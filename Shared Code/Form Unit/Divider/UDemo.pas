unit UDemo;

{ TMS FNC UI Pack - Divider

  Dividers separate sections of a page: horizontal between blocks of content, vertical between columns, with or
  without a text at the start, the centre or the end, a solid or dashed line, indents and ends that fade out.
  The settings change every divider on the page. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCDivider, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCDivider, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton, WEBLib.TMSFNCDivider, WEBLib.TMSFNCTheme,
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
    FPositionRadios: array[TTMSFNCDividerTextPosition] of TTMSFNCRadioButton;
    FTextCheck: TTMSFNCCheckBox;
    FDashCheck: TTMSFNCCheckBox;
    FFadeCheck: TTMSFNCCheckBox;
    FIndentCheck: TTMSFNCCheckBox;
    FDividers: array of TTMSFNCDivider;
    FTexts: array of string;
    function AddParagraph(AParent: TDemoParent; const AText: string; AHeight: Integer): TTMSFNCHTMLText;
    function AddDivider(AParent: TDemoParent; const AText: string): TTMSFNCDivider;
    procedure CreateSettings;
    procedure CreateContent;
    procedure ApplySettings;
    procedure SettingChanged(Sender: TObject);
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
  PositionNames: array[TTMSFNCDividerTextPosition] of string = ('Start', 'Centre', 'End');
var
  tp: TTMSFNCDividerTextPosition;
begin
  FSettings := FLayout.AddSettingsPanel(Self);

  FLayout.AddCaption(FSettings, 'Text');
  FTextCheck := FLayout.AddCheck(FSettings, 'Show the text', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  for tp := Low(TTMSFNCDividerTextPosition) to High(TTMSFNCDividerTextPosition) do
    FPositionRadios[tp] := FLayout.AddRadio(FSettings, PositionNames[tp], 'Position', tp = dtpCenter, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Line');
  FDashCheck := FLayout.AddCheck(FSettings, 'Dashed', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FFadeCheck := FLayout.AddCheck(FSettings, 'Fade the ends', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FIndentCheck := FLayout.AddCheck(FSettings, 'Indent 24 px', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FLayout.AddText(FSettings, 'The line colour comes from the theme; the text uses the secondary text colour. ' +
    'A divider without text is a plain rule.', 64);
end;

function TForm1.AddParagraph(AParent: TDemoParent; const AText: string; AHeight: Integer): TTMSFNCHTMLText;
begin
  Result := TTMSFNCHTMLText.Create(Self);
  Result.Parent := AParent;
  FLayout.Place(Result, daTop, AHeight, 16, 0, 16, 0);
  Result.Text := AText;
  Result.HorizontalTextAlign := gtaLeading;
  Result.VerticalTextAlign := gtaLeading;
  Result.WordWrapping := True;
  Result.Fill.Kind := gfkNone;
  Result.Stroke.Kind := gskNone;
end;

function TForm1.AddDivider(AParent: TDemoParent; const AText: string): TTMSFNCDivider;
begin
  Result := TTMSFNCDivider.Create(Self);
  Result.Parent := AParent;
  FLayout.Place(Result, daTop, 32, 0, 0, 0, 0);
  Result.Text := AText;
  SetLength(FDividers, Length(FDividers) + 1);
  FDividers[High(FDividers)] := Result;
  SetLength(FTexts, Length(FDividers));
  FTexts[High(FTexts)] := AText;
end;

procedure TForm1.CreateContent;
var
  columns, col: TTMSFNCPanel;
  d: TTMSFNCDivider;
begin
  FContent := FLayout.AddContentPanel(Self);

  { an article: dividers between its parts }
  AddParagraph(FContent, '<b>Release notes</b><br>Version 8.0 brings themes to every control, a set of new ' +
    'controls and data binding without adapter components.', 56);
  AddDivider(FContent, 'New controls');
  AddParagraph(FContent, 'Avatar, Breadcrumb, CardPanel, ControlList, Divider, GroupBox, HeaderControl, Knob, ' +
    'ListView, MaskEdit, MenuBar, NumberBox, ScrollBox, Skeleton, SplitView, StackPanel, Stepper, TagEdit and Toast.', 56);
  AddDivider(FContent, 'Data');
  AddParagraph(FContent, 'A DataSource on the grid, the tree view, the planner and the editors binds them to any ' +
    'TDataSet; the data navigator drives them all.', 40);
  AddDivider(FContent, '');

  { two columns separated by a vertical divider }
  columns := FLayout.AddPanel(FContent, daTop, 150, 16, 8, 16, 0);
  columns.Fill.Kind := gfkNone;
  columns.Stroke.Kind := gskNone;
  col := FLayout.AddPanel(columns, daLeft, 300, 0, 0, 0, 0);
  col.Fill.Kind := gfkNone;
  col.Stroke.Kind := gskNone;
  AddParagraph(col, '<b>Desktop</b><br>Windows and macOS with FireMonkey, Windows with the VCL. Every demo is one ' +
    'form unit shared by the frameworks.', 120);
  d := AddDivider(columns, 'or');
  FLayout.Place(d, daLeft, 32, 0, 0, 0, 0);
  d.Orientation := dvoVertical;
  col := FLayout.AddPanel(columns, daClient, 0, 0, 0, 0, 0);
  col.Fill.Kind := gfkNone;
  col.Stroke.Kind := gskNone;
  AddParagraph(col, '<b>Web</b><br>The same unit compiled with TMS WEB Core runs in the browser; the theme manager ' +
    'colours the page as it colours the window.', 120);
end;

procedure TForm1.ApplySettings;
var
  I: Integer;
  d: TTMSFNCDivider;
  tp: TTMSFNCDividerTextPosition;
begin
  for I := 0 to High(FDividers) do
  begin
    d := FDividers[I];
    d.BeginUpdate;
    for tp := Low(TTMSFNCDividerTextPosition) to High(TTMSFNCDividerTextPosition) do
      if FPositionRadios[tp].Checked then
        d.TextPosition := tp;
    if FTextCheck.Checked then
      d.Text := FTexts[I]
    else
      d.Text := '';
    if FDashCheck.Checked then
      d.Appearance.Stroke.Kind := gskDash
    else
      d.Appearance.Stroke.Kind := gskSolid;
    d.Appearance.FadeEnds := FFadeCheck.Checked;
    if FIndentCheck.Checked then
    begin
      d.Appearance.StartIndent := 24;
      d.Appearance.EndIndent := 24;
    end
    else
    begin
      d.Appearance.StartIndent := 0;
      d.Appearance.EndIndent := 0;
    end;
    d.EndUpdate;
  end;
end;

procedure TForm1.SettingChanged(Sender: TObject);
begin
  ApplySettings;
end;

end.
