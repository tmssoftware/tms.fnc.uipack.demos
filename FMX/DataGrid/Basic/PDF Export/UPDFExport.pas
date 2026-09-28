unit UPDFExport;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.TMSFNCCustomControl, FMX.TMSFNCTypes,
  FMX.TMSFNCUtils, FMX.TMSFNCPDFIO, FMX.TMSFNCDataGridPDFIO,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCBitmapContainer,
  FMX.TMSFNCCustomScrollControl, FMX.TMSFNCDataGridData, FMX.TMSFNCCustomGrid,
  FMX.TMSFNCDataGrid, FMX.TMSFNCDataGridCell, FMX.TMSFNCGraphics,
  FMX.TMSFNCGraphicsTypes, FMX.TMSFNCDataGridBase, FMX.TMSFNCDataGridCore,
  FMX.TMSFNCDataGridRenderer, System.Rtti;

type
  TForm130 = class(TForm)
    TMSFNCDataGrid1: TTMSFNCDataGrid;
    Panel1: TPanel;
    Button2: TButton;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    TMSFNCDataGridPDFIO1: TTMSFNCDataGridPDFIO;
    CheckBox1: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure TMSFNCDataGridPDFIO1GetFooter(Sender, AExportObject: TObject;
      APageIndex: Integer; var AFooter: string);
    procedure TMSFNCDataGrid1GetCellLayout(Sender: TObject;
      ACell: TTMSFNCDataGridCell);
    procedure TMSFNCDataGrid1BeforeDrawCell(Sender: TObject;
      AGraphics: TTMSFNCGraphics; ACell: TTMSFNCDataGridCell;
      var ACanDraw: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form130: TForm130;

implementation

{$R *.fmx}

procedure TForm130.Button2Click(Sender: TObject);
begin
  TMSFNCDataGridPDFIO1.Save('gridexport.pdf');
end;

procedure TForm130.FormCreate(Sender: TObject);
begin
  TMSFNCDataGrid1.BeginUpdate;
  TMSFNCDataGrid1.ColumnCount := 10;
  TMSFNCDataGrid1.LoadSampleData;
  TMSFNCDataGrid1.AutoNumberColumn(0);

  TMSFNCDataGrid1.Layouts[2, 2].Fill.Color := gcRed;

  TMSFNCDataGrid1.Layouts[3, 3].Fill.Color := gcLime;
  TMSFNCDataGrid1.Layouts[4, 4].Fill.Color := gcYellow;

  TMSFNCDataGrid1.Layouts[4, 5].TextAngle := 90;

  TMSFNCDataGrid1.Layouts[2, 3].TextAlign := gtaCenter;
  TMSFNCDataGrid1.Layouts[3, 4].TextAlign := gtaTrailing;

  TMSFNCDataGrid1.Layouts[1, 1].Font.Style := [TFontStyle.fsBold];
  TMSFNCDataGrid1.Layouts[1, 2].Font.Style := [TFontStyle.fsItalic];

  TMSFNCDataGrid1.MergeCells(1,4,2,2);

  TMSFNCDataGrid1.AddBitmap(1,7,'1');
  TMSFNCDataGrid1.AddBitmap(1,8,'2');
  TMSFNCDataGrid1.AddBitmap(1,9,'3');

  TMSFNCDataGrid1.AutoSizeGrid;
  TMSFNCDataGrid1.ColumnWidths[0] := 50;

  TMSFNCDataGrid1.EndUpdate;

  TMSFNCDataGridPDFIO1.Options.OpenInPDFReader := True;
  TMSFNCDataGridPDFIO1.Options.Header := 'TMS FNC Data Grid PDF Export';
end;

procedure TForm130.TMSFNCDataGrid1BeforeDrawCell(Sender: TObject;
  AGraphics: TTMSFNCGraphics; ACell: TTMSFNCDataGridCell;
  var ACanDraw: Boolean);
begin
  if CheckBox1.IsChecked and ACell.IsExporting then
    ACell.DrawElements := [gcdText, gcdStroke];
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

procedure TForm130.TMSFNCDataGridPDFIO1GetFooter(Sender, AExportObject: TObject;
  APageIndex: Integer; var AFooter: string);
begin
  AFooter := 'Page ' + IntToStr(APageIndex + 1);
end;

end.
