unit Urldemo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VCL.TMSFNCScrollControl,
  VCL.TMSFNCResponsiveList, Vcl.StdCtrls, VCL.TMSFNCTypes, VCL.TMSFNCUtils,
  VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes;

type
  TForm3 = class(TForm)
    TMSFNCResponsiveList1: TTMSFNCResponsiveList;
    Label2: TLabel;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.FormCreate(Sender: TObject);
var
  sl,col: TStringList;
  i: integer;
begin
  TMSFNCResponsiveList1.Items.Clear;

  sl := TStringList.Create;
  col := TStringList.Create;
  col.StrictDelimiter := true;
  col.Delimiter := ',';

  TMSFNCResponsiveList1.BeginUpdate;

  try
    sl.LoadFromFile('.\carlist.txt');

    for i := 0 to sl.Count - 1 do
    begin
      col.CommaText := sl.Strings[i];
      TMSFNCResponsiveList1.Items.Add.Content := '<B>'+col[0]+'</B>'+'<BR><IMG SRC="file://.\'+col[2]+'"><BR><BR>'+col[1];
    end;

  finally
    TMSFNCResponsiveList1.EndUpdate;
    col.Free;
    sl.Free;
  end;


end;

end.
