program AutoFill;

uses
  System.StartUpCopy,
  FMX.Forms,
  UAutoFill in 'UAutoFill.pas' {FormAutoFill};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormAutoFill, FormAutoFill);
  Application.Run;
end.
