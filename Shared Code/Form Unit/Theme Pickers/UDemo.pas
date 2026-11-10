unit UDemo;

{ TMS FNC UI Pack - Theme Pickers

  The controls an application offers its users to pick a look, all linked to the theme manager of the form: the
  theme selector with every built-in theme and the "follow the system" option, the accent selector with the
  system and theme accents, a swatch selector that sets the accent from a brand palette, a segmented control
  that switches the density and the brand logo that shows the application name in the theme's colours. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCEdit, VCL.TMSFNCProgressBar, VCL.TMSFNCSwitch, VCL.TMSFNCStackPanel, VCL.TMSFNCCardPanel,
  VCL.TMSFNCSwatchSelector, VCL.TMSFNCAccentSelector, VCL.TMSFNCSegmentedControl, VCL.TMSFNCBrandLogo,
  VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCEdit, FMX.TMSFNCProgressBar, FMX.TMSFNCSwitch, FMX.TMSFNCStackPanel, FMX.TMSFNCCardPanel,
  FMX.TMSFNCSwatchSelector, FMX.TMSFNCAccentSelector, FMX.TMSFNCSegmentedControl, FMX.TMSFNCBrandLogo,
  FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton, WEBLib.TMSFNCEdit, WEBLib.TMSFNCProgressBar,
  WEBLib.TMSFNCSwitch, WEBLib.TMSFNCStackPanel, WEBLib.TMSFNCCardPanel, WEBLib.TMSFNCSwatchSelector,
  WEBLib.TMSFNCAccentSelector, WEBLib.TMSFNCSegmentedControl, WEBLib.TMSFNCBrandLogo, WEBLib.TMSFNCTheme,
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
    FAllThemes: TTMSFNCThemeSelector;
    FAccent: TTMSFNCAccentSelector;
    FSwatches: TTMSFNCSwatchSelector;
    FDensity: TTMSFNCSegmentedControl;
    FLogo: TTMSFNCBrandLogo;
    FStatus: TTMSFNCHTMLText;
    FSwitch: TTMSFNCSwitch;
    procedure CreateSettings;
    procedure CreateContent;
    procedure ThemeApplied(Sender: TObject; const AThemeName: string);
    procedure AccentApplied(Sender: TObject; AItemIndex: Integer; AColor: TTMSFNCGraphicsColor);
    procedure SwatchChange(Sender: TObject);
    procedure DensityChange(Sender: TObject);
    procedure UpdateStatus;
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
  UpdateStatus;
end;

procedure TForm1.CreateSettings;
begin
  FSettings := FLayout.AddSettingsPanel(Self, 300);

  { every registered theme, light and dark, with the follow-the-system choice }
  FLayout.AddCaption(FSettings, 'Theme');
  FAllThemes := TTMSFNCThemeSelector.Create(Self);
  FAllThemes.Parent := FSettings;
  FLayout.Place(FAllThemes, daTop, 36, 16, 0, 16, 0);
  FAllThemes.ThemeManager := ThemeManager;
  FAllThemes.AllThemes := True;
  FAllThemes.ShowFollowSystem := True;
  FAllThemes.OnAfterApplyTheme := {$IFDEF WEBLIB}@{$ENDIF}ThemeApplied;
  FLayout.AddText(FSettings, 'The header selector offers Light and Dark only; this one lists every theme.', 44);

  { the accent colour of the theme: the system accent, the theme''s own and a set of colours }
  FLayout.AddCaption(FSettings, 'Accent');
  FAccent := TTMSFNCAccentSelector.Create(Self);
  FAccent.Parent := FSettings;
  FLayout.Place(FAccent, daTop, 40, 16, 0, 16, 0);
  FAccent.ThemeManager := ThemeManager;
  FAccent.OnAfterApplyAccent := {$IFDEF WEBLIB}@{$ENDIF}AccentApplied;

  { a brand palette as a swatch selector; the chosen swatch becomes the accent }
  FLayout.AddCaption(FSettings, 'Brand palette');
  FSwatches := TTMSFNCSwatchSelector.Create(Self);
  FSwatches.Parent := FSettings;
  FLayout.Place(FSwatches, daTop, 64, 16, 0, 16, 0);
  FSwatches.Shape := sssRounded;
  FSwatches.TextPosition := sstpBottom;
  { demo-colors: the swatches are the colours of a brand }
  FSwatches.Items.AddSwatch(MakeGraphicsColor($0F, $6C, $BD), 'Ocean');
  FSwatches.Items.AddSwatch(MakeGraphicsColor($13, $A1, $0E), 'Leaf');
  FSwatches.Items.AddSwatch(MakeGraphicsColor($CA, $50, $10), 'Clay');
  FSwatches.Items.AddSwatch(MakeGraphicsColor($87, $64, $B8), 'Plum');
  FSwatches.Items.AddSwatch(MakeGraphicsColor($03, $83, $87), 'Teal');
  FSwatches.Items.AddSwatch(MakeGraphicsColor($C4, $31, $4B), 'Berry');
  FSwatches.OnChange := {$IFDEF WEBLIB}@{$ENDIF}SwatchChange;

  { the density of every control, as a segmented control }
  FLayout.AddCaption(FSettings, 'Density');
  FDensity := TTMSFNCSegmentedControl.Create(Self);
  FDensity.Parent := FSettings;
  FLayout.Place(FDensity, daTop, 36, 16, 0, 16, 0);
  FDensity.Items.Clear;
  FDensity.Items.AddItem('Compact');
  FDensity.Items.AddItem('Standard');
  FDensity.Items.AddItem('Comfortable');
  FDensity.StretchItems := True;
  FDensity.ItemIndex := Ord(ThemeManager.Density);
  FDensity.OnChange := {$IFDEF WEBLIB}@{$ENDIF}DensityChange;

  FLayout.AddCaption(FSettings, 'Current');
  FStatus := FLayout.AddText(FSettings, '', 80);
end;

procedure TForm1.CreateContent;
var
  card: TTMSFNCCardPanel;
  stack: TTMSFNCStackPanel;
  e: TTMSFNCEdit;
  b: TTMSFNCButton;
  p: TTMSFNCProgressBar;
begin
  FContent := FLayout.AddContentPanel(Self);

  { the brand logo: the application name in the theme''s colours }
  FLogo := TTMSFNCBrandLogo.Create(Self);
  FLogo.Parent := FContent;
  FLayout.Place(FLogo, daTop, 64, 0, 0, 0, 16);
  FLogo.Kind := blkMarkAndAppName;
  FLogo.Mode := blmTheme;

  { a card of controls that show the accent and the density }
  card := TTMSFNCCardPanel.Create(Self);
  card.Parent := FContent;
  FLayout.Place(card, daTop, 300, 0, 0, 0, 0);
  card.Header.Text := 'Preview';
  card.Header.Description := 'Every control follows the pickers on the left';
  stack := TTMSFNCStackPanel.Create(Self);
  stack.Parent := card;
  FLayout.Place(stack, daClient, 0, 0, 0, 0, 0);
  stack.Gap := 8;
  stack.Alignment := lpaStart;
  e := TTMSFNCEdit.Create(Self);
  e.Parent := stack;
  e.Width := FLayout.Size(320);
  e.Height := FLayout.Size(32);
  e.Text := 'An edit with the accent as its focus colour';
  b := FLayout.AddButton(stack, 'A primary button in the accent colour', nil);
  b.Default := True;
  b.Width := FLayout.Size(320);
  FLayout.AddButton(stack, 'A standard button', nil).Width := FLayout.Size(320);
  FLayout.AddCheck(stack, 'A checked check box', True, nil).Width := FLayout.Size(320);
  FSwitch := TTMSFNCSwitch.Create(Self);
  FSwitch.Parent := stack;
  FSwitch.Width := FLayout.Size(48);
  FSwitch.Height := FLayout.Size(24);
  FSwitch.Checked := True;
  p := TTMSFNCProgressBar.Create(Self);
  p.Parent := stack;
  p.Width := FLayout.Size(320);
  p.Height := FLayout.Size(20);
  p.Value := 66;
end;

procedure TForm1.ThemeApplied(Sender: TObject; const AThemeName: string);
begin
  UpdateStatus;
end;

procedure TForm1.AccentApplied(Sender: TObject; AItemIndex: Integer; AColor: TTMSFNCGraphicsColor);
begin
  UpdateStatus;
end;

procedure TForm1.SwatchChange(Sender: TObject);
begin
  if FSwatches.ItemIndex >= 0 then
    ThemeManager.Accent := FSwatches.SelectedColor;
  UpdateStatus;
end;

procedure TForm1.DensityChange(Sender: TObject);
begin
  if FDensity.ItemIndex >= 0 then
    ThemeManager.Density := TTMSFNCThemeDensity(FDensity.ItemIndex);
  UpdateStatus;
end;

procedure TForm1.UpdateStatus;
var
  s: string;
begin
  s := 'Theme <b>' + ThemeManager.Theme + '</b>';
  if ThemeManager.FollowSystem then
    s := s + ' (follows the system)';
  if ThemeManager.Accent <> gcNull then
    s := s + '<br>Accent ' + TTMSFNCGraphics.ColorToHTML(ThemeManager.Accent)
  else
    s := s + '<br>Accent of the theme';
  FStatus.Text := s;
end;

end.
