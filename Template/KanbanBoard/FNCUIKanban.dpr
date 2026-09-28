program FNCUIKanban;

uses
  System.StartUpCopy,
  FMX.Forms,
  UFNCUIKanban in 'UFNCUIKanban.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
