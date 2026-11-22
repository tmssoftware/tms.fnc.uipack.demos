unit UDemo;

{ TMS FNC UI Pack - Input Forms

  One form with every FNC input: edits with a clear button, a lookup that completes while typing and a password
  reveal, a mask edit, an IP edit, a directory edit (desktop), a number box with currency and limits, a spin edit, a knob, a
  tag edit with suggestions, a label edit, a switch, a radio group and a check group. Validate checks the
  values and marks the fields; the options on the left switch the clear buttons, the reveal and read only for
  the whole form. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCStackPanel,
  VCL.TMSFNCScrollBox, VCL.TMSFNCEdit, VCL.TMSFNCMaskEdit, VCL.TMSFNCNumberBox, VCL.TMSFNCTagEdit, VCL.TMSFNCKnob,
  VCL.TMSFNCIPEdit, VCL.TMSFNCLabelEdit, VCL.TMSFNCSpinEdit, VCL.TMSFNCSwitch, VCL.TMSFNCDirectoryEdit,
  VCL.TMSFNCCheckGroup, VCL.TMSFNCRadioGroup, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCStackPanel,
  FMX.TMSFNCScrollBox, FMX.TMSFNCEdit, FMX.TMSFNCMaskEdit, FMX.TMSFNCNumberBox, FMX.TMSFNCTagEdit, FMX.TMSFNCKnob,
  FMX.TMSFNCIPEdit, FMX.TMSFNCLabelEdit, FMX.TMSFNCSpinEdit, FMX.TMSFNCSwitch, FMX.TMSFNCDirectoryEdit,
  FMX.TMSFNCCheckGroup, FMX.TMSFNCRadioGroup, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCStackPanel, WEBLib.TMSFNCScrollBox, WEBLib.TMSFNCEdit,
  WEBLib.TMSFNCMaskEdit, WEBLib.TMSFNCNumberBox, WEBLib.TMSFNCTagEdit, WEBLib.TMSFNCKnob, WEBLib.TMSFNCIPEdit,
  WEBLib.TMSFNCLabelEdit, WEBLib.TMSFNCSpinEdit, WEBLib.TMSFNCSwitch, WEBLib.TMSFNCCheckGroup,
  WEBLib.TMSFNCRadioGroup, WEBLib.TMSFNCTheme, WEBLib.TMSFNCThemeSelector,
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
    FClearCheck: TTMSFNCCheckBox;
    FRevealCheck: TTMSFNCCheckBox;
    FContainsCheck: TTMSFNCCheckBox;
    FReadOnlyCheck: TTMSFNCCheckBox;
    FStatus: TTMSFNCHTMLText;
    FBox: TTMSFNCScrollBox;
    FName: TTMSFNCEdit;
    FMail: TTMSFNCEdit;
    FDepartment: TTMSFNCEdit;
    FPassword: TTMSFNCEdit;
    FPhone: TTMSFNCMaskEdit;
    FAddress: TTMSFNCIPEdit;
    {$IFNDEF WEBLIB}
    FFolder: TTMSFNCDirectoryEdit;
    {$ENDIF}
    FSalary: TTMSFNCNumberBox;
    FHours: TTMSFNCSpinEdit;
    FWorkload: TTMSFNCKnob;
    FSkills: TTMSFNCTagEdit;
    FNickname: TTMSFNCLabelEdit;
    FRemote: TTMSFNCSwitch;
    FContract: TTMSFNCRadioGroup;
    FChannels: TTMSFNCCheckGroup;
    procedure CreateSettings;
    procedure CreateContent;
    function AddColumn(AParent: TDemoParent): TTMSFNCStackPanel;
    function AddEdit(AParent: TTMSFNCStackPanel; const ALabel, AEmptyText: string): TTMSFNCEdit;
    procedure ApplySettings;
    procedure SettingChanged(Sender: TObject);
    procedure ValidateClick(Sender: TObject);
    procedure ResetClick(Sender: TObject);
    procedure WorkloadChange(Sender: TObject);
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

  FLayout.AddCaption(FSettings, 'Edits');
  FClearCheck := FLayout.AddCheck(FSettings, 'Clear buttons', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FRevealCheck := FLayout.AddCheck(FSettings, 'Password reveal button', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FContainsCheck := FLayout.AddCheck(FSettings, 'Lookup matches anywhere in the name', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Form');
  FReadOnlyCheck := FLayout.AddCheck(FSettings, 'Read only', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FLayout.AddButton(FSettings, 'Validate', {$IFDEF WEBLIB}@{$ENDIF}ValidateClick).Default := True;
  FLayout.AddButton(FSettings, 'Reset', {$IFDEF WEBLIB}@{$ENDIF}ResetClick);
  FLayout.AddText(FSettings, 'Validate marks the number box and the mask edit with their validation state ' +
    'and lists what is missing here.', 64);

  FLayout.AddCaption(FSettings, 'Result');
  FStatus := FLayout.AddText(FSettings, 'Not validated yet.', 120);
end;

function TForm1.AddColumn(AParent: TDemoParent): TTMSFNCStackPanel;
begin
  Result := TTMSFNCStackPanel.Create(Self);
  Result.Parent := AParent;
  Result.Appearance.Stroke.Kind := gskNone;
  Result.Gap := 4;
  Result.SizeToContent := True;
  Result.ContentPadding.Rect := RectF(0, 0, 16, 16);
end;

function TForm1.AddEdit(AParent: TTMSFNCStackPanel; const ALabel, AEmptyText: string): TTMSFNCEdit;
begin
  FLayout.AddCaption(AParent, ALabel, 8);
  Result := TTMSFNCEdit.Create(Self);
  Result.Parent := AParent;
  Result.Width := FLayout.Size(300);
  Result.Height := FLayout.Size(32);
  Result.{$IFDEF FMX}TextPrompt{$ELSE}TextHint{$ENDIF} := AEmptyText;
end;

procedure TForm1.CreateContent;
var
  left, right: TTMSFNCStackPanel;
  row: TTMSFNCStackPanel;
  t: TTMSFNCHTMLText;
begin
  FContent := FLayout.AddContentPanel(Self);

  { the form scrolls when the window is small: two columns of fields in a scroll box }
  FBox := TTMSFNCScrollBox.Create(Self);
  FBox.Parent := FContent;
  FLayout.Place(FBox, daClient, 0, 0, 0, 0, 0);
  FBox.Appearance.Fill.Kind := gfkNone;
  FBox.Appearance.Stroke.Kind := gskNone;
  left := AddColumn(FBox);
  left.SetBounds(0, 0, FLayout.Size(332), FLayout.Size(100));
  right := AddColumn(FBox);
  right.SetBounds(FLayout.Size(348), 0, FLayout.Size(332), FLayout.Size(100));

  { text: a required name, an address, a department completed from a list, a password }
  FName := AddEdit(left, 'Full name (required)', 'First and last name');
  FMail := AddEdit(left, 'E-mail (required, with an @)', 'name@example.com');
  FDepartment := AddEdit(left, 'Department (type two letters)', 'Where you work');
  FDepartment.Lookup.Enabled := True;
  FDepartment.Lookup.DisplayList.CommaText := 'Design,Development,Documentation,Finance,"Human resources",' +
    'Marketing,Operations,Platform,Sales,Support';
  FDepartment.Lookup.HighlightMatch := True;
  FDepartment.Lookup.EmptyText := 'No department matches';
  FDepartment.Lookup.RecentCount := 3;
  FPassword := AddEdit(left, 'Password (8 characters or more)', '');
  {$IFDEF FMX}
  FPassword.Password := True;
  {$ELSE}
  FPassword.PasswordChar := '*';
  {$ENDIF}
  FPassword.Text := 'secret';

  { a phone number with a mask: the state shows while typing }
  FLayout.AddCaption(left, 'Phone (complete the mask)', 8);
  FPhone := TTMSFNCMaskEdit.Create(Self);
  FPhone.Parent := left;
  FPhone.Width := FLayout.Size(300);
  FPhone.Height := FLayout.Size(32);
  FPhone.EditMask := '!\(999\) 000-0000;1;_';
  FPhone.Placeholder := '(555) 123-4567';
  FPhone.Required := True;

  FLayout.AddCaption(left, 'Workstation address', 8);
  FAddress := TTMSFNCIPEdit.Create(Self);
  FAddress.Parent := left;
  FAddress.Width := FLayout.Size(300);
  FAddress.Height := FLayout.Size(32);
  FAddress.IPAddress := '192.168.1.42';

  {$IFNDEF WEBLIB}
  FLayout.AddCaption(left, 'Home folder (desktop only)', 8);
  FFolder := TTMSFNCDirectoryEdit.Create(Self);
  FFolder.Parent := left;
  FFolder.Width := FLayout.Size(300);
  FFolder.Height := FLayout.Size(32);
  FFolder.EmptyText := 'Pick a folder';
  {$ENDIF}

  { numbers: a currency with limits, a spin edit, a knob }
  FLayout.AddCaption(right, 'Salary (currency, 1,500 to 12,000)', 8);
  FSalary := TTMSFNCNumberBox.Create(Self);
  FSalary.Parent := right;
  FSalary.Width := FLayout.Size(300);
  FSalary.Height := FLayout.Size(32);
  FSalary.ValueType := nbvtCurrency;
  FSalary.CurrencySymbol := 'EUR ';
  FSalary.MinValue := 1500;
  FSalary.MaxValue := 12000;
  FSalary.SmallStep := 100;
  FSalary.LargeStep := 500;
  FSalary.Value := 4200;
  FSalary.Placeholder := 'Type a number or an expression';

  row := TTMSFNCStackPanel.Create(Self);
  row.Parent := right;
  row.Width := FLayout.Size(300);
  row.Height := FLayout.Size(150);
  row.Orientation := spoHorizontal;
  row.Alignment := lpaStart;
  row.Gap := 24;
  row.Appearance.Stroke.Kind := gskNone;
  left := AddColumn(row);
  left.Width := FLayout.Size(140);
  left.ContentPadding.Rect := RectF(0, 0, 0, 0);
  FLayout.AddCaption(left, 'Hours a week', 8);
  FHours := TTMSFNCSpinEdit.Create(Self);
  FHours.Parent := left;
  FHours.Width := FLayout.Size(130);
  FHours.Height := FLayout.Size(32);
  FHours.Min := 0;
  FHours.Max := 60;
  FHours.Value := 38;
  FLayout.AddCaption(left, 'Remote', 8);
  FRemote := TTMSFNCSwitch.Create(Self);
  FRemote.Parent := left;
  FRemote.Width := FLayout.Size(48);
  FRemote.Height := FLayout.Size(24);
  FRemote.Checked := True;
  left := AddColumn(row);
  left.Width := FLayout.Size(130);
  left.ContentPadding.Rect := RectF(0, 0, 0, 0);
  FLayout.AddCaption(left, 'Workload', 8);
  FWorkload := TTMSFNCKnob.Create(Self);
  FWorkload.Parent := left;
  FWorkload.Width := FLayout.Size(100);
  FWorkload.Height := FLayout.Size(100);
  FWorkload.Min := 0;
  FWorkload.Max := 100;
  FWorkload.Step := 5;
  FWorkload.Value := 80;
  FWorkload.ValueFormat := '%.0f%%';
  FWorkload.TickCount := 5;
  FWorkload.OnChange := {$IFDEF WEBLIB}@{$ENDIF}WorkloadChange;

  { tags with suggestions, a label that edits in place }
  FLayout.AddCaption(right, 'Skills (type for suggestions, five at most)', 8);
  FSkills := TTMSFNCTagEdit.Create(Self);
  FSkills.Parent := right;
  FSkills.Width := FLayout.Size(300);
  FSkills.Height := FLayout.Size(68);
  FSkills.AddTag('Delphi');
  FSkills.AddTag('FireMonkey');
  FSkills.Suggestions.CommaText := 'Android,Azure,C++Builder,Delphi,FireMonkey,iOS,Linux,macOS,SQL,TypeScript,VCL,' +
    '"WEB Core",Windows';
  FSkills.MaxTags := 5;
  FSkills.Placeholder := 'Add a skill';

  FLayout.AddCaption(right, 'Nickname (click the text to edit it)', 8);
  FNickname := TTMSFNCLabelEdit.Create(Self);
  FNickname.Parent := right;
  FNickname.Width := FLayout.Size(300);
  FNickname.Height := FLayout.Size(32);
  FNickname.Text := 'The new one';

  { groups: one of three contracts, any of three channels }
  FLayout.AddCaption(right, 'Contract', 8);
  FContract := TTMSFNCRadioGroup.Create(Self);
  FContract.Parent := right;
  FContract.Width := FLayout.Size(300);
  FContract.Height := FLayout.Size(60);
  FContract.Items.CommaText := 'Permanent,"Fixed term",Freelance';
  FContract.Columns := 3;
  FContract.ItemIndex := 0;
  FLayout.AddCaption(right, 'Reach me by', 8);
  FChannels := TTMSFNCCheckGroup.Create(Self);
  FChannels.Parent := right;
  FChannels.Width := FLayout.Size(300);
  FChannels.Height := FLayout.Size(60);
  FChannels.Items.CommaText := 'Mail,Chat,Phone';
  FChannels.Columns := 3;
  FChannels.Checked[0] := True;
  FChannels.Checked[1] := True;

  t := FLayout.AddText(right, 'Tab through the form: every field shows the focus colour of the theme.', 40);
  t.Width := FLayout.Size(300);
  FBox.UpdateContent;
end;

procedure TForm1.ApplySettings;
begin
  { the clear and reveal buttons of the edit are desktop only; the mask edit and number box have them everywhere }
  {$IFNDEF WEBLIB}
  FName.ShowClearButton := FClearCheck.Checked;
  FMail.ShowClearButton := FClearCheck.Checked;
  FDepartment.ShowClearButton := FClearCheck.Checked;
  FPassword.PasswordReveal := FRevealCheck.Checked;
  {$ENDIF}
  FPhone.ShowClearButton := FClearCheck.Checked;
  FSalary.ShowClearButton := FClearCheck.Checked;
  if FContainsCheck.Checked then
    FDepartment.Lookup.MatchMode := elmContains
  else
    FDepartment.Lookup.MatchMode := elmStartsWith;
  FName.ReadOnly := FReadOnlyCheck.Checked;
  FMail.ReadOnly := FReadOnlyCheck.Checked;
  FDepartment.ReadOnly := FReadOnlyCheck.Checked;
  FPassword.ReadOnly := FReadOnlyCheck.Checked;
  FPhone.ReadOnly := FReadOnlyCheck.Checked;
  FSalary.ReadOnly := FReadOnlyCheck.Checked;
  FSkills.ReadOnly := FReadOnlyCheck.Checked;
  FNickname.Editable := not FReadOnlyCheck.Checked;
  FHours.Enabled := not FReadOnlyCheck.Checked;
  FWorkload.Enabled := not FReadOnlyCheck.Checked;
  FRemote.Enabled := not FReadOnlyCheck.Checked;
  FAddress.Enabled := not FReadOnlyCheck.Checked;
  FContract.Enabled := not FReadOnlyCheck.Checked;
  FChannels.Enabled := not FReadOnlyCheck.Checked;
  {$IFNDEF WEBLIB}
  FFolder.Enabled := not FReadOnlyCheck.Checked;
  {$ENDIF}
end;

procedure TForm1.SettingChanged(Sender: TObject);
begin
  ApplySettings;
end;

procedure TForm1.ValidateClick(Sender: TObject);
var
  errors: string;
  I, n: Integer;
begin
  errors := '';
  if Trim(FName.Text) = '' then
    errors := errors + '<li>The name is required</li>';
  if Pos('@', FMail.Text) <= 1 then
    errors := errors + '<li>The e-mail needs an @</li>';
  if Length(FPassword.Text) < 8 then
    errors := errors + '<li>The password is shorter than 8 characters</li>';
  if FDepartment.Lookup.DisplayList.IndexOf(FDepartment.Text) < 0 then
    errors := errors + '<li>The department is not in the list</li>';

  { the mask edit and the number box show their state themselves }
  if FPhone.ValidateEdit then
    FPhone.ValidationState := vlsValid
  else
  begin
    FPhone.ValidationState := vlsError;
    errors := errors + '<li>The phone number is incomplete</li>';
  end;
  if (FSalary.Value < FSalary.MinValue) or (FSalary.Value > FSalary.MaxValue) then
  begin
    FSalary.ValidationState := vlsError;
    errors := errors + '<li>The salary is outside 1,500 to 12,000</li>';
  end
  else if FSalary.Value > 10000 then
    FSalary.ValidationState := vlsWarning
  else
    FSalary.ValidationState := vlsValid;

  if FSkills.Tags.Count = 0 then
    errors := errors + '<li>Add at least one skill</li>';
  n := 0;
  for I := 0 to FChannels.Items.Count - 1 do
    if FChannels.Checked[I] then
      Inc(n);
  if n = 0 then
    errors := errors + '<li>Pick a way to reach you</li>';

  if errors = '' then
    FStatus.Text := '<b>Valid.</b> ' + FName.Text + ' works ' + IntToStr(Round(FHours.Value)) + ' hours a week at ' +
      IntToStr(Round(FWorkload.Value)) + '% on a ' + LowerCase(FContract.Items[FContract.ItemIndex]) +
      ' contract; ' + IntToStr(FSkills.Tags.Count) + ' skills, address ' + FAddress.IPAddress + '.'
  else
    FStatus.Text := '<b>Please correct:</b><ul>' + errors + '</ul>';
end;

procedure TForm1.ResetClick(Sender: TObject);
begin
  FName.Text := '';
  FMail.Text := '';
  FDepartment.Text := '';
  FPassword.Text := '';
  FPhone.Text := '';
  FPhone.ValidationState := vlsNone;
  FSalary.Value := 4200;
  FSalary.ValidationState := vlsNone;
  FHours.Value := 38;
  FWorkload.Value := 80;
  FSkills.Tags.Clear;
  FNickname.Text := 'The new one';
  FRemote.Checked := True;
  FContract.ItemIndex := 0;
  FStatus.Text := 'Not validated yet.';
end;

procedure TForm1.WorkloadChange(Sender: TObject);
begin
  { the hours follow the workload of a full week }
  if Assigned(FHours) then
    FHours.Value := Round(38 * FWorkload.Value / 100);
end;

end.
