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
  Data.Bind.Components, Data.Bind.DBScope, TMS.TMSFNCFilterBuilder, FMX.TMSFNCFilterDialog,
  FMX.TMSFNCCustomDialog;

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
    FilterDialogBtn: TButton;
    TMSFNCDataSetFilterDialog1: TTMSFNCDataSetFilterDialog;
    procedure ActiveBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure FilterDialogBtnClick(Sender: TObject);
    procedure TMSFNCDataSetFilterDialog1AfterAddColumn(Sender: TObject;
      AColumn: TTMSFNCFilterBuilderColumn);
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

procedure TForm130.ActiveBtnClick(Sender: TObject);
begin
  ClientDataSet1.Active := not ClientDataSet1.Active;
  SetText;
end;

procedure TForm130.FilterDialogBtnClick(Sender: TObject);
begin
  TMSFNCDataSetFilterDialog1.FilterText := FilterTextEdit.Text;
  TMSFNCDataSetFilterDialog1.Execute;
  FilterTextEdit.Text := TMSFNCDataSetFilterDialog1.FilterText;
end;

procedure TForm130.CheckBox1Change(Sender: TObject);
begin
  TMSFNCDataGridDatabaseAdapter1.ShowPictureFields := CheckBox1.IsChecked;
end;

procedure TForm130.CheckBox2Change(Sender: TObject);
begin
  TMSFNCDataGridDatabaseAdapter1.ShowMemoFields := CheckBox2.IsChecked;
end;

procedure TForm130.FormCreate(Sender: TObject);
begin
  FilterTextEdit.Text := ClientDataSet1.Filter;
end;

procedure TForm130.SetText;
begin
  if ClientDataSet1.Active then
    ActiveBtn.Text := 'Deactivate'
  else
    ActiveBtn.Text := 'Activate';
end;

procedure TForm130.TMSFNCDataSetFilterDialog1AfterAddColumn(Sender: TObject;
  AColumn: TTMSFNCFilterBuilderColumn);
begin
  if AColumn.Name = 'Species No' then
    AColumn.DisplayName := 'Series Number'
  else if AColumn.Name = 'Category' then
    AColumn.DisplayName := 'Fish Type';
end;

end.
