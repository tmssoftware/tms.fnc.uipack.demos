program XDataDemoServer;

{ TMS XData demo server for the TMS FNC data demos: customers, orders and tasks on http://127.0.0.1:8793/tms/xdata.

  XDataDemoServer [--port 8793] [--session <file>] [--until-killed]

  The tasks need a sign-in: user "demo" and the password the server shows when it starts (a new one every start).
  --session writes the address, user and password of this run to a file for test tools (the password in plain text:
  a temporary folder, never a repository; deleted when the server stops with Enter, an old one at the next start);
  --until-killed runs without waiting for Enter (started by a test tool). }

{$APPTYPE CONSOLE}

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.IOUtils, System.JSON,
  XDemo.IndyDispatcher in 'XDemo.IndyDispatcher.pas',
  XDemo.Entities in 'XDemo.Entities.pas',
  XDemo.Data in 'XDemo.Data.pas',
  XDemo.LoginService in 'XDemo.LoginService.pas',
  XDemo.Server in 'XDemo.Server.pas';

function OptionValue(const AName, ADefault: string): string;
var
  I: Integer;
begin
  Result := ADefault;
  for I := 1 to ParamCount - 1 do
    if SameText(ParamStr(I), AName) then
      Exit(ParamStr(I + 1));
end;

function HasOption(const AName: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 1 to ParamCount do
    if SameText(ParamStr(I), AName) then
      Exit(True);
end;

procedure WriteSession(const AFileName, ABaseUrl: string);
var
  o: TJSONObject;
begin
  o := TJSONObject.Create;
  try
    o.AddPair('url', ABaseUrl);
    o.AddPair('user', DemoUser);
    o.AddPair('password', DemoPassword);
    o.AddPair('pid', TJSONNumber.Create(GetCurrentProcessId));
    TFile.WriteAllText(AFileName, o.ToJSON, TEncoding.UTF8);
  finally
    o.Free;
  end;
end;

var
  server: TDemoServer;
  session: string;
begin
  try
    MakeDemoSecrets;
    session := OptionValue('--session', '');
    if (session <> '') and TFile.Exists(session) then
      TFile.Delete(session);
    server := TDemoServer.Create(nil, StrToIntDef(OptionValue('--port', '8793'), 8793));
    try
      server.Start;
      if session <> '' then
        WriteSession(session, server.BaseUrl);
      WriteLn('TMS XData demo server');
      WriteLn('  Service:  ', server.BaseUrl);
      WriteLn('  Sign in:  user "', DemoUser, '", password "', DemoPassword, '" (new at every start)');
      WriteLn('  Entity sets: Customer, Order, Task (Task needs the sign-in)');
      if HasOption('--until-killed') then
        while True do
          Sleep(1000)
      else
      begin
        WriteLn('Press Enter to stop.');
        ReadLn;
      end;
    finally
      server.Free;
      if (session <> '') and TFile.Exists(session) then
        TFile.Delete(session);
    end;
  except
    on e: Exception do
    begin
      WriteLn(e.ClassName, ': ', e.Message);
      ExitCode := 1;
    end;
  end;
end.
