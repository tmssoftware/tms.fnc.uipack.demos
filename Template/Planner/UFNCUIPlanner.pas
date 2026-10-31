unit UFNCUIPlanner;

{ TMS FNC UI Pack - Planner template

  A starting point for an FMX application (Windows, macOS, iOS, Android) built around a themed
  TTMSFNCPlanner. Copy the project, rename the form and replace the sample items with your own.

  Theme
    ThemeManager (Theme = 'Fluent Light', Scope = tsApplication) themes every FNC control of the
    application: planner grid, time line, resources, header. DemoThemeSelector switches between
    Light and Dark; its "Follow system" switch makes the application follow the light/dark setting
    of the operating system (TTMSFNCTheme.SetFollowSystem(True) does the same in code).
    ThemeManager.Theme = '' gives the classic FNC look of earlier versions.

  Brand it
    - ThemeManager.Accent: your accent color on top of the theme.
    - ThemeManager.Brand (stored in the form) or ThemeManager.BrandFile := 'mybrand.fncbrand' (a
      .fncbrand file loaded at run time; a relative name is next to the executable): your own Light
      and Dark themes, used following ThemeManager.BrandMode (default: follow the system).
    - ThemeManager.TitleBar := tbTheme (or tbBrand): the window title bar in the theme's colors.
    - DemoTitle / DemoDescription: your application's name and a one-line description.
    Do not set colors or font names on the controls in the Object Inspector: such a value is yours
    and survives every theme switch. The one exception here is Items[].Color: the category of a
    meeting, drawn as a tint and a bar on the theme's surface (BeforeDrawItem), so it stays readable
    in Light and Dark. Item texts take the theme's text colors.

  Data
    The items are stored in the form and moved to the current working day at start-up (FormCreate). For a
    database, link the PlannerAdapter on this form:
      PlannerAdapter.Item.DataSource := <your TDataSource>;
      PlannerAdapter.Item.DBKey := '<key field>'; (and .StartTime, .EndTime, .Title, .Text and
        .Resource: the fields of an item)
      TMSFNCPlanner1.Adapter := PlannerAdapter;
      <your dataset>.Active := True;
    Moving, resizing and editing an item then updates its record. }

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCCustomControl, FMX.TMSFNCPlannerBase, FMX.TMSFNCPlannerData,
  FMX.TMSFNCPlanner, FMX.TMSFNCCustomComponent, FMX.TMSFNCBitmapContainer,
  FMX.TMSFNCPlannerDatabaseAdapter,
  FMX.TMSFNCHTMLText, FMX.TMSFNCPanel, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector;

type
  TForm1 = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TTMSFNCPanel;
    DemoTitle: TTMSFNCHTMLText;
    DemoDescription: TTMSFNCHTMLText;
    DemoThemeSelector: TTMSFNCThemeSelector;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    TMSFNCPlanner1: TTMSFNCPlanner;
    PlannerAdapter: TTMSFNCPlannerDatabaseAdapter;
    procedure FormCreate(Sender: TObject);
    procedure TMSFNCPlanner1BeforeDrawItem(Sender: TObject;
      AGraphics: TTMSFNCGraphics; ARect: TRectF; AItem: TTMSFNCPlannerItem;
      var AAllow, ADefaultDraw: Boolean);
    procedure TMSFNCPlanner1BeforeDrawItemTitleText(Sender: TObject;
      AGraphics: TTMSFNCGraphics; ARect: TRectF; AItem: TTMSFNCPlannerItem;
      ATitle: string; var AAllow: Boolean);
    procedure TMSFNCPlanner1BeforeDrawItemText(Sender: TObject;
      AGraphics: TTMSFNCGraphics; ARect: TRectF; AItem: TTMSFNCPlannerItem;
      AText: string; var AAllow: Boolean);
  private
    function ThemeColors: TTMSFNCResolvedTheme;
    function IsSelected(AItem: TTMSFNCPlannerItem): Boolean;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

{ the sample items were planned for the day TimeLine.ViewStart: move them to today, or to Monday
  on a weekend }
procedure TForm1.FormCreate(Sender: TObject);
var
  day: TDateTime;
  d: Double;
  I: Integer;
