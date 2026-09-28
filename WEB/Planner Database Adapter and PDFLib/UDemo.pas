unit UDemo;

interface

uses
  System.SysUtils, System.Classes, Types, Contnrs, JS, Web, WEBLib.Graphics, WEBLib.Controls,
  WEBLib.Forms, WEBLib.Dialogs, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, Data.DB, WEBLib.DB, WEBLib.CDS,
  VCL.TMSFNCBitmapContainer, VCL.TMSFNCCustomComponent, VCL.TMSFNCPlanner,
  VCL.TMSFNCPlannerDatabaseAdapter, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPlannerBase, VCL.TMSFNCPlannerData, Vcl.Controls, Vcl.StdCtrls,
  WEBLib.StdCtrls, WEBLib.ExtCtrls, WEBLib.TMSFNCPDFLib, WEBLib.TMSFNCPDFIO, WEBLib.TMSFNCGraphicsPDFEngine,
  VCL.TMSFNCPDFLib, WEBLib.TMSFNCTypes, VCL.TMSFNCTypes, VCL.TMSFNCUtils;

type
  TForm1 = class(TWebForm)
    WebPanel1: TWebPanel;
    WebLabel1: TWebLabel;
    WebLabel2: TWebLabel;
    TMSFNCPlanner1: TTMSFNCPlanner;
    TMSFNCPlannerDatabaseAdapter1: TTMSFNCPlannerDatabaseAdapter;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    WebClientDataSet1: TWebClientDataSet;
    WebDataSource1: TWebDataSource;
    WebButton1: TWebButton;
    procedure WebFormCreate(Sender: TObject);
    procedure DoFontCacheReady(Sender: TObject);
    procedure WebButton1Click(Sender: TObject);
    procedure TMSFNCPlanner1AfterNavigateToDateTime(Sender: TObject;
      ADirection: TTMSFNCPlannerNavigationDirection; ACurrentDateTime,
      ANewDateTime: TDateTime);
    procedure TMSFNCPlanner1IsDateTimeSub(Sender: TObject; ADateTime: TDateTime;
      var AIsSub: Boolean);
    procedure TMSFNCPlannerDatabaseAdapter1FieldsToItem(Sender: TObject;
      AFields: TFields; AItem: TTMSFNCPlannerItem);
  private
    { Private declarations }
    procedure LoadData;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  DateUtils;

{$R *.dfm}

{ TForm1 }

procedure TForm1.DoFontCacheReady(Sender: TObject);
begin
  WebButton1.Visible := True;
end;

