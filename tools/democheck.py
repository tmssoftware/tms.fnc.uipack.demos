"""democheck.py - compile FNC demo projects, run them themed on the hidden desktop, check contrast.

Subcommands
  compile  <project>...  compile for the requested platforms (Win32/Win64 link; macOS/iOS/Android
                         compile the project's units without linking). Exit 1 when one fails.
  shoot    <project>...  build Win32 with tools/delphi/DemoShot.pas linked in, run it on the hidden
                         desktop (harness tools/hidden_desktop.py) with each mode (as shipped, no
                         theme, a TTMSFNCThemeManager injected with 'Fluent Light' / 'Fluent Dark'),
                         save <mode>.png + <mode>.json and analyse the contrast of every visible
                         text-bearing control (PIL). Writes <out>/<tag>/<demo>/summary.json.
  sheet                  contact sheet of a results folder: one row per demo, columns per tag/mode.

A project is a .dproj or .dpr (FMX/VCL is detected from the .dpr) or a WEB .dproj (compile only,
TMS WEB Core). Theming sources: --core / --uipack (default: the theming worktrees). Heavy runs go
through the harness tools/heavy.py; this script only throttles test processes through
hidden_desktop.

Examples (from the demos repository root):
  python -I tools/democheck.py compile FMX/Calendar/Demo.dproj --platforms win32 win64 osx64 android64
  python -I tools/democheck.py shoot FMX/Calendar/Demo.dproj VCL/Calendar/Demo.dproj --tag after
  python -I tools/democheck.py sheet --tags before after
"""

import argparse
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPO = HERE.parent
WORKSPACE = Path(os.environ.get("THEMING_WORKSPACE", "E:/Delphi"))
HARNESS = WORKSPACE / "tms.fnc.uipack-theming" / "Extras" / "UnitTesting" / "TMS FNC Theming"
STUDIO = Path(r"C:\Program Files (x86)\Embarcadero\Studio")
DELPHI = {"13": "37.0", "12": "23.0"}
WEBCORE = WORKSPACE / "TMS Smart Setup Install" / "Products" / "tms.webcore"
BELOW_NORMAL = 0x00004000
NO_WINDOW = 0x08000000

NS_COMMON = "System;Xml;Data;Datasnap;Web;Soap"
COMPILERS = {
    # platform: (compiler, extra namespaces, link)
    "win32": ("dcc32", "Winapi;System.Win;Data.Win;Datasnap.Win;Web.Win;Soap.Win;Xml.Win", True),
    "win64": ("dcc64", "Winapi;System.Win;Data.Win;Datasnap.Win;Web.Win;Soap.Win;Xml.Win", True),
    "osx64": ("dccosx64", "Macapi;Posix", False),
    "osxarm64": ("dccosxarm64", "Macapi;Posix", False),
    "iosarm64": ("dcciosarm64", "iOSapi;Macapi;Posix", False),
    "android64": ("dccaarm64", "Androidapi;Posix", False),
}
FW_NS = {"fmx": "FMX", "vcl": "Vcl;Vcl.Imaging;Vcl.Touch;Vcl.Samples;Vcl.Shell"}
MODES = ["asis", "none", "Fluent Light", "Fluent Dark"]
TEXT_CLASSES = re.compile(r"(Label|HTMLText|CheckBox|RadioButton|Button|Edit|ComboBox|GroupBox|Switch|Memo|ListBox|"
                          r"StatusBar|TabSet|SegmentedControl|ThemeSelector|Selector|Picker)$", re.I)


def pil():
    """Pillow, also from the user site (python -I leaves it out)."""
    try:
        import PIL  # noqa: F401
    except ImportError:
        import site
        sys.path.append(site.getusersitepackages())
    from PIL import Image, ImageDraw, ImageFont
    return Image, ImageDraw, ImageFont


def work_root(args):
    w = Path(args.work) if getattr(args, "work", None) else Path(tempfile.gettempdir()) / "claude" / "democheck"
    w.mkdir(parents=True, exist_ok=True)
    return w


def run(cmd, log, cwd=None, timeout=1800):
    with open(log, "w", encoding="utf-8", errors="replace") as f:
        return subprocess.run([str(c) for c in cmd], cwd=cwd, stdout=f, stderr=subprocess.STDOUT,
                              stdin=subprocess.DEVNULL, timeout=timeout,
                              creationflags=BELOW_NORMAL | NO_WINDOW).returncode


