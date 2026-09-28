unit UTimeTableDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCCustomControl, FMX.TMSFNCCustomScrollControl, FMX.TMSFNCTimeline,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCTimelineDatabaseAdapter, Data.DB,
  Datasnap.DBClient;

type
  TForm1 = class(TForm)
    TMSFNCTimeline1: TTMSFNCTimeline;
    TMSFNCTimelineDatabaseAdapter1: TTMSFNCTimelineDatabaseAdapter;
    DataSource1: TDataSource;
    ClientDataSet1: TClientDataSet;
    procedure TMSFNCTimeline1AfterDraw(Sender: TObject;
      AGraphics: TTMSFNCGraphics; ARect: TRectF);
    procedure TMSFNCTimeline1BeforeDrawSection(Sender: TObject;
      AGraphics: TTMSFNCGraphics; ASection: TTMSFNCTimelineSection;
      var ADrawingParams: TTMSFNCTimelineSectionDrawingParams; var AAllow,
      ADefaultDraw: Boolean);
    procedure TMSFNCTimeline1AfterDrawSection(Sender: TObject;
      AGraphics: TTMSFNCGraphics; ASection: TTMSFNCTimelineSection;
      ADrawingParams: TTMSFNCTimelineSectionDrawingParams);
    procedure FormCreate(Sender: TObject);
    procedure TMSFNCTimelineDatabaseAdapter1FieldsToSection(Sender: TObject;
      AFields: TFields; ASection: TTMSFNCTimelineSection;
      var ADefaultSet: TTMSFNCTimelineDatabaseAdapterSectionFieldsParams);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure FillClientDataSet;
  end;

var
  Form1: TForm1;

implementation

uses
  System.DateUtils;

{$R *.fmx}

