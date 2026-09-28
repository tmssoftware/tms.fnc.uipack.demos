program BiolifeClientDataSet;

uses
  System.StartUpCopy,
  FMX.Forms,
  UBiolifeClientDataSet in 'UBiolifeClientDataSet.pas' {Form130};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm130, Form130);
  Application.Run;
end.