def errors_of(log, limit=12):
    text = Path(log).read_text(encoding="utf-8", errors="replace")
    return [l.strip() for l in text.splitlines() if re.search(r"\b(Error|Fatal)\b", l)][:limit]


# ---------------------------------------------------------------- projects

class Project:
    def __init__(self, path):
        p = Path(path)
        if not p.is_absolute():
            p = (Path.cwd() / p).resolve()
        if p.suffix.lower() == ".dproj":
            self.dproj = p
            self.dpr = p.with_suffix(".dpr")
        else:
            self.dpr = p
            self.dproj = p.with_suffix(".dproj")
        self.dir = self.dpr.parent
        self.text = self.dpr.read_text(encoding="utf-8-sig", errors="replace")
        dproj = self.dproj.read_text(encoding="utf-8-sig", errors="replace") if self.dproj.exists() else ""
        if re.search(r"\bWEBLib\.Forms\b", self.text) or "TMSWebProject" in dproj or "<FrameworkType>WEB" in dproj:
            self.fw = "web"
        elif re.search(r"\bFMX\.Forms\b", self.text):
            self.fw = "fmx"
        else:
            self.fw = "vcl"
        defs = set()
        for d in re.findall(r"<DCC_Define>([^<]*)</DCC_Define>", dproj):
            defs.update(x for x in d.split(";") if x and not x.startswith("$(") and x not in ("DEBUG", "RELEASE"))
        self.defines = sorted(defs)
        paths = []
        for d in re.findall(r"<DCC_UnitSearchPath>([^<]*)</DCC_UnitSearchPath>", dproj):
            for x in d.split(";"):
                if x and "$(" not in x:
                    q = (self.dir / x).resolve()
                    if q.is_dir():
                        paths.append(q)
        self.search = paths
        self.units = []  # (name, absolute path) of the dpr's "in" clauses
        for name, rel in re.findall(r"^\s*([\w.]+)\s+in\s+'([^']+)'", self.text, re.M):
            self.units.append((name, (self.dir / rel).resolve()))

    @property
    def slug(self):
        try:
            rel = self.dir.relative_to(find_root(self.dir))
        except ValueError:
            rel = Path(self.dir.name)
        parts = [x for x in rel.parts]
        if parts and parts[0].upper() in ("FMX", "VCL", "WEB", "LCL"):
            parts = parts[1:]
        s = "-".join(parts) or self.dpr.stem
        if self.dpr.stem.lower() not in ("demo",) and self.dpr.stem.lower() not in s.lower().replace("-", "").replace(" ", ""):
            s += "-" + self.dpr.stem
        return re.sub(r"[^A-Za-z0-9]+", "-", s).strip("-").lower()

    def unit_dirs(self):
        dirs = [self.dir] + self.search
        for _, p in self.units:
            if p.parent not in dirs:
                dirs.append(p.parent)
        return dirs


def find_root(d):
    d = Path(d)
    for p in [d, *d.parents]:
        if (p / ".git").exists():
            return p
    return d.anchor and Path(d.anchor)


def sources(args):
    """Overlay folders first (patched copies of product units, e.g. to get past a product bug on
    one platform), then the Core and UI Pack sources."""
    return [Path(p) for p in (getattr(args, "overlay", None) or [])] + [Path(args.core) / "Source", Path(args.uipack) / "Source",
                                                                          Path(args.uipack) / "Source" / "xlsAdapter"]


def scratch_dpr(proj, out, extra_units=()):
    """A copy of the .dpr in <out> with absolute unit paths (and extra units appended)."""
    text = proj.text

    def fix(m):
        q = (proj.dir / m.group(2)).resolve()
        return f"{m.group(1)} in '{q}'"
    text = re.sub(r"([\w.]+)\s+in\s+'([^']+)'", fix, text)
    if extra_units:
        m = re.search(r"\buses\b(.*?);", text, re.S | re.I)
        add = "".join(f",\n  {n} in '{p}'" for n, p in extra_units)
        text = text[:m.end() - 1] + add + text[m.end() - 1:]
    res = proj.dpr.with_suffix(".res")
    dst = out / proj.dpr.name
    dst.write_text(text, encoding="utf-8")
    if res.exists():
        shutil.copy2(res, out / res.name)
    elif "{$R *.res}" in text:
        make_empty_res(out / (proj.dpr.stem + ".res"), out)
    return dst


