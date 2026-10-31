program TMSWeb_FNCTreeViewDatabaseAdapter;

uses
  WEBLib.Forms,
  UDemo in '..\..\Shared Code\Form Unit\TreeView Database Adapter\UDemo.pas' {Form1: TWebForm} {*.html};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
