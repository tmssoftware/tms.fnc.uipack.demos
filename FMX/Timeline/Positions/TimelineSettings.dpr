program TimelineSettings;

uses
  System.StartUpCopy,
  FMX.Forms,
  UTimelineSettings in 'UTimelineSettings.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