def make_empty_res(path, out, delphi="13"):
    rc = out / "empty.rc"
    rc.write_text("", encoding="ascii")
    run([STUDIO / DELPHI[delphi] / "bin" / "brcc32.exe", "-fo" + str(path), rc], out / "brcc32.log")


def dcu_cache(args, delphi, fw, platform):
    d = work_root(args) / "dcu-cache" / (f"d{delphi}-{fw}-{platform}" + ("-overlay" if getattr(args, "overlay", None) else ""))
    d.mkdir(parents=True, exist_ok=True)
    return d


def harvest(dcu_dir, cache):
    """Moves the FNC DCUs a build compiled into the shared cache (demo units stay)."""
    for f in Path(dcu_dir).glob("*.dcu"):
        if "TMSFNC" in f.name.upper():
            dst = cache / f.name
            try:
                if dst.exists():
                    dst.unlink()
                shutil.move(str(f), str(dst))
            except OSError:
                pass


def build_native(args, proj, platform, delphi="13", defines=(), extra_units=(), tag="build"):
    comp, ns, link = COMPILERS[platform]
    exe = STUDIO / DELPHI[delphi] / "bin" / f"{comp}.exe"
    if not exe.exists():
        return {"ok": None, "detail": f"{comp} not installed"}
    out = work_root(args) / tag / proj.fw / proj.slug / f"d{delphi}-{platform}"
    if out.exists():
        shutil.rmtree(out, ignore_errors=True)
    (out / "dcu").mkdir(parents=True, exist_ok=True)
    cache = dcu_cache(args, delphi, proj.fw, platform)
    src = sources(args)
    search = ";".join(str(x) for x in [cache, *proj.unit_dirs(), *src, *[Path(p).parent for _, p in extra_units]])
    inc = ";".join(str(x) for x in src)
    namespaces = f"{NS_COMMON};{FW_NS[proj.fw]};{ns}"
    d = ";".join(list(proj.defines) + list(defines))
    if link:
        target = scratch_dpr(proj, out, extra_units)
        cmd = [exe, "-Q", f"-NS{namespaces}", f"-U{search}", f"-I{inc}", f"-R{search};{out}", f"-NU{out / 'dcu'}",
               f"-E{out}", f"-D{d}" if d else "-D_", target]
    else:
        # cross platforms: compile the project's units (no SDK needed, nothing is linked)
        units = ", ".join(n for n, _ in proj.units) or proj.dpr.stem
        target = out / "XCheck.pas"
        target.write_text(f"unit XCheck;\n\ninterface\n\nuses\n  {units};\n\nimplementation\n\nend.\n", encoding="utf-8")
        cmd = [exe, "-Q", f"-NS{namespaces}", f"-U{search}", f"-I{inc}", f"-R{search}", f"-NU{out / 'dcu'}",
               f"-NO{out / 'dcu'}", f"-D{d}" if d else "-D_", target]
    log = out / "build.log"
    code = run(cmd, log, cwd=out)
    harvest(out / "dcu", cache)
    ok = code == 0 and (not link or (out / (proj.dpr.stem + ".exe")).exists())
    return {"ok": ok, "exit": code, "log": str(log), "errors": [] if ok else errors_of(log),
            "exe": str(out / (proj.dpr.stem + ".exe")) if link else None}


def build_web(args, proj, tag="build"):
    wc = WEBCORE
    comp = wc / "Bin" / "Win32" / "TMSWebCompiler.exe"
    if not comp.exists():
        return {"ok": None, "detail": "TMS WEB Core not installed"}
    out = work_root(args) / tag / "web" / proj.slug
    if out.exists():
        shutil.rmtree(out, ignore_errors=True)
    (out / "js").mkdir(parents=True, exist_ok=True)
    src = sources(args)
    search = ";".join(str(x) for x in [*proj.unit_dirs(), *src, wc / "Core Source", wc / "Core Source" / "RTL",
                                         wc / "Component Library Source"])
    cmd = [comp, f"-ProjectFile:{proj.dpr}", f"-InstallDir:{wc}", f"-HTMLOutputDir:{out / 'js'}",
           f"-IntermediateOutputDir:{out / 'js'}", f"-UnitSearchPaths:{search}",
           f"-IncSearchPaths:{';'.join(str(x) for x in src)}", "-ShowWarnings", "-ShowErrors", "-ShowLineNumbers"]
    if proj.defines:
        cmd.append("-Defines:" + ";".join(proj.defines))
    log = out / "build.log"
    code = run(cmd, log, cwd=out)
    errs = errors_of(log)
    return {"ok": code == 0 and not errs, "exit": code, "log": str(log), "errors": errs}


