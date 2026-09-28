program Filtering;

uses
  System.StartUpCopy,
  FMX.Forms,
  UFiltering in 'UFiltering.pas' {Form130};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm130, Form130);
  Application.Run;
end.
