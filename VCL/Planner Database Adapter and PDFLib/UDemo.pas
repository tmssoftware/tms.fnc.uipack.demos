unit UDemo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VCL.TMSFNCUtils,
  VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, Data.DB, Datasnap.DBClient,
  VCL.TMSFNCBitmapContainer, VCL.TMSFNCPlanner,
  VCL.TMSFNCPlannerItemEditorRecurrency, VCL.TMSFNCCustomComponent,
  VCL.TMSFNCPlannerDatabaseAdapter, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPlannerBase, VCL.TMSFNCPlannerData, Vcl.StdCtrls, Vcl.ExtCtrls,
  VCL.TMSFNCPDFLib, VCL.TMSFNCPDFIO, VCL.TMSFNCGraphicsPDFEngine, VCL.TMSFNCTypes;

type
  TForm3 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Button1: TButton;
    Label2: TLabel;
    TMSFNCPlanner1: TTMSFNCPlanner;
    TMSFNCPlannerDatabaseAdapter1: TTMSFNCPlannerDatabaseAdapter;
    TMSFNCPlannerItemEditorRecurrency1: TTMSFNCPlannerItemEditorRecurrency;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    TMSFNCPDFLib1: TTMSFNCPDFLib;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure TMSFNCPlanner1AfterNavigateToDateTime(Sender: TObject;
      ADirection: TTMSFNCPlannerNavigationDirection; ACurrentDateTime,
      ANewDateTime: TDateTime);
    procedure TMSFNCPlanner1IsDateTimeSub(Sender: TObject; ADateTime: TDateTime;
      var AIsSub: Boolean);
    procedure TMSFNCPlannerDatabaseAdapter1FieldsToItem(Sender: TObject;
      AFields: TFields; AItem: TTMSFNCPlannerItem);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses
  DateUtils;

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
begin
  ClientDataSet1.Active := not ClientDataSet1.Active;
  if ClientDataSet1.Active then
    Button1.Caption := 'Disconnect'
  else
    Button1.Caption := 'Connect';
end;

procedure TForm3.Button2Click(Sender: TObject);
var
  txt: string;
  s: TStringList;
  r: TRectF;
  offsetx,ry: single;
  I: Integer;
  j: Integer;
  dts,dte: string;
  fdraw: Boolean;
begin
  offsetx := 30;

  s := TStringList.Create;
  TMSFNCPDFLib1.BitmapContainer := TMSFNCBitmapContainer1;

  for I := 0 to TMSFNCPlanner1.Resources.Count - 1 do
  begin
    s.AddObject(TMSFNCPlanner1.Resources[I].Text, TMSFNCPlanner1.Resources[I]);
  end;

  TMSFNCPDFLib1.BeginDocument('TestPDFPlannerDemo.pdf');
  try
    for I := 0 to s.Count - 1 do
    begin
      fdraw := True;
      for J := 0 to TMSFNCPlanner1.Items.Count - 1 do
      begin
        if (TMSFNCPlanner1.Items[J].Resource = (s.Objects[I] as TTMSFNCPlannerResource).Index) then
        begin
          if fdraw then
          begin
            TMSFNCPDFLib1.Header := '';
            TMSFNCPDFLib1.Footer := '';
            TMSFNCPDFLib1.NewPage;
            r := RectF(offsetx * 2, offsetx , TMSFNCPDFLib1.PageWidth - 2 * offsetx , TMSFNCPDFLib1.PageHeight - offsetx);
            TMSFNCPDFLib1.Graphics.Font.Name := 'Arial';
            TMSFNCPDFLib1.Graphics.Font.Size := 24;
            TMSFNCPDFLib1.Graphics.DrawHTMLText(s.Strings[I], r);
            r:= TMSFNCPDFLib1.Graphics.DrawHTMLText(s.Strings[I], r, True, 1, True);
            ry := r.Bottom + 20;
            r := RectF(offsetx, ry, TMSFNCPDFLib1.PageWidth -  offsetx , TMSFNCPDFLib1.PageHeight - offsetx);
            TMSFNCPDFLib1.Graphics.Font.Size := 14;
          end;
          fdraw := false;
          DateTimeToString(dts, 'dd/mm hh:nn', TMSFNCPlanner1.Items[J].StartTime);
          if CompareDate(TMSFNCPlanner1.Items[J].StartTime, TMSFNCPlanner1.Items[J].EndTime) = 0 then
            DateTimeToString(dte, 'hh:nn', TMSFNCPlanner1.Items[J].EndTime)
          else
            DateTimeToString(dte, 'dd/mm hh:nn', TMSFNCPlanner1.Items[J].EndTime);
          txt := dts + ' - ' +  dte + ' | <b><font color="' + TTMSFNCGraphics.ColorToHTML(TMSFNCPlanner1.Items[J].Color) + '">' +TMSFNCPlanner1.Items[J].Title +':</font</b> '+TMSFNCPlanner1.Items[J].Text;
          TMSFNCPDFLib1.Graphics.DrawHTMLText(txt, r);

          r:= TMSFNCPDFLib1.Graphics.DrawHTMLText(txt, r, True, 1, True);
          ry := r.Bottom + 20;
          r := RectF(offsetx, ry, TMSFNCPDFLib1.PageWidth -  offsetx , TMSFNCPDFLib1.PageHeight - offsetx);
        end;
      end;
    end;

  finally
    s.Free;
    TMSFNCPDFLib1.EndDocument(True);
  end;
