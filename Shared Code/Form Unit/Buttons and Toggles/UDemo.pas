unit UDemo;

{ TMS FNC UI Pack - Buttons and Toggles

  The controls every form is made of, under the theme: buttons in the classic and the Fluent look with a primary
  default button, switches, check boxes and radio buttons, enabled and disabled. Switch the theme in the header
  and the look of every control changes with it; clear the theme to see the released appearance. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCSwitch, VCL.TMSFNCStackPanel, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCSwitch, FMX.TMSFNCStackPanel, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton, WEBLib.TMSFNCSwitch, WEBLib.TMSFNCStackPanel,
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
    FThemedCheck: TTMSFNCCheckBox;
    FFluentRadio: TTMSFNCRadioButton;
    FClassicRadio: TTMSFNCRadioButton;
    FEnabledCheck: TTMSFNCCheckBox;
    FStatus: TTMSFNCHTMLText;
    FButtons: array of TTMSFNCButton;
    FSwitches: array of TTMSFNCSwitch;
    FToggles: array of TControl;
    function AddRow(const ACaption: string; AHeight: Integer): TTMSFNCStackPanel;
    function AddButton(AParent: TDemoParent; const AText: string; ADefault: Boolean): TTMSFNCButton;
    function AddSwitch(AParent: TDemoParent; AChecked: Boolean): TTMSFNCSwitch;
    procedure CreateSettings;
    procedure CreateContent;
    procedure ApplySettings;
    procedure SettingChanged(Sender: TObject);
    procedure ButtonClick(Sender: TObject);
    procedure ToggleChange(Sender: TObject);
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
begin
  FSettings := FLayout.AddSettingsPanel(Self);

  FLayout.AddCaption(FSettings, 'Theme');
  FThemedCheck := FLayout.AddCheck(FSettings, 'Theme manager active', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FLayout.AddText(FSettings, 'Off: the manager''s Theme is cleared and every control shows its own Look.', 44);

  FLayout.AddCaption(FSettings, 'Look without a theme');
  FFluentRadio := FLayout.AddRadio(FSettings, 'Fluent', 'Look', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FClassicRadio := FLayout.AddRadio(FSettings, 'Classic', 'Look', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'State');
  FEnabledCheck := FLayout.AddCheck(FSettings, 'Controls enabled', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Last action');
  FStatus := FLayout.AddText(FSettings, 'Click a button or a toggle.', 60);
end;

function TForm1.AddRow(const ACaption: string; AHeight: Integer): TTMSFNCStackPanel;
begin
  FLayout.AddCaption(FContent, ACaption, 8);
  Result := TTMSFNCStackPanel.Create(Self);
  Result.Parent := FContent;
  FLayout.Place(Result, daTop, AHeight, 16, 0, 16, 8);
  Result.Orientation := spoHorizontal;
  Result.Alignment := lpaCenter;
  Result.Gap := 16;
  Result.Appearance.Stroke.Kind := gskNone;
end;

function TForm1.AddButton(AParent: TDemoParent; const AText: string; ADefault: Boolean): TTMSFNCButton;
begin
  Result := TTMSFNCButton.Create(Self);
  Result.Parent := AParent;
  Result.Width := FLayout.Size(140);
  Result.Height := FLayout.Size(32);
  Result.Text := AText;
  Result.Default := ADefault;
  Result.OnClick := {$IFDEF WEBLIB}@{$ENDIF}ButtonClick;
  SetLength(FButtons, Length(FButtons) + 1);
  FButtons[High(FButtons)] := Result;
end;

function TForm1.AddSwitch(AParent: TDemoParent; AChecked: Boolean): TTMSFNCSwitch;
begin
  Result := TTMSFNCSwitch.Create(Self);
  Result.Parent := AParent;
  Result.Width := FLayout.Size(48);
  Result.Height := FLayout.Size(24);
  Result.Checked := AChecked;
  Result.OnChange := {$IFDEF WEBLIB}@{$ENDIF}ToggleChange;
  SetLength(FSwitches, Length(FSwitches) + 1);
  FSwitches[High(FSwitches)] := Result;
end;

procedure TForm1.CreateContent;
var
  row: TTMSFNCStackPanel;
  c: TTMSFNCCheckBox;
  r: TTMSFNCRadioButton;
  I: Integer;
const
  Sizes: array[0..2] of string = ('Small', 'Medium', 'Large');
begin
  FContent := FLayout.AddContentPanel(Self);

  row := AddRow('Buttons', 56);
  AddButton(row, 'Save', True);
  AddButton(row, 'Cancel', False);
  AddButton(row, 'Options...', False);
  AddButton(row, 'Disabled', False).Enabled := False;

  row := AddRow('Switches', 56);
  AddSwitch(row, True);
  AddSwitch(row, False);
  AddSwitch(row, True).Enabled := False;

  row := AddRow('Check boxes', 56);
  for I := 0 to 2 do
  begin
    c := TTMSFNCCheckBox.Create(Self);
    c.Parent := row;
    c.Width := FLayout.Size(160);
    c.Height := FLayout.Size(32);
    c.Text := 'Option ' + IntToStr(I + 1);
    c.Checked := I <> 1;
    c.OnChange := {$IFDEF WEBLIB}@{$ENDIF}ToggleChange;
    SetLength(FToggles, Length(FToggles) + 1);
    FToggles[High(FToggles)] := c;
  end;

  row := AddRow('Radio buttons', 56);
  for I := 0 to 2 do
  begin
    r := TTMSFNCRadioButton.Create(Self);
    r.Parent := row;
    r.Width := FLayout.Size(160);
    r.Height := FLayout.Size(32);
    r.Text := Sizes[I];
    r.GroupName := 'Size';
    r.Checked := I = 1;
    r.OnChange := {$IFDEF WEBLIB}@{$ENDIF}ToggleChange;
    SetLength(FToggles, Length(FToggles) + 1);
    FToggles[High(FToggles)] := r;
  end;

  FLayout.AddText(FContent, 'Enter activates the default button; Space toggles the focused switch, check box or ' +
    'radio button; the arrow keys move within a radio group.', 44);
end;

procedure TForm1.ApplySettings;
var
  I: Integer;
begin
  if FThemedCheck.Checked then
    ThemeManager.Theme := DemoThemeSelector.SelectedTheme
  else
    ThemeManager.Theme := '';
  { the Look of a control without a theme; on WEB the controls follow the page style }
  for I := 0 to High(FButtons) do
  begin
    {$IFNDEF WEBLIB}
    if FClassicRadio.Checked then
      FButtons[I].Look := btlClassic
    else
      FButtons[I].Look := btlFluent;
    {$ENDIF}
    if FButtons[I].Text <> 'Disabled' then
      FButtons[I].Enabled := FEnabledCheck.Checked;
  end;
  for I := 0 to High(FSwitches) do
  begin
    {$IFNDEF WEBLIB}
    if FClassicRadio.Checked then
      FSwitches[I].Look := swlClassic
    else
      FSwitches[I].Look := swlFluent;
    {$ENDIF}
    if I < 2 then
      FSwitches[I].Enabled := FEnabledCheck.Checked;
  end;
  for I := 0 to High(FToggles) do
    FToggles[I].Enabled := FEnabledCheck.Checked;
  DemoThemeSelector.Enabled := FThemedCheck.Checked;
end;

procedure TForm1.SettingChanged(Sender: TObject);
begin
  ApplySettings;
end;

procedure TForm1.ButtonClick(Sender: TObject);
begin
  FStatus.Text := 'Button <b>' + TTMSFNCButton(Sender).Text + '</b>';
end;

procedure TForm1.ToggleChange(Sender: TObject);
begin
  if Sender is TTMSFNCSwitch then
  begin
    if TTMSFNCSwitch(Sender).Checked then
      FStatus.Text := 'Switch <b>on</b>'
    else
      FStatus.Text := 'Switch <b>off</b>';
  end
  else if Sender is TTMSFNCCheckBox then
  begin
    if TTMSFNCCheckBox(Sender).Checked then
      FStatus.Text := '<b>' + TTMSFNCCheckBox(Sender).Text + '</b> checked'
    else
      FStatus.Text := '<b>' + TTMSFNCCheckBox(Sender).Text + '</b> unchecked';
  end
  else if Sender is TTMSFNCRadioButton then
    FStatus.Text := '<b>' + TTMSFNCRadioButton(Sender).Text + '</b> selected';
end;

end.
