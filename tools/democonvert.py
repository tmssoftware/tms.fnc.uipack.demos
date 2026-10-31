"""democonvert.py - safe, reported conversions of demo forms toward the demo guidelines.

Dry run by default: prints what would change. --write applies it (the form file and its unit keep
their encoding and line endings).

  --colors default    remove colour properties of FNC controls equal to the class's run-time
                      default (nothing changes, with or without a theme)
  --colors theme      also remove colours the theme owns (only the look without a theme changes)
  --colors developer  also remove hard-coded developer colours (not exempt: `demo-colors:` comment
                      in the unit, ThemingEnabled = False). Look at the screenshots afterwards.
     (the colour classes come from demoscan.py, which needs democheck.py shoot data)
  --native            replace simple native controls by their FNC equivalent: TLabel/TStaticText ->
                      TTMSFNCHTMLText, TButton/TSpeedButton/TBitBtn -> TTMSFNCButton, TCheckBox ->
                      TTMSFNCCheckBox, TRadioButton -> TTMSFNCRadioButton, TEdit -> TTMSFNCEdit,
                      TPanel -> TTMSFNCPanel, TGroupBox -> TTMSFNCPanel with a header,
                      TComboBox -> TTMSFNCComboBox. Properties are translated (Caption/IsChecked/
                      TextSettings/Layout/Alignment), unknown ones dropped and reported; the unit's
                      field types, uses clause, member accesses (IsChecked -> Checked,
                      Caption -> Text) and class references follow. Units shared by several
                      frameworks ({$IFDEF FMX}/{$IFDEF VCL}) are reported, not changed.
  --theme-manager [THEME]  add a TTMSFNCThemeManager named ThemeManager to the form (Theme = THEME)
  --header TITLE DESCRIPTION  add the guideline header (DemoHeader: title, one-line description, a
                      TTMSFNCThemeSelector linked to the ThemeManager - added with 'Fluent Light'
                      when missing; --no-selector leaves the selector out; LCL: a native header);
                      controls that are not aligned move down by the header height

Everything else (TListBox, TTrackBar, TMemo, TPageControl, ...) is reported as manual.

Usage:
  python -I tools/democonvert.py <form or folder>... [--colors default|theme|developer] [--native]
                                 [--theme-manager "Fluent Light"] [--write]
"""

import argparse
import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import formfile  # noqa: E402
import demoscan  # noqa: E402
import democheck  # noqa: E402

UNITS = {  # FNC class -> unit (without framework prefix)
    "TTMSFNCHTMLText": "TMSFNCHTMLText", "TTMSFNCButton": "TMSFNCButton", "TTMSFNCCheckBox": "TMSFNCCheckBox",
    "TTMSFNCRadioButton": "TMSFNCRadioButton", "TTMSFNCEdit": "TMSFNCEdit", "TTMSFNCPanel": "TMSFNCPanel",
    "TTMSFNCComboBox": "TMSFNCComboBox", "TTMSFNCThemeManager": "TMSFNCTheme",
    "TTMSFNCThemeSelector": "TMSFNCThemeSelector", "TPanel": None, "TLabel": None,
}
BASE_UNITS = ["TMSFNCTypes", "TMSFNCUtils", "TMSFNCGraphics", "TMSFNCGraphicsTypes", "TMSFNCCustomControl"]
PREFIX = {"fmx": "FMX.", "vcl": "VCL.", "web": "WEBLib.", "lcl": "LCL"}

COMMON_FMX = re.compile(r"^(Align|Anchors|Margins\.\w+|Padding\.\w+|Position\.[XY]|Size\.(Width|Height|PlatformDefault)|"
                        r"Width|Height|Visible|Enabled|TabOrder|TabStop|Hint|ShowHint|HitTest|Opacity|Cursor|Tag|"
                        r"ClipChildren|PopupMenu|DragMode|On(Click|DblClick|Mouse\w+|Resize|Enter|Exit|Key\w+|Resized))$")
