program NonVisualDataExport;

uses
  System.StartUpCopy,
  FMX.Forms,
  UNonVisualDataExport in 'UNonVisualDataExport.pas' {Form130};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm130, Form130);
  Application.Run;
end.
