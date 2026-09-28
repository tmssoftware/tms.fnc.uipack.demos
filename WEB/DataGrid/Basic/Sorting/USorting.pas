unit USorting;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  VCL.Controls, VCL.Forms, JS, Web, WEBLib.Graphics, WEBLib.Forms, VCL.Graphics, VCL.Dialogs, VCL.StdCtrls,
  WEBLib.TMSFNCCustomControl,
  WEBLib.TMSFNCCustomScrollControl, WEBLib.TMSFNCDataGridData, WEBLib.TMSFNCCustomGrid,
  WEBLib.TMSFNCDataGrid, WEBLib.TMSFNCTypes,
  WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCDataGridBase, WEBLib.TMSFNCDataGridCell, WEBLib.TMSFNCDataGridCore,
  WEBLib.TMSFNCDataGridRenderer, System.Rtti, VCL.TMSFNCTypes, VCL.TMSFNCUtils,
  VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCDataGridCell,
  VCL.TMSFNCDataGridData, VCL.TMSFNCDataGridBase, VCL.TMSFNCDataGridCore,
  VCL.TMSFNCDataGridRenderer, WEBLib.StdCtrls, VCL.TMSFNCCustomControl,
  VCL.TMSFNCDataGrid;

type
  TForm130 = class(TWebForm)
    lblTitle: TWebLabel;
    lblDescription: TWebLabel;
    TMSFNCDataGrid1: TTMSFNCDataGrid;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form130: TForm130;

implementation

{$R *.dfm}

procedure TForm130.FormCreate(Sender: TObject);
begin
  TMSFNCDataGrid1.Options.IO.StartColumn := 1;
  TMSFNCDataGrid1.Options.IO.StartRow := 1;
  TMSFNCDataGrid1.LoadFromCSVData('CARS.csv', TEncoding.UTF8);
  TMSFNCDataGrid1.Cells[0,0] := 'ID';
  TMSFNCDataGrid1.Cells[1,0] := 'Brand';
  TMSFNCDataGrid1.Cells[2,0] := 'Type';
  TMSFNCDataGrid1.Cells[3,0] := 'CC';
  TMSFNCDataGrid1.Cells[4,0] := 'Hp';
  TMSFNCDataGrid1.Cells[5,0] := 'Cyl';
  TMSFNCDataGrid1.Cells[6,0] := 'Kw';
  TMSFNCDataGrid1.Cells[7,0] := 'Price';
  TMSFNCDataGrid1.Cells[8,0] := 'Country';
  TMSFNCDataGrid1.AutoNumberColumn(0, 1);

  TMSFNCDataGrid1.Options.Sorting.Enabled := True;
  TMSFNCDataGrid1.Sort(1, gsdAscending);
end;

end.
