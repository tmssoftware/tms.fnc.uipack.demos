program Demo;

uses
  Vcl.Forms,
  UMain in 'UMain.pas' {Main},
  UAppData in 'UAppData.pas' {AppData: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  { the data module first: it loads the services while the form is made, and the grid finds its columns }
  Application.CreateForm(TAppData, AppData);
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
