program Demo;

uses
  Vcl.Forms,
  UDemo in '..\..\Shared Code\Form Unit\TreeView Database Adapter\UDemo.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
