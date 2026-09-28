program Demo;

uses
  Vcl.Forms,
  UBL in '..\..\Shared Code\Business Logic\PDFLib BMI\UBL.pas',
  UDemo in '..\..\Shared Code\Form Unit\PDFLib BMI\UDemo.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
