unit UFNCUIGrid;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCDataGridCell, FMX.TMSFNCCustomComponent,
  FMX.TMSFNCBitmapContainer, FMX.TMSFNCCustomControl,
  FMX.TMSFNCCustomScrollControl, FMX.TMSFNCDataGridData, FMX.TMSFNCCustomGrid,
  FMX.TMSFNCDataGrid, System.Rtti, FMX.TMSFNCDataGridBase,
  FMX.TMSFNCDataGridCore, FMX.TMSFNCDataGridRenderer;

type
  TForm1 = class(TForm)
    TMSFNCDataGrid1: TTMSFNCDataGrid;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    procedure FormCreate(Sender: TObject);
    procedure TMSFNCDataGrid1AfterDrawCell(Sender: TObject;
      AGraphics: TTMSFNCGraphics; ACell: TTMSFNCDataGridCell);
    procedure TMSFNCDataGrid1BeforeDrawCell(Sender: TObject;
      AGraphics: TTMSFNCGraphics; ACell: TTMSFNCDataGridCell;
      var ACanDraw: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.FormCreate(Sender: TObject);
begin
  TMSFNCDataGrid1.LoadFromCSVData('..\..\grid.csv');
end;

procedure TForm1.TMSFNCDataGrid1AfterDrawCell(Sender: TObject;
  AGraphics: TTMSFNCGraphics; ACell: TTMSFNCDataGridCell);
var
  txt: string;
  r: TRectF;
  v: Integer;
  s: Single;
begin
  if (ACell.Column = 3) and (ACell.Row > 0) then
  begin
    AGraphics.Stroke.Kind := gskNone;

    txt := TMSFNCDataGrid1.Strings[ACell.Column, ACell.Row];

    r := ACell.Rect;
    InflateRectEx(r,-10,-10);

    if txt = 'On Leave' then
      AGraphics.Fill.Color := $FFEF5A5A
    else if txt = 'Flight' then
      AGraphics.Fill.Color := $FFF0C531
    else if txt = 'Abroad' then
        AGraphics.Fill.Color := $FF587EE6
    else if txt = 'Office' then
        AGraphics.Fill.Color := $FF9BEC96;

    AGraphics.DrawRoundRectangle(r);

    AGraphics.Font.Color := gcWhite;
    AGraphics.DrawText(r, txt, False, gtaCenter, gtaCenter);
  end;

  if (ACell.Column = 4) and (ACell.Row > 0) then
  begin
    txt := TMSFNCDataGrid1.Strings[ACell.Column, ACell.Row];
    if txt <> '' then
      v := StrToInt(txt)
    else
      v := 0;

      r := ACell.Rect;
      InflateRectEx(r, -6, -10);

      AGraphics.Fill.Color := $FFDDE8FE;

      AGraphics.DrawRoundRectangle(r, 3);

      s := r.Width * (v / 100);

      if s < 5 then
        s := 5;

      r.Right := r.Left + s;

      AGraphics.Stroke.Kind := gskNone;
      AGraphics.Fill.Color := $FF8DB7FB;
      AGraphics.DrawRoundRectangle(r, 3);
  end;

  if (ACell.Column = 5) and (ACell.Row > 0) then
  begin
    if TMSFNCDataGrid1.Strings[4, ACell.Row] = '100' then
    begin
      AGraphics.Font.Color := $FF5BC659;
    end
    else
    begin
      AGraphics.Font.Color := $FFCD3524;
    end;

    AGraphics.DrawText(ACell.TextRect, '€ ' + TMSFNCDataGrid1.Strings[ACell.Column, ACell.Row], False, gtaTrailing, gtaCenter, gttNone);
  end;
end;

procedure TForm1.TMSFNCDataGrid1BeforeDrawCell(Sender: TObject;
  AGraphics: TTMSFNCGraphics; ACell: TTMSFNCDataGridCell;
  var ACanDraw: Boolean);
begin
  if (ACell.Column = 3) and (ACell.Row > 0) then
    ACell.DrawElements := ACell.DrawElements - [gcdText];

  if (ACell.Column = 4) and (ACell.Row > 0) then
    ACell.DrawElements := ACell.DrawElements - [gcdText];

  if (ACell.Column = 5) and (ACell.Row > 0) then
    ACell.DrawElements := ACell.DrawElements - [gcdText];
end;

end.
