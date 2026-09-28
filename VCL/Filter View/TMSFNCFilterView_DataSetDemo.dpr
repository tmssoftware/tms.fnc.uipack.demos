program TMSFNCFilterView_DataSetDemo;

uses
  VCL.Forms,
  UTMSFNCFilterView_DataSetDemo in 'UTMSFNCFilterView_DataSetDemo.pas' {FilterViewDemoForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFilterViewDemoForm, FilterViewDemoForm);
  Application.Run;
end.
