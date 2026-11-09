"""demonew.py - scaffold a new UI Pack demo: FMX, VCL and WEB projects sharing one form unit.

  python -I tools/demonew.py "Avatar" --title "Avatar" --description "Images, initials, ..." [--web-name FNCAvatar]
                             [--no-web] [--data]

Creates FMX/<Name>/Demo.dpr|.dproj|.res|TMSLogo.ico, VCL/<Name>/..., WEB/<Name>/TMSWeb_<web-name>.dpr|.dproj|index.html
and Shared Code/Form Unit/<Name>/UDemo.pas|.fmx|.dfm|.html (plus a one-line README.md per folder) from the TreeView Database Adapter demo (the layout
reference of docs/DemoGuidelines.md): header with title, description and theme selector, a ThemeManager on
'Fluent Light', the shared layout helpers of Shared Code/Business Logic/Demo Layout in the uses clause and an empty
FormCreate. --data adds Data.DB and the in-memory dataset units (FireDAC on desktop, TWebClientDataSet on WEB).
Nothing is overwritten: an existing folder stops the script.
"""

import argparse
import re
import shutil
import sys
import uuid
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPO = HERE.parent
TEMPLATE = "TreeView Database Adapter"
TEMPLATE_WEB = "TMSWeb_FNCTreeViewDatabaseAdapter"

UNIT = """unit UDemo;

{ TMS FNC UI Pack - %(title)s

  %(description)s }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,%(vcldata)s
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox,
  VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,%(fmxdata)s
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox,
  FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs,%(webdata)s
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCTheme, WEBLib.TMSFNCThemeSelector,
  {$ENDIF}
  UDemoLayout;

type
  TForm1 = class(TDemoForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TTMSFNCPanel;
    DemoTitle: TTMSFNCHTMLText;
    DemoDescription: TTMSFNCHTMLText;
    DemoThemeSelector: TTMSFNCThemeSelector;
    procedure FormCreate(Sender: TObject);
  private
    FLayout: TDemoLayout;
    FSettings: TTMSFNCPanel;
    FContent: TTMSFNCPanel;
    procedure CreateSettings;
    procedure CreateContent;
  public
  end;

var
  Form1: TForm1;

implementation

{$IFDEF FMX}
{$R *.fmx}
{$ENDIF}
{$IFDEF VCL}
{$R *.dfm}
{$ENDIF}
{$IFDEF WEBLIB}
{$R *.dfm}
{$ENDIF}

procedure TForm1.FormCreate(Sender: TObject);
begin
  FLayout := TDemoLayout.Create(Self);
  CreateSettings;
  CreateContent;
end;

procedure TForm1.CreateSettings;
begin
  FSettings := FLayout.AddSettingsPanel(Self);
end;

procedure TForm1.CreateContent;
begin
  FContent := FLayout.AddContentPanel(Self);
end;

end.
"""

FMX_DATA = """
  Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client,"""
WEB_DATA = " DB, WEBLib.DB, WEBLib.CDS,"


def guid_replace(text):
    return re.sub(r"<ProjectGuid>\{[0-9A-Fa-f-]+\}</ProjectGuid>", "<ProjectGuid>{%s}</ProjectGuid>" % str(uuid.uuid4()).upper(),
                  text)


LAYOUT_UNIT = r"UDemoLayout in '..\..\Shared Code\Business Logic\Demo Layout\UDemoLayout.pas'"


def copy_text(src, dst, replacements):
    raw = src.read_bytes()
    bom = raw.startswith(b"\xef\xbb\xbf")
    text = raw.decode("utf-8-sig")
    for a, b in replacements:
        text = text.replace(a, b)
    if dst.suffix.lower() == ".dproj":
        text = guid_replace(text)
        text = text.replace('<DCCReference Include="..\\..\\Shared Code\\Form Unit',
                            '<DCCReference Include="..\\..\\Shared Code\\Business Logic\\Demo Layout\\UDemoLayout.pas"/>\r\n'
                            '        <DCCReference Include="..\\..\\Shared Code\\Form Unit', 1)
    elif dst.suffix.lower() == ".dpr":
        text = re.sub(r"(\r?\n)(  UDemo in '[^']+'[^;\r\n]*)", lambda m: f"{m.group(1)}  {LAYOUT_UNIT},{m.group(1)}{m.group(2)}", text, count=1)
    dst.write_bytes((b"\xef\xbb\xbf" if bom else b"") + text.encode("utf-8"))


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("name", help="demo folder name under FMX, VCL, WEB and Shared Code/Form Unit")
    ap.add_argument("--title", help="header title (default: the name)")
    ap.add_argument("--description", required=True, help="one line: what to try")
    ap.add_argument("--web-name", help="WEB project name without TMSWeb_ (default: FNC + name without spaces)")
    ap.add_argument("--no-web", action="store_true", help="FMX and VCL only")
    ap.add_argument("--data", action="store_true", help="add the dataset units to the uses clauses")
    args = ap.parse_args()
    name = args.name
    title = args.title or name
    web = args.web_name or "FNC" + re.sub(r"[^A-Za-z0-9]", "", name)
    old_caption = f"TMS FNC UI Pack - {TEMPLATE}"
    new_caption = f"TMS FNC UI Pack - {title}"
    old_desc = "Expand nodes to load them on demand, click a selected node to rename it, drag a node onto another to move it"
    common = [(old_caption, new_caption), (f"Text = '{TEMPLATE}'", f"Text = '{title}'"), (old_desc, args.description),
              (TEMPLATE, name), (TEMPLATE_WEB, "TMSWeb_" + web)]
    targets = [REPO / "FMX" / name, REPO / "VCL" / name, REPO / "Shared Code" / "Form Unit" / name]
    if not args.no_web:
        targets.append(REPO / "WEB" / name)
    for t in targets:
        if t.exists():
            sys.exit(f"exists: {t}")
    for fw in ("FMX", "VCL"):
        src, dst = REPO / fw / TEMPLATE, REPO / fw / name
        dst.mkdir(parents=True)
        for f in src.iterdir():
            if f.suffix.lower() in (".dpr", ".dproj"):
                copy_text(f, dst / f.name, common)
            else:
                shutil.copy2(f, dst / f.name)
    if not args.no_web:
        src, dst = REPO / "WEB" / TEMPLATE, REPO / "WEB" / name
        dst.mkdir(parents=True)
        for f in src.iterdir():
            copy_text(f, dst / f.name.replace(TEMPLATE_WEB, "TMSWeb_" + web), common)
    src, dst = REPO / "Shared Code" / "Form Unit" / TEMPLATE, REPO / "Shared Code" / "Form Unit" / name
    dst.mkdir(parents=True)
    for ext in (".fmx", ".dfm", ".html"):
        copy_text(src / ("UDemo" + ext), dst / ("UDemo" + ext), common)
    unit = UNIT % {"title": title, "description": args.description,
                   "vcldata": " Data.DB," + FMX_DATA if args.data else "", "fmxdata": FMX_DATA if args.data else "",
                   "webdata": WEB_DATA if args.data else ""}
    if args.data:
        unit = unit.replace(" Data.DB,\n  Data.DB,", "\n  Data.DB,")
    (dst / "UDemo.pas").write_bytes(unit.replace("\n", "\r\n").encode("utf-8"))
    print("\n".join(str(t.relative_to(REPO)) for t in targets))


if __name__ == "__main__":
    main()
