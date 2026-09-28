program TVGuideDemoWEB;

uses
  Vcl.Forms,
  WEBLib.Forms,
  UTVGuideDemoWEB in 'UTVGuideDemoWEB.pas' {Form1: TWebForm} {*.html};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
