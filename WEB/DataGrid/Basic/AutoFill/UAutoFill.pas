unit UAutoFill;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  VCL.Controls, VCL.Forms, JS, Web, WEBLib.Graphics, WEBLib.Forms, VCL.Graphics,
  VCL.Dialogs, VCL.StdCtrls, WEBLib.StdCtrls, WEBLib.TMSFNCCustomControl,
  WEBLib.TMSFNCCustomScrollControl, WEBLib.TMSFNCDataGridData,
  WEBLib.TMSFNCCustomGrid, WEBLib.TMSFNCDataGrid, WEBLib.TMSFNCTypes,
  WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCDataGridBase, WEBLib.TMSFNCDataGridCell, WEBLib.TMSFNCDataGridCore,
  WEBLib.TMSFNCDataGridRenderer, VCL.TMSFNCTypes, VCL.TMSFNCUtils,
  VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCDataGridCell,
  VCL.TMSFNCDataGridData, VCL.TMSFNCDataGridBase, VCL.TMSFNCDataGridCore,
  VCL.TMSFNCDataGridRenderer, VCL.TMSFNCCustomControl, VCL.TMSFNCDataGrid,
  System.Rtti;

type
  TFormAutoFill = class(TWebForm)
    lblTitle: TWebLabel;
    lblDescription: TWebLabel;
    TMSFNCDataGrid1: TTMSFNCDataGrid;
    procedure FormCreate(Sender: TObject);
  private
    procedure SetupGrid;
    procedure SetupCustomLists;
    procedure LoadDemoData;
    procedure HandleAutoFillGetCustomList(Sender: TObject;
      BaseValue: string; var Values: TArray<string>; var Handled: Boolean);
    procedure HandleAutoFillCalculateValue(Sender: TObject;
      SourceCells: TTMSFNCDataGridCellCoordRange;
      SourceValues: TArray<TTMSFNCDataGridCellValue>;
      TargetCells: TTMSFNCDataGridCellCoordRange;
      FillIndex: Integer;
      Direction: TTMSFNCDataGridDataAutoFillDirection;
      var NewValue: TTMSFNCDataGridCellValue;
      var Handled: Boolean);
  public
  end;

var
  FormAutoFill: TFormAutoFill;

implementation

{$R *.dfm}

procedure TFormAutoFill.FormCreate(Sender: TObject);
begin
  lblTitle.Caption := 'TMS FNC DataGrid AutoFill Demo';
  lblDescription.Caption := 'Select cells with seed values (rows 1-2), then drag the fill handle to auto-fill. Patterns: numbers, dates, times, days, custom lists.';

  SetupGrid;
  SetupCustomLists;
  LoadDemoData;
end;

procedure TFormAutoFill.SetupGrid;
begin
  TMSFNCDataGrid1.Options.Selection.Mode := gsmCellRange;
  TMSFNCDataGrid1.Options.Selection.AutoFill := True;

  TMSFNCDataGrid1.DefaultColumnWidth := 110;
  TMSFNCDataGrid1.DefaultRowHeight := 24;
  TMSFNCDataGrid1.Options.Column.Stretching.Enabled := True;

  TMSFNCDataGrid1.OnAutoFillGetCustomList := HandleAutoFillGetCustomList;
  TMSFNCDataGrid1.OnAutoFillCalculateValue := HandleAutoFillCalculateValue;
end;

procedure TFormAutoFill.SetupCustomLists;
begin
  TMSFNCDataGrid1.AutoFillCustomListSet('StatusList',
    ['TODO', 'In Progress', 'Review', 'Done']);

  TMSFNCDataGrid1.AutoFillCustomListSet('PriorityList',
    ['Low', 'Medium', 'High', 'Critical']);

  TMSFNCDataGrid1.AutoFillCustomListSet('QuarterList',
    ['Q1', 'Q2', 'Q3', 'Q4']);

  TMSFNCDataGrid1.AutoFillCustomListSet('RatingList',
    ['Poor', 'Fair', 'Good', 'Excellent']);
end;

