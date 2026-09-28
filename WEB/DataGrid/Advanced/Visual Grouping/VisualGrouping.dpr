program VisualGrouping;

uses
  VCL.Forms,
  WEBLib.Forms,
  UVisualGrouping in 'UVisualGrouping.pas' {Form130: TWebForm} {*.html};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm130, Form130);
  Application.Run;
end.
