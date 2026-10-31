unit UTemplate;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, System.IOUtils, System.Math,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCDataGridCell, FMX.TMSFNCCustomComponent,
  FMX.TMSFNCBitmapContainer, FMX.TMSFNCCustomControl,
  FMX.TMSFNCCustomScrollControl, FMX.TMSFNCDataGridData,
  FMX.TMSFNCDataGrid, System.Rtti, FMX.TMSFNCDataGridBase,
  FMX.TMSFNCDataGridCore, FMX.TMSFNCDataGridRenderer, FMX.Controls.Presentation,
  FMX.StdCtrls, TMS.TMSFNCFilterBuilder,
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
  TMSFNCDataGrid1.Options.IO.StartColumn := 0;
  TMSFNCDataGrid1.Options.IO.StartRow := 0;
  LoadSampleData;

  TMSFNCDataGrid1.Options.Selection.Mode := gsmDisjunctRow;
  TMSFNCDataGrid1.SelectedRows[1] := False;
  TMSFNCDataGrid1.SelectedRows[4] := True;

  TMSFNCDataGrid1.GlobalFont.Scale := 1.2;
  TMSFNCDataGrid1.CellAppearance.FixedLayout.Font.Style := [TFontStyle.fsBold];
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
