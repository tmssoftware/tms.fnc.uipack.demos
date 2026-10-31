unit UFNCUITreeView;

{ TMS FNC UI Pack - TreeView template

  A starting point for an FMX application (Windows, macOS, iOS, Android) built around a themed
  TTMSFNCTreeView. Copy the project, rename the form and replace the sample nodes with your own.

  Theme
    ThemeManager (Theme = 'Fluent Light', Scope = tsApplication) themes every FNC control of the
    application: tree, columns, header. DemoThemeSelector switches between Light and Dark; its
    "Follow system" switch makes the application follow the light/dark setting of the operating
    system (TTMSFNCTheme.SetFollowSystem(True) does the same in code).
    ThemeManager.Theme = '' gives the classic FNC look of earlier versions.

  Brand it
    - ThemeManager.Accent: your accent color on top of the theme.
    - ThemeManager.Brand (stored in the form) or ThemeManager.BrandFile := 'mybrand.fncbrand' (a
      .fncbrand file loaded at run time; a relative name is next to the executable): your own Light
      and Dark themes, used following ThemeManager.BrandMode (default: follow the system).
    - ThemeManager.TitleBar := tbTheme (or tbBrand): the window title bar in the theme's colors.
    - DemoTitle / DemoDescription: your application's name and a one-line description.
    Do not set colors or font names on the controls in the Object Inspector: such a value is yours
    and survives every theme switch. Custom drawing takes its colors from the theme (ThemeColors
    below), so it follows Light, Dark, the accent and the brand.

  Data
    The nodes are stored in the form (Values: name, size in MB, type, lock column; Tag 1 = locked).
    For a database, link the TreeViewAdapter on this form:
      TreeViewAdapter.DataSource := <your TDataSource>;
      TreeViewAdapter.Columns: the fields shown per column (or AutoCreateColumns);
      TreeViewAdapter.Levels: master/detail datasets for the levels of the tree (KeyField,
        MasterKeyField);
      TMSFNCTreeView1.Adapter := TreeViewAdapter;
      <your dataset>.Active := True; }

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, System.Math,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCBitmapContainer, FMX.TMSFNCCustomControl,
  FMX.TMSFNCTreeViewBase, FMX.TMSFNCTreeViewData, FMX.TMSFNCCustomTreeView,
  FMX.TMSFNCTreeView, FMX.TMSFNCTreeViewDatabaseAdapter,
  FMX.TMSFNCHTMLText, FMX.TMSFNCPanel, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector;

type
  TForm1 = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TTMSFNCPanel;
    DemoTitle: TTMSFNCHTMLText;
    DemoDescription: TTMSFNCHTMLText;
    DemoThemeSelector: TTMSFNCThemeSelector;
    TMSFNCTreeView1: TTMSFNCTreeView;
    TMSFNCBitmapContainer2: TTMSFNCBitmapContainer;
    TreeViewAdapter: TTMSFNCTreeViewDatabaseAdapter;
    procedure TMSFNCTreeView1BeforeDrawNode(Sender: TObject;
      AGraphics: TTMSFNCGraphics; ARect: TRectF;
      ANode: TTMSFNCTreeViewVirtualNode; var AAllow, ADefaultDraw: Boolean);
    procedure TMSFNCTreeView1GetNodeIcon(Sender: TObject;
      ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer; ALarge: Boolean;
      var AIcon: TTMSFNCBitmap);
    procedure TMSFNCTreeView1GetNodeIconSize(Sender: TObject;
      ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer; ALarge: Boolean;
      AIcon: TTMSFNCBitmap; var AIconWidth, AIconHeight: Double);
    procedure TMSFNCTreeView1GetNodeTextColor(Sender: TObject;
      ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer;
      var ATextColor: TTMSFNCGraphicsColor);
    procedure TMSFNCTreeView1BeforeDrawNodeText(Sender: TObject;
      AGraphics: TTMSFNCGraphics; ARect: TRectF; AColumn: Integer;
      ANode: TTMSFNCTreeViewVirtualNode; AText: string; var AAllow: Boolean);
    procedure TMSFNCTreeView1BeforeDrawNodeExpand(Sender: TObject;
      AGraphics: TTMSFNCGraphics; ARect: TRectF; AColumn: Integer;
      ANode: TTMSFNCTreeViewVirtualNode; AExpand: TTMSFNCBitmap;
      var AAllow: Boolean);
  private
    function ThemeColors: TTMSFNCResolvedTheme;
    function OnSelectedPath(ANode: TTMSFNCTreeViewVirtualNode): Boolean;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

const
  { the columns: name, size (MB, drawn as a bar), type, lock icon }
  ColName = 0;
  ColSize = 1;
  ColType = 2;
  ColLock = 3;
  CardSize = 8000; // MB

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

{ the selected node or one of its parents }
function TForm1.OnSelectedPath(ANode: TTMSFNCTreeViewVirtualNode): Boolean;
var
  n: TTMSFNCTreeViewVirtualNode;
begin
  n := TMSFNCTreeView1.SelectedVirtualNode;
  while Assigned(n) do
  begin
    if n = ANode then
      Exit(True);
    n := n.GetParent;
  end;
  Result := False;
end;

