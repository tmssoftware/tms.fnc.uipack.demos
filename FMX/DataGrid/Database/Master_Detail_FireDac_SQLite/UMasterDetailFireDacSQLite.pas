unit UMasterDetailFireDacSQLite;

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
  FireDAC.Comp.Client, FMX.TMSFNCPDFIO, FMX.TMSFNCDataGridPDFIO;

type
  TForm130 = class(TForm)
    Panel1: TPanel;
    Button2: TButton;
    TMSFNCDataGrid1: TTMSFNCDataGrid;
    BindNavigator1: TBindNavigator;
    TMSFNCDataGridDatabaseAdapter1: TTMSFNCDataGridDatabaseAdapter;
    DataSource1: TDataSource;
    Button1: TButton;
    BindSourceDB1: TBindSourceDB;
    FDConnection1: TFDConnection;
    FDTable1: TFDTable;
    TMSFNCDataGridDatabaseAdapter2: TTMSFNCDataGridDatabaseAdapter;
    DataSource2: TDataSource;
    FDTable2: TFDTable;
    TMSFNCDataGrid2: TTMSFNCDataGrid;
    TMSFNCDataGridPDFIO1: TTMSFNCDataGridPDFIO;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FDTable1AfterOpen(DataSet: TDataSet);
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
  FDTable1.Active := not FDTable1.Active;
  FDTable2.Active := not FDTable2.Active;
  SetText;
end;

procedure TForm130.Button3Click(Sender: TObject);
begin
  TMSFNCDataGridPDFIO1.Options.Header := 'Master Detail';
  TMSFNCDataGridPDFIO1.Options.Footer := '';
  TMSFNCDataGridPDFIO1.Options.OpenInPDFReader := True;
  TMSFNCDataGridPDFIO1.Save('Export.pdf');
end;

procedure TForm130.FDTable1AfterOpen(DataSet: TDataSet);
begin
  TMSFNCDataGrid1.ColumnWidths[0] := 30;
  TMSFNCDataGrid1.AutoSizeColumns();
end;

procedure TForm130.FormCreate(Sender: TObject);
begin
  SetText;
  FDConnection1.Connected := True;
end;

procedure TForm130.SetText;
begin
  if FDTable1.Active then
    Button1.Text := 'Deactivate'
  else
    Button1.Text := 'Activate';
end;

end.
