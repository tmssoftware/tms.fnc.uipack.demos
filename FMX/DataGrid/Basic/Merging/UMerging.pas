unit UMerging;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.TMSFNCCustomControl,
  FMX.TMSFNCCustomScrollControl, FMX.TMSFNCDataGridData, FMX.TMSFNCCustomGrid,
  FMX.TMSFNCDataGrid, FMX.TMSFNCTypes,
  FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCDataGridBase, FMX.TMSFNCDataGridCell, FMX.TMSFNCDataGridCore,
  FMX.TMSFNCDataGridRenderer, System.Rtti;

type
  TForm130 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    TMSFNCDataGrid1: TTMSFNCDataGrid;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form130: TForm130;

implementation

{$R *.fmx}

procedure TForm130.Button1Click(Sender: TObject);
begin
  TMSFNCDataGrid1.MergeRange(TMSFNCDataGrid1.Selection);
end;

procedure TForm130.Button2Click(Sender: TObject);
begin
  TMSFNCDataGrid1.SplitCell(TMSFNCDataGrid1.Selection.StartCell);
end;

procedure TForm130.FormCreate(Sender: TObject);
begin
  TMSFNCDataGrid1.FixedColumnCount := 1;
  TMSFNCDataGrid1.Options.IO.StartRow := 1;
  TMSFNCDataGrid1.Options.IO.StartColumn := 1;
  TMSFNCDataGrid1.LoadFromCSVData('CARS.csv');
  TMSFNCDataGrid1.Sort(1, gsdAscending);
  TMSFNCDataGrid1.Cells[1,0] := 'Brand';
  TMSFNCDataGrid1.Cells[2,0] := 'Type';
  TMSFNCDataGrid1.Cells[3,0] := 'CC';
  TMSFNCDataGrid1.Cells[4,0] := 'Hp';
  TMSFNCDataGrid1.Cells[5,0] := 'Cyl';
  TMSFNCDataGrid1.Cells[6,0] := 'Kw';
  TMSFNCDataGrid1.Cells[7,0] := 'Price';
  TMSFNCDataGrid1.Cells[8,0] := 'Country';
  TMSFNCDataGrid1.Options.Sorting.Enabled := True;
  TMSFNCDataGrid1.Options.Selection.Mode := gsmCellRange;
  TMSFNCDataGrid1.MergeCells(3, 3, 3, 3);
  TMSFNCDataGrid1.MergeCells(7, 10, 2, 4);
end;

end.
