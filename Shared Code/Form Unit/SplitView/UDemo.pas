unit UDemo;

{ TMS FNC UI Pack - SplitView

  A navigation pane for a mail application: items with icons and badges, a header, a separator and a settings
  item pinned to the footer. Docked, the pane takes room next to the content; as an overlay it slides over the
  content with a scrim and closes when you click outside it (light dismiss). Closed, it collapses to nothing or
  to a compact rail of icons. The hamburger button toggles it; a narrow window collapses it by itself. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCSplitView, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCSplitView, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton, WEBLib.TMSFNCSplitView, WEBLib.TMSFNCTheme,
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
    FDockedRadio: TTMSFNCRadioButton;
    FOverlayRadio: TTMSFNCRadioButton;
    FCollapseRadio: TTMSFNCRadioButton;
    FCompactRadio: TTMSFNCRadioButton;
    FLeftRadio: TTMSFNCRadioButton;
    FRightRadio: TTMSFNCRadioButton;
    FDismissCheck: TTMSFNCCheckBox;
    FHamburgerCheck: TTMSFNCCheckBox;
    FAnimateCheck: TTMSFNCCheckBox;
    FStatus: TTMSFNCHTMLText;
    FSplit: TTMSFNCSplitView;
    FMail: TTMSFNCHTMLText;
    procedure CreateSettings;
    procedure CreateContent;
    procedure ApplySettings;
    procedure SettingChanged(Sender: TObject);
    procedure ToggleClick(Sender: TObject);
    procedure ItemIndexChanged(Sender: TObject);
    procedure PaneOpened(Sender: TObject);
    procedure PaneClosed(Sender: TObject);
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
  ItemIndexChanged(FSplit);
end;

procedure TForm1.CreateSettings;
begin
  FSettings := FLayout.AddSettingsPanel(Self);

  FLayout.AddCaption(FSettings, 'Display mode');
  FDockedRadio := FLayout.AddRadio(FSettings, 'Docked next to the content', 'Mode', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FOverlayRadio := FLayout.AddRadio(FSettings, 'Overlay over the content', 'Mode', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'When closed');
  FCompactRadio := FLayout.AddRadio(FSettings, 'Compact rail of icons', 'Close', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FCollapseRadio := FLayout.AddRadio(FSettings, 'Collapse completely', 'Close', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Placement');
  FLeftRadio := FLayout.AddRadio(FSettings, 'Left', 'Side', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FRightRadio := FLayout.AddRadio(FSettings, 'Right', 'Side', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Behaviour');
  FHamburgerCheck := FLayout.AddCheck(FSettings, 'Hamburger button', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FDismissCheck := FLayout.AddCheck(FSettings, 'Light dismiss (overlay)', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FAnimateCheck := FLayout.AddCheck(FSettings, 'Animate', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FLayout.AddButton(FSettings, 'Open or close the pane', {$IFDEF WEBLIB}@{$ENDIF}ToggleClick);

  FLayout.AddCaption(FSettings, 'State');
  FStatus := FLayout.AddText(FSettings, '', 60);
end;

procedure TForm1.CreateContent;
var
  it: TTMSFNCSplitViewItem;
begin
  FContent := FLayout.AddContentPanel(Self);
  FContent.Fill.Kind := gfkSolid;
  FContent.Stroke.Kind := gskSolid;

  { the content the pane sits next to or over }
  FMail := TTMSFNCHTMLText.Create(Self);
  FMail.Parent := FContent;
  FLayout.Place(FMail, daClient, 0, 0, 0, 0, 0);
  FMail.Fill.Kind := gfkNone;
  FMail.Stroke.Kind := gskNone;
  FMail.HorizontalTextAlign := gtaLeading;
  FMail.VerticalTextAlign := gtaLeading;
  FMail.WordWrapping := True;

  FSplit := TTMSFNCSplitView.Create(Self);
  FSplit.Parent := FContent;
  FSplit.Title := 'Mail';
  FSplit.OpenedWidth := 220;
  FSplit.BeginUpdate;
  FSplit.Items.Add('Inbox', 'Folder').Badge := '12';
  FSplit.Items.Add('Starred', 'Star');
  FSplit.Items.Add('Sent', 'Send');
  FSplit.Items.Add('Drafts', 'Document').Badge := '3';
  FSplit.Items.AddHeader('Workspace');
  FSplit.Items.Add('Calendar', 'Calendar');
  FSplit.Items.Add('People', 'People');
  it := FSplit.Items.Add('Archive', 'Folder');
  it.Enabled := False;
  it.Hint := 'Not available offline';
  FSplit.Items.AddSeparator;
  it := FSplit.Items.Add('Settings', 'Settings');
  it.Footer := True;
  FSplit.EndUpdate;
  FSplit.ItemIndex := 0;
  FSplit.OnItemIndexChanged := {$IFDEF WEBLIB}@{$ENDIF}ItemIndexChanged;
  FSplit.OnOpened := {$IFDEF WEBLIB}@{$ENDIF}PaneOpened;
  FSplit.OnClosed := {$IFDEF WEBLIB}@{$ENDIF}PaneClosed;
end;

procedure TForm1.ApplySettings;
begin
  FSplit.BeginUpdate;
  if FOverlayRadio.Checked then
    FSplit.DisplayMode := svdmOverlay
  else
    FSplit.DisplayMode := svdmDocked;
  if FCollapseRadio.Checked then
    FSplit.CloseStyle := svcsCollapse
  else
    FSplit.CloseStyle := svcsCompact;
  if FRightRadio.Checked then
    FSplit.Placement := svpRight
  else
    FSplit.Placement := svpLeft;
  FSplit.ShowHamburger := FHamburgerCheck.Checked;
  FSplit.LightDismiss := FDismissCheck.Checked;
  FSplit.Animate := FAnimateCheck.Checked;
  FSplit.EndUpdate;
end;

procedure TForm1.SettingChanged(Sender: TObject);
begin
  ApplySettings;
end;

procedure TForm1.ToggleClick(Sender: TObject);
begin
  FSplit.Opened := not FSplit.Opened;
end;

procedure TForm1.ItemIndexChanged(Sender: TObject);
var
  it: TTMSFNCSplitViewItem;
begin
  if (FSplit.ItemIndex < 0) or (FSplit.ItemIndex >= FSplit.Items.Count) then
    Exit;
  it := FSplit.Items[FSplit.ItemIndex];
  FMail.Text := '<b>' + it.Text + '</b><br><br>';
  if it.Text = 'Inbox' then
    FMail.Text := FMail.Text + 'Quarterly report ready for review<br>Team lunch moved to Friday<br>' +
      'Build 1284 passed all checks<br>Invoice 2026-118 paid<br><br>12 unread messages.'
  else if it.Text = 'Settings' then
    FMail.Text := FMail.Text + 'Account, signature, rules and notifications.'
  else
    FMail.Text := FMail.Text + 'Nothing here yet. Pick another folder in the pane.';
  FStatus.Text := 'Selected: <b>' + it.Text + '</b>';
end;

procedure TForm1.PaneOpened(Sender: TObject);
begin
  FStatus.Text := 'Pane opened (' + IntToStr(Round(FSplit.CurrentWidth)) + ' px)';
end;

procedure TForm1.PaneClosed(Sender: TObject);
begin
  FStatus.Text := 'Pane closed (' + IntToStr(Round(FSplit.CurrentWidth)) + ' px)';
end;

end.
