unit UMultiColumnGrouping;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  VCL.Controls, VCL.Forms, VCL.Graphics, VCL.Dialogs, VCL.StdCtrls,
  VCL.TMSFNCCustomControl, VCL.TMSFNCTypes,
  VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, System.Rtti,
  VCL.TMSFNCDataGridCell, VCL.TMSFNCDataGridData, VCL.TMSFNCDataGridBase,
  VCL.TMSFNCDataGridCore, VCL.TMSFNCDataGridRenderer, VCL.TMSFNCPDFIO,
  VCL.TMSFNCDataGridPDFIO, VCL.TMSFNCCustomComponent, VCL.TMSFNCBitmapContainer,
  VCL.TMSFNCDataGrid, Vcl.ExtCtrls;

type
  TForm130 = class(TForm)
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    TMSFNCDataGrid1: TTMSFNCDataGrid;
    Panel1: TPanel;
    Button1: TButton;
    TMSFNCDataGridPDFIO1: TTMSFNCDataGridPDFIO;
    procedure FormCreate(Sender: TObject);
    procedure TMSFNCDataGrid1GetCustomGroup(Sender: TObject;
      ACell: TTMSFNCDataGridCellCoord; AData: TTMSFNCDataGridCellValue;
      ALevel: Integer; var AGroup: string);
    procedure TMSFNCDataGrid1CanEditCell(Sender: TObject; AColumn,
      ARow: Integer; var ACanEdit: Boolean);
    procedure TMSFNCDataGrid1AfterCloseInplaceEditor(Sender: TObject;
      ACell: TTMSFNCDataGridCellCoord; ACancel: Boolean;
      AValue: TTMSFNCDataGridCellValue);
    procedure TMSFNCDataGrid1GetCellFormatting(Sender: TObject;
      ACell: TTMSFNCDataGridCellCoord; AData: TTMSFNCDataGridCellValue;
      var AFormatting: TTMSFNCDataGridDataFormatting;
      var AConvertSettings: TFormatSettings; var ACanFormat: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure TMSFNCDataGrid1AfterApplyFilter(Sender: TObject; AColumn: Integer;
      ACondition: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form130: TForm130;

implementation

{$R *.dfm}

procedure TForm130.Button1Click(Sender: TObject);
begin
  TMSFNCDataGridPDFIO1.Options.Header := 'Train Data';
  TMSFNCDataGridPDFIO1.Options.Footer := '';

  TMSFNCDataGridPDFIO1.Options.OpenInPDFReader := True;
  TMSFNCDataGridPDFIO1.Save('Export.pdf');
end;

procedure TForm130.FormCreate(Sender: TObject);
begin
  TMSFNCDataGrid1.BeginUpdate;
  TMSFNCDataGrid1.LoadFromCSVData('train.csv');

  TMSFNCDataGrid1.RowCount := TMSFNCDataGrid1.RowCount + 2;
  TMSFNCDataGrid1.FixedBottomRowCount := 2;
  TMSFNCDataGrid1.Options.Filtering.Enabled := True;
  TMSFNCDataGrid1.Options.Filtering.MultiColumn := True;
  TMSFNCDataGrid1.Options.Sorting.Enabled := True;
  TMSFNCDataGrid1.Options.Mouse.FixedColumnSizing := True;
  TMSFNCDataGrid1.Options.Mouse.ColumnAutoSizeOnDblClick := True;
  TMSFNCDataGrid1.Options.Lookup.Enabled := True;

  TMSFNCDataGrid1.Options.Mouse.TouchScrolling := True;

  TMSFNCDataGrid1.Options.Grouping.HideColumns := True;
  TMSFNCDataGrid1.Group(CreateGroupInfo([4, 5, 7], [11]));
  TMSFNCDataGrid1.Comments[5, 6] := '<b>Hello World!</b>';


  TMSFNCDataGrid1.Options.Column.Stretching.Enabled := True;
  TMSFNCDataGrid1.Options.Column.Stretching.&Index := 3;

  TMSFNCDataGrid1.ColumnCalculations[3, 'Total Count'] := [CreateGroupColumnCalculation(gcmCount,
  procedure(AColumn: Integer; ALevel: Integer; var AOptions: TTMSFNCDataGridDataColumnCalculationOptions)
  begin
    case ALevel of
      0: AOptions.CalculationFormat := 'Count: %g';
      1: AOptions.CalculationFormat := 'Sub-Count: %g';
    end;
  end)];

  TMSFNCDataGrid1.ColumnCalculations[9, 'Average Fare Price'] := [CreateGroupColumnCalculation(gcmAverage,
  procedure(AColumn: Integer; ALevel: Integer; var AOptions: TTMSFNCDataGridDataColumnCalculationOptions)
  begin
    if ALevel = 1 then
      AOptions.CalculationFormat := 'Sub-Average Fare Price: $%.2f'
    else
      AOptions.CalculationFormat := 'Average Fare Price: $%.2f';
  end
  )];

  TMSFNCDataGrid1.ColumnCalculations[9, 'Sum'] :=
  [
  CreateNormalColumnCalculation(gcmSum,
  procedure(AColumn: Integer; ALevel: Integer; var AOptions: TTMSFNCDataGridDataColumnCalculationOptions)
  begin
    AOptions.CalculationFormat := 'Total Sum: $%.2f';
  end),

  CreateNormalColumnCalculation(gcmMax,
  procedure(AColumn: Integer; ALevel: Integer; var AOptions: TTMSFNCDataGridDataColumnCalculationOptions)
  begin
    AOptions.CalculationFormat := '<br>The Maximum: $%.2f';
  end)
  ];

  TMSFNCDataGrid1.ColumnCalculations[3, 'Count'] :=
  [
  CreateNormalColumnCalculation(gcmCount,
  procedure(AColumn: Integer; ALevel: Integer; var AOptions: TTMSFNCDataGridDataColumnCalculationOptions)
  begin
    AOptions.CalculationFormat := 'Total Count: %g';
  end)
  ];

  TMSFNCDataGrid1.AutoSizeColumns;
  TMSFNCDataGrid1.ColumnWidths[0] := 20;
  TMSFNCDataGrid1.RowHeights[TMSFNCDataGrid1.RowCount - TMSFNCDataGrid1.FixedBottomRowCount] := 40;

  TMSFNCDataGrid1.Options.Calculations.IncludeHiddenRows := False;

  TMSFNCDataGrid1.EndUpdate;
end;

procedure TForm130.TMSFNCDataGrid1AfterApplyFilter(Sender: TObject;
  AColumn: Integer; ACondition: string);
begin
  TMSFNCDataGrid1.UpdateCalculations;
end;

procedure TForm130.TMSFNCDataGrid1AfterCloseInplaceEditor(Sender: TObject;
  ACell: TTMSFNCDataGridCellCoord; ACancel: Boolean;
  AValue: TTMSFNCDataGridCellValue);
begin
  TMSFNCDataGrid1.UpdateCalculations;
end;

procedure TForm130.TMSFNCDataGrid1CanEditCell(Sender: TObject; AColumn,
  ARow: Integer; var ACanEdit: Boolean);
begin
  ACanEdit := TMSFNCDataGrid1.RowTypes[ARow] = grtDefault;
end;

procedure TForm130.TMSFNCDataGrid1GetCellFormatting(Sender: TObject;
  ACell: TTMSFNCDataGridCellCoord; AData: TTMSFNCDataGridCellValue;
  var AFormatting: TTMSFNCDataGridDataFormatting;
  var AConvertSettings: TFormatSettings; var ACanFormat: Boolean);
begin
  if (ACell.Column = 9) and (TMSFNCDataGrid1.RowTypes[ACell.Row] = grtDefault) and (ACell.Row > TMSFNCDataGrid1.FixedRowCount - 1) then
  begin
    AFormatting.&Type := gdftNumber;
    AConvertSettings.DecimalSeparator := '.';
    AFormatting.Format := '$%.2f';
  end;
end;

procedure TForm130.TMSFNCDataGrid1GetCustomGroup(Sender: TObject;
  ACell: TTMSFNCDataGridCellCoord; AData: TTMSFNCDataGridCellValue;
  ALevel: Integer; var AGroup: string);
var
  f, i: Integer;
begin
  if ACell.Column = 4 then
    AGroup := '<img src="graph.svg" height="95%"/> ' + AGroup
  else if ACell.Column = 11 then
    AGroup := '<img src="goal.svg" height="95%"/> ' + AGroup
  else if ACell.Column = 5 then
  begin
    f := TMSFNCDataGrid1.ValueToInteger(AData);

    i := f div 10;

    AGroup := Format('%s - %s', [IntToStr(i * 10), IntToStr((i + 1) * 10)]);

    AGroup := 'Age Group: ' + AGroup;
  end;
end;

end.
