unit UTimelineCustomDrawingDemo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VCL.TMSFNCTypes, VCL.TMSFNCUtils,
  VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl, System.Types,
  VCL.TMSFNCCustomScrollControl, VCL.TMSFNCTimeline, VCL.TMSFNCCustomComponent,
  VCL.TMSFNCBitmapContainer, Generics.Collections;

type
  TTimelineItem = record
    Year: Integer;
    Name: string;
    Text: string;
  end;
  TTimelineItemList = class(TList<TTimelineItem>);

  TForm1 = class(TForm)
    TMSFNCTimeline1: TTMSFNCTimeline;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    procedure TMSFNCTimeline1BeforeDrawIndicatorAnnotation(Sender: TObject; AGraphics: TTMSFNCGraphics; AIndicator: TTMSFNCTimelineIndicator;
      var ADrawingParams: TTMSFNCTimelineAnnotationDrawingParams; var AAllow, ADefaultDraw: Boolean);
    procedure TMSFNCTimeline1AfterDrawIndicatorAnnotation(Sender: TObject; AGraphics: TTMSFNCGraphics; AIndicator: TTMSFNCTimelineIndicator; ADrawingParams: TTMSFNCTimelineAnnotationDrawingParams);
    procedure TMSFNCTimeline1UpdateIndicatorDisplay(Sender: TObject; AIndicator: TTMSFNCTimelineIndicator; var AIndicatorDrawingParams: TTMSFNCTimelineIndicatorDrawingParams; var AAdd: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    TimelineItemsList: TTimelineItemList;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
 it: TTimelineItem;
begin
  TimelineItemsList := TTimelineItemList.Create;

  it.Year := 2002;
  it.Name := 'LinkedIn';
  it.Text := 'A platform for anyone who is looking to advance their career.';
  TimelineItemsList.Add(it);

  it.Year := 2004;
  it.Name := 'Facebook';
  it.Text := 'A social networking site that makes it easy for you to connect and share with family and friends online.';
  TimelineItemsList.Add(it);

  it.Year := 2005;
  it.Name := 'Youtube';
  it.Text := 'A free video sharing website that makes it easy to watch online videos.';
  TimelineItemsList.Add(it);

  it.Year := 2006;
  it.Name := 'Twitter';
  it.Text := 'A free social networking site where users broadcast short posts.';
  TimelineItemsList.Add(it);

  it.Year := 2007;
  it.Name := 'Tumblr';
  it.Text := 'A blogging platform that enables you to easily share the content you love with the world.';
  TimelineItemsList.Add(it);

  it.Year := 2010;
  it.Name := 'Instagram';
  it.Text := 'A photo and video sharing social networking service.';
  TimelineItemsList.Add(it);

  it.Year := 2010;
  it.Name := 'Pinterest';
  it.Text := 'A social Curation website for sharing and categorizing images found online.';
  TimelineItemsList.Add(it);
end;

procedure TForm1.TMSFNCTimeline1AfterDrawIndicatorAnnotation(Sender: TObject; AGraphics: TTMSFNCGraphics; AIndicator: TTMSFNCTimelineIndicator; ADrawingParams: TTMSFNCTimelineAnnotationDrawingParams);
var
  r: TRectF;
  s: Integer;
begin
  if (AIndicator.Index > 0) and (AIndicator.Index < 8) then
  begin
    s := 68;
    if AIndicator.Index mod 2 = 1 then
      r := RectF(ADrawingParams.TextRect.Right + 10, ADrawingParams.Rect.Top, ADrawingParams.TextRect.Right + 10 + s, ADrawingParams.Rect.Top + s)
    else
      r := RectF(ADrawingParams.TextRect.Left - 10 - s, ADrawingParams.Rect.Top, ADrawingParams.TextRect.Left - 10, ADrawingParams.Rect.Top + s);

    AGraphics.Fill.Color := gcWhite;
    AGraphics.Fill.Kind := gfkSolid;
    AGraphics.Stroke.Color := $424829;
    AGraphics.Stroke.Kind := gskSolid;
    AGraphics.Stroke.Width := 2;
    AGraphics.DrawRectangle(r);

    InflateRect(r, -1, -1);

    AGraphics.DrawBitmap(r, TMSFNCBitmapContainer1.FindBitmap(LowerCase(TimelineItemsList[AIndicator.Index - 1].Name)+'.png'), true, true);
  end;
end;

procedure TForm1.TMSFNCTimeline1BeforeDrawIndicatorAnnotation(Sender: TObject; AGraphics: TTMSFNCGraphics; AIndicator: TTMSFNCTimelineIndicator; var ADrawingParams: TTMSFNCTimelineAnnotationDrawingParams; var AAllow, ADefaultDraw: Boolean);
var
  txt: string;
begin
  if (AIndicator.Index > 0) and (AIndicator.Index < 8) then
  begin
    AGraphics.Fill.Kind := gfkNone;
    AGraphics.Stroke.Kind := gskNone;
    AGraphics.Font.Color := gcWhite;
    if AIndicator.Index mod 2 = 1 then
    begin
      txt := '<P align="right">';
      ADrawingParams.Rect.Right := ADrawingParams.Rect.Right - 40;
      ADrawingParams.TextRect.Right := ADrawingParams.Rect.Right - 40;
    end
    else
    begin
      txt := '<P align="left">';
      ADrawingParams.Rect.Left := ADrawingParams.Rect.Left + 40;
      ADrawingParams.TextRect.Left := ADrawingParams.Rect.Left + 40;
    end;

    txt := txt + '<FONT size="' + TMSFNCTimeline1.ScalePaintValue(18).ToString + '" color="#FFF001"><B>' + TimelineItemsList[AIndicator.Index - 1].Year.ToString + '</FONT><br>'
                          +'<FONT size="' + TMSFNCTimeline1.ScalePaintValue(12).ToString + '" color="#294842">' + TimelineItemsList[AIndicator.Index - 1].Name + '</FONT></B><br>'
                          +'<FONT size="' + TMSFNCTimeline1.ScalePaintValue(14).ToString + '" color="#141213">' + TimelineItemsList[AIndicator.Index - 1].Text + '</FONT></P>';

    ADrawingParams.Text := txt;
  end;
end;

procedure TForm1.TMSFNCTimeline1UpdateIndicatorDisplay(Sender: TObject; AIndicator: TTMSFNCTimelineIndicator; var AIndicatorDrawingParams: TTMSFNCTimelineIndicatorDrawingParams; var AAdd: Boolean);
begin
  if (AIndicator.Index > 0) and (AIndicator.Index < 8) then
  begin
    if AIndicator.Index mod 2 = 1 then
    begin
      AIndicatorDrawingParams.AnnotationDrawingParams.Rect := RectF(TMSFNCTimeline1.WorkspaceRect.Left + 10, AIndicatorDrawingParams.AnnotationDrawingParams.Rect.Top - 20, TMSFNCTimeline1.TimelineRect.Left - 20, AIndicatorDrawingParams.AnnotationDrawingParams.Rect.Top - 20 + TMSFNCTimeline1.DivisionSpace * 1.5);
      AIndicatorDrawingParams.AnnotationLineDrawingParams.StartPoint.X := TMSFNCTimeline1.TimelineRect.Left;
      AIndicatorDrawingParams.AnnotationLineDrawingParams.EndPoint.X := AIndicatorDrawingParams.AnnotationDrawingParams.Rect.Right;
    end
    else
    begin
      AIndicatorDrawingParams.AnnotationDrawingParams.Rect := RectF(TMSFNCTimeline1.TimelineRect.Right + 20, AIndicatorDrawingParams.AnnotationDrawingParams.Rect.Top - 20, TMSFNCTimeline1.WorkspaceRect.Right - 10, AIndicatorDrawingParams.AnnotationDrawingParams.Rect.Top - 20 + TMSFNCTimeline1.DivisionSpace * 1.5);
      AIndicatorDrawingParams.AnnotationLineDrawingParams.StartPoint.X := TMSFNCTimeline1.TimelineRect.Right;
      AIndicatorDrawingParams.AnnotationLineDrawingParams.EndPoint.X := AIndicatorDrawingParams.AnnotationDrawingParams.Rect.Left;
    end;
    AIndicatorDrawingParams.AnnotationDrawingParams.TextRect := AIndicatorDrawingParams.AnnotationDrawingParams.Rect;
  end;
end;


end.
