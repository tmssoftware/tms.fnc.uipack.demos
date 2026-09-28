program CellControls;

uses
  VCL.Forms, 
  UCellControls in 'UCellControls.pas' {Form130};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm130, Form130);
  Application.Run;
end.
