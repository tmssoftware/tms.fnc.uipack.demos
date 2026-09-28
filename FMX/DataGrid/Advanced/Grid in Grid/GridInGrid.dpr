program GridInGrid;

uses
  System.StartUpCopy,
  FMX.Forms,
  UGridInGrid in 'UGridInGrid.pas' {Form130};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm130, Form130);
  Application.Run;
end.
