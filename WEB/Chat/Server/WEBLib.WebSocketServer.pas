{********************************************************************}
{                                                                    }
{ written by TMS Software                                            }
{            copyright © 2018                                        }
{            Email : info@tmssoftware.com                            }
{            Web : http://www.tmssoftware.com                        }
{                                                                    }
{ The source code is given as is. The author is not responsible      }
{ for any possible damage done due to the use of this code.          }
{ The complete source code remains property of the author and may    }
{ not be distributed, published, given or sold in any form as such.  }
{ No parts of the source code can be included in any other component }
{ or application without written authorization of the author.        }
{********************************************************************}

unit WEBLib.WebSocketServer;

interface

uses
  Classes, SysUtils, IniFiles, IdContext, IdTCPConnection, IdCustomHTTPServer,
  Generics.Collections, IdHTTPServer, IdScheduler, IdSchedulerOfThreadDefault, IdHeaderList,
  IdSSLOpenSSL;

const
  Fin: Byte = $80;
  TwoBytesLengthCode = 126;
  EightBytesLengthCode = 127;
  DefaultPort = 8888;

type
  TTMSWebSocketConnection = class;

  TTMSWebSocketBitConverter = class
    class function InTo<T>(Buffer: TArray<Byte>; Index: Integer): T;
    class procedure From<T>(Value: T; var Buffer: TArray<Byte>);
  end;

  TTMSWebSocketMessageEvent = procedure(Sender: TObject; AConnection: TTMSWebSocketConnection; const AMessage: string) of object;
  TTMSWebSocketConnectEvent = procedure(Sender: TObject; AConnection: TTMSWebSocketConnection) of object;
  TTMSWebSocketDisconnectEvent = procedure(Sender: TObject; AConnection: TTMSWebSocketConnection) of object;
  TTMSWebSocketException = class(Exception);
  TTMSWebSocketHandshakeException = class(TTMSWebSocketException);

  TTMSWebSocketRequest = class
  private
    FHost: string;
    FOrigin, FKey: string;
    FProtocol: string;
    FVersion: String;
  public
    constructor Create(const AHeaderList: TIdHeaderList);

    property Host: string read FHost;
    property Origin: string read FOrigin;
    property Protocol: string read FProtocol;
    property Version: string read FVersion;
    property Key: string read FKey;
  end;

  TTMSWebSocketFrameOpcode = (focContinuation = $0, focText = $1, focBinary = $2, focClose = $8, focPing = $9, focPong = $A);

  TTMSWebSocketFrame = class
  private
    FOpcode: TTMSWebSocketFrameOpcode;
    FIsFin: Boolean;
    FPayloadLength: Cardinal;
    FUnmaskedPayload: TBytes;
    FMaskingKey: Integer;
    FIsMasked: Boolean;
  public
    constructor Create(AOpcode: TTMSWebSocketFrameOpcode; APayload: TBytes; AIsFin: Boolean); overload;
    constructor Create; overload;
    function ToBuffer: TBytes;
    class function FromBuffer(buffer: TBytes): TTMSWebSocketFrame;
    class function UnMask(var payload: TBytes; Key: Integer): TBytes;
    property IsFin: Boolean read FIsFin write FIsFin;
    property IsMasked: Boolean read FIsMasked write FIsMasked;
    property PayloadLength: Cardinal read FPayloadLength write FPayloadLength;
    property MaskingKey: Integer read FMaskingKey write FMaskingKey;
    property UnmaskedPayload: TBytes read FUnmaskedPayload write FUnmaskedPayload;
    property Opcode: TTMSWebSocketFrameOpcode read FOpcode write FOpcode;
  end;

  TTMSWebSocketConnection = class
  private
    FPeerThread: TIdContext;
    FHandshakeRequest: TTMSWebSocketRequest;
    FHandshakeResponseSent: Boolean;
    FOnMessageReceived: TTMSWebSocketMessageEvent;
    function GetHandshakeCompleted: Boolean;
    function GetServerConnection: TIDTCPConnection;
    function GetPeerIP: string;
  protected
    const
      FRAME_START = #$00;
      FRAME_SIZE_START = #$80;
      FRAME_END = #$FF;

    procedure Handshake(const ARequestInfo: TIdHTTPRequestInfo; const AResponseInfo: TIdHTTPResponseInfo); virtual;
    procedure SendFrame(const AData: string); virtual;

    property PeerThread: TIdContext read FPeerThread write FPeerThread;
    property ServerConnection: TIDTCPConnection read GetServerConnection;
    property HandshakeRequest: TTMSWebSocketRequest read FHandshakeRequest write FHandshakeRequest;
    property HandshakeCompleted: Boolean read GetHandshakeCompleted;
    property HandshakeResponseSent: Boolean read FHandshakeResponseSent write FHandshakeResponseSent;
  public
    constructor Create(APeerThread: TIdContext);
    destructor Destroy; override;

    procedure Receive(const ARequestInfo: TIdHTTPRequestInfo; const AResponseInfo: TIdHTTPResponseInfo);
    procedure Send(const AMessage: string);
    procedure SendBytes(const ABytes: TBytes);

    property OnMessageReceived: TTMSWebSocketMessageEvent read FOnMessageReceived write FOnMessageReceived;
    property PeerIP: string read GetPeerIP;
  end;

  TTMSWebSocketConnections = class(TList<TTMSWebSocketConnection>);

  TTMSWebSocketHTTPServer = class(TIdHttpServer)
  private
    FOnDestroyNotification: TNotifyEvent;
  public
    destructor Destroy; override;
    property OnDestroyNotification: TNotifyEvent read FOnDestroyNotification write FOnDestroyNotification;
  end;

  TTMSWebSocketServer = class(TComponent)
  private
    FPort: Integer;
    FOwner: TComponent;
    FHTTPServer: TTMSWebSocketHTTPServer;
    FServerIOHandler: TIdServerIOHandlerSSLOpenSSL;
    FThreadManager: TIdScheduler;
    FConnections: TTMSWebSocketConnections;
    FOnConnect: TTMSWebSocketConnectEvent;
    FOnMessageReceived: TTMSWebSocketMessageEvent;
    FOnDisconnect: TTMSWebSocketDisconnectEvent;
    FCertificatePath: string;
    FUseSSL: Boolean;
    function GetHTTPServer: TTMSWebSocketHTTPServer;
    function GetThreadManager: TIdScheduler;
    function GetConnections: TTMSWebSocketConnections;
    function GetActive: Boolean;
    procedure SetActive(const Value: Boolean);
    function GetServerIOHandler: TIdServerIOHandlerSSLOpenSSL;
    procedure SetCertificatePath(const Value: string);
  protected
    procedure DestroyHTTPServer(Sender: TObject); virtual;
    procedure HTTPServerQuerySSLPort(APort: Word; var VUseSSL: Boolean); virtual;
    procedure HTTPServerConnect(AThread: TIdContext); virtual;
    procedure HTTPServerDisconnect(AThread: TIdContext); virtual;
    procedure HTTPServerCommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo); virtual;
    procedure MessageReceived(Sender: TObject; AConnection: TTMSWebSocketConnection; const AMessage: string); virtual;
    function DoIOHandlerVerifyPeer(Certificate: TIdX509; AOk: Boolean; ADepth, AError: Integer): Boolean;
    property ServerIOHandler: TIdServerIOHandlerSSLOpenSSL read GetServerIOHandler;
    property HTTPServer: TTMSWebSocketHTTPServer read GetHTTPServer;
    property ThreadManager: TIdScheduler read GetThreadManager;
    property Connections: TTMSWebSocketConnections read GetConnections;
  public
    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(AOwner: TComponent; APort: Integer); reintroduce; overload; virtual;
    destructor Destroy; override;
    procedure BroadcastMessage(AMessage: string); virtual;
    procedure BroadcastData(AData: TBytes); virtual;
    procedure BroadcastMessageExceptSender(AMessage: string; ASender: TTMSWebSocketConnection);
  published
    property Active: Boolean read GetActive write SetActive;
    property CertificatePath: string read FCertificatePath write SetCertificatePath;
    property UseSSL: Boolean read FUseSSL write FUseSSL;
    property Port: Integer read FPort write FPort default DefaultPort;
    property OnConnect: TTMSWebSocketConnectEvent read FOnConnect write FOnConnect;
    property OnMessageReceived: TTMSWebSocketMessageEvent read FOnMessageReceived write FOnMessageReceived;
    property OnDisconnect: TTMSWebSocketDisconnectEvent read FOnDisconnect write FOnDisconnect;
  end;

