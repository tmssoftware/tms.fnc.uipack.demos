unit XDemo.IndyDispatcher;

{ A Sparkle dispatcher on Indy's HTTP server, bound to one address (127.0.0.1 by default): it needs no URL
  reservation (http.sys) and no firewall rule, so the demo server runs without administrator rights. }

interface

uses
  System.Classes, IdSocketHandle, Sparkle.Comp.Server, Sparkle.Indy.Server;

type
  TDemoIndyDispatcher = class(TSparkleDispatcher)
  private
    FServer: TIndySparkleHTTPServer;
    FHost: string;
    FPort: Integer;
  strict protected
    procedure DoStart; override;
    procedure DoStop; override;
    function GetActive: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Host: string read FHost write FHost;
    property Port: Integer read FPort write FPort;
  end;

implementation

constructor TDemoIndyDispatcher.Create(AOwner: TComponent);
begin
  inherited;
  FHost := '127.0.0.1';
  FPort := 8793;
end;

destructor TDemoIndyDispatcher.Destroy;
begin
  if Assigned(FServer) then
    FServer.Active := False;
  FServer.Free;
  inherited;
end;

procedure TDemoIndyDispatcher.DoStart;
var
  b: TIdSocketHandle;
begin
  if GetActive then
    Exit;
  FServer.Free;
  FServer := TIndySparkleHTTPServer.Create(nil);
  FServer.DefaultPort := FPort;
  FServer.Bindings.Clear;
  b := FServer.Bindings.Add;
  b.IP := FHost;
  b.Port := FPort;
  FServer.Dispatcher.ClearModules;
  AddDispatcherModules(FServer.Dispatcher);
  FServer.Active := True;
end;

procedure TDemoIndyDispatcher.DoStop;
begin
  if Assigned(FServer) then
    FServer.Active := False;
end;

function TDemoIndyDispatcher.GetActive: Boolean;
begin
  Result := Assigned(FServer) and FServer.Active;
end;

end.
