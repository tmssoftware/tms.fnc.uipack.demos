"""demoscan.py - scan demo forms for what keeps a TTMSFNCThemeManager from theming them.

For every form (.fmx, .dfm, .lfm) under the given folders it lists
  * native controls (TLabel, TButton, TPanel, ...): the theme does not reach them; each with the
    FNC replacement democonvert.py can make (or 'manual');
  * colour properties of FNC controls, classified:
      default    equal to the class's run-time default: removable, nothing changes
      theme      the theme owns the value (not a developer value under a theme): removable,
                 only the look without a theme changes
      developer  the theme leaves it (TTMSFNCTheme.DeveloperValues): a hard-coded colour that
                 survives Light/Dark switches -> remove, or exempt it when the demo is about colour
      exempt     listed in a `demo-colors:` comment of the form unit (intentional colour)
      unknown    no run-time data (run democheck.py shoot first) - a colour other than a null colour
  * colours of native controls and of the form itself;
  * whether the form has a TTMSFNCThemeManager (and its Theme).

The classes 'default'/'theme'/'developer' need the run-time data democheck.py shoot wrote
(<results>/<tag>/<fw>-<demo>/defaults.json and fluent-light.json); without it the scanner only
separates null colours from the rest.

Exemptions: a comment in the form unit (.pas) such as
  { demo-colors: TMSFNCPlanner1, ColorPanel.Fill.Color }
marks those controls (or single properties) as intentional colours.

Usage:
  python -I tools/demoscan.py <folder or form>... [--results DIR] [--tag after] [--json out.json] [--brief]
"""

import argparse
import json
import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import formfile  # noqa: E402
import democheck  # noqa: E402

# native control -> FNC replacement made by democonvert.py ('' = manual, None = leave: layout only)
NATIVE = {
    "fmx": {
        "TLabel": "TTMSFNCHTMLText", "TButton": "TTMSFNCButton", "TSpeedButton": "TTMSFNCButton",
        "TCheckBox": "TTMSFNCCheckBox", "TRadioButton": "TTMSFNCRadioButton", "TEdit": "TTMSFNCEdit",
        "TPanel": "TTMSFNCPanel", "TGroupBox": "TTMSFNCPanel", "TComboBox": "TTMSFNCComboBox",
        "TTrackBar": "", "TListBox": "", "TMemo": "", "TSwitch": "", "TSpinBox": "", "TNumberBox": "",
        "TRectangle": "", "TRoundRect": "", "TLine": "", "TCalloutPanel": "", "TTabControl": "",
        "TStatusBar": "", "TToolBar": "", "TImage": None, "TLayout": None, "TScrollBox": None,
        "TVertScrollBox": None, "THorzScrollBox": None, "TSplitter": None, "TGridPanelLayout": None,
        "TFlowLayout": None, "TListView": "", "TStringGrid": "", "TComboEdit": "", "TDateEdit": "",
        "TProgressBar": "", "TArcDial": "", "TExpander": "", "TColorComboBox": "", "TText": "",
    },
    "vcl": {
        "TLabel": "TTMSFNCHTMLText", "TButton": "TTMSFNCButton", "TBitBtn": "TTMSFNCButton",
        "TSpeedButton": "TTMSFNCButton", "TCheckBox": "TTMSFNCCheckBox", "TRadioButton": "TTMSFNCRadioButton",
        "TEdit": "TTMSFNCEdit", "TPanel": "TTMSFNCPanel", "TGroupBox": "TTMSFNCPanel",
        "TComboBox": "TTMSFNCComboBox", "TTrackBar": "", "TListBox": "", "TMemo": "", "TRadioGroup": "",
        "TPageControl": "", "TTabSheet": "", "TStatusBar": "", "TToolBar": "", "TShape": "", "TBevel": "",
        "TSpinEdit": "", "TUpDown": "", "TColorBox": "", "TDateTimePicker": "", "TListView": "",
        "TStringGrid": "", "TRichEdit": "", "TProgressBar": "", "TImage": None, "TSplitter": None,
        "TScrollBox": None, "TGridPanel": "", "TFlowPanel": "", "TStaticText": "TTMSFNCHTMLText",
        "TLinkLabel": "", "TCheckListBox": "", "TMaskEdit": "", "TLabeledEdit": "",
    },
}
NATIVE["lcl"] = NATIVE["vcl"]
NATIVE["web"] = {**NATIVE["vcl"], "TWebLabel": "", "TWebButton": "", "TWebEdit": "", "TWebPanel": "",
                 "TWebCheckBox": "", "TWebComboBox": "", "TWebMemo": "", "TWebListBox": ""}