implementation

uses
  IdHashSHA, IdCoderMime, IdGlobal, IOUtils, UITypes, UIConsts
  {$IFDEF MACOS}
  ,MacApi.CoreFoundation
  {$ENDIF}
  ;

{ TTMSWebSocketServer }

procedure TTMSWebSocketServer.MessageReceived(Sender: TObject; AConnection: TTMSWebSocketConnection; const AMessage: string);
begin
  if Assigned(OnMessageReceived) and (AConnection.HandshakeCompleted) then
    OnMessageReceived(Self, AConnection, AMessage);
end;

procedure TTMSWebSocketServer.BroadcastData(AData: TBytes);
var
  ConnectionPtr: Pointer;
  Connection: TTMSWebSocketConnection;
begin
  for ConnectionPtr in Connections do
  begin
    Connection := ConnectionPtr;
    if Connection.HandshakeCompleted then
    begin
      Connection.SendBytes(AData);
    end;
  end;
end;

procedure TTMSWebSocketServer.BroadcastMessage(AMessage: string);
var
  ConnectionPtr: Pointer;
  Connection: TTMSWebSocketConnection;
begin
  for ConnectionPtr in Connections do
  begin
    Connection := ConnectionPtr;
    if Connection.HandshakeCompleted then
    begin
      Connection.Send(AMessage);
    end;
  end;
