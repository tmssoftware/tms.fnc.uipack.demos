program ConditionalFormatting;

uses
  VCL.Forms,
  WEBLib.Forms,
  UConditionalFormatting in 'UConditionalFormatting.pas' {frmConditionalFormatting: TWebForm} {*.html};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmConditionalFormatting, frmConditionalFormatting);
  Application.Run;
end.
