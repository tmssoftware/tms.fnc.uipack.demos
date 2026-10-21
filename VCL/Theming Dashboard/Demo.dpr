program Demo;

uses
  Vcl.Forms,
  UBL in '..\..\Shared Code\Business Logic\Theming Dashboard\UBL.pas',
  UDemo in '..\..\Shared Code\Form Unit\Theming Dashboard\UDemo.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