end;

procedure TTMSWebSocketServer.BroadcastMessageExceptSender(AMessage: string;
  ASender: TTMSWebSocketConnection);
var
  ConnectionPtr: Pointer;
  Connection: TTMSWebSocketConnection;
begin
  for ConnectionPtr in Connections do
  begin
    Connection := ConnectionPtr;
    if Connection.HandshakeCompleted and (Connection <> ASender) then
    begin
      Connection.Send(AMessage);
    end;
  end;
end;

constructor TTMSWebSocketServer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FUseSSL := False;
  FPort := DefaultPort;
  FCertificatePath := '';
end;

constructor TTMSWebSocketServer.Create(AOwner: TComponent; APort: Integer);
begin
  inherited Create(AOwner);
  FUseSSL := False;
  FOwner := AOwner;
  FPort := APort;
  FCertificatePath := '';
end;

destructor TTMSWebSocketServer.Destroy;
begin
  if Assigned(FConnections) then
    FConnections.Free;

  if Assigned(FHTTPServer) then
  begin
    FHTTPServer.Active := False;
    FHTTPServer.Free;
  end;

  if Assigned(FThreadManager) then
    FThreadManager.Free;

  inherited;
end;

procedure TTMSWebSocketServer.DestroyHTTPServer(Sender: TObject);
begin
  FHTTPServer := nil;
end;

function TTMSWebSocketServer.DoIOHandlerVerifyPeer(Certificate: TIdX509;
  AOk: Boolean; ADepth, AError: Integer): Boolean;
begin
  if ADepth = 0 then
  begin
    Result := AOk;
  end
  else
  begin
    Result := True;
  end;
end;

function TTMSWebSocketServer.GetActive: Boolean;
begin
  Result := HTTPServer.Active;
end;

function TTMSWebSocketServer.GetConnections: TTMSWebSocketConnections;
begin
  if not Assigned(FConnections) then
  begin
    FConnections := TTMSWebSocketConnections.Create;
  end;

  Result := FConnections;
end;

