program Sorting;

uses
  System.StartUpCopy,
  FMX.Forms,
  USorting in 'USorting.pas' {Form130};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm130, Form130);
  Application.Run;
end.
