unit UDemo;

{ TMS FNC UI Pack - HeaderControl

  Column headers as a file list or a table shows them: drag the border between two sections to resize one,
  double click the border to size it to its content, drag a section to another position, click a section to
  sort by it. The first section can be fixed, the last one stretched to the right edge; OffsetX scrolls the
  header together with the content below it. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCHeaderControl, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCHeaderControl, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton, WEBLib.TMSFNCHeaderControl, WEBLib.TMSFNCTheme,
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
    FNoSortRadio: TTMSFNCRadioButton;
    FSortRadio: TTMSFNCRadioButton;
    FTriStateRadio: TTMSFNCRadioButton;
    FResizeCheck: TTMSFNCCheckBox;
    FMoveCheck: TTMSFNCCheckBox;
    FStretchCheck: TTMSFNCCheckBox;
    FFixedCheck: TTMSFNCCheckBox;
    FLog: TTMSFNCHTMLText;
    FFiles: TTMSFNCHeaderControl;
    FTable: TTMSFNCHeaderControl;
    FRows: TTMSFNCHTMLText;
    procedure CreateSettings;
    procedure CreateContent;
    procedure ApplySettings;
    procedure SettingChanged(Sender: TObject);
    procedure SectionClick(Sender: TObject; ASection: TTMSFNCHeaderControlSection);
    procedure SectionResized(Sender: TObject; ASection: TTMSFNCHeaderControlSection);
    procedure SectionMoved(Sender: TObject; ASection: TTMSFNCHeaderControlSection; AFromIndex, AToIndex: Integer);
    procedure SortChanged(Sender: TObject; ASection: TTMSFNCHeaderControlSection; ASortIndicator: TTMSFNCHeaderControlSortIndicator);
    procedure SectionAutoSize(Sender: TObject; ASection: TTMSFNCHeaderControlSection; var AWidth: Single);
    procedure ScrollLeftClick(Sender: TObject);
    procedure ScrollRightClick(Sender: TObject);
    procedure Log(const AText: string);
    procedure UpdateRows;
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
  UpdateRows;
end;

procedure TForm1.CreateSettings;
begin
  FSettings := FLayout.AddSettingsPanel(Self);

  FLayout.AddCaption(FSettings, 'Sorting on click');
  FNoSortRadio := FLayout.AddRadio(FSettings, 'None', 'Sort', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FSortRadio := FLayout.AddRadio(FSettings, 'Ascending, descending', 'Sort', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FTriStateRadio := FLayout.AddRadio(FSettings, 'Ascending, descending, none', 'Sort', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Sections');
  FResizeCheck := FLayout.AddCheck(FSettings, 'Resize by dragging the border', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FMoveCheck := FLayout.AddCheck(FSettings, 'Move by dragging the section', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FStretchCheck := FLayout.AddCheck(FSettings, 'Stretch the last section', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FFixedCheck := FLayout.AddCheck(FSettings, 'Fixed first section in the table', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FLayout.AddButton(FSettings, 'Scroll the table left', {$IFDEF WEBLIB}@{$ENDIF}ScrollLeftClick);
  FLayout.AddButton(FSettings, 'Scroll the table right', {$IFDEF WEBLIB}@{$ENDIF}ScrollRightClick);

  FLayout.AddCaption(FSettings, 'Events');
  FLog := FLayout.AddText(FSettings, '', 140);
end;

procedure TForm1.CreateContent;
var
  s: TTMSFNCHeaderControlSection;
begin
  FContent := FLayout.AddContentPanel(Self);

  { a file list: name, date, type and a right aligned size }
  FLayout.AddCaption(FContent, 'Files', 8);
  FFiles := TTMSFNCHeaderControl.Create(Self);
  FFiles.Parent := FContent;
  FLayout.Place(FFiles, daTop, 34, 16, 0, 16, 0);
  FFiles.Sections.AddSection('Name', 220);
  FFiles.Sections.AddSection('Date modified', 150);
  FFiles.Sections.AddSection('Type', 120);
  FFiles.Sections.AddSection('Size', 100).Alignment := gtaTrailing;
  FFiles.SetSort(0, hsiAscending);
  FFiles.OnSectionClick := {$IFDEF WEBLIB}@{$ENDIF}SectionClick;
  FFiles.OnSectionResized := {$IFDEF WEBLIB}@{$ENDIF}SectionResized;
  FFiles.OnSectionMoved := {$IFDEF WEBLIB}@{$ENDIF}SectionMoved;
  FFiles.OnSortChanged := {$IFDEF WEBLIB}@{$ENDIF}SortChanged;
  FFiles.OnSectionAutoSize := {$IFDEF WEBLIB}@{$ENDIF}SectionAutoSize;
  FRows := TTMSFNCHTMLText.Create(Self);
  FRows.Parent := FContent;
  FLayout.Place(FRows, daTop, 120, 16, 0, 16, 16);
  FRows.Fill.Kind := gfkNone;
  FRows.Stroke.Kind := gskNone;
  FRows.HorizontalTextAlign := gtaLeading;
  FRows.VerticalTextAlign := gtaLeading;
  FRows.TextRole := htrSecondary;

  { a wide table: a fixed row number, the rest scrolls under it }
  FLayout.AddCaption(FContent, 'Table wider than its window', 8);
  FTable := TTMSFNCHeaderControl.Create(Self);
  FTable.Parent := FContent;
  FLayout.Place(FTable, daTop, 34, 16, 0, 16, 0);
  s := FTable.Sections.AddSection('#', 48);
  s.Fixed := True;
  s.Alignment := gtaCenter;
  s.AllowMove := False;
  FTable.Sections.AddSection('Customer', 220);
  FTable.Sections.AddSection('City', 160);
  FTable.Sections.AddSection('Country', 140);
  FTable.Sections.AddSection('Revenue', 140).Alignment := gtaTrailing;
  FTable.Sections.AddSection('Orders', 100).Alignment := gtaTrailing;
  FTable.Sections.AddSection('Notes', 240);
  FTable.SetSort(4, hsiDescending);
  FTable.OnSectionClick := {$IFDEF WEBLIB}@{$ENDIF}SectionClick;
  FTable.OnSectionResized := {$IFDEF WEBLIB}@{$ENDIF}SectionResized;
  FTable.OnSectionMoved := {$IFDEF WEBLIB}@{$ENDIF}SectionMoved;
  FTable.OnSortChanged := {$IFDEF WEBLIB}@{$ENDIF}SortChanged;
  FLayout.AddText(FContent, 'The scroll buttons on the left change OffsetX: an application sets it from the ' +
    'horizontal scroll position of the grid or list under the header.', 44);
end;

procedure TForm1.ApplySettings;
var
  I: Integer;
  h: TTMSFNCHeaderControl;
  J: Integer;
begin
  for I := 0 to 1 do
  begin
    if I = 0 then
      h := FFiles
    else
      h := FTable;
    h.BeginUpdate;
    if FNoSortRadio.Checked then
      h.SortMode := hsmNone
    else if FTriStateRadio.Checked then
      h.SortMode := hsmSingleTriState
    else
      h.SortMode := hsmSingle;
    h.StretchLastSection := FStretchCheck.Checked;
    for J := 0 to h.Sections.Count - 1 do
    begin
      h.Sections[J].AllowResize := FResizeCheck.Checked;
      h.Sections[J].AllowMove := FMoveCheck.Checked and ((h = FFiles) or (J > 0));
    end;
    h.EndUpdate;
  end;
  FTable.Sections[0].Fixed := FFixedCheck.Checked;
end;

procedure TForm1.SettingChanged(Sender: TObject);
begin
  ApplySettings;
end;

procedure TForm1.Log(const AText: string);
begin
  FLog.Text := AText + '<br>' + FLog.Text;
end;

procedure TForm1.UpdateRows;
const
  Names: array[0..3] of string = ('Budget 2026.xlsx', 'Contract draft.pdf', 'Logo.png', 'Release notes.docx');
  Dates: array[0..3] of string = ('28/10/2026', '30/10/2026', '14/10/2026', '05/11/2026');
  Types: array[0..3] of string = ('Spreadsheet', 'PDF', 'Image', 'Document');
  Sizes: array[0..3] of string = ('48 KB', '1.4 MB', '126 KB', '212 KB');
var
  I: Integer;
  s: string;
begin
  { four rows under the file header, in the order of its sections }
  s := '';
  for I := 0 to 3 do
    s := s + Names[I] + ' &nbsp; ' + Dates[I] + ' &nbsp; ' + Types[I] + ' &nbsp; ' + Sizes[I] + '<br>';
  FRows.Text := s;
end;

procedure TForm1.SectionClick(Sender: TObject; ASection: TTMSFNCHeaderControlSection);
begin
  Log('Click: <b>' + ASection.Text + '</b>');
end;

procedure TForm1.SectionResized(Sender: TObject; ASection: TTMSFNCHeaderControlSection);
begin
  Log('Resized: <b>' + ASection.Text + '</b> to ' + IntToStr(Round(ASection.Width)) + ' px');
end;

procedure TForm1.SectionMoved(Sender: TObject; ASection: TTMSFNCHeaderControlSection; AFromIndex, AToIndex: Integer);
begin
  Log('Moved: <b>' + ASection.Text + '</b> from ' + IntToStr(AFromIndex) + ' to ' + IntToStr(AToIndex));
end;

procedure TForm1.SortChanged(Sender: TObject; ASection: TTMSFNCHeaderControlSection; ASortIndicator: TTMSFNCHeaderControlSortIndicator);
const
  Names: array[TTMSFNCHeaderControlSortIndicator] of string = ('not sorted', 'ascending', 'descending');
begin
  if Assigned(ASection) then
    Log('Sort: <b>' + ASection.Text + '</b> ' + Names[ASortIndicator])
  else
    Log('Sort: ' + Names[ASortIndicator]);
end;

procedure TForm1.SectionAutoSize(Sender: TObject; ASection: TTMSFNCHeaderControlSection; var AWidth: Single);
begin
  { a double click on the border: the application knows the width its content needs }
  if ASection.Text = 'Name' then
    AWidth := 180
  else
    AWidth := 110;
  Log('Sized to content: <b>' + ASection.Text + '</b>');
end;

procedure TForm1.ScrollLeftClick(Sender: TObject);
begin
  if FTable.OffsetX >= 60 then
    FTable.OffsetX := FTable.OffsetX - 60
  else
    FTable.OffsetX := 0;
end;

procedure TForm1.ScrollRightClick(Sender: TObject);
begin
  FTable.OffsetX := FTable.OffsetX + 60;
end;

end.