function TTMSWebSocketServer.GetHTTPServer: TTMSWebSocketHTTPServer;
begin
  if not Assigned(FHTTPServer) then
  begin
    FHTTPServer := TTMSWebSocketHTTPServer.Create(FOwner);
    FHTTPServer.OnDestroyNotification := DestroyHTTPServer;
    FHTTPServer.Scheduler := ThreadManager;
    FHTTPServer.DefaultPort := Port;

    FHTTPServer.OnQuerySSLPort := HTTPServerQuerySSLPort;
    FHTTPServer.OnConnect := HTTPServerConnect;
    FHTTPServer.OnDisconnect := HTTPServerDisconnect;
    FHTTPServer.OnCommandGet := HTTPServerCommandGet;

    FHTTPServer.IOHandler := ServerIOHandler;
  end;

  Result := FHTTPServer;
end;

function TTMSWebSocketServer.GetServerIOHandler: TIdServerIOHandlerSSLOpenSSL;
begin
  if not Assigned(FServerIOHandler) then
  begin
    FServerIOHandler := TIdServerIOHandlerSSLOpenSSL.Create(FOwner);
    FServerIOHandler.SSLOptions.CertFile := FCertificatePath;
    FServerIOHandler.SSLOptions.KeyFile := FCertificatePath;
    FServerIOHandler.SSLOptions.RootCertFile := FCertificatePath;
    FServerIOHandler.SSLOptions.Method := sslvSSLv23;
    FServerIOHandler.SSLOptions.Mode := sslmServer;
    FServerIOHandler.SSLOptions.VerifyDepth := 0;
    FServerIOHandler.SSLOptions.VerifyMode := [];
    FServerIOHandler.SSLOptions.SSLVersions := [sslvSSLv2, sslvSSLv3, sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];
    FServerIOHandler.OnVerifyPeer := DoIOHandlerVerifyPeer;
  end;

  Result := FServerIOHandler;
end;

function TTMSWebSocketServer.GetThreadManager: TIdScheduler;
begin
  if not Assigned(FThreadManager) then
  begin
    FThreadManager := TIdSchedulerOfThreadDefault.Create(nil);
  end;

  Result := FThreadManager;
end;

procedure TTMSWebSocketServer.SetActive(const Value: Boolean);
begin
  if (csDesigning in ComponentState) then
    Exit;

  HTTPServer.Active := Value;
end;

procedure TTMSWebSocketServer.SetCertificatePath(const Value: string);
begin
  FCertificatePath := Value;

  ServerIOHandler.SSLOptions.CertFile := FCertificatePath;
  ServerIOHandler.SSLOptions.KeyFile := FCertificatePath;
  ServerIOHandler.SSLOptions.RootCertFile := FCertificatePath;
end;

procedure TTMSWebSocketServer.HTTPServerCommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
const
  cSleepTime = 100;
var
  Client: TTMSWebSocketConnection;
begin
  if not ARequestInfo.Connection.Contains('Upgrade') then
  begin
    if ARequestInfo.Document = '' then
      AResponseInfo.Redirect('/')
    else if ARequestInfo.Document = '/' then
    begin
      AResponseInfo.ResponseNo := 200;
      AResponseInfo.ContentType := 'text/html';
      AResponseInfo.CharSet := 'UTF-8';
    end
    else
      AResponseInfo.ResponseNo := 404;
  end
  else
  begin
    {$IF DEFINED(IOS) OR DEFINED(ANDROID)}
    Client := AContext.DataObject as TTMSWebSocketConnection;
    {$ELSE}
    Client := AContext.Data as TTMSWebSocketConnection;
    {$ENDIF}

    while Client.ServerConnection.Connected do
    begin
      Client.Receive(ARequestInfo, AResponseInfo);
      //Allow the thread to calm down
      TThread.Sleep(cSleepTime);
    end;
  end;
end;

procedure TTMSWebSocketServer.HTTPServerConnect(AThread: TIdContext);
var
  Connection: TTMSWebSocketConnection;
begin
  Connection := TTMSWebSocketConnection.Create(AThread);
  Connection.OnMessageReceived := MessageReceived;
  Connections.Add(Connection);
  {$IF DEFINED(IOS) OR DEFINED(ANDROID)}
  AThread.DataObject := Connection;
  {$ELSE}
  AThread.Data := Connection;
  {$ENDIF}

  if Assigned(OnConnect) then
    OnConnect(Self, Connection);
