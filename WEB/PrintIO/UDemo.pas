unit UDemo;

interface

uses
  System.SysUtils, System.Classes, JS, Web, WEBLib.Graphics, WEBLib.Controls,
  WEBLib.Forms, WEBLib.Dialogs, WEBLib.TMSFNCPrinters, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  Vcl.Graphics, Vcl.Controls, WEBLib.ExtCtrls, Vcl.StdCtrls, WEBLib.StdCtrls,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes,
  VCL.TMSFNCDataGridCell, VCL.TMSFNCCustomControl,
  VCL.TMSFNCCustomScrollControl, VCL.TMSFNCDataGridData, VCL.TMSFNCCustomGrid,
  VCL.TMSFNCDataGrid, VCL.TMSFNCDataGridPrintIO, VCL.TMSFNCCustomComponent,
  VCL.TMSFNCPrintIO, WEBLib.TMSFNCTypes, System.Rtti, VCL.TMSFNCDataGridBase,
  VCL.TMSFNCDataGridCore, VCL.TMSFNCDataGridRenderer;

type
  TForm1 = class(TWebForm)
    WebButton1: TWebButton;
    WebButton2: TWebButton;
    TMSFNCGraphicsPrintIO1: TTMSFNCGraphicsPrintIO;
    TMSFNCDataGridPrintIO1: TTMSFNCDataGridPrintIO;
    TMSFNCDataGrid1: TTMSFNCDataGrid;
    procedure WebButton1Click(Sender: TObject);
    procedure WebFormCreate(Sender: TObject);
    procedure WebButton2Click(Sender: TObject);
    procedure TMSFNCDataGrid1GetCellLayout(Sender: TObject;
      ACell: TTMSFNCDataGridCell);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{ TForm1 }
procedure TForm1.TMSFNCDataGrid1GetCellLayout(Sender: TObject;
  ACell: TTMSFNCDataGridCell);
begin
  if (ACell.Column = 5) then
  begin
    ACell.Layout.Font.Color := gcRed;
    ACell.Layout.TextAlign := gtaTrailing;
  end;
end;

procedure TForm1.WebButton1Click(Sender: TObject);
var
  r: TRectF;
begin
  TMSFNCGraphicsPrintIO1.Options.Footer := 'My Footer Text';

  TMSFNCGraphicsPrintIO1.Options.PageNumber := pnHeader;
  TMSFNCGraphicsPrintIO1.Options.PageNumberFormat := 'Page %d';

  r := RectF(TMSFNCGraphicsPrintIO1.Options.Margins.Left, TMSFNCGraphicsPrintIO1.Options.Margins.Top, TMSFNCGraphicsPrintIO1.Options.Margins.Left + TMSFNCDataGrid1.Width, TMSFNCGraphicsPrintIO1.Options.Margins.Top + TMSFNCDataGrid1.Height);
  TMSFNCGraphicsPrintIO1.Print(TMSFNCDataGrid1, r);
end;

procedure TForm1.WebButton2Click(Sender: TObject);
begin
  TMSFNCDataGridPrintIO1.Options.Header := 'My Header Text';

  TMSFNCDataGridPrintIO1.Options.PageNumber := pnHeader;
  TMSFNCDataGridPrintIO1.Options.PageNumberFormat := 'Page %d';

  TMSFNCDataGridPrintIO1.Print;
end;

procedure TForm1.WebFormCreate(Sender: TObject);
begin
  TMSFNCDataGrid1.ColumnCount := 6;
  TMSFNCDataGrid1.RandomFill;
  TMSFNCDataGrid1.AutoNumberColumn(0);
  TMSFNCDataGrid1.Colors[2,2] := gcRed;
  TMSFNCDataGrid1.Colors[3,3] := gcLime;
  TMSFNCDataGrid1.Colors[4,4] := gcYellow;

  TMSFNCDataGrid1.TextAligns[2,3] := gtaCenter;
  TMSFNCDataGrid1.TextAligns[3,4] := gtaTrailing;

  TMSFNCDataGrid1.FontStyles[1,1] := [TFontStyle.fsBold];
  TMSFNCDataGrid1.FontStyles[1,2] := [TFontStyle.fsItalic];

  TMSFNCDataGrid1.MergeCells(1,4,2,2);

  TMSFNCDataGrid1.AddBitmap(1,7,'1');
  TMSFNCDataGrid1.AddBitmap(1,8,'2');
  TMSFNCDataGrid1.AddBitmap(1,9,'3');

  TMSFNCDataGridPrintIO1.DataGrid := TMSFNCDataGrid1;
end;

end.