unit XDemo.Server;

{ The TMS XData demo server: the components a TMS XData server is made of (TXDataServer with its defaults, a JWT
  and a CORS middleware, a connection pool on a TAureliusConnection) created in code, a SQLite database filled with
  the sample rows at start, and the Indy dispatcher on 127.0.0.1. }

interface

uses
  System.Classes, FireDAC.Comp.Client, Aurelius.Comp.Connection, XData.Comp.ConnectionPool, XData.Comp.Server,
  Sparkle.Comp.JwtMiddleware, Sparkle.Comp.CorsMiddleware, XDemo.IndyDispatcher;

type
  TDemoServer = class(TComponent)
  private
    FDatabase: TFDConnection;
    FConnection: TAureliusConnection;
    FPool: TXDataConnectionPool;
    FDispatcher: TDemoIndyDispatcher;
    FServer: TXDataServer;
    FJwt: TSparkleJwtMiddleware;
    FCors: TSparkleCorsMiddleware;
    FDatabaseFile: string;
    procedure Seed;
  public
    constructor Create(AOwner: TComponent; APort: Integer); reintroduce;
    destructor Destroy; override;
    procedure Start;
    procedure Stop;
    function BaseUrl: string;
  end;

implementation

uses
  System.SysUtils, System.IOUtils, FireDAC.Stan.Def, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.ConsoleUI.Wait, Aurelius.Drivers.FireDac, Aurelius.Drivers.Interfaces,
  Aurelius.Sql.SQLite, Aurelius.Schema.SQLite, Aurelius.Engine.DatabaseManager, Aurelius.Engine.ObjectManager,
  XData.Security.Attributes,
  XDemo.Entities, XDemo.Data, XDemo.LoginService;

constructor TDemoServer.Create(AOwner: TComponent; APort: Integer);
begin
  inherited Create(AOwner);
  FDatabaseFile := TPath.Combine(TPath.GetTempPath, Format('tms-fnc-xdata-demo-%d.db', [APort]));
  FDatabase := TFDConnection.Create(Self);
  FDatabase.DriverName := 'SQLite';
  FDatabase.Params.Values['Database'] := FDatabaseFile;
  FDatabase.LoginPrompt := False;

  FConnection := TAureliusConnection.Create(Self);
  FConnection.AdapterName := 'FireDac';
  FConnection.SQLDialect := 'SQLite';
  FConnection.AdaptedConnection := FDatabase;

  FPool := TXDataConnectionPool.Create(Self);
  FPool.Connection := FConnection;
  FPool.Size := 8;

  FDispatcher := TDemoIndyDispatcher.Create(Self);
  FDispatcher.Port := APort;

  FServer := TXDataServer.Create(Self);
  FServer.BaseUrl := Format('http://127.0.0.1:%d/tms/xdata', [APort]);
  FServer.Dispatcher := FDispatcher;
  FServer.Pool := FPool;
  FServer.DefaultEntitySetPermissions := [TEntitySetPermission.List, TEntitySetPermission.Get];

  { the JWT of LoginService/Login: a signed-in user reads the tasks ([EntityAuthorize] on TTask) }
  FJwt := TSparkleJwtMiddleware.Create(Self);
  FJwt.Secret := DemoSigningKey;
  FJwt.Server := FServer;
  { TMS WEB Core pages on another port call the server too }
  FCors := TSparkleCorsMiddleware.Create(Self);
  FCors.Origin := '*';
  FCors.Server := FServer;
end;

destructor TDemoServer.Destroy;
begin
  Stop;
  inherited;
  if TFile.Exists(FDatabaseFile) then
    TFile.Delete(FDatabaseFile);
end;

function TDemoServer.BaseUrl: string;
begin
  Result := FServer.BaseUrl;
end;

procedure TDemoServer.Seed;
var
  conn: IDBConnection;
  db: TDatabaseManager;
  om: TObjectManager;
  customers: array of TCustomer;
  c: TCustomer;
  o: TOrder;
  t: TTask;
  I: Integer;
  fs: TFormatSettings;
begin
  fs := TFormatSettings.Invariant;
  fs.ShortDateFormat := 'yyyy-mm-dd';
  fs.DateSeparator := '-';
  conn := FConnection.CreateConnection;
  db := TDatabaseManager.Create(conn);
  try
    db.BuildDatabase;
  finally
    db.Free;
  end;
  om := TObjectManager.Create(conn);
  try
    SetLength(customers, Length(DemoCustomers));
    for I := 0 to High(DemoCustomers) do
    begin
      c := TCustomer.Create;
      c.Id := DemoCustomers[I].Id;
      c.Name := DemoCustomers[I].Name;
      c.City := DemoCustomers[I].City;
      c.Country := DemoCustomers[I].Country;
      c.Credit := DemoCustomers[I].Credit;
      c.Active := DemoCustomers[I].Active;
      c.Created := StrToDate(DemoCustomers[I].Created, fs);
      om.Save(c);
      customers[I] := c;
    end;
    for I := 0 to High(DemoOrders) do
    begin
      o := TOrder.Create;
      o.Id := DemoOrders[I].Id;
      o.Customer := customers[DemoOrders[I].CustomerId - 1];
      o.OrderDate := StrToDate(DemoOrders[I].OrderDate, fs);
      o.Status := DemoOrders[I].Status;
      o.Amount := DemoOrders[I].Amount;
      om.Save(o);
    end;
    for I := 0 to High(DemoTasks) do
    begin
      t := TTask.Create;
      t.Id := DemoTasks[I].Id;
      t.Title := DemoTasks[I].Title;
      t.Status := DemoTasks[I].Status;
      t.Owner := DemoTasks[I].Owner;
      t.Priority := DemoTasks[I].Priority;
      t.Order := DemoTasks[I].Order;
      if DemoTasks[I].CustomerId > 0 then
        t.Customer := customers[DemoTasks[I].CustomerId - 1];
      om.Save(t);
    end;
  finally
    om.Free;
  end;
end;

procedure TDemoServer.Start;
begin
  if TFile.Exists(FDatabaseFile) then
    TFile.Delete(FDatabaseFile);
  Seed;
  FDispatcher.Start;
end;

procedure TDemoServer.Stop;
begin
  if Assigned(FDispatcher) then
    FDispatcher.Stop;
end;

end.
