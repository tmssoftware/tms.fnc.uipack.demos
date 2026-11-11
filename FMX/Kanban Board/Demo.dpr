program Demo;

uses
  System.StartUpCopy,
  FMX.Forms,
  UDemo in '..\..\Shared Code\Form Unit\Kanban Board\UDemo.pas' {Form1},
  UDemoLayout in '..\..\Shared Code\Business Logic\Demo Layout\UDemoLayout.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