{ the selected node: the theme's selection color with an accent bar on the left }
procedure TForm1.TMSFNCTreeView1BeforeDrawNode(Sender: TObject;
  AGraphics: TTMSFNCGraphics; ARect: TRectF; ANode: TTMSFNCTreeViewVirtualNode;
  var AAllow, ADefaultDraw: Boolean);
var
  t: TTMSFNCResolvedTheme;
  r: TRectF;
begin
  if not TMSFNCTreeView1.IsVirtualNodeSelected(ANode) then
    Exit;
  ADefaultDraw := False;
  t := ThemeColors;
  r := ARect;
  AGraphics.Stroke.Kind := gskNone;
  AGraphics.Fill.Kind := gfkSolid;
  AGraphics.Fill.Color := t[ttSelection];
  AGraphics.DrawRectangle(r);
  r.Right := r.Left + 3;
  AGraphics.Fill.Color := t[ttAccent];
  AGraphics.DrawRoundRectangle(r, 1.5);
end;

{ a chevron in the theme's secondary text color, in the accent on the path to the selected node }
procedure TForm1.TMSFNCTreeView1BeforeDrawNodeExpand(Sender: TObject; AGraphics: TTMSFNCGraphics;
  ARect: TRectF; AColumn: Integer; ANode: TTMSFNCTreeViewVirtualNode; AExpand: TTMSFNCBitmap;
  var AAllow: Boolean);
var
  t: TTMSFNCResolvedTheme;
  c: TPointF;
  s: Single;
begin
  AAllow := False;
  t := ThemeColors;
  c := ARect.CenterPoint;
  s := Min(ARect.Width, ARect.Height) / 4;
  AGraphics.Stroke.Kind := gskSolid;
  AGraphics.Stroke.Width := 1.5;
  if OnSelectedPath(ANode) then
    AGraphics.Stroke.Color := t[ttAccent]
  else
    AGraphics.Stroke.Color := t[ttTextSecondary];
  if ANode.Expanded then
  begin
    AGraphics.DrawLine(PointF(c.X - s, c.Y - s / 2), PointF(c.X, c.Y + s / 2));
    AGraphics.DrawLine(PointF(c.X, c.Y + s / 2), PointF(c.X + s, c.Y - s / 2));
  end
  else
  begin
    AGraphics.DrawLine(PointF(c.X - s / 2, c.Y - s), PointF(c.X + s / 2, c.Y));
    AGraphics.DrawLine(PointF(c.X + s / 2, c.Y), PointF(c.X - s / 2, c.Y + s));
  end;
end;

{ the size column: a bar on the theme's track, the accent for files and folders, the warning color
  for the card itself; an expanded folder shows its contents instead }
procedure TForm1.TMSFNCTreeView1BeforeDrawNodeText(Sender: TObject; AGraphics: TTMSFNCGraphics;
  ARect: TRectF; AColumn: Integer; ANode: TTMSFNCTreeViewVirtualNode; AText: string; var AAllow: Boolean);
var
  t: TTMSFNCResolvedTheme;
  v: Integer;
  r: TRectF;
  kind: string;
begin
  if AColumn <> ColSize then
    Exit;
  AAllow := False;
  v := StrToIntDef(AText, 0);
  kind := UpperCase(ANode.Node.Values[ColType].Text);
  if (v <= 0) or ((kind = 'FOLDER') and ANode.Expanded) then
    Exit;

  t := ThemeColors;
  r := ARect;
  InflateRectEx(r, -6, 0);
  r.Top := Int(r.CenterPoint.Y) - 3;
  r.Bottom := r.Top + 6;
  AGraphics.Stroke.Kind := gskNone;
  AGraphics.Fill.Kind := gfkSolid;
  AGraphics.Fill.Color := t[ttTrack];
  AGraphics.DrawRoundRectangle(r, 3);
  r.Right := r.Left + Max(6, r.Width * v / CardSize);
  if kind = 'SD-CARD' then
    AGraphics.Fill.Color := t[ttWarning]
  else
    AGraphics.Fill.Color := t[ttAccent];
  AGraphics.DrawRoundRectangle(r, 3);
end;

{ the type column in the theme's secondary text color (also when selected) }
procedure TForm1.TMSFNCTreeView1GetNodeTextColor(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode;
  AColumn: Integer; var ATextColor: TTMSFNCGraphicsColor);
begin
  if AColumn = ColType then
    ATextColor := ThemeColors.Colors[ttTextSecondary];
end;

procedure TForm1.TMSFNCTreeView1GetNodeIcon(Sender: TObject;
  ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer; ALarge: Boolean;
  var AIcon: TTMSFNCBitmap);
var
  kind: string;
begin
  case AColumn of
    ColName:
    begin
      kind := UpperCase(ANode.Node.Values[ColType].Text);
      if kind = 'SD-CARD' then
        AIcon := TMSFNCBitmapContainer2.FindBitmap('Card.svg')
      else if kind = 'FOLDER' then
        AIcon := TMSFNCBitmapContainer2.FindBitmap('Folder.svg')
      else
        AIcon := TMSFNCBitmapContainer2.FindBitmap('New.svg');
    end;
    ColLock:
      if ANode.Node.Tag > 0 then
        AIcon := TMSFNCBitmapContainer2.FindBitmap('Lock.svg');
  end;
end;

procedure TForm1.TMSFNCTreeView1GetNodeIconSize(Sender: TObject;
  ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer; ALarge: Boolean;
  AIcon: TTMSFNCBitmap; var AIconWidth, AIconHeight: Double);
begin
  case AColumn of
    ColName:
    begin
      AIconWidth := 16;
      AIconHeight := 16;
    end;
    ColLock:
    begin
      AIconWidth := 18;
      AIconHeight := 18;
    end;
  end;
end;

end.
