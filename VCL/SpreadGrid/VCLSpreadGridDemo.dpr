program VCLSpreadGridDemo;

uses
  Vcl.Forms,
  Uspreadgriddemo in 'Uspreadgriddemo.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