COMMON_VCL = re.compile(r"^(Left|Top|Width|Height|Align|AlignWithMargins|Margins\.\w+|Padding\.\w+|Anchors|Visible|"
                        r"Enabled|TabOrder|TabStop|Hint|ShowHint|ParentShowHint|Tag|Cursor|PopupMenu|Constraints\.\w+|"
                        r"DragMode|On(Click|DblClick|Mouse\w+|Resize|Enter|Exit|Key\w+))$")
ALIGN_H = {"Leading": "gtaLeading", "Center": "gtaCenter", "Trailing": "gtaTrailing",
           "taLeftJustify": "gtaLeading", "taCenter": "gtaCenter", "taRightJustify": "gtaTrailing"}
ALIGN_V = {"Leading": "gtaLeading", "Center": "gtaCenter", "Trailing": "gtaTrailing",
           "tlTop": "gtaLeading", "tlCenter": "gtaCenter", "tlBottom": "gtaTrailing"}


class Conversion:
    def __init__(self, form):
        self.form = form
        self.raw = form.read_bytes()
        self.crlf = b"\r\n" in self.raw
        self.bom = self.raw.startswith(b"\xef\xbb\xbf")
        try:
            self.text = self.raw.decode("utf-8-sig")
            self.enc = "utf-8"
        except UnicodeDecodeError:
            self.text = self.raw.decode("cp1252")
            self.enc = "cp1252"
        self.lines = self.text.splitlines()
        self.root = formfile.parse(self.text)
        self.fw = demoscan.framework(form)
        self.delete = set()        # line indexes to drop
        self.replace = {}          # line index -> list of new lines (replacing that line)
        self.insert_after = {}     # line index -> list of lines
        self.report = []
        self.converted = {}        # control name -> (old class, new class)
        self.pas = form.with_suffix(".pas")

    # ---------------------------------------------------------------- colours
    def colors(self, level, results, tags):
        rep = demoscan.scan_form(self.form, results, tags)
        if not rep["runtime"]:
            self.report.append("colours: no run-time data (democheck.py shoot) - nothing removed")
            return
        kinds = {"default": {"default"}, "theme": {"default", "theme"},
                 "developer": {"default", "theme", "developer"}}[level]
        n = 0
        for c in rep["colors"]:
            if c["kind"] in kinds:
                obj = self.find(c["control"])
                p = obj.prop(c["path"]) if obj else None
                if p and "[" not in p.path:
                    for i in range(p.start, p.end + 1):
                        self.delete.add(i)
                    n += 1
                    if c["kind"] == "developer":
                        self.report.append(f"  removed developer colour {c['control']}.{c['path']} = {c['value']}")
        kept = [c for c in rep["colors"] if c["kind"] not in kinds and c["kind"] not in ("null",)]
        self.report.append(f"colours: removed {n} ({'/'.join(sorted(kinds))}); kept {len(kept)} "
                           f"({', '.join(sorted({c['kind'] for c in kept})) or '-'})")

    def find(self, name):
        for o in self.root.walk():
            if o.name == name:
                return o
        return None

    # ---------------------------------------------------------------- native controls
    def native(self):
        if self.fw not in ("fmx", "vcl"):
            self.report.append(f"native: {self.fw} forms are not converted (manual)")
            return
        natives = demoscan.NATIVE[self.fw]
        for o in list(self.root.walk()):
            if o is self.root or o.cls not in natives:
                continue
            target = natives[o.cls]
            if target is None:
                continue
            if not target:
                self.report.append(f"  manual  {o.name}: {o.cls}")
                continue
            self.convert_object(o, target)

    def convert_object(self, o, target):
        fmx = self.fw == "fmx"
        common = COMMON_FMX if fmx else COMMON_VCL
        ind = " " * (o.indent + 2)
        keep, add, dropped = [], [], []
        props = {p.path: p for p in o.props if "[" not in p.path}
        child_items = [c for c in o.children if c.cls == "TListBoxItem"]
        for p in o.props:
            path, v = p.path, p.value.strip()
            line_text = self.lines[p.start:p.end + 1]
            new_name = None
            if common.match(path):
                new_name = path
            elif target == "TTMSFNCHTMLText":
                new_name = {"Text": "Text", "Caption": "Text", "AutoSize": "AutoSize", "WordWrap": "WordWrapping",
                            "TextSettings.WordWrap": "WordWrapping", "TextSettings.Font.Size": "Font.Size",
                            "TextSettings.Font.StyleExt": "Font.StyleExt", "Font.Height": "Font.Height",
                            "Font.Style": "Font.Style", "Font.Size": "Font.Size"}.get(path)
                if path in ("TextSettings.HorzAlign", "Alignment"):
                    add.append(f"HorizontalTextAlign = {ALIGN_H.get(v, 'gtaLeading')}")
                    self.delete.update(range(p.start, p.end + 1))
                    continue
                if path in ("TextSettings.VertAlign", "Layout"):
                    add.append(f"VerticalTextAlign = {ALIGN_V.get(v, 'gtaCenter')}")
                    self.delete.update(range(p.start, p.end + 1))
                    continue
            elif target == "TTMSFNCButton":
                if fmx:
                    new_name = None if path.startswith("TextSettings.") or path in ("StyleLookup", "Images", "ImageIndex") else path
                else:
                    new_name = {"Caption": "Text", "Default": "Default", "Cancel": "Cancel", "ModalResult": "ModalResult",
                                "Font.Height": "Font.Height", "Font.Style": "Font.Style", "Action": "Action"}.get(path)
            elif target in ("TTMSFNCCheckBox", "TTMSFNCRadioButton"):
                new_name = {"Text": "Text", "Caption": "Text", "IsChecked": "Checked", "Checked": "Checked",
                            "GroupName": "GroupName" if target == "TTMSFNCRadioButton" else None,
                            "OnChange": "OnChange", "Font.Height": "Font.Height", "Font.Style": "Font.Style",
                            "TextSettings.Font.Size": "Font.Size"}.get(path)
                if not fmx and path == "OnClick":
                    new_name = "OnChange"
                if not fmx and path == "State":
                    if v == "cbChecked":
                        add.append("Checked = True")
                    self.delete.update(range(p.start, p.end + 1))
                    continue
            elif target == "TTMSFNCEdit":
                new_name = None if path in ("StyleLookup", "TextSettings.FontColor", "Font.Color", "Font.Name", "Font.Charset",
                                            "ParentFont", "Ctl3D", "ParentCtl3D", "BevelInner", "BevelOuter") else path
            elif target == "TTMSFNCPanel":
                if path == "Text" or path == "Caption":
                    if o.cls == "TGroupBox" and v not in ("''", ""):
                        add.append(f"Header.Text = {v}")
                    elif v not in ("''", ""):
                        dropped.append(f"{path}={v}")
                    self.delete.update(range(p.start, p.end + 1))
                    continue
            elif target == "TTMSFNCComboBox":
                new_name = {"Items.Strings": "Items.Strings", "ItemIndex": "ItemIndex", "OnChange": "OnChange",
                            "Text": "Text", "Sorted": None, "DropDownCount": "DropDownCount",
                            "Font.Height": "Font.Height"}.get(path)
                if not fmx and path == "Style":
                    if v == "csDropDownList":
                        add.append("Style = csDropDownList")
                    self.delete.update(range(p.start, p.end + 1))
                    continue
            if new_name is None:
                if not (formfile.is_color_prop(path) and v.lower() in formfile.NULL_COLORS) and path not in (
                        "StyledSettings", "Size.PlatformDefault", "ParentFont", "ParentColor", "ParentBackground",
                        "Font.Charset", "Font.Name", "Font.Color", "Transparent", "BevelOuter", "BevelInner",
                        "FullRepaint", "StyleLookup", "TextSettings.Trimming", "DisableFocusEffect", "AutoSize",
                        "ExplicitLeft", "ExplicitTop", "ExplicitWidth", "ExplicitHeight", "TextSettings.Font.Family",
                        "ParentDoubleBuffered", "DoubleBuffered", "StyleElements", "WordWrap", "ShowCaption"):
                    dropped.append(f"{path}={v[:30]}")
                for i in range(p.start, p.end + 1):
                    self.delete.add(i)
                continue
            if new_name != path:
                first = line_text[0]
                self.replace[p.start] = [first.replace(path, new_name, 1)] + line_text[1:]
                for i in range(p.start + 1, p.end + 1):
                    self.delete.add(i)
        # FMX: a size that was not stored is the native default, which the FNC class does not share
        if fmx:
            dw, dh = {"TLabel": (120, 17), "TCheckBox": (120, 19), "TRadioButton": (120, 19), "TButton": (80, 22),
                      "TSpeedButton": (80, 22), "TEdit": (100, 22), "TComboBox": (100, 22), "TPanel": (120, 100),
                      "TGroupBox": (120, 100)}.get(o.cls, (None, None))
            if dw and "Size.Width" not in props:
                add.append(f"Size.Width = {float(dw):.18f}")
            if dh and "Size.Height" not in props:
                add.append(f"Size.Height = {float(dh):.18f}")
            if dw and ("Size.Width" not in props or "Size.Height" not in props) and "Size.PlatformDefault" not in props:
                add.append("Size.PlatformDefault = False")
        # class-specific additions
        if target == "TTMSFNCHTMLText":
            if not any(a.startswith("HorizontalTextAlign") for a in add):
                add.append("HorizontalTextAlign = gtaLeading")
            hp = props.get("Size.Height")
            if fmx and "TextSettings.WordWrap" not in props and hp and float(hp.value) >= 28:
                add.append("WordWrapping = True")  # FMX labels wrap by default; only multi-line ones need it
            if not fmx and "AutoSize" not in props:
                add.append("AutoSize = True")  # VCL labels size to their text by default
            add += ["Fill.Kind = gfkNone", "Stroke.Kind = gskNone"]
        if target == "TTMSFNCPanel":
            add.append("Header.Visible = True" if o.cls == "TGroupBox" else "Header.Visible = False")
            if o.cls == "TGroupBox":
                # the header (24) is taller than the group box caption (16): children move down 8
                add.append("Header.Size = 24.000000000000000000" if fmx else "Header.Size = 24.000000000000000000")
                self.shift_children(o, 8)
                hp = props.get("Size.Height" if fmx else "Height")
                if hp:
                    nh = float(hp.value) + 8
                    self.replace[hp.start] = [self.lines[hp.start].split("=")[0] + "= " + (f"{nh:.18f}" if fmx else str(int(nh)))]
                self.report.append(f"  check   {o.name}: TGroupBox -> panel with header; children moved down 8")
        if target == "TTMSFNCRadioButton" and not fmx and o.parent is not None:
            add.append(f"GroupName = '{o.parent.name}'")
        if target == "TTMSFNCComboBox":
            if fmx:
                add.append("Style = csDropDownList")
            if child_items:
                add.append("Items.Strings = (")
                texts = []
                for c in child_items:
                    t = c.prop("Text")
                    texts.append(t.value.strip() if t else "''")
                add[-1] += "\n" + "\n".join(f"{ind}  {t}" for t in texts) + ")"
                for c in child_items:
                    for i in range(c.start, c.end + 1):
                        self.delete.add(i)
        # header line
        hdr = self.lines[o.start]
        self.replace[o.start] = [hdr.replace(f": {o.cls}", f": {target}", 1)]
        last_prop = max([p.end for p in o.props if "[" not in p.path] or [o.start])
        if add:
            lines = []
            for a in add:
                lines += [ind + x if i == 0 else x for i, x in enumerate(a.split("\n"))]
            self.insert_after.setdefault(last_prop, []).extend(lines)
        self.converted[o.name] = (o.cls, target)
        self.report.append(f"  native  {o.name}: {o.cls} -> {target}" + (f"  dropped {', '.join(dropped)}" if dropped else ""))

    def shift_children(self, o, dy):
        fmx = self.fw == "fmx"
        for c in o.children:
            al = c.prop("Align")
            if al and al.value.strip() not in ("None", "alNone"):
                continue
            p = c.prop("Position.Y") if fmx else c.prop("Top")
            if p is None:
                if fmx and c.prop("Position.X"):
                    self.insert_after.setdefault(c.prop("Position.X").end, []).append(
                        " " * (c.indent + 2) + f"Position.Y = {float(dy):.18f}")
                continue
            v = float(p.value)
            nv = f"{v + dy:.18f}" if fmx else str(int(v) + dy)
            self.replace[p.start] = [self.lines[p.start].split("=")[0] + "= " + nv]

    # ---------------------------------------------------------------- theme manager
    def theme_manager(self, theme):
        for o in self.root.walk():
            if o.cls == "TTMSFNCThemeManager":
                self.report.append(f"theme manager: {o.name} already on the form")
                return
        ind = " " * (self.root.indent + 2)
        lines = [f"{ind}object ThemeManager: TTMSFNCThemeManager"]
        if theme:
            lines.append(f"{ind}  Theme = '{theme}'")
        if self.fw == "fmx":
            lines += [f"{ind}  Left = 24", f"{ind}  Top = 24"]
        else:
            lines += [f"{ind}  Left = 24", f"{ind}  Top = 24"]
        lines.append(f"{ind}end")
        self.insert_after.setdefault(self.root.end - 1, []).extend(lines)
        self.converted["ThemeManager"] = (None, "TTMSFNCThemeManager")
        self.report.append(f"theme manager: added (Theme = '{theme}')")

    # ---------------------------------------------------------------- header
    def header(self, title, description, selector):
        """The guideline header: title, one-line description and (FMX/VCL/WEB) a theme selector,
        aligned to the top; controls that are not aligned move down by its height."""
        if self.find("DemoHeader"):
            self.report.append("header: already there")
            return
        H = 72
        fw = self.fw
        root = self.root
        ind = " " * (root.indent + 2)
        cw = root.prop("ClientWidth")
        W = int(float(cw.value)) if cw else 800
        esc = lambda s: "'" + s.replace("'", "''") + "'"
        selw = 160 if selector and fw != "lcl" else 0
        tw = W - 48 - (selw + 16 if selw else 0)
        L = []
        if fw == "fmx":
            f = lambda v: f"{float(v):.18f}"
            L += ["object DemoHeader: TTMSFNCPanel", "  Align = Top", f"  Size.Width = {f(W)}", f"  Size.Height = {f(H)}",
                  "  Size.PlatformDefault = False", "  TabOrder = 0", "  Fill.Kind = gfkNone", "  Stroke.Kind = gskNone",
                  "  Header.Visible = False"]
            if selw:
                L += ["  object DemoThemeSelector: TTMSFNCThemeSelector", "    Align = Right", f"    Margins.Top = {f(18)}",
                      f"    Margins.Right = {f(24)}", f"    Margins.Bottom = {f(18)}", f"    Size.Width = {f(selw)}",
                      f"    Size.Height = {f(36)}", "    Size.PlatformDefault = False", "    TabOrder = 0",
                      "    ThemeManager = ThemeManager", "    Themes.Strings = (", "      'Fluent Light=Light'", "      'Fluent Dark=Dark')",
                      "  end"]
            L += ["  object DemoTitle: TTMSFNCHTMLText", "    Anchors = [akLeft, akTop, akRight]", f"    Position.X = {f(24)}",
                  f"    Position.Y = {f(12)}", f"    Size.Width = {f(tw)}", f"    Size.Height = {f(30)}",
                  "    Size.PlatformDefault = False", "    TabOrder = 1", f"    Font.Size = {f(20)}",
                  "    Font.StyleExt = {00060000000000000004000000}", "    HorizontalTextAlign = gtaLeading",
                  "    Trimming = gttCharacter", "    Fill.Kind = gfkNone", "    Stroke.Kind = gskNone", f"    Text = {esc(title)}",
                  "  end",
                  "  object DemoDescription: TTMSFNCHTMLText", "    TextRole = htrSecondary", "    Anchors = [akLeft, akTop, akRight]",
                  f"    Position.X = {f(24)}", f"    Position.Y = {f(42)}", f"    Size.Width = {f(tw)}", f"    Size.Height = {f(20)}",
                  "    Size.PlatformDefault = False", "    TabOrder = 2", f"    Font.Size = {f(13)}",
                  "    HorizontalTextAlign = gtaLeading", "    Trimming = gttCharacter", "    Fill.Kind = gfkNone",
                  "    Stroke.Kind = gskNone", f"    Text = {esc(description)}", "  end", "end"]
        elif fw in ("vcl", "web"):
            L += ["object DemoHeader: TTMSFNCPanel", "  Left = 0", "  Top = 0", f"  Width = {W}", f"  Height = {H}",
                  "  Align = alTop", "  TabOrder = 0", "  Fill.Kind = gfkNone", "  Stroke.Kind = gskNone", "  Header.Visible = False"]
            if selw:
                L += ["  object DemoThemeSelector: TTMSFNCThemeSelector", "    AlignWithMargins = True",
                      f"    Left = {W - 24 - selw}", "    Top = 18", f"    Width = {selw}", "    Height = 36",
                      "    Margins.Left = 0", "    Margins.Top = 18", "    Margins.Right = 24", "    Margins.Bottom = 18",
                      "    Align = alRight", "    TabOrder = 0", "    ThemeManager = ThemeManager",
                      "    Themes.Strings = (", "      'Fluent Light=Light'", "      'Fluent Dark=Dark')", "  end"]
            L += ["  object DemoTitle: TTMSFNCHTMLText", "    Left = 24", "    Top = 12", f"    Width = {tw}", "    Height = 30",
                  "    Anchors = [akLeft, akTop, akRight]", "    Font.Height = -20", "    Font.Name = 'Segoe UI Semibold'",
                  "    TabOrder = 1",
                  "    HorizontalTextAlign = gtaLeading", "    Trimming = gttCharacter", "    Fill.Kind = gfkNone",
                  "    Stroke.Kind = gskNone", f"    Text = {esc(title)}", "  end",
                  "  object DemoDescription: TTMSFNCHTMLText", "    Left = 24", "    Top = 42", f"    Width = {tw}", "    Height = 20",
                  "    Anchors = [akLeft, akTop, akRight]", "    TabOrder = 2", "    TextRole = htrSecondary",
                  "    HorizontalTextAlign = gtaLeading", "    Trimming = gttCharacter", "    Fill.Kind = gfkNone",
                  "    Stroke.Kind = gskNone", f"    Text = {esc(description)}", "  end", "end"]
        else:  # lcl: no theme manager; native header
            L += ["object DemoHeader: TPanel", "  Left = 0", "  Height = 72", "  Top = 0", f"  Width = {W}", "  Align = alTop",
                  "  BevelOuter = bvNone", "  ClientHeight = 72", f"  ClientWidth = {W}", "  TabOrder = 0",
                  "  object DemoTitle: TLabel", "    Left = 24", "    Height = 30", "    Top = 12", f"    Width = {tw}",
                  "    Anchors = [akTop, akLeft, akRight]", "    AutoSize = False", "    Caption = " + esc(title),
                  "    Font.Height = -20", "    Font.Style = [fsBold]", "    ParentFont = False", "  end",
                  "  object DemoDescription: TLabel", "    Left = 24", "    Height = 20", "    Top = 42", f"    Width = {tw}",
                  "    Anchors = [akTop, akLeft, akRight]", "    AutoSize = False", "    Caption = " + esc(description),
                  "    Font.Color = clGrayText", "    ParentFont = False", "  end", "end"]
        last = max([p.end for p in root.props] or [root.start])
        self.insert_after.setdefault(last, []).extend(ind + x for x in L)
        # move controls that are not aligned below the header; grow the form
        moved = 0
        for c in root.children:
            al = c.prop("Align")
            if al and al.value.strip() not in ("None", "alNone"):
                continue
            p = c.prop("Position.Y") if fw == "fmx" else c.prop("Top")
            if fw == "fmx" and not c.prop("Position.X") and not p and not c.prop("Size.Width"):
                continue  # non-visual component
            if fw != "fmx" and not c.prop("Width") and c.prop("Left") and c.prop("Top") and not c.prop("Height"):
                continue  # non-visual component (Left/Top only)
            if p is None:
                if fw == "fmx" and c.prop("Position.X"):
                    self.insert_after.setdefault(c.prop("Position.X").end, []).append(
                        " " * (c.indent + 2) + f"Position.Y = {float(H):.18f}")
                    moved += 1
                continue
            v = float(p.value)
            nv = f"{v + H:.18f}" if fw == "fmx" else str(int(v) + H)
            self.replace[p.start] = [self.lines[p.start].split("=")[0] + "= " + nv]
            moved += 1
        ch = root.prop("ClientHeight")
        if ch:
            self.replace[ch.start] = [self.lines[ch.start].split("=")[0] + f"= {int(float(ch.value)) + H}"]
        for name in ("DemoHeader", "DemoTitle", "DemoDescription") + (("DemoThemeSelector",) if selw else ()):
            cls = {"DemoHeader": "TTMSFNCPanel", "DemoTitle": "TTMSFNCHTMLText", "DemoDescription": "TTMSFNCHTMLText",
                   "DemoThemeSelector": "TTMSFNCThemeSelector"}[name]
            if fw == "lcl":
                cls = "TPanel" if name == "DemoHeader" else "TLabel"
            self.converted[name] = (None, cls)
        if selw and not self.find("ThemeManager") and "ThemeManager" not in self.converted:
            self.theme_manager("Fluent Light")
        self.report.append(f"header: added ({'with' if selw else 'without'} theme selector); {moved} controls moved down {H}")

    # ---------------------------------------------------------------- output
    def new_form_text(self):
        out = []
        for i, line in enumerate(self.lines):
            if i in self.replace:
                out.extend(self.replace[i])
            elif i not in self.delete:
                out.append(line)
            if i in self.insert_after:
                out.extend(self.insert_after[i])
        nl = "\r\n" if self.crlf else "\n"
        return nl.join(out) + nl

    def new_pas_text(self):
        if not self.pas.exists() or not self.converted:
            return None, []
        raw = self.pas.read_bytes()
        try:
            text = raw.decode("utf-8-sig")
            enc = "utf-8"
        except UnicodeDecodeError:
            text = raw.decode("cp1252")
            enc = "cp1252"
        notes = []
        shared = re.search(r"\{\$IFDEF\s+(FMX|VCL|WEBLIB|LCL)\}", text) is not None
        if shared:
            notes.append("unit is shared by several frameworks: field types/uses not changed (manual)")
            return None, notes
        prefix = PREFIX[self.fw]
        added = []
        for name, (old, new) in self.converted.items():
            if old:
                text, n = re.subn(rf"(\b{name}\s*:\s*){old}\s*;", rf"\g<1>{new};", text)
            elif not re.search(rf"\b{name}\s*:\s*T", text):
                added.append((name, new))
        if added:
            # new components: fields right after the class header, in form order
            order = ["ThemeManager", "DemoHeader", "DemoTitle", "DemoDescription", "DemoThemeSelector"]
            added.sort(key=lambda a: order.index(a[0]) if a[0] in order else 99)
            m = re.search(r"(\bT\w+\s*=\s*class\s*\(\s*T\w*Form\s*\)\s*\r?\n)", text)
            if m:
                text = text[:m.end()] + "".join(f"    {n}: {c};\n" for n, c in added) + text[m.end():]
        # member accesses
        for name, (old, new) in self.converted.items():
            if not old:
                continue
            if self.fw == "fmx" and new in ("TTMSFNCCheckBox", "TTMSFNCRadioButton"):
                text = re.sub(rf"\b{name}\.IsChecked\b", f"{name}.Checked", text)
            if self.fw == "vcl" and new in ("TTMSFNCHTMLText", "TTMSFNCButton", "TTMSFNCCheckBox", "TTMSFNCRadioButton"):
                text = re.sub(rf"\b{name}\.Caption\b", f"{name}.Text", text)
            for m in re.finditer(rf"\b{name}\.(\w+)", text):
                member = m.group(1)
                if member not in ("Text", "Checked", "Visible", "Enabled", "Width", "Height", "Left", "Top", "Align",
                                  "Hint", "Tag", "SetFocus", "BringToFront", "Position", "Parent", "Name", "Items",
                                  "ItemIndex", "OnChange", "OnClick", "Header", "Font", "Size", "Margins",
                                  "BeginUpdate", "EndUpdate", "Clear", "Repaint", "Invalidate"):
                    notes.append(f"check {name}.{member} (now {new})")
        # class references in code (Sender as TCheckBox ...), when every instance was converted
        olds = {old for old, _ in self.converted.values() if old}
        for old in olds:
            remaining = [o for o in self.root.walk() if o.cls == old and o.name not in self.converted]
            if not remaining:
                new = next(n for o2, n in self.converted.values() if o2 == old)
                body_start = text.find("implementation")
                if body_start > 0:
                    text = text[:body_start] + re.sub(rf"\b{old}\b", new, text[body_start:])
        # uses
        need = set()
        for _, new in self.converted.values():
            if UNITS.get(new):
                need.add(UNITS[new])
                if new != "TTMSFNCThemeManager":
                    need.update(BASE_UNITS)
        m = re.search(r"\buses\b(.*?);", text, re.S)
        if m:
            # every uses clause counts (interface and implementation): a unit in both is E2004
            have = set()
            for um in re.finditer(r"\buses\b(.*?);", text, re.S):
                have.update(u.strip().lower() for u in re.split(r",", re.sub(r"\{[^}]*\}", "", um.group(1))))
            missing = [prefix + u for u in sorted(need) if (prefix + u).lower() not in have]
            if missing:
                text = text[:m.end() - 1] + ",\n  " + ", ".join(missing) + text[m.end() - 1:]
        return (text, enc, raw), notes


