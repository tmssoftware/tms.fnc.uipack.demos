unit UFNCUIGrid;

{ TMS FNC UI Pack - Data Grid template

  A starting point for an FMX application (Windows, macOS, iOS, Android) built around a themed
  TTMSFNCDataGrid. Copy the project, rename the form and replace the sample data with your own.

  Theme
    ThemeManager (Theme = 'Fluent Light', Scope = tsApplication) themes every FNC control of the
    application: grid, header, panels, buttons. DemoThemeSelector switches between Light and Dark;
    its "Follow system" switch makes the application follow the light/dark setting of the
    operating system (TTMSFNCTheme.SetFollowSystem(True) does the same in code).
    ThemeManager.Theme = '' gives the classic FNC look of earlier versions.

  Brand it
    - ThemeManager.Accent: your accent color on top of the theme.
    - ThemeManager.Brand (stored in the form) or ThemeManager.BrandFile := 'mybrand.fncbrand' (a
      .fncbrand file loaded at run time; a relative name is next to the executable): your own Light
      and Dark themes, used following ThemeManager.BrandMode (default: follow the system).
    - ThemeManager.TitleBar := tbTheme (or tbBrand): the window title bar in the theme's colors.
    - DemoTitle / DemoDescription: your application's name and a one-line description.
    Do not set colors or font names on the controls in the Object Inspector: such a value is yours
    and survives every theme switch (white panels in Dark). Custom drawing takes its colors from the
    theme (ThemeColors below), so it follows Light, Dark, the accent and the brand.

  Data
    The sample loads grid.csv (FormCreate). For a database, link the DataGridAdapter on this form:
      DataGridAdapter.DataSource := <your TDataSource>;   (TDataSource.DataSet: your query or table)
      TMSFNCDataGrid1.Adapter := DataGridAdapter;
      <your dataset>.Active := True;
    The adapter creates a column per field (or set DataGridAdapter.Columns), and the custom drawing
    below works the same on database data: adapt the column constants to your fields. }

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, System.IOUtils, System.Math,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCDataGridCell, FMX.TMSFNCCustomComponent,
  FMX.TMSFNCBitmapContainer, FMX.TMSFNCCustomControl,
  FMX.TMSFNCCustomScrollControl, FMX.TMSFNCDataGridData, FMX.TMSFNCCustomGrid,
  FMX.TMSFNCDataGrid, System.Rtti, FMX.TMSFNCDataGridBase,
  FMX.TMSFNCDataGridCore, FMX.TMSFNCDataGridRenderer, FMX.TMSFNCDataGridDatabaseAdapter,
  FMX.TMSFNCHTMLText, FMX.TMSFNCPanel, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector, FMX.TMSFNCSampleData;

type
  TForm1 = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TTMSFNCPanel;
    DemoTitle: TTMSFNCHTMLText;
    DemoDescription: TTMSFNCHTMLText;
    DemoThemeSelector: TTMSFNCThemeSelector;
    TMSFNCDataGrid1: TTMSFNCDataGrid;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    DataGridAdapter: TTMSFNCDataGridDatabaseAdapter;
    procedure FormCreate(Sender: TObject);
    procedure TMSFNCDataGrid1AfterDrawCell(Sender: TObject;
      AGraphics: TTMSFNCGraphics; ACell: TTMSFNCDataGridCell);
    procedure TMSFNCDataGrid1BeforeDrawCell(Sender: TObject;
      AGraphics: TTMSFNCGraphics; ACell: TTMSFNCDataGridCell;
      var ACanDraw: Boolean);
  private
    function ThemeColors: TTMSFNCResolvedTheme;
    procedure LoadSampleData;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

const
  { the columns drawn in code (grid.csv: Employee ID; Name; Joined; Status; Progress; Target) }
  ColStatus = 3;
  ColProgress = 4;
  ColTarget = 5;

procedure TForm1.FormCreate(Sender: TObject);
begin
  LoadSampleData;
end;

{ grid.csv next to the executable (deployed), else in the project folder (run from the IDE) }
procedure TForm1.LoadSampleData;
var
  dir, f: string;
begin
  dir := ExtractFilePath(ParamStr(0));
  f := TPath.Combine(dir, 'grid.csv');
  if not TFile.Exists(f) then
    f := TPath.Combine(TPath.Combine(TPath.Combine(dir, '..'), '..'), 'grid.csv');
  if not TFile.Exists(f) then
    f := TPath.Combine(GetCurrentDir, 'grid.csv');
  if TFile.Exists(f) then
    TMSFNCDataGrid1.LoadFromCSVData(f);
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

function StatusKind(const AStatus: string): TTMSFNCStatusKind;
begin
  if AStatus = 'Office' then
    Result := tskSuccess
  else if AStatus = 'Flight' then
    Result := tskWarning
  else if AStatus = 'On Leave' then
    Result := tskError
  else if AStatus = 'Abroad' then
    Result := tskInfo
  else
    Result := tskNeutral;
end;

procedure TForm1.TMSFNCDataGrid1BeforeDrawCell(Sender: TObject;
  AGraphics: TTMSFNCGraphics; ACell: TTMSFNCDataGridCell;
  var ACanDraw: Boolean);
begin
  { the data cells of these columns draw their own content (AfterDrawCell) }
  if (ACell.Row > 0) and (ACell.Column in [ColStatus, ColProgress, ColTarget]) then
    ACell.DrawElements := ACell.DrawElements - [gcdText];
end;

procedure TForm1.TMSFNCDataGrid1AfterDrawCell(Sender: TObject;
  AGraphics: TTMSFNCGraphics; ACell: TTMSFNCDataGridCell);
var
  t: TTMSFNCResolvedTheme;
  txt: string;
  r: TRectF;
  v: Integer;
  bg, tx, bd: TTMSFNCGraphicsColor;
begin
  if ACell.Row = 0 then
    Exit;

  t := ThemeColors;
  txt := TMSFNCDataGrid1.Strings[ACell.Column, ACell.Row];

  case ACell.Column of
    ColStatus:
    begin
      { a status pill in the theme's status colors (success, warning, error, info) }
      r := ACell.Rect;
      InflateRectEx(r, -8, -6);
      TTMSFNCThemePainter.DrawStatusPill(AGraphics, r, txt, StatusKind(txt), True, t);
    end;
    ColProgress:
    begin
      { a progress bar: the theme's track with the accent }
      v := StrToIntDef(txt, 0);
      r := ACell.Rect;
      InflateRectEx(r, -12, 0);
      r.Top := Int(r.CenterPoint.Y) - 3;
      r.Bottom := r.Top + 6;
      AGraphics.Stroke.Kind := gskNone;
      AGraphics.Fill.Kind := gfkSolid;
      AGraphics.Fill.Color := t[ttTrack];
      AGraphics.DrawRoundRectangle(r, 3);
      r.Right := r.Left + Max(6, r.Width * v / 100);
      AGraphics.Fill.Color := t[ttAccent];
      AGraphics.DrawRoundRectangle(r, 3);
    end;
    ColTarget:
    begin
      { the target in the success (completed) or error color of the theme }
      if TMSFNCDataGrid1.Strings[ColProgress, ACell.Row] = '100' then
        TTMSFNCTheme.StatusColors(t, tskSuccess, bg, tx, bd)
      else
        TTMSFNCTheme.StatusColors(t, tskError, bg, tx, bd);
      AGraphics.Font.Color := tx;
      AGraphics.DrawText(ACell.TextRect, '€ ' + txt, False, gtaTrailing, gtaCenter, gttNone);
    end;
  end;
end;

end.