def cmd_compile(args):
    results, ok = {}, True
    for p in args.projects:
        proj = Project(p)
        key = f"{proj.fw}/{proj.slug}"
        results[key] = {}
        if proj.fw == "web":
            r = build_web(args, proj)
            results[key]["web"] = r
            ok &= r["ok"] is not False
            print(f"{key:40} web       {'ok' if r['ok'] else r.get('detail') or 'FAILED'} {' | '.join(r.get('errors', [])[:2])}")
            continue
        for delphi in args.delphi:
            for plat in args.platforms:
                if proj.fw == "vcl" and plat not in ("win32", "win64"):
                    continue
                r = build_native(args, proj, plat, delphi)
                results[key][f"d{delphi}-{plat}"] = r
                if r["ok"] is False:
                    ok = False
                state = "ok" if r["ok"] else (r.get("detail") or "FAILED")
                print(f"{key:40} d{delphi}-{plat:10} {state} {' | '.join(r.get('errors', [])[:2])}", flush=True)
    out = Path(args.out)
    out.mkdir(parents=True, exist_ok=True)
    name = f"compile-{args.tag}.json" if args.tag else "compile.json"
    prev = {}
    if (out / name).exists():
        prev = json.loads((out / name).read_text(encoding="utf-8"))
    prev.update(results)
    (out / name).write_text(json.dumps(prev, indent=1), encoding="utf-8")
    return 0 if ok else 1


# ---------------------------------------------------------------- shoot + contrast

def luminance(rgb):
    def ch(c):
        c = c / 255.0
        return c / 12.92 if c <= 0.03928 else ((c + 0.055) / 1.055) ** 2.4
    r, g, b = rgb[:3]
    return 0.2126 * ch(r) + 0.7152 * ch(g) + 0.0722 * ch(b)


def contrast(a, b):
    la, lb = luminance(a), luminance(b)
    hi, lo = max(la, lb), min(la, lb)
    return (hi + 0.05) / (lo + 0.05)


CAPTION_CLASSES = re.compile(r"(CheckBox|RadioButton)$", re.I)


