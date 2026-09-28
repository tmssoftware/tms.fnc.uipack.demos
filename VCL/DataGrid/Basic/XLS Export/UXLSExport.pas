unit UXLSExport;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  VCL.Controls, VCL.Forms, VCL.Graphics, VCL.Dialogs, VCL.StdCtrls,
  VCL.TMSFNCCustomControl,
  VCL.TMSFNCCustomScrollControl, VCL.TMSFNCDataGridData, VCL.TMSFNCCustomGrid,
  VCL.TMSFNCDataGrid, VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCCustomComponent,
  VCL.TMSFNCDataGridExcelIO, VCL.TMSFNCDataGridCell, VCL.TMSFNCBitmapContainer,
  VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCDataGridBase,
  VCL.TMSFNCDataGridCore, VCL.TMSFNCDataGridRenderer, System.Rtti, Vcl.ExtCtrls;

type
  TForm130 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    TMSFNCDataGrid1: TTMSFNCDataGrid;
    TMSFNCDataGridExcelIO1: TTMSFNCDataGridExcelIO;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure TMSFNCDataGrid1GetCellLayout(Sender: TObject;
      ACell: TTMSFNCDataGridCell);
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
  TMSFNCDataGridExcelIO1.XLSImport('CARS.xls');
end;

procedure TForm130.Button2Click(Sender: TObject);
begin
  TMSFNCDataGridExcelIO1.XLSExport('gridexport.xls');
  TTMSFNCUtils.OpenFile('gridexport.xls');
end;

procedure TForm130.FormCreate(Sender: TObject);
begin
  TMSFNCDataGridExcelIO1.Options.ImportCellProperties := true;
  TMSFNCDataGridExcelIO1.Options.ExportCellProperties := true;
  TMSFNCDataGridExcelIO1.Options.ExportOverwrite := omAlways;
  TMSFNCDataGridExcelIO1.Options.ExportImages := true;

  TMSFNCDataGrid1.ColumnCount := 6;
  TMSFNCDataGrid1.RandomFill;
  TMSFNCDataGrid1.AutoNumberColumn(0);
  TMSFNCDataGrid1.Layouts[2,2].Fill.Color := gcRed;
  TMSFNCDataGrid1.Layouts[3,3].Fill.Color := gcLime;
  TMSFNCDataGrid1.Layouts[4,4].Fill.Color := gcYellow;

  TMSFNCDataGrid1.Layouts[2,3].TextAlign := gtaCenter;
  TMSFNCDataGrid1.Layouts[3,4].TextAlign := gtaTrailing;

  TMSFNCDataGrid1.Layouts[1,1].Font.Style := [TFontStyle.fsBold];
  TMSFNCDataGrid1.Layouts[1,2].Font.Style := [TFontStyle.fsItalic];

  TMSFNCDataGrid1.MergeCells(1,4,2,2);

  TMSFNCDataGrid1.AddBitmap(1,7,'1');
  TMSFNCDataGrid1.AddBitmap(1,8,'2');
  TMSFNCDataGrid1.AddBitmap(1,9,'3');
end;

procedure TForm130.TMSFNCDataGrid1GetCellLayout(Sender: TObject;
  ACell: TTMSFNCDataGridCell);
begin
  if (ACell.Column = 5) then
  begin
    ACell.Layout.Font.Color := gcRed;
    ACell.Layout.TextAlign := gtaTrailing;
  end;
end;

end.
