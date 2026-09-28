unit UFiltering;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  VCL.Controls, VCL.Forms, JS, Web, WEBLib.Graphics, WEBLib.Forms, VCL.Graphics, VCL.Dialogs, VCL.StdCtrls,
  WEBLib.TMSFNCCustomControl,
  WEBLib.TMSFNCCustomScrollControl, WEBLib.TMSFNCDataGridData, WEBLib.TMSFNCCustomGrid,
  WEBLib.TMSFNCDataGrid, WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics,
  WEBLib.TMSFNCGraphicsTypes, WEBLib.TMSFNCDataGridBase, WEBLib.TMSFNCDataGridCell,
  WEBLib.TMSFNCDataGridCore, WEBLib.TMSFNCDataGridRenderer, System.Rtti, Vcl.ExtCtrls,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes,
  VCL.TMSFNCDataGridCell, VCL.TMSFNCDataGridData, VCL.TMSFNCDataGridBase,
  VCL.TMSFNCDataGridCore, VCL.TMSFNCDataGridRenderer, VCL.TMSFNCCustomControl,
  VCL.TMSFNCDataGrid, WEBLib.StdCtrls, WEBLib.Controls, WEBLib.ExtCtrls;

type
  TForm130 = class(TWebForm)
    lblTitle: TWebLabel;
    lblDescription: TWebLabel;
    Panel1: TWebPanel;
    Button1: TWebButton;
    Edit1: TWebEdit;
    Label1: TWebLabel;
    Edit2: TWebEdit;
    Label2: TWebLabel;
    TMSFNCDataGrid1: TTMSFNCDataGrid;
    procedure Button1Click(Sender: TObject);
    procedure Edit1ChangeTracking(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit2ChangeTracking(Sender: TObject);
    procedure TMSFNCDataGrid1GetCellProperties(Sender: TObject;
      ACell: TTMSFNCDataGridCell);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form130: TForm130;

implementation

{$R *.dfm}

procedure TForm130.Button1Click(Sender: TObject);
var
  fltr: TTMSFNCDataGridDataFilterData;
begin
  TMSFNCDataGrid1.Filter.Clear;
  fltr := TMSFNCDataGrid1.Filter.Add;

  fltr.Column := 1;
  fltr.Condition := 'A*';

  Edit1.Text := 'A';

  TMSFNCDataGrid1.ApplyFilter;
end;

procedure TForm130.Edit1ChangeTracking(Sender: TObject);
var
  fltr : TTMSFNCDataGridDataFilterData;
begin
  TMSFNCDataGrid1.ClearFilter;
  fltr := TMSFNCDataGrid1.Filter.Add;

  fltr.Column := 1;
  fltr.CaseSensitive := false;
  fltr.Condition := edit1.Text + '*';

  TMSFNCDataGrid1.ApplyFilter;
end;

procedure TForm130.Edit2ChangeTracking(Sender: TObject);
var
  fltr : TTMSFNCDataGridDataFilterData;
begin
  TMSFNCDataGrid1.ClearFilter;

  fltr := TMSFNCDataGrid1.Filter.Add;

  fltr.Column := 7;
  fltr.CaseSensitive := false;
  fltr.Condition := edit2.Text + '*';

  TMSFNCDataGrid1.ApplyFilter;
end;

procedure TForm130.FormCreate(Sender: TObject);
begin
  TMSFNCDataGrid1.FixedColumnCount := 1;
  TMSFNCDataGrid1.Options.IO.StartRow := 1;
  TMSFNCDataGrid1.Options.IO.StartColumn := 1;
  TMSFNCDataGrid1.LoadFromCSVData('CARS.csv', TEncoding.UTF8);
  TMSFNCDataGrid1.Cells[1,0] := 'Brand';
  TMSFNCDataGrid1.Cells[2,0] := 'Type';
  TMSFNCDataGrid1.Cells[3,0] := 'CC';
  TMSFNCDataGrid1.Cells[4,0] := 'Hp';
  TMSFNCDataGrid1.Cells[5,0] := 'Cyl';
  TMSFNCDataGrid1.Cells[6,0] := 'Kw';
  TMSFNCDataGrid1.Cells[7,0] := 'Price';
  TMSFNCDataGrid1.Cells[8,0] := 'Country';

  TMSFNCDataGrid1.Group([8, 1]);
  TMSFNCDataGrid1.Options.Column.Stretching.Enabled := True;
  TMSFNCDataGrid1.Options.Filtering.Enabled := True;
end;

procedure TForm130.TMSFNCDataGrid1GetCellProperties(Sender: TObject;
  ACell: TTMSFNCDataGridCell);
begin
  if ACell.Column = 0 then
    ACell.FilterButton := False;
end;

end.
