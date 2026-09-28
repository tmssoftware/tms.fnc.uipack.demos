unit UFNCUITreeView;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCBitmapContainer, FMX.TMSFNCCustomControl,
  FMX.TMSFNCTreeViewBase, FMX.TMSFNCTreeViewData, FMX.TMSFNCCustomTreeView,
  FMX.TMSFNCTreeView;

type
  TForm1 = class(TForm)
    TMSFNCTreeView1: TTMSFNCTreeView;
    TMSFNCBitmapContainer2: TTMSFNCBitmapContainer;
    procedure FormCreate(Sender: TObject);
    procedure TMSFNCTreeView1BeforeDrawNode(Sender: TObject;
      AGraphics: TTMSFNCGraphics; ARect: TRectF;
      ANode: TTMSFNCTreeViewVirtualNode; var AAllow, ADefaultDraw: Boolean);
    procedure TMSFNCTreeView1GetNodeIcon(Sender: TObject;
      ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer; ALarge: Boolean;
      var AIcon: TTMSFNCBitmap);
    procedure TMSFNCTreeView1GetNodeIconSize(Sender: TObject;
      ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer; ALarge: Boolean;
      AIcon: TTMSFNCBitmap; var AIconWidth, AIconHeight: Double);
    procedure TMSFNCTreeView1GetNodeSelectedTextColor(Sender: TObject;
      ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer;
      var ATextColor: TAlphaColor);
    procedure TMSFNCTreeView1BeforeDrawNodeText(Sender: TObject;
      AGraphics: TTMSFNCGraphics; ARect: TRectF; AColumn: Integer;
      ANode: TTMSFNCTreeViewVirtualNode; AText: string; var AAllow: Boolean);
    procedure TMSFNCTreeView1BeforeDrawNodeExpand(Sender: TObject;
      AGraphics: TTMSFNCGraphics; ARect: TRectF; AColumn: Integer;
      ANode: TTMSFNCTreeViewVirtualNode; AExpand: TTMSFNCBitmap;
      var AAllow: Boolean);
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
var
  I: Integer;
begin
  for I := 0 to TMSFNCTreeView1.Columns.Count - 1 do
  begin
    TMSFNCTreeView1.Columns[I].TopFill.Color := $FFEEF2F9;
    TMSFNCTreeView1.Columns[I].TopFill.Kind := gfkSolid;
  end;
end;

procedure TForm1.TMSFNCTreeView1BeforeDrawNode(Sender: TObject;
  AGraphics: TTMSFNCGraphics; ARect: TRectF; ANode: TTMSFNCTreeViewVirtualNode;
  var AAllow, ADefaultDraw: Boolean);
var
  r: TRectF;
begin
  if TMSFNCTreeView1.IsVirtualNodeSelected(ANode) then
  begin
    ADefaultDraw := False;
    r := ARect;
    r.Left := 1;

    AGraphics.Stroke.Color := $FF2D9BEF;
    AGraphics.Stroke.Kind := gskSolid;
    AGraphics.Fill.Color := $FFF6F8FC;
    AGraphics.Fill.Kind := gfkSolid;
    AGraphics.DrawRoundRectangle(r, 2, [gcTopRight, gcBottomRight]);

    r.Right := r.Left + 3;

    AGraphics.Stroke.Kind := gskNone;
    AGraphics.Fill.Kind := gfkSolid;
    AGraphics.Fill.Color := $FF2D9BEF;
    AGraphics.DrawRoundRectangle(r, 2, [gcTopLeft,gcBottomLeft]);
  end;
end;

procedure TForm1.TMSFNCTreeView1BeforeDrawNodeExpand(Sender: TObject;  AGraphics: TTMSFNCGraphics; ARect: TRectF; AColumn: Integer;
  ANode: TTMSFNCTreeViewVirtualNode; AExpand: TTMSFNCBitmap; var AAllow: Boolean);
var
  p: Boolean;
  n: TTMSFNCTreeViewVirtualNode;
  r: TRectF;
