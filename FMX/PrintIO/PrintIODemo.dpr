program PrintIODemo;

uses
  System.StartUpCopy,
  FMX.Forms,
  UPrintIODemo in 'UPrintIODemo.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
