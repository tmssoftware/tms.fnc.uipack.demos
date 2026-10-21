unit UBL;

{ TMS FNC UI Pack - Theming Dashboard demo: builds the whole dashboard in code.

  One source for VCL, FMX and WEB (TMS WEB Core; the VCL / FMX / WEBLIB define of the project): the
  FNC API is the same in the frameworks.

  How the theming works in this demo:
  * the form has a TTMSFNCThemeManager (Scope tsApplication, Theme 'Fluent Light'): every FNC
    control of the application follows the theme by itself, also the ones created in code here;
  * the theme switcher in the header calls TTMSFNCTheme.Apply with the theme of the clicked segment;
  * the 'Follow system' switch calls TTMSFNCTheme.SetFollowSystem with the light and the dark theme
    of the current family (Fluent or Microsoft 365): the engine then applies the one that matches
    the Windows mode (WEB: the browser's prefers-color-scheme), also when that mode changes while the
    application runs;
  * the accent swatches call TTMSFNCTheme.SetAccent (gcNull removes the override again);
  * the demo only colors what is its own composition (the segmented switcher, chips, status pills,
    secondary text). It takes those colors from the tokens of the current theme
    (TTMSFNCTheme.Resolve(TTMSFNCTheme.Current)[ttSurface] and so on) in ThemeChanged, which runs
    again after every theme or accent change (TTMSFNCTheme.Version tells that one happened).

  Layout: positions follow the FNC design of the dashboard (1440 x 1277, in pixels at 96 DPI); a
  smaller window moves the projects card under the orders card. }

interface

uses
  {$IFDEF WEBLIB}
  SysUtils, Classes, Types, Math, Generics.Collections, DateUtils, StrUtils,
  WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.ExtCtrls,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes, WEBLib.TMSFNCTheme,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCToolBar, WEBLib.TMSFNCSwitch,
  WEBLib.TMSFNCListBox, WEBLib.TMSFNCBadge, WEBLib.TMSFNCDataGrid, WEBLib.TMSFNCDataGridCell,
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
  FMX.TMSFNCCustomControl, FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCToolBar, FMX.TMSFNCSwitch,
  FMX.TMSFNCListBox, FMX.TMSFNCBadge, FMX.TMSFNCDataGrid, FMX.TMSFNCDataGridCell,
  FMX.TMSFNCDataGridRenderer, FMX.TMSFNCDataGridCore, FMX.TMSFNCProgressBar, FMX.TMSFNCEdit,
  FMX.TMSFNCComboBox, FMX.TMSFNCDatePicker, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCTrackBar, FMX.TMSFNCTreeView, FMX.TMSFNCTreeViewData, FMX.TMSFNCCustomTreeView,
  FMX.TMSFNCCheckedTreeView, FMX.TMSFNCStatusBar, FMX.TMSFNCButton;
  {$ELSE}
  Winapi.Windows, Winapi.Messages, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.ExtCtrls,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCTheme,
  VCL.TMSFNCCustomControl, VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCToolBar, VCL.TMSFNCSwitch,
  VCL.TMSFNCListBox, VCL.TMSFNCBadge, VCL.TMSFNCDataGrid, VCL.TMSFNCDataGridCell,
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

  TStatusKind = (skInfo, skSuccess, skWarning, skError);

  TOrder = record
    Id, Customer, Date, Total, Status: string;
    Pct: Integer;
  end;

  TProject = record
    Name, Owner, Status: string;
    Level: Integer;
    Done: Boolean;
  end;

  { An accent swatch: a 20 px dot in its color with a ring in the surface color; the active one has
    an outer ring in the text color. Composition of the demo, painted by itself. }
  TDashSwatch = class(TTMSFNCCustomControl)
  private
    FSwatchColor: TTMSFNCGraphicsColor;
    FRingColor: TTMSFNCGraphicsColor;
    FOuterColor: TTMSFNCGraphicsColor;
  protected
    procedure Draw(AGraphics: TTMSFNCGraphics; ARect: TRectF); override;
  public
    property SwatchColor: TTMSFNCGraphicsColor read FSwatchColor write FSwatchColor;
    property RingColor: TTMSFNCGraphicsColor read FRingColor write FRingColor;
    property OuterColor: TTMSFNCGraphicsColor read FOuterColor write FOuterColor;
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
    FAccentIndex: Integer;
    FFamily: string;
    FCompact: Boolean;
    { the card being laid out: where its body starts inside its bounds (the room of its shadow) }
    FOX, FOY: Single;
    { header }
    FHeader: TTMSFNCPanel;
    FMark: TTMSFNCPanel;
    FAppTitle: TTMSFNCHTMLText;
    FSwitcher: TTMSFNCPanel;
    FSegments: array[0..4] of TTMSFNCToolBarButton;
    FFollowLabel: TTMSFNCHTMLText;
    FFollow: TTMSFNCSwitch;
    FSwatches: array[0..4] of TDashSwatch;
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
    { recent orders }
    FOrdersCard: TTMSFNCPanel;
    FOrdersTitle: TTMSFNCHTMLText;
    FChips: array[0..3] of TTMSFNCToolBarButton;
    FSearch: TTMSFNCEditButton;
    FGrid: TTMSFNCDataGrid;
    FOrdersCount: TTMSFNCHTMLText;
    FViewAll: TTMSFNCHTMLText;
    { projects }
    FProjectsCard: TTMSFNCPanel;
    FProjectsTitle: TTMSFNCHTMLText;
    FProjectsNote: TTMSFNCHTMLText;
    FTree: TTMSFNCCheckedTreeView;
    { quarterly goals }
    FGoalsCard: TTMSFNCPanel;
    FGoalsTitle: TTMSFNCHTMLText;
    FGoalLabels: array[0..2] of TTMSFNCHTMLText;
    FGoalPcts: array[0..2] of TTMSFNCHTMLText;
    FGoalBars: array[0..2] of TTMSFNCProgressBar;
    { report preferences }
    FPrefsCard: TTMSFNCPanel;
    FPrefsTitle: TTMSFNCHTMLText;
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
    { WEB: an image loads asynchronously; the icons, per SVG text, once loaded }
    FIcons: TDictionary<string, TTMSFNCBitmap>;
    function IconBitmap(const ASvg: string): TTMSFNCBitmap;
    {$ENDIF}

    function Theme: TTMSFNCResolvedTheme;
    function Scale: Single;
    function S(AValue: Single): Single;
    procedure Place(AControl: TControl; X, Y, W, H: Single);
    procedure PlaceCard(ACard: TTMSFNCPanel; X, Y, W, H: Single);
    procedure PlaceIn(AControl: TControl; X, Y, W, H: Single);
    procedure SetFont(AFont: TTMSFNCGraphicsFont; APx: Single; ASemibold: Boolean);
    function NewCard(AParent: TDashParent; AShadow: Boolean = False): TTMSFNCPanel;
    function NewText(AParent: TDashParent; const AText: string; APx: Single; ASemibold: Boolean = False;
      ASecondary: Boolean = False; AAlign: TTMSFNCGraphicsTextAlign = gtaLeading): TTMSFNCHTMLText;
    function NewButton(AParent: TDashParent; const AText: string; APx: Single; ASemibold: Boolean;
      AOnClick: TNotifyEvent): TTMSFNCToolBarButton;
    function NewActionButton(AParent: TDashParent; const AText: string; APrimary: Boolean): TTMSFNCButton;
    function NewPill(AParent: TDashParent; const AText: string): TTMSFNCBadge;
    function TextWidth(const AText: string; APx: Single; ASemibold: Boolean): Single;
    function SegmentTheme(AIndex: Integer): string;
    function ActiveSegment: Integer;

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

    procedure LayoutHeader(W: Single);
    procedure LayoutKpi(AIndex: Integer; W: Single);
    procedure LayoutOrders(W, H: Single);
    procedure LayoutProjects(W, H: Single);
    procedure LayoutGoals(W: Single);
    procedure LayoutPrefs(W, H: Single);

    procedure StyleButton(AButton: TTMSFNCToolBarButton; AFill, AStroke, AFont, AHover, ADown: TTMSFNCGraphicsColor);
    procedure StatusColors(AKind: TStatusKind; out ABack, AFore: TTMSFNCGraphicsColor);
    procedure DrawPill(AGraphics: TTMSFNCGraphics; const ARect: TRectF; const AText: string; AKind: TStatusKind; ADot: Boolean);
    procedure DrawNavItem(AList: TTMSFNCListBox; AGraphics: TTMSFNCGraphics; ARect: TRectF; AItem: TTMSFNCListBoxItem);

    procedure FormResize(Sender: TObject);
    procedure TimerTick(Sender: TObject);
    procedure SegmentClick(Sender: TObject);
    procedure FollowChange(Sender: TObject);
    procedure SwatchClick(Sender: TObject);
    procedure ChipClick(Sender: TObject);
    procedure SearchChange(Sender: TObject);
    procedure NavSelected(Sender: TObject; AItem: TTMSFNCListBoxItem);
    procedure NavBeforeDrawItem(Sender: TObject; AGraphics: TTMSFNCGraphics; ARect: TRectF; AItem: TTMSFNCListBoxItem;
      var AAllow: Boolean; var ADefaultDraw: Boolean);
    procedure NavBeforeDrawItemText(Sender: TObject; AGraphics: TTMSFNCGraphics; ARect: TRectF; AItem: TTMSFNCListBoxItem;
      AText: String; var AAllow: Boolean);
    procedure RegionSelected(Sender: TObject; AText: string; AItemIndex: Integer);
    procedure DetailChanged(Sender: TObject; AValue: Single);
    procedure MarkAfterDraw(Sender: TObject; AGraphics: TTMSFNCGraphics; ARect: TRectF);
    procedure CardAfterDraw(Sender: TObject; AGraphics: TTMSFNCGraphics; ARect: TRectF);
    procedure GridGetCellLayout(Sender: TObject; ACell: TTMSFNCDataGridCell);
    procedure GridAfterDrawCell(Sender: TObject; AGraphics: TTMSFNCGraphics; ACell: TTMSFNCDataGridCell);
    procedure TreeBeforeDrawNodeText(Sender: TObject; AGraphics: TTMSFNCGraphics; ARect: TRectF; AColumn: Integer;
      ANode: TTMSFNCTreeViewVirtualNode; AText: String; var AAllow: Boolean);
    procedure TreeGetNodeTextColor(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer;
      var ATextColor: TTMSFNCGraphicsColor);
    procedure StatusDrawPanel(Sender: TObject; AGraphics: TTMSFNCGraphics; ARect: TRectF; APanel: TTMSFNCStatusBarPanel);
  public
    constructor Create(AForm: TForm); reintroduce;
    destructor Destroy; override;
    procedure Layout;
    { Shrinks the window to the work area of a smaller screen; the layout adapts. }
    procedure FitToScreen;
    { Applies a theme the way the switcher does (follow system off) and refreshes the UI. }
    procedure ApplyTheme(const AName: string);
    { Re-colors the demo's own composition from the current theme's tokens. }
    procedure ThemeChanged;
  end;

implementation

const
  Dot = ' ' + #$00B7 + ' ';

  { one segment per theme; each always applies exactly that theme }
  SegmentNames: array[0..4] of string = ('Fluent Light', 'Fluent Dark', 'Microsoft 365 Light', 'Microsoft 365 Dark',
    'High contrast');
  { the labels used when the full names do not fit next to the app title (a narrow window) }
  SegmentShortNames: array[0..4] of string = ('Fluent Light', 'Fluent Dark', 'M365 Light', 'M365 Dark',
    'High contrast');
  { the first swatch is the theme's own accent (a blue in every built-in theme): no override }
  AccentNames: array[0..4] of string = ('Theme accent', 'Purple', 'Teal', 'Crimson', 'Amber');
  AccentHex: array[0..4] of string = ('#0F6CBD', '#6B4FBB', '#0E7C66', '#C4314B', '#B86E00');
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

  KpiLabels: array[0..3] of string = ('Revenue', 'Open orders', 'New customers', 'Satisfaction');
  KpiValues: array[0..3] of string = ('$128.4K', '86', '1,204', '4.6 / 5');
  KpiDeltas: array[0..3] of string = ('+12.4%', '14 late', '+8.1%', #$2212'0.1');
  KpiKinds: array[0..3] of TStatusKind = (skSuccess, skWarning, skSuccess, skError);

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
  OrderHeaderH = 37;     // 36 + the divider at its bottom (the one above it is the card's)
  ProjectRowH = 36;
  { the page height the design is laid out for: below it the projects card moves under the orders }
  DesignH = HeaderH + PadTop + 52 + SectionGap + KpiH + SectionGap + GoalsH + Gap + PrefsH + SectionGap +
    ProjectsH + PadBottom + StatusH;

  { status pills of the FNC design (Fluent themes): tint, text }
  DesignStatusLight: array[TStatusKind, 0..1] of string = (('#E8F1FB', '#0F5BA7'), ('#E6F4EA', '#1E7B34'),
    ('#FFF3E0', '#A15C00'), ('#FDECEA', '#B42318'));
  DesignStatusDark: array[TStatusKind, 0..1] of string = (('#1C2F44', '#7DB7F0'), ('#1F3A26', '#6CCB7A'),
    ('#3D2F17', '#F2B860'), ('#45201F', '#F0857D'));

type
  TFNCControlAccess = class(TTMSFNCCustomControl);
  {$IFNDEF WEBLIB}
  TControlAccess = class(TControl);
  {$ENDIF}

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

function RGBColor(R, G, B: Byte): TTMSFNCGraphicsColor;
begin
  {$IFDEF FMX}
  Result := $FF000000 or (Cardinal(R) shl 16) or (Cardinal(G) shl 8) or B;
  {$ELSE}
  Result := TColor(R or (G shl 8) or (B shl 16));
  {$ENDIF}
end;

function HexColor(const AHex: string): TTMSFNCGraphicsColor;
var
  v: Integer;
begin
  v := StrToInt('$' + Copy(AHex, 2, 6));
  Result := RGBColor((v shr 16) and $FF, (v shr 8) and $FF, v and $FF);
end;

function ColorHex(AColor: TTMSFNCGraphicsColor): string;
var
  r, g, b: Byte;
begin
  ColorRGB(AColor, r, g, b);
  Result := '#' + IntToHex(r, 2) + IntToHex(g, 2) + IntToHex(b, 2);
end;

function Mix(A, B: TTMSFNCGraphicsColor; T: Single): TTMSFNCGraphicsColor;
var
  ar, ag, ab, br, bg, bb: Byte;
begin
  ColorRGB(A, ar, ag, ab);
  ColorRGB(B, br, bg, bb);
  Result := RGBColor(Round(ar + (br - ar) * T), Round(ag + (bg - ag) * T), Round(ab + (bb - ab) * T));
end;

function SameRGB(A, B: TTMSFNCGraphicsColor; ATolerance: Integer = 2): Boolean;
var
  ar, ag, ab, br, bg, bb: Byte;
begin
  ColorRGB(A, ar, ag, ab);
  ColorRGB(B, br, bg, bb);
  Result := (Abs(ar - br) <= ATolerance) and (Abs(ag - bg) <= ATolerance) and (Abs(ab - bb) <= ATolerance);
end;

function IsFluentTheme: Boolean;
begin
  Result := StartsText('Fluent', TTMSFNCTheme.Current);
end;

{ the text on the selection tint: the accent text (the design), or the text on the accent where a
  theme selects with a solid, dark fill (the Framework theme follows the platform style); High
  Contrast: the selection text of the system (on its highlight color) }
function SelectionTextColor(T: TTMSFNCResolvedTheme): TTMSFNCGraphicsColor;
var
  r, g, b: Byte;
  c: TTMSFNCGraphicsColor;
begin
  if T.Mode = tmHighContrast then
    Exit(T[ttSelectionText]);
  Result := T[ttAccentText];
  c := T[ttSelection];
  ColorRGB(c, r, g, b);
  if {$IFDEF FMX}((c shr 24) >= $C0) and {$ENDIF}(0.299 * r + 0.587 * g + 0.114 * b < 140) and (T.Mode = tmLight) then
    Result := T[ttTextOnAccent];
end;

{ the track of a bar }
function TrackColor(T: TTMSFNCResolvedTheme): TTMSFNCGraphicsColor;
begin
  Result := T[ttTrack];
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

function StatusKindOf(const AStatus: string): TStatusKind;
begin
  if SameText(AStatus, 'Shipped') or SameText(AStatus, 'On track') then
    Result := skSuccess
  else if SameText(AStatus, 'Late') or SameText(AStatus, 'At risk') then
    Result := skError
  else if SameText(AStatus, 'Packing') or SameText(AStatus, 'In progress') then
    Result := skWarning
  else
    Result := skInfo;
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

{ ---------------------------------------------------------------- swatch }

procedure TDashSwatch.Draw(AGraphics: TTMSFNCGraphics; ARect: TRectF);
var
  r: TRectF;
  k: Single;
begin
  { a 2 px outer ring (the text color when active, else the swatch color), a 2 px ring in the
    surface color, the swatch color inside }
  k := ScalePaintValue(2);
  r := RectF(0, 0, Width, Height);
  AGraphics.Stroke.Kind := gskNone;
  AGraphics.Fill.Kind := gfkSolid;
  AGraphics.Fill.Color := FOuterColor;
  AGraphics.DrawEllipse(r, gcrmNone);
  InflateRectEx(r, -k, -k);
  AGraphics.Fill.Color := FRingColor;
  AGraphics.DrawEllipse(r, gcrmNone);
  InflateRectEx(r, -k, -k);
  AGraphics.Fill.Color := FSwatchColor;
  AGraphics.DrawEllipse(r, gcrmNone);
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
  {$IFDEF WEBLIB}
  FIcons := TDictionary<string, TTMSFNCBitmap>.Create;
  {$ENDIF}
  FVisibleOrders := TList<Integer>.Create;
  FOrders := MakeOrders;
  FFilter := 0;
  FNavIndex := 0;
  FAccentIndex := 0;
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
  FTimer := TTimer.Create(Self);
  FTimer.Interval := 250;
  FTimer.OnTimer := TimerTick;
  FTimer.Enabled := True;
end;

destructor TDashboard.Destroy;
{$IFDEF WEBLIB}
var
  b: TTMSFNCBitmap;
{$ENDIF}
begin
  {$IFDEF WEBLIB}
  for b in FIcons.Values do
    b.Free;
  FIcons.Free;
  {$ENDIF}
  FSecondary.Free;
  FVisibleOrders.Free;
  inherited;
end;

{$IFDEF WEBLIB}
{ nil until the image is loaded; the navigation is painted again then }
function TDashboard.IconBitmap(const ASvg: string): TTMSFNCBitmap;
begin
  if FIcons.TryGetValue(ASvg, Result) then
  begin
    if Result.Empty then
      Result := nil;
    Exit;
  end;
  Result := TTMSFNCBitmap.Create;
  FIcons.Add(ASvg, Result);
  Result.LoadFromURL(SvgDataURL(ASvg),
    procedure
    begin
      { the list's items are painted by its inner tree view }
      FNav.TreeView.Invalidate;
      FNavBottom.TreeView.Invalidate;
    end);
  Result := nil;
end;
{$ENDIF}

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
  {$IFDEF FMX}
  AControl.SetBounds(l, t, Round(S(X + W)) - l, Round(S(Y + H)) - t);
  {$ELSE}
  AControl.SetBounds(l, t, Round(S(X + W)) - l, Round(S(Y + H)) - t);
  {$ENDIF}
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

{ A card: a panel (themed: the Fluent card look); AShadow: it casts the theme's soft shadow. Bars and
  small shapes that are panels too have none. }
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

function TDashboard.NewCard(AParent: TDashParent; AShadow: Boolean): TTMSFNCPanel;
begin
  Result := TTMSFNCPanel.Create(FForm);
  Result.Parent := AParent;
  Result.Shadow := AShadow;
  Result.Header.Visible := False;
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

function TDashboard.NewButton(AParent: TDashParent; const AText: string; APx: Single; ASemibold: Boolean;
  AOnClick: TNotifyEvent): TTMSFNCToolBarButton;
begin
  Result := TTMSFNCToolBarButton.Create(FForm);
  Result.Parent := AParent;
  Result.Text := AText;
  Result.HorizontalTextAlign := gtaCenter;
  SetFont(Result.Font, APx, ASemibold);
  Result.OnClick := AOnClick;
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

function TDashboard.NewPill(AParent: TDashParent; const AText: string): TTMSFNCBadge;
begin
  Result := TTMSFNCBadge.Create(FForm);
  Result.Parent := AParent;
  Result.Text := AText;
  Result.Appearance.Rounding := 10;
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
  case AIndex of
    0: Result := 'Fluent Light';
    1: Result := 'Fluent Dark';
    2: Result := 'Microsoft 365 Light';
    3: Result := 'Microsoft 365 Dark';
  else
    Result := TTMSFNCHighContrastThemeName;
  end;
end;

function TDashboard.ActiveSegment: Integer;
var
  cur: string;
begin
  cur := TTMSFNCTheme.Current;
  if SameText(cur, 'Fluent Light') then
    Result := 0
  else if SameText(cur, 'Fluent Dark') then
    Result := 1
  else if SameText(cur, 'Microsoft 365 Light') then
    Result := 2
  else if SameText(cur, 'Microsoft 365 Dark') then
    Result := 3
  else if SameText(cur, TTMSFNCHighContrastThemeName) then
    Result := 4
  else
    Result := -1;
end;

procedure TDashboard.BuildHeader;
var
  I: Integer;
begin
  FHeader := NewCard(FForm);

  FMark := NewCard(FHeader);
  FMark.OnAfterDraw := MarkAfterDraw;
  FAppTitle := NewText(FHeader, 'Theming Dashboard', 15, True);

  FSwitcher := NewCard(FHeader);
  for I := 0 to High(FSegments) do
  begin
    FSegments[I] := NewButton(FSwitcher, SegmentNames[I], 13, False, {$IFDEF WEBLIB}@{$ENDIF}SegmentClick);
    FSegments[I].Tag := I;
    FSegments[I].Appearance.ShowInnerStroke := False;
    FSegments[I].Appearance.Rounding := 6;
  end;

  FFollowLabel := NewText(FHeader, 'Follow system', 13, False, True, gtaLeading);
  FFollow := TTMSFNCSwitch.Create(FForm);
  FFollow.Parent := FHeader;
  FFollow.OnChange := FollowChange;

  for I := 0 to High(AccentHex) do
  begin
    FSwatches[I] := TDashSwatch.Create(FForm);
    FSwatches[I].Parent := FHeader;
    FSwatches[I].Tag := I;
    FSwatches[I].Hint := AccentNames[I];
    FSwatches[I].Fill.Kind := gfkSolid;
    FSwatches[I].Stroke.Kind := gskNone;
    {$IFNDEF FMX}{$IFNDEF WEBLIB}
    FSwatches[I].NativeCanvas := True;
    {$ENDIF}{$ENDIF}
    {$IFDEF WEBLIB}
    FSwatches[I].OnClick := @SwatchClick;
    {$ELSE}
    TControlAccess(FSwatches[I]).OnClick := SwatchClick;
    {$ENDIF}
  end;

  FAvatar := NewPill(FHeader, 'PS');
  FAvatar.Appearance.Rounding := 16;
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
    { owner drawn: a 36 px pill per item with 2 px between the items (the item is 38 px) }
    AList.ItemsAppearance.HeightMode := lihmFixed;
    AList.ItemsAppearance.FixedHeight := S(NavRowH + NavGap);
    AList.Stroke.Color := gcNull;
    AList.ItemsAppearance.Stroke.Color := gcNull;
    AList.ItemsAppearance.SelectedStroke.Color := gcNull;
    AList.ItemsAppearance.ShowFocus := False;
    AList.OnItemSelected := NavSelected;
    AList.OnBeforeDrawItem := NavBeforeDrawItem;
    AList.OnBeforeDrawItemText := NavBeforeDrawItemText;
    {$IFDEF WEBLIB}
    { WEB: the list's own element is transparent (its items are painted by the inner tree view; the
      element's background would show at the anti-aliased edges) }
    TFNCControlAccess(TObject(AList)).Fill.Kind := gfkNone;
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
      it := FNav.Items.Add;
      it.Text := NavNames[I];
      it.Tag := I;
    end;
  finally
    FNav.EndUpdate;
  end;

  FNavBottom := TTMSFNCListBox.Create(FForm);
  SetupList(FNavBottom);
  FNavBottom.BeginUpdate;
  try
    FNavBottom.Items.Clear;
    it := FNavBottom.Items.Add;
    it.Text := 'Settings';
    it.Tag := 5;
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
    FKpiDeltas[I] := NewPill(FKpiCards[I], KpiDeltas[I]);
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
  FOrdersCard := NewCard(FForm, True);
  FOrdersCard.OnAfterDraw := CardAfterDraw;
  FOrdersTitle := NewText(FOrdersCard, 'Recent orders', 16, True);
  for I := 0 to High(ChipNames) do
  begin
    FChips[I] := NewButton(FOrdersCard, ChipNames[I], 13, I = 0, {$IFDEF WEBLIB}@{$ENDIF}ChipClick);
    FChips[I].Tag := I;
    FChips[I].Appearance.Rounding := 14;
    FChips[I].Appearance.ShowInnerStroke := False;
  end;

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
  finally
    FGrid.EndUpdate;
  end;
  FGrid.OnGetCellLayout := GridGetCellLayout;
  FGrid.OnAfterDrawCell := GridAfterDrawCell;

  FOrdersCount := NewText(FOrdersCard, '', 12, False, True);
  FViewAll := NewText(FOrdersCard, '<a href="all">View all</a>', 12, True, False, gtaTrailing);
  FViewAll.URLUnderline := False;
  FViewAll.AutoOpenURL := False;
end;

procedure TDashboard.BuildProjects;
var
  I: Integer;
  parent, node: TTMSFNCTreeViewNode;
  col: TTMSFNCTreeViewColumn;
begin
  FProjectsCard := NewCard(FForm, True);
  FProjectsCard.OnAfterDraw := CardAfterDraw;
  FProjectsTitle := NewText(FProjectsCard, 'Projects', 16, True);
  FProjectsNote := NewText(FProjectsCard, 'TreeView' + Dot + 'checkable', 12, False, True, gtaTrailing);

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
  FTree.OnBeforeDrawNodeText := TreeBeforeDrawNodeText;
  FTree.OnGetNodeTextColor := TreeGetNodeTextColor;
  FTree.BeginUpdate;
  try
    FTree.ClearColumns;
    FTree.ClearNodes;
    col := FTree.Columns.Add;
    col.Text := 'Project';
    { Owner and Status get their widths in LayoutProjects }
    col := FTree.Columns.Add;
    col.Text := 'Owner';
    col := FTree.Columns.Add;
    col.Text := 'Status';
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
  FGoalsCard := NewCard(FForm, True);
  FGoalsTitle := NewText(FGoalsCard, 'Quarterly goals', 16, True);
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
  FPrefsCard := NewCard(FForm, True);
  FPrefsTitle := NewText(FPrefsCard, 'Report preferences', 16, True);

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
  { padding 0 20, gap 20: the panels draw their text 10 px in }
  p := FStatus.Panels.Add;
  p.Style := spsOwnerDraw;
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
  FStatus.OnDrawCustomPanel := StatusDrawPanel;
  UpdateStatusText;
end;

procedure TDashboard.UpdateStatusText;
var
  s: string;
begin
  s := TTMSFNCTheme.Current;
  if s = '' then
    s := 'none';
  if FStatus.Panels.Count > 0 then
    FStatus.Panels.Items[0].Text := s;
  if Assigned(FHeader) then
    Layout;
  FStatus.Invalidate;
end;

{ 'Theme: ' in secondary text and the theme's name in semibold text, 12 px, at 20 }
procedure TDashboard.StatusDrawPanel(Sender: TObject; AGraphics: TTMSFNCGraphics; ARect: TRectF; APanel: TTMSFNCStatusBarPanel);
var
  t: TTMSFNCResolvedTheme;
  x: Single;
begin
  if APanel.Index <> 0 then
    Exit;
  t := Theme;
  x := ARect.Left + S(21);
  SetFont(AGraphics.Font, 12, False);
  if Assigned(t) then
    AGraphics.Font.Color := t[ttTextSecondary];
  AGraphics.DrawText(RectF(x, ARect.Top, ARect.Right, ARect.Bottom), 'Theme: ', False, gtaLeading, gtaCenter);
  x := x + AGraphics.CalculateTextWidth('Theme: ');
  SetFont(AGraphics.Font, 12, True);
  if Assigned(t) then
    AGraphics.Font.Color := t[ttText];
  AGraphics.DrawText(RectF(x, ARect.Top, ARect.Right, ARect.Bottom), APanel.Text, False, gtaLeading, gtaCenter);
end;

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
      end
      else
      begin
        FGrid.Cells[0, row] := '';
        FGrid.Cells[1, row] := '';
        FGrid.Cells[2, row] := '';
        FGrid.Cells[3, row] := '';
      end;
      { status and fulfilment are drawn in GridAfterDrawCell }
      FGrid.Cells[4, row] := '';
      FGrid.Cells[5, row] := '';
    end;
  finally
    FGrid.EndUpdate;
  end;
  if Assigned(FOrdersCount) then
    FOrdersCount.Text := Format('%d of %d orders', [FVisibleOrders.Count, matches]);
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
  { from x -1: 'Theme: <name>' at 20, then 20 px to '30 orders' (its text 10 px into its panel); the
    right text ends 20 px before the edge (an 11 px panel after it, 10 px text padding) }
  sw := 1 + 20 + TextWidth('Theme: ', 12, False) + TextWidth(FStatus.Panels.Items[0].Text, 12, True) + 20 - 10;
  FStatus.Panels.Items[0].Width := Round(S(sw));
  FStatus.Panels.Items[1].Width := Round(S(TextWidth(FStatus.Panels.Items[1].Text, 12, False) + 20));
  FStatus.Panels.Items[3].Width := Round(S(TextWidth(FStatus.Panels.Items[3].Text, 12, False) + 20));
  FStatus.Panels.Items[4].Width := Round(S(11));
  FStatus.Panels.Items[2].Width := Max(10, Round(S(W + 2)) - FStatus.Panels.Items[0].Width - FStatus.Panels.Items[1].Width -
    FStatus.Panels.Items[3].Width - FStatus.Panels.Items[4].Width);
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
  I, act: Integer;
  widths: array[0..4] of Single;
  short: Boolean;

  function SwitcherWidth(AShort: Boolean): Single;
  var
    J: Integer;
    s: string;
  begin
    Result := 2 * 4 + 2 * High(FSegments);
    for J := 0 to High(FSegments) do
    begin
      if AShort then
        s := SegmentShortNames[J]
      else
        s := SegmentNames[J];
      widths[J] := TextWidth(s, 13, J = act) + 24;
      Result := Result + widths[J];
    end;
  end;

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
  x := x - 16 - (5 * 20 + 4 * 6);
  for I := 0 to High(FSwatches) do
    Place(FSwatches[I], x + I * 26, y + 17.5, 20, 20);

  x := x - 16 - 36;
  Place(FFollow, x, y + 17.5, 36, 20);
  fw := TextWidth(FFollowLabel.Text, 13, False);
  x := x - 8 - fw;
  Place(FFollowLabel, x, y + 17.5, fw + 6, 20);

  { the switcher: border 1, padding 3, buttons of 12 + text + 12, 2 apart; the full theme names,
    or the short ones when those do not fit between the app title and the follow switch }
  act := ActiveSegment;
  sw := SwitcherWidth(False);
  short := x - 16 - sw < titleRight + 16;
  if short then
    sw := SwitcherWidth(True);
  for I := 0 to High(FSegments) do
    if short and (FSegments[I].Text <> SegmentShortNames[I]) then
      FSegments[I].Text := SegmentShortNames[I]
    else if not short and (FSegments[I].Text <> SegmentNames[I]) then
      FSegments[I].Text := SegmentNames[I];
  x := x - 16 - sw;
  Place(FSwitcher, x, y + 9.5, sw, 36);
  x := 4;
  for I := 0 to High(FSegments) do
  begin
    Place(FSegments[I], x, 4, widths[I], 28);
    x := x + widths[I] + 2;
  end;
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
  x, cw, gw, rest: Single;
  I: Integer;
const
  { the table's column widths at the design width; Customer takes what is left }
  Fixed: array[0..5] of Single = (112.3, 0, 88.6, 112.8, 141.5, 150);
begin
  { header row: border 1, padding 14 18, the 32 px search field the tallest item }
  PlaceIn(FOrdersTitle, 19, 19, 240, 24);
  PlaceIn(FSearch, W - 19 - 200, 15, 200, 32);
  x := W - 19 - 200 - 12;
  for I := High(FChips) downto 0 do
  begin
    cw := TextWidth(ChipNames[I], 13, I = FFilter) + 26;
    x := x - cw;
    PlaceIn(FChips[I], x, 17, cw, 28);
    x := x - 6;
  end;
  { the table: a divider above the header (painted by the card), the header 36 + its divider, the
    rows 39 + their divider }
  gw := W - 2;
  PlaceIn(FGrid, 1, 62, gw, OrderHeaderH + OrderRows * OrderRowH);
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
  { footer: padding 10 18 }
  PlaceIn(FOrdersCount, 19, 62 + OrderHeaderH + OrderRows * OrderRowH + 10, 240, 20);
  PlaceIn(FViewAll, W - 19 - 120, 62 + OrderHeaderH + OrderRows * OrderRowH + 10, 120, 20);
end;

procedure TDashboard.LayoutProjects(W, H: Single);
begin
  { header: border 1, padding 14 18, title 24; a divider; rows of 35 + their divider }
  PlaceIn(FProjectsTitle, 19, 15, 240, 24);
  PlaceIn(FProjectsNote, W - 19 - 240, 17, 240, 20);
  PlaceIn(FTree, 1, 54, W - 2, H - 55);
  { Owner at 120 + 10 and Status at 110 + 18 from the right; the tree draws a cell's text 8 px in }
  FTree.Columns[1].Width := S(130);
  FTree.Columns[2].Width := S(136);
end;

procedure TDashboard.LayoutGoals(W: Single);
var
  I: Integer;
  y: Single;
begin
  { border 1, padding 16 18, gap 14: title 24, then per goal a 20 px row, gap 6 and an 8 px bar }
  PlaceIn(FGoalsTitle, 19, 17, W - 38, 24);
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
  { border 1, padding 16 18, gap 14 between the groups }
  colW := (W - 38 - 12) / 2;
  PlaceIn(FPrefsTitle, 19, 17, W - 38, 24);
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

procedure TDashboard.StyleButton(AButton: TTMSFNCToolBarButton; AFill, AStroke, AFont, AHover, ADown: TTMSFNCGraphicsColor);
begin
  AButton.Appearance.NormalFill.Kind := gfkSolid;
  AButton.Appearance.NormalFill.Color := AFill;
  AButton.Appearance.NormalStroke.Color := AStroke;
  AButton.Appearance.HoverFill.Kind := gfkSolid;
  AButton.Appearance.HoverFill.Color := AHover;
  AButton.Appearance.HoverStroke.Color := AStroke;
  AButton.Appearance.DownFill.Kind := gfkSolid;
  AButton.Appearance.DownFill.Color := ADown;
  AButton.Appearance.DownStroke.Color := AStroke;
  AButton.Font.Color := AFont;
  AButton.HoverFontColor := AFont;
  AButton.DownFontColor := AFont;
end;

procedure TDashboard.StatusColors(AKind: TStatusKind; out ABack, AFore: TTMSFNCGraphicsColor);
var
  t: TTMSFNCResolvedTheme;
  tone: TTMSFNCGraphicsColor;
begin
  t := Theme;
  if not Assigned(t) then
  begin
    ABack := gcSilver;
    AFore := gcBlack;
    Exit;
  end;
  if IsFluentTheme then
  begin
    { the tints of the FNC design }
    if t.Mode = tmDark then
    begin
      ABack := HexColor(DesignStatusDark[AKind, 0]);
      AFore := HexColor(DesignStatusDark[AKind, 1]);
    end
    else
    begin
      ABack := HexColor(DesignStatusLight[AKind, 0]);
      AFore := HexColor(DesignStatusLight[AKind, 1]);
    end;
    Exit;
  end;
  case AKind of
    skSuccess: tone := t[ttSuccess];
    skWarning: tone := t[ttWarning];
    skError: tone := t[ttError];
  else
    tone := t[ttAccent];
  end;
  case t.Mode of
    tmDark:
    begin
      ABack := Mix(t[ttSurface], tone, 0.24);
      if AKind = skInfo then
        AFore := t[ttAccentText]
      else
        AFore := Mix(tone, t[ttText], 0.2);
    end;
    tmHighContrast:
    begin
      { system colors only: the text color on the surface, with a border in the text color }
      ABack := t[ttSurface];
      AFore := t[ttText];
    end;
  else
    ABack := Mix(t[ttSurface], tone, 0.12);
    if AKind = skInfo then
      AFore := t[ttAccentText]
    else
      AFore := Mix(tone, t[ttText], 0.3);
  end;
end;

{ a status pill: 22 px, radius 11, padding 9, 12 px semibold; with a 6 px dot and a 6 px gap }
procedure TDashboard.DrawPill(AGraphics: TTMSFNCGraphics; const ARect: TRectF; const AText: string; AKind: TStatusKind;
  ADot: Boolean);
var
  back, fore: TTMSFNCGraphicsColor;
  w, cy, x: Single;
  r: TRectF;
  t: TTMSFNCResolvedTheme;
begin
  StatusColors(AKind, back, fore);
  SetFont(AGraphics.Font, 12, True);
  w := AGraphics.CalculateTextWidth(AText) + S(18);
  if ADot then
    w := w + S(12);
  cy := (ARect.Top + ARect.Bottom) / 2;
  r := RectF(ARect.Left, Round(cy - S(11)), Round(ARect.Left + w), Round(cy - S(11)) + Round(S(22)));
  AGraphics.Fill.Kind := gfkSolid;
  AGraphics.Fill.Color := back;
  t := Theme;
  if Assigned(t) and (t.Mode = tmHighContrast) then
  begin
    AGraphics.Stroke.Kind := gskSolid;
    AGraphics.Stroke.Color := fore;
  end
  else
    AGraphics.Stroke.Kind := gskNone;
  AGraphics.DrawRoundRectangle(r, S(11), [gcTopLeft, gcTopRight, gcBottomLeft, gcBottomRight], gcrmNone);
  x := r.Left + S(9);
  if ADot then
  begin
    AGraphics.Fill.Color := fore;
    AGraphics.Stroke.Kind := gskNone;
    AGraphics.DrawEllipse(RectF(x, r.Top + S(8), x + S(6), r.Top + S(14)), gcrmNone);
    x := x + S(12);
  end;
  AGraphics.Font.Color := fore;
  AGraphics.DrawText(RectF(x, r.Top, r.Right, r.Bottom), AText, False, gtaLeading, gtaCenter);
end;

procedure TDashboard.ThemeChanged;
var
  t: TTMSFNCResolvedTheme;
  I, act: Integer;
  txt: TTMSFNCHTMLText;
  back, fore, accent: TTMSFNCGraphicsColor;
  dark: Boolean;
  st: TTMSFNCGraphicsStroke;
begin
  FSeenVersion := TTMSFNCTheme.Version;
  t := Theme;
  UpdateStatusText;
  if not Assigned(t) then
    Exit;
  dark := t.Mode <> tmLight;
  accent := t[ttAccent];
  act := ActiveSegment;

  for txt in FSecondary do
    txt.Font.Color := t[ttTextSecondary];
  FViewAll.URLColor := t[ttAccentText];

  { app mark }
  FMark.Fill.Color := accent;
  FMark.Stroke.Color := accent;
  FMark.Invalidate;

  { segmented theme switcher: a track in SurfaceAlt, the active theme raised on Surface }
  FSwitcher.Fill.Color := t[ttSurfaceAlt];
  FSwitcher.Stroke.Color := t[ttDivider];
  for I := 0 to High(FSegments) do
  begin
    if I = act then
    begin
      StyleButton(FSegments[I], t[ttSurface], t[ttSurface], t[ttText], t[ttSurface], t[ttSurface]);
      SetFont(FSegments[I].Font, 13, True);
    end
    else
    begin
      StyleButton(FSegments[I], t[ttSurfaceAlt], t[ttSurfaceAlt], t[ttTextSecondary], t[ttHover], t[ttPressed]);
      SetFont(FSegments[I].Font, 13, False);
    end;
    FSegments[I].Font.Color := FSegments[I].HoverFontColor;
  end;

  { accent swatches: content colors; the active one gets a ring in the text color. High Contrast
    uses the system's colors only (the accent override does not apply): no swatches }
  for I := 0 to High(FSwatches) do
  begin
    FSwatches[I].Visible := t.Mode <> tmHighContrast;
    back := HexColor(AccentHex[I]);
    FSwatches[I].SwatchColor := back;
    FSwatches[I].RingColor := t[ttSurface];
    FSwatches[I].Fill.Color := t[ttSurface];
    if I = FAccentIndex then
      FSwatches[I].OuterColor := t[ttText]
    else
      FSwatches[I].OuterColor := back;
    FSwatches[I].Invalidate;
  end;

  { avatar: a tinted accent circle; High Contrast: the surface with a border and text in the text
    color }
  if t.Mode = tmHighContrast then
  begin
    back := t[ttSurface];
    fore := t[ttText];
  end
  else
  begin
    back := Mix(t[ttSurface], accent, IfThen(dark, 0.28, 0.14));
    fore := t[ttAccentText];
  end;
  FAvatar.Appearance.Fill.Color := back;
  FAvatar.Appearance.HoverFill.Color := back;
  if t.Mode = tmHighContrast then
  begin
    FAvatar.Appearance.Stroke.Color := fore;
    FAvatar.Appearance.HoverStroke.Color := fore;
  end
  else
  begin
    FAvatar.Appearance.Stroke.Color := back;
    FAvatar.Appearance.HoverStroke.Color := back;
  end;
  FAvatar.Appearance.Font.Color := fore;
  FAvatar.Appearance.HoverFont.Color := fore;

  { filter chips }
  for I := 0 to High(FChips) do
    if (I = FFilter) and (t.Mode = tmHighContrast) then
    begin
      { system colors only: the selection with its text, a border in the text color }
      StyleButton(FChips[I], t[ttSelection], t[ttText], SelectionTextColor(t), t[ttSelection], t[ttSelection]);
      SetFont(FChips[I].Font, 13, True);
      FChips[I].Font.Color := SelectionTextColor(t);
    end
    else if I = FFilter then
    begin
      StyleButton(FChips[I], t[ttSelection], accent, SelectionTextColor(t),
        Mix(t[ttSurface], accent, IfThen(dark, 0.28, 0.14)), Mix(t[ttSurface], accent, IfThen(dark, 0.34, 0.18)));
      SetFont(FChips[I].Font, 13, True);
      FChips[I].Font.Color := SelectionTextColor(t);
    end
    else
    begin
      StyleButton(FChips[I], t[ttSurface], t[ttBorder], t[ttText], t[ttHover], t[ttPressed]);
      SetFont(FChips[I].Font, 13, False);
      FChips[I].Font.Color := t[ttText];
    end;

  { KPI delta pills }
  for I := 0 to 3 do
  begin
    StatusColors(KpiKinds[I], back, fore);
    FKpiDeltas[I].Appearance.Fill.Color := back;
    FKpiDeltas[I].Appearance.HoverFill.Color := back;
    if t.Mode = tmHighContrast then
    begin
      FKpiDeltas[I].Appearance.Stroke.Color := fore;
      FKpiDeltas[I].Appearance.HoverStroke.Color := fore;
    end
    else
    begin
      FKpiDeltas[I].Appearance.Stroke.Color := back;
      FKpiDeltas[I].Appearance.HoverStroke.Color := back;
    end;
    FKpiDeltas[I].Appearance.Font.Color := fore;
    FKpiDeltas[I].Appearance.HoverFont.Color := fore;
  end;

  { the search icon in the button of the search box }
  {$IFDEF WEBLIB}
  FSearch.Bitmap.LoadFromURL(SvgDataURL(Svg(SearchIcon, t[ttTextTertiary], 16)));
  {$ELSE}
  FSearch.Bitmap.LoadFromSVG(Svg(SearchIcon, t[ttTextTertiary], 16));
  {$ENDIF}

  { the navigation lists are no cards: no border (a theme writes one; assigned as a whole, the
    list passes it on to its inner tree) }
  st := TTMSFNCGraphicsStroke.Create;
  try
    st.Kind := gskNone;
    FNav.Stroke := st;
    FNavBottom.Stroke := st;
  finally
    st.Free;
  end;
  { the layout depends on the active segment (semibold text is wider) }
  Layout;
  FHeader.Invalidate;
  FNav.Invalidate;
  FNavBottom.Invalidate;
  FGrid.Invalidate;
  FTree.Invalidate;
  FOrdersCard.Invalidate;
  FProjectsCard.Invalidate;
end;

procedure TDashboard.ApplyTheme(const AName: string);
begin
  if TTMSFNCTheme.FollowSystem then
    TTMSFNCTheme.SetFollowSystem(False);
  TTMSFNCTheme.Apply(AName);
  FUpdating := True;
  try
    if FFollow.State <> ssOff then
      FFollow.State := ssOff;
  finally
    FUpdating := False;
  end;
  ThemeChanged;
end;

{ ---------------------------------------------------------------- events }

procedure TDashboard.FormResize(Sender: TObject);
begin
  Layout;
end;

procedure TDashboard.TimerTick(Sender: TObject);
begin
  { a theme change that did not come from this UI (the OS switched to dark while following it) }
  if TTMSFNCTheme.Version <> FSeenVersion then
    ThemeChanged;
end;

{ the controls' Tag (on WEB a control declares a Tag of its own, next to the component's) }
procedure TDashboard.SegmentClick(Sender: TObject);
begin
  ApplyTheme(SegmentTheme((Sender as TControl).Tag));
end;

procedure TDashboard.FollowChange(Sender: TObject);
var
  cur: string;
begin
  { the switch reports appearance changes too (a theme writes its colors): act on a change of
    its state only }
  if FUpdating or ((FFollow.State = ssOn) = TTMSFNCTheme.FollowSystem) then
    Exit;
  if FFollow.State = ssOn then
  begin
    cur := TTMSFNCTheme.Current;
    { follow the OS within the current theme family }
    if StartsText('Microsoft 365', cur) then
      TTMSFNCTheme.SetFollowSystem(True, 'Microsoft 365 Light', 'Microsoft 365 Dark')
    else
      TTMSFNCTheme.SetFollowSystem(True);
  end
  else
    TTMSFNCTheme.SetFollowSystem(False);
  ThemeChanged;
end;

procedure TDashboard.SwatchClick(Sender: TObject);
begin
  { SetAccent replaces the accent of every theme (also after a theme switch) and re-themes the app;
    gcNull removes the override, every theme then uses its own accent again }
  FAccentIndex := (Sender as TControl).Tag;
  if FAccentIndex = 0 then
    TTMSFNCTheme.SetAccent(gcNull)
  else
    TTMSFNCTheme.SetAccent(HexColor(AccentHex[FAccentIndex]));
  ThemeChanged;
end;

procedure TDashboard.ChipClick(Sender: TObject);
begin
  FFilter := (Sender as TControl).Tag;
  FillGrid;
  ThemeChanged;
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
  FNav.Invalidate;
  FNavBottom.Invalidate;
end;

{ A navigation item: a 36 px pill (radius 6) in the 38 px item, the selected one tinted with the
  selection color; an 18 px icon at 10 and the text at 38 in the item's text color, the selected
  one semibold in the accent text color; 'Orders' with a count badge. }
procedure TDashboard.DrawNavItem(AList: TTMSFNCListBox; AGraphics: TTMSFNCGraphics; ARect: TRectF; AItem: TTMSFNCListBoxItem);
var
  t: TTMSFNCResolvedTheme;
  r, ir, br: TRectF;
  sel: Boolean;
  c: TTMSFNCGraphicsColor;
  bmp: TTMSFNCBitmap;
begin
  t := Theme;
  if not Assigned(t) then
    Exit;
  sel := AItem.Tag = FNavIndex;
  { the item's own band of the list, in whole pixels (the item rectangle the list passes differs a
    pixel between the frameworks): 1 px above and below the 36 px pill }
  r := RectF(0, Round(AItem.Index * S(NavRowH + NavGap) + S(NavGap / 2)), Round(AList.Width),
    Round((AItem.Index + 1) * S(NavRowH + NavGap) - S(NavGap / 2)));
  if sel then
  begin
    AGraphics.Fill.Kind := gfkSolid;
    AGraphics.Fill.Color := t[ttSelection];
    AGraphics.Stroke.Kind := gskNone;
    AGraphics.DrawRoundRectangle(r, S(6), [gcTopLeft, gcTopRight, gcBottomLeft, gcBottomRight], gcrmNone);
    c := SelectionTextColor(t);
  end
  else if AItem.Tag = 5 then
    c := t[ttTextSecondary]
  else
    c := t[ttText];
  { the icon }
  ir := RectF(r.Left + S(10), Round((r.Top + r.Bottom) / 2 - S(9)), r.Left + S(28), Round((r.Top + r.Bottom) / 2 - S(9)) + S(18));
  {$IFDEF WEBLIB}
  bmp := IconBitmap(Svg(NavIcons[AItem.Tag], c));
  if Assigned(bmp) then
    AGraphics.DrawBitmap(ir, bmp);
  {$ELSE}
  bmp := TTMSFNCBitmap.Create;
  try
    bmp.LoadFromSVG(Svg(NavIcons[AItem.Tag], c));
    AGraphics.DrawBitmap(ir, bmp);
  finally
    bmp.Free;
  end;
  {$ENDIF}
  { the text }
  SetFont(AGraphics.Font, 14, sel);
  AGraphics.Font.Color := c;
  AGraphics.DrawText(RectF(r.Left + S(38), r.Top, r.Right - S(10), r.Bottom), AItem.Text, False, gtaLeading, gtaCenter);
  { the count of open orders next to 'Orders': 20 px, padding 6, 12 px semibold }
  if (AList = FNav) and (AItem.Tag = 1) then
  begin
    SetFont(AGraphics.Font, 12, True);
    br := RectF(0, 0, Max(S(22), AGraphics.CalculateTextWidth('14') + S(12)), S(20));
    br := RectF(r.Right - S(10) - br.Right, Round((r.Top + r.Bottom) / 2 - S(10)), r.Right - S(10),
      Round((r.Top + r.Bottom) / 2 - S(10)) + S(20));
    AGraphics.Fill.Kind := gfkSolid;
    AGraphics.Fill.Color := t[ttAccent];
    AGraphics.Stroke.Kind := gskNone;
    AGraphics.DrawRoundRectangle(br, S(10), [gcTopLeft, gcTopRight, gcBottomLeft, gcBottomRight], gcrmNone);
    AGraphics.Font.Color := t[ttTextOnAccent];
    AGraphics.DrawText(br, '14', False, gtaCenter, gtaCenter);
  end;
end;

procedure TDashboard.NavBeforeDrawItem(Sender: TObject; AGraphics: TTMSFNCGraphics; ARect: TRectF; AItem: TTMSFNCListBoxItem;
  var AAllow: Boolean; var ADefaultDraw: Boolean);
begin
  ADefaultDraw := False;
  if Assigned(AItem) then
    DrawNavItem(Sender as TTMSFNCListBox, AGraphics, ARect, AItem);
end;

procedure TDashboard.NavBeforeDrawItemText(Sender: TObject; AGraphics: TTMSFNCGraphics; ARect: TRectF; AItem: TTMSFNCListBoxItem;
  AText: String; var AAllow: Boolean);
begin
  { the text is part of the item drawn in NavBeforeDrawItem }
  AAllow := False;
end;

procedure TDashboard.RegionSelected(Sender: TObject; AText: string; AItemIndex: Integer);
begin
  FPageSub.Text := 'Week 42' + Dot + AText;
end;

procedure TDashboard.DetailChanged(Sender: TObject; AValue: Single);
begin
  FDetailPct.Text := IntToStr(Round(AValue)) + '%';
end;

procedure TDashboard.MarkAfterDraw(Sender: TObject; AGraphics: TTMSFNCGraphics; ARect: TRectF);
var
  t: TTMSFNCResolvedTheme;
  x, y: Single;

  procedure Tile(L, T: Single);
  begin
    AGraphics.DrawRoundRectangle(RectF(x + S(L), y + S(T), x + S(L + 4.5), y + S(T + 4.5)), S(1),
      [gcTopLeft, gcTopRight, gcBottomLeft, gcBottomRight], gcrmNone);
  end;

begin
  t := Theme;
  if not Assigned(t) then
    Exit;
  { the design's 16 px icon in the middle of the 28 px mark: four 4.5 px tiles, stroke 1.6 }
  x := ARect.Left + S(6);
  y := ARect.Top + S(6);
  AGraphics.Fill.Kind := gfkNone;
  AGraphics.Stroke.Kind := gskSolid;
  AGraphics.Stroke.Color := t[ttTextOnAccent];
  AGraphics.Stroke.Width := S(1.6);
  Tile(2.5, 2.5);
  Tile(9, 2.5);
  Tile(2.5, 9);
  Tile(9, 9);
  AGraphics.Stroke.Width := 1;
end;

{ the divider above a card's table or list (the header row's bottom border) }
procedure TDashboard.CardAfterDraw(Sender: TObject; AGraphics: TTMSFNCGraphics; ARect: TRectF);
var
  t: TTMSFNCResolvedTheme;
  y: Single;
  r: TRectF;
begin
  t := Theme;
  if not Assigned(t) then
    Exit;
  if Sender = FOrdersCard then
    y := 61
  else
    y := 53;
  r := (Sender as TTMSFNCPanel).ShadowMargins;
  r := RectF(ARect.Left + r.Left, ARect.Top + r.Top, ARect.Right - r.Right, ARect.Bottom - r.Bottom);
  AGraphics.Stroke.Kind := gskSolid;
  AGraphics.Stroke.Color := t[ttDivider];
  AGraphics.Stroke.Width := Max(1, Round(S(1)));
  AGraphics.DrawLine(PointF(r.Left + S(1), r.Top + Round(S(y))), PointF(r.Right - S(1), r.Top + Round(S(y))));
  AGraphics.Stroke.Width := 1;
end;

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

procedure TDashboard.GridAfterDrawCell(Sender: TObject; AGraphics: TTMSFNCGraphics; ACell: TTMSFNCDataGridCell);
var
  t: TTMSFNCResolvedTheme;
  o: TOrder;
  r, bar: TRectF;
  cy, w: Single;
begin
  if (ACell.Row < 1) or (ACell.Row - 1 >= FVisibleOrders.Count) or (ACell.Column < 4) then
    Exit;
  t := Theme;
  if not Assigned(t) then
    Exit;
  o := FOrders[FVisibleOrders[ACell.Row - 1]];
  r := ACell.Rect;
  { the row's own height without its divider }
  r.Bottom := r.Bottom - S(1);
  if ACell.Column = 4 then
    DrawPill(AGraphics, RectF(r.Left + S(12), r.Top, r.Right - S(4), r.Bottom), o.Status, StatusKindOf(o.Status), True)
  else
  begin
    { fulfilment: a 6 px bar on a track (radius 3), 8 px gap, the percentage in 34 px }
    cy := Round((r.Top + r.Bottom) / 2 - S(3));
    bar := RectF(r.Left + S(12), cy, r.Right - 1 - S(18 + 34 + 8), cy + S(6));
    AGraphics.Stroke.Kind := gskNone;
    AGraphics.Fill.Kind := gfkSolid;
    AGraphics.Fill.Color := TrackColor(t);
    AGraphics.DrawRoundRectangle(bar, S(3), [gcTopLeft, gcTopRight, gcBottomLeft, gcBottomRight], gcrmNone);
    w := (bar.Right - bar.Left) * o.Pct / 100;
    if w > 0 then
    begin
      AGraphics.Fill.Color := t[ttAccent];
      AGraphics.DrawRoundRectangle(RectF(bar.Left, bar.Top, bar.Left + Max(w, S(6)), bar.Bottom), S(3), [gcTopLeft, gcTopRight, gcBottomLeft, gcBottomRight], gcrmNone);
    end;
    SetFont(AGraphics.Font, 12, False);
    AGraphics.Font.Color := t[ttTextSecondary];
    AGraphics.DrawText(RectF(r.Right - 1 - S(18 + 34), r.Top, r.Right - 1 - S(18), r.Bottom), IntToStr(o.Pct) + '%', False,
      gtaTrailing, gtaCenter);
  end;
end;

procedure TDashboard.TreeBeforeDrawNodeText(Sender: TObject; AGraphics: TTMSFNCGraphics; ARect: TRectF; AColumn: Integer;
  ANode: TTMSFNCTreeViewVirtualNode; AText: String; var AAllow: Boolean);
begin
  if AColumn = 2 then
  begin
    AAllow := False;
    DrawPill(AGraphics, ARect, AText, StatusKindOf(AText), False);
  end
  else
    SetFont(AGraphics.Font, 13, (AColumn = 0) and Assigned(ANode) and (ANode.Level = 0));
end;

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
