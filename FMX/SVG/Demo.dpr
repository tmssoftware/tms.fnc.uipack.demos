program Demo;



uses
  System.StartUpCopy,
  FMX.Forms,
  UDemo in '..\..\Shared Code\Form Unit\SVG\UDemo.pas' {Form1: TWebForm},
  UBL in '..\..\Shared Code\Business Logic\SVG\UBL.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
