program DataGridFilter;

uses
  System.StartUpCopy,
  FMX.Forms,
  UDataGridFilter in 'UDataGridFilter.pas' {FilterViewDataGridForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFilterViewDataGridForm, FilterViewDataGridForm);
  Application.Run;
end.
