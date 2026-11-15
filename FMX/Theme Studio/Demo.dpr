program Demo;

uses
  System.StartUpCopy,
  FMX.Forms,
  UDemoLayout in '..\..\Shared Code\Business Logic\Demo Layout\UDemoLayout.pas',
  UDemo in '..\..\Shared Code\Form Unit\Theme Studio\UDemo.pas' {Form1};

{$R *.res}
{ the platform styles the standard controls follow the theme with (Windows) }
{$IFDEF MSWINDOWS}
{$R *.dres}
{$ENDIF}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
