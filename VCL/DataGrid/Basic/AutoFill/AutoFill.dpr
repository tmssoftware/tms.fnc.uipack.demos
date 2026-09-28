program AutoFill;

uses
  VCL.Forms,
  UAutoFill in 'UAutoFill.pas' {FormAutoFill};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormAutoFill, FormAutoFill);
  Application.Run;
end.
