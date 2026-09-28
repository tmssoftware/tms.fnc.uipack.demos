unit URendererSource;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  Vcl.Controls, Vcl.Forms, JS, Web, WEBLib.Graphics, WEBLib.Forms,
  Vcl.Graphics, Vcl.Dialogs, Vcl.StdCtrls,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCCustomScrollControl,
  WEBLib.TMSFNCDataGridData, WEBLib.TMSFNCCustomGrid, WEBLib.TMSFNCDataGrid,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics,
  WEBLib.TMSFNCGraphicsTypes, WEBLib.TMSFNCDataGridBase,
  WEBLib.TMSFNCDataGridCell, WEBLib.TMSFNCDataGridCore,
  WEBLib.TMSFNCDataGridRenderer, System.Rtti, WEBLib.StdCtrls,
  WEBLib.Controls, WEBLib.ExtCtrls, VCL.TMSFNCTypes, VCL.TMSFNCUtils,
  VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCDataGridCell,
  VCL.TMSFNCDataGridData, VCL.TMSFNCDataGridBase, VCL.TMSFNCDataGridCore,
  VCL.TMSFNCDataGridRenderer, VCL.TMSFNCCustomControl, VCL.TMSFNCDataGrid;

type
  TFormRendererSource = class(TWebForm)
    lblTitle: TWebLabel;
    lblDescription: TWebLabel;
    Panel1: TWebPanel;
    btnSales: TWebButton;
    btnInventory: TWebButton;
    btnDefault: TWebButton;
    btnAddRow: TWebButton;
    lblStatus: TWebLabel;
    TMSFNCDataGrid1: TTMSFNCDataGrid;
    procedure FormCreate(Sender: TObject);
    procedure btnSalesClick(Sender: TObject);
    procedure btnInventoryClick(Sender: TObject);
    procedure btnDefaultClick(Sender: TObject);
    procedure btnAddRowClick(Sender: TObject);
  private
    FSalesLayer: TTMSFNCDataGridRendererSource;
    FInventoryLayer: TTMSFNCDataGridRendererSource;
    procedure BuildSalesLayer;
    procedure BuildInventoryLayer;
    procedure SeedGridOwnData;
    function ActiveLayerName: string;
    procedure UpdateStatus(const ALayerName: string);
  public
  end;

var
  FormRendererSource: TFormRendererSource;

implementation

{$R *.dfm}

procedure TFormRendererSource.FormCreate(Sender: TObject);
begin
  SeedGridOwnData;

  FSalesLayer := TTMSFNCDataGridRendererSource.Create(Self);
  FSalesLayer.Name := 'SalesLayer';
  BuildSalesLayer;

  FInventoryLayer := TTMSFNCDataGridRendererSource.Create(Self);
  FInventoryLayer.Name := 'InventoryLayer';
  BuildInventoryLayer;

  UpdateStatus('the grid''s own layer');
end;

procedure TFormRendererSource.BuildSalesLayer;
var
  r: TTMSFNCDataGridRenderer;
const
  CRegions: array[0..4] of string = (
    'North America', 'Europe', 'Asia Pacific', 'Latin America', 'Middle East');
  CSales: array[0..4, 0..3] of Integer = (
    (412, 458, 501, 530),
    (388, 401, 444, 470),
    (295, 360, 410, 502),
    (120, 134, 150, 168),
    ( 88,  95, 110, 121));
var
  i, q, total: Integer;
begin
  r := FSalesLayer.Renderer;
  r.BeginUpdate;
  try
    r.CellAppearance.FixedLayout.Fill.Color := gcSteelblue;
    r.CellAppearance.FixedLayout.Font.Color := gcWhite;
    r.CellAppearance.NormalLayout.Fill.Color := gcAliceblue;
    r.CellAppearance.SelectedLayout.Fill.Color := gcLightsteelblue;
    r.Options.Column.Stretching.Enabled := True;

    r.FixedRowCount := 1;
    r.ColumnCount := 6;
    r.RowCount := Length(CRegions) + 1;

    r.Cells[0, 0] := 'Region';
    r.Cells[1, 0] := 'Q1';
    r.Cells[2, 0] := 'Q2';
    r.Cells[3, 0] := 'Q3';
    r.Cells[4, 0] := 'Q4';
    r.Cells[5, 0] := 'Total';

    for i := 0 to High(CRegions) do
    begin
      r.Cells[0, i + 1] := CRegions[i];
      total := 0;
      for q := 0 to 3 do
      begin
        r.Cells[q + 1, i + 1] := CSales[i, q].ToString;
        Inc(total, CSales[i, q]);
      end;
      r.Cells[5, i + 1] := total.ToString;
    end;
  finally
    r.EndUpdate;
  end;
end;

procedure TFormRendererSource.BuildInventoryLayer;
var
  r: TTMSFNCDataGridRenderer;
