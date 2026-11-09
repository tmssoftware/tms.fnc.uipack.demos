program TMSWeb_FNCSplitView;

uses
  WEBLib.Forms,
  UDemoLayout in '..\..\Shared Code\Business Logic\Demo Layout\UDemoLayout.pas',
  UDemo in '..\..\Shared Code\Form Unit\SplitView\UDemo.pas' {Form1: TWebForm} {*.html};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