begin
  day := Date;
  while DayOfWeek(day) in [1, 7] do
    day := day + 1;
  d := Int(day) - Int(TMSFNCPlanner1.TimeLine.ViewStart);
  TMSFNCPlanner1.BeginUpdate;
  try
    for I := 0 to TMSFNCPlanner1.Items.Count - 1 do
    begin
      TMSFNCPlanner1.Items[I].EndTime := TMSFNCPlanner1.Items[I].EndTime + d;
      TMSFNCPlanner1.Items[I].StartTime := TMSFNCPlanner1.Items[I].StartTime + d;
    end;
    TMSFNCPlanner1.ModeSettings.EndTime := TMSFNCPlanner1.ModeSettings.EndTime + d;
    TMSFNCPlanner1.ModeSettings.StartTime := TMSFNCPlanner1.ModeSettings.StartTime + d;
    TMSFNCPlanner1.TimeLine.ViewStart := TMSFNCPlanner1.TimeLine.ViewStart + d;
  finally
    TMSFNCPlanner1.EndUpdate;
  end;
end;

{ the colors of the theme in effect (Light, Dark, a brand, with the accent applied); without a
  theme the light colors, which match the classic look }
function TForm1.ThemeColors: TTMSFNCResolvedTheme;
var
  n: string;
begin
  n := TTMSFNCTheme.EffectiveThemeName(Self);
  Result := nil;
  if n <> '' then
    Result := TTMSFNCTheme.Resolve(n);
  if not Assigned(Result) then
    Result := TTMSFNCTheme.Resolve('Fluent Light');
end;

function TForm1.IsSelected(AItem: TTMSFNCPlannerItem): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to TMSFNCPlanner1.SelectedItems.Count - 1 do
    if TMSFNCPlanner1.SelectedItems[I].Index = AItem.Index then
      Exit(True);
end;

{ ACategory mixed into ABase: AAmount 0 gives ABase, 1 ACategory }
function Mix(ACategory, ABase: TTMSFNCGraphicsColor; AAmount: Single): TTMSFNCGraphicsColor;
var
  c, b, r: TAlphaColorRec;
begin
  c.Color := ACategory;
  b.Color := ABase;
  r.A := 255;
  r.R := Round(b.R + (c.R - b.R) * AAmount);
  r.G := Round(b.G + (c.G - b.G) * AAmount);
  r.B := Round(b.B + (c.B - b.B) * AAmount);
  Result := r.Color;
end;

{ an item: a tint of its category color on the theme's surface, a bar in the category color and,
  when selected, the accent as border }
procedure TForm1.TMSFNCPlanner1BeforeDrawItem(Sender: TObject;
  AGraphics: TTMSFNCGraphics; ARect: TRectF; AItem: TTMSFNCPlannerItem;
  var AAllow, ADefaultDraw: Boolean);
var
  t: TTMSFNCResolvedTheme;
  r: TRectF;
  rad: Single;
begin
  ADefaultDraw := False;
  t := ThemeColors;
  rad := t.Metrics[tmxRadiusControl];

  r := ARect;
  InflateRectEx(r, -1, -1);
  AGraphics.Fill.Kind := gfkSolid;
  if t.Mode = tmDark then
    AGraphics.Fill.Color := Mix(AItem.Color, t[ttSurface], 0.28)
  else
    AGraphics.Fill.Color := Mix(AItem.Color, t[ttSurface], 0.18);
  if IsSelected(AItem) then
  begin
    AGraphics.Stroke.Kind := gskSolid;
    AGraphics.Stroke.Color := t[ttAccent];
    AGraphics.Stroke.Width := 2;
  end
  else
    AGraphics.Stroke.Kind := gskNone;
  AGraphics.DrawRoundRectangle(r, rad);

  r.Right := r.Left + 4;
  AGraphics.Stroke.Kind := gskNone;
  AGraphics.Fill.Color := AItem.Color;
  AGraphics.DrawRoundRectangle(r, rad, [gcTopLeft, gcBottomLeft]);
end;

procedure TForm1.TMSFNCPlanner1BeforeDrawItemTitleText(Sender: TObject;
  AGraphics: TTMSFNCGraphics; ARect: TRectF; AItem: TTMSFNCPlannerItem;
  ATitle: string; var AAllow: Boolean);
var
  r: TRectF;
begin
  AAllow := False;
  r := ARect;
  r.Left := r.Left + 10;
  AGraphics.Font.Color := ThemeColors.Colors[ttText];
  AGraphics.DrawText(r, ATitle, False, gtaLeading, gtaTrailing);
end;

procedure TForm1.TMSFNCPlanner1BeforeDrawItemText(Sender: TObject;
  AGraphics: TTMSFNCGraphics; ARect: TRectF; AItem: TTMSFNCPlannerItem;
  AText: string; var AAllow: Boolean);
var
  r: TRectF;
begin
  AAllow := False;
  r := ARect;
  r.Left := r.Left + 10;
  AGraphics.Font.Color := ThemeColors.Colors[ttTextSecondary];
  AGraphics.DrawText(r, AText, True, AItem.TextHorizontalTextAlign, gtaCenter);
end;

end.
