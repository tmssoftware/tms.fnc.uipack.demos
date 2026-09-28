program AutoFill;

uses
  VCL.Forms,
  WEBLib.Forms,
  UAutoFill in 'UAutoFill.pas' {FormAutoFill: TWebForm} {*.html};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormAutoFill, FormAutoFill);
  Application.Run;
end.
