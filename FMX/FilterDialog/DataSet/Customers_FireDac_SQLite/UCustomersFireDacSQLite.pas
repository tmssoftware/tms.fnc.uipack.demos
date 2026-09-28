unit UCustomersFireDacSQLite;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  Data.Bind.Controls, FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics,
  FMX.TMSFNCGraphicsTypes, System.Rtti, FMX.TMSFNCDataGridCell,
  FMX.TMSFNCDataGridData, FMX.TMSFNCDataGridBase, FMX.TMSFNCDataGridCore,
  FMX.TMSFNCDataGridRenderer, Data.Bind.Components, Data.Bind.DBScope, Data.DB,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCDataGridDatabaseAdapter,
  FMX.TMSFNCCustomControl, FMX.TMSFNCDataGrid, FMX.Layouts, Fmx.Bind.Navigator,
  FMX.Controls.Presentation, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.Edit, FMX.TMSFNCFilterDialog, FMX.TMSFNCCustomDialog;

type
  TForm130 = class(TForm)
    Panel1: TPanel;
    Button2: TButton;
    TMSFNCDataGrid1: TTMSFNCDataGrid;
    BindNavigator1: TBindNavigator;
    TMSFNCDataGridDatabaseAdapter1: TTMSFNCDataGridDatabaseAdapter;
    DataSource1: TDataSource;
    ActiveBtn: TButton;
    BindSourceDB1: TBindSourceDB;
    FDConnection1: TFDConnection;
    FDTable1: TFDTable;
    Panel2: TPanel;
    FilterTextEdit: TEdit;
    FilterBtn: TButton;
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

{$R *.fmx}

procedure TForm130.ActiveBtnClick(Sender: TObject);
begin
  TMSFNCDataGridDatabaseAdapter1.DataSource := DataSource1;
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

  FilterTextEdit.Text := '([ContactName] LIKE ' + QuotedStr('Mar%') +' AND [ContactTitle] = ' + QuotedStr('Owner')+ ') OR ([PostalCode] LIKE ' + QuotedStr('1____') + ' AND [Region] is NULL)';
end;

procedure TForm130.SetText;
begin
  if FDTable1.Active then
    ActiveBtn.Text := 'Deactivate'
  else
    ActiveBtn.Text := 'Activate';
end;

end.