end;

procedure TForm3.FormCreate(Sender: TObject);
var
  I: Integer;
  res: TTMSFNCPlannerResource;
  it: TTMSFNCBitmapItem;

  procedure AddResource(AName: string);
  begin
    it := TMSFNCBitmapContainer1.Items.Add;
    it.Bitmap.LoadFromResource(AName);
    it.Name := StringReplace(AName, '_', ' ', [rfReplaceAll]);
  end;
begin
  AddResource('Audrea_Joey');
  AddResource('Brittani_Robin');
  AddResource('Daniel_Harris');
  AddResource('Elias_Lester');
  AddResource('Jayden_Arvel');
  AddResource('Kelia_Blondie');
  AddResource('Nate_Chance');
  AddResource('Pamella_Lynn');

  TMSFNCPlanner1.BeginUpdate;
  TMSFNCPlanner1.BitmapContainer := TMSFNCBitmapContainer1;
  TMSFNCPlanner1.Interaction.UpdateMode := pumDialog;
  TMSFNCPlanner1.Interaction.TopNavigationButtons := [pnbPrevious, pnbNext];
  TMSFNCPlanner1.Interaction.MouseInsertMode := pmimAfterSelection;
  TMSFNCPlanner1.Interaction.KeyboardInsertMode := pkimSelection;
  TMSFNCPlanner1.DefaultItem.FontColor := gcWhite;
  TMSFNCPlanner1.DefaultItem.TitleFontColor := gcWhite;
  TMSFNCPlanner1.ModeSettings.StartTime := Now;
  TMSFNCPlanner1.Mode := pmDay;
  TMSFNCPlanner1.TimeLine.DisplayUnit := 240;
  TMSFNCPlanner1.TimeLine.DisplayUnitFormat := 'dddd dd/mm';
  TMSFNCPlanner1.TimeLine.DisplaySubUnitFormat := 'hh:nn';
  TMSFNCPlanner1.TimeLine.DisplayEnd := Round((MinsPerDay * 7) / TMSFNCPlanner1.TimeLine.DisplayUnit) - 1;
  TMSFNCPlanner1.TimeLineAppearance.LeftSize := TMSFNCPlanner1.ScalePaintValue(200);
  TMSFNCPlanner1.PositionsAppearance.TopSize := TMSFNCPlanner1.ScalePaintValue(120);
  TMSFNCPlanner1.Resources.Clear;
  TMSFNCPlanner1.PositionsAppearance.TopFont.Size := 14;
  for I := 0 to TMSFNCBitmapContainer1.Items.Count - 1 do
  begin
    res := TMSFNCPlanner1.Resources.Add;
    res.Name := TMSFNCBitmapContainer1.Items[I].Name;
    res.Text := '<img width="80" src="'+res.Name+'"></img><br><p align="center">'+res.Name+'</p>';
  end;

  TMSFNCPlanner1.Positions.Count := TMSFNCPlanner1.Resources.Count;
  TMSFNCPlanner1.EndUpdate;

  ClientDataSet1.FieldDefs.Add('Id', ftString, 255);
  ClientDataSet1.FieldDefs.Add('Resource', ftString, 10);
  ClientDataSet1.FieldDefs.Add('Title', ftString, 10);
  ClientDataSet1.FieldDefs.Add('Text', ftString, 255);
  ClientDataSet1.FieldDefs.Add('StartTime', ftDateTime);
  ClientDataSet1.FieldDefs.Add('EndTime', ftDateTime);
  ClientDataSet1.FieldDefs.Add('Recurrency', ftString, 255);
  ClientDataSet1.FieldDefs.Add('Color', ftLongWord);
  ClientDataSet1.CreateDataSet;

  TMSFNCPlanner1.Adapter := TMSFNCPlannerDatabaseAdapter1;
  TMSFNCPlanner1.ItemEditor := TMSFNCPlannerItemEditorRecurrency1;
  TMSFNCPlannerDatabaseAdapter1.Item.AutoIncrementDBKey := False;
  TMSFNCPlannerDatabaseAdapter1.Item.DataSource := DataSource1;
  TMSFNCPlannerDatabaseAdapter1.Item.DBKey := 'Id';
  TMSFNCPlannerDatabaseAdapter1.Item.StartTime := 'StartTime';
  TMSFNCPlannerDatabaseAdapter1.Item.EndTime := 'EndTime';
  TMSFNCPlannerDatabaseAdapter1.Item.Title := 'Title';
  TMSFNCPlannerDatabaseAdapter1.Item.Text := 'Text';
  TMSFNCPlannerDatabaseAdapter1.Item.Resource := 'Resource';
  TMSFNCPlannerDatabaseAdapter1.Item.Recurrency := 'Recurrency';

