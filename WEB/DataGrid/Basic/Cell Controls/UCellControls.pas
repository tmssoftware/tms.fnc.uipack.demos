unit UCellControls;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  VCL.Controls, VCL.Forms, JS, Web, WEBLib.Graphics, WEBLib.Forms, VCL.Graphics, VCL.Dialogs, VCL.StdCtrls,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCTypes,
  WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes, System.Rtti,
  WEBLib.TMSFNCDataGridCell, WEBLib.TMSFNCDataGridData, WEBLib.TMSFNCDataGridBase,
  WEBLib.TMSFNCDataGridCore, WEBLib.TMSFNCDataGridRenderer, WEBLib.TMSFNCDataGrid,
  WEBLib.TMSFNCCustomComponent,
  Vcl.ExtCtrls, VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics,
  VCL.TMSFNCGraphicsTypes, VCL.TMSFNCDataGridCell, VCL.TMSFNCDataGridData,
  VCL.TMSFNCDataGridBase, VCL.TMSFNCDataGridCore, VCL.TMSFNCDataGridRenderer,
  WEBLib.StdCtrls, VCL.TMSFNCCustomComponent,
  WEBLib.Controls, WEBLib.ExtCtrls,
  VCL.TMSFNCCustomControl, VCL.TMSFNCDataGrid;

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

uses
  Math;

procedure TForm130.FormCreate(Sender: TObject);
var
  b: TWebButton;
  I: Integer;
  g: TTMSFNCDataGridRenderer;
begin
  TMSFNCDataGrid1.BeginUpdate;
  TMSFNCDataGrid1.Clear;
  TMSFNCDataGrid1.ColumnCount := 8;
  TMSFNCDataGrid1.LinearFill();
  TMSFNCDataGrid1.RowHeights[1] := 100;
  TMSFNCDataGrid1.RowHeights[2] := 100;
  TMSFNCDataGrid1.RowHeights[3] := 100;
  TMSFNCDataGrid1.RowHeights[4] := 100;

  b := TWebButton.Create(Self);
  b.Caption := 'Left';
  TMSFNCDataGrid1.Controls[0, 1] := b;
  TMSFNCDataGrid1.ControlAligns[0, 1] := gcaLeft;

  b := TWebButton.Create(Self);
  b.Caption := 'Top';
  TMSFNCDataGrid1.Controls[1, 1] := b;
  TMSFNCDataGrid1.ControlAligns[1, 1] := gcaTop;

  b := TWebButton.Create(Self);
  b.Caption := 'Right';
  TMSFNCDataGrid1.Controls[2, 1] := b;
  TMSFNCDataGrid1.ControlAligns[2, 1] := gcaRight;

  b := TWebButton.Create(Self);
  b.Caption := 'Bottom';
  TMSFNCDataGrid1.Controls[3, 1] := b;
  TMSFNCDataGrid1.ControlAligns[3, 1] := gcaBottom;

  b := TWebButton.Create(Self);
  b.Caption := 'Client';
  TMSFNCDataGrid1.Controls[4, 1] := b;
  TMSFNCDataGrid1.ControlAligns[4, 1] := gcaClient;

  b := TWebButton.Create(Self);
  b.Caption := 'Top Left';
  TMSFNCDataGrid1.Controls[0, 2] := b;
  TMSFNCDataGrid1.ControlPositions[0, 2] := gcpTopLeft;

  b := TWebButton.Create(Self);
  b.Caption := 'Top Center';
  TMSFNCDataGrid1.Controls[1, 2] := b;
  TMSFNCDataGrid1.ControlPositions[1, 2] := gcpTopCenter;

  b := TWebButton.Create(Self);
  b.Caption := 'Top Right';
  TMSFNCDataGrid1.Controls[2, 2] := b;
  TMSFNCDataGrid1.ControlPositions[2, 2] := gcpTopRight;

  b := TWebButton.Create(Self);
  b.Caption := 'Center Left';
  TMSFNCDataGrid1.Controls[0, 3] := b;
  TMSFNCDataGrid1.ControlPositions[0, 3] := gcpCenterLeft;

  b := TWebButton.Create(Self);
  b.Caption := 'Center Center';
  TMSFNCDataGrid1.Controls[1, 3] := b;
  TMSFNCDataGrid1.ControlPositions[1, 3] := gcpCenterCenter;

  b := TWebButton.Create(Self);
  b.Caption := 'Center Right';
  TMSFNCDataGrid1.Controls[2, 3] := b;
  TMSFNCDataGrid1.ControlPositions[2, 3] := gcpCenterRight;

  b := TWebButton.Create(Self);
  b.Caption := 'Bottom Left';
  TMSFNCDataGrid1.Controls[0, 4] := b;
  TMSFNCDataGrid1.ControlPositions[0, 4] := gcpBottomLeft;

  b := TWebButton.Create(Self);
  b.Caption := 'Bottom Center';
  TMSFNCDataGrid1.Controls[1, 4] := b;
  TMSFNCDataGrid1.ControlPositions[1, 4] := gcpBottomCenter;

  b := TWebButton.Create(Self);
  b.Caption := 'Bottom Right';
  TMSFNCDataGrid1.Controls[2, 4] := b;
  TMSFNCDataGrid1.ControlPositions[2, 4] := gcpBottomRight;

  TMSFNCDataGrid1.AddDataProgressBar(0, 5);
  TMSFNCDataGrid1.Ints[0, 5] := 25;
  TMSFNCDataGrid1.AddDataProgressBar(0, 6);
  TMSFNCDataGrid1.Ints[0, 6] := 50;
  TMSFNCDataGrid1.AddDataProgressBar(0, 7);
  TMSFNCDataGrid1.Ints[0, 7] := 75;
  TMSFNCDataGrid1.AddDataProgressBar(0, 8);
  TMSFNCDataGrid1.Ints[0, 8] := 100;

  TMSFNCDataGrid1.AddDataCheckBoxColumn(5);
  TMSFNCDataGrid1.AddRadioButtonColumn(6);

  for I := 0 to TMSFNCDataGrid1.RowCount - 1 do
    TMSFNCDataGrid1.Booleans[5, I] := Boolean(RandomRange(-1, 1));

  TMSFNCDataGrid1.MergeCells(2, 9, 4, 5);

  g := TMSFNCDataGrid1.AddGrid(2, 9);
  g.ColumnCount := 10;
  g.LoadSampleData;

  TMSFNCDataGrid1.Options.Column.Stretching.Enabled := True;
  TMSFNCDataGrid1.EndUpdate;
end;

end.
