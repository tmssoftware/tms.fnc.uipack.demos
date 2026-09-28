unit UDemo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  LCLTMSFNCListEditor;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ListBox1: TListBox;
    TMSFNCListEditor1: TTMSFNCListEditor;
    TMSFNCListEditor2: TTMSFNCListEditor;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TMSFNCListEditor2ItemClick(Sender: TObject; AItemIndex: Integer);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  TMSFNCListEditor1.ItemAppearance.RoundingNormal := 0;
  TMSFNCListEditor1.ItemAppearance.RoundingSelected := 0;
  TMSFNCListEditor2.SelectedItemIndex := 0;
  Label4.Caption := TMSFNCListEditor2.Items[0].Value;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i: integer;
begin
  ListBox1.Items.Clear;
  for i := 0 to TMSFNCListEditor1.Items.Count - 1 do
    ListBox1.Items.Add(TMSFNCListEditor1.Items[i].Text);
end;

procedure TForm1.TMSFNCListEditor2ItemClick(Sender: TObject; AItemIndex: Integer
  );
begin
  Label4.Caption := TMSFNCListEditor2.Items[AItemIndex].Value;
end;

end.

