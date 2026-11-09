program TMSWeb_FNCToast;

uses
  WEBLib.Forms,
  UDemoLayout in '..\..\Shared Code\Business Logic\Demo Layout\UDemoLayout.pas',
  UDemo in '..\..\Shared Code\Form Unit\Toast\UDemo.pas' {Form1: TWebForm} {*.html};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
