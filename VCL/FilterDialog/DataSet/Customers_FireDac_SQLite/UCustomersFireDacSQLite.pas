unit UCustomersFireDacSQLite;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  VCL.Controls, VCL.Forms, VCL.Graphics, VCL.Dialogs, VCL.StdCtrls,
  Data.Bind.Controls, VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics,
  VCL.TMSFNCGraphicsTypes, System.Rtti, VCL.TMSFNCDataGridCell,
  VCL.TMSFNCDataGridData, VCL.TMSFNCDataGridBase, VCL.TMSFNCDataGridCore,
  VCL.TMSFNCDataGridRenderer, Data.Bind.Components, Data.Bind.DBScope, Data.DB,
  VCL.TMSFNCCustomComponent, VCL.TMSFNCDataGridDatabaseAdapter,
  VCL.TMSFNCCustomControl, VCL.TMSFNCDataGrid, Fmx.Bind.Navigator,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.VCLUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.Buttons, Vcl.Bind.Navigator, Vcl.ExtCtrls,
  VCL.TMSFNCCustomDialog, VCL.TMSFNCFilterDialog,
  VCL.TMSFNCButton, VCL.TMSFNCEdit, VCL.TMSFNCHTMLText, VCL.TMSFNCPanel, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector;

type
  TForm130 = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TTMSFNCPanel;
    DemoTitle: TTMSFNCHTMLText;
    DemoDescription: TTMSFNCHTMLText;
    DemoThemeSelector: TTMSFNCThemeSelector;
    Panel1: TTMSFNCPanel;
    Button2: TTMSFNCButton;
    TMSFNCDataGrid1: TTMSFNCDataGrid;
    BindNavigator1: TBindNavigator;
    TMSFNCDataGridDatabaseAdapter1: TTMSFNCDataGridDatabaseAdapter;
    DataSource1: TDataSource;
    ActiveBtn: TTMSFNCButton;
    BindSourceDB1: TBindSourceDB;
    FDConnection1: TFDConnection;
    FDTable1: TFDTable;
    Panel2: TTMSFNCPanel;
    FilterTextEdit: TTMSFNCEdit;
    FilterBtn: TTMSFNCButton;
    TMSFNCDataSetFilterDialog1: TTMSFNCDataSetFilterDialog;
    procedure ActiveBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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
  FDTable1.Active := not FDTable1.Active;
  SetText;
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
  FDConnection1.Connected := True;
end;

procedure TForm130.SetText;
begin
  if FDTable1.Active then
    ActiveBtn.Text := 'Deactivate'
  else
    ActiveBtn.Text := 'Activate';
end;

end.
