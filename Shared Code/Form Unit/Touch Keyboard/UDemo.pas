unit UDemo;

{ TMS FNC UI Pack - Touch Keyboard

  An on-screen keyboard that types into the control with the focus: QWERTY, AZERTY, QWERTZ, DVORAK, a numeric
  pad and a phone layout, with the caps and AltGr keys highlighted and the keys scaling with the control.
  The pop-up keyboard appears on request below the form and closes by itself; the Fluent look follows the
  theme. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCEdit, VCL.TMSFNCMemo, VCL.TMSFNCStackPanel, VCL.TMSFNCTouchKeyboard, VCL.TMSFNCTheme,
  VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCEdit, FMX.TMSFNCMemo, FMX.TMSFNCStackPanel, FMX.TMSFNCTouchKeyboard, FMX.TMSFNCTheme,
  FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton, WEBLib.TMSFNCEdit, WEBLib.TMSFNCMemo, WEBLib.TMSFNCStackPanel,
  WEBLib.TMSFNCTouchKeyboard, WEBLib.TMSFNCTheme, WEBLib.TMSFNCThemeSelector,
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
    FTypeRadios: array[0..5] of TTMSFNCRadioButton;
    FCapsCheck: TTMSFNCCheckBox;
    FZoomCheck: TTMSFNCCheckBox;
    FStatus: TTMSFNCHTMLText;
    FKeyboard: TTMSFNCTouchKeyboard;
    FPopup: TTMSFNCPopupTouchKeyboard;
    FName: TTMSFNCEdit;
    FAmount: TTMSFNCEdit;
    FNotes: TTMSFNCMemo;
    procedure CreateSettings;
    procedure CreateContent;
    function AddField(AParent: TTMSFNCStackPanel; const ALabel: string): TTMSFNCEdit;
    procedure ApplySettings;
    procedure SettingChanged(Sender: TObject);
    procedure KeyClick(Sender: TObject; AIndex: Integer);
    procedure PopupClick(Sender: TObject);
    procedure PopupClosed(Sender: TObject);
    procedure AmountEnter(Sender: TObject);
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
  TypeNames: array[0..5] of string = ('QWERTY', 'AZERTY', 'QWERTZ', 'DVORAK', 'Numeric pad', 'Phone');
  Types: array[0..5] of TTMSFNCKeyboardType = (ktQWERTY, ktAZERTY, ktQWERTZ, ktDVORAK, ktNUMERIC, ktCELLPHONE);

procedure TForm1.FormCreate(Sender: TObject);
begin
  FLayout := TDemoLayout.Create(Self);
  CreateSettings;
  CreateContent;
  ApplySettings;
end;

procedure TForm1.CreateSettings;
var
  I: Integer;
begin
  FSettings := FLayout.AddSettingsPanel(Self);

  FLayout.AddCaption(FSettings, 'Layout');
  for I := 0 to High(TypeNames) do
    FTypeRadios[I] := FLayout.AddRadio(FSettings, TypeNames[I], 'Type', I = 0, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Options');
  FCapsCheck := FLayout.AddCheck(FSettings, 'Highlight Caps Lock and AltGr', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FZoomCheck := FLayout.AddCheck(FSettings, 'Keys scale with the control', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Pop-up keyboard');
  FLayout.AddButton(FSettings, 'Show the pop-up keyboard', {$IFDEF WEBLIB}@{$ENDIF}PopupClick);
  FLayout.AddText(FSettings, 'The amount field opens the numeric pop-up by itself when it gets the focus.', 44);

  FLayout.AddCaption(FSettings, 'Last key');
  FStatus := FLayout.AddText(FSettings, 'Click a key on the keyboard.', 44);
end;

function TForm1.AddField(AParent: TTMSFNCStackPanel; const ALabel: string): TTMSFNCEdit;
begin
  FLayout.AddCaption(AParent, ALabel, 8);
  Result := TTMSFNCEdit.Create(Self);
  Result.Parent := AParent;
  Result.Width := FLayout.Size(260);
  Result.Height := FLayout.Size(32);
end;

procedure TForm1.CreateContent;
var
  form: TTMSFNCStackPanel;
begin
  FContent := FLayout.AddContentPanel(Self);

  { the fields the keyboard types into: the one with the focus receives the keys }
  form := TTMSFNCStackPanel.Create(Self);
  form.Parent := FContent;
  FLayout.Place(form, daLeft, 292, 0, 0, 16, 0);
  form.Appearance.Stroke.Kind := gskNone;
  form.Gap := 4;
  FName := AddField(form, 'Name');
  FName.Text := 'Click here, then type on the keyboard';
  FAmount := AddField(form, 'Amount (numeric pop-up)');
  FAmount.OnEnter := {$IFDEF WEBLIB}@{$ENDIF}AmountEnter;
  FLayout.AddCaption(form, 'Notes', 8);
  FNotes := TTMSFNCMemo.Create(Self);
  FNotes.Parent := form;
  FNotes.Width := FLayout.Size(260);
  FNotes.Height := FLayout.Size(160);
  FNotes.Text := 'Enter, Backspace and the arrow keys work as on a real keyboard.';

  { the keyboard itself, filling the rest }
  FKeyboard := TTMSFNCTouchKeyboard.Create(Self);
  FKeyboard.Parent := FContent;
  FLayout.Place(FKeyboard, daClient, 0, 0, 0, 0, 0);
  FKeyboard.OnKeyClick := {$IFDEF WEBLIB}@{$ENDIF}KeyClick;

  { the pop-up keyboard: numeric, for the amount }
  FPopup := TTMSFNCPopupTouchKeyboard.Create(Self);
  FPopup.KeyboardType := ktNUMERIC;
  FPopup.OnClose := {$IFDEF WEBLIB}@{$ENDIF}PopupClosed;
end;

procedure TForm1.ApplySettings;
var
  I: Integer;
begin
  FKeyboard.BeginUpdate;
  for I := 0 to High(Types) do
    if FTypeRadios[I].Checked then
      FKeyboard.KeyboardType := Types[I];
  if FCapsCheck.Checked then
  begin
    FKeyboard.HighlightCaps := gcNull;
    FKeyboard.HighlightAltGr := gcNull;
  end
  else
  begin
    { demo-colors: the highlight off is the key colour itself (gcNull means the theme's accent) }
    FKeyboard.HighlightCaps := FKeyboard.Fill.Color;
    FKeyboard.HighlightAltGr := FKeyboard.Fill.Color;
  end;
  FKeyboard.AllowAutoZoom := FZoomCheck.Checked;
  FKeyboard.EndUpdate;
  if FZoomCheck.Checked then
    FKeyboard.AutoZoom;
end;

procedure TForm1.SettingChanged(Sender: TObject);
begin
  ApplySettings;
end;

procedure TForm1.KeyClick(Sender: TObject; AIndex: Integer);
var
  k: TTMSFNCTouchKeyItem;
begin
  k := FKeyboard.Keys[AIndex];
  if k.Caption <> '' then
    FStatus.Text := 'Key <b>' + k.Caption + '</b> (index ' + IntToStr(AIndex) + ')'
  else
    FStatus.Text := 'Key index ' + IntToStr(AIndex);
end;

procedure TForm1.PopupClick(Sender: TObject);
begin
  FName.SetFocus;
  FPopup.KeyboardType := ktQWERTY;
  FPopup.ShowKeyboard;
end;

procedure TForm1.PopupClosed(Sender: TObject);
begin
  FStatus.Text := 'The pop-up keyboard closed.';
end;

procedure TForm1.AmountEnter(Sender: TObject);
begin
  FPopup.KeyboardType := ktNUMERIC;
  FPopup.ShowKeyboard;
end;

end.