end;

procedure TTMSWebSocketServer.HTTPServerDisconnect(AThread: TIdContext);
var
  Connection: TTMSWebSocketConnection;
begin
  {$IF DEFINED(IOS) OR DEFINED(ANDROID)}
  Connection := AThread.DataObject as TTMSWebSocketConnection;
  {$ELSE}
  Connection := AThread.Data as TTMSWebSocketConnection;
  {$ENDIF}

  if Assigned(OnDisconnect) then
    OnDisconnect(Self, Connection);

  {$IF DEFINED(IOS) OR DEFINED(ANDROID)}
  AThread.DataObject := nil;
  {$ELSE}
  AThread.Data := nil;
  {$ENDIF}
  Connections.Remove(Connection);
  Connection.Free;
end;

procedure TTMSWebSocketServer.HTTPServerQuerySSLPort(APort: Word;
  var VUseSSL: Boolean);
begin
  VUseSSL := FUseSSL;
end;

{ TTMSWebSocketConnection }

constructor TTMSWebSocketConnection.Create(APeerThread: TIdContext);
begin
  HandshakeResponseSent := False;
  PeerThread := APeerThread;
end;

procedure TTMSWebSocketConnection.Receive(const ARequestInfo: TIdHTTPRequestInfo; const AResponseInfo: TIdHTTPResponseInfo);
var
  msg: string;
  f: TTMSWebSocketFrame;
  b: TBytesStream;
  bs: TBytes;
begin
  if not HandshakeCompleted then
    Handshake(ARequestInfo, AResponseInfo)
  else
  begin
    if ServerConnection.IOHandler.InputBuffer.Size > 0 then
    begin
      SetLength(bs, ServerConnection.IOHandler.InputBuffer.Size);
      b := TBytesStream.Create(bs);
      ServerConnection.IOHandler.InputBufferToStream(b);
      bs := b.Bytes;
      b.Free;
      f := TTMSWebSocketFrame.FromBuffer(bs);
      if f.Opcode = focClose then
        ServerConnection.Disconnect
      else if f.Opcode = focBinary then
      begin
      end
      else if f.Opcode = focText then
      begin
        msg := TEncoding.UTF8.GetString(f.UnmaskedPayload, 0, f.PayloadLength);
        if (msg <> '') and Assigned(OnMessageReceived) then
          OnMessageReceived(Self, Self, Msg);
      end;
      f.Free;
    end;
  end;
end;

function TTMSWebSocketConnection.GetServerConnection: TIDTCPConnection;
begin
  Result := PeerThread.Connection;
end;

destructor TTMSWebSocketConnection.Destroy;
begin
  if Assigned(FHandshakeRequest) then
    FHandshakeRequest.Free;
  inherited;
end;

function TTMSWebSocketConnection.GetHandshakeCompleted: Boolean;
begin
  Result := HandshakeResponseSent;
end;

function TTMSWebSocketConnection.GetPeerIP: string;
begin
  Result := ServerConnection.Socket.Binding.PeerIP;
end;

procedure TTMSWebSocketConnection.Handshake(const ARequestInfo: TIdHTTPRequestInfo; const AResponseInfo: TIdHTTPResponseInfo);
var
  k: string;
  hash: TIdHashSHA1;
begin
  // Preconditions
  Assert(not HandshakeResponseSent);

  try
    // Read request headers
    HandshakeRequest := TTMSWebSocketRequest.Create(ARequestInfo.RawHeaders);


    AResponseInfo.ResponseNo         := 101;
    AResponseInfo.ResponseText       := 'Switching Protocols';
    AResponseInfo.CloseConnection    := False;
    AResponseInfo.Connection         := 'Upgrade';
    AResponseInfo.CustomHeaders.Values['Upgrade'] := 'websocket';

    k := Trim(HandshakeRequest.Key) + '258EAFA5-E914-47DA-95CA-C5AB0DC85B11';
    hash := TIdHashSHA1.Create;
    try
      k := TIdEncoderMIME.EncodeBytes(hash.HashString(k));
    finally
      hash.Free;
    end;

    AResponseInfo.CustomHeaders.Values['Sec-WebSocket-Accept'] := k;

    AResponseInfo.CustomHeaders.Values['Sec-WebSocket-Protocol'] := HandshakeRequest.Protocol;
    AResponseInfo.WriteHeader;

    HandshakeResponseSent := True;
  except
    on E: TTMSWebSocketHandshakeException do
    begin
      // Close the connection if the handshake failed
      ServerConnection.Disconnect;
    end;
  end;