ClientDataSet1.Insert;
  ClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  ClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + EncodeTime(12, 0, 0, 0);
  ClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + EncodeTime(20, 0, 0, 0);
  ClientDataSet1.FieldByName('Resource').AsInteger := 0;
  ClientDataSet1.FieldByName('Title').AsString := 'New York';
  ClientDataSet1.FieldByName('Text').AsString := 'Shoe model';
  ClientDataSet1.FieldByName('Color').AsLongWord := gcOrange;

  ClientDataSet1.Insert;
  ClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  ClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 1 + EncodeTime(11, 30, 0, 0);
  ClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 1 + EncodeTime(16, 15, 0, 0);
  ClientDataSet1.FieldByName('Resource').AsInteger := 0;
  ClientDataSet1.FieldByName('Title').AsString := 'L.A.';
  ClientDataSet1.FieldByName('Text').AsString := 'Audition for movie';
  ClientDataSet1.FieldByName('Color').AsLongWord := gcOrange;

  ClientDataSet1.Insert;
  ClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  ClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 3 + EncodeTime(11, 30, 0, 0);
  ClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 3 + EncodeTime(17, 0, 0, 0);
  ClientDataSet1.FieldByName('Resource').AsInteger := 0;
  ClientDataSet1.FieldByName('Title').AsString := 'Antwerp';
  ClientDataSet1.FieldByName('Text').AsString := 'Clothing line shoot';
  ClientDataSet1.FieldByName('Color').AsLongWord := gcOrange;

  ClientDataSet1.Insert;
  ClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  ClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 4 + EncodeTime(8, 0, 0, 0);
  ClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 5 + EncodeTime(15, 0, 0, 0);
  ClientDataSet1.FieldByName('Resource').AsInteger := 0;
  ClientDataSet1.FieldByName('Title').AsString := 'Milan';
  ClientDataSet1.FieldByName('Text').AsString := 'Fashion Show';
  ClientDataSet1.FieldByName('Color').AsLongWord := gcOrange;

  ClientDataSet1.Insert;
  ClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  ClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + EncodeTime(8, 0, 0, 0);
  ClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + EncodeTime(12, 0, 0, 0);
  ClientDataSet1.FieldByName('Resource').AsInteger := 1;
  ClientDataSet1.FieldByName('Title').AsString := 'Instagram';
  ClientDataSet1.FieldByName('Text').AsString := 'Create new content for page';
  ClientDataSet1.FieldByName('Recurrency').AsString := 'RRULE:FREQ=WEEKLY;BYDAY=TU,TH';
  ClientDataSet1.FieldByName('Color').AsLongWord := gcDarkgray;

  ClientDataSet1.Insert;
  ClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  ClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 2 + EncodeTime(14, 0, 0, 0);
  ClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 2 + EncodeTime(22, 0, 0, 0);
  ClientDataSet1.FieldByName('Resource').AsInteger := 1;
  ClientDataSet1.FieldByName('Title').AsString := 'Miami';
  ClientDataSet1.FieldByName('Text').AsString := 'Weekly shoot at the beach';
  ClientDataSet1.FieldByName('Recurrency').AsString := 'RRULE:FREQ=WEEKLY';
  ClientDataSet1.FieldByName('Color').AsLongWord := gcDarkgray;


  ClientDataSet1.Insert;
  ClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  ClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + EncodeTime(10, 0, 0, 0);
  ClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + EncodeTime(20, 0, 0, 0);
  ClientDataSet1.FieldByName('Resource').AsInteger := 2;
  ClientDataSet1.FieldByName('Title').AsString := 'TV Ad';
  ClientDataSet1.FieldByName('Text').AsString := 'Advertisement for toothpaste';
  ClientDataSet1.FieldByName('Color').AsLongWord := gcSteelblue;

  ClientDataSet1.Insert;
  ClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  ClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 5 + EncodeTime(8, 0, 0, 0);
  ClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 5 + EncodeTime(16, 0, 0, 0);
  ClientDataSet1.FieldByName('Resource').AsInteger := 2;
  ClientDataSet1.FieldByName('Title').AsString := 'Prada Casting';
  ClientDataSet1.FieldByName('Text').AsString := 'Casting to become this years face of Prada';
  ClientDataSet1.FieldByName('Color').AsLongWord := gcSteelblue;

  ClientDataSet1.Insert;
  ClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  ClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 2 + EncodeTime(4, 0, 0, 0);
  ClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 3 + EncodeTime(20, 0, 0, 0);
  ClientDataSet1.FieldByName('Resource').AsInteger := 2;
  ClientDataSet1.FieldByName('Title').AsString := 'Barcelona';
  ClientDataSet1.FieldByName('Text').AsString := 'Meet with Daniel Harris for audition';
  ClientDataSet1.FieldByName('Color').AsLongWord := gcSteelblue;

  ClientDataSet1.Insert;
  ClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  ClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 3 + EncodeTime(11, 30, 0, 0);
  ClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 3 + EncodeTime(21, 30, 0, 0);
  ClientDataSet1.FieldByName('Resource').AsInteger := 4;
  ClientDataSet1.FieldByName('Title').AsString := 'Clothes';
  ClientDataSet1.FieldByName('Text').AsString := 'New clothes line presentation in Milan';
  ClientDataSet1.FieldByName('Color').AsLongWord := gcSeagreen;

  ClientDataSet1.Insert;
  ClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  ClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 5 + EncodeTime(8, 0, 0, 0);
  ClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 5 + EncodeTime(16, 0, 0, 0);
  ClientDataSet1.FieldByName('Resource').AsInteger := 4;
  ClientDataSet1.FieldByName('Title').AsString := 'Prada Casting';
  ClientDataSet1.FieldByName('Text').AsString := 'Casting to become this years face of Prada';
  ClientDataSet1.FieldByName('Color').AsLongWord := gcSeagreen;

  ClientDataSet1.Insert;
  ClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  ClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 8 + EncodeTime(9, 15, 0, 0);
  ClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 8 + EncodeTime(18, 45, 0, 0);
  ClientDataSet1.FieldByName('Resource').AsInteger := 4;
  ClientDataSet1.FieldByName('Title').AsString := 'Extras';
  ClientDataSet1.FieldByName('Text').AsString := 'Extras role in new sitcom';
  ClientDataSet1.FieldByName('Color').AsLongWord := gcSeagreen;

  ClientDataSet1.Insert;
  ClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  ClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + EncodeTime(4, 0, 0, 0);
  ClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + EncodeTime(22, 0, 0, 0);
  ClientDataSet1.FieldByName('Resource').AsInteger := 3;
  ClientDataSet1.FieldByName('Title').AsString := 'Photoshoot';
  ClientDataSet1.FieldByName('Text').AsString := 'Photoshoot for bikini magazine';
  ClientDataSet1.FieldByName('Recurrency').AsString := 'RRULE:FREQ=DAILY;BYDAY=MO,FR';
  ClientDataSet1.FieldByName('Color').AsLongWord := gcSkyblue;

  ClientDataSet1.Insert;
  ClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  ClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 1 + EncodeTime(12, 0, 0, 0);
  ClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 1 + EncodeTime(20, 0, 0, 0);
  ClientDataSet1.FieldByName('Resource').AsInteger := 3;
  ClientDataSet1.FieldByName('Title').AsString := 'Mall Model';
  ClientDataSet1.FieldByName('Text').AsString := 'Live model in Haute Couture';
  ClientDataSet1.FieldByName('Recurrency').AsString := 'RRULE:FREQ=DAILY;BYDAY=SA,SU';
  ClientDataSet1.FieldByName('Color').AsLongWord := gcSkyblue;

  ClientDataSet1.Insert;
  ClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  ClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 1 + EncodeTime(12, 0, 0, 0);
  ClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 2 + EncodeTime(20, 0, 0, 0);
  ClientDataSet1.FieldByName('Resource').AsInteger := 5;
  ClientDataSet1.FieldByName('Title').AsString := 'Catwalk';
  ClientDataSet1.FieldByName('Text').AsString := 'Catwalk in Paris';
  ClientDataSet1.FieldByName('Color').AsLongWord := gcPlum;

  ClientDataSet1.Insert;
  ClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  ClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + EncodeTime(4, 0, 0, 0);
  ClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 1 + EncodeTime(16, 0, 0, 0);
  ClientDataSet1.FieldByName('Resource').AsInteger := 6;
  ClientDataSet1.FieldByName('Title').AsString := 'TV Ad';
  ClientDataSet1.FieldByName('Text').AsString := 'Dinner with friends at the seafood restaurant while shooting a new advertisement';
  ClientDataSet1.FieldByName('Color').AsLongWord := gcLightpink;

  ClientDataSet1.Insert;
  ClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  ClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 4 + EncodeTime(4, 0, 0, 0);
  ClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 4 + EncodeTime(20, 30, 0, 0);
  ClientDataSet1.FieldByName('Resource').AsInteger := 6;
  ClientDataSet1.FieldByName('Title').AsString := 'Catwalk';
  ClientDataSet1.FieldByName('Text').AsString := 'Catwalk in Barcelona';
  ClientDataSet1.FieldByName('Color').AsLongWord := gcLightpink;

  ClientDataSet1.Insert;
  ClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  ClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 5 + EncodeTime(8, 0, 0, 0);
  ClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 5 + EncodeTime(16, 0, 0, 0);
  ClientDataSet1.FieldByName('Resource').AsInteger := 6;
  ClientDataSet1.FieldByName('Title').AsString := 'Prada Casting';
  ClientDataSet1.FieldByName('Text').AsString := 'Casting to become this years face of Prada';
  ClientDataSet1.FieldByName('Color').AsLongWord := gcLightpink;

  ClientDataSet1.Insert;
  ClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  ClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 1;
  ClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 1 + EncodeTime(12, 0, 0, 0);
  ClientDataSet1.FieldByName('Resource').AsInteger := 7;
  ClientDataSet1.FieldByName('Title').AsString := 'Portfolio Update';
  ClientDataSet1.FieldByName('Text').AsString := 'Shoot at the market in Phuket';
  ClientDataSet1.FieldByName('Color').AsLongWord := gcDarkkhaki;

  ClientDataSet1.Insert;
  ClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  ClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 3.5 + EncodeTime(4, 0, 0, 0);
  ClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now)+ 3.5 + EncodeTime(22, 0, 0, 0);
  ClientDataSet1.FieldByName('Resource').AsInteger := 7;
  ClientDataSet1.FieldByName('Title').AsString := 'Exclusive Night';
  ClientDataSet1.FieldByName('Text').AsString := 'Steward on Exclusive Night event';
  ClientDataSet1.FieldByName('Color').AsLongWord := gcDarkkhaki;

  ClientDataSet1.Post;

  TMSFNCPlannerDatabaseAdapter1.Active := True;
