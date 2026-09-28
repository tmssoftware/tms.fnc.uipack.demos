program CellControls;

uses
  VCL.Forms, 
  WEBLib.Forms,
  UCellControls in 'UCellControls.pas' {Form130: TWebForm} {*.html};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm130, Form130);
  Application.Run;
end.
