unit UFNCUIPlanner;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCCustomControl, FMX.TMSFNCPlannerBase, FMX.TMSFNCPlannerData,
  FMX.TMSFNCPlanner, FMX.TMSFNCCustomComponent, FMX.TMSFNCBitmapContainer;

type
  TForm1 = class(TForm)
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    TMSFNCPlanner1: TTMSFNCPlanner;
    procedure FormCreate(Sender: TObject);
    procedure TMSFNCPlanner1BeforeDrawItem(Sender: TObject;
      AGraphics: TTMSFNCGraphics; ARect: TRectF; AItem: TTMSFNCPlannerItem;
      var AAllow, ADefaultDraw: Boolean);
    procedure TMSFNCPlanner1BeforeDrawItemTitleText(Sender: TObject;
      AGraphics: TTMSFNCGraphics; ARect: TRectF; AItem: TTMSFNCPlannerItem;
      ATitle: string; var AAllow: Boolean);
    procedure TMSFNCPlanner1BeforeDrawItemText(Sender: TObject;
      AGraphics: TTMSFNCGraphics; ARect: TRectF; AItem: TTMSFNCPlannerItem;
      AText: string; var AAllow: Boolean);
    procedure TMSFNCPlanner1BeforeDrawPositionText(Sender: TObject;
      AGraphics: TTMSFNCGraphics; ARect: TRectF; APosition: Integer;
      AKind: TTMSFNCPlannerCacheItemKind; AText: string; var AAllow: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.FormCreate(Sender: TObject);
begin
  TMSFNCPlanner1.GridCellAppearance.Fill.Kind := gfkSolid;
end;

procedure TForm1.TMSFNCPlanner1BeforeDrawItem(Sender: TObject;
  AGraphics: TTMSFNCGraphics; ARect: TRectF; AItem: TTMSFNCPlannerItem;
  var AAllow, ADefaultDraw: Boolean);
var
  r: TRectF;
  c,c2: TTMSFNCGraphicsColor;
  I: Integer;
  selected: boolean;
begin
  ADefaultDraw := False;

  r := ARect;
  r.Left := r.Left + 2;
  r.Top := r.Top + 2;

  c := AGraphics.Fill.Color;
  c2 := AGraphics.Fill.Color;

  TAlphaColorRec(c).A := 100;

  selected := False;
  for I := 0 to TMSFNCPlanner1.SelectedItems.Count - 1 do
  begin
    if TMSFNCPlanner1.SelectedItems[I].Index = AItem.Index then
    begin
      selected := True;
      Break;
    end;
  end;

  if selected then
    AGraphics.Fill.Color := $FF5980E6
  else
    AGraphics.Fill.Color := c;

  AGraphics.Stroke.Kind := gskNone;

  AGraphics.DrawRoundRectangle(r, 4);

  AGraphics.Fill.Color := c2;
  r.Right := r.Left + 6;

  AGraphics.DrawRoundRectangle(r, 4, [gcTopLeft, gcBottomLeft]);
end;

procedure TForm1.TMSFNCPlanner1BeforeDrawItemText(Sender: TObject;
  AGraphics: TTMSFNCGraphics; ARect: TRectF; AItem: TTMSFNCPlannerItem;
  AText: string; var AAllow: Boolean);
var
  r: TRectF;
begin
  AAllow := False;

  r := ARect;
  r.Left := r.Left + 10;

  AGraphics.Font.Color := $FFFAFAFA;
  AGraphics.DrawText(r, AText, True, AItem.TextHorizontalTextAlign, gtaCenter);
end;

procedure TForm1.TMSFNCPlanner1BeforeDrawItemTitleText(Sender: TObject;
  AGraphics: TTMSFNCGraphics; ARect: TRectF; AItem: TTMSFNCPlannerItem;
  ATitle: string; var AAllow: Boolean);
var
  r: TRectF;
begin
  AAllow := False;

  r := ARect;
  r.Left := r.Left + 10;

  AGraphics.Font.Color := AItem.Color;
  AGraphics.DrawText(r, ATitle, False, gtaLeading, gtaTrailing);
end;

procedure TForm1.TMSFNCPlanner1BeforeDrawPositionText(Sender: TObject;
  AGraphics: TTMSFNCGraphics; ARect: TRectF; APosition: Integer;
  AKind: TTMSFNCPlannerCacheItemKind; AText: string; var AAllow: Boolean);
begin
  AAllow := False;
  AGraphics.DrawText(ARect, 'Mon 02/03', False, gtaCenter, gtaCenter, gttNone, -90);
end;

end.
