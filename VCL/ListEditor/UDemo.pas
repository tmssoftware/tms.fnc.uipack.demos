unit UDemo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, VCL.TMSFNCListEditor, VCL.TMSFNCListBox,
  VCL.TMSFNCCustomControl, VCL.TMSFNCCustomScrollControl, VCL.TMSFNCTypes,
  VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes,
  VCL.TMSFNCButton, VCL.TMSFNCHTMLText, VCL.TMSFNCPanel, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector;

type
  TForm130 = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TTMSFNCPanel;
    DemoTitle: TTMSFNCHTMLText;
    DemoDescription: TTMSFNCHTMLText;
    DemoThemeSelector: TTMSFNCThemeSelector;
    Section2: TTMSFNCHTMLText;
    Section1: TTMSFNCHTMLText;
    GroupBox1: TTMSFNCPanel;
    Label2: TTMSFNCHTMLText;
    TMSFNCListEditor1: TTMSFNCListEditor;
    TMSFNCListEditor2: TTMSFNCListEditor;
    Button1: TTMSFNCButton;
    ListBox1: TTMSFNCListBox;
    GroupBox2: TTMSFNCPanel;
    Label3: TTMSFNCHTMLText;
    Label4: TTMSFNCHTMLText;
    procedure TMSFNCListEditor2ItemClick(Sender: TObject; AItemIndex: Integer);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form130: TForm130;

implementation

{$R *.dfm}

procedure TForm130.Button1Click(Sender: TObject);
var
  i: integer;
begin
  ListBox1.Items.Clear;
  for i := 0 to TMSFNCListEditor1.Items.Count - 1 do
    ListBox1.Items.Add.Text := TMSFNCListEditor1.Items[i].Text;
end;

procedure TForm130.FormCreate(Sender: TObject);
begin
  TMSFNCListEditor1.ItemAppearance.RoundingNormal := 0;
  TMSFNCListEditor1.ItemAppearance.RoundingSelected := 0;
  TMSFNCListEditor2.SelectedItemIndex := 0;
  Label4.Text := TMSFNCListEditor2.Items[0].Value;
end;

procedure TForm130.TMSFNCListEditor2ItemClick(Sender: TObject;
  AItemIndex: Integer);
begin
  Label4.Text := TMSFNCListEditor2.Items[AItemIndex].Value;
end;

end.
