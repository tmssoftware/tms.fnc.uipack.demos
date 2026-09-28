unit Uspreadgriddemo;

interface

uses
  windows, System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCCustomControl,
  FMX.TMSFNCCustomScrollControl, FMX.TMSFNCGridData, FMX.TMSFNCCustomGrid,
  FMX.TMSFNCGrid, FMX.TMSFNCSpreadGrid, FMX.StdCtrls, FMX.Controls.Presentation;

type
  TForm2 = class(TForm)
    TMSFNCSpreadGrid1: TTMSFNCSpreadGrid;
    ckShowFormula: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    ckNameMode: TCheckBox;
    Button3: TButton;
    Button4: TButton;
    StatusBar1: TStatusBar;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ckNameModeChange(Sender: TObject);
    procedure ckShowFormulaChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure TMSFNCSpreadGrid1CalcCustomFunction(sender: TObject;
      var func: string; var param: Double);
    procedure TMSFNCSpreadGrid1IsCustomFunction(sender: TObject;
      var func: string; var match: Boolean);
    procedure Button4Click(Sender: TObject);
    procedure TMSFNCSpreadGrid1FormulaError(Sender: TObject; ACol, ARow,
      ErrType, ErrPos, ErrParam: Integer; ErrStr: string);
    procedure TMSFNCSpreadGrid1CellEditValidateData(Sender: TObject; ACol,
      ARow: Integer; CellEditor: TControl; var CellString: string;
      var Allow: Boolean);
    procedure TMSFNCSpreadGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var Allow: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

procedure TForm2.Button1Click(Sender: TObject);
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

procedure TForm2.Button2Click(Sender: TObject);
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

procedure TForm2.Button3Click(Sender: TObject);
begin
  TMSFNCSpreadGrid1.CellNameMode := nmA1;
  TMSFNCSpreadGrid1.ClearNormalCells;
  TMSFNCSpreadGrid1.LoadFromCSV('.\spread.csv');
end;

procedure TForm2.Button4Click(Sender: TObject);
begin
  TMSFNCSpreadGrid1.ClearNormalCells;
end;

procedure TForm2.ckNameModeChange(Sender: TObject);
begin
  if TMSFNCSpreadGrid1.CellNameMode = nmA1 then
  begin
    TMSFNCSpreadGrid1.CellNameMode := nmRC;
    ckNameMode.Text := 'A1 cell name mode';
  end
  else
  begin
    TMSFNCSpreadGrid1.CellNameMode := nmA1;
    ckNameMode.Text := 'RC cell name mode';
  end;
end;

procedure TForm2.ckShowFormulaChange(Sender: TObject);
begin
  TMSFNCSpreadGrid1.ShowFormula := ckShowFormula.IsChecked;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  FormatSettings.DecimalSeparator := '.';
  FormatSettings.ThousandSeparator := ',';
  TMSFNCSpreadGrid1.SetFocus;
  TMSFNCSpreadGrid1.DefaultColumnWidth := 96;
end;

procedure TForm2.TMSFNCSpreadGrid1CalcCustomFunction(sender: TObject;
  var func: string; var param: Double);
begin
  if func = 'BFS' then
    param := param * 2;
  if func = 'SELECT' then
    param := 125;
end;

procedure TForm2.TMSFNCSpreadGrid1CellEditValidateData(Sender: TObject; ACol,
  ARow: Integer; CellEditor: TControl; var CellString: string;
  var Allow: Boolean);
begin
  Label1.Text := CellString;
end;

procedure TForm2.TMSFNCSpreadGrid1FormulaError(Sender: TObject; ACol, ARow,
  ErrType, ErrPos, ErrParam: Integer; ErrStr: string);
begin
  Label1.Text := 'Error at: ' + IntToStr(ACol)+':'+IntToStr(ARow)+' position ' + InttoStr(ErrPos) + ' ' + ErrStr;
end;

procedure TForm2.TMSFNCSpreadGrid1IsCustomFunction(sender: TObject;
  var func: string; var match: Boolean);
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

procedure TForm2.TMSFNCSpreadGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var Allow: Boolean);
begin
  Label1.Text := TMSFNCSpreadGrid1.Cells[ACol,ARow];
end;

end.
