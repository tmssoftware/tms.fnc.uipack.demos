unit UDemo;

{ TMS FNC UI Pack - ScrollBox

  A scroll box with the themed overlay scroll bars: thin indicators that appear while scrolling and grow when
  the mouse comes near, or bars that are always there. Scroll with the wheel, by dragging the content, with
  inertia that keeps it rolling, or with the keyboard; a sticky control stays at the top while the content
  moves under it. The left box holds a long settings form, the right one tiles that scroll both ways. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCEdit, VCL.TMSFNCStackPanel, VCL.TMSFNCCardPanel, VCL.TMSFNCHeaderControl, VCL.TMSFNCScrollBox,
  VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCEdit, FMX.TMSFNCStackPanel, FMX.TMSFNCCardPanel, FMX.TMSFNCHeaderControl, FMX.TMSFNCScrollBox,
  FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton, WEBLib.TMSFNCEdit, WEBLib.TMSFNCStackPanel,
  WEBLib.TMSFNCCardPanel, WEBLib.TMSFNCHeaderControl, WEBLib.TMSFNCScrollBox, WEBLib.TMSFNCTheme,
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
    FAutoHideRadio: TTMSFNCRadioButton;
    FAlwaysRadio: TTMSFNCRadioButton;
    FNeverRadio: TTMSFNCRadioButton;
    FDragCheck: TTMSFNCCheckBox;
    FInertiaCheck: TTMSFNCCheckBox;
    FSmoothCheck: TTMSFNCCheckBox;
    FStickyCheck: TTMSFNCCheckBox;
    FPosition: TTMSFNCHTMLText;
    FForm: TTMSFNCScrollBox;
    FTiles: TTMSFNCScrollBox;
    FFormHeader: TTMSFNCHeaderControl;
    procedure CreateSettings;
    procedure CreateContent;
    procedure ApplySettings;
    procedure SettingChanged(Sender: TObject);
    procedure BoxScroll(Sender: TObject);
    procedure TopClick(Sender: TObject);
    procedure LastClick(Sender: TObject);
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
  Options: array[0..15] of string = ('Automatic updates', 'Download over metered connections',
    'Restart notifications', 'Delivery optimisation', 'Active hours', 'Optional updates', 'Pause updates',
    'Insider programme', 'Notifications', 'Focus assist', 'Clipboard history', 'Nearby sharing', 'Storage sense',
    'Battery saver', 'Night light', 'Default browser');

procedure TForm1.FormCreate(Sender: TObject);
begin
  FLayout := TDemoLayout.Create(Self);
  CreateSettings;
  CreateContent;
  ApplySettings;
end;

procedure TForm1.CreateSettings;
begin
  FSettings := FLayout.AddSettingsPanel(Self);

  FLayout.AddCaption(FSettings, 'Scroll bars');
  FAutoHideRadio := FLayout.AddRadio(FSettings, 'Overlay, hidden when idle', 'Bars', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FAlwaysRadio := FLayout.AddRadio(FSettings, 'Always visible', 'Bars', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FNeverRadio := FLayout.AddRadio(FSettings, 'Never (wheel and drag only)', 'Bars', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Scrolling');
  FDragCheck := FLayout.AddCheck(FSettings, 'Drag the content', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FInertiaCheck := FLayout.AddCheck(FSettings, 'Inertia after a drag', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FSmoothCheck := FLayout.AddCheck(FSettings, 'Smooth wheel scrolling', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FStickyCheck := FLayout.AddCheck(FSettings, 'Header stays at the top', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FLayout.AddButton(FSettings, 'Scroll the form to the top', {$IFDEF WEBLIB}@{$ENDIF}TopClick);
  FLayout.AddButton(FSettings, 'Bring the last field into view', {$IFDEF WEBLIB}@{$ENDIF}LastClick);

  FLayout.AddCaption(FSettings, 'Position');
  FPosition := FLayout.AddText(FSettings, '', 60);
end;

procedure TForm1.CreateContent;
var
  stack: TTMSFNCStackPanel;
  flow: TTMSFNCFlowPanel;
  e: TTMSFNCEdit;
  c: TTMSFNCCardPanel;
  I: Integer;
begin
  FContent := FLayout.AddContentPanel(Self);

  { a long form: a header control pinned above a stack of edits }
  FForm := TTMSFNCScrollBox.Create(Self);
  FForm.Parent := FContent;
  FLayout.Place(FForm, daLeft, 320, 0, 0, 16, 0);
  FForm.Appearance.Fill.Kind := gfkSolid;
  FForm.Appearance.Stroke.Kind := gskSolid;
  FForm.Appearance.Rounding := 8;
  FForm.OnScroll := {$IFDEF WEBLIB}@{$ENDIF}BoxScroll;
  FFormHeader := TTMSFNCHeaderControl.Create(Self);
  FFormHeader.Parent := FForm;
  FFormHeader.SetBounds(FLayout.Size(1), FLayout.Size(1), FLayout.Size(300), FLayout.Size(32));
  FFormHeader.Sections.AddSection('Setting', 200);
  FFormHeader.Sections.AddSection('Value', 100);
  FFormHeader.SortMode := hsmNone;
  FFormHeader.StretchLastSection := True;
  stack := TTMSFNCStackPanel.Create(Self);
  stack.Parent := FForm;
  stack.SetBounds(FLayout.Size(1), FLayout.Size(33), FLayout.Size(300), FLayout.Size(100));
  stack.SizeToContent := True;
  stack.ContentPadding.Rect := RectF(12, 8, 12, 8);
  stack.Gap := 6;
  for I := 0 to High(Options) do
  begin
    FLayout.AddCaption(stack, Options[I], 4);
    e := TTMSFNCEdit.Create(Self);
    e.Parent := stack;
    e.Width := FLayout.Size(270);
    e.Height := FLayout.Size(32);
    e.Text := 'Value ' + IntToStr(I + 1);
    e.Name := 'Field' + IntToStr(I + 1);
  end;
  FForm.UpdateContent;

  { tiles wider and taller than the box: both scroll bars }
  FTiles := TTMSFNCScrollBox.Create(Self);
  FTiles.Parent := FContent;
  FLayout.Place(FTiles, daClient, 0, 0, 0, 0, 0);
  FTiles.Appearance.Fill.Kind := gfkSolid;
  FTiles.Appearance.Stroke.Kind := gskSolid;
  FTiles.Appearance.Rounding := 8;
  FTiles.OnScroll := {$IFDEF WEBLIB}@{$ENDIF}BoxScroll;
  flow := TTMSFNCFlowPanel.Create(Self);
  flow.Parent := FTiles;
  flow.SetBounds(FLayout.Size(12), FLayout.Size(12), FLayout.Size(900), FLayout.Size(100));
  flow.SizeToContent := True;
  flow.HorizontalGap := 12;
  flow.VerticalGap := 12;
  for I := 1 to 24 do
  begin
    c := TTMSFNCCardPanel.Create(Self);
    c.Parent := flow;
    c.Width := FLayout.Size(210);
    c.Height := FLayout.Size(130);
    c.Header.Text := 'Tile ' + IntToStr(I);
    c.Header.Description := 'Scrolls in both directions';
  end;
  FTiles.UpdateContent;
end;

procedure TForm1.ApplySettings;
var
  I: Integer;
  b: TTMSFNCScrollBox;
begin
  for I := 0 to 1 do
  begin
    if I = 0 then
      b := FForm
    else
      b := FTiles;
    b.BeginUpdate;
    if FAlwaysRadio.Checked then
      b.ScrollBarVisibility := sbvAlways
    else if FNeverRadio.Checked then
      b.ScrollBarVisibility := sbvNever
    else
      b.ScrollBarVisibility := sbvAutoHide;
    b.DragScrolling := FDragCheck.Checked;
    b.Inertia := FInertiaCheck.Checked;
    b.SmoothScrolling := FSmoothCheck.Checked;
    b.EndUpdate;
  end;
  if FStickyCheck.Checked then
    FForm.StickyControl := FFormHeader
  else
    FForm.StickyControl := nil;
end;

procedure TForm1.SettingChanged(Sender: TObject);
begin
  ApplySettings;
end;

procedure TForm1.BoxScroll(Sender: TObject);
begin
  FPosition.Text := 'Form: ' + IntToStr(Round(FForm.ScrollY)) + ' of ' + IntToStr(Round(FForm.MaxScrollY)) +
    '<br>Tiles: ' + IntToStr(Round(FTiles.ScrollX)) + ', ' + IntToStr(Round(FTiles.ScrollY)) +
    ' of ' + IntToStr(Round(FTiles.MaxScrollX)) + ', ' + IntToStr(Round(FTiles.MaxScrollY));
end;

procedure TForm1.TopClick(Sender: TObject);
begin
  FForm.ScrollTo(0, 0, True);
end;

procedure TForm1.LastClick(Sender: TObject);
var
  c: TComponent;
begin
  c := FindComponent('Field' + IntToStr(Length(Options)));
  if c is TControl then
    FForm.ScrollInView(TControl(c), True);
end;

end.
