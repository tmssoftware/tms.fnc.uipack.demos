unit UDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, FMX.Forms,
  FMX.TMSFNCCustomControl, FMX.TMSFNCCustomScrollControl, FMX.TMSFNCListEditor,
  FMX.StdCtrls, FMX.Layouts, FMX.ListBox, FMX.Types, FMX.Controls,
  FMX.Controls.Presentation;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    ListBox1: TListBox;
    Button1: TButton;
    GroupBox2: TGroupBox;
    TMSFNCListEditor2: TTMSFNCListEditor;
    Label2: TLabel;
    Label3: TLabel;
    TMSFNCListEditor1: TTMSFNCListEditor;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TMSFNCListEditor2ItemClick(Sender: TObject; AItemIndex: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
var
  i: integer;
begin
  ListBox1.Items.Clear;
  for i := 0 to TMSFNCListEditor1.Items.Count - 1 do
    ListBox1.Items.Add(TMSFNCListEditor1.Items[i].Text);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  TMSFNCListEditor1.ItemAppearance.RoundingNormal := 0;
  TMSFNCListEditor1.ItemAppearance.RoundingSelected := 0;
  TMSFNCListEditor2.SelectedItemIndex := 0;
  Label2.Text := TMSFNCListEditor2.Items[0].Value;
end;

procedure TForm1.TMSFNCListEditor2ItemClick(Sender: TObject;
  AItemIndex: Integer);
begin
  Label2.Text := TMSFNCListEditor2.Items[AItemIndex].Value;
end;

end.
