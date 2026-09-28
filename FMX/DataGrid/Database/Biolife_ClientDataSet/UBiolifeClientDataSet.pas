unit UBiolifeClientDataSet;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.TMSFNCCustomControl, FMX.TMSFNCTypes,
  FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, System.Rtti,
  FMX.TMSFNCDataGridCell, FMX.TMSFNCDataGridData, FMX.TMSFNCDataGridBase,
  FMX.TMSFNCDataGridCore, FMX.TMSFNCDataGridRenderer, Data.Bind.Controls,
  Data.DB, FMX.TMSFNCCustomComponent, FMX.TMSFNCDataGridDatabaseAdapter,
  Datasnap.DBClient, FMX.Layouts, Fmx.Bind.Navigator, FMX.TMSFNCDataGrid,
  Data.Bind.Components, Data.Bind.DBScope;

type
  TForm130 = class(TForm)
    Panel1: TPanel;
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
    CheckBox3: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure TMSFNCDataGrid1GetInplaceEditorProperties(Sender: TObject;
      ACell: TTMSFNCDataGridCellCoord;
      AInplaceEditor: TTMSFNCDataGridInplaceEditor;
      AInplaceEditorType: TTMSFNCDataGridInplaceEditorType);
    procedure TMSFNCDataGrid1GetCellFormatting(Sender: TObject;
      ACell: TTMSFNCDataGridCellCoord; AData: TTMSFNCDataGridCellValue;
      var AFormatting: TTMSFNCDataGridDataFormatting;
      var AConvertSettings: TFormatSettings; var ACanFormat: Boolean);
    procedure CheckBox3Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetText;
  end;

var
  Form130: TForm130;

implementation

{$R *.fmx}

procedure TForm130.Button1Click(Sender: TObject);
begin
  ClientDataSet1.Active := not ClientDataSet1.Active;
  SetText;
end;

procedure TForm130.CheckBox1Change(Sender: TObject);
begin
  TMSFNCDataGrid1.Paging := not TMSFNCDataGrid1.Paging;
  TMSFNCDataGrid1.Footer.Visible := TMSFNCDataGrid1.Paging;
  TMSFNCDataGrid1.Footer.Paging.Visible := TMSFNCDataGrid1.Paging;
end;

procedure TForm130.CheckBox2Change(Sender: TObject);
begin
  TMSFNCDataGridDatabaseAdapter1.ShowMemoFields := CheckBox2.IsChecked;
end;

procedure TForm130.CheckBox3Change(Sender: TObject);
begin
  TMSFNCDataGridDatabaseAdapter1.ShowPictureFields := CheckBox3.IsChecked;
end;

procedure TForm130.FormCreate(Sender: TObject);
begin
  SetText;
  TMSFNCDataGrid1.Options.Filtering.Enabled := True;
end;

procedure TForm130.SetText;
begin
  if ClientDataSet1.Active then
    Button1.Text := 'Deactivate'
  else
    Button1.Text := 'Activate';
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
