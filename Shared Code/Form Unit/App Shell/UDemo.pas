unit UDemo;

{ TMS FNC UI Pack - App Shell

  The new controls of 8.0 together, the way an application uses them: a menu bar and the brand logo on top, a
  split view rail that switches the pages, a breadcrumb that follows the navigation, a dashboard of cards and a
  team list that shows a skeleton while it loads, a project list with a header control, an accordion of
  expanders, an onboarding stepper and toasts for every action. Switch the theme in the header: the whole shell
  follows. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Menus,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCMenuBar,
  VCL.TMSFNCSplitView, VCL.TMSFNCBreadcrumb, VCL.TMSFNCScrollBox, VCL.TMSFNCStackPanel, VCL.TMSFNCCardPanel,
  VCL.TMSFNCRepeater, VCL.TMSFNCListView, VCL.TMSFNCHeaderControl, VCL.TMSFNCGroupBox, VCL.TMSFNCStepper,
  VCL.TMSFNCSkeleton, VCL.TMSFNCToast, VCL.TMSFNCAvatar, VCL.TMSFNCBadge, VCL.TMSFNCDivider, VCL.TMSFNCBrandLogo,
  VCL.TMSFNCThemeSelector, VCL.TMSFNCAccentSelector, VCL.TMSFNCSampleData, VCL.TMSFNCTheme,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs, FMX.Menus,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCMenuBar,
  FMX.TMSFNCSplitView, FMX.TMSFNCBreadcrumb, FMX.TMSFNCScrollBox, FMX.TMSFNCStackPanel, FMX.TMSFNCCardPanel,
  FMX.TMSFNCRepeater, FMX.TMSFNCListView, FMX.TMSFNCHeaderControl, FMX.TMSFNCGroupBox, FMX.TMSFNCStepper,
  FMX.TMSFNCSkeleton, FMX.TMSFNCToast, FMX.TMSFNCAvatar, FMX.TMSFNCBadge, FMX.TMSFNCDivider, FMX.TMSFNCBrandLogo,
  FMX.TMSFNCThemeSelector, FMX.TMSFNCAccentSelector, FMX.TMSFNCSampleData, FMX.TMSFNCTheme,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs, WEBLib.ExtCtrls, WEBLib.Menus,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCMenuBar, WEBLib.TMSFNCSplitView, WEBLib.TMSFNCBreadcrumb,
  WEBLib.TMSFNCScrollBox, WEBLib.TMSFNCStackPanel, WEBLib.TMSFNCCardPanel, WEBLib.TMSFNCRepeater,
  WEBLib.TMSFNCListView, WEBLib.TMSFNCHeaderControl, WEBLib.TMSFNCGroupBox, WEBLib.TMSFNCStepper,
  WEBLib.TMSFNCSkeleton, WEBLib.TMSFNCToast, WEBLib.TMSFNCAvatar, WEBLib.TMSFNCBadge, WEBLib.TMSFNCDivider,
  WEBLib.TMSFNCBrandLogo, WEBLib.TMSFNCThemeSelector, WEBLib.TMSFNCAccentSelector, WEBLib.TMSFNCSampleData,
  WEBLib.TMSFNCTheme,
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
    FContent: TTMSFNCPanel;
    FMenuBar: TTMSFNCMenuBar;
    FLogo: TTMSFNCBrandLogo;
    FSplit: TTMSFNCSplitView;
    FBreadcrumb: TTMSFNCBreadcrumb;
    FPages: array[0..3] of TTMSFNCPanel;
    FPageIndex: Integer;
    FRailPages: array of Integer;
    FToast: TTMSFNCToast;
    { dashboard }
    FDashboard: TTMSFNCScrollBox;
    FDashboardStack: TTMSFNCStackPanel;
    FSkeleton: TTMSFNCSkeleton;
    FLoadTimer: TTimer;
    FTeam: TTMSFNCRepeater;
    FTeamAvatar: TTMSFNCAvatar;
    FTeamName: TTMSFNCHTMLText;
    FTeamTask: TTMSFNCHTMLText;
    FTeamBadge: TTMSFNCBadge;
    FNames: TArray<string>;
    FTasks: TArray<TTMSFNCSampleProjectTask>;
    { projects }
    FProjectHeader: TTMSFNCHeaderControl;
    FProjects: TTMSFNCListView;
    { team }
    FAccordion: array[0..2] of TTMSFNCGroupBox;
    { settings }
    FStepper: TTMSFNCStepper;
    FStepText: TTMSFNCHTMLText;
    FBackButton: TTMSFNCButton;
    FNextButton: TTMSFNCButton;
    FAccent: TTMSFNCAccentSelector;
    FCompactCheck: TTMSFNCCheckBox;
    FOverlayCheck: TTMSFNCCheckBox;
    function NewMenu(const AItems: array of string): TTMSFNCMenuBarPopupMenu;
    function AddPage(AParent: TDemoParent): TTMSFNCPanel;
    function AddRailItem(const AText, AIcon: string; APage: Integer): TTMSFNCSplitViewItem;
    function AddCard(AParent: TDemoParent; const ATitle, AValue, ADetail: string; AKind: TTMSFNCStatusKind;
      const ABadge: string): TTMSFNCCardPanel;
    procedure CreateShell;
    procedure CreateDashboard(APage: TTMSFNCPanel);
    procedure CreateProjects(APage: TTMSFNCPanel);
    procedure CreateTeam(APage: TTMSFNCPanel);
    procedure CreateSettings(APage: TTMSFNCPanel);
    procedure ShowPage(AIndex: Integer);
    procedure ShowStep;
    procedure StartLoading;
    procedure LoadTimer(Sender: TObject);
    procedure MenuItemClick(Sender: TObject);
    procedure RailChanged(Sender: TObject);
    procedure BreadcrumbClick(Sender: TObject; AIndex: Integer);
    procedure TeamDraw(Sender: TObject; AGraphics: TTMSFNCGraphics; AIndex: Integer; ARect: TRectF;
      var AAllow: Boolean; var ADefaultDraw: Boolean);
    procedure TeamClick(Sender: TObject; AIndex: Integer; AControl: TControl);
    procedure CardClick(Sender: TObject; APart: TTMSFNCCardPanelPart);
    procedure ProjectSelected(Sender: TObject);
    procedure ProjectSorted(Sender: TObject; ASection: TTMSFNCHeaderControlSection;
      ASortIndicator: TTMSFNCHeaderControlSortIndicator);
    procedure HeaderResized(Sender: TObject; ASection: TTMSFNCHeaderControlSection);
    procedure GroupToggled(Sender: TObject);
    procedure StepChanged(Sender: TObject);
    procedure BackClick(Sender: TObject);
    procedure NextClick(Sender: TObject);
    procedure RailOptionChanged(Sender: TObject);
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
  PageNames: array[0..3] of string = ('Dashboard', 'Projects', 'Team', 'Settings');
  StepTexts: array[0..3] of string = (
    '<b>Welcome</b><br><br>Tell the workspace who you are: the name on the avatar and the e-mail the toasts ' +
    'mention.',
    '<b>Workspace</b><br><br>Pick the projects the dashboard shows. The rail badge counts the ones that need ' +
    'attention.',
    '<b>Notifications</b><br><br>Toasts appear in the bottom right corner of the shell: choose what you want ' +
    'to hear about.',
    '<b>Ready</b><br><br>Finish closes the onboarding and the shell remembers it.');

procedure TForm1.FormCreate(Sender: TObject);
begin
  FLayout := TDemoLayout.Create(Self);
  FNames := TTMSFNCSampleData.People;
  FTasks := TTMSFNCSampleData.ProjectTasks;
  CreateShell;
  CreateDashboard(FPages[0]);
  CreateProjects(FPages[1]);
  CreateTeam(FPages[2]);
  CreateSettings(FPages[3]);
  FPageIndex := -1;
  ShowPage(0);
  StartLoading;
end;

function TForm1.NewMenu(const AItems: array of string): TTMSFNCMenuBarPopupMenu;
var
  I: Integer;
  mi: TMenuItem;
begin
  Result := TTMSFNCMenuBarPopupMenu.Create(Self);
  for I := 0 to High(AItems) do
  begin
    mi := TMenuItem.Create(Result);
    {$IFDEF FMX}mi.Text{$ELSE}mi.Caption{$ENDIF} := AItems[I];
    if AItems[I] <> '-' then
      mi.OnClick := {$IFDEF WEBLIB}@{$ENDIF}MenuItemClick;
    {$IFDEF FMX}
    Result.AddObject(mi);
    {$ELSE}
    Result.Items.Add(mi);
    {$ENDIF}
  end;
end;

procedure TForm1.CreateShell;
var
  bar, body, main: TTMSFNCPanel;
  I: Integer;
begin
  { the shell fills the demo area: no settings panel, the shell has its own settings page }
  FContent := FLayout.AddContentPanel(Self);
  FContent.Fill.Kind := gfkSolid;
  FContent.Stroke.Kind := gskSolid;

  { the top bar: brand logo and the menu bar }
  bar := FLayout.AddPanel(FContent, daTop, 36, 1, 1, 1, 0);
  bar.Fill.Kind := gfkNone;
  bar.Stroke.Kind := gskNone;
  FLogo := TTMSFNCBrandLogo.Create(Self);
  FLogo.Parent := bar;
  FLayout.Place(FLogo, daLeft, 180, 8, 2, 8, 2);
  FLogo.Kind := blkMarkAndAppName;
  FMenuBar := TTMSFNCMenuBar.Create(Self);
  FMenuBar.Parent := bar;
  FLayout.Place(FMenuBar, daClient, 0, 0, 2, 0, 2);
  FMenuBar.Items.Clear;
  FMenuBar.Items.AddItem('&File', NewMenu(['&New project', '&Open...', '-', 'E&xit']));
  FMenuBar.Items.AddItem('&View', NewMenu(['&Dashboard', '&Projects', '&Team', '&Settings', '-', '&Reload']));
  FMenuBar.Items.AddItem('&Help', NewMenu(['&Documentation', '&About']));

  body := FLayout.AddPanel(FContent, daClient, 0, 1, 0, 1, 1);
  body.Fill.Kind := gfkNone;
  body.Stroke.Kind := gskNone;

  { the pages sit right of the rail; the breadcrumb above them follows the navigation }
  main := FLayout.AddPanel(body, daClient, 0, 0, 0, 0, 0);
  main.Fill.Kind := gfkNone;
  main.Stroke.Kind := gskNone;
  FBreadcrumb := TTMSFNCBreadcrumb.Create(Self);
  FBreadcrumb.Parent := main;
  FLayout.Place(FBreadcrumb, daTop, 36, 16, 8, 16, 0);
  FBreadcrumb.Items.AddItem('Home');
  FBreadcrumb.Items.AddItem(PageNames[0]);
  FBreadcrumb.OnItemClick := {$IFDEF WEBLIB}@{$ENDIF}BreadcrumbClick;
  for I := 0 to High(FPages) do
    FPages[I] := AddPage(main);

  { the rail: the pages, a badge on the projects, two recent projects and the settings in the footer }
  FSplit := TTMSFNCSplitView.Create(Self);
  FSplit.Parent := body;
  FSplit.Title := 'Workspace';
  FSplit.OpenedWidth := 200;
  FSplit.BeginUpdate;
  AddRailItem(PageNames[0], 'Star', 0);
  AddRailItem(PageNames[1], 'Folder', 1).Badge := '3';
  AddRailItem(PageNames[2], 'People', 2);
  AddRailItem('Recent', '', -2);
  AddRailItem('Website redesign', 'Document', 1);
  AddRailItem('Mobile app', 'Document', 1);
  AddRailItem(PageNames[3], 'Settings', 3).Footer := True;
  FSplit.EndUpdate;
  FSplit.ItemIndex := 0;
  FSplit.OnItemIndexChanged := {$IFDEF WEBLIB}@{$ENDIF}RailChanged;

  FToast := TTMSFNCToast.Create(Self);
  FToast.Host := FContent;
  FToast.Position := tpsBottomRight;
end;

function TForm1.AddPage(AParent: TDemoParent): TTMSFNCPanel;
begin
  Result := FLayout.AddPanel(AParent, daClient, 0, 16, 8, 16, 16);
  Result.Fill.Kind := gfkNone;
  Result.Stroke.Kind := gskNone;
  Result.Visible := False;
end;

function TForm1.AddRailItem(const AText, AIcon: string; APage: Integer): TTMSFNCSplitViewItem;
begin
  { the page an item opens, by item index: -2 is a header, -1 nothing }
  if APage = -2 then
    Result := FSplit.Items.AddHeader(AText)
  else
    Result := FSplit.Items.Add(AText, AIcon);
  SetLength(FRailPages, Result.Index + 1);
  FRailPages[Result.Index] := APage;
end;

function TForm1.AddCard(AParent: TDemoParent; const ATitle, AValue, ADetail: string; AKind: TTMSFNCStatusKind;
  const ABadge: string): TTMSFNCCardPanel;
var
  v: TTMSFNCHTMLText;
  b: TTMSFNCBadge;
begin
  Result := TTMSFNCCardPanel.Create(Self);
  Result.Parent := AParent;
  Result.Width := FLayout.Size(220);
  Result.Height := FLayout.Size(130);
  Result.Header.Text := ATitle;
  Result.Footer.Text := ADetail;
  Result.OnPartClick := {$IFDEF WEBLIB}@{$ENDIF}CardClick;
  v := TTMSFNCHTMLText.Create(Self);
  v.Parent := Result;
  FLayout.Place(v, daLeft, 110, 0, 0, 0, 0);
  v.Fill.Kind := gfkNone;
  v.Stroke.Kind := gskNone;
  v.HorizontalTextAlign := gtaLeading;
  {$IFDEF FMX}
  v.Font.Size := 22;
  {$ELSE}
  v.Font.Height := -FLayout.Size(22);
  {$ENDIF}
  v.Text := AValue;
  b := TTMSFNCBadge.Create(Self);
  b.Parent := Result;
  FLayout.Place(b, daLeft, 80, 4, 12, 0, 12);
  b.Kind := AKind;
  b.ShowDot := True;
  b.Text := ABadge;
end;

procedure TForm1.CreateDashboard(APage: TTMSFNCPanel);
var
  flow: TTMSFNCFlowPanel;
  d: TTMSFNCDivider;
begin
  { everything of the dashboard is in a scroll box, its stack panel sizes to the content }
  FDashboard := TTMSFNCScrollBox.Create(Self);
  FDashboard.Parent := APage;
  FLayout.Place(FDashboard, daClient, 0, 0, 0, 0, 0);
  FDashboard.Appearance.Fill.Kind := gfkNone;
  FDashboard.Appearance.Stroke.Kind := gskNone;
  FDashboardStack := TTMSFNCStackPanel.Create(Self);
  FDashboardStack.Parent := FDashboard;
  FDashboardStack.SetBounds(0, 0, FLayout.Size(760), FLayout.Size(100));
  FDashboardStack.SizeToContent := True;
  FDashboardStack.Appearance.Stroke.Kind := gskNone;
  FDashboardStack.Gap := 8;

  d := TTMSFNCDivider.Create(Self);
  d.Parent := FDashboardStack;
  d.Width := FLayout.Size(760);
  d.Height := FLayout.Size(28);
  d.Text := 'This week';
  d.TextPosition := dtpStart;

  flow := TTMSFNCFlowPanel.Create(Self);
  flow.Parent := FDashboardStack;
  flow.Width := FLayout.Size(760);
  flow.Height := FLayout.Size(140);
  flow.SizeToContent := True;
  flow.Appearance.Stroke.Kind := gskNone;
  flow.HorizontalGap := 12;
  flow.VerticalGap := 12;
  AddCard(flow, 'Open orders', '128', '14 due today', tskWarning, 'Attention');
  AddCard(flow, 'Revenue', '348,300', 'plus 5.1% on last quarter', tskSuccess, 'On track');
  AddCard(flow, 'Support cases', '7', '2 waiting for an answer', tskError, 'Overdue');
  AddCard(flow, 'Builds', '42', 'all green since Monday', tskInfo, 'Stable');

  d := TTMSFNCDivider.Create(Self);
  d.Parent := FDashboardStack;
  d.Width := FLayout.Size(760);
  d.Height := FLayout.Size(28);
  d.Text := 'Team activity';
  d.TextPosition := dtpStart;

  { the team list: one template of controls drawn for every member }
  FTeam := TTMSFNCRepeater.Create(Self);
  FTeam.Parent := FDashboardStack;
  FTeam.Width := FLayout.Size(760);
  FTeam.Height := FLayout.Size(248);
  FTeam.ItemHeight := 60;
  FTeam.Appearance.ItemStroke.Kind := gskSolid;
  FTeam.Appearance.ItemMargin := 4;
  FTeam.Appearance.ItemRounding := 8;
  FTeamAvatar := TTMSFNCAvatar.Create(Self);
  FTeamAvatar.Parent := FTeam;
  FTeamAvatar.Size := avzSmall;
  {$IFDEF FMX}
  FTeamAvatar.Position.Point := PointF(14, 14);
  {$ELSE}
  FTeamAvatar.Left := FLayout.Size(14);
  FTeamAvatar.Top := FLayout.Size(14);
  {$ENDIF}
  FTeamName := TTMSFNCHTMLText.Create(Self);
  FTeamName.Parent := FTeam;
  FTeamName.SetBounds(FLayout.Size(62), FLayout.Size(9), FLayout.Size(260), FLayout.Size(22));
  FTeamName.Fill.Kind := gfkNone;
  FTeamName.Stroke.Kind := gskNone;
  FTeamName.HorizontalTextAlign := gtaLeading;
  FTeamTask := TTMSFNCHTMLText.Create(Self);
  FTeamTask.Parent := FTeam;
  FTeamTask.SetBounds(FLayout.Size(62), FLayout.Size(30), FLayout.Size(400), FLayout.Size(20));
  FTeamTask.Fill.Kind := gfkNone;
  FTeamTask.Stroke.Kind := gskNone;
  FTeamTask.HorizontalTextAlign := gtaLeading;
  FTeamTask.TextRole := htrSecondary;
  FTeamBadge := TTMSFNCBadge.Create(Self);
  FTeamBadge.Parent := FTeam;
  FTeamBadge.SetBounds(FLayout.Size(620), FLayout.Size(18), FLayout.Size(100), FLayout.Size(24));
  FTeamBadge.ShowDot := True;
  FTeam.OnBeforeDrawItem := {$IFDEF WEBLIB}@{$ENDIF}TeamDraw;
  FTeam.OnItemClick := {$IFDEF WEBLIB}@{$ENDIF}TeamClick;
  FTeam.ItemCount := Length(FTasks);
  FDashboard.UpdateContent;

  { the skeleton covers the dashboard while it loads }
  FSkeleton := TTMSFNCSkeleton.Create(Self);
  FSkeleton.Parent := APage;
  FLayout.Place(FSkeleton, daClient, 0, 0, 0, 0, 0);
  FSkeleton.Preset := skpList;
  FLoadTimer := TTimer.Create(Self);
  FLoadTimer.Enabled := False;
  FLoadTimer.Interval := 1500;
  FLoadTimer.OnTimer := {$IFDEF WEBLIB}@{$ENDIF}LoadTimer;
end;

procedure TForm1.CreateProjects(APage: TTMSFNCPanel);
var
  I, g: Integer;
  it: TTMSFNCListViewItem;
begin
  { a header control above a list view in report style: the header sorts and resizes, the list follows }
  FProjectHeader := TTMSFNCHeaderControl.Create(Self);
  FProjectHeader.Parent := APage;
  FLayout.Place(FProjectHeader, daTop, 34, 0, 0, 0, 0);
  FProjectHeader.Sections.AddSection('Task', 300);
  FProjectHeader.Sections.AddSection('Owner', 140);
  FProjectHeader.Sections.AddSection('Status', 120);
  FProjectHeader.Sections.AddSection('Progress', 100).Alignment := gtaTrailing;
  FProjectHeader.StretchLastSection := True;
  FProjectHeader.OnSortChanged := {$IFDEF WEBLIB}@{$ENDIF}ProjectSorted;
  FProjectHeader.OnSectionResized := {$IFDEF WEBLIB}@{$ENDIF}HeaderResized;
  FProjects := TTMSFNCListView.Create(Self);
  FProjects.Parent := APage;
  FLayout.Place(FProjects, daClient, 0, 0, 0, 0, 0);
  FProjects.BeginUpdate;
  FProjects.ShowColumnHeaders := False;
  FProjects.Columns.Add('Task', 300);
  FProjects.Columns.Add('Owner', 140);
  FProjects.Columns.Add('Status', 120);
  FProjects.Columns.Add('Progress', 100).Alignment := gtaTrailing;
  for I := 0 to High(FTasks) do
  begin
    g := FProjects.Groups.Count - 1;
    while (g >= 0) and (FProjects.Groups[g].Text <> FTasks[I].Project) do
      Dec(g);
    if g < 0 then
      g := FProjects.Groups.Add(FTasks[I].Project).Index;
    it := FProjects.Items.Add(FTasks[I].Task, [FTasks[I].Owner, FTasks[I].Status,
      IntToStr(FTasks[I].Progress) + '%'], 'Document', g);
    it.Checked := FTasks[I].Progress >= 100;
  end;
  FProjects.EndUpdate;
  FProjects.OnSelectionChanged := {$IFDEF WEBLIB}@{$ENDIF}ProjectSelected;
end;

procedure TForm1.CreateTeam(APage: TTMSFNCPanel);
const
  Groups: array[0..2] of string = ('Design', 'Mobile', 'Platform');
  Details: array[0..2] of string = ('Three people, two open positions', 'Four people', 'Five people');
var
  I, J: Integer;
  row: TTMSFNCStackPanel;
  a: TTMSFNCAvatar;
begin
  { an accordion of expanders, each with the avatars of its members }
  for I := 0 to 2 do
  begin
    FAccordion[I] := TTMSFNCGroupBox.Create(Self);
    FAccordion[I].Parent := APage;
    FLayout.Place(FAccordion[I], daTop, 150, 0, 0, 0, 12);
    FAccordion[I].Caption := Groups[I];
    FAccordion[I].Description := Details[I];
    FAccordion[I].Collapsible := True;
    FAccordion[I].Collapsed := I > 0;
    FAccordion[I].OnAfterExpand := {$IFDEF WEBLIB}@{$ENDIF}GroupToggled;
    row := TTMSFNCStackPanel.Create(Self);
    row.Parent := FAccordion[I];
    FLayout.Place(row, daClient, 0, 0, 0, 0, 0);
    row.Orientation := spoHorizontal;
    row.Alignment := lpaCenter;
    row.Gap := 16;
    row.Appearance.Stroke.Kind := gskNone;
    for J := 0 to 2 + I do
    begin
      a := TTMSFNCAvatar.Create(Self);
      a.Parent := row;
      a.Size := avzLarge;
      a.Text := FNames[(I * 4 + J) mod Length(FNames)];
      a.Hint := a.Text;
      a.ShowHint := True;
      a.Status := TTMSFNCAvatarStatus(1 + (I + J) mod 5);
    end;
  end;
  FLayout.AddText(APage, 'Open one group and the others close: the expanders are an accordion. Hover an ' +
    'avatar for the name; the dot is the presence.', 44);
end;

procedure TForm1.CreateSettings(APage: TTMSFNCPanel);
var
  side: TTMSFNCPanel;
  buttons: TTMSFNCPanel;
begin
  { the rail and accent options on the right }
  side := FLayout.AddPanel(APage, daRight, 260, 16, 0, 0, 0);
  FLayout.AddCaption(side, 'Rail', 12);
  FCompactCheck := FLayout.AddCheck(side, 'Compact rail of icons when closed', True, {$IFDEF WEBLIB}@{$ENDIF}RailOptionChanged);
  FOverlayCheck := FLayout.AddCheck(side, 'Overlay over the pages', False, {$IFDEF WEBLIB}@{$ENDIF}RailOptionChanged);
  FLayout.AddCaption(side, 'Accent');
  FAccent := TTMSFNCAccentSelector.Create(Self);
  FAccent.Parent := side;
  FLayout.Place(FAccent, daTop, 40, 16, 0, 16, 0);
  FAccent.ThemeManager := ThemeManager;
  FLayout.AddText(side, 'The accent colours the rail selection, the badges, the stepper and the primary ' +
    'button; Light and Dark are in the header.', 64);

  { the onboarding: a stepper above the page it drives }
  FStepper := TTMSFNCStepper.Create(Self);
  FStepper.Parent := APage;
  FLayout.Place(FStepper, daTop, 84, 0, 0, 0, 8);
  FStepper.Steps.AddStep('Profile', 'Who you are', 'People');
  FStepper.Steps.AddStep('Workspace', 'What you see', 'Folder');
  FStepper.Steps.AddStep('Notifications', 'What you hear', 'Info');
  FStepper.Steps.AddStep('Done', 'Start working', 'Checkmark');
  FStepper.OnActiveStepChanged := {$IFDEF WEBLIB}@{$ENDIF}StepChanged;
  buttons := FLayout.AddPanel(APage, daBottom, 48, 0, 8, 0, 0);
  buttons.Fill.Kind := gfkNone;
  buttons.Stroke.Kind := gskNone;
  FNextButton := TTMSFNCButton.Create(Self);
  FNextButton.Parent := buttons;
  FLayout.Place(FNextButton, daRight, 120, 8, 8, 0, 8);
  FNextButton.Default := True;
  FNextButton.OnClick := {$IFDEF WEBLIB}@{$ENDIF}NextClick;
  FBackButton := TTMSFNCButton.Create(Self);
  FBackButton.Parent := buttons;
  FLayout.Place(FBackButton, daRight, 120, 8, 8, 0, 8);
  FBackButton.Text := 'Back';
  FBackButton.OnClick := {$IFDEF WEBLIB}@{$ENDIF}BackClick;
  FStepText := TTMSFNCHTMLText.Create(Self);
  FStepText.Parent := APage;
  FLayout.Place(FStepText, daClient, 0, 0, 0, 0, 0);
  FStepText.HorizontalTextAlign := gtaLeading;
  FStepText.VerticalTextAlign := gtaLeading;
  FStepText.WordWrapping := True;
  ShowStep;
end;

procedure TForm1.ShowPage(AIndex: Integer);
var
  I: Integer;
begin
  if AIndex = FPageIndex then
    Exit;
  FPageIndex := AIndex;
  for I := 0 to High(FPages) do
    FPages[I].Visible := I = AIndex;
  { the breadcrumb: Home > page, a third segment while a project is selected }
  FBreadcrumb.BeginUpdate;
  while FBreadcrumb.Items.Count > 1 do
    FBreadcrumb.Items.Delete(FBreadcrumb.Items.Count - 1);
  FBreadcrumb.Items.AddItem(PageNames[AIndex]);
  FBreadcrumb.EndUpdate;
  { the rail follows a page opened from the menu or the breadcrumb }
  if (FSplit.ItemIndex < 0) or (FRailPages[FSplit.ItemIndex] <> AIndex) then
    for I := 0 to High(FRailPages) do
      if FRailPages[I] = AIndex then
      begin
        FSplit.ItemIndex := I;
        Break;
      end;
end;

procedure TForm1.ShowStep;
begin
  FStepText.Text := StepTexts[FStepper.ActiveStep];
  FBackButton.Enabled := FStepper.ActiveStep > 0;
  if FStepper.ActiveStep = High(StepTexts) then
    FNextButton.Text := 'Finish'
  else
    FNextButton.Text := 'Next';
end;

procedure TForm1.StartLoading;
begin
  FSkeleton.Visible := True;
  FSkeleton.Active := True;
  FDashboard.Visible := False;
  FLoadTimer.Enabled := True;
end;

procedure TForm1.LoadTimer(Sender: TObject);
begin
  FLoadTimer.Enabled := False;
  FSkeleton.Active := False;
  FSkeleton.Visible := False;
  FDashboard.Visible := True;
  FDashboard.UpdateContent;
end;

procedure TForm1.MenuItemClick(Sender: TObject);
var
  s: string;
  I: Integer;
begin
  s := StringReplace({$IFDEF FMX}TMenuItem(Sender).Text{$ELSE}TMenuItem(Sender).Caption{$ENDIF}, '&', '', [rfReplaceAll]);
  for I := 0 to High(PageNames) do
    if s = PageNames[I] then
    begin
      ShowPage(I);
      Exit;
    end;
  if s = 'Reload' then
  begin
    ShowPage(0);
    StartLoading;
    FToast.ShowInfo('Reloading', 'The dashboard shows its skeleton until the data is back.');
  end
  else if s = 'About' then
    FToast.Show('TMS FNC UI Pack 8.0', 'The new controls in one shell: switch the theme in the header.', toastNeutral)
  else if s = 'Exit' then
    FToast.ShowWarning('Not in the demo', 'Exit closes the application; here it only tells you so.')
  else
    FToast.ShowInfo(s, 'Menu command "' + s + '" chosen.');
end;

procedure TForm1.RailChanged(Sender: TObject);
var
  it: TTMSFNCSplitViewItem;
begin
  if (FSplit.ItemIndex < 0) or (FSplit.ItemIndex >= FSplit.Items.Count) then
    Exit;
  it := FSplit.Items[FSplit.ItemIndex];
  if FRailPages[it.Index] < 0 then
    Exit;
  ShowPage(FRailPages[it.Index]);
  if it.Text <> PageNames[FRailPages[it.Index]] then
    FToast.ShowInfo(it.Text, 'A recent project: the projects page opens.');
end;

procedure TForm1.BreadcrumbClick(Sender: TObject; AIndex: Integer);
begin
  if AIndex = 0 then
    ShowPage(0);
end;

procedure TForm1.TeamDraw(Sender: TObject; AGraphics: TTMSFNCGraphics; AIndex: Integer; ARect: TRectF;
  var AAllow: Boolean; var ADefaultDraw: Boolean);
begin
  { the template takes the values of the task about to be drawn }
  FTeamAvatar.Text := FTasks[AIndex].Owner;
  FTeamName.Text := '<b>' + FTasks[AIndex].Owner + '</b>';
  FTeamTask.Text := FTasks[AIndex].Project + ': ' + FTasks[AIndex].Task + ', ' +
    IntToStr(FTasks[AIndex].Progress) + '% done';
  FTeamBadge.Text := FTasks[AIndex].Status;
  FTeamBadge.Kind := FTasks[AIndex].Kind;
end;

procedure TForm1.TeamClick(Sender: TObject; AIndex: Integer; AControl: TControl);
begin
  FToast.ShowAction(FTasks[AIndex].Owner, FTasks[AIndex].Task, 'Open', toastInfo);
end;

procedure TForm1.CardClick(Sender: TObject; APart: TTMSFNCCardPanelPart);
begin
  FToast.ShowInfo(TTMSFNCCardPanel(Sender).Header.Text, TTMSFNCCardPanel(Sender).Footer.Text);
end;

procedure TForm1.ProjectSelected(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to FProjects.Items.Count - 1 do
    if FProjects.Items[I].Selected then
    begin
      FBreadcrumb.BeginUpdate;
      while FBreadcrumb.Items.Count > 2 do
        FBreadcrumb.Items.Delete(FBreadcrumb.Items.Count - 1);
      FBreadcrumb.Items.AddItem(FProjects.Items[I].Text);
      FBreadcrumb.EndUpdate;
      Exit;
    end;
end;

procedure TForm1.ProjectSorted(Sender: TObject; ASection: TTMSFNCHeaderControlSection;
  ASortIndicator: TTMSFNCHeaderControlSortIndicator);
begin
  if Assigned(ASection) then
    FToast.ShowInfo('Sort', 'Sorted on ' + ASection.Text + '; an application sorts its list here.');
end;

procedure TForm1.HeaderResized(Sender: TObject; ASection: TTMSFNCHeaderControlSection);
begin
  FProjects.Columns[ASection.Index].Width := ASection.Width;
end;

procedure TForm1.GroupToggled(Sender: TObject);
var
  I: Integer;
begin
  { an accordion: the group that opened closes the others }
  for I := 0 to High(FAccordion) do
    if FAccordion[I] <> Sender then
      FAccordion[I].Collapsed := True;
end;

procedure TForm1.StepChanged(Sender: TObject);
begin
  ShowStep;
end;

procedure TForm1.BackClick(Sender: TObject);
begin
  if FStepper.ActiveStep > 0 then
    FStepper.ActiveStep := FStepper.ActiveStep - 1;
end;

procedure TForm1.NextClick(Sender: TObject);
begin
  if FStepper.ActiveStep < High(StepTexts) then
    FStepper.ActiveStep := FStepper.ActiveStep + 1
  else
  begin
    FToast.ShowSuccess('Welcome aboard', 'The onboarding is complete.');
    ShowPage(0);
  end;
end;

procedure TForm1.RailOptionChanged(Sender: TObject);
begin
  FSplit.BeginUpdate;
  if FCompactCheck.Checked then
    FSplit.CloseStyle := svcsCompact
  else
    FSplit.CloseStyle := svcsCollapse;
  if FOverlayCheck.Checked then
    FSplit.DisplayMode := svdmOverlay
  else
    FSplit.DisplayMode := svdmDocked;
  FSplit.EndUpdate;
end;

end.
