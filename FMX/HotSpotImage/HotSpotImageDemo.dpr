program HotSpotImageDemo;

uses
  System.StartUpCopy,
  FMX.Forms,
  UHotSpotImageDemo in 'UHotSpotImageDemo.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
