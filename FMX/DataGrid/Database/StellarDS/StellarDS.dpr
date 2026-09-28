program StellarDS;

uses
  System.StartUpCopy,
  FMX.Forms,
  UStelllarDS in 'UStelllarDS.pas' {Form130};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm130, Form130);
  Application.Run;
end.
