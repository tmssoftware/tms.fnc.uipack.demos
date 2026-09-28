unit UGridInGrid;

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
    TMSFNCDataGrid1: TTMSFNCDataGrid;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    TMSFNCDataGridPDFIO1: TTMSFNCDataGridPDFIO;
    Button3: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure TMSFNCDataGrid1GetCellProperties(Sender: TObject;
      ACell: TTMSFNCDataGridCell);
    procedure TMSFNCDataGrid1GetCellLayout(Sender: TObject;
      ACell: TTMSFNCDataGridCell);
    procedure TMSFNCDataGrid1CellCheckBoxChange(Sender: TObject; AColumn,
      ARow: Integer);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure DoCollapse(Sender: TObject);
  end;

var
  Form130: TForm130;

implementation

{$R *.dfm}

uses
  Math;

procedure TForm130.Button1Click(Sender: TObject);
begin
  TMSFNCDataGrid1.ExpandAllNodes;
end;

procedure TForm130.Button2Click(Sender: TObject);
begin
  TMSFNCDataGrid1.CollapseAllNodes;
end;

procedure TForm130.Button3Click(Sender: TObject);
begin
  TMSFNCDataGridPDFIO1.Options.OpenInPDFReader := True;
  TMSFNCDataGridPDFIO1.Options.Header := 'Grid in Grid';
  TMSFNCDataGridPDFIO1.Options.Footer := '';
  TMSFNCDataGridPDFIO1.Save('Export.pdf');
end;

procedure TForm130.DoCollapse(Sender: TObject);
var
  t: Integer;
begin
  t := (Sender as TButton).Tag;
  TMSFNCDataGrid1.ToggleNode(t);
end;

procedure TForm130.FormCreate(Sender: TObject);
var
  I, K: Integer;
  g: TTMSFNCDataGridRenderer;
  b: TButton;
  idx, m, nr: Integer;
