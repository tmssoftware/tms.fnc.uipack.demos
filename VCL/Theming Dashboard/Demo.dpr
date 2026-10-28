program Demo;

uses
  Vcl.Forms,
  UOrdersData in '..\..\Shared Code\Business Logic\Theming Dashboard\UOrdersData.pas' {OrdersData: TDataModule},
  UDemo in '..\..\Shared Code\Form Unit\Theming Dashboard\UDemo.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TOrdersData, OrdersData);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
