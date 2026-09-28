program TVGuideDemoFMX;

uses
  System.StartUpCopy,
  FMX.Forms,
  UTVGuideDemoFMX in 'UTVGuideDemoFMX.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
