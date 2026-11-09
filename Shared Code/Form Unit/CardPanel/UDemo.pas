unit UDemo;

{ TMS FNC UI Pack - CardPanel

  Cards group related content: a header with a title and a description, a body that holds any controls and a
  footer for a status or an action. An accent bar at the top or the left marks the card, elevation gives it a
  shadow that rises when the mouse is over a clickable card. Click a card, its header or its footer to see which
  part was hit. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCStackPanel, VCL.TMSFNCCardPanel, VCL.TMSFNCProgressBar, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCStackPanel, FMX.TMSFNCCardPanel, FMX.TMSFNCProgressBar, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton, WEBLib.TMSFNCStackPanel, WEBLib.TMSFNCCardPanel,
  WEBLib.TMSFNCProgressBar, WEBLib.TMSFNCTheme, WEBLib.TMSFNCThemeSelector,
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
    FAccentRadios: array[TTMSFNCCardPanelAccentPosition] of TTMSFNCRadioButton;
    FFlatRadio: TTMSFNCRadioButton;
    FRaisedRadio: TTMSFNCRadioButton;
    FClickableCheck: TTMSFNCCheckBox;
    FDividerCheck: TTMSFNCCheckBox;
    FFooterCheck: TTMSFNCCheckBox;
    FStatus: TTMSFNCHTMLText;
    FCards: array of TTMSFNCCardPanel;
    function AddCard(AParent: TDemoParent; const ATitle, ADescription, AFooter: string): TTMSFNCCardPanel;
    procedure CreateSettings;
    procedure CreateContent;
    procedure ApplySettings;
    procedure SettingChanged(Sender: TObject);
    procedure CardPartClick(Sender: TObject; APart: TTMSFNCCardPanelPart);
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
  AccentNames: array[TTMSFNCCardPanelAccentPosition] of string = ('No accent bar', 'Accent bar on the left', 'Accent bar at the top');
var
  ap: TTMSFNCCardPanelAccentPosition;
begin
  FSettings := FLayout.AddSettingsPanel(Self);

  FLayout.AddCaption(FSettings, 'Accent');
  for ap := Low(TTMSFNCCardPanelAccentPosition) to High(TTMSFNCCardPanelAccentPosition) do
    FAccentRadios[ap] := FLayout.AddRadio(FSettings, AccentNames[ap], 'Accent', ap = capNone, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Elevation');
  FFlatRadio := FLayout.AddRadio(FSettings, 'Flat with a border', 'Elevation', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FRaisedRadio := FLayout.AddRadio(FSettings, 'Raised, higher on hover', 'Elevation', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Parts');
  FDividerCheck := FLayout.AddCheck(FSettings, 'Divider under the header', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FFooterCheck := FLayout.AddCheck(FSettings, 'Footer', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FClickableCheck := FLayout.AddCheck(FSettings, 'Clickable (hand cursor, hover)', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Last click');
  FStatus := FLayout.AddText(FSettings, 'Click a card.', 60);
end;

function TForm1.AddCard(AParent: TDemoParent; const ATitle, ADescription, AFooter: string): TTMSFNCCardPanel;
begin
  Result := TTMSFNCCardPanel.Create(Self);
  Result.Parent := AParent;
  Result.Width := FLayout.Size(250);
  Result.Height := FLayout.Size(210);
  Result.Header.Text := ATitle;
  Result.Header.Description := ADescription;
  Result.Footer.Text := AFooter;
  Result.OnPartClick := {$IFDEF WEBLIB}@{$ENDIF}CardPartClick;
  SetLength(FCards, Length(FCards) + 1);
  FCards[High(FCards)] := Result;
end;

procedure TForm1.CreateContent;
var
  row: TTMSFNCStackPanel;
  c: TTMSFNCCardPanel;
  body: TTMSFNCStackPanel;
  t: TTMSFNCHTMLText;
  p: TTMSFNCProgressBar;
begin
  FContent := FLayout.AddContentPanel(Self);

  row := TTMSFNCStackPanel.Create(Self);
  row.Parent := FContent;
  FLayout.Place(row, daTop, 230, 0, 8, 0, 0);
  row.Orientation := spoHorizontal;
  row.Alignment := lpaStart;
  row.Gap := 16;

  { a card with options in its body }
  c := AddCard(row, 'Storage', 'Last synced 5 minutes ago', '12.4 GB of 15 GB used');
  body := TTMSFNCStackPanel.Create(Self);
  body.Parent := c;
  FLayout.Place(body, daClient, 0, 0, 0, 0, 0);
  body.Gap := 2;
  FLayout.AddCheck(body, 'Photos', True, nil);
  FLayout.AddCheck(body, 'Documents', True, nil);
  FLayout.AddCheck(body, 'Music', False, nil);

  { a card with a progress bar and a text }
  c := AddCard(row, 'Build 1284', 'main branch', 'Started 10:42');
  body := TTMSFNCStackPanel.Create(Self);
  body.Parent := c;
  FLayout.Place(body, daClient, 0, 0, 0, 0, 0);
  body.Gap := 8;
  t := FLayout.AddText(body, '312 of 340 tests passed, 2 skipped', 24);
  t.TextRole := htrPrimary;
  p := TTMSFNCProgressBar.Create(Self);
  p.Parent := body;
  FLayout.Place(p, daTop, 20, 16, 0, 16, 0);
  p.Value := 92;

  { a card that is a button }
  c := AddCard(row, 'Quarterly report', 'PDF, 2.4 MB', 'Click to open');
  c.Footer.TextAlign := gtaTrailing;
  t := FLayout.AddText(c, 'Revenue, costs and headcount per region with the comparison to last year.', 60);
  t.TextRole := htrPrimary;

  FLayout.AddText(FContent, 'The cards keep their size; the row is a stack panel with a gap of 16. The header ' +
    'description and the footer use the secondary text colour of the theme.', 44);
end;

procedure TForm1.ApplySettings;
var
  I: Integer;
  ap: TTMSFNCCardPanelAccentPosition;
begin
  for I := 0 to High(FCards) do
  begin
    FCards[I].BeginUpdate;
    for ap := Low(TTMSFNCCardPanelAccentPosition) to High(TTMSFNCCardPanelAccentPosition) do
      if FAccentRadios[ap].Checked then
        FCards[I].Appearance.AccentPosition := ap;
    if FRaisedRadio.Checked then
    begin
      FCards[I].Appearance.Elevation := 2;
      FCards[I].Appearance.HoverElevation := 4;
    end
    else
    begin
      FCards[I].Appearance.Elevation := 0;
      FCards[I].Appearance.HoverElevation := 0;
    end;
    FCards[I].Header.ShowDivider := FDividerCheck.Checked;
    FCards[I].Footer.Visible := FFooterCheck.Checked;
    FCards[I].Clickable := FClickableCheck.Checked;
    FCards[I].EndUpdate;
  end;
end;

procedure TForm1.SettingChanged(Sender: TObject);
begin
  ApplySettings;
end;

procedure TForm1.CardPartClick(Sender: TObject; APart: TTMSFNCCardPanelPart);
const
  PartNames: array[TTMSFNCCardPanelPart] of string = ('nowhere', 'the header', 'the body', 'the footer',
    'the accent bar', 'the picture');
begin
  FStatus.Text := '<b>' + TTMSFNCCardPanel(Sender).Header.Text + '</b>: ' + PartNames[APart];
end;

end.
