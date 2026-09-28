program RendererSource;

uses
  Vcl.Forms,
  URendererSource in 'URendererSource.pas' {FormRendererSource};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormRendererSource, FormRendererSource);
  Application.Run;
end.
