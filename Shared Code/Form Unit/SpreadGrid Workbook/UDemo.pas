unit UDemo;

{ TMS FNC UI Pack - SpreadGrid Workbook

  A trip budget as a small workbook of two TTMSFNCSpreadGrid sheets. The Rates sheet holds the exchange rates and
  the trip facts; the Budget sheet reads them with sheet references (=Rates!B2), which a TTMSFNCGridBinder makes
  possible by giving both grids a name. The math libraries add functions to the formulas: PMT for the loan that
  pays the trip (TTMSFNCFinanceMathLib), KGTOLB and CELSTOFAHR for the luggage and the weather
  (TTMSFNCConversionMathLib), CAPITALIZE for the destination (TTMSFNCStringMathLib) and GEOMEAN
  (TTMSFNCMiscMathLib). The formula bar shows the formula of the selected cell; change a rate and the budget follows.
  FMX and VCL: the spread grid does not compile for TMS WEB Core yet. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCEdit,
  VCL.TMSFNCSegmentedControl, VCL.TMSFNCGridData, VCL.TMSFNCCustomGrid, VCL.TMSFNCGrid, VCL.TMSFNCSpreadGrid,
  VCL.TMSFNCSpreadGridLibs, VCL.TMSFNCFormulaParser, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCEdit,
  FMX.TMSFNCSegmentedControl, FMX.TMSFNCGridData, FMX.TMSFNCCustomGrid, FMX.TMSFNCGrid, FMX.TMSFNCSpreadGrid,
  FMX.TMSFNCSpreadGridLibs, FMX.TMSFNCFormulaParser, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
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
    FSheets: TTMSFNCSegmentedControl;
    FCellName: TTMSFNCHTMLText;
    FFormula: TTMSFNCEdit;
    FBudget: TTMSFNCSpreadGrid;
    FRates: TTMSFNCSpreadGrid;
    FBinder: TTMSFNCGridBinder;
    FShowFormulaCheck: TTMSFNCCheckBox;
    FStatus: TTMSFNCHTMLText;
    procedure CreateSettings;
    procedure CreateContent;
    function NewSheet: TTMSFNCSpreadGrid;
    procedure AddLibs(AGrid: TTMSFNCSpreadGrid);
    procedure FillRates;
    procedure FillBudget;
    function ActiveSheet: TTMSFNCSpreadGrid;
    procedure ShowCell(AGrid: TTMSFNCSpreadGrid; ACol, ARow: Integer);
    procedure SheetChanged(Sender: TObject);
    procedure SettingChanged(Sender: TObject);
    procedure ResetClick(Sender: TObject);
    procedure CellSelected(Sender: TObject; ACol, ARow: Integer);
    procedure FormulaError(Sender: TObject; ACol, ARow, ErrType, ErrPos, ErrParam: Integer; ErrStr: string);
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

function ColName(ACol: Integer): string;
begin
  if ACol < 1 then
    Result := ''
  else
    Result := Chr(Ord('A') + ACol - 1);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FLayout := TDemoLayout.Create(Self);
  CreateSettings;
  CreateContent;
  FillRates;
  FillBudget;
  SheetChanged(nil);
end;

procedure TForm1.CreateSettings;
begin
  FSettings := FLayout.AddSettingsPanel(Self);

  FLayout.AddCaption(FSettings, 'Workbook');
  FShowFormulaCheck := FLayout.AddCheck(FSettings, 'Show formulas in the cells', False,
    SettingChanged);
  FLayout.AddButton(FSettings, 'Start again', ResetClick);

  FLayout.AddCaption(FSettings, 'Try');
  FLayout.AddText(FSettings, 'Rates sheet: change the EUR to USD rate in B2 or the flight in B5; the budget ' +
    'follows.<br><br>Budget sheet: click a total to see its formula; type =Rates!B3*100 in a free cell.' +
    '<br><br>Functions of the libraries: PMT, RATE, PV (finance), KGTOLB, CELSTOFAHR, GALTOL (conversion), ' +
    'CAPITALIZE, REVERSE (text), GEOMEAN, HARMEAN (misc).', 230);

  FStatus := FLayout.AddText(FSettings, '', 56);
end;

function TForm1.NewSheet: TTMSFNCSpreadGrid;
begin
  Result := TTMSFNCSpreadGrid.Create(Self);
  Result.Parent := FContent;
  FLayout.Place(Result, daClient, 0, 0, 0, 0, 0);
  Result.ColumnCount := 6;
  Result.RowCount := 20;
  Result.DefaultColumnWidth := FLayout.Size(110);
  Result.CellNameMode := nmA1;
  Result.OnSelectedCell := CellSelected;
  Result.OnFormulaError := FormulaError;
  AddLibs(Result);
end;

procedure TForm1.AddLibs(AGrid: TTMSFNCSpreadGrid);
begin
  AGrid.Libs.Add.MathLib := TTMSFNCFinanceMathLib.Create(Self);
  AGrid.Libs.Add.MathLib := TTMSFNCConversionMathLib.Create(Self);
  AGrid.Libs.Add.MathLib := TTMSFNCStringMathLib.Create(Self);
  AGrid.Libs.Add.MathLib := TTMSFNCMiscMathLib.Create(Self);
end;

procedure TForm1.CreateContent;
var
  bar: TTMSFNCPanel;
  item: TTMSFNCGridBinderItem;
begin
  FContent := FLayout.AddContentPanel(Self);

  { the sheet tabs and the formula bar }
  bar := FLayout.AddPanel(FContent, daTop, 40, 0, 0, 0, 8);
  bar.Fill.Kind := gfkNone;
  bar.Stroke.Kind := gskNone;
  FSheets := TTMSFNCSegmentedControl.Create(Self);
  FSheets.Parent := bar;
  FLayout.Place(FSheets, daLeft, 200, 0, 4, 12, 4);
  FSheets.Items.AddItem('Budget');
  FSheets.Items.AddItem('Rates');
  FSheets.ItemIndex := 0;
  FSheets.OnChange := SheetChanged;
  FCellName := FLayout.AddText(bar, '', 0);
  FLayout.Place(FCellName, daLeft, 56, 0, 10, 8, 0);
  FFormula := TTMSFNCEdit.Create(Self);
  FFormula.Parent := bar;
  FLayout.Place(FFormula, daClient, 0, 0, 4, 0, 4);
  FFormula.ReadOnly := True;

  FBudget := NewSheet;
  FRates := NewSheet;

  { one name per sheet: =Rates!B2 in the budget finds the rates grid }
  FBinder := TTMSFNCGridBinder.Create(Self);
  item := FBinder.Grids.Add;
  item.Grid := FBudget;
  item.Name := 'Budget';
  item := FBinder.Grids.Add;
  item.Grid := FRates;
  item.Name := 'Rates';
end;

procedure TForm1.FillRates;
begin
  FRates.BeginUpdate;
  try
    FRates.ClearNormalCells;
    FRates.Cells[1, 1] := 'Fact';
    FRates.Cells[2, 1] := 'Value';
    FRates.Cells[1, 2] := 'EUR to USD';
    FRates.Floats[2, 2] := 1.08;
    FRates.Cells[1, 3] := 'EUR to GBP';
    FRates.Floats[2, 3] := 0.85;
    FRates.Cells[1, 4] := 'Nights';
    FRates.Ints[2, 4] := 6;
    FRates.Cells[1, 5] := 'Flight (USD)';
    FRates.Ints[2, 5] := 640;
    FRates.Cells[1, 6] := 'Hotel per night (GBP)';
    FRates.Ints[2, 6] := 120;
    FRates.Cells[1, 7] := 'Luggage (kg)';
    FRates.Ints[2, 7] := 18;
    FRates.Cells[1, 8] := 'Expected (deg C)';
    FRates.Ints[2, 8] := 24;
    FRates.ColumnWidths[1] := FLayout.Size(170);
  finally
    FRates.EndUpdate;
  end;
  FRates.Recalc;
end;

procedure TForm1.FillBudget;
begin
  FBudget.BeginUpdate;
  try
    FBudget.ClearNormalCells;
    FBudget.Cells[1, 1] := 'Item';
    FBudget.Cells[2, 1] := 'EUR';
    FBudget.Cells[3, 1] := 'How';
    FBudget.Cells[1, 2] := 'Flight';
    FBudget.Cells[2, 2] := '=Rates!B5/Rates!B2';
    FBudget.Cells[3, 2] := 'USD price / rate';
    FBudget.Cells[1, 3] := 'Hotel';
    FBudget.Cells[2, 3] := '=Rates!B6*Rates!B4/Rates!B3';
    FBudget.Cells[3, 3] := 'GBP x nights / rate';
    FBudget.Cells[1, 4] := 'Food';
    FBudget.Cells[2, 4] := '=45*Rates!B4';
    FBudget.Cells[3, 4] := '45 a day';
    FBudget.Cells[1, 5] := 'Total';
    FBudget.Cells[2, 5] := '=SUM(B2:B4)';
    FBudget.Cells[1, 7] := 'Loan, 12 months';
    { TTMSFNCFinanceMathLib: PMT(principal, rate per period, periods), not the order of Excel (that gave 0,00) }
    FBudget.Cells[2, 7] := '=PMT(B5,5/1200,12)';
    FBudget.Cells[3, 7] := 'PMT at 5 % a year';
    FBudget.Cells[1, 8] := 'Luggage (lb)';
    FBudget.Cells[2, 8] := '=KGTOLB(Rates!B7)';
    FBudget.Cells[1, 9] := 'Weather (deg F)';
    FBudget.Cells[2, 9] := '=CELSTOFAHR(Rates!B8)';
    FBudget.Cells[1, 10] := 'A day';
    FBudget.Cells[2, 10] := '=B5/Rates!B4';
    FBudget.Cells[3, 10] := 'total / nights';
    FBudget.Cells[1, 11] := 'Typical item';
    FBudget.Cells[2, 11] := '=GEOMEAN(B2:B4)';
    FBudget.Cells[3, 11] := 'geometric mean';
    FBudget.Cells[1, 13] := 'Destination';
    FBudget.Cells[2, 13] := '=CAPITALIZE("lisbon")';
    FBudget.ColumnWidths[1] := FLayout.Size(150);
    FBudget.ColumnWidths[3] := FLayout.Size(170);
  finally
    FBudget.EndUpdate;
  end;
  FBudget.Recalc;
end;

function TForm1.ActiveSheet: TTMSFNCSpreadGrid;
begin
  if FSheets.ItemIndex = 1 then
    Result := FRates
  else
    Result := FBudget;
end;

procedure TForm1.ShowCell(AGrid: TTMSFNCSpreadGrid; ACol, ARow: Integer);
begin
  FCellName.Text := '<b>' + ColName(ACol) + IntToStr(ARow) + '</b>';
  FFormula.Text := AGrid.Cells[ACol, ARow];
end;

procedure TForm1.SheetChanged(Sender: TObject);
begin
  FBudget.Visible := FSheets.ItemIndex = 0;
  FRates.Visible := FSheets.ItemIndex = 1;
  { a rate changed on the other sheet: the budget calculates again }
  FBudget.Recalc;
  ShowCell(ActiveSheet, 2, 2);
  FStatus.Text := '';
end;

procedure TForm1.SettingChanged(Sender: TObject);
begin
  FBudget.ShowFormula := FShowFormulaCheck.Checked;
  FRates.ShowFormula := FShowFormulaCheck.Checked;
end;

procedure TForm1.ResetClick(Sender: TObject);
begin
  FillRates;
  FillBudget;
  SheetChanged(nil);
end;

procedure TForm1.CellSelected(Sender: TObject; ACol, ARow: Integer);
begin
  ShowCell(Sender as TTMSFNCSpreadGrid, ACol, ARow);
end;

procedure TForm1.FormulaError(Sender: TObject; ACol, ARow, ErrType, ErrPos, ErrParam: Integer; ErrStr: string);
begin
  FStatus.Text := '<font color="var(--error)">' + ColName(ACol) + IntToStr(ARow) + ': ' + ErrStr + '</font>';
end;

end.
