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
  smoke    <project>...  build Win32 with DemoShot.pas linked in and start the demo on the hidden desktop;
                         passes when the main form came up and the demo ended without an exception
                         (DemoShot hooks Application.OnException and writes error.txt). A demo kept
                         alive by an exception or message dialog (window class #32770) fails with the
                         dialog text. Exit 1 when one fails.
  click    <project>...  the click-through: build Win32 with DemoShot.pas, then per DPI (--ppi, default 96 120
                         144 192) start the demo on the hidden desktop with DPI emulation; first the demo's own
                         scenario (tools/scenarios/<demo slug>.txt, the syntax is in DemoShot.pas) when there is
                         one, the person-like sequence that reaches its states; then DemoShot clicks every
                         reachable control under Fluent Light (pop-ups and dialogs captured and closed), walks
                         the tab order, resizes, switches to Fluent Dark and opens the pop-ups again. Writes
                         <out>/click/<fw>-<demo>/<ppi>/click.json + PNGs and issues.json (exceptions, dialogs,
                         windows that did not close, controls outside their parent or overlapping, a stuck tab
                         order, a hang). Exit 1 when a run has an exception, a hang or a crash.
  clicksheet             one sheet per demo: light, dark and resized shots per DPI, the issues underneath.

A project is a .dproj or .dpr (FMX/VCL is detected from the .dpr) or a WEB .dproj (compile only,
TMS WEB Core). Theming sources: --core / --uipack (default: the theming worktrees); --extra adds the sources of
other products a demo needs. Shared form units with {$IFDEF} form classes are resolved for WEBLIB before the WEB
compile; a VCL/FMX project's <RcItem> resources become its .dres.

Machine locks (harness tools/heavy.py): every compiler call takes a compile slot and the runs of one demo
(shoot, smoke, the DPIs of a click-through) take the run lock, which is free again between two demos: a
batch of hours lets the runs of other agents in between. heavy.py starts this script without a lock of its own.

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
HEAVY_LOCKS_PER_STEP = True  # read by heavy.py: this script takes its slots per build and per demo

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


def heavy_slot(kind):
    """A compile slot ('compile') or the run lock ('run') of the harness tools/heavy.py for a with block. A slot
    a parent process holds (gate.py, heavy.py --run) is shared."""
    tools = str(HARNESS / "tools")
    if tools not in sys.path:
        sys.path.insert(0, tools)
    import heavy  # noqa: E402
    return heavy.slot(kind)


def run(cmd, log, cwd=None, timeout=1800):
    with heavy_slot("compile"), open(log, "w", encoding="utf-8", errors="replace") as f:
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
    extra = [Path(p) for p in (getattr(args, "extra", None) or [])]
    return [Path(p) for p in (getattr(args, "overlay", None) or [])] + [Path(args.core) / "Source", Path(args.uipack) / "Source",
                                                                          Path(args.uipack) / "Source" / "xlsAdapter"] + extra


def scratch_dpr(proj, out, extra_units=(), delphi="13"):
    """A copy of the .dpr in <out> with absolute unit paths (and extra units appended); the resources the IDE
    would link (manifest, resource items, VCL styles of the project) built with the tools of that Delphi."""
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
        make_empty_res(out / (proj.dpr.stem + ".res"), out, delphi)
    if "{$R *.dres}" in text:
        make_dres(proj, out, delphi)
    more = [name for name, made in (("manifest.res", make_manifest(out, delphi)),
                                    ("styles.res", make_styles(proj, out, delphi))) if made]
    if more:
        text = dst.read_text(encoding="utf-8")
        add = "".join("\n{$R %s}" % name for name in more)
        text = re.sub(r"(\{\$R \*\.res\})", lambda m: m.group(1) + add, text, count=1, flags=re.I)
        dst.write_text(text, encoding="utf-8")
    return dst


MANIFEST = """<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<assembly xmlns="urn:schemas-microsoft-com:asm.v1" manifestVersion="1.0">
  <dependency><dependentAssembly><assemblyIdentity type="win32" name="Microsoft.Windows.Common-Controls"
    version="6.0.0.0" processorArchitecture="*" publicKeyToken="6595b64144ccf1df" language="*"/></dependentAssembly></dependency>
  <compatibility xmlns="urn:schemas-microsoft-com:compatibility.v1"><application>
    <supportedOS Id="{8e0f7a12-bfb3-4fe8-b9a5-48fd50a15a9a}"/></application></compatibility>
  <application xmlns="urn:schemas-microsoft-com:asm.v3"><windowsSettings>
    <dpiAware xmlns="http://schemas.microsoft.com/SMI/2005/WindowsSettings">true/pm</dpiAware>
    <dpiAwareness xmlns="http://schemas.microsoft.com/SMI/2016/WindowsSettings">PerMonitorV2</dpiAwareness>
  </windowsSettings></application>
</assembly>
"""


def make_manifest(out, delphi="13"):
    """The IDE links a manifest (common controls 6, Windows 10, per monitor V2 as the demos' AppDPIAwarenessMode);
    the command line does not: without it VCL sees Windows 8 (no per monitor DPI) and native controls look classic."""
    (out / "demo.manifest").write_text(MANIFEST, encoding="utf-8")
    rc = out / "manifest.rc"
    rc.write_text('1 24 "demo.manifest"\n', encoding="ascii")
    run([STUDIO / DELPHI[delphi] / "bin" / "brcc32.exe", "-fo" + str(out / "manifest.res"), rc], out / "brcc32-manifest.log")
    return (out / "manifest.res").exists()


def make_empty_res(path, out, delphi="13"):
    rc = out / "empty.rc"
    rc.write_text("", encoding="ascii")
    run([STUDIO / DELPHI[delphi] / "bin" / "brcc32.exe", "-fo" + str(path), rc], out / "brcc32.log")


def expand_macros(text, delphi="13"):
    """A path of a project file with the IDE's $(BDS) and $(BDSCOMMONDIR) filled in for that Delphi."""
    public = Path(os.environ.get("PUBLIC", "C:/Users/Public")) / "Documents" / "Embarcadero" / "Studio" / DELPHI[delphi]
    for name, value in (("BDSCOMMONDIR", public), ("BDS", STUDIO / DELPHI[delphi])):
        text = re.sub(r"\$\(" + name + r"\)", lambda m: str(value), text, flags=re.I)
    return text


def make_styles(proj, out, delphi="13"):
    """The VCL styles of the project (Project > Options > Application > Appearance, <Custom_Styles> in the .dproj:
    "Name|VCLSTYLE|file" entries) as styles.res: the IDE links them, the command line does not. False without any."""
    dproj = proj.dproj.read_text(encoding="utf-8-sig", errors="replace") if proj.dproj.exists() else ""
    lines, seen = [], set()
    for value in re.findall(r"<Custom_Styles>([^<]*)</Custom_Styles>", dproj):
        for entry in value.replace("&quot;", "").replace('"', "").split(";"):
            parts = entry.split("|")
            if len(parts) != 3 or parts[0] in seen:
                continue
            path = Path(expand_macros(parts[2], delphi))
            if not path.is_absolute():
                path = (proj.dir / path).resolve()
            if path.exists():
                seen.add(parts[0])
                ident = re.sub(r"[^A-Za-z0-9]", "", parts[0]).upper()
                lines.append(f'{ident} {parts[1]} "{str(path).replace(chr(92), "/")}"')
    if not lines:
        return False
    rc = out / "styles.rc"
    rc.write_text("\n".join(lines) + "\n", encoding="ascii", errors="replace")
    run([STUDIO / DELPHI[delphi] / "bin" / "brcc32.exe", "-fo" + str(out / "styles.res"), rc], out / "brcc32-styles.log")
    return (out / "styles.res").exists()


def make_dres(proj, out, delphi="13"):
    """The IDE compiles the project's resource items (<RcItem> in the .dproj: SVGs, images) into <project>.dres;
    the command line does not, so the file is built here from the same items (or copied when the IDE left one)."""
    dres = proj.dpr.with_suffix(".dres")
    if dres.exists():
        shutil.copy2(dres, out / dres.name)
        return
    dproj = proj.dproj.read_text(encoding="utf-8-sig", errors="replace") if proj.dproj.exists() else ""
    lines = []
    for inc, body in re.findall(r'<RcItem Include="([^"]+)">(.*?)</RcItem>', dproj, re.S):
        rtype = re.search(r"<ResourceType>([^<]*)</ResourceType>", body)
        rid = re.search(r"<ResourceId>([^<]*)</ResourceId>", body)
        path = Path(expand_macros(inc, delphi))  # a file of the IDE: $(BDS)\Redist\styles\...
        if not path.is_absolute():
            path = (proj.dir / path).resolve()
        if rtype and rid and path.exists():
            lines.append(f'{rid.group(1)} {rtype.group(1)} "{str(path).replace(chr(92), "/")}"')
    rc = out / "resources.rc"
    rc.write_text("\n".join(lines) + "\n", encoding="ascii", errors="replace")
    run([STUDIO / DELPHI[delphi] / "bin" / "brcc32.exe", "-fo" + str(out / dres.name), rc], out / "brcc32-dres.log")


# conditional symbols the WEB compiler defines, and the ones of the other frameworks it never defines; a shared form
# unit resolved for these before TMS WEB Core's preprocessor sees it, so it finds the one form class declaration
WEB_DEFINED = {"WEBLIB", "PAS2JS"}
WEB_UNDEFINED = {"FMX", "VCL", "LCL", "LCLLIB", "MSWINDOWS", "WIN32", "WIN64", "MACOS", "IOS", "ANDROID", "LINUX",
                 "POSIX", "CPUX64", "CPUX86", "CPUARM64"}


def resolve_conditionals(text, defined=WEB_DEFINED, undefined=WEB_UNDEFINED):
    """Removes the inactive branches of {$IFDEF}/{$IFNDEF}/{$ELSE}/{$ENDIF} blocks whose symbol is known; other
    directives (and blocks nested in them) stay for the compiler."""
    pattern = re.compile(r"\{\$(IFDEF|IFNDEF|IFOPT|IF|ELSEIF|ELSE|ENDIF|IFEND)\b([^}]*)\}", re.I)
    out, pos = [], 0
    stack = []  # (resolved, active before this block, active in the current branch)
    emit = True
    for m in pattern.finditer(text):
        kind, arg = m.group(1).upper(), m.group(2).strip().upper()
        if emit:
            out.append(text[pos:m.start()])
        pos = m.end()
        if kind in ("IFDEF", "IFNDEF") and arg in defined | undefined:
            on = (arg in defined) == (kind == "IFDEF")
            stack.append((True, emit, on))
            emit = emit and on
            continue
        if kind in ("IFDEF", "IFNDEF", "IFOPT", "IF"):
            stack.append((False, emit, True))
        elif kind in ("ELSE", "ELSEIF") and stack and stack[-1][0]:
            resolved, before, on = stack[-1]
            stack[-1] = (resolved, before, not on)
            emit = before and not on
            continue
        elif kind in ("ENDIF", "IFEND") and stack:
            resolved, before, _ = stack.pop()
            if resolved:
                emit = before
                continue
        if emit:
            out.append(m.group(0))
    out.append(text[pos:])
    return "".join(out)


def scratch_web_project(proj, out):
    """A copy of a WEB project in <out>/src whose shared form units are resolved for WEBLIB (TMS WEB Core's
    preprocessor matches the form class by name, and a unit that declares it once per framework under {$IFDEF}
    makes it inject LoadDFMValues into the wrong declaration); the form files and the page template come along."""
    src = out / "src"
    src.mkdir(parents=True, exist_ok=True)
    text = proj.text
    for name, path in proj.units:
        unit = path.read_text(encoding="utf-8-sig", errors="replace")
        if not re.search(r"\{\$IF(N?DEF)?\b", unit, re.I):
            continue
        (src / path.name).write_text(resolve_conditionals(unit), encoding="utf-8")
        for sib in path.parent.glob(path.stem + ".*"):
            if sib.suffix.lower() in (".dfm", ".html"):
                shutil.copy2(sib, src / sib.name)
        text = re.sub(r"(\b" + re.escape(name) + r"\s+in\s+')[^']+'", lambda m: m.group(1) + str(src / path.name) + "'", text)

    def fix(m):
        q = Path(m.group(2))
        return m.group(0) if q.is_absolute() else f"{m.group(1)} in '{(proj.dir / q).resolve()}'"
    text = re.sub(r"([\w.]+)\s+in\s+'([^']+)'", fix, text)
    dst = src / proj.dpr.name
    dst.write_text(text, encoding="utf-8")
    for f in proj.dir.iterdir():
        if f.is_file() and f.suffix.lower() in (".html", ".dproj", ".res", ".css", ".js", ".json"):
            shutil.copy2(f, src / f.name)
    return dst, src


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
        target = scratch_dpr(proj, out, extra_units, delphi)
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
    dpr, scratch = scratch_web_project(proj, out)
    search = ";".join(str(x) for x in [scratch, *proj.unit_dirs(), *src, wc / "Core Source", wc / "Core Source" / "RTL",
                                         wc / "Component Library Source"])
    cmd = [comp, f"-ProjectFile:{dpr}", f"-InstallDir:{wc}", f"-HTMLOutputDir:{out / 'js'}",
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
            with heavy_slot("run"):
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


# ---------------------------------------------------------------- dialogs + smoke start

def find_dialog(pid, desktop_name):
    """The caption and texts of a dialog (window class #32770) of the process on the hidden desktop, or None."""
    import ctypes
    from ctypes import wintypes
    user32 = ctypes.WinDLL("user32", use_last_error=True)
    proc = ctypes.WINFUNCTYPE(wintypes.BOOL, wintypes.HWND, wintypes.LPARAM)
    found = []

    def text(hwnd):
        buf = ctypes.create_unicode_buffer(1024)
        user32.GetWindowTextW(hwnd, buf, 1024)
        return buf.value

    def cls(hwnd):
        buf = ctypes.create_unicode_buffer(256)
        user32.GetClassNameW(hwnd, buf, 256)
        return buf.value

    def child(hwnd, _):
        if cls(hwnd) in ("Static", "Edit", "RichEdit20W", "SysLink"):
            s = text(hwnd).strip()
            if s:
                found[-1]["texts"].append(s)
        return True

    def top(hwnd, _):
        owner = wintypes.DWORD()
        user32.GetWindowThreadProcessId(hwnd, ctypes.byref(owner))
        if owner.value == pid and cls(hwnd) == "#32770":
            found.append({"caption": text(hwnd), "texts": []})
            user32.EnumChildWindows(hwnd, proc(child), 0)
        return True

    desk = user32.OpenDesktopW(desktop_name, 0, False, 0x0100)  # DESKTOP_ENUMERATE
    if not desk:
        return None
    try:
        user32.EnumDesktopWindows(desk, proc(top), 0)
    finally:
        user32.CloseDesktop(desk)
    if not found:
        return None
    d = found[0]
    return " | ".join([d["caption"], *d["texts"]]).strip(" |")


def watch_process(p, hidden_desktop, timeout, settle=0.5):
    """Waits for a hidden desktop process; ends it when a dialog appears or the time is up.
    Returns (exit code or None while alive, dialog text or None)."""
    import time
    deadline = time.monotonic() + timeout
    while True:
        try:
            return p.wait(timeout=settle), None
        except subprocess.TimeoutExpired:
            pass
        dialog = find_dialog(p.pid, hidden_desktop.DESKTOP_NAME)
        if dialog is not None:
            p.kill()
            return None, dialog
        if time.monotonic() >= deadline:
            return None, None


def cmd_smoke(args):
    sys.path.insert(0, str(HARNESS / "tools"))
    import hidden_desktop  # noqa: E402
    probe = HERE / "delphi" / "DemoShot.pas"
    rc = 0
    for p in args.projects:
        proj = Project(p)
        if proj.fw == "web":
            print(f"{proj.slug}: WEB projects are compiled only (compile)")
            continue
        key = f"{proj.fw}-{proj.slug}"
        dest = Path(args.out) / "smoke" / key
        if dest.exists():
            shutil.rmtree(dest, ignore_errors=True)
        dest.mkdir(parents=True, exist_ok=True)
        b = build_native(args, proj, "win32", args.delphi[0], defines=[f"DEMOSHOT_{proj.fw.upper()}"],
                         extra_units=[("DemoShot", probe)], tag="smoke")
        if not b["ok"]:
            print(f"{key:44} build FAILED {' | '.join(b.get('errors', [])[:3])}")
            rc = 1
            continue
        env = dict(os.environ)
        env["DEMOSHOT_OUT"] = str(dest)
        env["DEMOSHOT_MODES"] = "smoke"
        env["DEMOSHOT_DELAY"] = str(args.delay)
        with heavy_slot("run"):
            proc = hidden_desktop.start([b["exe"]], env=env, cwd=str(proj.dir), stdout_path=str(dest / "stdout.txt"))
            code, dialog = watch_process(proc, hidden_desktop, args.timeout)
            if code is None and not dialog:
                proc.kill()  # still running: ended before the run lock is given back
        error = (dest / "error.txt").read_text(encoding="utf-8", errors="replace").strip() if (dest / "error.txt").exists() else ""
        if dialog:
            state = f"FAILED dialog: {dialog}"
        elif code is None:
            state = "FAILED still running (no main form or a blocked message loop)"
        elif error:
            state = f"FAILED exception: {error}"
        elif code != 0 or not (dest / "done.txt").exists():
            state = f"FAILED exit {code}"
        else:
            state = "ok"
        if state != "ok":
            rc = 1
        (dest / "result.txt").write_text(state, encoding="utf-8")
        print(f"{key:44} {state}", flush=True)
    return rc


# ---------------------------------------------------------------- click-through

def click_issues(data):
    """The findings of one click.json: (severity, text)."""
    out = []
    for s in data.get("steps", []):
        what = f"{s.get('class')} {s.get('name') or ''} \"{s.get('text') or ''}\"".strip()
        for e in s.get("exceptions", []):
            out.append(("error", f"exception while using {what}: {e}"))
        if s.get("missing"):
            out.append(("warn", f"scenario target not found: {s['missing']}"))
        if s.get("driverError"):
            out.append(("warn", f"driver error at {what}: {s['driverError']}"))
        for ph in [s] + s.get("phases", []):
            act = ph.get("act", "modal")
            for w in ph.get("windows", []):
                if w.get("class") == "#32770":
                    out.append(("info", f"dialog after {act} on {what}: {w.get('text')}"))
            for w in ph.get("notClosed", []):
                out.append(("warn", f"window did not close after {act} on {what}: {w.get('class')} {w.get('text')}"))
    for g in ("geometryLight", "geometrySmall", "geometryDark"):
        seen = set()
        for e in data.get(g, []):
            k = (e.get("issue"), e.get("control"), e.get("other"))
            if k in seen:
                continue
            seen.add(k)
            sev = "info" if e.get("issue") == "overlap" or g == "geometrySmall" else "warn"
            out.append((sev, f"{g[8:].lower()}: {e.get('issue')}: {e.get('control')}"
                             + (f" / {e.get('other')}" if e.get("other") else "") + f" in {e.get('parent', 'form')}"))
    focus = [f for f in data.get("focus", []) if f]
    if len(set(focus)) <= 1 and len(data.get("focus", [])) > 3:
        out.append(("warn", f"tab key does not move the focus ({focus[0] if focus else 'nothing focused'})"))
    for s in data.get("shell", []):
        out.append(("info", f"shell execute: {s}"))
    return out


def click_one(hidden_desktop, exe, proj, dest, ppi, timeout, maxsteps):
    import time
    if dest.exists():
        shutil.rmtree(dest, ignore_errors=True)
    dest.mkdir(parents=True, exist_ok=True)
    env = dict(os.environ)
    env["DEMOSHOT_OUT"] = str(dest)
    env["DEMOSHOT_MODES"] = "click"
    env["DEMOSHOT_PPI"] = str(ppi)
    env["DEMOSHOT_MAXSTEPS"] = str(maxsteps)
    scenario = HERE / "scenarios" / f"{proj.slug}.txt"
    if scenario.exists():
        env["DEMOSHOT_SCENARIO"] = str(scenario)
    proc = hidden_desktop.start([exe], env=env, cwd=str(proj.dir), stdout_path=str(dest / "stdout.txt"))
    deadline = time.monotonic() + timeout
    code = None
    while time.monotonic() < deadline:
        try:
            code = proc.wait(timeout=1)
            break
        except subprocess.TimeoutExpired:
            pass
    issues = []
    if code is None:
        dialog = find_dialog(proc.pid, hidden_desktop.DESKTOP_NAME)
        proc.kill()
        issues.append(("error", "hang" + (f" with dialog: {dialog}" if dialog else " (no dialog)")))
    error = (dest / "error.txt").read_text(encoding="utf-8-sig", errors="replace").strip() if (dest / "error.txt").exists() else ""
    if error:
        issues.append(("error", f"ended with: {error}"))
    if (dest / "exceptions.txt").exists():
        for line in (dest / "exceptions.txt").read_text(encoding="utf-8-sig", errors="replace").splitlines():
            issues.append(("error", f"exception outside a step: {line}"))
    data = {}
    if (dest / "click.json").exists():
        data = json.loads((dest / "click.json").read_text(encoding="utf-8-sig"))
        issues += click_issues(data)
    elif code is not None:
        issues.append(("error", f"no click.json (exit {code})"))
    summary = {"ppi": ppi, "exit": code, "steps": len(data.get("steps", [])),
               "size": [data.get("width"), data.get("height")], "issues": issues}
    (dest / "issues.json").write_text(json.dumps(summary, indent=1), encoding="utf-8")
    return summary


def cmd_click(args):
    sys.path.insert(0, str(HARNESS / "tools"))
    import hidden_desktop  # noqa: E402
    from concurrent.futures import ThreadPoolExecutor
    probe = HERE / "delphi" / "DemoShot.pas"
    rc = 0
    for p in args.projects:
        proj = Project(p)
        if proj.fw == "web":
            continue
        key = f"{proj.fw}-{proj.slug}"
        b = build_native(args, proj, "win32", args.delphi[0], defines=[f"DEMOSHOT_{proj.fw.upper()}"],
                         extra_units=[("DemoShot", probe)], tag="click")
        if not b["ok"]:
            print(f"{key:44} build FAILED {' | '.join(b.get('errors', [])[:3])}", flush=True)
            rc = 1
            continue

        def go(ppi, key=key, proj=proj, exe=b["exe"]):
            return ppi, click_one(hidden_desktop, exe, proj, Path(args.out) / "click" / key / str(ppi), ppi,
                                  args.timeout, args.maxsteps)

        # the run lock per demo: free again between two demos of a long list
        with heavy_slot("run"), ThreadPoolExecutor(max_workers=args.jobs) as ex:
            for ppi, s in ex.map(go, args.ppi):
                errs = [t for sev, t in s["issues"] if sev == "error"]
                warns = [t for sev, t in s["issues"] if sev == "warn"]
                if errs:
                    rc = 1
                print(f"{key:40} {ppi:>3} steps={s['steps']:<3} errors={len(errs)} warnings={len(warns)}"
                      + (f"  {errs[0][:150]}" if errs else ""), flush=True)
    return rc


def cmd_stepsheet(args):
    """Every step shot of one DPI as labelled thumbnails, pages of --per shots: what a person saw after each action."""
    Image, ImageDraw, ImageFont = pil()
    root = Path(args.out) / "click"
    try:
        font = ImageFont.truetype("segoeui.ttf", 13)
    except OSError:
        font = ImageFont.load_default()
    demos = sorted(d for d in root.iterdir() if d.is_dir()) if root.exists() else []
    if args.only:
        demos = [d for d in demos if any(o.lower() in d.name for o in args.only)]
    for d in demos:
        run_dir = d / str(args.ppi)
        f = run_dir / "click.json"
        if not f.exists():
            continue
        data = json.loads(f.read_text(encoding="utf-8-sig"))
        shots = []
        for n, s in enumerate(data.get("steps", []), 1):
            what = f"{n} {s.get('class', '')[7:] if s.get('class', '').startswith('TTMSFNC') else s.get('class')} {s.get('text', '')}"
            for ph in s.get("phases", []):
                if ph.get("shot"):
                    flag = " [win]" if ph.get("windows") else ""
                    shots.append((ph["shot"], f"{what[:34]} | {ph.get('act')}{flag}"))
            if s.get("exceptions"):
                shots.append((None, f"{what[:34]} | EXCEPTION {s['exceptions'][0][:60]}"))
        W, cols = args.width, 4
        for page in range(0, len(shots), args.per):
            part = shots[page:page + args.per]
            cells = []
            for shot, label in part:
                im = None
                if shot and (run_dir / f"{shot}.png").exists():
                    im = Image.open(run_dir / f"{shot}.png").convert("RGB")
                    im = im.resize((W, max(1, int(im.height * W / im.width))))
                cells.append((im, label))
            ch = max([c.height for c, _ in cells if c] or [80]) + 20
            rows = (len(cells) + cols - 1) // cols
            sheet = Image.new("RGB", (cols * (W + 6) + 6, rows * (ch + 6) + 6), (255, 255, 255))
            dr = ImageDraw.Draw(sheet)
            for i, (im, label) in enumerate(cells):
                x, y = 6 + (i % cols) * (W + 6), 6 + (i // cols) * (ch + 6)
                dr.text((x, y), label, fill=(170, 0, 0) if "EXCEPTION" in label else (0, 0, 0), font=font)
                if im:
                    sheet.paste(im, (x, y + 18))
            out = root / f"{d.name}-{args.ppi}-steps-{page // args.per + 1}.png"
            sheet.save(out)
            print(out)
    return 0


def cmd_clicksheet(args):
    Image, ImageDraw, ImageFont = pil()
    root = Path(args.out) / "click"
    demos = sorted(d for d in root.iterdir() if d.is_dir()) if root.exists() else []
    if args.only:
        demos = [d for d in demos if any(o.lower() in d.name for o in args.only)]
    try:
        font = ImageFont.truetype("segoeui.ttf", 14)
        bold = ImageFont.truetype("segoeuib.ttf", 16)
    except OSError:
        font = bold = ImageFont.load_default()
    W = args.width
    for d in demos:
        ppis = sorted((x for x in d.iterdir() if x.is_dir() and x.name.isdigit()), key=lambda x: int(x.name))
        rows, notes = [], []
        for pdir in ppis:
            cells = []
            for name in ("light", "dark", "small"):
                f = pdir / f"{name}.png"
                if f.exists():
                    im = Image.open(f).convert("RGB")
                    cells.append(im.resize((W, max(1, int(im.height * W / im.width)))))
                else:
                    cells.append(None)
            rows.append((pdir.name, cells))
            s = pdir / "issues.json"
            if s.exists():
                for sev, text in json.loads(s.read_text(encoding="utf-8")).get("issues", []):
                    if sev != "info":
                        notes.append(f"{pdir.name}: {sev}: {text}")
        if not rows:
            continue
        H = [max([c.height for c in cells if c] or [60]) for _, cells in rows]
        notes = notes[:40]
        pad, head = 8, 24
        sw = pad + 3 * (W + pad)
        sh = head + sum(h + head + pad for h in H) + 18 * len(notes) + pad * 2
        sheet = Image.new("RGB", (sw, sh), (250, 250, 250))
        dr = ImageDraw.Draw(sheet)
        dr.text((pad, 4), d.name + "   (light / dark / resized to 80 %)", fill=(0, 0, 0), font=bold)
        y = head
        for (ppi, cells), h in zip(rows, H):
            dr.text((pad, y + 2), f"{ppi} dpi", fill=(60, 60, 60), font=bold)
            y += head
            for i, c in enumerate(cells):
                if c:
                    sheet.paste(c, (pad + i * (W + pad), y))
            y += h + pad
        for n in notes:
            dr.text((pad, y), n[:220], fill=(170, 0, 0) if ": error:" in n else (120, 80, 0), font=font)
            y += 18
        out = root / f"{d.name}.png"
        sheet.save(out)
        print(out)
    return 0


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
    ap.add_argument("--extra", action="append", help="more source folders (other FNC products a demo uses, e.g. the "
                    "Dashboard Pack gauge of PDFLib BMI)")
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
    k = sub.add_parser("smoke")
    k.add_argument("projects", nargs="+")
    k.add_argument("--delphi", nargs="+", default=["13"])
    k.add_argument("--timeout", type=int, default=30)
    k.add_argument("--delay", type=int, default=2500, help="ms after the main form is up before the demo ends")
    q = sub.add_parser("click")
    q.add_argument("projects", nargs="+")
    q.add_argument("--delphi", nargs="+", default=["13"])
    q.add_argument("--ppi", nargs="+", type=int, default=[96, 120, 144, 192])
    q.add_argument("--timeout", type=int, default=240)
    q.add_argument("--maxsteps", type=int, default=70)
    q.add_argument("--jobs", type=int, default=2)
    r = sub.add_parser("clicksheet")
    r.add_argument("--only", nargs="*")
    r.add_argument("--width", type=int, default=560)
    st = sub.add_parser("stepsheet")
    st.add_argument("--only", nargs="*")
    st.add_argument("--ppi", type=int, default=144)
    st.add_argument("--per", type=int, default=24)
    st.add_argument("--width", type=int, default=480)
    h = sub.add_parser("sheet")
    h.add_argument("--tags", nargs="+", default=["before", "after"])
    h.add_argument("--modes", nargs="+", default=["asis", "Fluent Dark"])
    h.add_argument("--only", nargs="*")
    h.add_argument("--width", type=int, default=520)
    h.add_argument("--name")
    args = ap.parse_args()
    return {"compile": cmd_compile, "shoot": cmd_shoot, "smoke": cmd_smoke, "sheet": cmd_sheet,
            "click": cmd_click, "clicksheet": cmd_clicksheet,
            "stepsheet": cmd_stepsheet}[args.cmd](args)


if __name__ == "__main__":
    sys.exit(main())
