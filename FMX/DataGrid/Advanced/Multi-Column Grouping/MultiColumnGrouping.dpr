program MultiColumnGrouping;

uses
  System.StartUpCopy,
  FMX.Forms,
  UMultiColumnGrouping in 'UMultiColumnGrouping.pas' {Form130};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm130, Form130);
  Application.Run;
end.
