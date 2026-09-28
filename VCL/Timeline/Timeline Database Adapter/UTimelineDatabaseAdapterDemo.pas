unit UTimelineDatabaseAdapterDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  VCL.Controls, VCL.Forms, VCL.Graphics, VCL.Dialogs,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes,
  VCL.TMSFNCCustomControl, VCL.TMSFNCCustomScrollControl, VCL.TMSFNCTimeline,
  VCL.StdCtrls, Data.DB, VCL.TMSFNCCustomComponent,
  VCL.TMSFNCTimelineDatabaseAdapter, Datasnap.DBClient;

type
  TForm1 = class(TForm)
    TMSFNCTimeline1: TTMSFNCTimeline;
    ConnectBtn: TButton;
    HistoryData: TClientDataSet;
    TMSFNCTimelineDatabaseAdapter1: TTMSFNCTimelineDatabaseAdapter;
    DataSource1: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure ConnectBtnClick(Sender: TObject);
    procedure TMSFNCTimelineDatabaseAdapter1FieldsToSection(Sender: TObject;
      AFields: TFields; ASection: TTMSFNCTimelineSection;
      var ADefaultSet: TTMSFNCTimelineDatabaseAdapterSectionFieldsParams);
    procedure TMSFNCTimelineDatabaseAdapter1SectionRead(Sender: TObject;
      ASection: TTMSFNCTimelineSection);
    procedure TMSFNCTimelineDatabaseAdapter1IndicatorRead(Sender: TObject;
      AIndicator: TTMSFNCTimelineIndicator);
    procedure TMSFNCTimeline1BeforeDrawIndicator(Sender: TObject;
      AGraphics: TTMSFNCGraphics; AIndicator: TTMSFNCTimelineIndicator;
      var ADrawingParams: TTMSFNCTimelineIndicatorDrawingParams; var AAllow,
      ADefaultDraw: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.ConnectBtnClick(Sender: TObject);
begin
  TMSFNCTimelineDatabaseAdapter1.Active := not TMSFNCTimelineDatabaseAdapter1.Active;

  if TMSFNCTimelineDatabaseAdapter1.Active then
    ConnectBtn.Caption := 'Disconnect'
  else
    ConnectBtn.Caption := 'Connect';
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  HistoryData.FieldDefs.Add('Id', ftString, 255);
  HistoryData.FieldDefs.Add('Start', ftInteger);
  HistoryData.FieldDefs.Add('End', ftInteger);
  HistoryData.FieldDefs.Add('Text', ftString, 255);
  HistoryData.FieldDefs.Add('Selectable', ftBoolean);
  HistoryData.FieldDefs.Add('Color', ftLongWord);
  HistoryData.CreateDataSet;

  TMSFNCTimeline1.Adapter := TMSFNCTimelineDatabaseAdapter1;
  TMSFNCTimelineDatabaseAdapter1.Item.AutoIncrementDBKey := False;
  TMSFNCTimelineDatabaseAdapter1.Item.DataSource := DataSource1;
  TMSFNCTimelineDatabaseAdapter1.Item.DBKey := 'Id';
  TMSFNCTimelineDatabaseAdapter1.Item.StartValue := 'Start';
  TMSFNCTimelineDatabaseAdapter1.Item.EndValue := 'End';
  TMSFNCTimelineDatabaseAdapter1.Item.Text := 'Text';

  HistoryData.Insert;
  HistoryData.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  HistoryData.FieldByName('Start').AsInteger := 410 ;
  HistoryData.FieldByName('End').AsInteger :=  1066;
  HistoryData.FieldByName('Text').AsString := 'Anglo-Saxons';
  HistoryData.FieldByName('Color').AsLongWord := gcGold;

  HistoryData.Insert;
  HistoryData.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  HistoryData.FieldByName('Start').AsInteger := 793 ;
  HistoryData.FieldByName('End').AsInteger :=  1066;
  HistoryData.FieldByName('Text').AsString := 'Vikings';
  HistoryData.FieldByName('Color').AsLongWord := gcCrimson;

  HistoryData.Insert;
  HistoryData.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  HistoryData.FieldByName('Start').AsInteger := 1485 ;
  HistoryData.FieldByName('End').AsInteger :=  1603;
  HistoryData.FieldByName('Text').AsString := 'The Tudors';
  HistoryData.FieldByName('Color').AsLongWord := gcMagenta;

  HistoryData.Insert;
  HistoryData.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  HistoryData.FieldByName('Start').AsInteger := 1789 ;
  HistoryData.FieldByName('End').AsInteger :=  1945;
  HistoryData.FieldByName('Text').AsString := 'Late Modern Period';
  HistoryData.FieldByName('Color').AsLongWord := gcAzure;

  HistoryData.Insert;
  HistoryData.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  HistoryData.FieldByName('Start').AsInteger := 1837 ;
  HistoryData.FieldByName('End').AsInteger :=  1901;
  HistoryData.FieldByName('Text').AsString := 'The Victorians';
  HistoryData.FieldByName('Color').AsLongWord := gcLightgreen;

  HistoryData.Insert;
  HistoryData.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  HistoryData.FieldByName('Start').AsInteger := 1492;
  HistoryData.FieldByName('End').AsInteger :=  1492;
  HistoryData.FieldByName('Text').AsString := 'Columbus discovers America';

  HistoryData.Insert;
  HistoryData.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  HistoryData.FieldByName('Start').AsInteger := 1969;
  HistoryData.FieldByName('End').AsInteger :=  1969;
  HistoryData.FieldByName('Text').AsString := 'First Man on Moon';

  HistoryData.Insert;
  HistoryData.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  HistoryData.FieldByName('Start').AsInteger := 1776;
  HistoryData.FieldByName('End').AsInteger :=  1776;
  HistoryData.FieldByName('Text').AsString := 'USA Independence Day';

  HistoryData.Insert;
  HistoryData.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  HistoryData.FieldByName('Start').AsInteger := 1302;
  HistoryData.FieldByName('End').AsInteger :=  1302;
  HistoryData.FieldByName('Text').AsString := 'Battle of the Golden Spurs';

  HistoryData.Post;

  TMSFNCTimelineDatabaseAdapter1.Active := True;
end;

procedure TForm1.TMSFNCTimeline1BeforeDrawIndicator(Sender: TObject;
  AGraphics: TTMSFNCGraphics; AIndicator: TTMSFNCTimelineIndicator;
  var ADrawingParams: TTMSFNCTimelineIndicatorDrawingParams; var AAllow,
  ADefaultDraw: Boolean);
var
  tlr, r: TRectF;

begin
  tlr := TMSFNCTimeline1.TimelineRect;
  r := RectF(ADrawingParams.CenterPosition.X - 2, tlr.Top, ADrawingParams.CenterPosition.X + 2, tlr.Bottom);

  AGraphics.DrawRectangle(r);
end;

procedure TForm1.TMSFNCTimelineDatabaseAdapter1FieldsToSection(Sender: TObject;
  AFields: TFields; ASection: TTMSFNCTimelineSection;
  var ADefaultSet: TTMSFNCTimelineDatabaseAdapterSectionFieldsParams);
var
  c: TTMSFNCGraphicsColor;
begin
  c := AFields.FieldByName('Color').AsLongWord;
  if c <> 0 then
    ASection.Appearance.Fill.Color := c
  else
    ASection.Appearance.Fill.Color := TMSFNCTimeline1.Appearance.DefaultSectionAppearance.Fill.Color;
end;

procedure TForm1.TMSFNCTimelineDatabaseAdapter1IndicatorRead(Sender: TObject;
  AIndicator: TTMSFNCTimelineIndicator);
begin
  AIndicator.Fixed := True;
end;

procedure TForm1.TMSFNCTimelineDatabaseAdapter1SectionRead(Sender: TObject;
  ASection: TTMSFNCTimelineSection);
begin
  ASection.Fixed := True;
  ASection.Selectable := False;
end;

end.
