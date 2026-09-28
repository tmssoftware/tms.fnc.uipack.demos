program RendererSource;

uses
  System.StartUpCopy,
  FMX.Forms,
  URendererSource in 'URendererSource.pas' {FormRendererSource};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormRendererSource, FormRendererSource);
  Application.Run;
end.