begin
  TMSFNCDataGrid1.BeginUpdate;
  TMSFNCDataGrid1.RowCount := 1;
  TMSFNCDataGrid1.FixedRowCount := 1;
  TMSFNCDataGrid1.FixedColumnCount := 1;
  TMSFNCDataGrid1.ColumnCount := 6;
  TMSFNCDataGrid1.Options.Column.Stretching.Enabled := True;
  TMSFNCDataGrid1.Options.Column.Stretching.Mode := gstmIndex;
  TMSFNCDataGrid1.Options.Column.Stretching.&Index := 1;
  TMSFNCDataGrid1.Columns[0].Header := '';
  TMSFNCDataGrid1.Columns[1].Header := 'Grid';
  TMSFNCDataGrid1.Columns[2].Header := '<b>HTML</b> <i>Formatted</i> Text';
  TMSFNCDataGrid1.Columns[3].Header := 'Checkboxes';
  TMSFNCDataGrid1.Columns[4].Header := 'More <b>HTML</b>';
  TMSFNCDataGrid1.MergeCells(4, 0, 2, 1);
  TMSFNCDataGrid1.AddCheckBox(3, 0);

  for I := 0 to 9 do
  begin
    TMSFNCDataGrid1.AddRow;
    idx := TMSFNCDataGrid1.RowCount - 1;
    nr := idx;
    TMSFNCDataGrid1.Cells[0, idx] := (I + 1).ToString;
    TMSFNCDataGrid1.Cells[1, idx] := 'Click on the node icon or button to expand/collapse this row';
    b := TButton.Create(Self);
    b.OnClick := DoCollapse;
    b.Tag := idx;
    TMSFNCDataGrid1.Controls[1, idx] := b;

    TMSFNCDataGrid1.AddRow;
    idx := TMSFNCDataGrid1.RowCount - 1;
    g := TMSFNCDataGrid1.AddGrid(1, idx);
    g.LoadSampleData;
    g.Options.Column.Stretching.Enabled := True;
    TMSFNCDataGrid1.RowHeights[idx] := 150;
    TMSFNCDataGrid1.Cells[2, idx] := 'The grid is capable of <font color="gcDarkOrange">expanding</font> and <font color="gcYellowGreen">collapsing</font> <u>multiple</u> rows, but did '+
      'you know that the grid is also capable of filtering ' + '<IMG src="filter.svg" height="24"/> and sorting <IMG src="sort.svg" height="24"/>';

    m := idx;

    TMSFNCDataGrid1.RowCount := TMSFNCDataGrid1.RowCount + 4;

    for K := m to m + 4 do
    begin
      TMSFNCDataGrid1.AddCheckBox(3, K);
      TMSFNCDataGrid1.ControlPositions[3, K] := gcpCenterCenter;
      TMSFNCDataGrid1.Booleans[3, K] := RandomRange(-1, 1) = 0;
    end;

    TMSFNCDataGrid1.AddRow;

    TMSFNCDataGrid1.Cells[4, idx + 1] := 'Did you know that the grid is also capable of <font color="gcred">adding</font> and <font color="gcred">updating</font> calculations across multiple '+
      '<font color="gcYellowGreen">columns</font> and <font color="gcYellowGreen">rows</font>';

    idx := TMSFNCDataGrid1.RowCount - 1;
    TMSFNCDataGrid1.RowTypes[idx] := grtSummary;

    TMSFNCDataGrid1.ColumnCalculations[3, 'Total Checked' + IntToStr(idx)] := [CreateNormalColumnCalculation(gcmCustom,
    procedure(AColumn: Integer; ALevel: Integer; var AOptions: TTMSFNCDataGridDataColumnCalculationOptions)
    begin
      AOptions.CalculationFormat := 'Total Checked: %.0f';
    end
    ,
    function(AColumn: Integer; ALevel: Integer; AFromRow: Integer; AToRow: Integer): Double
    var
      r: Integer;
    begin
      Result := 0;
      for r := AFromRow to AToRow do
      begin
        if TMSFNCDataGrid1.Booleans[AColumn, r] then
        begin
          Result := Result + 1;
        end;
      end;

    end, idx - 5, idx - 1, idx
    )];

    TMSFNCDataGrid1.MergeCells(1, m, 1, 5);
    TMSFNCDataGrid1.MergeCells(4, m + 1, 2, 4);

    TMSFNCDataGrid1.SetNodeRow(nr, 5, 0, True);
  end;

  TMSFNCDataGrid1.ColumnWidths[2] := 200;
  TMSFNCDataGrid1.Columns[2].AddSetting(gcsEditor);
  TMSFNCDataGrid1.Columns[2].Editor := getHTMLEditor;
  TMSFNCDataGrid1.AutoSizeColumn(0);

  TMSFNCDataGrid1.EndUpdate;
end;

procedure TForm130.TMSFNCDataGrid1CellCheckBoxChange(Sender: TObject; AColumn,
  ARow: Integer);
begin
  TMSFNCDataGrid1.UpdateCalculations;
end;

procedure TForm130.TMSFNCDataGrid1GetCellLayout(Sender: TObject;
  ACell: TTMSFNCDataGridCell);
begin
  if (ACell.Column in [2, 4]) and (ACell.Row >= TMSFNCDataGrid1.FixedRowCount) then
  begin
    ACell.Layout.TextAlign := gtaLeading;
    ACell.Layout.VerticalTextAlign := gtaLeading;
    ACell.Layout.WordWrapping := True;
  end;

  if TMSFNCDataGrid1.IsRowNode(ACell.Row) then
    ACell.Layout.Assign(TMSFNCDataGrid1.CellAppearance.GroupLayout)
  else if TMSFNCDataGrid1.IsRowSummary(ACell.Row) then
    ACell.Layout.Assign(TMSFNCDataGrid1.CellAppearance.SummaryLayout);
end;

procedure TForm130.TMSFNCDataGrid1GetCellProperties(Sender: TObject;
  ACell: TTMSFNCDataGridCell);
var
  c: TControl;
  t: Integer;
begin
  c := ACell.Control;
  if Assigned(c) then
  begin
    t := c.Tag;
    if c is TButton then
    begin
      case TMSFNCDataGrid1.RowNodeState[t] of
        grnsCollapsed: (c as TButton).Caption := 'Expand';
        grnsExpanded: (c as TButton).Caption := 'Collapse';
      end;
    end;
  end;
end;

end.