procedure TForm1.LoadData;
begin
  WebClientDataSet1.FieldDefs.Clear;

  WebClientDataSet1.FieldDefs.Add('Id', ftString, 255);
  WebClientDataSet1.FieldDefs.Add('Resource', ftString, 10);
  WebClientDataSet1.FieldDefs.Add('Title', ftString, 10);
  WebClientDataSet1.FieldDefs.Add('Text', ftString, 255);
  WebClientDataSet1.FieldDefs.Add('StartTime', ftDateTime);
  WebClientDataSet1.FieldDefs.Add('EndTime', ftDateTime);
  WebClientDataSet1.FieldDefs.Add('Recurrency', ftString, 255);
  WebClientDataSet1.FieldDefs.Add('Color', ftInteger);
  WebClientDataSet1.Active := True;

  TMSFNCPlanner1.Adapter := TMSFNCPlannerDatabaseAdapter1;
  TMSFNCPlannerDatabaseAdapter1.Item.AutoIncrementDBKey := False;
  TMSFNCPlannerDatabaseAdapter1.Item.DataSource := WebDataSource1;
  TMSFNCPlannerDatabaseAdapter1.Item.DBKey := 'Id';
  TMSFNCPlannerDatabaseAdapter1.Item.StartTime := 'StartTime';
  TMSFNCPlannerDatabaseAdapter1.Item.EndTime := 'EndTime';
  TMSFNCPlannerDatabaseAdapter1.Item.Title := 'Title';
  TMSFNCPlannerDatabaseAdapter1.Item.Text := 'Text';
  TMSFNCPlannerDatabaseAdapter1.Item.Resource := 'Resource';
  TMSFNCPlannerDatabaseAdapter1.Item.Recurrency := 'Recurrency';

  WebClientDataSet1.Insert;
  WebClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  WebClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + EncodeTime(12, 0, 0, 0);
  WebClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + EncodeTime(20, 0, 0, 0);
  WebClientDataSet1.FieldByName('Resource').AsInteger := 0;
  WebClientDataSet1.FieldByName('Title').AsString := 'New York';
  WebClientDataSet1.FieldByName('Text').AsString := 'Shoe model';
  WebClientDataSet1.FieldByName('Color').AsInteger := gcOrange;

  WebClientDataSet1.Insert;
  WebClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  WebClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 1 + EncodeTime(11, 30, 0, 0);
  WebClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 1 + EncodeTime(16, 15, 0, 0);
  WebClientDataSet1.FieldByName('Resource').AsInteger := 0;
  WebClientDataSet1.FieldByName('Title').AsString := 'L.A.';
  WebClientDataSet1.FieldByName('Text').AsString := 'Audition for movie';
  WebClientDataSet1.FieldByName('Color').AsInteger := gcOrange;

  WebClientDataSet1.Insert;
  WebClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  WebClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 3 + EncodeTime(11, 30, 0, 0);
  WebClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 3 + EncodeTime(17, 0, 0, 0);
  WebClientDataSet1.FieldByName('Resource').AsInteger := 0;
  WebClientDataSet1.FieldByName('Title').AsString := 'Antwerp';
  WebClientDataSet1.FieldByName('Text').AsString := 'Clothing line shoot';
  WebClientDataSet1.FieldByName('Color').AsInteger := gcOrange;

  WebClientDataSet1.Insert;
  WebClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  WebClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 4 + EncodeTime(8, 0, 0, 0);
  WebClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 5 + EncodeTime(15, 0, 0, 0);
  WebClientDataSet1.FieldByName('Resource').AsInteger := 0;
  WebClientDataSet1.FieldByName('Title').AsString := 'Milan';
  WebClientDataSet1.FieldByName('Text').AsString := 'Fashion Show';
  WebClientDataSet1.FieldByName('Color').AsInteger := gcOrange;

  WebClientDataSet1.Insert;
  WebClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  WebClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + EncodeTime(8, 0, 0, 0);
  WebClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + EncodeTime(12, 0, 0, 0);
  WebClientDataSet1.FieldByName('Resource').AsInteger := 1;
  WebClientDataSet1.FieldByName('Title').AsString := 'Instagram';
  WebClientDataSet1.FieldByName('Text').AsString := 'Create new content for page';
  WebClientDataSet1.FieldByName('Recurrency').AsString := 'RRULE:FREQ=WEEKLY;BYDAY=TU,TH';
  WebClientDataSet1.FieldByName('Color').AsInteger := gcDarkgray;

  WebClientDataSet1.Insert;
  WebClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  WebClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 2 + EncodeTime(14, 0, 0, 0);
  WebClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 2 + EncodeTime(22, 0, 0, 0);
  WebClientDataSet1.FieldByName('Resource').AsInteger := 1;
  WebClientDataSet1.FieldByName('Title').AsString := 'Miami';
  WebClientDataSet1.FieldByName('Text').AsString := 'Weekly shoot at the beach';
  WebClientDataSet1.FieldByName('Recurrency').AsString := 'RRULE:FREQ=WEEKLY';
  WebClientDataSet1.FieldByName('Color').AsInteger := gcDarkgray;


  WebClientDataSet1.Insert;
  WebClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  WebClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + EncodeTime(10, 0, 0, 0);
  WebClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + EncodeTime(20, 0, 0, 0);
  WebClientDataSet1.FieldByName('Resource').AsInteger := 2;
  WebClientDataSet1.FieldByName('Title').AsString := 'TV Ad';
  WebClientDataSet1.FieldByName('Text').AsString := 'Advertisement for toothpaste';
  WebClientDataSet1.FieldByName('Color').AsInteger := gcSteelblue;

  WebClientDataSet1.Insert;
  WebClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  WebClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 5 + EncodeTime(8, 0, 0, 0);
  WebClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 5 + EncodeTime(16, 0, 0, 0);
  WebClientDataSet1.FieldByName('Resource').AsInteger := 2;
  WebClientDataSet1.FieldByName('Title').AsString := 'Prada Casting';
  WebClientDataSet1.FieldByName('Text').AsString := 'Casting to become this years face of Prada';
  WebClientDataSet1.FieldByName('Color').AsInteger := gcSteelblue;

  WebClientDataSet1.Insert;
  WebClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  WebClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 2 + EncodeTime(4, 0, 0, 0);
  WebClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 3 + EncodeTime(20, 0, 0, 0);
  WebClientDataSet1.FieldByName('Resource').AsInteger := 2;
  WebClientDataSet1.FieldByName('Title').AsString := 'Barcelona';
  WebClientDataSet1.FieldByName('Text').AsString := 'Meet with Daniel Harris for audition';
  WebClientDataSet1.FieldByName('Color').AsInteger := gcSteelblue;

  WebClientDataSet1.Insert;
  WebClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  WebClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 3 + EncodeTime(11, 30, 0, 0);
  WebClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 3 + EncodeTime(21, 30, 0, 0);
  WebClientDataSet1.FieldByName('Resource').AsInteger := 4;
  WebClientDataSet1.FieldByName('Title').AsString := 'Clothes';
  WebClientDataSet1.FieldByName('Text').AsString := 'New clothes line presentation in Milan';
  WebClientDataSet1.FieldByName('Color').AsInteger := gcSeagreen;

  WebClientDataSet1.Insert;
  WebClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  WebClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 5 + EncodeTime(8, 0, 0, 0);
  WebClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 5 + EncodeTime(16, 0, 0, 0);
  WebClientDataSet1.FieldByName('Resource').AsInteger := 4;
  WebClientDataSet1.FieldByName('Title').AsString := 'Prada Casting';
  WebClientDataSet1.FieldByName('Text').AsString := 'Casting to become this years face of Prada';
  WebClientDataSet1.FieldByName('Color').AsInteger := gcSeagreen;

  WebClientDataSet1.Insert;
  WebClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  WebClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 8 + EncodeTime(9, 15, 0, 0);
  WebClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 8 + EncodeTime(18, 45, 0, 0);
  WebClientDataSet1.FieldByName('Resource').AsInteger := 4;
  WebClientDataSet1.FieldByName('Title').AsString := 'Extras';
  WebClientDataSet1.FieldByName('Text').AsString := 'Extras role in new sitcom';
  WebClientDataSet1.FieldByName('Color').AsInteger := gcSeagreen;

  WebClientDataSet1.Insert;
  WebClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  WebClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + EncodeTime(4, 0, 0, 0);
  WebClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + EncodeTime(22, 0, 0, 0);
  WebClientDataSet1.FieldByName('Resource').AsInteger := 3;
  WebClientDataSet1.FieldByName('Title').AsString := 'Photoshoot';
  WebClientDataSet1.FieldByName('Text').AsString := 'Photoshoot for bikini magazine';
  WebClientDataSet1.FieldByName('Recurrency').AsString := 'RRULE:FREQ=DAILY;BYDAY=MO,FR';
  WebClientDataSet1.FieldByName('Color').AsInteger := gcSkyblue;

  WebClientDataSet1.Insert;
  WebClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  WebClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 1 + EncodeTime(12, 0, 0, 0);
  WebClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 1 + EncodeTime(20, 0, 0, 0);
  WebClientDataSet1.FieldByName('Resource').AsInteger := 3;
  WebClientDataSet1.FieldByName('Title').AsString := 'Mall Model';
  WebClientDataSet1.FieldByName('Text').AsString := 'Live model in Haute Couture';
  WebClientDataSet1.FieldByName('Recurrency').AsString := 'RRULE:FREQ=DAILY;BYDAY=SA,SU';
  WebClientDataSet1.FieldByName('Color').AsInteger := gcSkyblue;

  WebClientDataSet1.Insert;
  WebClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  WebClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 1 + EncodeTime(12, 0, 0, 0);
  WebClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 2 + EncodeTime(20, 0, 0, 0);
  WebClientDataSet1.FieldByName('Resource').AsInteger := 5;
  WebClientDataSet1.FieldByName('Title').AsString := 'Catwalk';
  WebClientDataSet1.FieldByName('Text').AsString := 'Catwalk in Paris';
  WebClientDataSet1.FieldByName('Color').AsInteger := gcPlum;

  WebClientDataSet1.Insert;
  WebClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  WebClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + EncodeTime(4, 0, 0, 0);
  WebClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 1 + EncodeTime(16, 0, 0, 0);
  WebClientDataSet1.FieldByName('Resource').AsInteger := 6;
  WebClientDataSet1.FieldByName('Title').AsString := 'TV Ad';
  WebClientDataSet1.FieldByName('Text').AsString := 'Dinner with friends at the seafood restaurant while shooting a new advertisement';
  WebClientDataSet1.FieldByName('Color').AsInteger := gcLightpink;

  WebClientDataSet1.Insert;
  WebClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  WebClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 4 + EncodeTime(4, 0, 0, 0);
  WebClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 4 + EncodeTime(20, 30, 0, 0);
  WebClientDataSet1.FieldByName('Resource').AsInteger := 6;
  WebClientDataSet1.FieldByName('Title').AsString := 'Catwalk';
  WebClientDataSet1.FieldByName('Text').AsString := 'Catwalk in Barcelona';
  WebClientDataSet1.FieldByName('Color').AsInteger := gcLightpink;

  WebClientDataSet1.Insert;
  WebClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  WebClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 5 + EncodeTime(8, 0, 0, 0);
  WebClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 5 + EncodeTime(16, 0, 0, 0);
  WebClientDataSet1.FieldByName('Resource').AsInteger := 6;
  WebClientDataSet1.FieldByName('Title').AsString := 'Prada Casting';
  WebClientDataSet1.FieldByName('Text').AsString := 'Casting to become this years face of Prada';
  WebClientDataSet1.FieldByName('Color').AsInteger := gcLightpink;

  WebClientDataSet1.Insert;
  WebClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  WebClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 1;
  WebClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 1 + EncodeTime(12, 0, 0, 0);
  WebClientDataSet1.FieldByName('Resource').AsInteger := 7;
  WebClientDataSet1.FieldByName('Title').AsString := 'Portfolio Update';
  WebClientDataSet1.FieldByName('Text').AsString := 'Shoot at the market in Phuket';
  WebClientDataSet1.FieldByName('Color').AsInteger := gcDarkkhaki;

  WebClientDataSet1.Insert;
  WebClientDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  WebClientDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 3.5 + EncodeTime(4, 0, 0, 0);
  WebClientDataSet1.FieldByName('EndTime').AsDateTime := Int(Now)+ 3.5 + EncodeTime(22, 0, 0, 0);
  WebClientDataSet1.FieldByName('Resource').AsInteger := 7;
  WebClientDataSet1.FieldByName('Title').AsString := 'Exclusive Night';
  WebClientDataSet1.FieldByName('Text').AsString := 'Steward on Exclusive Night event';
  WebClientDataSet1.FieldByName('Color').AsInteger := gcDarkkhaki;

  WebClientDataSet1.Post;
  TMSFNCPlannerDatabaseAdapter1.Active := True;
