unit UTimelineCustomDrawing;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCCustomControl, FMX.TMSFNCCustomScrollControl, FMX.TMSFNCTimeline, Generics.Collections,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCBitmapContainer;

type
  TTimelineItem = record
    Date: string;
    Name: string;
    Text: string;
    Image: string;
    Color: TTMSFNCGraphicsColor;
  end;
  TTimelineItemList = class(TList<TTimelineItem>);


  TForm1 = class(TForm)
    TMSFNCTimeline1: TTMSFNCTimeline;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    procedure TMSFNCTimeline1UpdateIndicatorDisplay(Sender: TObject;
      AIndicator: TTMSFNCTimelineIndicator;
      var AIndicatorDrawingParams: TTMSFNCTimelineIndicatorDrawingParams;
      var AAdd: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure TMSFNCTimeline1BeforeDrawIndicatorAnnotation(Sender: TObject;
      AGraphics: TTMSFNCGraphics; AIndicator: TTMSFNCTimelineIndicator;
      var ADrawingParams: TTMSFNCTimelineAnnotationDrawingParams; var AAllow,
      ADefaultDraw: Boolean);
    procedure TMSFNCTimeline1AfterDrawIndicatorAnnotation(Sender: TObject;
      AGraphics: TTMSFNCGraphics; AIndicator: TTMSFNCTimelineIndicator;
      ADrawingParams: TTMSFNCTimelineAnnotationDrawingParams);
  private
    { Private declarations }
    TimelineItemsList: TTimelineItemList;
    procedure DoBeforeDrawLine(Sender:TObject; AGraphics: TTMSFNCGraphics; AIndicator: TTMSFNCTimelineIndicator; var ADrawingParams: TTMSFNCTimelineAnnotationLineDrawingParams; var AAllow: Boolean; var ADefaultDraw: Boolean);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.DoBeforeDrawLine(Sender: TObject; AGraphics: TTMSFNCGraphics;
  AIndicator: TTMSFNCTimelineIndicator;
  var ADrawingParams: TTMSFNCTimelineAnnotationLineDrawingParams; var AAllow,
  ADefaultDraw: Boolean);
begin
  AGraphics.Stroke.Color := TimelineItemsList[AIndicator.Index - 1].Color;
  AGraphics.Stroke.Width := 2;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
 it: TTimelineItem;
begin
  TMSFNCTimeline1.OnBeforeDrawIndicatorAnnotationLine := DoBeforeDrawLine;

  TimelineItemsList := TTimelineItemList.Create;

  it.Date := 'November';
  it.Name := 'Planning';
  it.Text := 'A platform for anyone who is looking to advance their career.';
  it.Image := 'puzzle.png';
  it.Color := $FF00DBBB;
  TimelineItemsList.Add(it);

  it.Date := 'May';
  it.Name := 'Early Birds';
  it.Text := 'A social networking site that makes it easy for you to connect and share with family and friends online.';
  it.Image := 'bird.png';
  it.Color := $FFF7BE48;
  TimelineItemsList.Add(it);

  it.Date := 'August';
  it.Name := 'Stop Registrations';
  it.Text := 'A free video sharing website that makes it easy to watch online videos.';
  it.Image := 'stop.png';
  it.Color := $FFFF5050;
  TimelineItemsList.Add(it);

  it.Date := 'September';
  it.Name := 'Training Days';
  it.Text := 'A free social networking site where users broadcast short posts.';
  it.Image := 'user.png';
  it.Color := $FF2682FF;
  TimelineItemsList.Add(it);

//  it.Date := 2007;
//  it.Name := 'Tumblr';
//  it.Text := 'A blogging platform that enables you to easily share the content you love with the world.';
//  TimelineItemsList.Add(it);
//
//  it.Date := 2010;
//  it.Name := 'Instagram';
//  it.Text := 'A photo and video sharing social networking service.';
//  TimelineItemsList.Add(it);
//
//  it.Date := 2010;
//  it.Name := 'Pinterest';
//  it.Text := 'A social Curation website for sharing and categorizing images found online.';
//  TimelineItemsList.Add(it);
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
    AGraphics.Stroke.Color := TimelineItemsList[AIndicator.Index - 1].Color;
    AGraphics.Stroke.Kind := gskSolid;
    AGraphics.Stroke.Width := 2;
    AGraphics.DrawEllipse(r);

    InflateRect(r, -14, -14);

    AGraphics.DrawBitmap(r, TMSFNCBitmapContainer1.FindBitmap(TimelineItemsList[AIndicator.Index - 1].Image));
  end;
end;

procedure TForm1.TMSFNCTimeline1BeforeDrawIndicatorAnnotation(Sender: TObject; AGraphics: TTMSFNCGraphics; AIndicator: TTMSFNCTimelineIndicator; var ADrawingParams: TTMSFNCTimelineAnnotationDrawingParams; var AAllow,  ADefaultDraw: Boolean);
var
  txt: string;
begin
  if (AIndicator.Index > 0) and (AIndicator.Index < 5) then
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

    txt := txt + '<FONT size="20" color="' + TTMSFNCGraphics.ColorToHTML(TimelineItemsList[AIndicator.Index - 1].Color) + '"><B>' + TimelineItemsList[AIndicator.Index - 1].Name + '</FONT><br>'
                          +'<FONT size="16" color="#294842">' + TimelineItemsList[AIndicator.Index - 1].Date + '</FONT></B><br>';
//                          +'<FONT size="14" color="#141213">' + TimelineItemsList[AIndicator.Index - 1].Text + '</FONT></P>';

    ADrawingParams.Text := txt;
  end;
end;

procedure TForm1.TMSFNCTimeline1UpdateIndicatorDisplay(Sender: TObject; AIndicator: TTMSFNCTimelineIndicator;  var AIndicatorDrawingParams: TTMSFNCTimelineIndicatorDrawingParams; var AAdd: Boolean);
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
