unit UBiolifeClientDataSet;

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
  Vcl.ExtCtrls, VCL.TMSFNCCustomDialog, VCL.TMSFNCFilterDialog;

type
  TForm130 = class(TForm)
    Panel1: TPanel;
    Button2: TButton;
    TMSFNCDataGrid1: TTMSFNCDataGrid;
    BindNavigator1: TBindNavigator;
    ClientDataSet1: TClientDataSet;
    TMSFNCDataGridDatabaseAdapter1: TTMSFNCDataGridDatabaseAdapter;
    DataSource1: TDataSource;
    ActiveBtn: TButton;
    BindSourceDB1: TBindSourceDB;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Panel2: TPanel;
    FilterTextEdit: TEdit;
    FilterBtn: TButton;
    TMSFNCDataSetFilterDialog1: TTMSFNCDataSetFilterDialog;
    procedure ActiveBtnClick(Sender: TObject);
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
    procedure FilterBtnClick(Sender: TObject);
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

procedure TForm130.ActiveBtnClick(Sender: TObject);
begin
  ClientDataSet1.Active := not ClientDataSet1.Active;
  SetText;
end;

procedure TForm130.CheckBox1Change(Sender: TObject);
begin
  TMSFNCDataGridDatabaseAdapter1.ShowPictureFields := CheckBox1.Checked;
end;

procedure TForm130.CheckBox2Change(Sender: TObject);
begin
  TMSFNCDataGridDatabaseAdapter1.ShowMemoFields := CheckBox2.Checked;
end;

procedure TForm130.FilterBtnClick(Sender: TObject);
begin
  TMSFNCDataSetFilterDialog1.FilterText := FilterTextEdit.Text;
  TMSFNCDataSetFilterDialog1.Execute;
  FilterTextEdit.Text := TMSFNCDataSetFilterDialog1.FilterText;
end;

procedure TForm130.FormCreate(Sender: TObject);
begin
  SetText;
end;

procedure TForm130.SetText;
begin
  if ClientDataSet1.Active then
    ActiveBtn.Caption := 'Deactivate'
  else
    ActiveBtn.Caption := 'Activate';
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