end;

procedure TForm1.TMSFNCPlanner1AfterNavigateToDateTime(Sender: TObject;
  ADirection: TTMSFNCPlannerNavigationDirection; ACurrentDateTime,
  ANewDateTime: TDateTime);
begin
  TMSFNCPlannerDatabaseAdapter1.LoadItems;
end;

procedure TForm1.TMSFNCPlanner1IsDateTimeSub(Sender: TObject;
  ADateTime: TDateTime; var AIsSub: Boolean);
begin
  AIsSub := HourOf(ADateTime) + MinuteOf(ADateTime) + SecondOf(ADateTime) + MilliSecondOf(ADateTime) > 0;
end;

procedure TForm1.TMSFNCPlannerDatabaseAdapter1FieldsToItem(Sender: TObject;
  AFields: TFields; AItem: TTMSFNCPlannerItem);
var
  c: TTMSFNCGraphicsColor;
begin
  c := AFields.FieldByName('Color').asInteger;
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

//procedure TForm1.WebButton1Click(Sender: TObject);
//var
//  PDF: TTMSFNCPDFLib;
//begin
//  PDF := TTMSFNCPDFLib.Create;
//  try
//    PDF.BeginDocument('TestPDFPlannerDemo.pdf');
//    PDF.NewPage;
//    PDF.Graphics.DrawText('Hello World!', PointF(100, 100));
//    PDF.EndDocument(True);
//  finally
//    PDF.Free;
//  end;
//end;

