unit UDemo;

{ TMS FNC UI Pack - Knob

  Rotary knobs for volume, gain, balance and temperature: ticks and labels, a value format with a unit, the arc
  drawn from the minimum or from the centre, dot or line pointers. Turn a knob with the mouse (rotary or vertical
  drag), the mouse wheel or the arrow keys; a double click resets it. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCStackPanel, VCL.TMSFNCKnob, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCStackPanel, FMX.TMSFNCKnob, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton, WEBLib.TMSFNCStackPanel, WEBLib.TMSFNCKnob,
  WEBLib.TMSFNCTheme, WEBLib.TMSFNCThemeSelector,
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
    FPointerRadios: array[TTMSFNCKnobPointerStyle] of TTMSFNCRadioButton;
    FRotaryRadio: TTMSFNCRadioButton;
    FVerticalRadio: TTMSFNCRadioButton;
    FTicksCheck: TTMSFNCCheckBox;
    FLabelsCheck: TTMSFNCCheckBox;
    FValueCheck: TTMSFNCCheckBox;
    FReadOnlyCheck: TTMSFNCCheckBox;
    FValuesText: TTMSFNCHTMLText;
    FKnobs: array of TTMSFNCKnob;
    function AddKnob(AParent: TTMSFNCStackPanel; const ACaption: string; AMin, AMax, AValue: Double; ASize: Integer): TTMSFNCKnob;
    procedure CreateSettings;
    procedure CreateContent;
    procedure ApplySettings;
    procedure SettingChanged(Sender: TObject);
    procedure KnobChange(Sender: TObject);
    procedure ResetClick(Sender: TObject);
    procedure UpdateValues;
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
  UpdateValues;
end;

procedure TForm1.CreateSettings;
const
  PointerNames: array[TTMSFNCKnobPointerStyle] of string = ('Dot', 'Line', 'None');
var
  ps: TTMSFNCKnobPointerStyle;
begin
  FSettings := FLayout.AddSettingsPanel(Self);

  FLayout.AddCaption(FSettings, 'Pointer');
  for ps := Low(TTMSFNCKnobPointerStyle) to High(TTMSFNCKnobPointerStyle) do
    FPointerRadios[ps] := FLayout.AddRadio(FSettings, PointerNames[ps], 'Pointer', ps = kpsDot, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Drag mode');
  FRotaryRadio := FLayout.AddRadio(FSettings, 'Rotary: follow the pointer around the knob', 'Drag', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FVerticalRadio := FLayout.AddRadio(FSettings, 'Vertical: drag up and down', 'Drag', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Scale');
  FTicksCheck := FLayout.AddCheck(FSettings, 'Ticks', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FLabelsCheck := FLayout.AddCheck(FSettings, 'Labels at the major ticks', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FValueCheck := FLayout.AddCheck(FSettings, 'Value in the centre', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FReadOnlyCheck := FLayout.AddCheck(FSettings, 'Read only', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FLayout.AddButton(FSettings, 'Reset all', {$IFDEF WEBLIB}@{$ENDIF}ResetClick);

  FLayout.AddCaption(FSettings, 'Values');
  FValuesText := FLayout.AddText(FSettings, '', 120);
end;

function TForm1.AddKnob(AParent: TTMSFNCStackPanel; const ACaption: string; AMin, AMax, AValue: Double; ASize: Integer): TTMSFNCKnob;
begin
  Result := TTMSFNCKnob.Create(Self);
  Result.Parent := AParent;
  Result.Width := FLayout.Size(ASize);
  Result.Height := FLayout.Size(ASize);
  Result.Min := AMin;
  Result.Max := AMax;
  Result.Value := AValue;
  Result.ResetValue := AValue;
  Result.Caption := ACaption;
  Result.OnChange := {$IFDEF WEBLIB}@{$ENDIF}KnobChange;
  SetLength(FKnobs, Length(FKnobs) + 1);
  FKnobs[High(FKnobs)] := Result;
end;

procedure TForm1.CreateContent;
var
  row: TTMSFNCStackPanel;
  k: TTMSFNCKnob;
begin
  FContent := FLayout.AddContentPanel(Self);

  FLayout.AddCaption(FContent, 'Mixer', 8);
  row := TTMSFNCStackPanel.Create(Self);
  row.Parent := FContent;
  FLayout.Place(row, daTop, 200, 16, 0, 16, 8);
  row.Orientation := spoHorizontal;
  row.Alignment := lpaCenter;
  row.Gap := 32;
  row.ContentPadding.Rect := RectF(8, 8, 8, 8);

  { volume in percent }
  k := AddKnob(row, 'Volume', 0, 100, 64, 170);
  k.ValueFormat := '%.0f%%';

  { gain with half steps and labels at the major ticks }
  k := AddKnob(row, 'Gain', 0, 10, 7.5, 170);
  k.Step := 0.5;
  k.Decimals := 1;
  k.MinorTickCount := 1;

  { balance: the arc starts in the centre }
  k := AddKnob(row, 'Balance', -50, 50, -20, 170);
  k.ArcOrigin := kaoCenter;
  k.TickCount := 3;
  k.MinorTickCount := 4;

  { temperature: one decimal and a unit }
  k := AddKnob(row, 'Target', 10, 30, 21.5, 170);
  k.Step := 0.5;
  k.Decimals := 1;
  k.ValueFormat := '%.1f °C';
  k.TickCount := 5;

  FLayout.AddCaption(FContent, 'Compact', 8);
  row := TTMSFNCStackPanel.Create(Self);
  row.Parent := FContent;
  FLayout.Place(row, daTop, 110, 16, 0, 16, 8);
  row.Orientation := spoHorizontal;
  row.Alignment := lpaCenter;
  row.Gap := 32;
  row.ContentPadding.Rect := RectF(8, 8, 8, 8);
  k := AddKnob(row, 'Bass', -12, 12, 3, 84);
  k.TickCount := 3;
  k.ArcOrigin := kaoCenter;
  k.ValueFormat := '%.0f dB';
  k := AddKnob(row, 'Mid', -12, 12, 0, 84);
  k.TickCount := 3;
  k.ArcOrigin := kaoCenter;
  k.ValueFormat := '%.0f dB';
  k := AddKnob(row, 'Treble', -12, 12, -2, 84);
  k.TickCount := 3;
  k.ArcOrigin := kaoCenter;
  k.ValueFormat := '%.0f dB';
  k := AddKnob(row, 'Disabled', 0, 100, 70, 84);
  k.Enabled := False;

  FLayout.AddText(FContent, 'Hover a knob and use the mouse wheel, or focus it and use the arrow keys (Page Up and ' +
    'Page Down for large steps, Home and End for the limits). A double click returns the knob to its initial value.', 44);
end;

procedure TForm1.ApplySettings;
var
  I: Integer;
  ps: TTMSFNCKnobPointerStyle;
begin
  for I := 0 to High(FKnobs) do
  begin
    FKnobs[I].BeginUpdate;
    for ps := Low(TTMSFNCKnobPointerStyle) to High(TTMSFNCKnobPointerStyle) do
      if FPointerRadios[ps].Checked then
        FKnobs[I].PointerStyle := ps;
    if FVerticalRadio.Checked then
      FKnobs[I].DragMode := kdmVertical
    else
      FKnobs[I].DragMode := kdmRotary;
    FKnobs[I].ShowTicks := FTicksCheck.Checked;
    FKnobs[I].ShowLabels := FLabelsCheck.Checked;
    FKnobs[I].ShowValue := FValueCheck.Checked;
    FKnobs[I].ReadOnly := FReadOnlyCheck.Checked;
    FKnobs[I].EndUpdate;
  end;
end;

procedure TForm1.SettingChanged(Sender: TObject);
begin
  ApplySettings;
end;

procedure TForm1.KnobChange(Sender: TObject);
begin
  UpdateValues;
end;

procedure TForm1.ResetClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to High(FKnobs) do
    FKnobs[I].Value := FKnobs[I].ResetValue;
  UpdateValues;
end;

procedure TForm1.UpdateValues;
var
  I: Integer;
  s: string;
begin
  s := '';
  for I := 0 to High(FKnobs) do
    s := s + FKnobs[I].Caption + ': <b>' + FormatFloat('0.0#', FKnobs[I].Value) + '</b><br>';
  FValuesText.Text := s;
end;

end.
