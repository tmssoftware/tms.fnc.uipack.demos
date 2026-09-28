program XLSExport;

uses
  System.StartUpCopy,
  FMX.Forms,
  UXLSExport in 'UXLSExport.pas' {Form130};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm130, Form130);
  Application.Run;
end.
