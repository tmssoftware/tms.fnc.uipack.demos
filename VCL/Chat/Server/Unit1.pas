unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdBaseComponent,
  IdComponent, IdCustomTCPServer, IdTCPServer, IdContext;

type
  TForm1 = class(TForm)
    IdTCPServer1: TIdTCPServer;
    Memo1: TMemo;
    Label1: TLabel;
    procedure IdTCPServer1Connect(AContext: TIdContext);
    procedure IdTCPServer1Execute(AContext: TIdContext);
    procedure IdTCPServer1Disconnect(AContext: TIdContext);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  IdTCPConnection, IdYarn, IdThreadSafe;

type
  TMyContext = class(TIdServerContext)
  private
    Queue: TIdThreadSafeStringList;
    QueuePending: Boolean;
    FID: string;
  public
    constructor Create(AConnection: TIdTCPConnection; AYarn: TIdYarn; AList: TIdContextThreadList = nil); override;
    destructor Destroy; override;
    procedure AddToQueue(const s: string);
    procedure SendQueue;
    property ID: string read FID write FID;
  end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  IdTCPServer1.ContextClass := TMyContext;
  IdTCPServer1.Active := True;
end;

procedure TForm1.IdTCPServer1Connect(AContext: TIdContext);
var
  id: string;
begin
  id := TGUID.NewGuid.ToString;
  TMyContext(AContext).Queue.Clear;
  TMyContext(AContext).ID := id;

  TThread.Queue(nil, procedure
  begin
    Memo1.Lines.Add('[Connected] ' + TMyContext(AContext).Connection.Socket.Binding.PeerIP + ' - Assigned ID: ' + TMyContext(AContext).ID);
  end);
end;

procedure TForm1.IdTCPServer1Disconnect(AContext: TIdContext);
var
  ip, id: string;
begin
  TMyContext(AContext).Queue.Clear;
  ip := TMyContext(AContext).Connection.Socket.Binding.PeerIP;
  id := TMyContext(AContext).ID;

  TThread.Queue(nil, procedure
  begin
    Memo1.Lines.Add('[Disconnected] ' + ip + ' - Assigned ID: ' + id);
  end);
end;

procedure TForm1.IdTCPServer1Execute(AContext: TIdContext);
var
  msg: string;
  list: TIdContextList;
  I: Integer;
  lContext: TMyContext;
begin
  LContext := TMyContext(AContext);
  LContext.SendQueue;


  if AContext.Connection.IOHandler.InputBufferIsEmpty then
  begin
    AContext.Connection.IOHandler.CheckForDataOnSource(100);
    AContext.Connection.IOHandler.CheckForDisconnect;

    if AContext.Connection.IOHandler.InputBufferIsEmpty then
      Exit;
  end;

  msg := AContext.Connection.IOHandler.ReadLn;

  TThread.Queue(nil, procedure
  begin
    Memo1.Lines.Add('[Message] From: ' + TMyContext(AContext).ID + ' - Message: ' + msg);
  end);

  //add to queue for all clients except the one the message came from
  list := IdTCPServer1.Contexts.LockList;
  try
    for I := 0 to list.Count - 1 do
    begin
      if TMyContext(list[i]).ID <> TMyContext(AContext).ID then
        TMyContext(list[i]).AddToQueue(msg);
    end;
  finally
    IdTCPServer1.Contexts.UnlockList;
  end;
end;

{ TMyContext }

procedure TMyContext.AddToQueue(const s: string);
var
  list: TStringList;
begin
  list := Queue.Lock;
  try
    list.Add(s);
    QueuePending := True;
  finally
    Queue.Unlock;
  end;
end;

constructor TMyContext.Create(AConnection: TIdTCPConnection; AYarn: TIdYarn;
  AList: TIdContextThreadList);
begin
  inherited;
  Queue := TIdThreadSafeStringList.Create;
end;

destructor TMyContext.Destroy;
begin
  Queue.Free;
  inherited;
end;

procedure TMyContext.SendQueue;
var
  list: TStringList;
  tmpList: TStringList;
  i: Integer;
begin
  if not QueuePending then
    Exit;

  tmpList := TStringList.Create;
  try
    list := Queue.Lock;
    try
      if list.Count = 0 then
      begin
        QueuePending := False;
        Exit;
      end;
      tmpList.Assign(list);
      list.Clear;
      QueuePending := False;
    finally
      Queue.Unlock;
    end;
    for i := 0 to tmpList.Count-1 do
      Connection.IOHandler.WriteLn(tmpList[i]);
  finally
    tmpList.Free;
  end;
end;

end.
