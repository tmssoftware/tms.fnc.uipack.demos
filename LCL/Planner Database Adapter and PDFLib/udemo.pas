unit UDemo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Types, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  LCLTMSFNCPlanner, LCLTMSFNCPlannerDatabaseAdapter, LCLTMSFNCGraphics, LCLTMSFNCGraphicsTypes,
  LCLTMSFNCPlannerItemEditorRecurrency, LCLTMSFNCCustomComponent, LCLTMSFNCTypes,
  LCLTMSFNCCustomControl, LCLTMSFNCPlannerBase, LCLTMSFNCPlannerData,
  LCLTMSFNCBitmapContainer, LCLTMSFNCPDFLib, LCLTMSFNCPDFIO, LCLTMSFNCGraphicsPDFEngine, memds, db;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button2: TButton;
    DataSource1: TDataSource;
    MemDataset1: TMemDataset;
 Panel1: TPanel;
    Label1: TLabel;
    Button1: TButton;
    Label2: TLabel;
    TMSFNCPDFLib1: TTMSFNCPDFLib;
    TMSFNCPlanner1: TTMSFNCPlanner;
    TMSFNCPlannerDatabaseAdapter1: TTMSFNCPlannerDatabaseAdapter;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    TMSFNCPlannerItemEditorRecurrency1: TTMSFNCPlannerItemEditorRecurrency;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure TMSFNCPlanner1AfterNavigateToDateTime(Sender: TObject;
      ADirection: TTMSFNCPlannerNavigationDirection; ACurrentDateTime,
      ANewDateTime: TDateTime);
    procedure TMSFNCPlanner1IsDateTimeSub(Sender: TObject; ADateTime: TDateTime;
      var AIsSub: Boolean);
    procedure TMSFNCPlannerDatabaseAdapter1FieldsToItem(Sender: TObject;
      AFields: TFields; AItem: TTMSFNCPlannerItem);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


var
  Form1: TForm1;

implementation

uses
  DateUtils;

