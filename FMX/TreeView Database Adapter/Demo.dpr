program Demo;

uses
  System.StartUpCopy,
  FMX.Forms,
  UDemo in '..\..\Shared Code\Form Unit\TreeView Database Adapter\UDemo.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