NONVISUAL_HINT = re.compile(r"^T(TMSFNC)?\w*(Container|Manager|DataSource|DataSet|Timer|Dialog|Adapter|Binder|IO|"
                            r"Lib|Menu|Popup|ImageList|ActionList|Connection|Query|Table|StyleBook|Lang|Hint)\w*$")
EXEMPT = re.compile(r"demo-colors\s*:\s*([^}\n]*)", re.I)


def framework(form):
    ext = form.suffix.lower()
    if ext == ".fmx":
        return "fmx"
    if ext == ".lfm":
        return "lcl"
    pas = form.with_suffix(".pas")
    html = form.with_suffix(".html")
    if html.exists() or (pas.exists() and "WEBLib." in pas.read_text(encoding="utf-8-sig", errors="replace")
                         and "{$IFDEF VCL}" not in pas.read_text(encoding="utf-8-sig", errors="replace")):
        return "web"
    return "vcl"


def exemptions(form):
    pas = form.with_suffix(".pas")
    if not pas.exists():
        return set()
    out = set()
    for m in EXEMPT.finditer(pas.read_text(encoding="utf-8-sig", errors="replace")):
        out.update(x.strip() for x in m.group(1).split(",") if x.strip())
    return out


def projects_of(form):
    """Projects (dpr) that use this form unit: in its folder, or referring to it by path."""
    unit = form.with_suffix(".pas").name.lower()
    res = []
    for d in [form.parent]:
        for dpr in d.glob("*.dpr"):
            res.append(dpr)
    if not res:
        root = democheck.find_root(form.parent)
        for dpr in root.rglob("*.dpr"):
            t = dpr.read_text(encoding="utf-8-sig", errors="replace").lower()
            if unit in t and str(form.parent.name).lower() in t:
                res.append(dpr)
    return res


def runtime(form, results, tags):
    """(defaults per class, colour idents, developer values per control) from democheck shoot data."""
    fw = framework(form)
    for dpr in projects_of(form):
        try:
            proj = democheck.Project(dpr)
        except OSError:
            continue
        if proj.fw != fw and not (fw == "vcl" and proj.fw == "vcl"):
            continue
        for tag in tags:
            d = Path(results) / tag / f"{proj.fw}-{proj.slug}"
            if (d / "defaults.json").exists():
                defaults = json.loads((d / "defaults.json").read_text(encoding="utf-8-sig"))
                idents = {k.lower(): v for k, v in defaults.pop("#colors", {}).items()}
                dev = {}
                lj = d / "fluent-light.json"
                if lj.exists():
                    for c in json.loads(lj.read_text(encoding="utf-8-sig")).get("controls", []):
                        if "developer" in c:
                            dev[c["name"]] = c["developer"]
                return defaults, idents, dev, str(d)
    return None, {}, {}, None


def path_matches(path, devpaths):
    p = path.lower()
    for d in devpaths:
        d = d.lower()
        if p == d or p.startswith(d + "."):
            return True
    return False


