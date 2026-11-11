unit UDemo;

{ TMS FNC UI Pack - Avatar

  Artisan Labs people directory. Nine team members across Design, Engineering and Product;
  click any card to see the full profile in the detail pane. The group avatar in the toolbar
  always shows the whole team. Status dots update live when the user picks a new presence. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCCardPanel, VCL.TMSFNCStackPanel, VCL.TMSFNCAvatar, VCL.TMSFNCSampleData,
  VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCCardPanel, FMX.TMSFNCStackPanel, FMX.TMSFNCAvatar, FMX.TMSFNCSampleData,
  FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton,
  WEBLib.TMSFNCCardPanel, WEBLib.TMSFNCStackPanel, WEBLib.TMSFNCAvatar, WEBLib.TMSFNCSampleData,
  WEBLib.TMSFNCTheme, WEBLib.TMSFNCThemeSelector,
  {$ENDIF}
  UDemoLayout;

type
  TPerson = record
    Name: string;
    Title: string;
    Dept: string;
    Email: string;
    Status: TTMSFNCAvatarStatus;
  end;

  TForm1 = class(TDemoForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TTMSFNCPanel;
    DemoTitle: TTMSFNCHTMLText;
    DemoDescription: TTMSFNCHTMLText;
    DemoThemeSelector: TTMSFNCThemeSelector;
    procedure FormCreate(Sender: TObject);
  private
    FLayout: TDemoLayout;
    FContent: TTMSFNCPanel;
    FToolbar: TTMSFNCPanel;
    FCompanyLabel: TTMSFNCHTMLText;
    FTeamAvatar: TTMSFNCAvatar;
    FCards: array[0..8] of TTMSFNCCardPanel;
    FAvatars: array[0..8] of TTMSFNCAvatar;
    FSelected: Integer;
    FDetailPanel: TTMSFNCPanel;
    FDetailAvatar: TTMSFNCAvatar;
    FDetailName: TTMSFNCHTMLText;
    FDetailTitle: TTMSFNCHTMLText;
    FDetailDept: TTMSFNCHTMLText;
    FDetailEmail: TTMSFNCHTMLText;
    FStatusRadios: array[0..4] of TTMSFNCRadioButton;
    procedure CreateToolbar;
    procedure CreateCards;
    procedure CreateDetail;
    procedure SelectPerson(AIndex: Integer);
    procedure CardClick(Sender: TObject);
    procedure StatusChanged(Sender: TObject);
  public
  end;

var
  Form1: TForm1;

const
  { accent per department: Design = purple, Engineering = steelblue, Product = darkgreen }
  DeptAccent: array[0..2] of TTMSFNCGraphicsColor = (gcMediumorchid, gcSteelblue, gcMediumseagreen);

  People: array[0..8] of TPerson = (
    (Name: 'Olivia Bennett'; Title: 'Creative Director'; Dept: 'Design';
     Email: 'olivia@artisanlabs.io'; Status: avstOnline),
    (Name: 'Liam Carter'; Title: 'UX Designer'; Dept: 'Design';
     Email: 'liam@artisanlabs.io'; Status: avstAway),
    (Name: 'Sofia Martins'; Title: 'Visual Designer'; Dept: 'Design';
     Email: 'sofia@artisanlabs.io'; Status: avstBusy),
    (Name: 'Noah Fischer'; Title: 'Engineering Lead'; Dept: 'Engineering';
     Email: 'noah@artisanlabs.io'; Status: avstOnline),
    (Name: 'Emma Laurent'; Title: 'Senior Engineer'; Dept: 'Engineering';
     Email: 'emma@artisanlabs.io'; Status: avstOnline),
    (Name: 'Lucas Novak'; Title: 'Backend Engineer'; Dept: 'Engineering';
     Email: 'lucas@artisanlabs.io'; Status: avstDoNotDisturb),
    (Name: 'Ava Thompson'; Title: 'Product Manager'; Dept: 'Product';
     Email: 'ava@artisanlabs.io'; Status: avstOnline),
    (Name: 'Mateo Rossi'; Title: 'Product Analyst'; Dept: 'Product';
     Email: 'mateo@artisanlabs.io'; Status: avstAway),
    (Name: 'James Holm'; Title: 'Growth Lead'; Dept: 'Product';
     Email: 'james@artisanlabs.io'; Status: avstOffline)
  );

  StatusNames: array[0..4] of string = ('Online', 'Away', 'Busy', 'Do not disturb', 'Offline');
  StatusValues: array[0..4] of TTMSFNCAvatarStatus = (
    avstOnline, avstAway, avstBusy, avstDoNotDisturb, avstOffline);

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
  FSelected := -1;
  FContent := FLayout.AddContentPanel(Self);
  CreateToolbar;
  CreateDetail;
  CreateCards;
  SelectPerson(0);
end;

procedure TForm1.CreateToolbar;
var
  I: Integer;
begin
  FToolbar := FLayout.AddPanel(FContent, daTop, 56, 0, 0, 0, 1);
  FToolbar.Fill.Kind := gfkSolid;
  FToolbar.Stroke.Kind := gskNone;

  FCompanyLabel := TTMSFNCHTMLText.Create(Self);
  FCompanyLabel.Parent := FToolbar;
  FLayout.Place(FCompanyLabel, daLeft, 180, 16, 0, 0, 0);
  FCompanyLabel.Text := '<b>Artisan Labs</b>';
  FCompanyLabel.VerticalTextAlign := gtaCenter;
  FCompanyLabel.HorizontalTextAlign := gtaLeading;
  {$IFDEF FMX}
  FCompanyLabel.Font.Size := 15;
  {$ELSE}
  FCompanyLabel.Font.Height := -FLayout.Size(15);
  {$ENDIF}

  FTeamAvatar := TTMSFNCAvatar.Create(Self);
  FTeamAvatar.Parent := FToolbar;
  FLayout.Place(FTeamAvatar, daLeft, 160, 0, 8, 0, 8);
  FTeamAvatar.Size := avzSmall;
  FTeamAvatar.MaxVisible := 5;
  for I := 0 to 8 do
    FTeamAvatar.Items.AddAvatar(People[I].Name, People[I].Status);
end;

procedure TForm1.CreateCards;
var
  flow: TTMSFNCFlowPanel;
  card: TTMSFNCCardPanel;
  av: TTMSFNCAvatar;
  cards: TTMSFNCPanel;
  I: Integer;
begin
  cards := FLayout.AddPanel(FContent, daClient, 0, 0, 0, 0, 0);
  cards.Fill.Kind := gfkNone;
  cards.Stroke.Kind := gskNone;

  flow := TTMSFNCFlowPanel.Create(Self);
  flow.Parent := cards;
  FLayout.Place(flow, daClient, 0, 0, 0, 0, 0);
  flow.HorizontalGap := FLayout.Size(16);
  flow.VerticalGap := FLayout.Size(16);
  flow.ContentPadding.Rect := RectF(FLayout.Size(16), FLayout.Size(16),
    FLayout.Size(16), FLayout.Size(16));

  for I := 0 to 8 do
  begin
    card := TTMSFNCCardPanel.Create(Self);
    card.Parent := flow;
    card.Width := FLayout.Size(160);
    card.Height := FLayout.Size(200);
    card.Clickable := True;
    card.Header.Text := People[I].Name;
    card.Header.Description := People[I].Title;
    card.Header.Height := FLayout.Size(60);
    card.Header.ShowDivider := True;
    card.Appearance.AccentPosition := capLeft;
    card.Appearance.AccentColor := DeptAccent[I div 3];
    card.Tag := I;
    card.OnClick := {$IFDEF WEBLIB}@{$ENDIF}CardClick;

    av := TTMSFNCAvatar.Create(Self);
    av.Parent := card;
    av.Size := avzLarge;
    av.Text := People[I].Name;
    av.Status := People[I].Status;
    {$IFDEF FMX}
    av.Position.X := (FLayout.Size(160) - 56) / 2;
    av.Position.Y := FLayout.Size(16);
    {$ELSE}
    av.Left := (FLayout.Size(160) - FLayout.Size(56)) div 2;
    av.Top := FLayout.Size(16);
    {$ENDIF}
    av.Width := FLayout.Size(56);
    av.Height := FLayout.Size(56);

    FCards[I] := card;
    FAvatars[I] := av;
  end;
end;

procedure TForm1.CreateDetail;
var
  I: Integer;
begin
  FDetailPanel := FLayout.AddPanel(FContent, daRight, 280, 0, 0, 0, 0);
  FDetailPanel.Stroke.Kind := gskSolid;

  FDetailAvatar := TTMSFNCAvatar.Create(Self);
  FDetailAvatar.Parent := FDetailPanel;
  FDetailAvatar.Size := avzExtraLarge;
  {$IFDEF FMX}
  FDetailAvatar.Align := TAlignLayout.None;
  FDetailAvatar.Position.X := (FLayout.Size(280) - 72) / 2;
  FDetailAvatar.Position.Y := FLayout.Size(24);
  {$ELSE}
  FDetailAvatar.Left := (FLayout.Size(280) - FLayout.Size(72)) div 2;
  FDetailAvatar.Top := FLayout.Size(24);
  {$ENDIF}
  FDetailAvatar.Width := FLayout.Size(72);
  FDetailAvatar.Height := FLayout.Size(96);

  FDetailName := TTMSFNCHTMLText.Create(Self);
  FDetailName.Parent := FDetailPanel;
  FLayout.Place(FDetailName, daTop, 32, 16, 136, 16, 2);
  FDetailName.HorizontalTextAlign := gtaCenter;
  FDetailName.VerticalTextAlign := gtaCenter;
  {$IFDEF FMX}
  FDetailName.Font.Style := [TFontStyle.fsBold];
  FDetailName.Font.Size := 14;
  {$ELSE}
  FDetailName.Font.Style := [fsBold];
  FDetailName.Font.Height := -FLayout.Size(14);
  {$ENDIF}

  FDetailTitle := TTMSFNCHTMLText.Create(Self);
  FDetailTitle.Parent := FDetailPanel;
  FLayout.Place(FDetailTitle, daTop, 24, 16, 2, 16, 2);
  FDetailTitle.HorizontalTextAlign := gtaCenter;
  FDetailTitle.TextRole := htrSecondary;

  FDetailDept := TTMSFNCHTMLText.Create(Self);
  FDetailDept.Parent := FDetailPanel;
  FLayout.Place(FDetailDept, daTop, 24, 16, 2, 16, 8);
  FDetailDept.HorizontalTextAlign := gtaCenter;
  FDetailDept.TextRole := htrTertiary;

  FDetailEmail := TTMSFNCHTMLText.Create(Self);
  FDetailEmail.Parent := FDetailPanel;
  FLayout.Place(FDetailEmail, daTop, 24, 16, 0, 16, 16);
  FDetailEmail.HorizontalTextAlign := gtaCenter;
  FDetailEmail.TextRole := htrSecondary;

  FLayout.AddCaption(FDetailPanel, 'Presence', 4);
  for I := 0 to 4 do
  begin
    FStatusRadios[I] := FLayout.AddRadio(FDetailPanel, StatusNames[I], 'Status', I = 0,
      {$IFDEF WEBLIB}@{$ENDIF}StatusChanged);
    FStatusRadios[I].Tag := I;
  end;
end;

procedure TForm1.SelectPerson(AIndex: Integer);
var
  I: Integer;
begin
  if (AIndex < 0) or (AIndex > 8) then
    Exit;

  { highlight selected card; remove highlight from others }
  if FSelected >= 0 then
    FCards[FSelected].Appearance.AccentPosition := capLeft;
  FSelected := AIndex;
  FCards[FSelected].Appearance.AccentPosition := capTop;

  FDetailAvatar.Text := People[AIndex].Name;
  FDetailAvatar.Status := People[AIndex].Status;
  FDetailName.Text := People[AIndex].Name;
  FDetailTitle.Text := People[AIndex].Title;
  FDetailDept.Text := People[AIndex].Dept;
  FDetailEmail.Text := People[AIndex].Email;

  for I := 0 to 4 do
    FStatusRadios[I].Checked := StatusValues[I] = People[AIndex].Status;
end;

procedure TForm1.CardClick(Sender: TObject);
begin
  SelectPerson((Sender as TTMSFNCCardPanel).Tag);
end;

procedure TForm1.StatusChanged(Sender: TObject);
var
  newStatus: TTMSFNCAvatarStatus;
  I: Integer;
begin
  if FSelected < 0 then
    Exit;
  if not (Sender as TTMSFNCRadioButton).Checked then
    Exit;

  newStatus := StatusValues[(Sender as TTMSFNCRadioButton).Tag];
  FAvatars[FSelected].Status := newStatus;
  FDetailAvatar.Status := newStatus;

  { update the team group avatar member status }
  for I := 0 to FTeamAvatar.Items.Count - 1 do
    if FTeamAvatar.Items[I].Text = People[FSelected].Name then
      FTeamAvatar.Items[I].Status := newStatus;
end;

end.