begin
  p := False;
  n := TMSFNCTreeView1.SelectedVirtualNode;
  if Assigned(n) then
  begin
    if ANode = n then
    begin
      p := True;
    end;

    if not p then
    begin
      while n.GetParent <> nil do
      begin
        if n.GetParent = ANode then
        begin
          p := True;
          Break;
        end;

        n := n.GetParent;
      end;
    end;
  end;

  AAllow := False;
  r := ARect;
  InflateRectEx(r, -2, -2);

  if p then
  begin
    if ANode.Expanded then
      AGraphics.DrawBitmap(r, TMSFNCBitmapContainer2.FindBitmap('down_arrow_circle_blue.svg'))
    else
      AGraphics.DrawBitmap(r, TMSFNCBitmapContainer2.FindBitmap('right_arrow_circle_blue.svg'))
  end
  else
  begin
    if ANode.Expanded then
      AGraphics.DrawBitmap(r, TMSFNCBitmapContainer2.FindBitmap('down_arrow_circle.svg'))
    else
      AGraphics.DrawBitmap(r, TMSFNCBitmapContainer2.FindBitmap('right_arrow_circle.svg'))
  end;
end;

procedure TForm1.TMSFNCTreeView1BeforeDrawNodeText(Sender: TObject; AGraphics: TTMSFNCGraphics; ARect: TRectF; AColumn: Integer; ANode: TTMSFNCTreeViewVirtualNode; AText: string; var AAllow: Boolean);
var
  v: Integer;
  s: Single;
  r: TRectF;
  c, cl: TTMSFNCGraphicsColor;
begin
  if AColumn = 1 then
  begin
    AAllow := False;

    if AText <> '' then
      v := StrToInt(AText)
    else
      v := 0;

    if (v > 0) and not ((UpperCase(ANode.Node.Values[2].Text) = 'FOLDER') and ANode.Expanded) then
    begin

      if UpperCase(ANode.Node.Values[2].Text) = 'SD-CARD' then
      begin
        c := $FFFBD18D;
        cl := $FFFEF3DD;
      end
      else
      begin
        c := $FF8DB7FB;
        cl := $FFDDE8FE;
      end;

      r := ARect;
      InflateRectEx(r, -6, -6);

      AGraphics.Fill.Color := cl;

      AGraphics.DrawRoundRectangle(r, 3);

      s := r.Width * (v / 8000);

      if s < 5 then
        s := 5;

      r.Right := r.Left + s;

      AGraphics.Stroke.Kind := gskNone;
      AGraphics.Fill.Color := c;
      AGraphics.DrawRoundRectangle(r, 3);
    end;
  end;
end;

procedure TForm1.TMSFNCTreeView1GetNodeIcon(Sender: TObject;
  ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer; ALarge: Boolean;
  var AIcon: TTMSFNCBitmap);
begin
  if AColumn = 0 then
  begin
    if UpperCase(ANode.Node.Values[2].Text) = 'SD-CARD' then
      AIcon := TMSFNCBitmapContainer2.FindBitmap('Card.svg')
    else if UpperCase(ANode.Node.Values[2].Text) = 'FOLDER' then
      AIcon := TMSFNCBitmapContainer2.FindBitmap('Folder.svg')
    else
      AIcon := TMSFNCBitmapContainer2.FindBitmap('New.svg');
  end;

  if AColumn = 3 then
  begin
    if ANode.Node.Tag > 0 then
      AIcon := TMSFNCBitmapContainer2.FindBitmap('Lock.svg');
  end;
end;

procedure TForm1.TMSFNCTreeView1GetNodeIconSize(Sender: TObject;
  ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer; ALarge: Boolean;
  AIcon: TTMSFNCBitmap; var AIconWidth, AIconHeight: Double);
begin
  if AColumn = 0 then
  begin
    AIconWidth := 16;
    AIconHeight := 16;
  end;

  if AColumn = 3 then
  begin
    AIconWidth := 20;
    AIconHeight := 20;
  end;
end;

procedure TForm1.TMSFNCTreeView1GetNodeSelectedTextColor(Sender: TObject;
  ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer;
  var ATextColor: TAlphaColor);
begin
  if AColumn = 2 then
  begin
    ATextColor := $FF7A7A7A;
  end;
end;

end.
