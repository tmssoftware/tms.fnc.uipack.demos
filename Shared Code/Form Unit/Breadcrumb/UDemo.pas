unit UDemo;

{ TMS FNC UI Pack - Breadcrumb

  A breadcrumb shows where the user is and lets them jump back: click a segment, open the drop-down after a
  segment to pick a sibling, or click the free space to type a path. In a narrow control the middle segments
  collapse into an ellipsis with their own drop-down. The second breadcrumb mirrors the first with another
  separator style. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCBreadcrumb, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCBreadcrumb, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton, WEBLib.TMSFNCBreadcrumb, WEBLib.TMSFNCTheme,
  WEBLib.TMSFNCThemeSelector,
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
    FSeparatorRadios: array[TTMSFNCBreadcrumbSeparator] of TTMSFNCRadioButton;
    FEditCheck: TTMSFNCCheckBox;
    FKeepFirstCheck: TTMSFNCCheckBox;
    FTruncateCheck: TTMSFNCCheckBox;
    FFramedCheck: TTMSFNCCheckBox;
    FExplorer: TTMSFNCBreadcrumb;
    FNarrow: TTMSFNCBreadcrumb;
    FLog: TTMSFNCHTMLText;
    procedure CreateSettings;
    procedure CreateContent;
    procedure ApplySettings;
    procedure SettingChanged(Sender: TObject);
    procedure ItemClick(Sender: TObject; AIndex: Integer);
    procedure PathChanged(Sender: TObject);
    procedure DropDownItemClick(Sender: TObject; AIndex, AEntry: Integer; const AText: string; var ANavigate: Boolean);
    procedure PathEdit(Sender: TObject; var APath: string; var AAllow: Boolean);
    procedure DeeperClick(Sender: TObject);
    procedure Log(const AText: string);
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
  ApplySettings;
end;

procedure TForm1.CreateSettings;
const
  SeparatorNames: array[TTMSFNCBreadcrumbSeparator] of string = ('Chevron', 'Slash', 'Text (>)');
var
  sp: TTMSFNCBreadcrumbSeparator;
begin
  FSettings := FLayout.AddSettingsPanel(Self);

  FLayout.AddCaption(FSettings, 'Separator');
  for sp := Low(TTMSFNCBreadcrumbSeparator) to High(TTMSFNCBreadcrumbSeparator) do
    FSeparatorRadios[sp] := FLayout.AddRadio(FSettings, SeparatorNames[sp], 'Separator', sp = bcsChevron, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Behaviour');
  FEditCheck := FLayout.AddCheck(FSettings, 'Click the free space to type a path', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FTruncateCheck := FLayout.AddCheck(FSettings, 'A click on a segment drops what follows', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FKeepFirstCheck := FLayout.AddCheck(FSettings, 'Keep the first segment when collapsing', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FFramedCheck := FLayout.AddCheck(FSettings, 'Framed like an address bar', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FLayout.AddButton(FSettings, 'Go one level deeper', {$IFDEF WEBLIB}@{$ENDIF}DeeperClick);

  FLayout.AddCaption(FSettings, 'Events');
  FLog := FLayout.AddText(FSettings, 'Click a segment, a drop-down entry or type a path.', 160);
end;

procedure TForm1.CreateContent;
var
  it: TTMSFNCBreadcrumbItem;
begin
  FContent := FLayout.AddContentPanel(Self);

  { an explorer path with a drop-down of siblings after every segment }
  FLayout.AddCaption(FContent, 'Folders', 8);
  FExplorer := TTMSFNCBreadcrumb.Create(Self);
  FExplorer.Parent := FContent;
  FLayout.Place(FExplorer, daTop, 36, 16, 0, 16, 16);
  it := FExplorer.Items.AddItem('This PC', 'Folder');
  it.DropDownItems.CommaText := 'Desktop,Documents,Downloads,Music,Pictures';
  it := FExplorer.Items.AddItem('Documents');
  it.DropDownItems.CommaText := 'Invoices,Projects,Templates';
  it := FExplorer.Items.AddItem('Projects');
  it.DropDownItems.CommaText := '"TMS FNC Chart","TMS FNC UI Pack","TMS WEB Core"';
  FExplorer.Items.AddItem('TMS FNC UI Pack');
  FExplorer.OnItemClick := {$IFDEF WEBLIB}@{$ENDIF}ItemClick;
  FExplorer.OnPathChanged := {$IFDEF WEBLIB}@{$ENDIF}PathChanged;
  FExplorer.OnDropDownItemClick := {$IFDEF WEBLIB}@{$ENDIF}DropDownItemClick;
  FExplorer.OnPathEdit := {$IFDEF WEBLIB}@{$ENDIF}PathEdit;

  { the same path in a control too narrow for every segment }
  FLayout.AddCaption(FContent, 'Narrow: the middle collapses', 8);
  FNarrow := TTMSFNCBreadcrumb.Create(Self);
  FNarrow.Parent := FContent;
  FLayout.Place(FNarrow, daTop, 36, 16, 0, 16, 16);
  FNarrow.Width := FLayout.Size(320);
  {$IFDEF FMX}
  FNarrow.Align := TAlignLayout.None;
  FNarrow.Position.X := 16;
  {$ELSE}
  FNarrow.Align := alNone;
  FNarrow.Left := FLayout.Size(16);
  {$ENDIF}
  FNarrow.PathDelimiter := '\';
  FNarrow.Path := 'C:\Users\Public\Documents\Reports\2026\November';
  FNarrow.Items[0].IconName := 'Folder';
  FNarrow.OnPathChanged := {$IFDEF WEBLIB}@{$ENDIF}PathChanged;

  FLayout.AddText(FContent, 'Keyboard: Tab into the breadcrumb, move with the arrow keys, Enter opens a drop-down ' +
    'or follows a segment, F2 edits the path.', 44);
end;

procedure TForm1.ApplySettings;
var
  sp: TTMSFNCBreadcrumbSeparator;
  b: TTMSFNCBreadcrumb;
  I: Integer;
begin
  for I := 0 to 1 do
  begin
    if I = 0 then
      b := FExplorer
    else
      b := FNarrow;
    b.BeginUpdate;
    for sp := Low(TTMSFNCBreadcrumbSeparator) to High(TTMSFNCBreadcrumbSeparator) do
      if FSeparatorRadios[sp].Checked then
        b.Separator := sp;
    b.SeparatorText := '>';
    b.AllowEdit := FEditCheck.Checked;
    b.TruncateOnClick := FTruncateCheck.Checked;
    b.KeepFirstItem := FKeepFirstCheck.Checked;
    if FFramedCheck.Checked then
    begin
      b.Appearance.Fill.Kind := gfkSolid;
      b.Appearance.Stroke.Kind := gskSolid;
    end
    else
    begin
      b.Appearance.Fill.Kind := gfkNone;
      b.Appearance.Stroke.Kind := gskNone;
    end;
    b.EndUpdate;
  end;
end;

procedure TForm1.SettingChanged(Sender: TObject);
begin
  ApplySettings;
end;

procedure TForm1.Log(const AText: string);
begin
  FLog.Text := AText + '<br>' + FLog.Text;
end;

procedure TForm1.ItemClick(Sender: TObject; AIndex: Integer);
begin
  Log('Segment ' + IntToStr(AIndex) + ': <b>' + FExplorer.Items[AIndex].Text + '</b>');
end;

procedure TForm1.PathChanged(Sender: TObject);
begin
  Log('Path: ' + TTMSFNCBreadcrumb(Sender).Path);
end;

procedure TForm1.DropDownItemClick(Sender: TObject; AIndex, AEntry: Integer; const AText: string; var ANavigate: Boolean);
begin
  Log('Drop-down after segment ' + IntToStr(AIndex) + ': <b>' + AText + '</b>');
end;

procedure TForm1.PathEdit(Sender: TObject; var APath: string; var AAllow: Boolean);
begin
  { a typed path is accepted as is; an application would check that it exists }
  AAllow := APath <> '';
  if not AAllow then
    Log('An empty path is not accepted');
end;

procedure TForm1.DeeperClick(Sender: TObject);
begin
  FExplorer.Items.AddItem('Level ' + IntToStr(FExplorer.Items.Count + 1));
  FNarrow.Path := FNarrow.Path + '\Level ' + IntToStr(FNarrow.Items.Count + 1);
end;

end.
