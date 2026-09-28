program FNCUIPlanner;

uses
  System.StartUpCopy,
  FMX.Forms,
  UFNCUIPlanner in 'UFNCUIPlanner.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