def scan_form(form, results, tags):
    text = form.read_text(encoding="utf-8-sig", errors="replace")
    root = formfile.parse(text)
    fw = framework(form)
    defaults, idents, dev, rt = runtime(form, results, tags)
    ex = exemptions(form)
    rep = {"form": str(form), "framework": fw, "runtime": rt, "theme_manager": None, "native": [], "colors": [],
           "native_colors": [], "form_colors": [], "counts": {}}
    if root is None:
        rep["error"] = "not a form file"
        return rep
    natives = NATIVE.get(fw, {})
    for o in root.walk():
        if o is root:
            for p in o.props:
                if formfile.is_color_prop(p.path) or p.path.lower() in ("fill.color", "color"):
                    rep["form_colors"].append(f"{p.path} = {p.value}")
            continue
        if o.cls == "TTMSFNCThemeManager":
            t = o.prop("Theme")
            rep["theme_manager"] = {"name": o.name, "theme": t.value.strip("'") if t else ""}
            continue
        fnc = o.cls.startswith("TTMSFNC")
        if not fnc:
            if o.cls in natives:
                repl = natives[o.cls]
                if repl is not None:
                    rep["native"].append({"name": o.name, "class": o.cls, "replace": repl or "manual",
                                          "line": o.start + 1})
                for p in o.props:
                    if formfile.is_color_prop(p.path) and p.value.strip().lower() not in formfile.NULL_COLORS:
                        rep["native_colors"].append(f"{o.name}.{p.path} = {p.value}")
            continue
        exempt_obj = o.name in ex or o.prop("ThemingEnabled") is not None and o.prop("ThemingEnabled").value.strip() == "False"
        cdef = (defaults or {}).get(o.cls, {})
        cdef_l = {k.lower(): v for k, v in cdef.items()}
        for p in o.props:
            if not formfile.is_color_prop(p.path):
                continue
            v = p.value.strip()
            val = formfile.color_value(v, idents)
            if f"{o.name}.{p.path}" in ex or exempt_obj:
                kind = "exempt"
            elif defaults is not None and p.path.lower() in cdef_l and val is not None and \
                    (int(cdef_l[p.path.lower()]) & 0xFFFFFFFF) == val:
                kind = "default"
            elif defaults is not None and o.name in dev:
                kind = "developer" if path_matches(p.path, dev[o.name]) else "theme"
            elif v.lower() in formfile.NULL_COLORS:
                kind = "null"
            else:
                kind = "unknown"
            rep["colors"].append({"control": o.name, "class": o.cls, "path": p.path, "value": v, "kind": kind,
                                  "line": p.start + 1})
    counts = {}
    for c in rep["colors"]:
        counts[c["kind"]] = counts.get(c["kind"], 0) + 1
    counts["native"] = len(rep["native"])
    counts["native_manual"] = sum(1 for n in rep["native"] if n["replace"] == "manual")
    rep["counts"] = counts
    return rep


def forms_in(paths):
    for p in paths:
        p = Path(p)
        if p.is_file():
            yield p
        else:
            for ext in ("*.fmx", "*.dfm", "*.lfm"):
                yield from sorted(p.rglob(ext))


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("paths", nargs="+")
    ap.add_argument("--results", default=str(democheck.HARNESS / "results" / "demos-pilot"))
    ap.add_argument("--tag", nargs="+", default=["after", "before"])
    ap.add_argument("--json")
    ap.add_argument("--brief", action="store_true", help="one line per form")
    args = ap.parse_args()
    reps = []
    for f in forms_in(args.paths):
        if any(part.lower() in ("tools", "__history", "backup") for part in f.parts):
            continue
        r = scan_form(f, args.results, args.tag)
        reps.append(r)
        c = r["counts"]
        tm = r["theme_manager"]
        tm_s = f"TM({tm['theme'] or 'no theme'})" if tm else "no TM"
        print(f"{f}: {tm_s}; native {c.get('native', 0)} ({c.get('native_manual', 0)} manual); colours "
              + ", ".join(f"{k} {v}" for k, v in sorted(c.items()) if k not in ("native", "native_manual"))
              + (f"; native colours {len(r['native_colors'])}" if r["native_colors"] else "")
              + (f"; form colours {len(r['form_colors'])}" if r["form_colors"] else ""))
        if not args.brief:
            for n in r["native"]:
                print(f"    native  {n['name']}: {n['class']} -> {n['replace']}  (line {n['line']})")
            for c2 in r["colors"]:
                if c2["kind"] in ("developer", "unknown"):
                    print(f"    {c2['kind']:9} {c2['control']}.{c2['path']} = {c2['value']}  (line {c2['line']})")
    if args.json:
        Path(args.json).write_text(json.dumps(reps, indent=1), encoding="utf-8")
    return 0


if __name__ == "__main__":
    sys.exit(main())