def write(path, text, enc, crlf_like):
    raw = text.encode(enc)
    if crlf_like and b"\r\n" not in raw:
        raw = raw.replace(b"\n", b"\r\n")
    path.write_bytes(raw)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("paths", nargs="+")
    ap.add_argument("--colors", choices=["default", "theme", "developer"])
    ap.add_argument("--native", action="store_true")
    ap.add_argument("--theme-manager", nargs="?", const="", default=None)
    ap.add_argument("--header", nargs=2, metavar=("TITLE", "DESCRIPTION"))
    ap.add_argument("--no-selector", action="store_true", help="header without a theme selector")
    ap.add_argument("--results", default=str(democheck.HARNESS / "results" / "demos-pilot"))
    ap.add_argument("--tag", nargs="+", default=["after", "before"])
    ap.add_argument("--write", action="store_true")
    args = ap.parse_args()
    for form in demoscan.forms_in(args.paths):
        if any(part.lower() in ("tools", "__history") for part in form.parts):
            continue
        c = Conversion(form)
        if c.root is None:
            continue
        if args.colors:
            c.colors(args.colors, args.results, args.tag)
        if args.native:
            c.native()
        if args.theme_manager is not None:
            c.theme_manager(args.theme_manager)
        if args.header:
            c.header(args.header[0], args.header[1], not args.no_selector)
        print(f"{form}:")
        for r in c.report:
            print("  " + r)
        new_form = c.new_form_text()
        pas, notes = c.new_pas_text()
        for n in notes:
            print("    pas: " + n)
        if args.write:
            if new_form != c.text.replace("\r\n", "\n").replace("\n", "\r\n" if c.crlf else "\n") + ("" if c.text.endswith("\n") else ""):
                raw = new_form.encode(c.enc)
                if c.bom:
                    raw = b"\xef\xbb\xbf" + raw
                form.write_bytes(raw)
            if pas:
                text, enc, raw = pas
                crlf = b"\r\n" in raw
                out = text.replace("\r\n", "\n")
                if crlf:
                    out = out.replace("\n", "\r\n")
                b = out.encode(enc)
                if raw.startswith(b"\xef\xbb\xbf"):
                    b = b"\xef\xbb\xbf" + b
                c.pas.write_bytes(b)
    if not args.write:
        print("(dry run - nothing written; --write applies)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
