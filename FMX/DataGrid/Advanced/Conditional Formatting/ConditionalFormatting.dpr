program ConditionalFormatting;

uses
  System.StartUpCopy,
  FMX.Forms,
  UConditionalFormatting in 'UConditionalFormatting.pas' {frmConditionalFormatting};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmConditionalFormatting, frmConditionalFormatting);
  Application.Run;
end.
