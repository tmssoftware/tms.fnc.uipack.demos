program VisualGrouping;

uses
  System.StartUpCopy,
  FMX.Forms,
  UVisualGrouping in 'UVisualGrouping.pas' {Form130};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm130, Form130);
  Application.Run;
end.
