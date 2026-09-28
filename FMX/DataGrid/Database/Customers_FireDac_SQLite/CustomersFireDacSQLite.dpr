program CustomersFireDacSQLite;

uses
  System.StartUpCopy,
  FMX.Forms,
  UCustomersFireDacSQLite in 'UCustomersFireDacSQLite.pas' {Form130};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm130, Form130);
  Application.Run;
end.
