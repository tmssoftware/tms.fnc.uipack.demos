program TMSWeb_FNCPDFLibBMI;

{$R *.dres}

uses
  WEBLib.Forms,
  UBL in '..\..\Shared Code\Business Logic\PDFLib BMI\UBL.pas',
  UDemo in '..\..\Shared Code\Form Unit\PDFLib BMI\UDemo.pas' {Form1: TWebForm} {*.html};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
