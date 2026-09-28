program BiolifeClientDataSetFilteringSorting;

uses
  System.StartUpCopy,
  FMX.Forms,
  UBiolifeClientDataSetFilteringSorting in 'UBiolifeClientDataSetFilteringSorting.pas' {Form130};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm130, Form130);
  Application.Run;
end.
