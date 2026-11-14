unit UDemo;

{ TMS FNC UI Pack - Theme Studio

  Everything the theme manager decides for an application, on one page. Pick any built-in theme, the accent (or
  the accent of Windows), the density, light or dark from the system, the title bar and the focus ring; the sample
  form follows at once. The middle column shows what a single control can do under a theme: keep the classic look
  (TTMSFNCTheme.KeepValues), use another theme than the application (ThemeName) or stay out of theming
  (ThemingEnabled False). The right column holds standard FireMonkey / VCL controls that follow the theme when the
  platform style is synchronised (SyncPlatformStyle, PlatformStyleMatch). Edit the theme opens the theme editor at
  run time; the result is the CustomTheme of the manager and can be saved as JSON. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, System.IOUtils,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton, VCL.TMSFNCEdit,
  VCL.TMSFNCComboBox, VCL.TMSFNCSwitch, VCL.TMSFNCProgressBar, VCL.TMSFNCTrackBar, VCL.TMSFNCListBox, VCL.TMSFNCCustomTreeView,
  VCL.TMSFNCSegmentedControl, VCL.TMSFNCAccentSelector, VCL.TMSFNCThemeEditor, VCL.TMSFNCTheme,
  VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, System.IOUtils,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls, FMX.Edit, FMX.ListBox,
  FMX.Controls.Presentation,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton, FMX.TMSFNCEdit,
  FMX.TMSFNCComboBox, FMX.TMSFNCSwitch, FMX.TMSFNCProgressBar, FMX.TMSFNCTrackBar, FMX.TMSFNCListBox, FMX.TMSFNCCustomTreeView,
  FMX.TMSFNCSegmentedControl, FMX.TMSFNCAccentSelector, FMX.TMSFNCThemeEditor, FMX.TMSFNCTheme,
  FMX.TMSFNCThemeSelector,
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
    procedure FormDestroy(Sender: TObject);
  private
    FLayout: TDemoLayout;
    FSettings: TTMSFNCPanel;
    FContent: TTMSFNCPanel;
    FThemes: TTMSFNCListBox;
    FAccent: TTMSFNCAccentSelector;
    FSystemAccentCheck: TTMSFNCCheckBox;
    FFollowCheck: TTMSFNCCheckBox;
    FDensity: TTMSFNCSegmentedControl;
    FTitleBar: TTMSFNCSegmentedControl;
    FFocusCheck: TTMSFNCCheckBox;
    FPlatformCheck: TTMSFNCCheckBox;
    FAllThemesCheck: TTMSFNCCheckBox;
    FStatus: TTMSFNCHTMLText;
    FEditor: TTMSFNCThemeEditor;
    FClassicButton: TTMSFNCButton;
    FOwnThemePanel: TTMSFNCPanel;
    FUpdating: Boolean;
    procedure CreateSettings;
    procedure CreateContent;
    procedure CreateSampleForm(AParent: TTMSFNCPanel);
    procedure CreatePerControl(AParent: TTMSFNCPanel);
    procedure CreatePlatform(AParent: TTMSFNCPanel);
    function AddColumn(const ATitle: string; AWidth: Integer): TTMSFNCPanel;
    function AddCard(AParent: TTMSFNCPanel; const ATitle, AText: string; AHeight: Integer): TTMSFNCPanel;
    procedure FillThemes;
    procedure ApplySettings;
    procedure UpdateStatus;
    procedure ThemeSelected(Sender: TObject; AItem: TTMSFNCListBoxItem);
    procedure SettingChanged(Sender: TObject);
    procedure EditClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure ThemeChanged(Sender: TObject);
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

procedure TForm1.FormCreate(Sender: TObject);
begin
  FLayout := TDemoLayout.Create(Self);
  FEditor := TTMSFNCThemeEditor.Create(Self);
  FEditor.ThemeManager := ThemeManager;
  CreateSettings;
  CreateContent;
  FillThemes;
  TTMSFNCTheme.AddChangeListener(ThemeChanged);
  { the manager starts as the check boxes say }
  ApplySettings;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  TTMSFNCTheme.RemoveChangeListener(ThemeChanged);
end;

procedure TForm1.CreateSettings;
var
  b: TTMSFNCButton;
begin
  FSettings := FLayout.AddSettingsPanel(Self, 280);

  FLayout.AddCaption(FSettings, 'Theme', 8);
  FThemes := TTMSFNCListBox.Create(Self);
  FThemes.Parent := FSettings;
  FLayout.Place(FThemes, daTop, 150, 16, 0, 16, 0);
  FThemes.Header.Visible := False;
  FThemes.ItemsAppearance.Look := tnlFluent;
  FThemes.ItemsAppearance.HeightMode := lihmFixed;
  FThemes.ItemsAppearance.FixedHeight := 26;
  FThemes.OnItemSelected := ThemeSelected;
  FFollowCheck := FLayout.AddCheck(FSettings, 'Light or dark as Windows is', False, SettingChanged);

  FLayout.AddCaption(FSettings, 'Accent', 8);
  FAccent := TTMSFNCAccentSelector.Create(Self);
  FAccent.Parent := FSettings;
  FLayout.Place(FAccent, daTop, 36, 16, 0, 16, 0);
  FAccent.ThemeManager := ThemeManager;
  FSystemAccentCheck := FLayout.AddCheck(FSettings, 'The accent of Windows', False, SettingChanged);

  FLayout.AddCaption(FSettings, 'Density and title bar', 8);
  FDensity := TTMSFNCSegmentedControl.Create(Self);
  FDensity.Parent := FSettings;
  FLayout.Place(FDensity, daTop, 32, 16, 0, 16, 6);
  FDensity.Items.AddItem('Compact');
  FDensity.Items.AddItem('Normal');
  FDensity.Items.AddItem('Roomy');
  FDensity.ItemIndex := 1;
  FDensity.OnChange := SettingChanged;
  FTitleBar := TTMSFNCSegmentedControl.Create(Self);
  FTitleBar.Parent := FSettings;
  FLayout.Place(FTitleBar, daTop, 32, 16, 0, 16, 0);
  FTitleBar.Items.AddItem('System bar');
  FTitleBar.Items.AddItem('Theme bar');
  FTitleBar.ItemIndex := 0;
  FTitleBar.OnChange := SettingChanged;
  FFocusCheck := FLayout.AddCheck(FSettings, 'Focus ring of the theme', True, SettingChanged);
  FPlatformCheck := FLayout.AddCheck(FSettings, 'Standard controls follow', True, SettingChanged);
  FAllThemesCheck := FLayout.AddCheck(FSettings, '... under every theme', False, SettingChanged);

  b := FLayout.AddButton(FSettings, 'Edit the theme...', EditClick);
  b.Default := True;
  FLayout.AddButton(FSettings, 'Save the custom theme...', SaveClick);
end;

function TForm1.AddColumn(const ATitle: string; AWidth: Integer): TTMSFNCPanel;
begin
  if AWidth > 0 then
    Result := FLayout.AddPanel(FContent, daLeft, AWidth, 0, 0, 16, 0)
  else
    Result := FLayout.AddPanel(FContent, daClient, 0, 0, 0, 0, 0);
  Result.Fill.Kind := gfkNone;
  Result.Stroke.Kind := gskNone;
  FLayout.AddCaption(Result, ATitle, 0);
end;

function TForm1.AddCard(AParent: TTMSFNCPanel; const ATitle, AText: string; AHeight: Integer): TTMSFNCPanel;
begin
  Result := FLayout.AddPanel(AParent, daTop, AHeight, 0, 4, 0, 8);
  FLayout.AddCaption(Result, ATitle, 8);
  if AText <> '' then
    FLayout.AddText(Result, AText, 0);
end;

procedure TForm1.CreateContent;
begin
  FContent := FLayout.AddContentPanel(Self);
  CreateSampleForm(AddColumn('Your application', 300));
  CreatePerControl(AddColumn('One control, its own way', 250));
  CreatePlatform(AddColumn('Standard controls', 0));
  FStatus := FLayout.AddText(FContent, '', 40);
  FLayout.Place(FStatus, daBottom, 40, 0, 8, 0, 0);
end;

procedure TForm1.CreateSampleForm(AParent: TTMSFNCPanel);
var
  card: TTMSFNCPanel;
  e: TTMSFNCEdit;
  cb: TTMSFNCComboBox;
  row: TTMSFNCPanel;
  b: TTMSFNCButton;
  sw: TTMSFNCSwitch;
  pb: TTMSFNCProgressBar;
  tb: TTMSFNCTrackBar;
begin
  card := FLayout.AddPanel(AParent, daClient, 0, 0, 4, 0, 0);
  FLayout.AddCaption(card, 'New customer', 12);
  e := TTMSFNCEdit.Create(Self);
  e.Parent := card;
  FLayout.Place(e, daTop, 32, 16, 4, 16, 4);
  e.Text := 'Northwind Traders';
  e := TTMSFNCEdit.Create(Self);
  e.Parent := card;
  FLayout.Place(e, daTop, 32, 16, 4, 16, 4);
  {$IFDEF FMX}
  e.TextPrompt := 'E-mail address';
  {$ELSE}
  e.TextHint := 'E-mail address';
  {$ENDIF}
  cb := TTMSFNCComboBox.Create(Self);
  cb.Parent := card;
  FLayout.Place(cb, daTop, 32, 16, 4, 16, 4);
  cb.Items.Add('Retail');
  cb.Items.Add('Wholesale');
  cb.Items.Add('Government');
  cb.ItemIndex := 1;
  FLayout.AddCheck(card, 'Send the newsletter', True, nil);
  FLayout.AddRadio(card, 'Pay by invoice', 'pay', True, nil);
  FLayout.AddRadio(card, 'Pay by card', 'pay', False, nil);
  row := FLayout.AddPanel(card, daTop, 32, 16, 4, 16, 4);
  row.Fill.Kind := gfkNone;
  row.Stroke.Kind := gskNone;
  sw := TTMSFNCSwitch.Create(Self);
  sw.Parent := row;
  FLayout.Place(sw, daLeft, 56, 0, 4, 8, 4);
  sw.Checked := True;
  FLayout.Place(FLayout.AddText(row, 'Active account', 0), daClient, 0, 0, 6, 0, 0);
  pb := TTMSFNCProgressBar.Create(Self);
  pb.Parent := card;
  FLayout.Place(pb, daTop, 20, 16, 8, 16, 4);
  pb.Value := 65;
  tb := TTMSFNCTrackBar.Create(Self);
  tb.Parent := card;
  FLayout.Place(tb, daTop, 32, 16, 4, 16, 4);
  tb.Value := 40;
  row := FLayout.AddPanel(card, daBottom, 36, 16, 8, 16, 12);
  row.Fill.Kind := gfkNone;
  row.Stroke.Kind := gskNone;
  b := FLayout.AddButton(row, 'Save', nil);
  FLayout.Place(b, daRight, 90, 8, 0, 0, 0);
  b.Default := True;
  b := FLayout.AddButton(row, 'Cancel', nil);
  FLayout.Place(b, daRight, 90, 8, 0, 0, 0);
end;

procedure TForm1.CreatePerControl(AParent: TTMSFNCPanel);
var
  card: TTMSFNCPanel;
  own: TTMSFNCHTMLText;
  e: TTMSFNCEdit;
begin
  card := AddCard(AParent, 'Follows the theme', '', 92);
  FLayout.AddButton(card, 'A themed button', nil);

  card := AddCard(AParent, 'Keeps the classic look', '', 92);
  FClassicButton := FLayout.AddButton(card, 'A classic button', nil);
  { the developer owns this value: a theme leaves it alone }
  TTMSFNCTheme.KeepValues(FClassicButton, ['Look']);
  FClassicButton.Look := btlClassic;

  FOwnThemePanel := AddCard(AParent, 'Always Fluent Dark', '', 132);
  FOwnThemePanel.ThemeName := 'Fluent Dark';
  e := TTMSFNCEdit.Create(Self);
  e.Parent := FOwnThemePanel;
  FLayout.Place(e, daTop, 32, 16, 4, 16, 4);
  e.Text := 'ThemeName on the card';
  FLayout.AddButton(FOwnThemePanel, 'Inside the card', nil);

  card := AddCard(AParent, 'Out of theming', '', 92);
  own := TTMSFNCHTMLText.Create(Self);
  own.Parent := card;
  FLayout.Place(own, daTop, 32, 16, 4, 16, 4);
  own.ThemingEnabled := False;
  { demo-colors: this label keeps the colours it was given under every theme }
  own.Fill.Kind := gfkSolid;
  own.Fill.Color := MakeGraphicsColor(255, 214, 102);
  own.Font.Color := MakeGraphicsColor(51, 51, 51);
  own.HorizontalTextAlign := gtaCenter;
  own.Text := 'My own colours';
end;

procedure TForm1.CreatePlatform(AParent: TTMSFNCPanel);
var
  card: TTMSFNCPanel;
  e: TEdit;
  b: TButton;
  c: TCheckBox;
  l: TListBox;
begin
  card := FLayout.AddPanel(AParent, daClient, 0, 0, 4, 0, 0);
  FLayout.AddText(card, 'TEdit, TButton, TCheckBox and TListBox of the framework, no FNC controls.', 0);
  e := TEdit.Create(Self);
  e.Parent := card;
  FLayout.Place(e, daTop, 30, 16, 8, 16, 4);
  e.Text := 'A standard edit';
  b := TButton.Create(Self);
  b.Parent := card;
  FLayout.Place(b, daTop, 32, 16, 4, 16, 4);
  {$IFDEF FMX}
  b.Text := 'A standard button';
  {$ELSE}
  b.Caption := 'A standard button';
  {$ENDIF}
  c := TCheckBox.Create(Self);
  c.Parent := card;
  FLayout.Place(c, daTop, 28, 16, 4, 16, 4);
  {$IFDEF FMX}
  c.Text := 'A standard check box';
  c.IsChecked := True;
  {$ELSE}
  c.Caption := 'A standard check box';
  c.Checked := True;
  {$ENDIF}
  l := TListBox.Create(Self);
  l.Parent := card;
  FLayout.Place(l, daClient, 0, 16, 4, 16, 16);
  l.Items.Add('Brussels');
  l.Items.Add('Ghent');
  l.Items.Add('Lyon');
  l.Items.Add('Porto');
  l.ItemIndex := 1;
end;

procedure TForm1.FillThemes;
var
  names: TStringList;
  I: Integer;
  it: TTMSFNCListBoxItem;
begin
  FUpdating := True;
  names := TTMSFNCTheme.ThemeNames;
  FThemes.BeginUpdate;
  try
    FThemes.Items.Clear;
    for I := 0 to names.Count - 1 do
    begin
      { names with a tilde are internal (the preview of an open theme editor) }
      if Copy(names[I], 1, 1) = '~' then
        Continue;
      it := FThemes.Items.Add;
      it.Text := names[I];
      if SameText(names[I], ThemeManager.Theme) then
        FThemes.ItemIndex := FThemes.Items.Count - 1;
    end;
  finally
    FThemes.EndUpdate;
    names.Free;
    FUpdating := False;
  end;
end;

procedure TForm1.ApplySettings;
begin
  if FUpdating then
    Exit;
  ThemeManager.FollowSystem := FFollowCheck.Checked;
  ThemeManager.FollowSystemAccent := FSystemAccentCheck.Checked;
  FAccent.Enabled := not FSystemAccentCheck.Checked;
  case FDensity.ItemIndex of
    0: ThemeManager.Density := tdCompact;
    2: ThemeManager.Density := tdComfortable;
  else
    ThemeManager.Density := tdStandard;
  end;
  if FTitleBar.ItemIndex = 1 then
    ThemeManager.TitleBar := tbTheme
  else
    ThemeManager.TitleBar := tbSystem;
  ThemeManager.FocusRing := FFocusCheck.Checked;
  ThemeManager.SyncPlatformStyle := FPlatformCheck.Checked;
  if FAllThemesCheck.Checked then
    ThemeManager.PlatformStyleMatch := psmAllThemes
  else
    ThemeManager.PlatformStyleMatch := psmFluentOnly;
  FAllThemesCheck.Enabled := FPlatformCheck.Checked;
  UpdateStatus;
end;

procedure TForm1.UpdateStatus;
var
  s: string;
begin
  s := 'Theme <b>' + ThemeManager.Theme + '</b>';
  if ThemeManager.CustomTheme.Count > 0 then
    s := s + ', with a custom theme of ' + IntToStr(ThemeManager.CustomTheme.Count) + ' lines';
  if ThemeManager.FollowSystem then
    s := s + ', light or dark as Windows is';
  FStatus.Text := s + '. The card in the middle stays dark under every theme; the yellow label keeps its own colours.';
end;

procedure TForm1.ThemeSelected(Sender: TObject; AItem: TTMSFNCListBoxItem);
begin
  if FUpdating or not Assigned(AItem) then
    Exit;
  FFollowCheck.Checked := False;
  ThemeManager.FollowSystem := False;
  ThemeManager.Theme := AItem.Text;
  UpdateStatus;
end;

procedure TForm1.SettingChanged(Sender: TObject);
begin
  ApplySettings;
end;

procedure TForm1.EditClick(Sender: TObject);
begin
  FEditor.Execute;
  UpdateStatus;
end;

procedure TForm1.SaveClick(Sender: TObject);
var
  f: string;
begin
  if ThemeManager.CustomTheme.Count = 0 then
  begin
    FStatus.Text := 'There is no custom theme yet: choose <b>Edit the theme...</b>, change a colour and apply it.';
    Exit;
  end;
  f := TPath.Combine(TPath.GetDocumentsPath, 'MyTheme.json');
  ThemeManager.CustomTheme.SaveToFile(f, TEncoding.UTF8);
  FStatus.Text := 'Saved as <b>' + f + '</b>. Load it in another application with the theme editor or ' +
    'ThemeManager.CustomTheme.LoadFromFile.';
end;

procedure TForm1.ThemeChanged(Sender: TObject);
var
  I: Integer;
begin
  { the theme may also change from the header selector or the editor }
  if not Assigned(FThemes) then
    Exit;
  FUpdating := True;
  try
    for I := 0 to FThemes.Items.Count - 1 do
      if SameText(FThemes.Items[I].Text, ThemeManager.Theme) and (FThemes.ItemIndex <> I) then
        FThemes.ItemIndex := I;
  finally
    FUpdating := False;
  end;
  UpdateStatus;
end;

end.