end;

procedure TTMSWebSocketConnection.Send(const AMessage: string);
begin
  Assert(HandshakeCompleted, 'Handshake not completed!');

  SendFrame(AMessage);
end;

procedure TTMSWebSocketConnection.SendBytes(const ABytes: TBytes);
var
  fs: TTMSWebSocketFrame;
begin
  fs := TTMSWebSocketFrame.Create(focBinary, ABytes, True);
  PeerThread.Connection.IOHandler.Write(TIdBytes(fs.ToBuffer));
  fs.Free;
end;

procedure TTMSWebSocketConnection.SendFrame(const AData: string);
var
  fs: TTMSWebSocketFrame;
begin
  fs := TTMSWebSocketFrame.Create(focText, TEncoding.UTF8.GetBytes(AData), True);
  PeerThread.Connection.IOHandler.Write(TIdBytes(fs.ToBuffer));
  fs.Free;
end;

{ TTMSWebSocketRequest }

constructor TTMSWebSocketRequest.Create(const AHeaderList: TIdHeaderList);
var
  k: string;
begin
  FHost := AHeaderList.Values['Host'];
  FProtocol := AHeaderList.Values['Sec-WebSocket-Protocol'];
  FOrigin := AHeaderList.Values['Origin'];
  FVersion := AHeaderList.Values['Sec-WebSocket-Version'];

  k := AHeaderList.Values['Sec-WebSocket-Key'];
  if (Length(TIdDecoderMIME.DecodeString(k)) = 16) then
    FKey := k;
end;

{ TTMSWebSocketFrame }

constructor TTMSWebSocketFrame.Create(AOpcode: TTMSWebSocketFrameOpcode;
  APayload: TBytes; AIsFin: Boolean);
begin
  IsFin := AIsFin;
  Opcode := AOpcode;
  UnmaskedPayload := APayload;
  if Assigned(UnmaskedPayload) then
    PayloadLength := Cardinal(Length(UnmaskedPayload));

  IsMasked := False;
end;

constructor TTMSWebSocketFrame.Create;
begin

end;

procedure ReverseBytes(Source: TBytes; var Dest: TBytes; Index: Integer; Size: Integer);
var
  I: Integer;
begin
  SetLength(dest, Size);
  for I := Index to Index + Size - 1 do
    Move(Pointer(LongInt(Source) + I)^,
        Pointer(LongInt(Dest) + (Size - I - 1))^ , 1);
end;

class function TTMSWebSocketFrame.FromBuffer(
  buffer: TBytes): TTMSWebSocketFrame;
var
  payloadStartIndex: Integer;
  payloadLength: Cardinal;
  firstNibble, secondNibble: Byte;
  isMasked: Boolean;
  b, content: TBytes;
  I: Integer;
begin
  Result := TTMSWebSocketFrame.Create;
  payloadStartIndex := 2;
  firstNibble := buffer[0] and $F0;
  secondNibble := buffer[0] and $0F;

  if firstNibble = Fin then
    Result.IsFin := True;

  Result.Opcode := TTMSWebSocketFrameOpcode(secondNibble);
  isMasked := Boolean((buffer[1] and $90) shr 7);
  payloadLength := buffer[1] and $7F;

  if payloadLength = TwoBytesLengthCode then
  begin
    ReverseBytes(buffer, b, payloadStartIndex, 2);
    buffer := b;
    payloadLength := TTMSWebSocketBitConverter.InTo<UInt16>(buffer, payloadStartIndex);
    payloadStartIndex := payloadStartIndex + 2;
  end
  else if payloadLength = EightBytesLengthCode then
  begin
    ReverseBytes(buffer, b, payloadStartIndex, 8);
    payloadLength := TTMSWebSocketBitConverter.InTo<UInt64>(buffer, payloadStartIndex);
    payloadStartIndex := payloadStartIndex + 8;
  end;

  Result.PayloadLength := payloadLength;

  if isMasked then
  begin
    Result.MaskingKey := TTMSWebSocketBitConverter.InTo<Int32>(buffer, payloadStartIndex);
    payloadStartIndex := payloadStartIndex + 4;
  end;

  SetLength(content, Result.PayloadLength);
  for I := 0 to Result.PayloadLength - 1 do
    content[I] := buffer[payloadStartIndex + I];

  if isMasked then
    UnMask(content, Result.MaskingKey);

  Result.UnmaskedPayload := content;