def region_contrast(img, rect, caption=False):
    """(background, ink, ratio, ink share) of a control's rectangle: the most common colour is the
    background, the pixels farthest from it are the ink (text, glyphs). `caption`: a check box or radio
    button; the box/circle glyph (light on dark, always readable) would hide a black caption on a dark
    form, so the glyph column (22 px or the control height, whichever is larger) is left out and the
    ink threshold is lower."""
    x0, y0, x1, y1 = rect
    if caption:
        x0 += max(22, y1 - y0)
    x0, y0 = max(0, x0), max(0, y0)
    x1, y1 = min(img.width, x1), min(img.height, y1)
    if x1 - x0 < 10 or y1 - y0 < 10:
        return None
    crop = img.crop((x0 + 3, y0 + 3, x1 - 3, y1 - 3)).convert("RGB")  # inside the border
    if crop.width * crop.height > 400 * 120:
        crop = crop.resize((min(crop.width, 400), min(crop.height, 120)))
    px = list(crop.get_flattened_data() if hasattr(crop, "get_flattened_data") else crop.getdata())
    counts = {}
    for p in px:
        q = (p[0] >> 3, p[1] >> 3, p[2] >> 3)
        counts[q] = counts.get(q, 0) + 1
    bgq = max(counts, key=counts.get)
    bg = (bgq[0] * 8 + 4, bgq[1] * 8 + 4, bgq[2] * 8 + 4)
    dist = sorted(px, key=lambda p: -abs(luminance(p) - luminance(bg)))
    far = [p for p in dist if abs(p[0] - bg[0]) + abs(p[1] - bg[1]) + abs(p[2] - bg[2]) > (24 if caption else 60)]
    share = len(far) / max(1, len(px))
    if share < 0.004:
        return {"bg": bg, "ink": None, "ratio": None, "share": round(share, 4)}
    top = dist[: max(3, len(far) // 4)]
    ink = tuple(sorted(c[i] for c in top)[len(top) // 2] for i in range(3))
    return {"bg": bg, "ink": ink, "ratio": round(contrast(bg, ink), 2), "share": round(share, 4)}


def analyse(folder, mode_slug):
    Image, _, _ = pil()
    js = folder / f"{mode_slug}.json"
    png = folder / f"{mode_slug}.png"
    if not js.exists() or not png.exists():
        return None
    data = json.loads(js.read_text(encoding="utf-8-sig"))
    img = Image.open(png)
    flags, native, developer = [], [], {}
    for c in data.get("controls", []):
        if not c.get("visible"):
            continue
        if not c.get("fnc"):
            native.append(f"{c['name']}: {c['class']}")
        if c.get("developer"):
            developer[c["name"]] = c["developer"]
        if not TEXT_CLASSES.search(c["class"]):
            continue
        r = region_contrast(img, c["rect"], bool(CAPTION_CLASSES.search(c["class"])))
        if r and r["ratio"] is not None and r["ratio"] < 3.0:
            flags.append({"control": c["name"], "class": c["class"], "ratio": r["ratio"], "bg": r["bg"], "ink": r["ink"],
                          "rect": c["rect"]})
    # the whole form: a dark form with dark ink (or light/light) anywhere
    return {"theme": data.get("theme"), "size": [data.get("width"), data.get("height")], "low_contrast": flags,
            "native_visible": native, "developer_values": developer}


def slug(s):
    return re.sub(r"[^a-z0-9]+", "-", s.lower()).strip("-")


def cmd_shoot(args):
    sys.path.insert(0, str(HARNESS / "tools"))
    import hidden_desktop  # noqa: E402
    probe = HERE / "delphi" / "DemoShot.pas"
    results = {}
    rc = 0
    for p in args.projects:
        proj = Project(p)
        if proj.fw == "web":
            print(f"{proj.slug}: WEB projects are compiled only (compile)")
            continue
        key = f"{proj.fw}-{proj.slug}"
        dest = Path(args.out) / args.tag / key
        if dest.exists():
            shutil.rmtree(dest, ignore_errors=True)
        dest.mkdir(parents=True, exist_ok=True)
        b = build_native(args, proj, "win32", args.delphi[0], defines=[f"DEMOSHOT_{proj.fw.upper()}"],
                         extra_units=[("DemoShot", probe)], tag="shoot")
        if not b["ok"]:
            results[key] = {"build": "FAILED", "errors": b.get("errors")}
            print(f"{key}: build FAILED {' | '.join(b.get('errors', [])[:3])}")
            rc = 1
            continue
        env = dict(os.environ)
        env["DEMOSHOT_OUT"] = str(dest)
        env["DEMOSHOT_MODES"] = "|".join(args.modes)
        try:
            code = hidden_desktop.run([b["exe"]], timeout=args.timeout, env=env, cwd=str(proj.dir),
                                      stdout_path=str(dest / "stdout.txt"))
        except subprocess.TimeoutExpired:
            code = "timeout"
        summary = {"project": str(proj.dpr), "exit": code, "modes": {}}
        if (dest / "error.txt").exists():
            summary["error"] = (dest / "error.txt").read_text(encoding="utf-8", errors="replace")
        for m in args.modes:
            a = analyse(dest, slug(m))
            if a:
                summary["modes"][m] = a
        (dest / "summary.json").write_text(json.dumps(summary, indent=1), encoding="utf-8")
        low = {m: len(v["low_contrast"]) for m, v in summary["modes"].items()}
        nat = len(next(iter(summary["modes"].values()), {}).get("native_visible", [])) if summary["modes"] else "-"
        print(f"{key:44} exit={code} modes={len(summary['modes'])} low-contrast={low} native={nat}", flush=True)
        if not summary["modes"]:
            rc = 1
        results[key] = summary
    return rc


# ---------------------------------------------------------------- contact sheet

def cmd_sheet(args):
    Image, ImageDraw, ImageFont = pil()
    root = Path(args.out)
    cols = []  # (tag, mode)
    for tag in args.tags:
        for m in args.modes:
            cols.append((tag, m))
    demos = sorted({d.name for tag in args.tags if (root / tag).exists() for d in (root / tag).iterdir() if d.is_dir()})
    if args.only:
        demos = [d for d in demos if any(o in d for o in args.only)]
    W = args.width
    try:
        font = ImageFont.truetype("segoeui.ttf", 15)
        bold = ImageFont.truetype("segoeuib.ttf", 17)
    except OSError:
        font = bold = ImageFont.load_default()
    rows = []
    for d in demos:
        cells = []
        for tag, m in cols:
            f = root / tag / d / f"{slug(m)}.png"
            if f.exists():
                im = Image.open(f).convert("RGB")
                h = int(im.height * W / im.width)
                cells.append(im.resize((W, h)))
            else:
                cells.append(None)
        H = max([c.height for c in cells if c] or [80])
        rows.append((d, cells, H))
    pad, head = 8, 28
    sheet_w = pad + len(cols) * (W + pad)
    sheet_h = head + sum(H + head + pad for _, _, H in rows) + pad
    sheet = Image.new("RGB", (sheet_w, sheet_h), (250, 250, 250))
    dr = ImageDraw.Draw(sheet)
    for i, (tag, m) in enumerate(cols):
        dr.text((pad + i * (W + pad), 6), f"{tag} / {m}", fill=(40, 40, 40), font=bold)
    y = head
    for d, cells, H in rows:
        dr.text((pad, y + 4), d, fill=(0, 0, 0), font=bold)
        flagged = []
        for tag, m in cols:
            s = root / tag / d / "summary.json"
            if s.exists():
                md = json.loads(s.read_text(encoding="utf-8")).get("modes", {}).get(m)
                if md and md["low_contrast"]:
                    flagged.append(f"{tag}/{m}: {len(md['low_contrast'])} low-contrast")
        if flagged:
            dr.text((pad + 360, y + 6), "; ".join(flagged), fill=(190, 0, 0), font=font)
        y += head
        for i, c in enumerate(cells):
            x = pad + i * (W + pad)
            if c:
                sheet.paste(c, (x, y))
                dr.rectangle([x - 1, y - 1, x + c.width, y + c.height], outline=(200, 200, 200))
            else:
                dr.text((x + 8, y + 8), "(none)", fill=(150, 150, 150), font=font)
        y += H + pad
    out = root / (args.name or "contact-sheet.png")
    sheet.save(out)
    print(out)
    return 0


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--core", default=str(WORKSPACE / "tms.fnc.core-theming"))
    ap.add_argument("--uipack", default=str(WORKSPACE / "tms.fnc.uipack-theming"))
    ap.add_argument("--overlay", action="append", help="folders searched before the sources (patched product units)")
    ap.add_argument("--work", help="scratch build folder (default %%TEMP%%/claude/democheck)")
    ap.add_argument("--out", default=str(HARNESS / "results" / "demos-pilot"))
    sub = ap.add_subparsers(dest="cmd", required=True)
    c = sub.add_parser("compile")
    c.add_argument("projects", nargs="+")
    c.add_argument("--delphi", nargs="+", default=["13"])
    c.add_argument("--platforms", nargs="+", default=["win32", "win64"])
    c.add_argument("--tag", default="")
    s = sub.add_parser("shoot")
    s.add_argument("projects", nargs="+")
    s.add_argument("--delphi", nargs="+", default=["13"])
    s.add_argument("--tag", default="after")
    s.add_argument("--modes", nargs="+", default=MODES)
    s.add_argument("--timeout", type=int, default=120)
    h = sub.add_parser("sheet")
    h.add_argument("--tags", nargs="+", default=["before", "after"])
    h.add_argument("--modes", nargs="+", default=["asis", "Fluent Dark"])
    h.add_argument("--only", nargs="*")
    h.add_argument("--width", type=int, default=520)
    h.add_argument("--name")
    args = ap.parse_args()
    return {"compile": cmd_compile, "shoot": cmd_shoot, "sheet": cmd_sheet}[args.cmd](args)


if __name__ == "__main__":
    sys.exit(main())
