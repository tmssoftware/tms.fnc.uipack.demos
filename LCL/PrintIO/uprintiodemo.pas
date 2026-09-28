unit uPrintIODemo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  LCLTMSFNCGraphicsTypes, LCLTMSFNCGridPrintIO,
  LCLTMSFNCPrintIO, LCLTMSFNCGrid, LCLTMSFNCGridData, LCLTMSFNCGridCell,
  LCLTMSFNCCustomGrid, LCLTMSFNCTypes, PrintersDlgs;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    PrintDialog1: TPrintDialog;
    TMSFNCGraphicsPrintIO1: TTMSFNCGraphicsPrintIO;
    TMSFNCGrid1: TTMSFNCGrid;
    TMSFNCGridPrintIO1: TTMSFNCGridPrintIO;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TMSFNCGrid1GetCellLayout(Sender: TObject; ACol, ARow: Integer;
      ALayout: TTMSFNCGridCellLayout; ACellState: TTMSFNCGridCellState);
  private
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }
 procedure TForm1.Button1Click(Sender: TObject);
 var
   r: TRectF;
 begin
   if PrintDialog1.Execute then
   begin
     TMSFNCGraphicsPrintIO1.Options.Footer := 'My Footer Text';

     TMSFNCGraphicsPrintIO1.Options.PageNumber := pnHeader;
     TMSFNCGraphicsPrintIO1.Options.PageNumberFormat := 'Page %d';

     r := RectF(TMSFNCGraphicsPrintIO1.Options.Margins.Left, TMSFNCGraphicsPrintIO1.Options.Margins.Top, TMSFNCGraphicsPrintIO1.Options.Margins.Left + TMSFNCGrid1.Width, TMSFNCGraphicsPrintIO1.Options.Margins.Top + TMSFNCGrid1.Height);
     TMSFNCGraphicsPrintIO1.Print(TMSFNCGrid1, r);
   end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if PrintDialog1.Execute then
  begin
    TMSFNCGridPrintIO1.Options.Footer := 'My Footer Text';

    TMSFNCGridPrintIO1.Options.PageNumber := pnHeader;
    TMSFNCGridPrintIO1.Options.PageNumberFormat := 'Page %d';

    TMSFNCGridPrintIO1.Print;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  TMSFNCGrid1.ColumnCount := 6;
  TMSFNCGrid1.RandomFill;
  TMSFNCGrid1.AutoNumberCol(0);
  TMSFNCGrid1.Colors[2,2] := gcRed;
  TMSFNCGrid1.Colors[3,3] := gcLime;
  TMSFNCGrid1.Colors[4,4] := gcYellow;

  TMSFNCGrid1.HorzAlignments[2,3] := gtaCenter;
  TMSFNCGrid1.HorzAlignments[3,4] := gtaTrailing;

  TMSFNCGrid1.FontStyles[1,1] := [TFontStyle.fsBold];
  TMSFNCGrid1.FontStyles[1,2] := [TFontStyle.fsItalic];

  TMSFNCGrid1.MergeCells(1,4,2,2);

  TMSFNCGrid1.AddBitmap(1,7,'1');
  TMSFNCGrid1.AddBitmap(1,8,'2');
  TMSFNCGrid1.AddBitmap(1,9,'3');

  TMSFNCGridPrintIO1.Grid := TMSFNCGrid1;
  TMSFNCGraphicsPrintIO1 := TTMSFNCGraphicsPrintIO.Create(Self);
end;

procedure TForm1.TMSFNCGrid1GetCellLayout(Sender: TObject; ACol, ARow: Integer;
  ALayout: TTMSFNCGridCellLayout; ACellState: TTMSFNCGridCellState);
begin
  if (ACol = 5) then
  begin
    ALayout.Font.Color := gcRed;
    ALayout.TextAlign := gtaTrailing;
  end;
end;


end.