procedure TForm1.FillClientDataSet;
begin
  TMSFNCTimeline1.Sections.Clear;

  ClientDataSet1.FieldDefs.Add('Id', ftString, 255);
  ClientDataSet1.FieldDefs.Add('Start', ftDateTime);
  ClientDataSet1.FieldDefs.Add('End', ftDateTime);
  ClientDataSet1.FieldDefs.Add('Title', ftString, 255);
  ClientDataSet1.FieldDefs.Add('Room', ftInteger);
  ClientDataSet1.FieldDefs.Add('Type', ftInteger);
  ClientDataSet1.CreateDataSet;

  TMSFNCTimeline1.Adapter := TMSFNCTimelineDatabaseAdapter1;
  TMSFNCTimelineDatabaseAdapter1.Item.AutoIncrementDBKey := False;
  TMSFNCTimelineDatabaseAdapter1.Item.DataSource := DataSource1;
  TMSFNCTimelineDatabaseAdapter1.Item.DBKey := 'Id';
  TMSFNCTimelineDatabaseAdapter1.Item.StartValue := 'Start';
  TMSFNCTimelineDatabaseAdapter1.Item.EndValue := 'End';
  TMSFNCTimelineDatabaseAdapter1.Item.Text := 'Title';

  ClientDataSet1.Insert;
  ClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  ClientDataSet1.FieldByName('Start').AsDateTime := EncodeDateTime(2024,9,26,9,0,0,0);
  ClientDataSet1.FieldByName('End').AsDateTime := EncodeDateTime(2024,9,26,10,0,0,0);
  ClientDataSet1.FieldByName('Title').AsString := 'Let''s install: Smart Setup';
  ClientDataSet1.FieldByName('Room').AsInteger := 1;
  ClientDataSet1.FieldByName('Type').AsInteger := 0;

  ClientDataSet1.Insert;
  ClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  ClientDataSet1.FieldByName('Start').AsDateTime := EncodeDateTime(2024,9,26,10,15,0,0);
  ClientDataSet1.FieldByName('End').AsDateTime := EncodeDateTime(2024,9,26,11,15,0,0);
  ClientDataSet1.FieldByName('Title').AsString := 'Flexcel as reporting engine';
  ClientDataSet1.FieldByName('Room').AsInteger := 1;
  ClientDataSet1.FieldByName('Type').AsInteger := -1;

  ClientDataSet1.Insert;
  ClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  ClientDataSet1.FieldByName('Start').AsDateTime := EncodeDateTime(2024,9,26,10,15,0,0);
  ClientDataSet1.FieldByName('End').AsDateTime := EncodeDateTime(2024,9,26,11,15,0,0);
  ClientDataSet1.FieldByName('Title').AsString := 'Using TMS XData, TMS Sphinx and more';
  ClientDataSet1.FieldByName('Room').AsInteger := 2;
  ClientDataSet1.FieldByName('Type').AsInteger := -1;

  ClientDataSet1.Insert;
  ClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  ClientDataSet1.FieldByName('Start').AsDateTime := EncodeDateTime(2024,9,26,11,45,0,0);
  ClientDataSet1.FieldByName('End').AsDateTime := EncodeDateTime(2024,9,26,12,45,0,0);
  ClientDataSet1.FieldByName('Title').AsString := 'Project Management via Delphi';
  ClientDataSet1.FieldByName('Room').AsInteger := 1;
  ClientDataSet1.FieldByName('Type').AsInteger := -1;

  ClientDataSet1.Insert;
  ClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  ClientDataSet1.FieldByName('Start').AsDateTime := EncodeDateTime(2024,9,26,11,45,0,0);
  ClientDataSet1.FieldByName('End').AsDateTime := EncodeDateTime(2024,9,26,12,45,0,0);
  ClientDataSet1.FieldByName('Title').AsString := 'The Latest TMS BIZ developments';
  ClientDataSet1.FieldByName('Room').AsInteger := 2;
  ClientDataSet1.FieldByName('Type').AsInteger := -1;

  ClientDataSet1.Insert;
  ClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  ClientDataSet1.FieldByName('Start').AsDateTime := EncodeDateTime(2024,9,26,14,0,0,0);
  ClientDataSet1.FieldByName('End').AsDateTime := EncodeDateTime(2024,9,26,15,0,0,0);
  ClientDataSet1.FieldByName('Title').AsString := 'StellarDS.io API';
  ClientDataSet1.FieldByName('Room').AsInteger := 1;
  ClientDataSet1.FieldByName('Type').AsInteger := -1;

  ClientDataSet1.Insert;
  ClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  ClientDataSet1.FieldByName('Start').AsDateTime := EncodeDateTime(2024,9,26,14,0,0,0);
  ClientDataSet1.FieldByName('End').AsDateTime := EncodeDateTime(2024,9,26,15,0,0,0);
  ClientDataSet1.FieldByName('Title').AsString := 'TMS WEB Core integrations in Delphi';
  ClientDataSet1.FieldByName('Room').AsInteger := 2;
  ClientDataSet1.FieldByName('Type').AsInteger := -1;

  ClientDataSet1.Insert;
  ClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  ClientDataSet1.FieldByName('Start').AsDateTime := EncodeDateTime(2024,9,26,15,15,0,0);
  ClientDataSet1.FieldByName('End').AsDateTime := EncodeDateTime(2024,9,26,16,15,0,0);
  ClientDataSet1.FieldByName('Title').AsString := 'Consuming StellarDS.io from Delphi apps';
  ClientDataSet1.FieldByName('Room').AsInteger := 1;
  ClientDataSet1.FieldByName('Type').AsInteger := -1;

  ClientDataSet1.Insert;
  ClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  ClientDataSet1.FieldByName('Start').AsDateTime := EncodeDateTime(2024,9,26,15,15,0,0);
  ClientDataSet1.FieldByName('End').AsDateTime := EncodeDateTime(2024,9,26,16,15,0,0);
  ClientDataSet1.FieldByName('Title').AsString := 'Signing PDF';
  ClientDataSet1.FieldByName('Room').AsInteger := 2;
  ClientDataSet1.FieldByName('Type').AsInteger := -1;

  ClientDataSet1.Insert;
  ClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  ClientDataSet1.FieldByName('Start').AsDateTime := EncodeDateTime(2024,9,26,16,30,0,0);
  ClientDataSet1.FieldByName('End').AsDateTime := EncodeDateTime(2024,9,26,17,30,0,0);
  ClientDataSet1.FieldByName('Title').AsString := 'Roundtable: TMS Focus & Directions';
  ClientDataSet1.FieldByName('Room').AsInteger := 1;
  ClientDataSet1.FieldByName('Type').AsInteger := 0;

  ClientDataSet1.Insert;
  ClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  ClientDataSet1.FieldByName('Start').AsDateTime := EncodeDateTime(2024,9,26,18,30,0,0);
  ClientDataSet1.FieldByName('End').AsDateTime := EncodeDateTime(2024,9,26,20,0,0,0);
  ClientDataSet1.FieldByName('Title').AsString := 'Community Event';
  ClientDataSet1.FieldByName('Room').AsInteger := 1;
  ClientDataSet1.FieldByName('Type').AsInteger := 1;


  ClientDataSet1.Post;

  TMSFNCTimelineDatabaseAdapter1.Item.DataSource := DataSource1;
  TMSFNCTimelineDatabaseAdapter1.Item.DBKey := 'Id';
  TMSFNCTimelineDatabaseAdapter1.Item.StartDate := 'Start';
  TMSFNCTimelineDatabaseAdapter1.Item.EndDate := 'End';
  TMSFNCTimelineDatabaseAdapter1.Item.Text := 'Title';

  TMSFNCTimelineDatabaseAdapter1.Active := True;

  TMSFNCTimeline1.Range.MinimumDate := EncodeDateTime(2024,9,26,8,30,0,0);
  TMSFNCTimeline1.Range.MaximumDate := EncodeDateTime(2024,9,26,20,0,0,0);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FillClientDataSet;