procedure TFormAutoFill.LoadDemoData;
begin
  TMSFNCDataGrid1.BeginUpdate;
  try
    TMSFNCDataGrid1.ClearData;
    TMSFNCDataGrid1.ColumnCount := 9;
    TMSFNCDataGrid1.RowCount := 20;
    TMSFNCDataGrid1.FixedRowCount := 1;
    TMSFNCDataGrid1.FixedColumnCount := 0;

    TMSFNCDataGrid1.Cells[0, 0] := 'Numbers';
    TMSFNCDataGrid1.Cells[1, 0] := 'Floats';
    TMSFNCDataGrid1.Cells[2, 0] := 'Dates';
    TMSFNCDataGrid1.Cells[3, 0] := 'Times';
    TMSFNCDataGrid1.Cells[4, 0] := 'Days';
    TMSFNCDataGrid1.Cells[5, 0] := 'Status';
    TMSFNCDataGrid1.Cells[6, 0] := 'Priority';
    TMSFNCDataGrid1.Cells[7, 0] := 'Item Code';
    TMSFNCDataGrid1.Cells[8, 0] := 'Letters';

    TMSFNCDataGrid1.Cells[0, 1] := 1;
    TMSFNCDataGrid1.Cells[0, 2] := 2;

    TMSFNCDataGrid1.Cells[1, 1] := 10.5;
    TMSFNCDataGrid1.Cells[1, 2] := 11.0;

    TMSFNCDataGrid1.Cells[2, 1] := '2026-01-01';
    TMSFNCDataGrid1.Cells[2, 2] := '2026-01-02';

    TMSFNCDataGrid1.Cells[3, 1] := '09:00';
    TMSFNCDataGrid1.Cells[3, 2] := '09:15';

    TMSFNCDataGrid1.Cells[4, 1] := 'Monday';
    TMSFNCDataGrid1.Cells[4, 2] := 'Tuesday';

    TMSFNCDataGrid1.Cells[5, 1] := 'TODO';
    TMSFNCDataGrid1.Cells[5, 2] := 'In Progress';

    TMSFNCDataGrid1.Cells[6, 1] := 'Low';
    TMSFNCDataGrid1.Cells[6, 2] := 'Medium';

    TMSFNCDataGrid1.Cells[7, 1] := 'ITEM-001';
    TMSFNCDataGrid1.Cells[7, 2] := 'ITEM-002';

    TMSFNCDataGrid1.Cells[8, 1] := 'a';
    TMSFNCDataGrid1.Cells[8, 2] := 'b';

  finally
    TMSFNCDataGrid1.EndUpdate;
  end;
end;

procedure TFormAutoFill.HandleAutoFillGetCustomList(Sender: TObject;
  BaseValue: string; var Values: TArray<string>; var Handled: Boolean);
begin
  if SameText(BaseValue, 'Sales') or SameText(BaseValue, 'Marketing') or
     SameText(BaseValue, 'Engineering') or SameText(BaseValue, 'Support') or
     SameText(BaseValue, 'HR') then
  begin
    Values := ['Sales', 'Marketing', 'Engineering', 'Support', 'HR'];
    Handled := True;
  end;
end;

procedure TFormAutoFill.HandleAutoFillCalculateValue(Sender: TObject;
  SourceCells: TTMSFNCDataGridCellCoordRange;
  SourceValues: TArray<TTMSFNCDataGridCellValue>;
  TargetCells: TTMSFNCDataGridCellCoordRange;
  FillIndex: Integer;
  Direction: TTMSFNCDataGridDataAutoFillDirection;
  var NewValue: TTMSFNCDataGridCellValue;
  var Handled: Boolean);
var
  i: Integer;
  allSingleLetters: Boolean;
  step: Integer;
  lastChar: Char;
  newChar: Integer;
  s: string;
begin
  Handled := False;

  if Length(SourceValues) < 2 then
    Exit;

  allSingleLetters := True;
  for i := 0 to High(SourceValues) do
  begin
    s := TTMSFNCDataGridData.ValueToString(SourceValues[i]);
    if (Length(s) <> 1) or not CharInSet(s[1], TTMSFNCUtils.AlphaCharSet) then
    begin
      allSingleLetters := False;
      Break;
    end;
  end;

  if not allSingleLetters then
    Exit;

  step := Ord(TTMSFNCDataGridData.ValueToString(SourceValues[1])[1]) - Ord(TTMSFNCDataGridData.ValueToString(SourceValues[0])[1]);

  lastChar := TTMSFNCDataGridData.ValueToString(SourceValues[High(SourceValues)])[1];
  newChar := Ord(lastChar) + (FillIndex * step);

  if newChar > Ord('z') then
    newChar := Ord('a') + ((newChar - Ord('a')) mod 26)
  else if newChar < Ord('a') then
    newChar := Ord('z') - ((Ord('a') - newChar - 1) mod 26);

  NewValue := Char(newChar);
  Handled := True;
end;

end.
