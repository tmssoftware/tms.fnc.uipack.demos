program MasterDetailFireDacSQLite;

uses
  System.StartUpCopy,
  FMX.Forms,
  UMasterDetailFireDacSQLite in 'UMasterDetailFireDacSQLite.pas' {Form130};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm130, Form130);
  Application.Run;
end.