end;

procedure TForm1.TMSFNCTimeline1AfterDraw(Sender: TObject; AGraphics: TTMSFNCGraphics; ARect: TRectF);
var
  r, tlr: TRectF;
begin
  tlr := TMSFNCTimeline1.TimelineRect;

  AGraphics.Font.Size := 20;
  AGraphics.Font.Style := [TFontStyle.fsBold];

  AGraphics.Font.Color := $7052BCF9;
  r := RectF(4, tlr.Top + 8, tlr.Left - 4, tlr.Top + ((tlr.Bottom - tlr.Top) / 2) - 8);
  AGraphics.DrawText(r,'ROOM 1', false, gtaCenter, gtaCenter, gttNone,-90);

  AGraphics.Font.Color := $70FF006E;
  r := RectF(4, tlr.Top + ((tlr.Bottom - tlr.Top) / 2) - 8, tlr.Left - 4, tlr.Bottom - 8);
  AGraphics.DrawText(r,'ROOM 2', false, gtaCenter, gtaCenter, gttNone,-90);


  AGraphics.Font.Size := 26;
  AGraphics.Font.Color := gcWhite;
  r := RectF(0, 8, TMSFNCTimeline1.Width, tlr.Top - 8);
  AGraphics.DrawText(r,'TMS Day 1', false, gtaCenter, gtaCenter);
end;

procedure TForm1.TMSFNCTimeline1AfterDrawSection(Sender: TObject; AGraphics: TTMSFNCGraphics; ASection: TTMSFNCTimelineSection; ADrawingParams: TTMSFNCTimelineSectionDrawingParams);
var
  r: TRectF;
  rc : TTMSFNCGraphicsCorners;
begin
  if (ASection.Index < 11) then
  begin
    if not ASection.Selected then
    begin
      if ASection.DataInteger = 1 then
        AGraphics.Fill.Color := $AAF9DF6B
      else if ASection.Row = 0 then
        AGraphics.Fill.Color := $7052BCF9
      else
        AGraphics.Fill.Color := $70FF006E;

      r := ADrawingParams.DrawRect;
      r.Right := r.Left + 8;

      rc := ADrawingParams.RoundedCorners - [gcTopRight, gcBottomRight];

      AGraphics.DrawRoundRectangle(r, ADrawingParams.Rounding, rc);
    end;


    r := ADrawingParams.TextRect;

    AGraphics.Font.Style := [];

    AGraphics.DrawText(r, TMSFNCTimeline1.GetValueText(ASection.StartTimelineValue) + ' - ' + TMSFNCTimeline1.GetValueText(ASection.EndTimelineValue), True,gtaLeading, gtaLeading, gttNone);
  end;

end;

procedure TForm1.TMSFNCTimeline1BeforeDrawSection(Sender: TObject; AGraphics: TTMSFNCGraphics; ASection: TTMSFNCTimelineSection;
  var ADrawingParams: TTMSFNCTimelineSectionDrawingParams; var AAllow, ADefaultDraw: Boolean);
var
  tlr: TRectF;
begin

  InflateRectEx(ADrawingParams.DrawRect, -2, -2);
  InflateRectEx(ADrawingParams.TextRect, -2, -2);

  ADrawingParams.TextRect.Left := ADrawingParams.TextRect.Left + 8;
  ADrawingParams.WordWrap := True;

  if ADrawingParams.Selected then
  begin
    if ASection.DataInteger = 1 then
    begin
      AGraphics.Fill.Color := $FFF9DF6B;
      AGraphics.Fill.Color := $AAF9DF6B
    end
    else if ASection.Row = 0 then
    begin
      AGraphics.Fill.Color := $FF52BCF9;
      AGraphics.Stroke.Color := $7052BCF9
    end
    else
    begin
      AGraphics.Fill.Color := $FFFF006E;
      AGraphics.Stroke.Color := $70FF006E;
    end;
  end;
end;

procedure TForm1.TMSFNCTimelineDatabaseAdapter1FieldsToSection(Sender: TObject; AFields: TFields; ASection: TTMSFNCTimelineSection;
  var ADefaultSet: TTMSFNCTimelineDatabaseAdapterSectionFieldsParams);
begin
  ASection.Fixed := True;
  ASection.Row := AFields.FieldByName('Room').AsInteger - 1;
  ASection.DataInteger := AFields.FieldByName('Type').AsInteger;
end;

end.
