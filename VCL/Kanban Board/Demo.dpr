program Demo;

uses
  Vcl.Forms,
  UBL in '..\..\Shared Code\Business Logic\Kanban Board\UBL.pas',
  UDemo in '..\..\Shared Code\Form Unit\Kanban Board\UDemo.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
