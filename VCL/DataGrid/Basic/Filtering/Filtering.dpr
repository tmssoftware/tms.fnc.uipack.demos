program Filtering;

uses
  VCL.Forms, 
  UFiltering in 'UFiltering.pas' {Form130};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm130, Form130);
  Application.Run;
end.
