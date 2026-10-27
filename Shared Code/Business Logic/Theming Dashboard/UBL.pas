unit UBL;

{ TMS FNC UI Pack - Theming Dashboard demo: builds the whole dashboard in code from FNC components.

  One source for VCL, FMX and WEB (TMS WEB Core; the VCL / FMX / WEBLIB define of the project): the
  FNC API is the same in the frameworks.

  How the theming works in this demo:
  * the form has a TTMSFNCThemeManager (Scope tsApplication, Theme 'Fluent Light'): every FNC
    control of the application follows the theme by itself, also the ones created in code here;
  * the theme switcher in the header is a TTMSFNCThemeSelector: a segment per theme and the
    'Follow system' switch (TTMSFNCTheme.SetFollowSystem with the light and the dark theme of the
    current family); the accent swatches are a TTMSFNCAccentSelector (TTMSFNCTheme.SetAccent, the
    first swatch is the theme's own accent); both find the theme manager on the form;
  * every part of the page is a component that draws itself in the theme: cards and their headers
    (TTMSFNCPanel), the navigation (TTMSFNCListBox as a navigation list: pills, icons, a counter),
    KPI and status pills, the avatar (TTMSFNCBadge with a status kind), the filter chips
    (TTMSFNCSegmentedControl), status and progress columns (TTMSFNCDataGrid), status columns
    (TTMSFNCTreeView), progress bars, inputs, buttons and the status bar;
  * the demo only chooses what is content: secondary text, the app mark and the icons. It takes
    those colors from the tokens of the current theme (TTMSFNCTheme.Resolve(TTMSFNCTheme.Current))
    in ThemeChanged, which runs again after every theme or accent change.

  Layout: positions follow the FNC design of the dashboard (1440 x 1277, in pixels at 96 DPI); a
  smaller window moves the projects card under the orders card. }

interface

uses
  {$IFDEF WEBLIB}
  SysUtils, Classes, Types, Math, Generics.Collections, DateUtils, StrUtils,
  WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.ExtCtrls,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes, WEBLib.TMSFNCTheme,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCBadge,
  WEBLib.TMSFNCSegmentedControl, WEBLib.TMSFNCThemeSelector, WEBLib.TMSFNCSwatchSelector, WEBLib.TMSFNCAccentSelector,
  WEBLib.TMSFNCListBox, WEBLib.TMSFNCDataGrid, WEBLib.TMSFNCDataGridCell,
  WEBLib.TMSFNCDataGridRenderer, WEBLib.TMSFNCDataGridCore, WEBLib.TMSFNCProgressBar, WEBLib.TMSFNCEdit,
  WEBLib.TMSFNCComboBox, WEBLib.TMSFNCDatePicker, WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton,
  WEBLib.TMSFNCTrackBar, WEBLib.TMSFNCTreeView, WEBLib.TMSFNCTreeViewData, WEBLib.TMSFNCCustomTreeView,
  WEBLib.TMSFNCCheckedTreeView, WEBLib.TMSFNCStatusBar, WEBLib.TMSFNCButton;
  {$ELSE}
  System.SysUtils, System.Classes, System.Types, System.UITypes, System.Math,
  System.Generics.Collections, System.Rtti, System.DateUtils, System.StrUtils,
  {$IFDEF FMX}
  Winapi.Windows, FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCTheme,
  FMX.TMSFNCCustomControl, FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCBadge,
  FMX.TMSFNCSegmentedControl, FMX.TMSFNCThemeSelector, FMX.TMSFNCSwatchSelector, FMX.TMSFNCAccentSelector,
  FMX.TMSFNCListBox, FMX.TMSFNCDataGrid, FMX.TMSFNCDataGridCell,
  FMX.TMSFNCDataGridRenderer, FMX.TMSFNCDataGridCore, FMX.TMSFNCProgressBar, FMX.TMSFNCEdit,
  FMX.TMSFNCComboBox, FMX.TMSFNCDatePicker, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCTrackBar, FMX.TMSFNCTreeView, FMX.TMSFNCTreeViewData, FMX.TMSFNCCustomTreeView,
  FMX.TMSFNCCheckedTreeView, FMX.TMSFNCStatusBar, FMX.TMSFNCButton;
  {$ELSE}
  Winapi.Windows, Winapi.Messages, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.ExtCtrls,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCTheme,
  VCL.TMSFNCCustomControl, VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCBadge,
  VCL.TMSFNCSegmentedControl, VCL.TMSFNCThemeSelector, VCL.TMSFNCSwatchSelector, VCL.TMSFNCAccentSelector,
  VCL.TMSFNCListBox, VCL.TMSFNCDataGrid, VCL.TMSFNCDataGridCell,
  VCL.TMSFNCDataGridRenderer, VCL.TMSFNCDataGridCore, VCL.TMSFNCProgressBar, VCL.TMSFNCEdit,
  VCL.TMSFNCComboBox, VCL.TMSFNCDatePicker, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCTrackBar, VCL.TMSFNCTreeView, VCL.TMSFNCTreeViewData, VCL.TMSFNCCustomTreeView,
  VCL.TMSFNCCheckedTreeView, VCL.TMSFNCStatusBar, VCL.TMSFNCButton;
  {$ENDIF}
  {$ENDIF}

type
  {$IFDEF FMX}
  TDashParent = TFmxObject;
  {$ENDIF}
  {$IFDEF WEBLIB}
  TDashParent = TControl;
  {$ENDIF}
  {$IFNDEF FMX}{$IFNDEF WEBLIB}
  TDashParent = TWinControl;
  {$ENDIF}{$ENDIF}

  TOrder = record
    Id, Customer, Date, Total, Status: string;
    Pct: Integer;
  end;

  TProject = record
    Name, Owner, Status: string;
    Level: Integer;
    Done: Boolean;
  end;

  { The dashboard: creates its controls on the form it is given and lays them out. The controls are
    protected, so a descendant can reach them. }
  TDashboard = class(TComponent)
  protected
    FForm: TForm;
    FTimer: TTimer;
    FSeenVersion: Integer;
    FUpdating: Boolean;
    FSecondary: TList<TTMSFNCHTMLText>;
    FOrders: TArray<TOrder>;
    FVisibleOrders: TList<Integer>;
    FFilter: Integer;
    FNavIndex: Integer;
    FFamily: string;
    FCompact: Boolean;
    FShortNames: Boolean;
    { the card being laid out: where its body starts inside its bounds (the room of its shadow) }
    FOX, FOY: Single;
    { header }
    FHeader: TTMSFNCPanel;
    FMark: TTMSFNCBadge;
    FAppTitle: TTMSFNCHTMLText;
    FThemeSelector: TTMSFNCThemeSelector;
    FAccent: TTMSFNCAccentSelector;
    FAvatar: TTMSFNCBadge;
    { navigation }
    FNavPanel: TTMSFNCPanel;
    FNav: TTMSFNCListBox;
    FNavBottom: TTMSFNCListBox;
    { page header }
    FPageTitle: TTMSFNCHTMLText;
    FPageSub: TTMSFNCHTMLText;
    FExport: TTMSFNCButton;
    FNewOrder: TTMSFNCButton;
    { KPI cards }
    FKpiCards: array[0..3] of TTMSFNCPanel;
    FKpiLabels: array[0..3] of TTMSFNCHTMLText;
    FKpiValues: array[0..3] of TTMSFNCHTMLText;
    FKpiDeltas: array[0..3] of TTMSFNCBadge;
    FKpiNotes: array[0..3] of TTMSFNCHTMLText;
    { recent orders: a card whose header holds the title, the filter chips and the search box, and
      whose footer holds the count and the 'View all' link }
    FOrdersCard: TTMSFNCPanel;
    FChips: TTMSFNCSegmentedControl;
    FSearch: TTMSFNCEditButton;
    FGrid: TTMSFNCDataGrid;
    FViewAll: TTMSFNCHTMLText;
    { projects }
    FProjectsCard: TTMSFNCPanel;
    FProjectsNote: TTMSFNCHTMLText;
    FTree: TTMSFNCCheckedTreeView;
    { quarterly goals }
    FGoalsCard: TTMSFNCPanel;
    FGoalLabels: array[0..2] of TTMSFNCHTMLText;
    FGoalPcts: array[0..2] of TTMSFNCHTMLText;
    FGoalBars: array[0..2] of TTMSFNCProgressBar;
    { report preferences }
    FPrefsCard: TTMSFNCPanel;
    FNameLabel: TTMSFNCHTMLText;
    FNameEdit: TTMSFNCEdit;
    FRegionLabel: TTMSFNCHTMLText;
    FRegion: TTMSFNCComboBox;
    FDateLabel: TTMSFNCHTMLText;
    FDate: TTMSFNCDatePicker;
    FCheckEmail: TTMSFNCCheckBox;
    FCheckArchived: TTMSFNCCheckBox;
    FRadioDaily: TTMSFNCRadioButton;
    FRadioWeekly: TTMSFNCRadioButton;
    FDetailLabel: TTMSFNCHTMLText;
    FDetailPct: TTMSFNCHTMLText;
    FDetail: TTMSFNCTrackBar;
    FCancel: TTMSFNCButton;
    FSave: TTMSFNCButton;
    { status bar }
    FStatus: TTMSFNCStatusBar;
    {$IFDEF WEBLIB}
    { WEB: an image loads asynchronously; the navigation icons in the color they were loaded in }
    FNavIconColor: array[0..5] of TTMSFNCGraphicsColor;
    FNavIconLoaded: array[0..5] of Boolean;
    {$ENDIF}

    function Theme: TTMSFNCResolvedTheme;
    function Scale: Single;
    function S(AValue: Single): Single;
    procedure Place(AControl: TControl; X, Y, W, H: Single);
    procedure PlaceCard(ACard: TTMSFNCPanel; X, Y, W, H: Single);
    procedure PlaceIn(AControl: TControl; X, Y, W, H: Single);
    procedure SetFont(AFont: TTMSFNCGraphicsFont; APx: Single; ASemibold: Boolean);
    function NewCard(AParent: TDashParent; AShadow: Boolean = False; const ATitle: string = ''): TTMSFNCPanel;
    function NewText(AParent: TDashParent; const AText: string; APx: Single; ASemibold: Boolean = False;
      ASecondary: Boolean = False; AAlign: TTMSFNCGraphicsTextAlign = gtaLeading): TTMSFNCHTMLText;
    function NewActionButton(AParent: TDashParent; const AText: string; APrimary: Boolean): TTMSFNCButton;
    function NewPill(AParent: TDashParent; const AText: string; AKind: TTMSFNCStatusKind): TTMSFNCBadge;
    function TextWidth(const AText: string; APx: Single; ASemibold: Boolean): Single;
    function SegmentTheme(AIndex: Integer): string;
    function ActiveSegment: Integer;
    procedure SetThemeCaptions(AShort: Boolean);

    procedure BuildHeader;
    procedure BuildNavigation;
    procedure BuildPage;
    procedure BuildOrders;
    procedure BuildProjects;
    procedure BuildGoals;
    procedure BuildPreferences;
    procedure BuildStatusBar;
    procedure FillGrid;
    procedure UpdateStatusText;
    procedure UpdateNavIcons;

    procedure LayoutHeader(W: Single);
    procedure LayoutKpi(AIndex: Integer; W: Single);
    procedure LayoutOrders(W, H: Single);
    procedure LayoutProjects(W, H: Single);
    procedure LayoutGoals(W: Single);
    procedure LayoutPrefs(W, H: Single);

    procedure FormResize(Sender: TObject);
    procedure TimerTick(Sender: TObject);
    procedure ThemeApplied(Sender: TObject; const AThemeName: string);
    procedure FollowSystemChanged(Sender: TObject);
    procedure AccentApplied(Sender: TObject; AItemIndex: Integer; AColor: TTMSFNCGraphicsColor);
    procedure ChipSelected(Sender: TObject; AItemIndex: Integer);
    procedure SearchChange(Sender: TObject);
    procedure NavSelected(Sender: TObject; AItem: TTMSFNCListBoxItem);
    procedure RegionSelected(Sender: TObject; AText: string; AItemIndex: Integer);
    procedure DetailChanged(Sender: TObject; AValue: Single);
    procedure GridGetCellLayout(Sender: TObject; ACell: TTMSFNCDataGridCell);
    procedure TreeGetNodeTextColor(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer;
      var ATextColor: TTMSFNCGraphicsColor);
  public
    constructor Create(AForm: TForm); reintroduce;
    destructor Destroy; override;
    procedure Layout;
    { Shrinks the window to the work area of a smaller screen; the layout adapts. }
    procedure FitToScreen;
    { Applies a theme the way the switcher does (follow system off) and refreshes the UI. }
    procedure ApplyTheme(const AName: string);
    { Re-colors the demo's own content (secondary text, mark, icons) from the current theme's tokens. }
    procedure ThemeChanged;
  end;

implementation

const
  Dot = ' ' + #$00B7 + ' ';

  { one segment per theme (theme=caption); each always applies exactly that theme }
  SegmentNames: array[0..4] of string = ('Fluent Light', 'Fluent Dark', 'Microsoft 365 Light', 'Microsoft 365 Dark',
    'High Contrast=High contrast');
  { the captions used when the full names do not fit next to the app title (a narrow window) }
  SegmentShortNames: array[0..4] of string = ('Fluent Light', 'Fluent Dark', 'Microsoft 365 Light=M365 Light',
    'Microsoft 365 Dark=M365 Dark', 'High Contrast=High contrast');
  ChipNames: array[0..3] of string = ('All', 'Open', 'Shipped', 'Late');
  NavNames: array[0..4] of string = ('Overview', 'Orders', 'Customers', 'Planning', 'Reports');
  NavIcons: array[0..5] of string = (
    '<path d="M3 9.5 9 4l6 5.5V15H3z"/>',
    '<rect x="3" y="3.5" width="12" height="11" rx="1.5"/><path d="M3 7.5h12"/>',
    '<circle cx="9" cy="6.5" r="3"/><path d="M3.5 15c.8-2.8 3-4 5.5-4s4.7 1.2 5.5 4"/>',
    '<rect x="3" y="4" width="12" height="11" rx="1.5"/><path d="M3 8h12M6.5 2.5v3M11.5 2.5v3"/>',
    '<path d="M4 14.5V9M9 14.5V4M14 14.5v-7"/>',
    '<circle cx="9" cy="9" r="2.5"/><path d="M9 2.5v2M9 13.5v2M2.5 9h2M13.5 9h2M4.4 4.4l1.4 1.4M12.2 12.2l1.4 1.4M4.4 13.6l1.4-1.4M12.2 5.8l1.4-1.4"/>');
  SearchIcon = '<circle cx="7" cy="7" r="4.5"/><path d="m10.5 10.5 3 3"/>';
  { the app mark: four tiles, 16 px in the middle of the 24 px the badge gives its image }
  MarkIcon = '<g transform="translate(4 4)"><rect x="2.5" y="2.5" width="4.5" height="4.5" rx="1"/>' +
    '<rect x="9" y="2.5" width="4.5" height="4.5" rx="1"/><rect x="2.5" y="9" width="4.5" height="4.5" rx="1"/>' +
    '<rect x="9" y="9" width="4.5" height="4.5" rx="1"/></g>';

  KpiLabels: array[0..3] of string = ('Revenue', 'Open orders', 'New customers', 'Satisfaction');
  KpiValues: array[0..3] of string = ('$128.4K', '86', '1,204', '4.6 / 5');
  KpiDeltas: array[0..3] of string = ('+12.4%', '14 late', '+8.1%', #$2212'0.1');
  KpiKinds: array[0..3] of TTMSFNCStatusKind = (tskSuccess, tskWarning, tskSuccess, tskError);

  GoalNames: array[0..2] of string = ('Revenue target', 'On-time delivery', 'Customer retention');
  GoalValues: array[0..2] of Integer = (72, 45, 91);

  Regions: array[0..3] of string = ('Europe', 'Americas', 'Asia Pacific', 'Middle East');

  Projects: array[0..5] of TProject = (
    (Name: 'Website relaunch'; Owner: 'Lena'; Status: 'On track'; Level: 0; Done: False),
    (Name: 'Design system'; Owner: 'Marcus'; Status: 'Done'; Level: 1; Done: True),
    (Name: 'Landing pages'; Owner: 'Priya'; Status: 'In progress'; Level: 1; Done: False),
    (Name: 'Mobile app 2.0'; Owner: 'Sofia'; Status: 'At risk'; Level: 0; Done: False),
    (Name: 'Offline mode'; Owner: 'Jonas'; Status: 'In progress'; Level: 1; Done: False),
    (Name: 'Dark mode'; Owner: 'Diego'; Status: 'Done'; Level: 1; Done: True));

  { geometry (px at 96 DPI), from the design's CSS }
  HeaderH = 56;          // header, 1 px divider at its bottom
  StatusH = 32;          // footer, 1 px divider at its top
  PadX = 28;             // main: padding 24 28 32
  PadTop = 24;
  PadBottom = 32;
  Gap = 16;
  SectionGap = 20;
  KpiH = 122;
  OrdersH = 420;
  GoalsH = 202;
  PrefsH = 410;
  ProjectsH = 271;
  OrderRows = 7;
  NavRowH = 36;
  NavGap = 2;
  BarOverhang = 8;
  OrderRowH = 40;
  OrderHeaderH = 37;     // 36 + the divider at its bottom (the one above it is the card header's)
  OrdersTop = 62;        // the card header: padding 14, the 32 px search box, padding 14, its divider
  ProjectsTop = 54;      // the card header: padding 14, the 24 px title, padding 14, its divider
  CardTitleH = 57;       // a card header without divider: padding 16, the 24 px title, gap 14
  OrdersFooterH = 41;    // padding 10, 20 px, padding 10 (and the bottom border)
  { the page height the design is laid out for: below it the projects card moves under the orders }
  DesignH = HeaderH + PadTop + 52 + SectionGap + KpiH + SectionGap + GoalsH + Gap + PrefsH + SectionGap +
    ProjectsH + PadBottom + StatusH;

type
  TFNCControlAccess = class(TTMSFNCCustomControl);

{ ---------------------------------------------------------------- colors }

procedure ColorRGB(AColor: TTMSFNCGraphicsColor; out R, G, B: Byte);
{$IFDEF FMX}
begin
  R := (AColor shr 16) and $FF;
  G := (AColor shr 8) and $FF;
  B := AColor and $FF;
end;
{$ELSE}
var
  c: Longint;
begin
  c := {$IFDEF WEBLIB}AColor{$ELSE}ColorToRGB(AColor){$ENDIF};
  R := c and $FF;
  G := (c shr 8) and $FF;
  B := (c shr 16) and $FF;
end;
{$ENDIF}

function ColorHex(AColor: TTMSFNCGraphicsColor): string;
var
  r, g, b: Byte;
begin
  ColorRGB(AColor, r, g, b);
  Result := '#' + IntToHex(r, 2) + IntToHex(g, 2) + IntToHex(b, 2);
end;

{$IFDEF WEBLIB}
{ WEB: an SVG image (ASCII) as a data URL: a bitmap loads it from there }
function SvgDataURL(const ASvg: string): string;
begin
  Result := '';
  asm
    Result = 'data:image/svg+xml;base64,' + window.btoa(ASvg);
  end;
end;

{ WEB: the CSS family of the semibold face (Windows names it as a family of its own, browsers
  resolve it); the stack ends with the platform's own font }
function WebSemiboldFamily(const AFamily: string): string;
begin
  if Pos('Segoe UI Variable Text', AFamily) > 0 then
    Result := '''Segoe UI Variable Text Semibold'', ''Segoe UI Semibold'', system-ui, sans-serif'
  else if Pos('Segoe UI', AFamily) > 0 then
    Result := '''Segoe UI Semibold'', system-ui, sans-serif'
  else
    Result := AFamily;
end;
{$ENDIF}

function Svg(const ABody: string; AColor: TTMSFNCGraphicsColor; ASize: Integer = 18): string;
begin
  Result := Format('<svg xmlns="http://www.w3.org/2000/svg" width="%d" height="%d" viewBox="0 0 %d %d" fill="none" ' +
    'stroke="%s" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">%s</svg>',
    [ASize, ASize, ASize, ASize, ColorHex(AColor), ABody]);
end;

{ a navigation icon (18 px) 5 px into an image of 25 x 18 px }
function NavSvg(AIndex: Integer; AColor: TTMSFNCGraphicsColor): string;
begin
  Result := Format('<svg xmlns="http://www.w3.org/2000/svg" width="25" height="18" viewBox="0 0 25 18" fill="none" ' +
    'stroke="%s" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><g transform="translate(5 0)">%s</g></svg>',
    [ColorHex(AColor), NavIcons[AIndex]]);
end;

function MakeOrders: TArray<TOrder>;
const
  Seed: array[0..6] of TOrder = (
    (Id: '#10240'; Customer: 'Northwind Traders'; Date: 'Oct 01'; Total: '$180.00'; Status: 'Open'; Pct: 10),
    (Id: '#10241'; Customer: 'Proseware'; Date: 'Oct 02'; Total: '$3,899.00'; Status: 'Late'; Pct: 47),
    (Id: '#10242'; Customer: 'Fabrikam Inc.'; Date: 'Oct 03'; Total: '$3,418.00'; Status: 'Shipped'; Pct: 100),
    (Id: '#10243'; Customer: 'Alpine Ski House'; Date: 'Oct 04'; Total: '$2,937.00'; Status: 'Packing'; Pct: 72),
    (Id: '#10244'; Customer: 'Tailspin Toys'; Date: 'Oct 05'; Total: '$2,456.00'; Status: 'Open'; Pct: 31),
    (Id: '#10245'; Customer: 'Humongous Insurance'; Date: 'Oct 06'; Total: '$1,975.00'; Status: 'Late'; Pct: 15),
    (Id: '#10246'; Customer: 'Litware Group'; Date: 'Oct 07'; Total: '$1,494.00'; Status: 'Shipped'; Pct: 100));
  Names: array[0..9] of string = ('Contoso Ltd.', 'Adventure Works', 'Wingtip Boats', 'Coho Winery',
    'Lucerne Publishing', 'Woodgrove Bank', 'Trey Research', 'Wide World Importers', 'Fourth Coffee',
    'Blue Yonder Airlines');
  States: array[0..3] of string = ('Open', 'Shipped', 'Packing', 'Late');
var
  I, cents: Integer;
  fs: TFormatSettings;
begin
  fs := TFormatSettings.Create('en-US');
  SetLength(Result, 30);
  for I := 0 to High(Seed) do
    Result[I] := Seed[I];
  for I := Length(Seed) to 29 do
  begin
    Result[I].Id := '#' + IntToStr(10240 + I);
    Result[I].Customer := Names[(I * 7) mod Length(Names)];
    Result[I].Date := Format('Oct %.2d', [1 + I mod 28]);
    cents := 12000 + ((I * 7919) mod 480000);
    Result[I].Total := '$' + FormatFloat('#,##0.00', cents / 100, fs);
    Result[I].Status := States[(I * 3) mod 4];
    if Result[I].Status = 'Shipped' then
      Result[I].Pct := 100
    else
      Result[I].Pct := 5 + (I * 37) mod 90;
  end;
end;

{ ---------------------------------------------------------------- construction }

constructor TDashboard.Create(AForm: TForm);
var
  c: TComponent;
  I: Integer;
  t: TTMSFNCResolvedTheme;
begin
  inherited Create(AForm);
  FForm := AForm;
  FormatSettings := TFormatSettings.Create('en-US');
  FormatSettings.ShortDateFormat := 'mmm d, yyyy';
  FSecondary := TList<TTMSFNCHTMLText>.Create;
  FVisibleOrders := TList<Integer>.Create;
  FOrders := MakeOrders;
  FFilter := 0;
  FNavIndex := 0;
  { the type face of the Fluent themes (Segoe UI Variable on Windows 11, else Segoe UI) }
  t := TTMSFNCTheme.Resolve('Fluent Light');
  if Assigned(t) and (t.FontFamily <> '') then
    FFamily := t.FontFamily
  else
    FFamily := {$IFDEF WEBLIB}'''Segoe UI Variable Text'', ''Segoe UI'', system-ui, sans-serif'{$ELSE}'Segoe UI'{$ENDIF};
  FUpdating := True;
  try
    BuildHeader;
    BuildNavigation;
    BuildPage;
    BuildOrders;
    BuildProjects;
    BuildGoals;
    BuildPreferences;
    BuildStatusBar;
    FillGrid;
  finally
    FUpdating := False;
  end;
  { the bars overlap the window edges and each other; the header lies on top }
  FHeader.BringToFront;
  FStatus.BringToFront;
  FForm.OnResize := FormResize;
  Layout;
  { let the engine theme every new control now, so ThemeChanged has the last word }
  for I := 0 to FForm.ComponentCount - 1 do
  begin
    c := FForm.Components[I];
    if c is TTMSFNCCustomControl then
      TTMSFNCTheme.ApplyTo(c);
  end;
  ThemeChanged;
  { a theme change that does not come from this UI (the OS switched to dark while following it) }
  FTimer := TTimer.Create(Self);
  FTimer.Interval := 250;
  FTimer.OnTimer := TimerTick;
  FTimer.Enabled := True;
end;

destructor TDashboard.Destroy;
begin
  FSecondary.Free;
  FVisibleOrders.Free;
  inherited;
end;

function TDashboard.Theme: TTMSFNCResolvedTheme;
begin
  Result := nil;
  if TTMSFNCTheme.Current <> '' then
    Result := TTMSFNCTheme.Resolve(TTMSFNCTheme.Current);
end;

{ The layout is written in pixels at 96 DPI. FMX works in device independent pixels anyway; a VCL
  form on a high DPI monitor (per monitor DPI aware, see the project's manifest) works in physical
  pixels, so positions and sizes set in code are multiplied by the form's ScaleFactor (its DPI / 96,
  updated when the window moves to a monitor with another DPI). Sizes that come from the theme (row
  heights, control heights, radii, fonts) are scaled by the controls themselves. }
function TDashboard.Scale: Single;
begin
  {$IFDEF FMX}
  Result := 1;
  {$ENDIF}
  {$IFDEF WEBLIB}
  { the browser scales the page (CSS pixels) }
  Result := 1;
  {$ENDIF}
  {$IFNDEF FMX}{$IFNDEF WEBLIB}
  Result := FForm.ScaleFactor;
  {$ENDIF}{$ENDIF}
end;

function TDashboard.S(AValue: Single): Single;
begin
  Result := AValue * Scale;
end;

{ Edges are rounded to whole pixels as a browser snaps its boxes, also on FMX (a box at a fraction
  of a pixel would be drawn blurred). }
procedure TDashboard.Place(AControl: TControl; X, Y, W, H: Single);
var
  l, t: Integer;
begin
  l := Round(S(X));
  t := Round(S(Y));
  {$IFDEF WEBLIB}
  { WEB paints a control again on every change of its bounds: skip what does not change }
  if (AControl.Left = l) and (AControl.Top = t) and (AControl.Width = Round(S(X + W)) - l) and
    (AControl.Height = Round(S(Y + H)) - t) then
    Exit;
  {$ENDIF}
  AControl.SetBounds(l, t, Round(S(X + W)) - l, Round(S(Y + H)) - t);
end;

{ A font of APx pixels at 96 DPI in the dashboard's type face. FMX fonts are sized in device
  independent pixels and take the semibold weight; VCL fonts get the height in pixels at the form's
  scale and the semibold face (a family of its own in GDI). }
procedure TDashboard.SetFont(AFont: TTMSFNCGraphicsFont; APx: Single; ASemibold: Boolean);
begin
  {$IFDEF FMX}
  AFont.Name := FFamily;
  AFont.Size := APx;
  if ASemibold then
    AFont.StyleExt := TFontStyleExt.Create(TFontWeight.Semibold, TFontSlant.Regular, TFontStretch.Regular)
  else
    AFont.StyleExt := TFontStyleExt.Default;
  {$ENDIF}
  {$IFDEF WEBLIB}
  { WEB: the canvas font. Semibold is the family of the semibold face, as on VCL (the browser
    resolves those names, e.g. 'Segoe UI Semibold'). A WEB font holds its size in whole points:
    the exact size in pixels (13 px = 9.75 pt) is kept in the font's size field. }
  if ASemibold then
    AFont.Name := WebSemiboldFamily(FFamily)
  else
    AFont.Name := FFamily;
  AFont.Style := [];
  AFont.Height := -Round(APx);
  asm
    if (AFont.FSize !== APx * 0.75) { AFont.FSize = APx * 0.75; AFont.DoChange(); }
  end;
  {$ENDIF}
  {$IFNDEF FMX}{$IFNDEF WEBLIB}
  if ASemibold and (TTMSFNCTheme.SemiboldFamily(FFamily) <> '') then
    AFont.Name := TTMSFNCTheme.SemiboldFamily(FFamily)
  else
    AFont.Name := FFamily;
  AFont.Style := [];
  AFont.Height := -Round(APx * Scale);
  {$ENDIF}{$ENDIF}
end;

{ A card whose body (border box) is X, Y, W, H: the panel is larger by the room of its shadow;
  PlaceIn then positions its content relative to the body. }
procedure TDashboard.PlaceCard(ACard: TTMSFNCPanel; X, Y, W, H: Single);
var
  m: TRectF;
begin
  m := ACard.ShadowMargins;
  m := RectF(m.Left / Scale, m.Top / Scale, m.Right / Scale, m.Bottom / Scale);
  Place(ACard, X - m.Left, Y - m.Top, W + m.Left + m.Right, H + m.Top + m.Bottom);
  FOX := m.Left;
  FOY := m.Top;
end;

procedure TDashboard.PlaceIn(AControl: TControl; X, Y, W, H: Single);
begin
  Place(AControl, X + FOX, Y + FOY, W, H);
end;

{ A card: a panel (themed: the Fluent card look); AShadow: it casts the theme's soft shadow. Bars
  are panels too, without shadow. ATitle: the card header shows it (semibold, on the card). }
function TDashboard.NewCard(AParent: TDashParent; AShadow: Boolean; const ATitle: string): TTMSFNCPanel;
begin
  Result := TTMSFNCPanel.Create(FForm);
  Result.Parent := AParent;
  Result.Shadow := AShadow;
  Result.Header.Visible := ATitle <> '';
  Result.Header.Text := ATitle;
  Result.Header.HorizontalTextAlign := gtaLeading;
  SetFont(Result.Header.Font, 16, True);
  Result.Header.ShowDivider := False;
  Result.Footer.Visible := False;
end;

function TDashboard.NewText(AParent: TDashParent; const AText: string; APx: Single; ASemibold: Boolean;
  ASecondary: Boolean; AAlign: TTMSFNCGraphicsTextAlign): TTMSFNCHTMLText;
begin
  Result := TTMSFNCHTMLText.Create(FForm);
  Result.Parent := AParent;
  { a label: transparent, no border }
  Result.Fill.Kind := gfkNone;
  Result.Stroke.Kind := gskNone;
  Result.WordWrapping := False;
  Result.Trimming := gttCharacter;
  Result.HorizontalTextAlign := AAlign;
  Result.VerticalTextAlign := gtaCenter;
  SetFont(Result.Font, APx, ASemibold);
  Result.Text := AText;
  if ASecondary then
    FSecondary.Add(Result);
end;

{ A dialog style button. Under a theme, Default = True makes it the primary button (accent fill,
  text on accent); the others get the secondary look (surface with a border). }
function TDashboard.NewActionButton(AParent: TDashParent; const AText: string; APrimary: Boolean): TTMSFNCButton;
begin
  Result := TTMSFNCButton.Create(FForm);
  Result.Parent := AParent;
  Result.Text := AText;
  Result.Default := APrimary;
end;

{ A status pill: a badge with a status kind takes the theme's status colors (a tinted background
  with the status color as text; High Contrast: outlined in the text color) }
function TDashboard.NewPill(AParent: TDashParent; const AText: string; AKind: TTMSFNCStatusKind): TTMSFNCBadge;
begin
  Result := TTMSFNCBadge.Create(FForm);
  Result.Parent := AParent;
  Result.Text := AText;
  Result.Kind := AKind;
  Result.Shape := bshPill;
  SetFont(Result.Appearance.Font, 12, True);
end;

function TDashboard.TextWidth(const AText: string; APx: Single; ASemibold: Boolean): Single;
var
  g: TTMSFNCGraphics;
  sc: Single;
begin
  g := TTMSFNCGraphics.CreateBitmapCanvas(10, 10);
  try
    g.BeginScene;
    try
      { measured at 96 DPI }
      sc := 1;
      {$IFNDEF FMX}
      sc := Scale;
      {$ENDIF}
      SetFont(g.Font, APx, ASemibold);
      Result := g.CalculateTextWidth(AText) / sc;
    finally
      g.EndScene;
    end;
  finally
    g.Free;
  end;
end;

{ the theme a segment applies: always the same one, whatever theme is current }
function TDashboard.SegmentTheme(AIndex: Integer): string;
begin
  Result := FThemeSelector.ThemeOfItem(AIndex);
end;

function TDashboard.ActiveSegment: Integer;
begin
  Result := FThemeSelector.ItemIndex;
end;

procedure TDashboard.SetThemeCaptions(AShort: Boolean);
var
  sl: TStringList;
  I: Integer;
begin
  sl := TStringList.Create;
  try
    for I := 0 to High(SegmentNames) do
      if AShort then
        sl.Add(SegmentShortNames[I])
      else
        sl.Add(SegmentNames[I]);
    if sl.Text <> FThemeSelector.Themes.Text then
      FThemeSelector.Themes := sl;
    FShortNames := AShort;
  finally
    sl.Free;
  end;
end;

procedure TDashboard.BuildHeader;
var
  I: Integer;
begin
  FHeader := NewCard(FForm);

  { the app mark: a rounded badge in the accent with the mark as its image }
  FMark := TTMSFNCBadge.Create(FForm);
  FMark.Parent := FHeader;
  FMark.Shape := bshRounded;
  FMark.Appearance.Rounding := Round(S(8));
  FMark.Text := '';
  FAppTitle := NewText(FHeader, 'Theming Dashboard', 15, True);

  { the theme switcher: a segment per theme and the 'Follow system' switch }
  FThemeSelector := TTMSFNCThemeSelector.Create(FForm);
  FThemeSelector.Parent := FHeader;
  FThemeSelector.ShowFollowSystem := True;
  FThemeSelector.AutoSize := True;
  SetFont(FThemeSelector.SegmentAppearance.Font, 13, False);
  SetFont(FThemeSelector.SegmentAppearance.SelectedFont, 13, True);
  SetFont(FThemeSelector.FollowSystemAppearance.Font, 13, False);
  SetThemeCaptions(False);
  FThemeSelector.OnAfterApplyTheme := ThemeApplied;
  FThemeSelector.OnFollowSystemChange := FollowSystemChanged;

  { the accent swatches; the first one is the theme's own accent (a blue in every built-in theme) }
  FAccent := TTMSFNCAccentSelector.Create(FForm);
  FAccent.Parent := FHeader;
  FAccent.OnAfterApplyAccent := AccentApplied;
  for I := 0 to FAccent.Colors.Count - 1 do
    if I = 0 then
      FAccent.Colors[I].Hint := 'Theme accent'
    else
      FAccent.Colors[I].Hint := FAccent.Colors[I].Text;

  { the user: an avatar in the accent's tint }
  FAvatar := NewPill(FHeader, 'PS', tskAccent);
  FAvatar.Shape := bshCircle;
end;

procedure TDashboard.BuildNavigation;
var
  I: Integer;
  it: TTMSFNCListBoxItem;

  procedure SetupList(AList: TTMSFNCListBox);
  begin
    AList.Parent := FNavPanel;
    AList.Stroke.Kind := gskNone;
    AList.Header.Visible := False;
    AList.VerticalScrollBarVisible := False;
    { a navigation list: the hovered and the selected item as a 36 px pill (radius 6) in a 38 px
      item, the icons in the item's text color, counters at the end }
    AList.ItemsAppearance.HeightMode := lihmFixed;
    AList.ItemsAppearance.FixedHeight := S(NavRowH + NavGap);
    AList.ItemsAppearance.SelectionRounding := 6;
    AList.ItemsAppearance.SelectionMargins.Top := NavGap / 2;
    AList.ItemsAppearance.SelectionMargins.Bottom := NavGap / 2;
    AList.ItemsAppearance.SelectionMargins.Left := 0;
    AList.ItemsAppearance.SelectionMargins.Right := 0;
    AList.ItemsAppearance.TintBitmaps := True;
    AList.ItemsAppearance.ShowFocus := False;
    SetFont(AList.ItemsAppearance.Font, 14, False);
    SetFont(AList.ItemsAppearance.SelectedFont, 14, True);
    SetFont(AList.ItemsAppearance.BadgeFont, 12, True);
    AList.OnItemSelected := NavSelected;
    {$IFDEF WEBLIB}
    { WEB: the list's own element is transparent (its items are painted by the inner tree view; the
      element's background would show at the anti-aliased edges) }
    TFNCControlAccess(TObject(AList)).Fill.Kind := gfkNone;
    {$ENDIF}
  end;

  procedure AddItem(AList: TTMSFNCListBox; const AText: string; ATag: Integer);
  begin
    it := AList.Items.Add;
    it.Text := AText;
    it.Tag := ATag;
    { the list keeps 2 px around an item's image and 6 px before the text: the icon in an image of
      25 x 18 px, 5 px in, puts it 10 px into the pill and the text at 38 }
    it.BitmapWidth := S(29);
    it.BitmapHeight := S(22);
    {$IFNDEF WEBLIB}
    it.Bitmap.LoadFromSVG(NavSvg(ATag, gcBlack));
    {$ENDIF}
  end;

begin
  FNavPanel := NewCard(FForm);

  FNav := TTMSFNCListBox.Create(FForm);
  SetupList(FNav);
  FNav.BeginUpdate;
  try
    FNav.Items.Clear;
    for I := 0 to High(NavNames) do
    begin
      AddItem(FNav, NavNames[I], I);
      { the open orders }
      if I = 1 then
        it.Badge := '14';
    end;
  finally
    FNav.EndUpdate;
  end;

  FNavBottom := TTMSFNCListBox.Create(FForm);
  SetupList(FNavBottom);
  FNavBottom.BeginUpdate;
  try
    FNavBottom.Items.Clear;
    AddItem(FNavBottom, 'Settings', 5);
  finally
    FNavBottom.EndUpdate;
  end;
  FNav.ItemIndex := 0;
  FNavBottom.ItemIndex := -1;
end;

procedure TDashboard.BuildPage;
var
  I: Integer;
begin
  FPageTitle := NewText(FForm, 'Overview', 24, True);
  FPageSub := NewText(FForm, 'Week 42' + Dot + 'all regions', 13, False, True);
  FExport := NewActionButton(FForm, 'Export', False);
  FNewOrder := NewActionButton(FForm, 'New order', True);

  for I := 0 to 3 do
  begin
    FKpiCards[I] := NewCard(FForm, True);
    FKpiLabels[I] := NewText(FKpiCards[I], KpiLabels[I], 13, False, True);
    FKpiValues[I] := NewText(FKpiCards[I], KpiValues[I], 28, True);
    FKpiDeltas[I] := NewPill(FKpiCards[I], KpiDeltas[I], KpiKinds[I]);
    FKpiNotes[I] := NewText(FKpiCards[I], 'vs last month', 12, False, True);
  end;
end;

procedure TDashboard.BuildOrders;
var
  I: Integer;
  col: TTMSFNCDataGridColumn;
const
  Headers: array[0..5] of string = ('Order', 'Customer', 'Date', 'Total', 'Status', 'Fulfilment');
begin
  FOrdersCard := NewCard(FForm, True, 'Recent orders');
  FOrdersCard.Header.ShowDivider := True;
  FOrdersCard.Header.ActionSpacing := 12;

  { the filter: chips (one selected) }
  FChips := TTMSFNCSegmentedControl.Create(FForm);
  FChips.Parent := FOrdersCard;
  FChips.Style := scsChips;
  FChips.AutoSize := True;
  SetFont(FChips.ChipAppearance.Font, 13, False);
  SetFont(FChips.ChipAppearance.SelectedFont, 13, True);
  FChips.Items.Clear;
  for I := 0 to High(ChipNames) do
    FChips.Items.AddItem(ChipNames[I]);
  FChips.ItemIndex := 0;
  FChips.OnAfterSelectItem := ChipSelected;
  FOrdersCard.Header.Actions.Add.Control := FChips;

  FSearch := TTMSFNCEditButton.Create(FForm);
  FSearch.Parent := FOrdersCard;
  { the search icon in front of the text: 10 px in, the text at 32 }
  FSearch.ButtonPosition := ebpLeft;
  FSearch.ButtonSize := 30;
  {$IFDEF FMX}
  FSearch.Edit.TextPrompt := 'Search orders';
  {$ELSE}
  FSearch.Edit.TextHint := 'Search orders';
  {$ENDIF}
  FSearch.Edit.OnChange := SearchChange;
  FOrdersCard.Header.Actions.Add.Control := FSearch;

  FGrid := TTMSFNCDataGrid.Create(FForm);
  FGrid.Parent := FOrdersCard;
  FGrid.Stroke.Kind := gskNone;
  {$IFNDEF FMX}{$IFNDEF WEBLIB}
  { the status pills and bars are drawn antialiased: the GDI+ canvas (with ClearType text) }
  TFNCControlAccess(FGrid).NativeCanvas := True;
  TFNCControlAccess(FGrid).TextQuality := gtqClearType;
  {$ENDIF}{$ENDIF}
  FGrid.BeginUpdate;
  try
    FGrid.ColumnCount := Length(Headers);
    FGrid.FixedRowCount := 1;
    FGrid.FixedColumnCount := 0;
    FGrid.RowCount := 1 + OrderRows;
    FGrid.Options.Selection.Mode := gsmSingleRow;
    for I := 0 to High(Headers) do
    begin
      col := FGrid.Columns[I];
      col.Header := Headers[I];
      FGrid.Cells[I, 0] := Headers[I];
    end;
    { the status: a pill with a dot in the colors of its status }
    col := FGrid.Columns[4];
    col.StatusValues.Add('Open=Info');
    col.StatusValues.Add('Packing=Warning');
    col.StatusValues.Add('Shipped=Success');
    col.StatusValues.Add('Late=Error');
    FGrid.AddDataStatusColumn(4);
    { the fulfilment: a progress bar with its value next to it }
    FGrid.ProgressAppearance.ShowValue := True;
  finally
    FGrid.EndUpdate;
  end;
  FGrid.OnGetCellLayout := GridGetCellLayout;

  { the footer: the count, and the link at its end }
  FOrdersCard.Footer.Visible := True;
  FOrdersCard.Footer.ShowDivider := False;
  FOrdersCard.Footer.HorizontalTextAlign := gtaLeading;
  SetFont(FOrdersCard.Footer.Font, 12, False);
  FViewAll := NewText(FOrdersCard, '<a href="all">View all</a>', 12, True, False, gtaTrailing);
  FViewAll.URLUnderline := False;
  FViewAll.AutoOpenURL := False;
  FOrdersCard.Footer.Actions.Add.Control := FViewAll;
end;

procedure TDashboard.BuildProjects;
var
  I: Integer;
  parent, node: TTMSFNCTreeViewNode;
  col: TTMSFNCTreeViewColumn;
begin
  FProjectsCard := NewCard(FForm, True, 'Projects');
  FProjectsCard.Header.ShowDivider := True;
  FProjectsNote := NewText(FProjectsCard, 'TreeView' + Dot + 'checkable', 12, False, True, gtaTrailing);
  FProjectsCard.Header.Actions.Add.Control := FProjectsNote;

  FTree := TTMSFNCCheckedTreeView.Create(FForm);
  FTree.Parent := FProjectsCard;
  FTree.Stroke.Kind := gskNone;
  FTree.Stroke.Color := gcNull;
  {$IFNDEF FMX}{$IFNDEF WEBLIB}
  TFNCControlAccess(FTree).NativeCanvas := True;
  TFNCControlAccess(FTree).TextQuality := gtqClearType;
  {$ENDIF}{$ENDIF}
  { six rows fill the card: no scroll bar }
  FTree.VerticalScrollBarVisible := False;
  FTree.HorizontalScrollBarVisible := False;
  FTree.OnGetNodeTextColor := TreeGetNodeTextColor;
  FTree.BeginUpdate;
  try
    FTree.ClearColumns;
    FTree.ClearNodes;
    { the projects (parent nodes) semibold }
    FTree.NodesAppearance.ParentNodesSemibold := True;
    SetFont(FTree.NodesAppearance.Font, 13, False);
    col := FTree.Columns.Add;
    col.Text := 'Project';
    { Owner and Status get their widths in LayoutProjects }
    col := FTree.Columns.Add;
    col.Text := 'Owner';
    col := FTree.Columns.Add;
    col.Text := 'Status';
    { the status: a pill in the colors of its status }
    col.StatusValues.Add('On track=Success');
    col.StatusValues.Add('Done=Info');
    col.StatusValues.Add('In progress=Warning');
    col.StatusValues.Add('At risk=Error');
    col.StatusShowDot := False;
    FTree.ColumnsAppearance.StretchAll := False;
    FTree.ColumnsAppearance.StretchColumn := 0;
    FTree.ColumnsAppearance.Stretch := True;
    { the card title names the list; no column header row }
    FTree.ColumnsAppearance.TopSize := 0;
    parent := nil;
    for I := 0 to High(Projects) do
    begin
      if Projects[I].Level = 0 then
      begin
        node := FTree.AddNode(nil);
        parent := node;
      end
      else
        node := FTree.AddNode(parent);
      node.Text[0] := Projects[I].Name;
      node.Text[1] := Projects[I].Owner;
      node.Text[2] := Projects[I].Status;
      node.DataInteger := I;
      node.CheckTypes[0] := tvntCheckBox;
      FTree.Checked[node] := Projects[I].Done;
    end;
    FTree.ExpandAll;
  finally
    FTree.EndUpdate;
  end;
end;

procedure TDashboard.BuildGoals;
var
  I: Integer;
begin
  FGoalsCard := NewCard(FForm, True, 'Quarterly goals');
  for I := 0 to 2 do
  begin
    FGoalLabels[I] := NewText(FGoalsCard, GoalNames[I], 13);
    FGoalPcts[I] := NewText(FGoalsCard, IntToStr(GoalValues[I]) + '%', 13, False, True, gtaTrailing);
    FGoalBars[I] := TTMSFNCProgressBar.Create(FForm);
    FGoalBars[I].Parent := FGoalsCard;
    FGoalBars[I].Minimum := 0;
    FGoalBars[I].Maximum := 100;
    FGoalBars[I].Value := GoalValues[I];
    FGoalBars[I].Layout.ShowValue := False;
  end;
end;

procedure TDashboard.BuildPreferences;
var
  I: Integer;
begin
  FPrefsCard := NewCard(FForm, True, 'Report preferences');

  FNameLabel := NewText(FPrefsCard, 'Report name', 13, True);
  FNameEdit := TTMSFNCEdit.Create(FForm);
  FNameEdit.Parent := FPrefsCard;
  FNameEdit.Text := 'Quarterly report';

  FRegionLabel := NewText(FPrefsCard, 'Region', 13, True);
  FRegion := TTMSFNCComboBox.Create(FForm);
  FRegion.Parent := FPrefsCard;
  FRegion.Style := csDropDownList;
  FRegion.Items.Clear;
  for I := 0 to High(Regions) do
    FRegion.Items.Add(Regions[I]);
  FRegion.ItemIndex := 0;
  FRegion.OnItemSelected := RegionSelected;

  FDateLabel := NewText(FPrefsCard, 'Start date', 13, True);
  FDate := TTMSFNCDatePicker.Create(FForm);
  FDate.Parent := FPrefsCard;
  FDate.SelectedDate := EncodeDate(2026, 11, 3);

  FCheckEmail := TTMSFNCCheckBox.Create(FForm);
  FCheckEmail.Parent := FPrefsCard;
  FCheckEmail.Text := 'Email notifications';
  FCheckEmail.Checked := True;
  FCheckArchived := TTMSFNCCheckBox.Create(FForm);
  FCheckArchived.Parent := FPrefsCard;
  FCheckArchived.Text := 'Include archived orders';

  FRadioDaily := TTMSFNCRadioButton.Create(FForm);
  FRadioDaily.Parent := FPrefsCard;
  FRadioDaily.Text := 'Daily';
  FRadioDaily.GroupName := 'Frequency';
  FRadioDaily.Checked := True;
  FRadioWeekly := TTMSFNCRadioButton.Create(FForm);
  FRadioWeekly.Parent := FPrefsCard;
  FRadioWeekly.Text := 'Weekly';
  FRadioWeekly.GroupName := 'Frequency';

  FDetailLabel := NewText(FPrefsCard, 'Detail level', 13, True);
  FDetailPct := NewText(FPrefsCard, '60%', 13, False, True, gtaTrailing);
  FDetail := TTMSFNCTrackBar.Create(FForm);
  FDetail.Parent := FPrefsCard;
  FDetail.Min := 0;
  FDetail.Max := 100;
  FDetail.Value := 60;
  FDetail.OnValueChanged := DetailChanged;

  FCancel := NewActionButton(FPrefsCard, 'Cancel', False);
  FSave := NewActionButton(FPrefsCard, 'Save', True);
end;

{ the panels: 20 px in, 'Theme: <name>' (HTML: the name semibold in the text color), '30 orders',
  a flexible gap, the versions at the end, 20 px from the edge; the panels draw their text 10 px in }
procedure TDashboard.BuildStatusBar;
var
  p: TTMSFNCStatusBarPanel;
begin
  FStatus := TTMSFNCStatusBar.Create(FForm);
  FStatus.Parent := FForm;
  {$IFDEF FMX}
  FStatus.Align := TAlignLayout.None;
  {$ELSE}
  FStatus.Align := alNone;
  {$ENDIF}
  FStatus.Panels.Clear;
  p := FStatus.Panels.Add;
  p.Style := spsText;
  p.Text := '';
  p.Width := 11;
  p := FStatus.Panels.Add;
  p.Style := spsHTML;
  p.Width := 240;
  p := FStatus.Panels.Add;
  p.Style := spsText;
  p.Text := IntToStr(Length(FOrders)) + ' orders';
  p.Width := 120;
  p := FStatus.Panels.Add;
  p.Style := spsText;
  p.Text := '';
  p.Width := 400;
  p := FStatus.Panels.Add;
  p.Style := spsText;
  p.Text := 'TMS FNC Core 5.0' + Dot + 'UI Pack 8.0';
  p.Alignment := taRightJustify;
  p.Width := 260;
  p := FStatus.Panels.Add;
  p.Style := spsText;
  p.Text := '';
  p.Width := 11;
  UpdateStatusText;
end;

{ the theme's name in the status bar, semibold in the text color after the secondary 'Theme: ' }
procedure TDashboard.UpdateStatusText;
var
  s, face: string;
  t: TTMSFNCResolvedTheme;
begin
  s := TTMSFNCTheme.Current;
  if s = '' then
    s := 'none';
  t := Theme;
  {$IFDEF WEBLIB}
  face := 'Segoe UI Semibold';
  {$ELSE}
  face := TTMSFNCTheme.SemiboldFamily(FFamily);
  {$ENDIF}
  if Assigned(t) and (face <> '') then
    s := Format('<font face="%s" color="%s">%s</font>', [face, ColorHex(t[ttText]), s])
  else if Assigned(t) then
    s := Format('<font color="%s"><b>%s</b></font>', [ColorHex(t[ttText]), s]);
  if FStatus.Panels.Count > 1 then
    FStatus.Panels.Items[1].Text := 'Theme: ' + s;
  if Assigned(FHeader) then
    Layout;
  FStatus.Invalidate;
end;

{ VCL / FMX: the list tints its SVG icons in the item's text color. WEB draws images as they are:
  each icon is loaded in the color of its item (the selected one in the color of the selected
  item's text) and loaded again when that color changes. }
procedure TDashboard.UpdateNavIcons;
{$IFDEF WEBLIB}

  procedure Update(AList: TTMSFNCListBox);
  var
    I: Integer;
    it: TTMSFNCListBoxItem;
    c: TTMSFNCGraphicsColor;
    l: TTMSFNCListBox;
  begin
    l := AList;
    for I := 0 to AList.Items.Count - 1 do
    begin
      it := AList.Items[I];
      if it.Tag = FNavIndex then
        c := AList.ItemsAppearance.SelectedFont.Color
      else
        c := it.TextColor;
      if FNavIconLoaded[it.Tag] and (FNavIconColor[it.Tag] = c) then
        Continue;
      FNavIconLoaded[it.Tag] := True;
      FNavIconColor[it.Tag] := c;
      it.Bitmap.LoadFromURL(SvgDataURL(NavSvg(it.Tag, c)),
        procedure
        begin
          l.TreeView.Invalidate;
        end);
    end;
  end;

begin
  Update(FNav);
  Update(FNavBottom);
end;
{$ELSE}
begin
  FNav.Invalidate;
  FNavBottom.Invalidate;
end;
{$ENDIF}

procedure TDashboard.FillGrid;
var
  I, row: Integer;
  q: string;
  o: TOrder;
  matches: Integer;
begin
  q := '';
  if Assigned(FSearch) then
    q := LowerCase(Trim(FSearch.Edit.Text));
  FVisibleOrders.Clear;
  matches := 0;
  for I := 0 to High(FOrders) do
  begin
    o := FOrders[I];
    if (FFilter > 0) and not SameText(o.Status, ChipNames[FFilter]) then
      Continue;
    if (q <> '') and (Pos(q, LowerCase(o.Customer + ' ' + o.Id)) = 0) then
      Continue;
    Inc(matches);
    if FVisibleOrders.Count < OrderRows then
      FVisibleOrders.Add(I);
  end;
  FGrid.BeginUpdate;
  try
    for row := 1 to OrderRows do
    begin
      if row - 1 < FVisibleOrders.Count then
      begin
        o := FOrders[FVisibleOrders[row - 1]];
        FGrid.Cells[0, row] := o.Id;
        FGrid.Cells[1, row] := o.Customer;
        FGrid.Cells[2, row] := o.Date;
        FGrid.Cells[3, row] := o.Total;
        FGrid.Cells[4, row] := o.Status;
        { the fulfilment: a progress bar of the cell's value with the value next to it }
        FGrid.Cells[5, row] := IntToStr(o.Pct);
        FGrid.AddDataProgressBar(5, row);
      end
      else
      begin
        FGrid.Cells[0, row] := '';
        FGrid.Cells[1, row] := '';
        FGrid.Cells[2, row] := '';
        FGrid.Cells[3, row] := '';
        FGrid.Cells[4, row] := '';
        FGrid.Cells[5, row] := '';
        FGrid.Root.RemoveDataProgressBar(5, row);
      end;
    end;
  finally
    FGrid.EndUpdate;
  end;
  FOrdersCard.Footer.Text := Format('%d of %d orders', [FVisibleOrders.Count, matches]);
end;

{ ---------------------------------------------------------------- layout }

{ The design's flex layout: the navigation (flex 1 1 220px, at most 232) and the main area
  (flex 999 1 640px) share what is left of the width 1 : 999; the orders card (flex 999 1 560px)
  and the right column (flex 1 1 320px) likewise. }
procedure TDashboard.Layout;
var
  W, H, y, navW, mainX, mainW, cw, ordersW, rightW, rightX, projY, projH, ew, nw, sw: Single;
  I: Integer;
begin
  if not Assigned(FStatus) then
    Exit;
  W := FForm.ClientWidth / Scale;
  H := FForm.ClientHeight / Scale;
  navW := Min(232, 220 + Max(0, W - 860) / 1000);
  mainX := navW + PadX;
  mainW := W - navW - 2 * PadX;
  FCompact := H < DesignH - 0.5;

  { bars: the panels reach past the edges of the window, so only their inner border line shows
    and the rounded corners a themed panel (a card) gets stay out of sight }
  Place(FHeader, -BarOverhang, -BarOverhang, W + 2 * BarOverhang, HeaderH + BarOverhang);
  LayoutHeader(W);
  Place(FStatus, -1, H - StatusH, W + 2, StatusH + 1);
  { from x -1: an 11 px panel, 'Theme: <name>' (its text 10 px into its panel, at 20), 20 px to
    '30 orders'; the right text ends 20 px before the edge (an 11 px panel after it) }
  sw := TextWidth('Theme: ', 12, False) + TextWidth(TTMSFNCTheme.Current, 12, True) + 24;
  FStatus.Panels.Items[0].Width := Round(S(11));
  FStatus.Panels.Items[1].Width := Round(S(sw));
  FStatus.Panels.Items[2].Width := Round(S(TextWidth(FStatus.Panels.Items[2].Text, 12, False) + 20));
  FStatus.Panels.Items[4].Width := Round(S(TextWidth(FStatus.Panels.Items[4].Text, 12, False) + 26));
  FStatus.Panels.Items[5].Width := Round(S(11));
  FStatus.Panels.Items[3].Width := Max(10, Round(S(W + 2)) - FStatus.Panels.Items[0].Width - FStatus.Panels.Items[1].Width -
    FStatus.Panels.Items[2].Width - FStatus.Panels.Items[4].Width - FStatus.Panels.Items[5].Width);
  Place(FNavPanel, -BarOverhang, HeaderH - BarOverhang, navW + BarOverhang, H - HeaderH - StatusH + 2 * BarOverhang);
  { nav: padding 12 10; the lists start 1 px early, their pills are inset 1 px in a 38 px item }
  Place(FNav, BarOverhang + 10, BarOverhang + 12 - NavGap / 2, navW - 21, Length(NavNames) * (NavRowH + NavGap));
  Place(FNavBottom, BarOverhang + 10, BarOverhang + H - HeaderH - StatusH - 12 - NavRowH - NavGap / 2, navW - 21,
    NavRowH + NavGap);

  y := HeaderH + PadTop;
  Place(FPageTitle, mainX, y, mainW - 240, 32);
  Place(FPageSub, mainX, y + 32, mainW - 240, 20);
  nw := TextWidth(FNewOrder.Text, 14, True) + 30;
  ew := TextWidth(FExport.Text, 14, False) + 30;
  Place(FNewOrder, mainX + mainW - nw, y + 20, nw, 32);
  Place(FExport, mainX + mainW - nw - 12 - ew, y + 20, ew, 32);
  y := y + 52 + SectionGap;

  cw := (mainW - 3 * Gap) / 4;
  for I := 0 to 3 do
  begin
    PlaceCard(FKpiCards[I], mainX + I * (cw + Gap), y, cw, KpiH);
    LayoutKpi(I, cw);
  end;
  y := y + KpiH + SectionGap;

  ordersW := 560 + Max(0, mainW - 560 - 320 - Gap) * 0.999;
  rightW := mainW - Gap - ordersW;
  rightX := mainX + ordersW + Gap;
  PlaceCard(FOrdersCard, mainX, y, ordersW, OrdersH);
  LayoutOrders(ordersW, OrdersH);

  PlaceCard(FGoalsCard, rightX, y, rightW, GoalsH);
  LayoutGoals(rightW);
  PlaceCard(FPrefsCard, rightX, y + GoalsH + Gap, rightW, PrefsH);
  LayoutPrefs(rightW, PrefsH);

  if FCompact then
  begin
    { not enough height: the projects card under the orders card, down to the bottom }
    projY := y + OrdersH + Gap;
    projH := Max(160, H - StatusH - 24 - projY);
    PlaceCard(FProjectsCard, mainX, projY, ordersW, projH);
    LayoutProjects(ordersW, projH);
  end
  else
  begin
    projY := y + GoalsH + Gap + PrefsH + SectionGap;
    PlaceCard(FProjectsCard, mainX, projY, mainW, ProjectsH);
    LayoutProjects(mainW, ProjectsH);
  end;
end;

procedure TDashboard.LayoutHeader(W: Single);
var
  x, y, sw, fw, titleRight: Single;
  I: Integer;
begin
  { coordinates inside the header panel, which starts BarOverhang outside the window; the content
    box is the header without its 1 px bottom border, its items centered in it }
  x := BarOverhang;
  y := BarOverhang;
  Place(FMark, x + 20, y + 13.5, 28, 28);
  Place(FAppTitle, x + 58, y + 17.5, TextWidth(FAppTitle.Text, 15, True) + 6, 20);
  titleRight := x + 58 + TextWidth(FAppTitle.Text, 15, True);

  x := x + W - 20 - 32;
  Place(FAvatar, x, y + 11.5, 32, 32);
  { five 20 px swatches 6 apart; the selector keeps 4 px around them for its focus ring }
  x := x - 16 - (5 * 20 + 4 * 6);
  Place(FAccent, x - 4, y + 17.5 - 4, 5 * 20 + 4 * 6 + 8, 28);

  { the theme selector sizes itself to its segments (border 1, padding 3, 12 + text + 12, 2 apart)
    and its 'Follow system' switch (16 px after the segments, the text, 8 px, a 36 px switch); its
    full theme names, or the short ones when those do not fit between the app title and the
    swatches }
  sw := 2 * 4 + 2 * High(SegmentNames) + 16 + TextWidth(FThemeSelector.FollowSystemText, 13.3, False) + 8 + 36;
  for I := 0 to High(SegmentNames) do
    sw := sw + TextWidth(Copy(SegmentNames[I], Pos('=', SegmentNames[I]) + 1, MaxInt), 13.3, True) + 24;
  SetThemeCaptions(x - 16 - sw < titleRight + 16);
  fw := FThemeSelector.Width / Scale;
  Place(FThemeSelector, x - 16 - fw, y + 9.5, fw, 36);
end;

procedure TDashboard.LayoutKpi(AIndex: Integer; W: Single);
var
  bw: Single;
begin
  { border 1, padding 16 18: label 20, gap 6, value 36, gap 6, delta row 20 }
  PlaceIn(FKpiLabels[AIndex], 19, 17, W - 38, 20);
  PlaceIn(FKpiValues[AIndex], 19, 43, W - 38, 36);
  bw := TextWidth(FKpiDeltas[AIndex].Text, 12, True) + 16;
  PlaceIn(FKpiDeltas[AIndex], 19, 85, bw, 20);
  PlaceIn(FKpiNotes[AIndex], 19 + bw + 8, 85, W - 38 - bw - 8, 20);
end;

procedure TDashboard.LayoutOrders(W, H: Single);
var
  gw, rest: Single;
  I: Integer;
const
  { the table's column widths at the design width; Customer takes what is left }
  Fixed: array[0..5] of Single = (112.3, 0, 88.6, 112.8, 141.5, 150);
begin
  { the header: the title, then (right aligned, 12 apart) the chips and the 200 px search box; the
    rows below the header's divider: the table header 36 + its divider, the rows 39 + their divider;
    the footer under the table }
  FOrdersCard.Header.Size := S(OrdersTop);
  FOrdersCard.Footer.Size := S(OrdersFooterH);
  FChips.Height := Round(S(28));
  FSearch.Height := Round(S(32));
  FSearch.Width := Round(S(200));
  FOrdersCard.Header.Actions[0].Width := FChips.Width / Scale;
  FOrdersCard.Header.Actions[1].Width := 200;
  FViewAll.Height := Round(S(20));
  FOrdersCard.Footer.Actions[0].Width := 120;
  gw := W - 2;
  PlaceIn(FGrid, 1, OrdersTop, gw, OrderHeaderH + OrderRows * OrderRowH);
  FGrid.BeginUpdate;
  try
    FGrid.DefaultRowHeight := S(OrderRowH);
    for I := 1 to FGrid.RowCount - 1 do
      FGrid.RowHeights[I] := S(OrderRowH);
    FGrid.RowHeights[0] := S(OrderHeaderH);
    rest := gw;
    for I := 0 to 5 do
      rest := rest - Fixed[I];
    for I := 0 to 5 do
      if Fixed[I] > 0 then
        FGrid.ColumnWidths[I] := S(Fixed[I])
      else
        FGrid.ColumnWidths[I] := S(Max(120, rest));
  finally
    FGrid.EndUpdate;
  end;
end;

procedure TDashboard.LayoutProjects(W, H: Single);
begin
  { header: the title and the note at its end; a divider; rows of 35 + their divider }
  FProjectsCard.Header.Size := S(ProjectsTop);
  FProjectsNote.Height := Round(S(20));
  FProjectsCard.Header.Actions[0].Width := 240;
  PlaceIn(FTree, 1, ProjectsTop, W - 2, H - ProjectsTop - 1);
  { Owner at 120 + 10 and Status at 110 + 18 from the right; the tree draws a cell's text 8 px in }
  FTree.Columns[1].Width := S(130);
  FTree.Columns[2].Width := S(136);
end;

procedure TDashboard.LayoutGoals(W: Single);
var
  I: Integer;
  y: Single;
begin
  { border 1, padding 16 18, gap 14: the title in the card header, then per goal a 20 px row, gap 6
    and an 8 px bar }
  FGoalsCard.Header.Size := S(CardTitleH);
  for I := 0 to 2 do
  begin
    y := 55 + I * 48;
    PlaceIn(FGoalLabels[I], 19, y, W - 38 - 60, 20);
    PlaceIn(FGoalPcts[I], W - 19 - 60, y, 60, 20);
    PlaceIn(FGoalBars[I], 19, y + 26, W - 38, 8);
  end;
end;

procedure TDashboard.LayoutPrefs(W, H: Single);
var
  colW, dw, sw, cw: Single;
begin
  { border 1, padding 16 18, gap 14 between the groups; the title in the card header }
  FPrefsCard.Header.Size := S(CardTitleH);
  colW := (W - 38 - 12) / 2;
  PlaceIn(FNameLabel, 19, 55, W - 38, 20);
  PlaceIn(FNameEdit, 19, 81, W - 38, 32);
  PlaceIn(FRegionLabel, 19, 127, colW, 20);
  PlaceIn(FRegion, 19, 153, colW, 32);
  PlaceIn(FDateLabel, 19 + colW + 12, 127, colW, 20);
  PlaceIn(FDate, 19 + colW + 12, 153, colW, 32);
  PlaceIn(FCheckEmail, 19, 199, W - 38, 20);
  PlaceIn(FCheckArchived, 19, 229, W - 38, 20);
  dw := 26 + TextWidth(FRadioDaily.Text, 14, False);
  PlaceIn(FRadioDaily, 19, 263, dw, 20);
  PlaceIn(FRadioWeekly, 19 + dw + 20, 263, 26 + TextWidth(FRadioWeekly.Text, 14, False) + 4, 20);
  PlaceIn(FDetailLabel, 19, 297, W - 38 - 60, 20);
  PlaceIn(FDetailPct, W - 19 - 60, 297, 60, 20);
  { the track bar keeps its track 4 px (left) and 5 px (right) inside its bounds, where the thumb
    turns; the design's track spans the full width }
  PlaceIn(FDetail, 19 - 4, 325, W - 38 + 9, 18);
  sw := TextWidth(FSave.Text, 14, True) + 34;
  cw := TextWidth(FCancel.Text, 14, False) + 34;
  PlaceIn(FSave, W - 19 - sw, 361, sw, 32);
  PlaceIn(FCancel, W - 19 - sw - 8 - cw, 361, cw, 32);
end;

procedure TDashboard.FitToScreen;
begin
  { WEB: the page is the browser window, the layout follows its size (FormResize) }
  {$IFNDEF WEBLIB}
  if FForm.Height > Screen.WorkAreaHeight then
  begin
    FForm.Top := {$IFDEF FMX}Round(Screen.WorkAreaTop){$ELSE}Screen.WorkAreaTop{$ENDIF};
    FForm.Height := {$IFDEF FMX}Round(Screen.WorkAreaHeight){$ELSE}Screen.WorkAreaHeight{$ENDIF};
  end;
  if FForm.Width > Screen.WorkAreaWidth then
  begin
    FForm.Left := {$IFDEF FMX}Round(Screen.WorkAreaLeft){$ELSE}Screen.WorkAreaLeft{$ENDIF};
    FForm.Width := {$IFDEF FMX}Round(Screen.WorkAreaWidth){$ELSE}Screen.WorkAreaWidth{$ENDIF};
  end;
  {$ENDIF}
end;

{ ---------------------------------------------------------------- theming }

procedure TDashboard.ThemeChanged;
var
  t: TTMSFNCResolvedTheme;
  txt: TTMSFNCHTMLText;
  {$IFDEF WEBLIB}
  url: string;
  {$ENDIF}
begin
  FSeenVersion := TTMSFNCTheme.Version;
  t := Theme;
  UpdateStatusText;
  if not Assigned(t) then
    Exit;

  for txt in FSecondary do
    txt.Font.Color := t[ttTextSecondary];
  FViewAll.URLColor := t[ttAccentText];

  { the app mark: the accent with the mark in the text on the accent }
  FMark.Appearance.Fill.Kind := gfkSolid;
  FMark.Appearance.Fill.Color := t[ttAccent];
  FMark.Appearance.Stroke.Kind := gskSolid;
  FMark.Appearance.Stroke.Color := t[ttAccent];
  FMark.Appearance.HoverFill.Assign(FMark.Appearance.Fill);
  FMark.Appearance.HoverStroke.Assign(FMark.Appearance.Stroke);
  FMark.Appearance.DownFill.Assign(FMark.Appearance.Fill);
  FMark.Appearance.DownStroke.Assign(FMark.Appearance.Stroke);
  {$IFDEF WEBLIB}
  url := SvgDataURL(Svg(MarkIcon, t[ttTextOnAccent], 24));
  FMark.Bitmap.LoadFromURL(url);
  {$ELSE}
  FMark.Bitmap.LoadFromSVG(Svg(MarkIcon, t[ttTextOnAccent], 24));
  {$ENDIF}

  { High Contrast uses the system's colors only (the accent override does not apply): no swatches }
  FAccent.Visible := t.Mode <> tmHighContrast;

  { the search icon in the button of the search box }
  {$IFDEF WEBLIB}
  FSearch.Bitmap.LoadFromURL(SvgDataURL(Svg(SearchIcon, t[ttTextTertiary], 16)));
  {$ELSE}
  FSearch.Bitmap.LoadFromSVG(Svg(SearchIcon, t[ttTextTertiary], 16));
  {$ENDIF}

  { the settings item in the secondary text color }
  FNavBottom.Items[0].TextColor := t[ttTextSecondary];
  UpdateNavIcons;

  { the layout depends on the active segment and on the fonts of the theme }
  Layout;
  FHeader.Invalidate;
  FGrid.Invalidate;
  FTree.Invalidate;
end;

procedure TDashboard.ApplyTheme(const AName: string);
begin
  { the selector switches following the system off and applies the theme through the manager }
  FThemeSelector.SelectedTheme := AName;
  ThemeChanged;
end;

{ ---------------------------------------------------------------- events }

procedure TDashboard.FormResize(Sender: TObject);
begin
  Layout;
end;

procedure TDashboard.TimerTick(Sender: TObject);
begin
  if TTMSFNCTheme.Version <> FSeenVersion then
    ThemeChanged;
end;

procedure TDashboard.ThemeApplied(Sender: TObject; const AThemeName: string);
begin
  ThemeChanged;
end;

procedure TDashboard.FollowSystemChanged(Sender: TObject);
begin
  ThemeChanged;
end;

procedure TDashboard.AccentApplied(Sender: TObject; AItemIndex: Integer; AColor: TTMSFNCGraphicsColor);
begin
  ThemeChanged;
end;

procedure TDashboard.ChipSelected(Sender: TObject; AItemIndex: Integer);
begin
  FFilter := Max(0, FChips.ItemIndex);
  FillGrid;
end;

procedure TDashboard.SearchChange(Sender: TObject);
begin
  if not FUpdating then
    FillGrid;
end;

procedure TDashboard.NavSelected(Sender: TObject; AItem: TTMSFNCListBoxItem);
begin
  if FUpdating or not Assigned(AItem) then
    Exit;
  FNavIndex := AItem.Tag;
  FUpdating := True;
  try
    if Sender = FNav then
      FNavBottom.ItemIndex := -1
    else
      FNav.ItemIndex := -1;
  finally
    FUpdating := False;
  end;
  if FNavIndex < Length(NavNames) then
    FPageTitle.Text := NavNames[FNavIndex]
  else
    FPageTitle.Text := 'Settings';
  UpdateNavIcons;
end;

procedure TDashboard.RegionSelected(Sender: TObject; AText: string; AItemIndex: Integer);
begin
  FPageSub.Text := 'Week 42' + Dot + AText;
end;

procedure TDashboard.DetailChanged(Sender: TObject; AValue: Single);
begin
  FDetailPct.Text := IntToStr(Round(AValue)) + '%';
end;

{ the cells' text: 18 px in at the card's edges, 12 px between the columns; the order number
  semibold in the accent text color, the date in the secondary text color }
procedure TDashboard.GridGetCellLayout(Sender: TObject; ACell: TTMSFNCDataGridCell);
var
  t: TTMSFNCResolvedTheme;
begin
  if ACell.Column = 0 then
    ACell.Layout.TextMargins.Left := 18
  else
    ACell.Layout.TextMargins.Left := 12;
  if ACell.Column = 3 then
  begin
    ACell.Layout.TextAlign := gtaTrailing;
    ACell.Layout.TextMargins.Right := 12;
  end;
  if ACell.Column = 5 then
    ACell.Layout.TextMargins.Right := 18;
  if ACell.Row = 0 then
    Exit;
  t := Theme;
  if not Assigned(t) then
    Exit;
  SetFont(ACell.Layout.Font, 13, ACell.Column = 0);
  case ACell.Column of
    0: ACell.Layout.Font.Color := t[ttAccentText];
    2: ACell.Layout.Font.Color := t[ttTextSecondary];
  end;
end;

{ the owners in the secondary text color }
procedure TDashboard.TreeGetNodeTextColor(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer;
  var ATextColor: TTMSFNCGraphicsColor);
var
  t: TTMSFNCResolvedTheme;
begin
  if AColumn <> 1 then
    Exit;
  t := Theme;
  if Assigned(t) then
    ATextColor := t[ttTextSecondary];
end;

end.
