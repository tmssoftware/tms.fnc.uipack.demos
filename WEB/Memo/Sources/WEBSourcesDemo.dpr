program WEBSourcesDemo;

uses
  Vcl.Forms,
  WEBLib.Forms,
  Main in 'Main.pas' {Form4: TWebForm} {*.html};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
