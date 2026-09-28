unit UCellControls;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.TMSFNCCustomControl, FMX.TMSFNCTypes,
  FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, System.Rtti,
  FMX.TMSFNCDataGridCell, FMX.TMSFNCDataGridData, FMX.TMSFNCDataGridBase,
  FMX.TMSFNCDataGridCore, FMX.TMSFNCDataGridRenderer, FMX.TMSFNCDataGrid,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCPDFIO, FMX.TMSFNCDataGridPDFIO;

type
  TForm130 = class(TForm)
    TMSFNCDataGrid1: TTMSFNCDataGrid;
    Panel1: TPanel;
    Button1: TButton;
    TMSFNCDataGridPDFIO1: TTMSFNCDataGridPDFIO;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form130: TForm130;

implementation

{$R *.fmx}

uses
  Math;

procedure TForm130.Button1Click(Sender: TObject);
begin
  TMSFNCDataGridPDFIO1.Options.Header := 'Cell Controls';
  TMSFNCDataGridPDFIO1.Options.Footer := '';
  TMSFNCDataGridPDFIO1.Options.OpenInPDFReader := True;
  TMSFNCDataGridPDFIO1.Save('Export.pdf');
end;

procedure TForm130.FormCreate(Sender: TObject);
var
  b: TButton;
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

  b := TButton.Create(Self);
  b.Text := 'Left';
  TMSFNCDataGrid1.Controls[0, 1] := b;
  TMSFNCDataGrid1.ControlAligns[0, 1] := gcaLeft;

  b := TButton.Create(Self);
  b.Text := 'Top';
  TMSFNCDataGrid1.Controls[1, 1] := b;
  TMSFNCDataGrid1.ControlAligns[1, 1] := gcaTop;

  b := TButton.Create(Self);
  b.Text := 'Right';
  TMSFNCDataGrid1.Controls[2, 1] := b;
  TMSFNCDataGrid1.ControlAligns[2, 1] := gcaRight;

  b := TButton.Create(Self);
  b.Text := 'Bottom';
  TMSFNCDataGrid1.Controls[3, 1] := b;
  TMSFNCDataGrid1.ControlAligns[3, 1] := gcaBottom;

  b := TButton.Create(Self);
  b.Text := 'Client';
  TMSFNCDataGrid1.Controls[4, 1] := b;
  TMSFNCDataGrid1.ControlAligns[4, 1] := gcaClient;

  b := TButton.Create(Self);
  b.Text := 'Top Left';
  TMSFNCDataGrid1.Controls[0, 2] := b;
  TMSFNCDataGrid1.ControlPositions[0, 2] := gcpTopLeft;

  b := TButton.Create(Self);
  b.Text := 'Top Center';
  TMSFNCDataGrid1.Controls[1, 2] := b;
  TMSFNCDataGrid1.ControlPositions[1, 2] := gcpTopCenter;

  b := TButton.Create(Self);
  b.Text := 'Top Right';
  TMSFNCDataGrid1.Controls[2, 2] := b;
  TMSFNCDataGrid1.ControlPositions[2, 2] := gcpTopRight;

  b := TButton.Create(Self);
  b.Text := 'Center Left';
  TMSFNCDataGrid1.Controls[0, 3] := b;
  TMSFNCDataGrid1.ControlPositions[0, 3] := gcpCenterLeft;

  b := TButton.Create(Self);
  b.Text := 'Center Center';
  TMSFNCDataGrid1.Controls[1, 3] := b;
  TMSFNCDataGrid1.ControlPositions[1, 3] := gcpCenterCenter;

  b := TButton.Create(Self);
  b.Text := 'Center Right';
  TMSFNCDataGrid1.Controls[2, 3] := b;
  TMSFNCDataGrid1.ControlPositions[2, 3] := gcpCenterRight;

  b := TButton.Create(Self);
  b.Text := 'Bottom Left';
  TMSFNCDataGrid1.Controls[0, 4] := b;
  TMSFNCDataGrid1.ControlPositions[0, 4] := gcpBottomLeft;

  b := TButton.Create(Self);
  b.Text := 'Bottom Center';
  TMSFNCDataGrid1.Controls[1, 4] := b;
  TMSFNCDataGrid1.ControlPositions[1, 4] := gcpBottomCenter;

  b := TButton.Create(Self);
  b.Text := 'Bottom Right';
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
