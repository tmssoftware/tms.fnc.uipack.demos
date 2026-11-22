unit UDemo;

{ TMS FNC UI Pack - MaskEdit

  Fields with an input mask: a phone number, a date, an IBAN, a postal code, a time and a product key. The mask
  uses the EditMask syntax of the VCL (0 digit, 9 optional digit, L letter, A letter or digit, > upper case, !
  leading blanks). A field left incomplete shows the error state; OnValidate can set the state from the
  application's own rules. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCStackPanel, VCL.TMSFNCMaskEdit, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCStackPanel, FMX.TMSFNCMaskEdit, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton, WEBLib.TMSFNCStackPanel, WEBLib.TMSFNCMaskEdit,
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
    FFocusedRadio: TTMSFNCRadioButton;
    FAlwaysRadio: TTMSFNCRadioButton;
    FClearCheck: TTMSFNCCheckBox;
    FValues: TTMSFNCHTMLText;
    FEdits: array of TTMSFNCMaskEdit;
    FPhone: TTMSFNCMaskEdit;
    FDate: TTMSFNCMaskEdit;
    function AddField(AParent: TTMSFNCStackPanel; const ALabel, AMask, APlaceholder: string): TTMSFNCMaskEdit;
    procedure CreateSettings;
    procedure CreateContent;
    procedure ApplySettings;
    procedure SettingChanged(Sender: TObject);
    procedure EditChange(Sender: TObject);
    procedure DateValidate(Sender: TObject; const AText: string; AComplete: Boolean; var AState: TTMSFNCValidationState);
    procedure FillClick(Sender: TObject);
    procedure ClearClick(Sender: TObject);
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
begin
  FSettings := FLayout.AddSettingsPanel(Self);

  FLayout.AddCaption(FSettings, 'Mask characters');
  FFocusedRadio := FLayout.AddRadio(FSettings, 'Shown while the field has the focus', 'Mask', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FAlwaysRadio := FLayout.AddRadio(FSettings, 'Always shown', 'Mask', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FClearCheck := FLayout.AddCheck(FSettings, 'Clear button', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FLayout.AddButton(FSettings, 'Fill in sample values', {$IFDEF WEBLIB}@{$ENDIF}FillClick);
  FLayout.AddButton(FSettings, 'Clear all', {$IFDEF WEBLIB}@{$ENDIF}ClearClick);

  FLayout.AddCaption(FSettings, 'Values');
  FValues := FLayout.AddText(FSettings, '', 180);
end;

function TForm1.AddField(AParent: TTMSFNCStackPanel; const ALabel, AMask, APlaceholder: string): TTMSFNCMaskEdit;
begin
  FLayout.AddCaption(AParent, ALabel, 8);
  Result := TTMSFNCMaskEdit.Create(Self);
  Result.Parent := AParent;
  Result.Width := FLayout.Size(300);
  Result.Height := FLayout.Size(32);
  Result.EditMask := AMask;
  Result.Placeholder := APlaceholder;
  Result.Hint := AMask;
  Result.OnChange := {$IFDEF WEBLIB}@{$ENDIF}EditChange;
  SetLength(FEdits, Length(FEdits) + 1);
  FEdits[High(FEdits)] := Result;
end;

procedure TForm1.CreateContent;
var
  left, right: TTMSFNCStackPanel;
  e: TTMSFNCMaskEdit;
begin
  FContent := FLayout.AddContentPanel(Self);

  left := TTMSFNCStackPanel.Create(Self);
  left.Parent := FContent;
  FLayout.Place(left, daLeft, 340, 0, 0, 16, 0);
  left.Appearance.Stroke.Kind := gskNone;
  left.Gap := 4;
  right := TTMSFNCStackPanel.Create(Self);
  right.Parent := FContent;
  FLayout.Place(right, daLeft, 340, 0, 0, 16, 0);
  right.Appearance.Stroke.Kind := gskNone;
  right.Gap := 4;

  FPhone := AddField(left, 'Phone', '!\(999\) 000-0000;1;_', '(555) 123-4567');
  FDate := AddField(left, 'Date of birth (dd/mm/yyyy, past)', '!99/99/0000;1;_', 'dd/mm/yyyy');
  FDate.OnValidate := {$IFDEF WEBLIB}@{$ENDIF}DateValidate;
  AddField(left, 'IBAN', '>LL00 AAAA 0000 0000 00;0;_', 'NL00 BANK 0000 0000 00');
  AddField(right, 'Postal code', '0000 >LL;1;_', '1234 AB');
  AddField(right, 'Start time', '!90:00;1;_', 'hh:mm');
  e := AddField(right, 'Product key', '>AAAAA-AAAAA-AAAAA;1;_', '');
  e.Text := 'X7K2P9QW4MT6RZ8';
  e := AddField(right, 'Licence (read only)', '>AAAA-0000;1;_', '');
  e.Text := 'TMSF2026';
  e.ReadOnly := True;

  FLayout.AddText(FContent, 'Tab through the fields. The date accepts only a past date; a field left half ' +
    'filled is marked as an error when it loses the focus, a complete one as valid.', 44);
end;

procedure TForm1.ApplySettings;
var
  I: Integer;
begin
  for I := 0 to High(FEdits) do
  begin
    if FAlwaysRadio.Checked then
      FEdits[I].MaskVisibility := memvAlways
    else
      FEdits[I].MaskVisibility := memvFocused;
    FEdits[I].ShowClearButton := FClearCheck.Checked and not FEdits[I].ReadOnly;
  end;
end;

procedure TForm1.SettingChanged(Sender: TObject);
begin
  ApplySettings;
end;

procedure TForm1.EditChange(Sender: TObject);
begin
  UpdateValues;
end;

procedure TForm1.DateValidate(Sender: TObject; const AText: string; AComplete: Boolean; var AState: TTMSFNCValidationState);
var
  d: TDateTime;
  fs: TFormatSettings;
begin
  { a complete date that lies in the past is valid, any other complete text is an error }
  if not AComplete then
    Exit;
  fs := TFormatSettings.Create;
  fs.DateSeparator := '/';
  fs.ShortDateFormat := 'dd/mm/yyyy';
  if TryStrToDate(AText, d, fs) and (d < Date) then
    AState := vlsValid
  else
    AState := vlsError;
end;

procedure TForm1.FillClick(Sender: TObject);
begin
  FEdits[0].Text := '5551234567';
  FEdits[1].Text := '07112001';
  FEdits[2].Text := 'NL91ABNA0417164300';
  FEdits[3].Text := '1234AB';
  FEdits[4].Text := '0930';
  UpdateValues;
end;

procedure TForm1.ClearClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to High(FEdits) do
    if not FEdits[I].ReadOnly then
      FEdits[I].Text := '';
  UpdateValues;
end;

procedure TForm1.UpdateValues;
var
  I: Integer;
  s: string;
begin
  { Text is the value without the mask literals, as an application stores it }
  s := '';
  for I := 0 to High(FEdits) do
    s := s + '<b>' + FEdits[I].Text + '</b><br>';
  FValues.Text := s;
end;

end.
