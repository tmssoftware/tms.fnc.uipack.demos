unit UDemo;

{ TMS FNC UI Pack - Toast

  Toasts are short notifications that slide into a corner of their host and leave by themselves: information,
  success, warning, error and neutral kinds, an optional action button, a countdown bar that pauses while the
  mouse is over the toast and a close button. The host here is the content area; an application uses its main
  form. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCToast, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCToast, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton, WEBLib.TMSFNCToast, WEBLib.TMSFNCTheme,
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
    FToast: TTMSFNCToast;
    FPositionRadios: array[TTMSFNCToastPosition] of TTMSFNCRadioButton;
    FShortRadio: TTMSFNCRadioButton;
    FNormalRadio: TTMSFNCRadioButton;
    FLongRadio: TTMSFNCRadioButton;
    FProgressCheck: TTMSFNCCheckBox;
    FCloseCheck: TTMSFNCCheckBox;
    FPauseCheck: TTMSFNCCheckBox;
    FAnimateCheck: TTMSFNCCheckBox;
    FStatus: TTMSFNCHTMLText;
    FCounter: Integer;
    procedure CreateSettings;
    procedure CreateContent;
    procedure ApplySettings;
    procedure SettingChanged(Sender: TObject);
    procedure InfoClick(Sender: TObject);
    procedure SuccessClick(Sender: TObject);
    procedure WarningClick(Sender: TObject);
    procedure ErrorClick(Sender: TObject);
    procedure NeutralClick(Sender: TObject);
    procedure ActionClick(Sender: TObject);
    procedure StickyClick(Sender: TObject);
    procedure CloseAllClick(Sender: TObject);
    procedure ToastActionClick(Sender: TObject; AItem: TTMSFNCToastItem);
    procedure ToastClick(Sender: TObject; AItem: TTMSFNCToastItem);
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
const
  PositionNames: array[TTMSFNCToastPosition] of string = ('Top left', 'Top centre', 'Top right', 'Bottom left',
    'Bottom centre', 'Bottom right');
var
  ps: TTMSFNCToastPosition;
begin
  FSettings := FLayout.AddSettingsPanel(Self);

  FLayout.AddCaption(FSettings, 'Position');
  for ps := Low(TTMSFNCToastPosition) to High(TTMSFNCToastPosition) do
    FPositionRadios[ps] := FLayout.AddRadio(FSettings, PositionNames[ps], 'Position', ps = tpsBottomRight, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Duration');
  FShortRadio := FLayout.AddRadio(FSettings, '2 seconds', 'Duration', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FNormalRadio := FLayout.AddRadio(FSettings, '4 seconds', 'Duration', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FLongRadio := FLayout.AddRadio(FSettings, '8 seconds', 'Duration', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Options');
  FProgressCheck := FLayout.AddCheck(FSettings, 'Countdown bar', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FCloseCheck := FLayout.AddCheck(FSettings, 'Close button', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FPauseCheck := FLayout.AddCheck(FSettings, 'Pause while the mouse is over it', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FAnimateCheck := FLayout.AddCheck(FSettings, 'Slide in and out', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
end;

procedure TForm1.CreateContent;
var
  bar: TTMSFNCPanel;
  b: TTMSFNCButton;
  procedure AddBarButton(const AText: string; AOnClick: TNotifyEvent);
  begin
    b := TTMSFNCButton.Create(Self);
    b.Parent := bar;
    FLayout.Place(b, daLeft, 110, 0, 8, 8, 8);
    b.Text := AText;
    b.OnClick := AOnClick;
  end;
begin
  FContent := FLayout.AddContentPanel(Self);
  FContent.Fill.Kind := gfkSolid;
  FContent.Stroke.Kind := gskSolid;

  bar := FLayout.AddPanel(FContent, daTop, 48, 8, 8, 8, 0);
  bar.Fill.Kind := gfkNone;
  bar.Stroke.Kind := gskNone;
  AddBarButton('Information', {$IFDEF WEBLIB}@{$ENDIF}InfoClick);
  AddBarButton('Success', {$IFDEF WEBLIB}@{$ENDIF}SuccessClick);
  AddBarButton('Warning', {$IFDEF WEBLIB}@{$ENDIF}WarningClick);
  AddBarButton('Error', {$IFDEF WEBLIB}@{$ENDIF}ErrorClick);
  AddBarButton('Neutral', {$IFDEF WEBLIB}@{$ENDIF}NeutralClick);
  AddBarButton('With action', {$IFDEF WEBLIB}@{$ENDIF}ActionClick);
  AddBarButton('Stays', {$IFDEF WEBLIB}@{$ENDIF}StickyClick);
  AddBarButton('Close all', {$IFDEF WEBLIB}@{$ENDIF}CloseAllClick);

  FStatus := TTMSFNCHTMLText.Create(Self);
  FStatus.Parent := FContent;
  FLayout.Place(FStatus, daTop, 60, 16, 8, 16, 0);
  FStatus.Fill.Kind := gfkNone;
  FStatus.Stroke.Kind := gskNone;
  FStatus.HorizontalTextAlign := gtaLeading;
  FStatus.VerticalTextAlign := gtaLeading;
  FStatus.WordWrapping := True;
  FStatus.TextRole := htrSecondary;
  FStatus.Text := 'The toasts appear in this area, in the corner chosen on the left. Click a toast or its action ' +
    'button to see the event here.';

  FToast := TTMSFNCToast.Create(Self);
  FToast.Host := FContent;
  FToast.OnActionClick := {$IFDEF WEBLIB}@{$ENDIF}ToastActionClick;
  FToast.OnToastClick := {$IFDEF WEBLIB}@{$ENDIF}ToastClick;
end;

procedure TForm1.ApplySettings;
var
  ps: TTMSFNCToastPosition;
begin
  for ps := Low(TTMSFNCToastPosition) to High(TTMSFNCToastPosition) do
    if FPositionRadios[ps].Checked then
      FToast.Position := ps;
  if FShortRadio.Checked then
    FToast.Duration := 2000
  else if FLongRadio.Checked then
    FToast.Duration := 8000
  else
    FToast.Duration := 4000;
  FToast.ShowProgress := FProgressCheck.Checked;
  FToast.ShowCloseButton := FCloseCheck.Checked;
  FToast.PauseOnHover := FPauseCheck.Checked;
  FToast.Animate := FAnimateCheck.Checked;
end;

procedure TForm1.SettingChanged(Sender: TObject);
begin
  ApplySettings;
end;

procedure TForm1.InfoClick(Sender: TObject);
begin
  Inc(FCounter);
  FToast.ShowInfo('Update available', 'Version 8.0.' + IntToStr(FCounter) + ' is ready to install.');
end;

procedure TForm1.SuccessClick(Sender: TObject);
begin
  FToast.ShowSuccess('Saved', 'The order was saved to the database.');
end;

procedure TForm1.WarningClick(Sender: TObject);
begin
  FToast.ShowWarning('Low disk space', 'Less than 2 GB left on drive C.');
end;

procedure TForm1.ErrorClick(Sender: TObject);
begin
  FToast.ShowError('Connection lost', 'The server did not answer. Retrying in 30 seconds.');
end;

procedure TForm1.NeutralClick(Sender: TObject);
begin
  FToast.Show('Reminder', 'Team meeting at 14:00 in room B.', toastNeutral);
end;

procedure TForm1.ActionClick(Sender: TObject);
begin
  FToast.ShowAction('Message deleted', 'The message was moved to the bin.', 'Undo', toastInfo);
end;

procedure TForm1.StickyClick(Sender: TObject);
begin
  { a duration of 0 keeps the toast until the user closes it }
  FToast.Show('Needs attention', 'This toast stays until you close it.', toastWarning, 0);
end;

procedure TForm1.CloseAllClick(Sender: TObject);
begin
  FToast.CloseAll;
end;

procedure TForm1.ToastActionClick(Sender: TObject; AItem: TTMSFNCToastItem);
begin
  FStatus.Text := 'Action <b>' + AItem.ActionText + '</b> of "' + AItem.Title + '" clicked.';
end;

procedure TForm1.ToastClick(Sender: TObject; AItem: TTMSFNCToastItem);
begin
  FStatus.Text := 'Toast "<b>' + AItem.Title + '</b>" clicked.';
end;

end.
