unit URLDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TMSFNCScrollControl,
  FMX.TMSFNCResponsiveList, FMX.TMSFNCTypes, FMX.TMSFNCUtils,
  FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes;

type
  TForm4 = class(TForm)
    TMSFNCResponsiveList1: TTMSFNCResponsiveList;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.fmx}

procedure TForm4.FormCreate(Sender: TObject);
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
