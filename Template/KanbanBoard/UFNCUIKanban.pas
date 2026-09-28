unit UFNCUIKanban;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCCustomControl, FMX.TMSFNCCustomScrollControl, FMX.TMSFNCKanbanBoard,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCBitmapContainer;

type
  TForm3 = class(TForm)
    TMSFNCKanbanBoard1: TTMSFNCKanbanBoard;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    procedure TMSFNCKanbanBoard1BeforeDrawItem(Sender: TObject;
      AGraphics: TTMSFNCGraphics; ARect: TRectF;
      AColumn: TTMSFNCKanbanBoardColumn; AItem: TTMSFNCKanbanBoardItem;
      var AAllow, ADefaultDraw: Boolean);
    procedure TMSFNCKanbanBoard1ItemCustomDrawMark(Sender: TObject;
      AGraphics: TTMSFNCGraphics; ARect: TRectF;
      AMarkType: TTMSFNCKanbanBoardMarkType; AColumn: TTMSFNCKanbanBoardColumn;
      AItem: TTMSFNCKanbanBoardItem);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.fmx}

procedure TForm3.FormCreate(Sender: TObject);
begin
  TMSFNCKanbanBoard1.Columns[3].HeaderFill.Kind := gfkSolid;
end;

procedure TForm3.TMSFNCKanbanBoard1BeforeDrawItem(Sender: TObject;
  AGraphics: TTMSFNCGraphics; ARect: TRectF; AColumn: TTMSFNCKanbanBoardColumn;
  AItem: TTMSFNCKanbanBoardItem; var AAllow, ADefaultDraw: Boolean);
begin
  ADefaultDraw := False;

  if AColumn.Index = 3 then
    AGraphics.Stroke.Color := TTMSFNCGraphics.HTMLToColor('#b0eda8')
  else if AItem.IsSelected then       
  begin
    case AItem.Tag of
      1:
      begin
        AGraphics.Stroke.Color := TTMSFNCGraphics.HTMLToColor('#62ddf0');
      end;
      2:
      begin
        AGraphics.Stroke.Color := TTMSFNCGraphics.HTMLToColor('#5a81e6');
      end;
      3:
      begin
        AGraphics.Stroke.Color := TTMSFNCGraphics.HTMLToColor('#f0ca35');
      end;
      4:
      begin
        AGraphics.Stroke.Color := TTMSFNCGraphics.HTMLToColor('#f05b5b');
      end;
      else
      begin
        AGraphics.Stroke.Color := TTMSFNCGraphics.HTMLToColor('#b0eda8');
      end;
    end;
  end;

  AGraphics.DrawRoundRectangle(ARect, 3);
end;

procedure TForm3.TMSFNCKanbanBoard1ItemCustomDrawMark(Sender: TObject;
  AGraphics: TTMSFNCGraphics; ARect: TRectF;
  AMarkType: TTMSFNCKanbanBoardMarkType; AColumn: TTMSFNCKanbanBoardColumn;
  AItem: TTMSFNCKanbanBoardItem);
begin
  if AColumn.Index <> 3 then
  begin
    case AItem.Tag of
      1:
      begin
        AGraphics.Fill.Color := TTMSFNCGraphics.HTMLToColor('#62ddf0');
        AGraphics.Fill.ColorTo := TTMSFNCGraphics.HTMLToColor('#30abdb');
      end;
      2:
      begin
        AGraphics.Fill.Color := TTMSFNCGraphics.HTMLToColor('#5a81e6');
        AGraphics.Fill.ColorTo := TTMSFNCGraphics.HTMLToColor('#1f35de');
      end;
      3:
      begin
        AGraphics.Fill.Color := TTMSFNCGraphics.HTMLToColor('#f0ca35');
        AGraphics.Fill.ColorTo := TTMSFNCGraphics.HTMLToColor('#ed9005');
      end;
      4:
      begin
        AGraphics.Fill.Color := TTMSFNCGraphics.HTMLToColor('#f05b5b');
        AGraphics.Fill.ColorTo := TTMSFNCGraphics.HTMLToColor('#cc3423');
      end;
      else
      begin
        AGraphics.Fill.Color := TTMSFNCGraphics.HTMLToColor('#b0eda8');
        AGraphics.Fill.ColorTo := TTMSFNCGraphics.HTMLToColor('#80eb7f');
      end;
    end;

    AGraphics.Stroke.Kind := gskNone;

    AGraphics.Fill.Kind := gfkGradient;
    AGraphics.Fill.Orientation := gfoHorizontal;
    AGraphics.DrawRoundRectangle(ARect,3,[gcTopLeft, gcTopRight]);
  end;
end;

end.
