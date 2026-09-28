program FNCUIGrid;

uses
  System.StartUpCopy,
  FMX.Forms,
  UFNCUIGrid in 'UFNCUIGrid.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
