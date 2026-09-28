unit uspreadgriddemo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, LCLTMSFNCSpreadGrid, LCLTMSFNCFormulaParser, LCLTMSFNCCustomGrid;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    ckNameMode: TCheckBox;
    ckShowFormula: TCheckBox;
    StatusBar1: TStatusBar;
    TMSFNCSpreadGrid1: TTMSFNCSpreadGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ckNameModeChange(Sender: TObject);
    procedure ckShowFormulaChange(Sender: TObject);
    procedure TMSFNCSpreadGrid1CalcCustomFunction(sender: TObject;
      var func: string; var param: double);
    procedure TMSFNCSpreadGrid1FormulaError(Sender: TObject; ACol,
      ARow: Integer; ErrType, ErrPos, ErrParam: Integer; ErrStr: string);
    procedure TMSFNCSpreadGrid1IsCustomFunction(sender: TObject;
      var func: string; var match: boolean);
    procedure TMSFNCSpreadGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var Allow: Boolean);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button2Click(Sender: TObject);
begin
  TMSFNCSpreadGrid1.CellNameMode := nmA1;
  TMSFNCSpreadGrid1.ClearNormalCells;
  TMSFNCSpreadGrid1.LoadFromCSV('.\spread.csv');
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  with TMSFNCSpreadgrid1 do
  begin
    ClearNormalCells;
    CellNameMode := nmRC;
    Cells[1,1] := 'Price';
    Cells[1,2] := 'Tax';
    Floats[2,1] := 100;
    Floats[2,2] := 15;
    CellName[2,1] := 'PRICE';
    CellName[2,2] := 'TAX';
    Cells[2,3] := '=PRICE+(PRICE*TAX/100)';
    Floats[3,1] := 100;
    Floats[3,2] := 15;
    Cells[3,3] := '=R1C3+(R1C3*R2C3/100)';
    Recalc;
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  i: Integer;
  COUNT: Integer;

begin
  COUNT := 100;

  with TMSFNCSpreadGrid1 do
  begin
    BeginUpdate;
    RowCount := COUNT + 1;
    ClearNormalCells;
    AutoRecalc := False;
    CellNameMode := nmRC;
    for i := 1 to COUNT do
    begin
      Floats[1,i] := i;
      Cells[2,i] := '=SUM(R'+IntToStr(i)+'C1:R'+IntToStr(COUNT)+'C1)';
      Cells[3,i] := '=AVERAGE(R'+IntToStr(i)+'C1:R'+IntToStr(COUNT)+'C1)';
      Cells[4,i] := '=MIN(R'+IntToStr(i)+'C1:R'+IntToStr(COUNT)+'C1)';
      Cells[5,i] := '=MAX(R'+IntToStr(i)+'C1:R'+IntToStr(COUNT)+'C1)';
      if i < Count then
        Cells[6,i] := '=STDEV(R'+IntToStr(i)+'C1:R'+IntToStr(COUNT)+'C1)';
    end;

    InsertRows(1,1);
    AutoHeaders := True;
    Cells[2,1] := 'SUM';
    Cells[3,1] := 'AVERAGE';
    Cells[4,1] := 'MIN';
    Cells[5,1] := 'MAX';
    Cells[6,1] := 'STDEV';

    ReCalc;
    AutoRecalc := True;
    EndUpdate;
  end;
end;

procedure TForm1.ckNameModeChange(Sender: TObject);
begin
  if TMSFNCSpreadGrid1.CellNameMode = nmA1 then
  begin
    TMSFNCSpreadGrid1.CellNameMode := nmRC;
    ckNameMode.Caption := 'A1 cell name mode';
  end
  else
  begin
    TMSFNCSpreadGrid1.CellNameMode := nmA1;
    ckNameMode.Caption := 'RC cell name mode';
  end;
end;

procedure TForm1.ckShowFormulaChange(Sender: TObject);
begin
  TMSFNCSpreadGrid1.ShowFormula := ckShowFormula.Checked;
end;

procedure TForm1.TMSFNCSpreadGrid1CalcCustomFunction(sender: TObject;
  var func: string; var param: double);
begin
  if func = 'BFS' then
    param := param * 2;
  if func = 'SELECT' then
    param := 125;

end;

procedure TForm1.TMSFNCSpreadGrid1FormulaError(Sender: TObject; ACol,
  ARow: Integer; ErrType, ErrPos, ErrParam: Integer; ErrStr: string);
begin
  Statusbar1.SimpleText := 'Error at: ' + IntToStr(ACol)+':'+IntToStr(ARow)+' position ' + InttoStr(ErrPos) + ' ' + ErrStr;
end;

procedure TForm1.TMSFNCSpreadGrid1IsCustomFunction(sender: TObject;
  var func: string; var match: boolean);
begin
  match := Pos('BFS',func) = 1;
  if match then
    func := 'BFS'
  else
  begin
    match := Pos('SELECT',func) = 1;
    if match then
      func := 'SELECT';
  end;
end;

procedure TForm1.TMSFNCSpreadGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var Allow: Boolean);
begin
  StatusBar1.SimpleText := TMSFNCSpreadGrid1.Cells[ACol,ARow];
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  TMSFNCSpreadGrid1.ClearNormalCells;
end;

end.

