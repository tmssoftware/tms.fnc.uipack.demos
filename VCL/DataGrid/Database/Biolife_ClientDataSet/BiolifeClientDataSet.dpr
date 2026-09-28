program BiolifeClientDataSet;

uses
  VCL.Forms, 
  UBiolifeClientDataSet in 'UBiolifeClientDataSet.pas' {Form130};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm130, Form130);
  Application.Run;
end.
