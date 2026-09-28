program ConditionalFormatting;

uses
  VCL.Forms,
  UConditionalFormatting in 'UConditionalFormatting.pas' {frmConditionalFormatting};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmConditionalFormatting, frmConditionalFormatting);
  Application.Run;
end.
