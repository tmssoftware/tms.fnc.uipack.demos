unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VCL.TMSFNCTypes, VCL.TMSFNCUtils,
  VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, VCL.TMSFNCCustomControl, VCL.TMSFNCTableView,
  VCL.TMSFNCChat, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    TMSFNCChat1: TTMSFNCChat;
    IdTCPClient1: TIdTCPClient;
    Timer1: TTimer;
    Panel1: TPanel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Edit3: TEdit;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure IdTCPClient1Connected(Sender: TObject);
    procedure TMSFNCChat1SendMessage(Sender: TObject;
      var AItem: TTMSFNCChatItem);
    procedure IdTCPClient1Disconnected(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  JSON;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  if Trim(Edit3.Text) = '' then
  begin
    ShowMessage('Username cannot be empty!');
    Exit;
  end;

  if Button1.Enabled then
  begin
    IdTCPClient1.Host := Edit1.Text;
    IdTCPClient1.Port := StrToInt(Edit2.Text);
    IdTCPClient1.Connect;
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Timer1.Enabled := False;
  IdTCPClient1.Disconnect;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  TMSFNCChat1.Clear;
  TMSFNCChat1.DisableInputControls;
end;

procedure TForm1.IdTCPClient1Connected(Sender: TObject);
begin
  TMSFNCChat1.EnableInputControls;
  Timer1.Enabled := True;
  Button1.Enabled := False;
  Edit1.Enabled := False;
  Edit2.Enabled := False;
  Edit3.Enabled := False;
end;

procedure TForm1.IdTCPClient1Disconnected(Sender: TObject);
begin
  Timer1.Enabled := False;
  Button1.Enabled := True;
  Edit1.Enabled := True;
  Edit2.Enabled := True;
  Edit3.Enabled := True;
  TMSFNCChat1.DisableInputControls;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  msg, text, user: string;
  j: TJSONValue;
begin
  try
    if IdTCPClient1.IOHandler.InputBufferIsEmpty then
    begin
      IdTCPClient1.IOHandler.CheckForDataOnSource(10);
      IdTCPClient1.IOHandler.CheckForDisconnect;

      if IdTCPClient1.IOHandler.InputBufferIsEmpty then
        Exit;
    end;
    msg := IdTCPClient1.IOHandler.ReadLn;

    j := TTMSFNCUtils.ParseJSON(msg);
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
  except
    IdTCPClient1.Disconnect;
  end;
end;

procedure TForm1.TMSFNCChat1SendMessage(Sender: TObject;
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
    j.AddPair('name', Edit3.Text);
    j.AddPair('message', AItem.Text);

    IdTCPClient1.IOHandler.WriteLn(j.ToJSON);
  finally
    j.Free
  end;
end;

end.