const
  CProducts: array[0..5] of string = (
    'Wireless Mouse', 'Mechanical Keyboard', 'USB-C Hub', '27" Monitor',
    'Laptop Stand', 'Webcam 1080p');
  CSku: array[0..5] of string = (
    'WM-100', 'KB-220', 'HUB-09', 'MON-27', 'LS-014', 'CAM-08');
  CStock: array[0..5] of Integer = (340, 75, 12, 58, 0, 210);
  CReorder: array[0..5] of Integer = (100, 80, 40, 30, 25, 120);
var
  i: Integer;
  status: string;
begin
  r := FInventoryLayer.Renderer;
  r.BeginUpdate;
  try
    r.CellAppearance.FixedLayout.Fill.Color := gcSeagreen;
    r.CellAppearance.FixedLayout.Font.Color := gcWhite;
    r.CellAppearance.NormalLayout.Fill.Color := gcHoneydew;
    r.CellAppearance.SelectedLayout.Fill.Color := gcDarkseagreen;
    r.Options.Column.Stretching.Enabled := True;

    r.FixedRowCount := 1;
    r.ColumnCount := 5;
    r.RowCount := Length(CProducts) + 1;

    r.Cells[0, 0] := 'Product';
    r.Cells[1, 0] := 'SKU';
    r.Cells[2, 0] := 'In Stock';
    r.Cells[3, 0] := 'Reorder Level';
    r.Cells[4, 0] := 'Status';

    for i := 0 to High(CProducts) do
    begin
      r.Cells[0, i + 1] := CProducts[i];
      r.Cells[1, i + 1] := CSku[i];
      r.Cells[2, i + 1] := CStock[i].ToString;
      r.Cells[3, i + 1] := CReorder[i].ToString;
      if CStock[i] = 0 then
        status := 'Out of stock'
      else if CStock[i] < CReorder[i] then
        status := 'Reorder'
      else
        status := 'OK';
      r.Cells[4, i + 1] := status;
    end;
  finally
    r.EndUpdate;
  end;
end;

procedure TFormRendererSource.SeedGridOwnData;
begin
  TMSFNCDataGrid1.BeginUpdate;
  try
    TMSFNCDataGrid1.Options.Column.Stretching.Enabled := True;
    TMSFNCDataGrid1.FixedRowCount := 1;
    TMSFNCDataGrid1.ColumnCount := 2;
    TMSFNCDataGrid1.RowCount := 4;

    TMSFNCDataGrid1.Cells[0, 0] := 'Topic';
    TMSFNCDataGrid1.Cells[1, 0] := 'Description';
    TMSFNCDataGrid1.Cells[0, 1] := 'This grid';
    TMSFNCDataGrid1.Cells[1, 1] := 'Shows its own built-in layer (RendererSource = nil).';
    TMSFNCDataGrid1.Cells[0, 2] := 'Sales by Region';
    TMSFNCDataGrid1.Cells[1, 2] := 'A separate renderer layer with its own blue theme and data.';
    TMSFNCDataGrid1.Cells[0, 3] := 'Product Inventory';
    TMSFNCDataGrid1.Cells[1, 3] := 'Another renderer layer with its own green theme and data.';
  finally
    TMSFNCDataGrid1.EndUpdate;
  end;
end;

procedure TFormRendererSource.btnSalesClick(Sender: TObject);
begin
  TMSFNCDataGrid1.RendererSource := FSalesLayer;
  UpdateStatus('Sales by Region (external layer)');
end;

procedure TFormRendererSource.btnInventoryClick(Sender: TObject);
begin
  TMSFNCDataGrid1.RendererSource := FInventoryLayer;
  UpdateStatus('Product Inventory (external layer)');
end;

procedure TFormRendererSource.btnDefaultClick(Sender: TObject);
begin
  TMSFNCDataGrid1.RendererSource := nil;
  UpdateStatus('the grid''s own layer');
end;

procedure TFormRendererSource.btnAddRowClick(Sender: TObject);
var
  newRow: Integer;
begin
  TMSFNCDataGrid1.BeginUpdate;
  try
    newRow := TMSFNCDataGrid1.RowCount;
    TMSFNCDataGrid1.RowCount := newRow + 1;
    TMSFNCDataGrid1.Cells[0, newRow] := Format('Added row %d', [newRow]);
  finally
    TMSFNCDataGrid1.EndUpdate;
  end;
  UpdateStatus(ActiveLayerName);
end;

function TFormRendererSource.ActiveLayerName: string;
begin
  if TMSFNCDataGrid1.RendererSource = FSalesLayer then
    Result := 'Sales by Region (external layer)'
  else if TMSFNCDataGrid1.RendererSource = FInventoryLayer then
    Result := 'Product Inventory (external layer)'
  else
    Result := 'the grid''s own layer';
end;

procedure TFormRendererSource.UpdateStatus(const ALayerName: string);
begin
  lblStatus.Caption := Format('Active layer: %s   -   %d columns x %d rows',
    [ALayerName, TMSFNCDataGrid1.ColumnCount, TMSFNCDataGrid1.RowCount]);
end;

end.
