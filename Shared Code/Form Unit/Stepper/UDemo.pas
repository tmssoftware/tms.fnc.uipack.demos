unit UDemo;

{ TMS FNC UI Pack - Stepper

  A checkout in five steps: the stepper shows where the customer is, the Back and Next buttons move the active
  step and the page below follows. Steps can be numbered, carry an icon or shrink to dots; a step can be marked
  done, in error or disabled; a vertical stepper suits a side panel. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCStepper, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCStepper, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton, WEBLib.TMSFNCStepper, WEBLib.TMSFNCTheme,
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
    FMarkerRadios: array[TTMSFNCStepperMarkerStyle] of TTMSFNCRadioButton;
    FBelowRadio: TTMSFNCRadioButton;
    FRightRadio: TTMSFNCRadioButton;
    FClickCheck: TTMSFNCCheckBox;
    FAnimateCheck: TTMSFNCCheckBox;
    FErrorCheck: TTMSFNCCheckBox;
    FStepper: TTMSFNCStepper;
    FSideStepper: TTMSFNCStepper;
    FPage: TTMSFNCHTMLText;
    FBackButton: TTMSFNCButton;
    FNextButton: TTMSFNCButton;
    procedure CreateSettings;
    procedure CreateContent;
    procedure ApplySettings;
    procedure SettingChanged(Sender: TObject);
    procedure StepChanged(Sender: TObject);
    procedure BackClick(Sender: TObject);
    procedure NextClick(Sender: TObject);
    procedure ShowPage;
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
  Pages: array[0..4] of string = (
    '<b>Cart</b><br><br>3 items, 247.00 EUR. Change quantities or remove items before you continue.',
    '<b>Account</b><br><br>You are signed in as ada@example.com. The order confirmation goes to this address.',
    '<b>Shipping</b><br><br>Delivery to the address on file in 2 to 3 working days; express delivery is available.',
    '<b>Payment</b><br><br>Card, bank transfer or invoice. Nothing is charged before the order is reviewed.',
    '<b>Review</b><br><br>Everything is in place. Place the order with the button below the stepper.');

procedure TForm1.FormCreate(Sender: TObject);
begin
  FLayout := TDemoLayout.Create(Self);
  CreateSettings;
  CreateContent;
  ApplySettings;
  ShowPage;
end;

procedure TForm1.CreateSettings;
const
  MarkerNames: array[TTMSFNCStepperMarkerStyle] of string = ('Numbers', 'Icons', 'Dots');
var
  ms: TTMSFNCStepperMarkerStyle;
begin
  FSettings := FLayout.AddSettingsPanel(Self);

  FLayout.AddCaption(FSettings, 'Markers');
  for ms := Low(TTMSFNCStepperMarkerStyle) to High(TTMSFNCStepperMarkerStyle) do
    FMarkerRadios[ms] := FLayout.AddRadio(FSettings, MarkerNames[ms], 'Marker', ms = smsNumber, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Labels');
  FBelowRadio := FLayout.AddRadio(FSettings, 'Below the markers', 'Labels', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FRightRadio := FLayout.AddRadio(FSettings, 'Next to the markers', 'Labels', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Behaviour');
  FClickCheck := FLayout.AddCheck(FSettings, 'Click a finished step to go back', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FAnimateCheck := FLayout.AddCheck(FSettings, 'Animate the progress line', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FErrorCheck := FLayout.AddCheck(FSettings, 'Payment step in error', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FLayout.AddText(FSettings, 'The stepper on the right is vertical and shows the same steps with their ' +
    'descriptions; its last step is disabled.', 64);
end;

procedure TForm1.CreateContent;
var
  buttons: TTMSFNCPanel;
  side: TTMSFNCPanel;
begin
  FContent := FLayout.AddContentPanel(Self);

  { the vertical stepper in a side panel }
  side := FLayout.AddPanel(FContent, daRight, 240, 16, 0, 0, 0);
  FLayout.AddCaption(side, 'Progress', 12);
  FSideStepper := TTMSFNCStepper.Create(Self);
  FSideStepper.Parent := side;
  FLayout.Place(FSideStepper, daClient, 0, 16, 0, 16, 16);
  FSideStepper.Orientation := stoVertical;
  FSideStepper.Steps.AddStep('Cart', '3 items');
  FSideStepper.Steps.AddStep('Account', 'Signed in');
  FSideStepper.Steps.AddStep('Shipping', 'Where to deliver');
  FSideStepper.Steps.AddStep('Payment', 'How to pay');
  FSideStepper.Steps.AddStep('Review', 'Not available yet').State := sstDisabled;
  FSideStepper.ClickMode := scmNone;

  { the horizontal stepper above the page it drives }
  FStepper := TTMSFNCStepper.Create(Self);
  FStepper.Parent := FContent;
  FLayout.Place(FStepper, daTop, 84, 0, 8, 0, 8);
  FStepper.Steps.AddStep('Cart', '3 items', 'Folder');
  FStepper.Steps.AddStep('Account', 'Signed in', 'People');
  FStepper.Steps.AddStep('Shipping', 'Where to deliver', 'Send');
  FStepper.Steps.AddStep('Payment', 'How to pay', 'Document');
  FStepper.Steps.AddStep('Review', 'Check and order', 'Star');
  FStepper.ActiveStep := 1;
  FStepper.OnActiveStepChanged := {$IFDEF WEBLIB}@{$ENDIF}StepChanged;

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

  FPage := TTMSFNCHTMLText.Create(Self);
  FPage.Parent := FContent;
  FLayout.Place(FPage, daClient, 0, 0, 0, 0, 0);
  FPage.HorizontalTextAlign := gtaLeading;
  FPage.VerticalTextAlign := gtaLeading;
  FPage.WordWrapping := True;
end;

procedure TForm1.ApplySettings;
var
  ms: TTMSFNCStepperMarkerStyle;
begin
  FStepper.BeginUpdate;
  for ms := Low(TTMSFNCStepperMarkerStyle) to High(TTMSFNCStepperMarkerStyle) do
    if FMarkerRadios[ms].Checked then
      FStepper.MarkerStyle := ms;
  if FRightRadio.Checked then
    FStepper.LabelPlacement := slpRight
  else
    FStepper.LabelPlacement := slpBelow;
  if FClickCheck.Checked then
    FStepper.ClickMode := scmDone
  else
    FStepper.ClickMode := scmNone;
  FStepper.Animate := FAnimateCheck.Checked;
  if FErrorCheck.Checked then
    FStepper.Steps[3].State := sstError
  else
    FStepper.Steps[3].State := sstAuto;
  FStepper.EndUpdate;
  FSideStepper.Animate := FAnimateCheck.Checked;
  FSideStepper.Steps[3].State := FStepper.Steps[3].State;
end;

procedure TForm1.SettingChanged(Sender: TObject);
begin
  ApplySettings;
end;

procedure TForm1.ShowPage;
begin
  FPage.Text := Pages[FStepper.ActiveStep];
  FSideStepper.ActiveStep := FStepper.ActiveStep;
  FBackButton.Enabled := FStepper.ActiveStep > 0;
  if FStepper.ActiveStep = High(Pages) then
    FNextButton.Text := 'Place order'
  else
    FNextButton.Text := 'Next';
end;

procedure TForm1.StepChanged(Sender: TObject);
begin
  ShowPage;
end;

procedure TForm1.BackClick(Sender: TObject);
begin
  if FStepper.ActiveStep > 0 then
    FStepper.ActiveStep := FStepper.ActiveStep - 1;
end;

procedure TForm1.NextClick(Sender: TObject);
begin
  if FStepper.ActiveStep < High(Pages) then
    FStepper.ActiveStep := FStepper.ActiveStep + 1
  else
    FPage.Text := '<b>Thank you</b><br><br>The order is placed. Every step shows as done.';
end;

end.
