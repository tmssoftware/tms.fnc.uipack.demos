unit UClient;

interface

uses
  System.SysUtils, System.Classes, WEBLib.Graphics, WEBLib.Forms, WEBLib.Dialogs,
  Vcl.StdCtrls, WEBLib.StdCtrls, Vcl.Controls, WEBLib.WebSocketClient, JS,
  WEBLib.Controls, WEBLib.ExtCtrls, VCL.TMSFNCListBox, VCL.TMSFNCTypes,
  VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes,
  VCL.TMSFNCCustomControl, VCL.TMSFNCCustomPicker, VCL.TMSFNCColorPicker, Types,
  VCL.TMSFNCTableView, VCL.TMSFNCChat;

type
  TForm43 = class(TWebForm)
    WebSocketClient1: TWebSocketClient;
    WebLabel3: TWebLabel;
    WebLabel4: TWebLabel;
    WebPanel1: TWebPanel;
    WebLabel1: TWebLabel;
    WebButton1: TWebButton;
    WebEdit1: TWebEdit;
    TMSFNCChat1: TTMSFNCChat;
    WebLabel2: TWebLabel;
    WebLabel5: TWebLabel;
    WebEdit2: TWebEdit;
    WebEdit3: TWebEdit;
    procedure WebFormCreate(Sender: TObject);
    procedure WebButton1Click(Sender: TObject);
    procedure TMSFNCChat1SendMessage(Sender: TObject;
      var AItem: TTMSFNCChatItem);
    procedure WebSocketClient1DataReceived(Sender: TObject; Origin: string;
      SocketData: TJSObjectRecord);
    procedure WebSocketClient1Connect(Sender: TObject);
    procedure WebSocketClient1Disconnect(Sender: TObject);
  private
  end;

var
  Form43: TForm43;

implementation

uses
  WEBLib.JSON, WEBLib.TMSFNCTypes;

{$R *.dfm}


procedure TForm43.TMSFNCChat1SendMessage(Sender: TObject;
  var AItem: TTMSFNCChatItem);
var
  j: TJSONObject;
begin
  AItem.Fill.Color := gcDodgerblue;
  AItem.TitleColor := gcWhite;
  AItem.TextColor := gcWhite;
  AItem.Title := 'Me';

  //send msg
  j := TJSONObject.Create;
  try
    j.AddPair('name', WebEdit1.Text);
    j.AddPair('message', AItem.Text);

    WebSocketClient1.Send(j.ToJSON);
  finally
    j.Free
  end;
end;

procedure TForm43.WebButton1Click(Sender: TObject);
begin
  if Trim(WebEdit1.Text) = '' then
  begin
    ShowMessage('Username cannot be empty!');
    Exit;
  end;

  if WebButton1.Enabled then
  begin
    WebSocketClient1.HostName := WebEdit2.Text;
    WebSocketClient1.Port := StrToInt(WebEdit3.Text);
    WebSocketClient1.Connect;
  end;
end;

procedure TForm43.WebFormCreate(Sender: TObject);
begin
  TMSFNCChat1.Clear;
  TMSFNCChat1.DisableInputControls;
end;

procedure TForm43.WebSocketClient1Connect(Sender: TObject);
begin
  TMSFNCChat1.EnableInputControls;
  WebButton1.Enabled := False;
  WebEdit1.Enabled := False;
  WebEdit2.Enabled := False;
  WebEdit3.Enabled := False;
end;

procedure TForm43.WebSocketClient1DataReceived(Sender: TObject; Origin: string;
  SocketData: TJSObjectRecord);
var
  msg, text, user: string;
  j: TJSONValue;
begin
  j := TTMSFNCUtils.ParseJSON(SocketData.jsobject.toString);
  if Assigned(j) then
  begin
    try
      user := j['name'].AsString;
      text := j['message'].AsString;
    finally
      j.Free;
    end;
  end;

  TMSFNCChat1.AddMessage(text, user, cmlLeft, False);
end;

procedure TForm43.WebSocketClient1Disconnect(Sender: TObject);
begin
  WebButton1.Enabled := True;
  WebEdit1.Enabled := True;
  WebEdit2.Enabled := True;
  WebEdit3.Enabled := True;
  TMSFNCChat1.DisableInputControls;
end;

end.
