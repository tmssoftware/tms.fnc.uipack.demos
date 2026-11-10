unit UDemo;

{ TMS FNC UI Pack - PageSlider

  A page slider shows one page at a time and slides to the next: a tour of four pages, each with a header and a
  footer, filled with controls. Move with the buttons, the keyboard (left and right arrows, Home and End), a
  swipe or drag, or by setting the page index; OnPageChanging can refuse a move. The Fluent look follows the
  theme. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCEdit, VCL.TMSFNCStackPanel, VCL.TMSFNCProgressBar, VCL.TMSFNCPageSlider, VCL.TMSFNCTheme,
  VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCEdit, FMX.TMSFNCStackPanel, FMX.TMSFNCProgressBar, FMX.TMSFNCPageSlider, FMX.TMSFNCTheme,
  FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton, WEBLib.TMSFNCEdit, WEBLib.TMSFNCStackPanel,
  WEBLib.TMSFNCProgressBar, WEBLib.TMSFNCPageSlider, WEBLib.TMSFNCTheme, WEBLib.TMSFNCThemeSelector,
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
    FAnimateCheck: TTMSFNCCheckBox;
    FKeyboardCheck: TTMSFNCCheckBox;
    FHeadersCheck: TTMSFNCCheckBox;
    FFootersCheck: TTMSFNCCheckBox;
    FLockCheck: TTMSFNCCheckBox;
    FStatus: TTMSFNCHTMLText;
    FSlider: TTMSFNCPageSlider;
    FBackButton: TTMSFNCButton;
    FNextButton: TTMSFNCButton;
    FProgress: TTMSFNCProgressBar;
    FAgree: TTMSFNCCheckBox;
    procedure CreateSettings;
    procedure CreateContent;
    function AddPage(const ACaption, AFooter: string): TTMSFNCStackPanel;
    procedure ApplySettings;
    procedure SettingChanged(Sender: TObject);
    procedure PageChange(Sender: TObject);
    procedure PageChanging(Sender: TObject; AFromPage, AToPage: Integer; var AAllowChange: Boolean);
    procedure BackClick(Sender: TObject);
    procedure NextClick(Sender: TObject);
    procedure FirstClick(Sender: TObject);
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

procedure TForm1.FormCreate(Sender: TObject);
begin
  FLayout := TDemoLayout.Create(Self);
  CreateSettings;
  CreateContent;
  ApplySettings;
  PageChange(nil);
end;

procedure TForm1.CreateSettings;
begin
  FSettings := FLayout.AddSettingsPanel(Self);

  FLayout.AddCaption(FSettings, 'Behaviour');
  FAnimateCheck := FLayout.AddCheck(FSettings, 'Animate the slide', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FKeyboardCheck := FLayout.AddCheck(FSettings, 'Arrow keys, Home and End', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FLockCheck := FLayout.AddCheck(FSettings, 'The terms must be accepted to pass page 3', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Pages');
  FHeadersCheck := FLayout.AddCheck(FSettings, 'Headers', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FFootersCheck := FLayout.AddCheck(FSettings, 'Footers', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FLayout.AddButton(FSettings, 'First page', {$IFDEF WEBLIB}@{$ENDIF}FirstClick);
  FLayout.AddButton(FSettings, 'Last page', {$IFDEF WEBLIB}@{$ENDIF}LastClick);

  FLayout.AddCaption(FSettings, 'Current page');
  FStatus := FLayout.AddText(FSettings, '', 60);
end;

function TForm1.AddPage(const ACaption, AFooter: string): TTMSFNCStackPanel;
var
  c: TTMSFNCPageSliderContainer;
begin
  { a page: its header and footer texts and a stack panel for the content }
  c := FSlider.AddPage(ACaption, AFooter);
  Result := TTMSFNCStackPanel.Create(Self);
  Result.Parent := c;
  FLayout.Place(Result, daClient, 0, 0, 0, 0, 0);
  Result.Appearance.Fill.Kind := gfkNone;
  Result.Appearance.Stroke.Kind := gskNone;
  Result.Gap := 6;
  Result.ContentPadding.Rect := RectF(16, 16, 16, 16);
end;

procedure TForm1.CreateContent;
var
  page: TTMSFNCStackPanel;
  e: TTMSFNCEdit;
  buttons: TTMSFNCPanel;
  t: TTMSFNCHTMLText;
begin
  FContent := FLayout.AddContentPanel(Self);

  buttons := FLayout.AddPanel(FContent, daBottom, 48, 0, 8, 0, 0);
  buttons.Fill.Kind := gfkNone;
  buttons.Stroke.Kind := gskNone;
  FNextButton := TTMSFNCButton.Create(Self);
  FNextButton.Parent := buttons;
  FLayout.Place(FNextButton, daRight, 120, 8, 8, 0, 8);
  FNextButton.Text := 'Next';
  FNextButton.Default := True;
  FNextButton.OnClick := {$IFDEF WEBLIB}@{$ENDIF}NextClick;
  FBackButton := TTMSFNCButton.Create(Self);
  FBackButton.Parent := buttons;
  FLayout.Place(FBackButton, daRight, 120, 8, 8, 0, 8);
  FBackButton.Text := 'Back';
  FBackButton.OnClick := {$IFDEF WEBLIB}@{$ENDIF}BackClick;
  FProgress := TTMSFNCProgressBar.Create(Self);
  FProgress.Parent := buttons;
  FLayout.Place(FProgress, daLeft, 240, 0, 16, 0, 16);
  FProgress.Maximum := 100;

  FSlider := TTMSFNCPageSlider.Create(Self);
  FSlider.Parent := FContent;
  FLayout.Place(FSlider, daClient, 0, 0, 0, 0, 0);
  FSlider.BeginUpdate;
  FSlider.Pages.Clear;

  page := AddPage('Welcome', 'Page 1 of 4');
  t := FLayout.AddText(page, '<b>A short tour</b><br>Four pages slide through this control. Use the buttons ' +
    'below, the arrow keys while the slider has the focus, or drag a page sideways.', 80);
  t.TextRole := htrPrimary;
  FLayout.AddText(page, 'Each page is a container: put any controls on it, as on a panel.', 40);

  page := AddPage('Your details', 'Page 2 of 4');
  FLayout.AddCaption(page, 'Name', 4);
  e := TTMSFNCEdit.Create(Self);
  e.Parent := page;
  e.Width := FLayout.Size(280);
  e.Height := FLayout.Size(32);
  e.Text := 'Anna Lee';
  FLayout.AddCaption(page, 'E-mail', 4);
  e := TTMSFNCEdit.Create(Self);
  e.Parent := page;
  e.Width := FLayout.Size(280);
  e.Height := FLayout.Size(32);
  e.Text := 'anna@example.com';

  page := AddPage('Terms', 'Page 3 of 4');
  FLayout.AddText(page, 'The demo licence: use it, change it, ship it with your application. ' +
    'Accept the terms to continue; OnPageChanging refuses the move until you do.', 60);
  FAgree := FLayout.AddCheck(page, 'I accept the terms', False, nil);
  FAgree.Width := FLayout.Size(280);

  page := AddPage('Done', 'Page 4 of 4');
  t := FLayout.AddText(page, '<b>That is the tour.</b><br>Home and End jump to the first and last page; ' +
    'the page index is a property the application can set at any time.', 80);
  t.TextRole := htrPrimary;

  FSlider.EndUpdate;
  FSlider.ActivePageIndex := 0;
  FSlider.OnPageChange := {$IFDEF WEBLIB}@{$ENDIF}PageChange;
  FSlider.OnPageChanging := {$IFDEF WEBLIB}@{$ENDIF}PageChanging;
end;

procedure TForm1.ApplySettings;
var
  I: Integer;
begin
  FSlider.BeginUpdate;
  FSlider.AnimateScroll := FAnimateCheck.Checked;
  FSlider.KeyboardInteraction := FKeyboardCheck.Checked;
  for I := 0 to FSlider.Pages.Count - 1 do
  begin
    FSlider.Pages[I].Container.Header.Visible := FHeadersCheck.Checked;
    FSlider.Pages[I].Container.Footer.Visible := FFootersCheck.Checked;
  end;
  FSlider.EndUpdate;
end;

procedure TForm1.SettingChanged(Sender: TObject);
begin
  ApplySettings;
end;

procedure TForm1.PageChange(Sender: TObject);
var
  n: Integer;
begin
  n := FSlider.Pages.Count;
  FStatus.Text := 'Page <b>' + IntToStr(FSlider.ActivePageIndex + 1) + '</b> of ' + IntToStr(n) + ': ' +
    FSlider.Pages[FSlider.ActivePageIndex].Container.Header.Text;
  FProgress.Value := 100 * (FSlider.ActivePageIndex + 1) / n;
  FBackButton.Enabled := FSlider.ActivePageIndex > 0;
  FNextButton.Enabled := FSlider.ActivePageIndex < n - 1;
end;

procedure TForm1.PageChanging(Sender: TObject; AFromPage, AToPage: Integer; var AAllowChange: Boolean);
begin
  { the terms page lets nobody pass until the box is checked }
  if FLockCheck.Checked and (AFromPage = 2) and (AToPage > 2) and not FAgree.Checked then
  begin
    AAllowChange := False;
    FStatus.Text := '<b>Accept the terms first.</b>';
  end;
end;

procedure TForm1.BackClick(Sender: TObject);
begin
  if FSlider.ActivePageIndex > 0 then
    FSlider.ActivePageIndex := FSlider.ActivePageIndex - 1;
end;

procedure TForm1.NextClick(Sender: TObject);
begin
  if FSlider.ActivePageIndex < FSlider.Pages.Count - 1 then
    FSlider.ActivePageIndex := FSlider.ActivePageIndex + 1;
end;

procedure TForm1.FirstClick(Sender: TObject);
begin
  FSlider.ActivePageIndex := 0;
end;

procedure TForm1.LastClick(Sender: TObject);
begin
  FSlider.ActivePageIndex := FSlider.Pages.Count - 1;
end;

end.