end;

procedure TForm3.TMSFNCPlanner1AfterNavigateToDateTime(Sender: TObject;
  ADirection: TTMSFNCPlannerNavigationDirection; ACurrentDateTime,
  ANewDateTime: TDateTime);
begin
  TMSFNCPlannerDatabaseAdapter1.LoadItems;
end;

procedure TForm3.TMSFNCPlanner1IsDateTimeSub(Sender: TObject;
  ADateTime: TDateTime; var AIsSub: Boolean);
begin
  AIsSub := HourOf(ADateTime) + MinuteOf(ADateTime) + SecondOf(ADateTime) + MilliSecondOf(ADateTime) > 0;
end;

procedure TForm3.TMSFNCPlannerDatabaseAdapter1FieldsToItem(Sender: TObject;
  AFields: TFields; AItem: TTMSFNCPlannerItem);
var
  c: TTMSFNCGraphicsColor;
begin
  c := AFields.FieldByName('Color').AsLongWord;
  if c <> 0 then
    AItem.Color := c
  else
    AItem.Color := TMSFNCPlanner1.DefaultItem.Color;

  if AItem.Color = gcGhostwhite then
  begin
    AItem.TitleFontColor := gcDarkGray;
    AItem.FontColor := gcDarkgray;
  end;
end;

end.
