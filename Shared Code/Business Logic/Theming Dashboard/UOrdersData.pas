unit UOrdersData;

{ TMS FNC UI Pack - Theming Dashboard demo: the data of the order management app (VCL and FMX).

  A SQLite database through FireDAC, all designed in UOrdersData.dfm:
  * Orders: the orders, edited in the grid's detail card; posted rows are written to the file at once;
  * Kpis: one row of aggregates (revenue, open orders, customers, goals), refreshed after every post
    and delete; the form shows it through a data source of its own;
  * Customers and Projects: the customer list and the project tasks.

  The demo ships orders.db (and orders.sql, the script it is built from) next to this unit. The app
  never changes that file: on the first start it copies it next to the executable and works on
  the copy; Reset copies it again. }

interface

uses
  System.SysUtils, System.Classes, System.IOUtils, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.Stan.ExprFuncs, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, {$IFDEF FMX}FireDAC.FMXUI.Wait{$ELSE}FireDAC.VCLUI.Wait{$ENDIF};

type
  TOrdersData = class(TDataModule)
    Database: TFDConnection;
    Orders: TFDQuery;
    OrdersId: TIntegerField;
    OrdersCustomer: TStringField;
    OrdersOrderDate: TDateField;
    OrdersAmount: TFloatField;
    OrdersStatus: TStringField;
    OrdersFulfilment: TIntegerField;
    OrdersExpress: TBooleanField;
    Kpis: TFDQuery;
    Customers: TFDQuery;
    Projects: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure OrdersNewRecord(DataSet: TDataSet);
    procedure OrdersChanged(DataSet: TDataSet);
    procedure OrdersFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure OrdersIdGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure OrdersOrderDateGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure OrdersAmountGetText(Sender: TField; var Text: string; DisplayText: Boolean);
  private
    FStatus, FSearch: string;
    function FileName: string;
    function ShippedFileName: string;
  public
    { Shows the orders with this status ('' all) whose customer or number contains ASearch. }
    procedure Filter(const AStatus, ASearch: string);
    { Marks a task done (or not); a project marks all its tasks. }
    procedure SetDone(AProjectId: Integer; ADone: Boolean);
    { Starts again from the shipped database (when the demo's folders are there). }
    procedure Reset;
  end;

var
  OrdersData: TOrdersData;

implementation

{$R *.dfm}

const
  ShippedDatabase = 'Shared Code\Business Logic\Theming Dashboard\orders.db';

{ the working copy, next to the executable }
function TOrdersData.FileName: string;
begin
  Result := TPath.Combine(ExtractFilePath(ParamStr(0)), 'orders.db');
end;

{ the shipped database in the demo's folders, found from the executable upwards ('' if not there) }
function TOrdersData.ShippedFileName: string;
var
  dir: string;
begin
  dir := ExtractFileDir(ParamStr(0));
  repeat
    Result := TPath.Combine(dir, ShippedDatabase);
    if TFile.Exists(Result) then
      Exit;
    dir := ExtractFileDir(dir);
  until (dir = '') or (dir = ExtractFileDir(dir));
  Result := '';
end;

procedure TOrdersData.DataModuleCreate(Sender: TObject);
begin
  if not TFile.Exists(FileName) and (ShippedFileName <> '') then
    TFile.Copy(ShippedFileName, FileName);
  Database.Params.Database := FileName;
  Database.Open;
  Customers.Open;
  Projects.Open;
  Orders.Open;
  Kpis.Open;
end;

procedure TOrdersData.Reset;
begin
  if ShippedFileName = '' then
    Exit;
  Database.Close;
  TFile.Copy(ShippedFileName, FileName, True);
  DataModuleCreate(Self);
end;

procedure TOrdersData.OrdersNewRecord(DataSet: TDataSet);
begin
  OrdersId.AsInteger := Database.ExecSQLScalar('SELECT COALESCE(MAX(id), 10239) + 1 FROM orders');
  OrdersCustomer.AsString := Customers.Fields[0].AsString;
  OrdersOrderDate.AsDateTime := Date;
  OrdersAmount.AsFloat := 0;
  OrdersStatus.AsString := 'Open';
  OrdersFulfilment.AsInteger := 0;
  OrdersExpress.AsBoolean := False;
end;

{ after a post or a delete (the row is in the file): the aggregates again }
procedure TOrdersData.OrdersChanged(DataSet: TDataSet);
begin
  Kpis.Refresh;
end;

procedure TOrdersData.Filter(const AStatus, ASearch: string);
begin
  FStatus := AStatus;
  FSearch := LowerCase(Trim(ASearch));
  Orders.Filtered := False;
  Orders.Filtered := (FStatus <> '') or (FSearch <> '');
end;

procedure TOrdersData.OrdersFilterRecord(DataSet: TDataSet; var Accept: Boolean);
begin
  Accept := ((FStatus = '') or SameText(OrdersStatus.AsString, FStatus)) and
    ((FSearch = '') or (Pos(FSearch, LowerCase(OrdersCustomer.AsString + ' #' + OrdersId.AsString)) > 0));
end;

procedure TOrdersData.SetDone(AProjectId: Integer; ADone: Boolean);
begin
  Database.ExecSQL('UPDATE projects SET done = :done, status = CASE WHEN :done2 THEN ''Done'' ELSE ''In progress'' END ' +
    'WHERE parent_id IS NOT NULL AND (id = :id OR parent_id = :id2)', [ADone, ADone, AProjectId, AProjectId]);
  Projects.Refresh;
end;

procedure TOrdersData.OrdersIdGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  Text := '#' + Sender.AsString;
end;

procedure TOrdersData.OrdersOrderDateGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  Text := FormatDateTime('mmm dd', Sender.AsDateTime);
end;

procedure TOrdersData.OrdersAmountGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  Text := FormatFloat('$#,##0.00', Sender.AsFloat);
end;

end.
