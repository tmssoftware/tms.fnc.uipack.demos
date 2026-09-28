program CellControls;

uses
  System.StartUpCopy,
  FMX.Forms,
  UCellControls in 'UCellControls.pas' {Form130};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm130, Form130);
  Application.Run;
end.
