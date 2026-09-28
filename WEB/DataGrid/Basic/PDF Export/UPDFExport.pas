unit UPDFExport;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  VCL.Controls, VCL.Forms, JS, Web, WEBLib.Graphics, WEBLib.Forms, VCL.Graphics, VCL.Dialogs, VCL.StdCtrls,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCTypes,
  WEBLib.TMSFNCUtils, WEBLib.TMSFNCPDFIO, WEBLib.TMSFNCDataGridPDFIO,
  WEBLib.TMSFNCCustomComponent, WEBLib.TMSFNCBitmapContainer,
  WEBLib.TMSFNCCustomScrollControl, WEBLib.TMSFNCDataGridData, WEBLib.TMSFNCCustomGrid,
  WEBLib.TMSFNCDataGrid, WEBLib.TMSFNCDataGridCell, WEBLib.TMSFNCGraphics,
  WEBLib.TMSFNCGraphicsTypes, WEBLib.TMSFNCDataGridBase, WEBLib.TMSFNCDataGridCore,
  WEBLib.TMSFNCDataGridRenderer, System.Rtti, Vcl.ExtCtrls, VCL.TMSFNCTypes,
  VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes,
  VCL.TMSFNCDataGridCell, VCL.TMSFNCDataGridData, VCL.TMSFNCDataGridBase,
  VCL.TMSFNCDataGridCore, VCL.TMSFNCDataGridRenderer, WEBLib.StdCtrls,
  VCL.TMSFNCPDFIO, VCL.TMSFNCDataGridPDFIO, VCL.TMSFNCCustomComponent,
  VCL.TMSFNCBitmapContainer, WEBLib.Controls, WEBLib.ExtCtrls,
  VCL.TMSFNCCustomControl, VCL.TMSFNCDataGrid;

type
  TForm130 = class(TWebForm)
    lblTitle: TWebLabel;
    lblDescription: TWebLabel;
    TMSFNCDataGrid1: TTMSFNCDataGrid;
    Panel1: TWebPanel;
    Button2: TWebButton;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    TMSFNCDataGridPDFIO1: TTMSFNCDataGridPDFIO;
    CheckBox1: TWebCheckBox;
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
    procedure DoFontCacheReady(Sender: TObject);
  end;

var
  Form130: TForm130;

implementation

uses
  WEBLib.TMSFNCPDFLib;

{$R *.dfm}

procedure TForm130.Button2Click(Sender: TObject);
begin
  TMSFNCDataGridPDFIO1.Options.DefaultFont.Name := 'Roboto';
  TMSFNCDataGridPDFIO1.Options.HeaderFont.Name := 'Roboto';
  TMSFNCDataGridPDFIO1.Options.FooterFont.Name := 'Roboto';
  TMSFNCDataGridPDFIO1.Options.PageNumberFont.Name := 'Roboto';
  TMSFNCDataGridPDFIO1.Options.FontFallBackList.Insert(0, 'Roboto');

  TMSFNCDataGridPDFIO1.Save('gridexport.pdf');
end;

procedure TForm130.DoFontCacheReady(Sender: TObject);
begin
  Button2.Enabled := True;
end;

procedure TForm130.FormCreate(Sender: TObject);
begin
  Application.OnFontCacheReady := DoFontCacheReady;
  AddFontToCache('https://download.tmssoftware.com/tmsweb/pdf/fonts/Roboto-Regular.ttf');
  AddFontToCache('https://download.tmssoftware.com/tmsweb/pdf/fonts/Roboto-Bold.ttf');
  AddFontToCache('https://download.tmssoftware.com/tmsweb/pdf/fonts/Roboto-BoldItalic.ttf');
  AddFontToCache('https://download.tmssoftware.com/tmsweb/pdf/fonts/Roboto-Italic.ttf');

  TMSFNCDataGrid1.BeginUpdate;
  TMSFNCDataGrid1.GlobalFont.Name := 'Roboto';
  TMSFNCDataGrid1.ColumnCount := 10;
  TMSFNCDataGrid1.LoadSampleData;
  TMSFNCDataGrid1.AutoNumberColumn(0);

  TMSFNCDataGrid1.Layouts[2, 2].Font.Name := 'Roboto';
  TMSFNCDataGrid1.Layouts[2, 2].Fill.Color := gcRed;

  TMSFNCDataGrid1.Layouts[3, 3].Font.Name := 'Roboto';
  TMSFNCDataGrid1.Layouts[3, 3].Fill.Color := gcLime;

  TMSFNCDataGrid1.Layouts[4, 4].Font.Name := 'Roboto';
  TMSFNCDataGrid1.Layouts[4, 4].Fill.Color := gcYellow;

  TMSFNCDataGrid1.Layouts[4, 5].Font.Name := 'Roboto';
  TMSFNCDataGrid1.Layouts[4, 5].TextAngle := 90;

  TMSFNCDataGrid1.Layouts[2, 3].Font.Name := 'Roboto';
  TMSFNCDataGrid1.Layouts[2, 3].TextAlign := gtaCenter;

  TMSFNCDataGrid1.Layouts[3, 4].Font.Name := 'Roboto';
  TMSFNCDataGrid1.Layouts[3, 4].TextAlign := gtaTrailing;

  TMSFNCDataGrid1.Layouts[1, 1].Font.Name := 'Roboto';
  TMSFNCDataGrid1.Layouts[1, 1].Font.Style := [TFontStyle.fsBold];

  TMSFNCDataGrid1.Layouts[1, 2].Font.Name := 'Roboto';
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
  if CheckBox1.Checked and ACell.IsExporting then
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