end;

function TTMSWebSocketFrame.ToBuffer: TBytes;
var
  firstByte: Byte;
  buffer, LengthBytes, l: TBytes;
  I: Integer;
begin
  firstByte := Byte(Opcode);
  if IsFin then
    firstByte := firstByte or Fin;

  if PayloadLength <= 0 then
  begin
    SetLength(buffer, 2);
    buffer[0] := firstByte;
    buffer[1] := Byte(PayloadLength);
    Result := Buffer;
  end
  else if PayloadLength < TwoBytesLengthCode then
  begin
    SetLength(buffer, PayloadLength + 2);
    buffer[0] := firstByte;
    buffer[1] := Byte(PayloadLength);
    for I := 0 to PayloadLength - 1 do
      buffer[2 + I] := UnmaskedPayload[I];

    Result := buffer;
  end
  else if PayloadLength < (1 shl 16) then
  begin
    SetLength(buffer, PayloadLength + 4);
    buffer[0] := firstByte;
    buffer[1] := TwoBytesLengthCode;

    SetLength(l, SizeOf(UInt16));
    TTMSWebSocketBitConverter.From(UInt16(PayloadLength), l);
    ReverseBytes(l, LengthBytes, 0, Length(l));

    for I := 0 to 1 do
      buffer[2 + I] := LengthBytes[I];

    for I := 0 to PayloadLength - 1 do
      buffer[4 + I] := UnmaskedPayload[I];

    Result := buffer;
  end
  else
  begin
    SetLength(buffer, PayloadLength + 10);
    buffer[0] := firstByte;
    buffer[1] := EightBytesLengthCode;

    SetLength(l, Sizeof(UInt64));
    TTMSWebSocketBitConverter.From<UInt64>(PayloadLength, l);
    ReverseBytes(l, LengthBytes, 0, Length(l));

    for I := 0 to 7 do
      buffer[2 + I] := LengthBytes[I];

    for I := 0 to PayloadLength - 1 do
      buffer[10 + I] := UnmaskedPayload[I];

    Result := buffer;
  end;
end;

class function TTMSWebSocketFrame.UnMask(var payload: TBytes;
  Key: Integer): TBytes;
var
  currentMaskIndex: Integer;
  byteKeys: TBytes;
  I: Integer;
begin
  currentMaskIndex := 0;
  SetLength(byteKeys, SizeOf(Key));
  TTMSWebSocketBitConverter.From<Integer>(Key, byteKeys);
  for I := 0 to Length(payload) - 1 do
  begin
    payload[I] := payload[I] XOR byteKeys[currentMaskIndex];
    currentMaskIndex := (currentMaskIndex + 1) mod 4;
  end;
end;

{ TTMSWebSocketBitConverter }

class procedure TTMSWebSocketBitConverter.From<T>(Value: T; var Buffer: TArray<Byte>);
begin
  Move(Value, Buffer[0], SizeOf(T));
end;

class function TTMSWebSocketBitConverter.InTo<T>(Buffer: TArray<Byte>; Index: Integer): T;
begin
  Move(Buffer[Index], Result, SizeOf(T));
end;

{ TTMSWebSocketHTTPServer }

destructor TTMSWebSocketHTTPServer.Destroy;
begin
  if Assigned(OnDestroyNotification) then
    OnDestroyNotification(Self);
  inherited;
end;

end.