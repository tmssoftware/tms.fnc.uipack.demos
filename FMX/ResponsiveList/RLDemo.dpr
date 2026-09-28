program RLDemo;

uses
  System.StartUpCopy,
  FMX.Forms,
  URLDemo in 'URLDemo.pas' {Form4};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
