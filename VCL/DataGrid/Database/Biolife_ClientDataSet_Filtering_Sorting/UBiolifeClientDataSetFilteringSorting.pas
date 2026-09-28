unit UBiolifeClientDataSetFilteringSorting;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  VCL.Controls, VCL.Forms, VCL.Graphics, VCL.Dialogs, VCL.StdCtrls,
  VCL.TMSFNCCustomControl, VCL.TMSFNCTypes,
  VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, System.Rtti,
  VCL.TMSFNCDataGridCell, VCL.TMSFNCDataGridData, VCL.TMSFNCDataGridBase,
  VCL.TMSFNCDataGridCore, VCL.TMSFNCDataGridRenderer, Data.Bind.Controls,
  Data.DB, VCL.TMSFNCCustomComponent, VCL.TMSFNCDataGridDatabaseAdapter,
  Datasnap.DBClient, Fmx.Bind.Navigator, VCL.TMSFNCDataGrid,
  Data.Bind.Components, Data.Bind.DBScope, Vcl.Buttons, Vcl.Bind.Navigator,
  Vcl.ExtCtrls;

type
  TForm130 = class(TForm)
    Z: TPanel;
    Button2: TButton;
    TMSFNCDataGrid1: TTMSFNCDataGrid;
    BindNavigator1: TBindNavigator;
    ClientDataSet1: TClientDataSet;
    TMSFNCDataGridDatabaseAdapter1: TTMSFNCDataGridDatabaseAdapter;
    DataSource1: TDataSource;
    Button1: TButton;
    BindSourceDB1: TBindSourceDB;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Panel1: TPanel;
    Button3: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Edit2: TEdit;
    Label2: TLabel;
    Button4: TButton;
    Button5: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Edit1ChangeTracking(Sender: TObject);
    procedure Edit2ChangeTracking(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure TMSFNCDataGrid1GetInplaceEditorProperties(Sender: TObject;
      ACell: TTMSFNCDataGridCellCoord;
      AInplaceEditor: TTMSFNCDataGridInplaceEditor;
      AInplaceEditorType: TTMSFNCDataGridInplaceEditorType);
    procedure TMSFNCDataGrid1GetCellFormatting(Sender: TObject;
      ACell: TTMSFNCDataGridCellCoord; AData: TTMSFNCDataGridCellValue;
      var AFormatting: TTMSFNCDataGridDataFormatting;
      var AConvertSettings: TFormatSettings; var ACanFormat: Boolean);
    procedure TMSFNCDataGrid1BeforeSortColumn(Sender: TObject; AColumn: Integer;
      var ACanSort: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetText;
  end;

var
  Form130: TForm130;

implementation

{$R *.dfm}

procedure TForm130.Button1Click(Sender: TObject);
begin
  ClientDataSet1.Active := not ClientDataSet1.Active;
  SetText;
end;

procedure TForm130.Button3Click(Sender: TObject);
begin
  Edit1.Text := '';
  Edit1.Text := 'S*';
end;

procedure TForm130.Button4Click(Sender: TObject);
begin
  TMSFNCDataGrid1.Sort(3, gsdAscending);
end;

procedure TForm130.Button5Click(Sender: TObject);
begin
  TMSFNCDataGrid1.Sort(3, gsdDescending);
end;

procedure TForm130.CheckBox1Change(Sender: TObject);
begin
  TMSFNCDataGridDatabaseAdapter1.ShowPictureFields := CheckBox1.Checked;
end;

procedure TForm130.CheckBox2Change(Sender: TObject);
begin
  TMSFNCDataGridDatabaseAdapter1.ShowMemoFields := CheckBox2.Checked;
end;

procedure TForm130.Edit1ChangeTracking(Sender: TObject);
var
  fltr : TTMSFNCDataGridDataFilterData;
begin
  TMSFNCDataGrid1.ClearFilter;
  if Edit1.Text <> '' then
  begin
    fltr := TMSFNCDataGrid1.Filter.Add;

    fltr.Column := 1;
    fltr.CaseSensitive := false;
    fltr.Condition := Edit1.Text;

    TMSFNCDataGrid1.ApplyFilter;
  end;
end;

procedure TForm130.Edit2ChangeTracking(Sender: TObject);
var
  fltr : TTMSFNCDataGridDataFilterData;
begin
  TMSFNCDataGrid1.ClearFilter;
  if Edit2.Text <> '' then
  begin
    fltr := TMSFNCDataGrid1.Filter.Add;

    fltr.Column := 4;
    fltr.CaseSensitive := false;
    fltr.Condition := edit2.Text;

    TMSFNCDataGrid1.ApplyFilter;
  end;
end;

procedure TForm130.FormCreate(Sender: TObject);
begin
  SetText;
  TMSFNCDataGrid1.Options.Sorting.Enabled := True;
  TMSFNCDataGrid1.Options.Filtering.Enabled := True;
  TMSFNCDataGrid1.ScrollMode := gsmCellScrolling;
end;

procedure TForm130.SetText;
begin
  if ClientDataSet1.Active then
    Button1.Caption := 'Deactivate'
  else
    Button1.Caption := 'Activate';
end;

procedure TForm130.TMSFNCDataGrid1BeforeSortColumn(Sender: TObject;
  AColumn: Integer; var ACanSort: Boolean);
begin
  ACanSort := not (AColumn in [6, 7]);
end;

procedure TForm130.TMSFNCDataGrid1GetCellFormatting(Sender: TObject;
  ACell: TTMSFNCDataGridCellCoord; AData: TTMSFNCDataGridCellValue;
  var AFormatting: TTMSFNCDataGridDataFormatting;
  var AConvertSettings: TFormatSettings; var ACanFormat: Boolean);
begin
  if ACell.Column in [4] then
  begin
    AFormatting.Format := '%g';
    AFormatting.&Type := gdftNumber;
  end
  else if ACell.Column in [5] then
  begin
    AFormatting.Format := '%.2f';
    AFormatting.&Type := gdftNumber;
  end;
end;

procedure TForm130.TMSFNCDataGrid1GetInplaceEditorProperties(Sender: TObject;
  ACell: TTMSFNCDataGridCellCoord; AInplaceEditor: TTMSFNCDataGridInplaceEditor;
  AInplaceEditorType: TTMSFNCDataGridInplaceEditorType);
begin
  if (AInplaceEditorType = getFloatEdit) then
  begin
    if ACell.Column in [4] then
      (AInplaceEditor as TTMSFNCDataGridEdit).Precision := 0
    else
      (AInplaceEditor as TTMSFNCDataGridEdit).Precision := 2;
  end;
end;

end.
