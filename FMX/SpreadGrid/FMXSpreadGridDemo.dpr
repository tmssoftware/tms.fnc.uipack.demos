program FMXSpreadGridDemo;

uses
  System.StartUpCopy,
  FMX.Forms,
  Uspreadgriddemo in 'Uspreadgriddemo.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
