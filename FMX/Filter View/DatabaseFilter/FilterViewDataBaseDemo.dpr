program FilterViewDataBaseDemo;

uses
  System.StartUpCopy,
  FMX.Forms,
  UFilterViewDataBaseDemo in 'UFilterViewDataBaseDemo.pas' {FilterViewDemoForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFilterViewDemoForm, FilterViewDemoForm);
  Application.Run;
end.
