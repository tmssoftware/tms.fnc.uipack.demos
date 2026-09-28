program PDFExport;

uses
  System.StartUpCopy,
  FMX.Forms,
  UPDFExport in 'UPDFExport.pas' {Form130};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm130, Form130);
  Application.Run;
end.
