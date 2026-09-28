program TMSWeb_FNCChat;

uses
  WEBLib.Forms,
  UClient in 'UClient.pas' {Form43: TWebForm} {*.html};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm43, Form43);
  Application.Run;
end.
