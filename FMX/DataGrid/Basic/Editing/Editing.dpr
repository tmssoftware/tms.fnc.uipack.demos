program Editing;

uses
  System.StartUpCopy,
  FMX.Forms,
  UEditing in 'UEditing.pas' {Form130};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm130, Form130);
  Application.Run;
end.
