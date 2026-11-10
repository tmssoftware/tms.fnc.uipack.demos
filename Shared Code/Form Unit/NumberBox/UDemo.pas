unit UDemo;

{ TMS FNC UI Pack - NumberBox

  Numeric input done right: integers, decimals, currency and percentages with spin buttons in three styles,
  a minimum and a maximum, a prefix or a suffix as the unit, an optional empty value and a placeholder. Type
  an expression such as 12*3+4 and the box shows the result before Enter confirms it; a value out of range or
  an invalid expression shows the error state. OnValidate adds the application's own rules. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCStackPanel, VCL.TMSFNCNumberBox, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCStackPanel, FMX.TMSFNCNumberBox, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton, WEBLib.TMSFNCStackPanel, WEBLib.TMSFNCNumberBox,
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
    FSpinRadios: array[TTMSFNCNumberBoxSpinButtons] of TTMSFNCRadioButton;
    FClearCheck: TTMSFNCCheckBox;
    FValues: TTMSFNCHTMLText;
    FBoxes: array of TTMSFNCNumberBox;
    FQuantity: TTMSFNCNumberBox;
    FPrice: TTMSFNCNumberBox;
    FDiscount: TTMSFNCNumberBox;
    FTotal: TTMSFNCNumberBox;
    function AddBox(AParent: TTMSFNCStackPanel; const ALabel: string): TTMSFNCNumberBox;
    procedure CreateSettings;
    procedure CreateContent;
    procedure ApplySettings;
    procedure SettingChanged(Sender: TObject);
    procedure BoxChange(Sender: TObject);
    procedure TemperatureValidate(Sender: TObject; AValue: Double; var AState: TTMSFNCNumberBoxValidationState);
    procedure UpdateTotal;
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
  UpdateTotal;
end;

procedure TForm1.CreateSettings;
const
  SpinNames: array[TTMSFNCNumberBoxSpinButtons] of string = ('No spin buttons', 'Inline, at the right edge',
    'Stacked up and down', 'One on each side');
var
  sb: TTMSFNCNumberBoxSpinButtons;
begin
  FSettings := FLayout.AddSettingsPanel(Self);

  FLayout.AddCaption(FSettings, 'Spin buttons');
  for sb := Low(TTMSFNCNumberBoxSpinButtons) to High(TTMSFNCNumberBoxSpinButtons) do
    FSpinRadios[sb] := FLayout.AddRadio(FSettings, SpinNames[sb], 'Spin', sb = nbsbInline, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FClearCheck := FLayout.AddCheck(FSettings, 'Clear button', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FLayout.AddText(FSettings, 'Spin with the buttons, the arrow keys or the mouse wheel; Shift steps by the ' +
    'large step. Enter confirms an expression, Escape restores the value.', 84);

  FLayout.AddCaption(FSettings, 'Order');
  FValues := FLayout.AddText(FSettings, '', 80);
end;

function TForm1.AddBox(AParent: TTMSFNCStackPanel; const ALabel: string): TTMSFNCNumberBox;
begin
  FLayout.AddCaption(AParent, ALabel, 8);
  Result := TTMSFNCNumberBox.Create(Self);
  Result.Parent := AParent;
  Result.Width := FLayout.Size(260);
  Result.Height := FLayout.Size(32);
  Result.OnChange := {$IFDEF WEBLIB}@{$ENDIF}BoxChange;
  SetLength(FBoxes, Length(FBoxes) + 1);
  FBoxes[High(FBoxes)] := Result;
end;

procedure TForm1.CreateContent;
var
  left, right: TTMSFNCStackPanel;
  nb: TTMSFNCNumberBox;
begin
  FContent := FLayout.AddContentPanel(Self);

  left := TTMSFNCStackPanel.Create(Self);
  left.Parent := FContent;
  FLayout.Place(left, daLeft, 300, 0, 0, 16, 0);
  left.Appearance.Stroke.Kind := gskNone;
  left.Gap := 4;
  right := TTMSFNCStackPanel.Create(Self);
  right.Parent := FContent;
  FLayout.Place(right, daLeft, 300, 0, 0, 16, 0);
  right.Appearance.Stroke.Kind := gskNone;
  right.Gap := 4;

  { an order line: quantity, price and discount make the total }
  FQuantity := AddBox(left, 'Quantity (1 to 99)');
  FQuantity.ValueType := nbvtInteger;
  FQuantity.MinValue := 1;
  FQuantity.MaxValue := 99;
  FQuantity.Value := 3;
  FPrice := AddBox(left, 'Unit price');
  FPrice.ValueType := nbvtCurrency;
  FPrice.CurrencySymbol := 'EUR';
  FPrice.Value := 249.5;
  FDiscount := AddBox(left, 'Discount');
  FDiscount.ValueType := nbvtPercentage;
  FDiscount.Decimals := 1;
  FDiscount.SmallStep := 0.5;
  FDiscount.MaxValue := 50;
  FDiscount.Value := 12.5;
  FTotal := AddBox(left, 'Total (read only)');
  FTotal.ValueType := nbvtCurrency;
  FTotal.CurrencySymbol := 'EUR';
  FTotal.ReadOnly := True;
  FTotal.SpinButtons := nbsbNone;

  { units, limits and states }
  nb := AddBox(right, 'Weight (up to 200 kg)');
  nb.Suffix := 'kg';
  nb.Decimals := 1;
  nb.MaxValue := 200;
  nb.Value := 72.5;
  nb := AddBox(right, 'Temperature (OnValidate warns above 38)');
  nb.Prefix := 'Body';
  nb.Suffix := #$B0'C';
  nb.Decimals := 1;
  nb.SmallStep := 0.1;
  nb.MinValue := 30;
  nb.MaxValue := 45;
  nb.Value := 36.6;
  nb.OnValidate := {$IFDEF WEBLIB}@{$ENDIF}TemperatureValidate;
  nb := AddBox(right, 'Optional (empty allowed)');
  nb.AllowEmpty := True;
  nb.Placeholder := 'Type a number or 12*3';
  nb.Empty := True;
  nb := AddBox(right, 'Disabled');
  nb.Value := 7.5;
  nb.Enabled := False;
end;

procedure TForm1.ApplySettings;
var
  I: Integer;
  sb: TTMSFNCNumberBoxSpinButtons;
begin
  for I := 0 to High(FBoxes) do
  begin
    if FBoxes[I] = FTotal then
      Continue;
    for sb := Low(TTMSFNCNumberBoxSpinButtons) to High(TTMSFNCNumberBoxSpinButtons) do
      if FSpinRadios[sb].Checked then
        FBoxes[I].SpinButtons := sb;
    FBoxes[I].ShowClearButton := FClearCheck.Checked;
  end;
end;

procedure TForm1.SettingChanged(Sender: TObject);
begin
  ApplySettings;
end;

procedure TForm1.BoxChange(Sender: TObject);
begin
  UpdateTotal;
end;

procedure TForm1.TemperatureValidate(Sender: TObject; AValue: Double; var AState: TTMSFNCNumberBoxValidationState);
begin
  if AValue >= 38 then
    AState := nbvsWarning
  else if AValue < 35 then
    AState := nbvsError
  else
    AState := nbvsValid;
end;

procedure TForm1.UpdateTotal;
var
  t: Double;
begin
  { OnChange also fires for a value set in code, so the first boxes report before the last one exists }
  if not Assigned(FTotal) then
    Exit;

  t := FQuantity.Value * FPrice.Value * (1 - FDiscount.Value / 100);
  FTotal.Value := t;
  FValues.Text := FormatFloat('0', FQuantity.Value) + ' x ' + FormatFloat('0.00', FPrice.Value) + ' EUR, ' +
    FormatFloat('0.0', FDiscount.Value) + '% off<br><b>' + FormatFloat('#,##0.00', t) + ' EUR</b>';
end;

end.
