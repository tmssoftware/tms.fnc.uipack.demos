program Demo;

uses
  System.SysUtils, System.IOUtils,
  Vcl.Forms,
  UDemo in '..\..\Shared Code\Form Unit\Styles\UDemo.pas';

{$R *.res}

var
  I: Integer;
  OutputFolder: string;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  try
    Application.CreateForm(TForm1, Form1);
    Application.Run;
  except
    on E: Exception do
    begin
      if FindCmdLineSwitch('self-check') or FindCmdLineSwitch('-self-check') then
      begin
        OutputFolder := TPath.Combine(ExtractFilePath(ParamStr(0)), 'output');
        for I := 1 to ParamCount - 1 do
          if ParamStr(I) = '--output' then
            OutputFolder := ExpandFileName(ParamStr(I + 1));
        ForceDirectories(OutputFolder);
        TFile.WriteAllText(TPath.Combine(OutputFolder, 'error.txt'), E.ClassName + ': ' + E.Message);
        System.ExitCode := 1;
      end
      else
        raise;
    end;
  end;
end.