procedure TForm1.WebButton1Click(Sender: TObject);
var
  txt: string;
  s: TStringList;
  r: TRectF;
  offsetx,ry: single;
  I: Integer;
  j: Integer;
  dts,dte: string;
  fdraw: Boolean;
  PDF: TTMSFNCPDFLib;
begin
  offsetx := 30;

  s := TStringList.Create;

  for I := 0 to TMSFNCPlanner1.Resources.Count - 1 do
  begin
    s.AddObject(TMSFNCPlanner1.Resources[I].Text, TMSFNCPlanner1.Resources[I]);
  end;

  PDF := TTMSFNCPDFLib.Create;
  PDF.FontFallBackList.Insert(0, 'Roboto');
  PDF.BitmapContainer := TMSFNCBitmapContainer1;
  try
    PDF.BeginDocument('TestPDFPlannerDemo.pdf');
    for I := 0 to s.Count - 1 do
    begin
      fdraw := True;
      for J := 0 to TMSFNCPlanner1.Items.Count - 1 do
      begin
        if (TMSFNCPlanner1.Items[J].Resource = (s.Objects[I] as TTMSFNCPlannerResource).Index) then
        begin
          if fdraw then
          begin
            PDF.Header := '';
            PDF.Footer := '';
            PDF.NewPage;
            PDF.Graphics.Font.Name := 'Roboto';
            PDF.Graphics.Font.Size := 24;
            r := RectF(offsetx * 2, offsetx , PDF.PageWidth - 2 * offsetx , PDF.PageHeight - offsetx);
            PDF.Graphics.DrawHTMLText(s.Strings[I], r);
            r:= PDF.Graphics.DrawHTMLText(s.Strings[I], r, True, 1, True);
            ry := r.Bottom + 20;
            r := RectF(offsetx, ry, PDF.PageWidth -  offsetx , PDF.PageHeight - offsetx);
            PDF.Graphics.Font.Size := 14;
          end;
          fdraw := false;
          dts := DateTimeToStr(TMSFNCPlanner1.Items[J].StartTime);
          if CompareDate(TMSFNCPlanner1.Items[J].StartTime, TMSFNCPlanner1.Items[J].EndTime) = 0 then
            dte := DateTimeToStr(TMSFNCPlanner1.Items[J].EndTime)
          else
            dte := DateTimeToStr(TMSFNCPlanner1.Items[J].EndTime);
          txt := dts + ' - ' +  dte + ' | <font face="Roboto" color="' + TTMSFNCGraphics.ColorToHTML(TMSFNCPlanner1.Items[J].Color) + '">' +TMSFNCPlanner1.Items[J].Title +':</font> '+TMSFNCPlanner1.Items[J].Text;
          PDF.Graphics.DrawHTMLText(txt, r);

          r:= PDF.Graphics.DrawHTMLText(txt, r, True, 1, True);
          ry := r.Bottom + 20;
          r := RectF(offsetx, ry, PDF.PageWidth -  offsetx , PDF.PageHeight - offsetx);
        end;
      end;
    end;
    PDF.EndDocument(True);
  finally
    s.free;
    PDF.Free;
  end;
end;

procedure TForm1.WebFormCreate(Sender: TObject);
var
  lbl: TWebLabel;
  I: Integer;
  res: TTMSFNCPlannerResource;
begin
  FormContainer := 'appcontent';
  lbl := TWebLabel.Create(Self);
  lbl.ElementID := 'title';
  lbl.Caption := 'TMSFNCPlanner and Database with TMSFNCPDFLib Demo';

  lbl := TWebLabel.Create(Self);
  lbl.ElementID := 'description';
  lbl.Caption := 'How to combine a TMSFNCPlanner with a database and export the data to a PDF.';

  WebButton1.Visible := False;
  Application.OnFontCacheReady := DoFontCacheReady;
  AddFontToCache('https://download.tmssoftware.com/tmsweb/pdf/fonts/Roboto-Regular.ttf');

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
  TMSFNCPlanner1.TimeLineAppearance.LeftSize := 200;
  TMSFNCPlanner1.PositionsAppearance.TopSize := 120;
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

  LoadData;

  TMSFNCPlannerDatabaseAdapter1.Active := True;
end;
end.