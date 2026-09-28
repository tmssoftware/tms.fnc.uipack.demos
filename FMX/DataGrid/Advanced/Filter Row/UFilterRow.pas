unit UFilterRow;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.TMSFNCCustomControl,
  FMX.TMSFNCCustomScrollControl, FMX.TMSFNCDataGridData, FMX.TMSFNCCustomGrid,
  FMX.TMSFNCDataGrid, FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics,
  FMX.TMSFNCGraphicsTypes, FMX.TMSFNCDataGridBase, FMX.TMSFNCDataGridCell,
  FMX.TMSFNCDataGridCore, FMX.TMSFNCDataGridRenderer, System.Rtti, FMX.ListBox;

type
  TForm130 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Edit2: TEdit;
    Label2: TLabel;
    TMSFNCDataGrid1: TTMSFNCDataGrid;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    ComboBox1: TComboBox;
    procedure Button1Click(Sender: TObject);
    procedure Edit1ChangeTracking(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit2ChangeTracking(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
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
var
  fltr : TTMSFNCDataGridDataFilterData;
begin
  TMSFNCDataGrid1.RemoveFilter;
  fltr := TMSFNCDataGrid1.Filter.ColumnFilter[1];
  fltr.CaseSensitive := false;
  fltr.&Type := gftStartsWith;
  fltr.Condition := 'A';
  TMSFNCDataGrid1.ApplyFilter;
end;

procedure TForm130.CheckBox1Change(Sender: TObject);
begin
  TMSFNCDataGrid1.Options.Filtering.MultiColumn := CheckBox1.IsChecked;
end;

procedure TForm130.CheckBox2Change(Sender: TObject);
begin
  TMSFNCDataGrid1.Options.Filtering.HideEmptyGroups := CheckBox2.IsChecked;
  TMSFNCDataGrid1.RemoveFilter;
  TMSFNCDataGrid1.ApplyFilter;
end;

procedure TForm130.ComboBox1Change(Sender: TObject);
var
  fltr : TTMSFNCDataGridDataFilterData;
begin
  TMSFNCDataGrid1.RemoveFilter;
  if Edit2.Text <> '' then
  begin
    fltr := TMSFNCDataGrid1.Filter.ColumnFilter[7];
    fltr.&Type := TTMSFNCDataGridDataFilterNumberType(ComboBox1.ItemIndex);
    fltr.Condition := Edit2.Text;
  end;
  TMSFNCDataGrid1.ApplyFilter;
end;

procedure TForm130.Edit1ChangeTracking(Sender: TObject);
var
  fltr : TTMSFNCDataGridDataFilterData;
begin
  TMSFNCDataGrid1.RemoveFilter;
  if Edit1.Text <> '' then
  begin
    fltr := TMSFNCDataGrid1.Filter.ColumnFilter[1];
    fltr.CaseSensitive := false;
    fltr.&Type := gftContains;
    fltr.Condition := Edit1.Text;
  end;
  TMSFNCDataGrid1.ApplyFilter;
end;

procedure TForm130.Edit2ChangeTracking(Sender: TObject);
var
  fltr : TTMSFNCDataGridDataFilterData;
begin
  TMSFNCDataGrid1.RemoveFilter;
  if Edit2.Text <> '' then
  begin
    fltr := TMSFNCDataGrid1.Filter.ColumnFilter[7];
    fltr.CaseSensitive := false;
    fltr.&Type := TTMSFNCDataGridDataFilterNumberType(ComboBox1.ItemIndex - Integer(Low(TTMSFNCDataGridDataFilterNumberType)));
    fltr.Condition := Edit2.Text;
  end;
  TMSFNCDataGrid1.ApplyFilter;
end;

procedure TForm130.FormCreate(Sender: TObject);
var
  I: TTMSFNCDataGridDataFilterNumberType;
begin
  TMSFNCDataGrid1.BeginUpdate;
  TMSFNCDataGrid1.FixedColumnCount := 1;
  TMSFNCDataGrid1.Options.IO.StartRow := 1;
  TMSFNCDataGrid1.Options.IO.StartColumn := 1;
  TMSFNCDataGrid1.LoadFromCSVData('CARS.csv');
  TMSFNCDataGrid1.Cells[1,0] := 'Brand';
  TMSFNCDataGrid1.Cells[2,0] := 'Type';
  TMSFNCDataGrid1.Cells[3,0] := 'CC';
  TMSFNCDataGrid1.Cells[4,0] := 'Hp';
  TMSFNCDataGrid1.Cells[5,0] := 'Cyl';
  TMSFNCDataGrid1.Cells[6,0] := 'Kw';
  TMSFNCDataGrid1.Cells[7,0] := 'Price';
  TMSFNCDataGrid1.Cells[8,0] := 'Country';

  TMSFNCDataGrid1.FixedRowCount := 2;
  TMSFNCDataGrid1.InsertRow(1);
  TMSFNCDataGrid1.Options.Column.Stretching.Enabled := True;
  TMSFNCDataGrid1.Options.Filtering.Enabled := True;
  TMSFNCDataGrid1.Options.Filtering.Row := 1;
  TMSFNCDataGrid1.Options.Filtering.Controls := [gfcButton, gfcEditor];
  TMSFNCDataGrid1.Options.Filtering.MultiColumn := True;
  CheckBox1.IsChecked := True;

  TMSFNCDataGrid1.Group([8, 1]);

  TMSFNCDataGrid1.Columns[0].Width := 30;

  TMSFNCDataGrid1.EndUpdate;

  for I := Low(TTMSFNCDataGridDataFilterNumberType) to High(TTMSFNCDataGridDataFilterNumberType) do
    ComboBox1.Items.Add(TMSFNCDataGrid1.GetFilterTypeName(I));

  ComboBox1.ItemIndex := 0;

  Edit1.SetFocus;
end;

end.
