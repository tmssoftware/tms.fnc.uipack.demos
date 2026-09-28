program FNCUITreeView;

uses
  System.StartUpCopy,
  FMX.Forms,
  UFNCUITreeView in 'UFNCUITreeView.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
