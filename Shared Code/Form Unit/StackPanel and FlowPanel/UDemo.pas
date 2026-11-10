unit UDemo;

{ TMS FNC UI Pack - StackPanel and FlowPanel

  Layout without pixel positions: a stack panel puts its controls in a column or a row with a gap, aligns them
  across the axis and justifies them along it; a flow panel lets them flow like words and wrap to the next line.
  Both can size themselves to their content. Resize the window and watch the chips reflow. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCEdit, VCL.TMSFNCToolBar, VCL.TMSFNCStackPanel, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCEdit, FMX.TMSFNCToolBar, FMX.TMSFNCStackPanel, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton, WEBLib.TMSFNCEdit, WEBLib.TMSFNCToolBar,
  WEBLib.TMSFNCStackPanel, WEBLib.TMSFNCTheme, WEBLib.TMSFNCThemeSelector,
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
    FAlignRadios: array[TTMSFNCLayoutPanelAlignment] of TTMSFNCRadioButton;
    FJustifyRadios: array[TTMSFNCLayoutPanelJustify] of TTMSFNCRadioButton;
    FGapCheck: TTMSFNCCheckBox;
    FFrameCheck: TTMSFNCCheckBox;
    FColumn: TTMSFNCStackPanel;
    FRow: TTMSFNCStackPanel;
    FFlow: TTMSFNCFlowPanel;
    FCount: TTMSFNCHTMLText;
    function AddChip(AParent: TDemoParent; const AText: string): TTMSFNCToolBarButton;
    procedure CreateSettings;
    procedure CreateContent;
    procedure ApplySettings;
    procedure SettingChanged(Sender: TObject);
    procedure AddChipClick(Sender: TObject);
    procedure RemoveChipClick(Sender: TObject);
    function ChipCount: Integer;
    procedure UpdateCount;
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

const
  Tags: array[0..13] of string = ('Delphi', 'FMX', 'VCL', 'WEB Core', 'Cross-platform', 'Themes', 'Fluent',
    'High DPI', 'Dark mode', 'Accessibility', 'Touch', 'Keyboard', 'Data binding', 'Layout');

procedure TForm1.FormCreate(Sender: TObject);
begin
  FLayout := TDemoLayout.Create(Self);
  CreateSettings;
  CreateContent;
  ApplySettings;
  UpdateCount;
end;

procedure TForm1.CreateSettings;
const
  AlignNames: array[TTMSFNCLayoutPanelAlignment] of string = ('Stretch', 'Start', 'Centre', 'End');
  JustifyNames: array[TTMSFNCLayoutPanelJustify] of string = ('Start', 'Centre', 'End', 'Space between');
var
  al: TTMSFNCLayoutPanelAlignment;
  ju: TTMSFNCLayoutPanelJustify;
begin
  FSettings := FLayout.AddSettingsPanel(Self);

  FLayout.AddCaption(FSettings, 'Alignment across the axis');
  for al := Low(TTMSFNCLayoutPanelAlignment) to High(TTMSFNCLayoutPanelAlignment) do
    FAlignRadios[al] := FLayout.AddRadio(FSettings, AlignNames[al], 'Align', al = lpaStretch, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Justification along the axis');
  for ju := Low(TTMSFNCLayoutPanelJustify) to High(TTMSFNCLayoutPanelJustify) do
    FJustifyRadios[ju] := FLayout.AddRadio(FSettings, JustifyNames[ju], 'Justify', ju = lpjStart, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Panels');
  FGapCheck := FLayout.AddCheck(FSettings, 'Wide gap (16 instead of 6)', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FFrameCheck := FLayout.AddCheck(FSettings, 'Show the panel frames', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FLayout.AddButton(FSettings, 'Add a chip to the flow', {$IFDEF WEBLIB}@{$ENDIF}AddChipClick);
  FLayout.AddButton(FSettings, 'Remove the last chip', {$IFDEF WEBLIB}@{$ENDIF}RemoveChipClick);
  FCount := FLayout.AddText(FSettings, '', 40);
end;

function TForm1.AddChip(AParent: TDemoParent; const AText: string): TTMSFNCToolBarButton;
begin
  Result := TTMSFNCToolBarButton.Create(Self);
  Result.Parent := AParent;
  Result.Text := AText;
  Result.Width := FLayout.Size(24 + 7 * Length(AText));
  Result.Height := FLayout.Size(28);
end;

procedure TForm1.CreateContent;
var
  e: TTMSFNCEdit;
  I: Integer;
begin
  FContent := FLayout.AddContentPanel(Self);

  { a column of fields: a form without positions }
  FLayout.AddCaption(FContent, 'Stack panel, vertical', 8);
  FColumn := TTMSFNCStackPanel.Create(Self);
  FColumn.Parent := FContent;
  FLayout.Place(FColumn, daLeft, 280, 16, 0, 16, 0);
  FColumn.Appearance.Rounding := 8;
  FColumn.ContentPadding.Rect := RectF(12, 12, 12, 12);
  for I := 0 to 2 do
  begin
    e := TTMSFNCEdit.Create(Self);
    e.Parent := FColumn;
    e.Width := FLayout.Size(200);
    e.Height := FLayout.Size(32);
    case I of
      0: e.Text := 'Ada Lovelace';
      1: e.Text := 'ada@example.com';
    else
      e.Text := '+32 3 123 45 67';
    end;
  end;
  FLayout.AddCheck(FColumn, 'Send me the newsletter', True, nil);
  FLayout.AddCheck(FColumn, 'Two-step verification', False, nil);
  FLayout.AddButton(FColumn, 'Save', nil).Default := True;

  { a row of chips: the horizontal stack }
  FLayout.AddCaption(FContent, 'Stack panel, horizontal', 8);
  FRow := TTMSFNCStackPanel.Create(Self);
  FRow.Parent := FContent;
  FLayout.Place(FRow, daTop, 56, 16, 0, 16, 16);
  FRow.Orientation := spoHorizontal;
  FRow.Appearance.Rounding := 8;
  FRow.ContentPadding.Rect := RectF(12, 8, 12, 8);
  AddChip(FRow, 'Draft');
  AddChip(FRow, 'In review');
  AddChip(FRow, 'Approved');
  AddChip(FRow, 'Published');

  { chips that wrap }
  FLayout.AddCaption(FContent, 'Flow panel', 8);
  FFlow := TTMSFNCFlowPanel.Create(Self);
  FFlow.Parent := FContent;
  FLayout.Place(FFlow, daTop, 120, 16, 0, 16, 0);
  FFlow.Appearance.Rounding := 8;
  FFlow.ContentPadding.Rect := RectF(12, 12, 12, 12);
  FFlow.SizeToContent := True;
  for I := 0 to High(Tags) do
    AddChip(FFlow, Tags[I]);
end;

procedure TForm1.ApplySettings;
var
  al: TTMSFNCLayoutPanelAlignment;
  ju: TTMSFNCLayoutPanelJustify;
  gap: Integer;
begin
  if FGapCheck.Checked then
    gap := 16
  else
    gap := 6;
  FColumn.BeginUpdate;
  FRow.BeginUpdate;
  FFlow.BeginUpdate;
  for al := Low(TTMSFNCLayoutPanelAlignment) to High(TTMSFNCLayoutPanelAlignment) do
    if FAlignRadios[al].Checked then
    begin
      FColumn.Alignment := al;
      FRow.Alignment := al;
      FFlow.ItemAlignment := al;
    end;
  for ju := Low(TTMSFNCLayoutPanelJustify) to High(TTMSFNCLayoutPanelJustify) do
    if FJustifyRadios[ju].Checked then
    begin
      FColumn.Justify := ju;
      FRow.Justify := ju;
      FFlow.Justify := ju;
    end;
  FColumn.Gap := gap;
  FRow.Gap := gap;
  FFlow.HorizontalGap := gap;
  FFlow.VerticalGap := gap;
  if FFrameCheck.Checked then
  begin
    FColumn.Appearance.Stroke.Kind := gskSolid;
    FRow.Appearance.Stroke.Kind := gskSolid;
    FFlow.Appearance.Stroke.Kind := gskDash;
  end
  else
  begin
    FColumn.Appearance.Stroke.Kind := gskNone;
    FRow.Appearance.Stroke.Kind := gskNone;
    FFlow.Appearance.Stroke.Kind := gskNone;
  end;
  FColumn.EndUpdate;
  FRow.EndUpdate;
  FFlow.EndUpdate;
end;

procedure TForm1.SettingChanged(Sender: TObject);
begin
  ApplySettings;
end;

function TForm1.ChipCount: Integer;
begin
  Result := FFlow.{$IFDEF FMX}ControlsCount{$ELSE}ControlCount{$ENDIF};
end;

procedure TForm1.UpdateCount;
begin
  FCount.Text := IntToStr(ChipCount) + ' chips in the flow panel';
end;

procedure TForm1.AddChipClick(Sender: TObject);
begin
  AddChip(FFlow, Tags[ChipCount mod Length(Tags)] + ' ' + IntToStr(ChipCount + 1));
  UpdateCount;
end;

procedure TForm1.RemoveChipClick(Sender: TObject);
var
  c: TControl;
begin
  if ChipCount > 0 then
  begin
    c := FFlow.Controls[ChipCount - 1];
    c.Free;
  end;
  UpdateCount;
end;

end.
