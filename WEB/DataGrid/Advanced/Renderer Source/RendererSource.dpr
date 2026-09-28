program RendererSource;

uses
  Vcl.Forms,
  WEBLib.Forms,
  URendererSource in 'URendererSource.pas' {FormRendererSource: TWebForm} {*.html};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormRendererSource, FormRendererSource);
  Application.Run;
end.
