unit UPrintIODemo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Types,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VCL.TMSFNCTypes, VCL.TMSFNCUtils,
  VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCDataGridCell,
  VCL.TMSFNCDataGridPrintIO, VCL.TMSFNCCustomControl,
  VCL.TMSFNCCustomScrollControl, VCL.TMSFNCDataGridData, VCL.TMSFNCCustomGrid,
  VCL.TMSFNCDataGrid, VCL.TMSFNCCustomComponent, VCL.TMSFNCPrintIO, Vcl.StdCtrls,
  System.Rtti, VCL.TMSFNCDataGridBase, VCL.TMSFNCDataGridCore,
  VCL.TMSFNCDataGridRenderer;

type
  TForm3 = class(TForm)
    Button1: TButton;
    TMSFNCGraphicsPrintIO1: TTMSFNCGraphicsPrintIO;
    TMSFNCDataGrid1: TTMSFNCDataGrid;
    Button2: TButton;
    TMSFNCDataGridPrintIO1: TTMSFNCDataGridPrintIO;
    PrintDialog1: TPrintDialog;
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
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
var
  r: TRectF;
begin
  if PrintDialog1.Execute then
  begin
    TMSFNCGraphicsPrintIO1.Options.Footer := 'My Footer Text';

    TMSFNCGraphicsPrintIO1.Options.PageNumber := pnHeader;
    TMSFNCGraphicsPrintIO1.Options.PageNumberFormat := 'Page %d';

    r := RectF(TMSFNCGraphicsPrintIO1.Options.Margins.Left, TMSFNCGraphicsPrintIO1.Options.Margins.Top, TMSFNCGraphicsPrintIO1.Options.Margins.Left + TMSFNCDataGrid1.Width, TMSFNCGraphicsPrintIO1.Options.Margins.Top + TMSFNCDataGrid1.Height);
    TMSFNCGraphicsPrintIO1.Print(TMSFNCDataGrid1, r);
  end;
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
  if PrintDialog1.Execute then
  begin
    TMSFNCDataGridPrintIO1.Options.Footer := 'My Footer Text';

    TMSFNCDataGridPrintIO1.Options.PageNumber := pnHeader;
    TMSFNCDataGridPrintIO1.Options.PageNumberFormat := 'Page %d';

    TMSFNCDataGridPrintIO1.Print;
  end;
end;

procedure TForm3.FormCreate(Sender: TObject);
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

procedure TForm3.TMSFNCDataGrid1GetCellLayout(Sender: TObject;
  ACell: TTMSFNCDataGridCell);
begin
  if (ACell.Column = 5) then
  begin
    ACell.Layout.Font.Color := gcRed;
    ACell.Layout.TextAlign := gtaTrailing;
  end;
end;

end.
