program ControlPickerDemo;

uses
  System.StartUpCopy,
  FMX.Forms,
  UControlPickerDemo in 'UControlPickerDemo.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
