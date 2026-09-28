program TimelineDatabaseAdapterDemo;

uses
  System.StartUpCopy,
  FMX.Forms,
  UTimelineDatabaseAdapterDemo in 'UTimelineDatabaseAdapterDemo.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
