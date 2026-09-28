program TMSWeb_FNCTileList;

uses
  WEBLib.Forms,
  UDemo in 'UDemo.pas' {Form43: TWebForm} {*.html};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm43, Form43);
  Application.Run;
end.
