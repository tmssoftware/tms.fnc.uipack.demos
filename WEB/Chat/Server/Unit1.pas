unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, WEBLib.WebSocketServer, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FTCPServer: TTMSWebSocketServer;
    procedure MessageReceived(Sender: TObject; AConnection: TTMSWebSocketConnection; const AMessage: string);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  Button1.Enabled := False;
  FTCPServer.Active := True;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FTCPServer := TTMSWebSocketServer.Create(Self);
  FTCPServer.Port := 8888;
  FTCPServer.OnMessageReceived := MessageReceived;
end;

procedure TForm1.MessageReceived(Sender: TObject;
  AConnection: TTMSWebSocketConnection; const AMessage: string);
begin
  FTCPServer.BroadcastMessageExceptSender(AMessage, AConnection);
end;

end.