{$R *.lfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  MemDataSet1.Active := not MemDataSet1.Active;
  if MemDataSet1.Active then
    Button1.Caption := 'Disconnect'
  else
    Button1.Caption := 'Connect';
end;

procedure TForm1.Button2Click(Sender: TObject);
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

procedure TForm1.FormCreate(Sender: TObject);
var
  I: Integer;
  res: TTMSFNCPlannerResource;
begin
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

  MemDataSet1.FieldDefs.Add('Id', ftString, 255);
  MemDataSet1.FieldDefs.Add('Resource', ftString, 10);
  MemDataSet1.FieldDefs.Add('Title', ftString, 10);
  MemDataSet1.FieldDefs.Add('Text', ftString, 255);
  MemDataSet1.FieldDefs.Add('StartTime', ftDateTime);
  MemDataSet1.FieldDefs.Add('EndTime', ftDateTime);
  MemDataSet1.FieldDefs.Add('Recurrency', ftString, 255);
  MemDataSet1.FieldDefs.Add('Color', ftInteger);
  MemDataSet1.Active := True;

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

  MemDataSet1.Insert;
  MemDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  MemDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + EncodeTime(8, 0, 0, 0);
  MemDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + EncodeTime(20, 0, 0, 0);
  MemDataSet1.FieldByName('Resource').AsInteger := 0;
  MemDataSet1.FieldByName('Title').AsString := 'Miami';
  MemDataSet1.FieldByName('Text').AsString := 'Dialy shoot at the beach';
  MemDataSet1.FieldByName('Recurrency').AsString := 'RRULE:FREQ=DAILY';
  MemDataSet1.FieldByName('Color').AsInteger := gcOrange;

  MemDataSet1.Insert;
  MemDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  MemDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + EncodeTime(12, 0, 0, 0);
  MemDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + EncodeTime(20, 0, 0, 0);
  MemDataSet1.FieldByName('Resource').AsInteger := 1;
  MemDataSet1.FieldByName('Title').AsString := 'New York';
  MemDataSet1.FieldByName('Text').AsString := 'Shoe model';
  MemDataSet1.FieldByName('Color').AsInteger := gcDarkgray;

  MemDataSet1.Insert;
  MemDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  MemDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 4 + EncodeTime(12, 0, 0, 0);
  MemDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 5 + EncodeTime(20, 0, 0, 0);
  MemDataSet1.FieldByName('Resource').AsInteger := 1;
  MemDataSet1.FieldByName('Title').AsString := 'New York';
  MemDataSet1.FieldByName('Text').AsString := 'Shoe model';
  MemDataSet1.FieldByName('Color').AsInteger := gcDarkgray;

  MemDataSet1.Insert;
  MemDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  MemDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 1 + EncodeTime(11, 30, 0, 0);
  MemDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 2 + EncodeTime(20, 0, 0, 0);
  MemDataSet1.FieldByName('Resource').AsInteger := 1;
  MemDataSet1.FieldByName('Title').AsString := 'Barcelona';
  MemDataSet1.FieldByName('Text').AsString := 'Audition for photoshoot';
  MemDataSet1.FieldByName('Color').AsInteger := gcDarkgray;

  MemDataSet1.Insert;
  MemDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  MemDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + EncodeTime(10, 0, 0, 0);
  MemDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + EncodeTime(20, 0, 0, 0);
  MemDataSet1.FieldByName('Resource').AsInteger := 2;
  MemDataSet1.FieldByName('Title').AsString := 'TV Ad';
  MemDataSet1.FieldByName('Text').AsString := 'Advertisement for toothpaste';
  MemDataSet1.FieldByName('Color').AsInteger := gcGhostwhite;

  MemDataSet1.Insert;
  MemDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  MemDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 5 + EncodeTime(10, 0, 0, 0);
  MemDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 6 + EncodeTime(10, 0, 0, 0);
  MemDataSet1.FieldByName('Resource').AsInteger := 2;
  MemDataSet1.FieldByName('Title').AsString := 'TV Ad';
  MemDataSet1.FieldByName('Text').AsString := 'Advertisement for toothpaste';
  MemDataSet1.FieldByName('Color').AsInteger := gcGhostwhite;

  MemDataSet1.Insert;
  MemDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  MemDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 2 + EncodeTime(4, 0, 0, 0);
  MemDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 3 + EncodeTime(20, 0, 0, 0);
  MemDataSet1.FieldByName('Resource').AsInteger := 2;
  MemDataSet1.FieldByName('Title').AsString := 'Barcelona';
  MemDataSet1.FieldByName('Text').AsString := 'Meet with Daniel Harris for audition';
  MemDataSet1.FieldByName('Color').AsInteger := gcGhostwhite;

  MemDataSet1.Insert;
  MemDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  MemDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 3 + EncodeTime(11, 30, 0, 0);
  MemDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 3 + EncodeTime(21, 30, 0, 0);
  MemDataSet1.FieldByName('Resource').AsInteger := 3;
  MemDataSet1.FieldByName('Title').AsString := 'Clothes';
  MemDataSet1.FieldByName('Text').AsString := 'New clothes line presentation in Milan';
  MemDataSet1.FieldByName('Color').AsInteger := gcSeagreen;

  MemDataSet1.Insert;
  MemDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  MemDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + EncodeTime(4, 0, 0, 0);
  MemDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + EncodeTime(22, 0, 0, 0);
  MemDataSet1.FieldByName('Resource').AsInteger := 4;
  MemDataSet1.FieldByName('Title').AsString := 'Photoshoot';
  MemDataSet1.FieldByName('Text').AsString := 'Photoshoot for bikini magazine';
  MemDataSet1.FieldByName('Recurrency').AsString := 'RRULE:FREQ=DAILY;BYDAY=MO,WE,FR,SU';
  MemDataSet1.FieldByName('Color').AsInteger := gcSkyblue;

  MemDataSet1.Insert;
  MemDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  MemDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 1 + EncodeTime(12, 0, 0, 0);
  MemDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 2 + EncodeTime(20, 0, 0, 0);
  MemDataSet1.FieldByName('Resource').AsInteger := 5;
  MemDataSet1.FieldByName('Title').AsString := 'Catwalk';
  MemDataSet1.FieldByName('Text').AsString := 'Catwalk in Paris';
  MemDataSet1.FieldByName('Color').AsInteger := gcPlum;

  MemDataSet1.Insert;
  MemDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  MemDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + EncodeTime(4, 0, 0, 0);
  MemDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 1 + EncodeTime(16, 0, 0, 0);
  MemDataSet1.FieldByName('Resource').AsInteger := 6;
  MemDataSet1.FieldByName('Title').AsString := 'TV Ad';
  MemDataSet1.FieldByName('Text').AsString := 'Dinner with friends at the seafood restaurant while shooting a new advertisement';
  MemDataSet1.FieldByName('Color').AsInteger := gcLightpink;

  MemDataSet1.Insert;
  MemDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  MemDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 4 + EncodeTime(4, 0, 0, 0);
  MemDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 4 + EncodeTime(20, 30, 0, 0);
  MemDataSet1.FieldByName('Resource').AsInteger := 6;
  MemDataSet1.FieldByName('Title').AsString := 'Catwalk';
  MemDataSet1.FieldByName('Text').AsString := 'Catwalk in Barcelona';
  MemDataSet1.FieldByName('Color').AsInteger := gcLightpink;

  MemDataSet1.Insert;
  MemDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  MemDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 1;
  MemDataSet1.FieldByName('EndTime').AsDateTime := Int(Now) + 1 + EncodeTime(12, 0, 0, 0);
  MemDataSet1.FieldByName('Resource').AsInteger := 7;
  MemDataSet1.FieldByName('Title').AsString := 'Test shoot';
  MemDataSet1.FieldByName('Text').AsString := 'Test shoot at the market in Phuket';
  MemDataSet1.FieldByName('Color').AsInteger := gcDarkkhaki;

  MemDataSet1.Insert;
  MemDataSet1.FieldByName('Id').AsString := TGuid.NewGuid.ToString;
  MemDataSet1.FieldByName('StartTime').AsDateTime := Int(Now) + 3.5 + EncodeTime(4, 0, 0, 0);
  MemDataSet1.FieldByName('EndTime').AsDateTime := Int(Now)+ 3.5 + EncodeTime(22, 0, 0, 0);
  MemDataSet1.FieldByName('Resource').AsInteger := 7;
  MemDataSet1.FieldByName('Title').AsString := 'Test shoot 2';
  MemDataSet1.FieldByName('Text').AsString := 'Second Test shoot at the market in Phuket';
  MemDataSet1.FieldByName('Color').AsInteger := gcDarkkhaki;

  MemDataSet1.Post;

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
  c := AFields.FieldByName('Color').AsInteger;
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


