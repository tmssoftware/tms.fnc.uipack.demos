unit UTVGuideDemoLCL;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, LCLTMSFNCPlanner, LCLTMSFNCPlannerBase,
  LCLTMSFNCGraphicsTypes, LCLTMSFNCPlannerData, LCLTMSFNCComboBox, LCLTMSFNCCloudBase, LCLTMSFNCUTils, DateUtils,
  fgl, fpjson, jsonparser, LCLTMSFNCTypes;

type
  TTVShow = class
  private
    FGenre: string;
    FStartTime: TDateTime;
    FTitle: string;
    FID: string;
    FEndTime: TDateTime;
    FKind: string;
  public
    property ID: string read FID write FID;
    property Title: string read FTitle write FTitle;
    property Genre: string read FGenre write FGenre;
    property Kind: string read FKind write FKind;
    property StartTime: TDateTime read FStartTime write FStartTime;
    property EndTime: TDateTime read FEndTime write FEndTime;
  end;

  TTVShows = class(specialize TFPGObjectList<TTVShow>);

  { TTVChannel }

  TTVChannel = class
  private
    FName: string;
    FID: string;
    FShows: TTVShows;
  public
    constructor Create;
    destructor Destroy; override;
    property ID: string read FID write FID;
    property Name: string read FName write FName;
    property Shows: TTVShows read FShows;
  end;

  TTVChannels = class(specialize TFPGObjectList<TTVChannel>);

  { TForm1 }

  TForm1 = class(TForm)
    TMSFNCComboBox1: TTMSFNCComboBox;
    TMSFNCPlanner1: TTMSFNCPlanner;
    procedure FormCreate(Sender: TObject);
    procedure TMSFNCComboBox1ItemSelected(Sender: TObject; AText: string;
      AItemIndex: Integer);
  private
    { Private declarations }
    FCloudBase: TTMSFNCCloudBase;
    FChannels: TTVChannels;
  public
    { Public declarations }
    procedure DoGetChannels(const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure DoGetShows(const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure UpdatePlanner;
  end;

var
  Form1: TForm1;

implementation

function UNIXTimeToDateTime(UnixTime: String): TDateTime;
begin
  UnixTime := StringReplace(UnixTime, '.', FormatSettings.DecimalSeparator, [rfReplaceAll]);
  Result := (StrToFloat(UnixTime) / 86400) + 25569;
end;

function DateTimeToUNIXTime(DelphiTime : TDateTime): String;
var
  s: string;
begin
  s := FloatToStrF((DelphiTime - 25569) * 86400, ffFixed, 16, 6);
  Result :=   StringReplace(s,FormatSettings.DecimalSeparator, '.', [rfReplaceAll]);
end;

function GenreIdToSTring(AId: Integer): string;
begin
  Result := 'Other';
  case AId of
    1: Result := 'Amusement';
    2: Result := 'Animation';
    3: Result := 'Comedy';
    4: Result := 'Documentary';
    6: Result := 'Movie';
    7: Result := 'Informative';
    8: Result := 'Kids';
    9: Result := 'Culture';
    10: Result := 'Crime';
    11: Result := 'Music';
    12: Result := 'Nature';
    13: Result := 'News';
    15: Result := 'Religion';
    16: Result := 'Soap';
    17: Result := 'Sports';
    18: Result := 'Theatre';
    19: Result := 'Science ';
    21: Result := 'Popular';
    23: Result := 'Cars';
    31: Result := 'Serie';
  end;
end;

{$R *.lfm}

{ TTVChannel }

constructor TTVChannel.Create;
begin
  FShows := TTVShows.Create;
end;

destructor TTVChannel.Destroy;
begin
  FShows.Free;
  inherited;
end;

{ TForm1 }

procedure TForm1.TMSFNCComboBox1ItemSelected(Sender: TObject; AText: string;
  AItemIndex: Integer);
var
  c: TTMSFNCPlannerCell;
begin
  c.Row := 0;
  c.Col := AItemIndex;
  TMSFNCPlanner1.Navigate(c, True, False, True);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  TMSFNCPlanner1.Visible := False;
  TMSFNCPlanner1.BeginUpdate;
  TMSFNCPlanner1.Items.Clear;
  TMSFNCPlanner1.Positions.Count := 10;
  TMSFNCPlanner1.PositionsAppearance.Stretch := False;
  TMSFNCPlanner1.PositionsAppearance.Size := 120;

  TMSFNCPlanner1.OrientationMode := pomHorizontal;
  TMSFNCPlanner1.VerticalScrollBarVisible := true;

  TMSFNCPlanner1.DefaultItem.TitleColor := gcSlategray;
  TMSFNCPlanner1.DefaultItem.TitleFontColor := gcWhite;
  TMSFNCPlanner1.DefaultItem.Color := gcWhitesmoke;
  TMSFNCPlanner1.DefaultItem.ActiveColor := gcSlateGray;

  TMSFNCPlanner1.Interaction.ReadOnly := True;

  TMSFNCPlanner1.Resources.Clear;

  TMSFNCPlanner1.ItemsAppearance.Stroke.Color := gcWhite;
  TMSFNCPlanner1.ItemsAppearance.Stroke.Kind := gskSolid;
  TMSFNCPlanner1.ItemsAppearance.Stroke.Width := 2;
  TMSFNCPlanner1.ItemsAppearance.TitleStroke.Assign(TMSFNCPlanner1.ItemsAppearance.Stroke);

  TMSFNCPlanner1.GridCellAppearance.InActiveFill.Assign(TMSFNCPlanner1.GridCellAppearance.Fill);
  TMSFNCPlanner1.PositionsAppearance.Layouts := [pplTop, pplBottom];

  TMSFNCPlanner1.ModeSettings.StartTime := Now;
  TMSFNCPlanner1.ModeSettings.EndTime := Now;
  TMSFNCPlanner1.Mode := pmDay;

  TMSFNCPlanner1.TimeLineAppearance.Layouts := [ptlLeft, ptlRight];
  TMSFNCPlanner1.TimeLineAppearance.RightVerticalTextAlign := gtaTrailing;
  TMSFNCPlanner1.TimeLineAppearance.RightSubVerticalTextAlign := gtaLeading;
  TMSFNCPlanner1.TimeLine.CurrentTimePosition := pctpOverItems;
  TMSFNCPlanner1.TimeLine.DisplayUnitType := pduMinute;
  TMSFNCPlanner1.TimeLine.DisplayUnit := 5;
  TMSFNCPlanner1.TimeLine.DisplayStart := 0;
  TMSFNCPlanner1.TimeLine.DisplayEnd := (MinsPerDay div TMSFNCPlanner1.TimeLine.DisplayUnit) - 1;

  TTMSFNCUtils.SetFontSize(TMSFNCPlanner1.ItemsAppearance.TitleFont, 14);
  TTMSFNCUtils.SetFontSize(TMSFNCPlanner1.PositionsAppearance.BottomFont, 14);
  TTMSFNCUtils.SetFontSize(TMSFNCPlanner1.PositionsAppearance.TopFont, 14);

  TMSFNCPlanner1.EndUpdate;
  TMSFNCPlanner1.TimeLine.ViewStart := IncHour(Now, -2);

  FChannels := TTVChannels.Create;

  FCloudBase := TTMSFNCCloudBase.Create;
  FCloudBase.Request.Host := 'http://json.tvgids.nl';
  FCloudBase.Request.Path := '/v4/channels';
  FCloudBase.ExecuteRequest(@DoGetChannels);
end;

procedure TForm1.DoGetChannels(const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  o, fo: TJSONValue;
  jv: TJSONValue;
  ja: TJSONArray;
  I: Integer;
  c: TTVChannel;
begin
  if ARequestResult.ResultString <> '' then
  begin
    o := TTMSFNCUtils.ParseJSON(ARequestResult.ResultString);

    if Assigned(o) then
    begin
      try
        ja := TTMSFNCUtils.GetJSONValue(o, 'data') as TJSONArray;
        for i := 0 to TTMSFNCUtils.GetJSONArraySize(ja) - 1 do
        begin
          fo := TTMSFNCUtils.GetJSONArrayItem(ja, i);
          c := TTVChannel.Create;

          jv := TTMSFNCUtils.GetJSONValue(fo, 'ch_id');
          if Assigned(jv) then
            c.FID := TTMSFNCUtils.GetJSONProp(fo, 'ch_id');

          jv := TTMSFNCUtils.GetJSONValue(fo, 'ch_name');
          if Assigned(jv) then
            c.FName := StringReplace(TTMSFNCUtils.GetJSONProp(fo, 'ch_name'), '&eacute;', 'é', [rfReplaceAll]);

          FChannels.Add(c);
        end;

        TMSFNCComboBox1.Items.Clear;
        for i := 0 to FChannels.Count - 1 do
        begin
          TMSFNCComboBox1.Items.AddObject(FChannels[I].FName, FChannels[I]);
        end;

        FCloudBase.Request.Path := '/v4/programs';
        FCloudBase.ExecuteRequest(@DoGetShows);
      finally
        o.Free;
      end;
    end;
  end;
end;

procedure TForm1.DoGetShows(const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  o, fo, ffo: TJSONValue;
  jv, jvv: TJSONValue;
  ja, jaa: TJSONArray;
  I, J, K: Integer;
  c: TTVChannel;
  s: TTVShow;
  id: string;
begin
  if ARequestResult.ResultString <> '' then
  begin
    o := TTMSFNCUtils.ParseJSON(ARequestResult.ResultString);

    if Assigned(o) then
    begin
      try
        ja := TTMSFNCUtils.GetJSONValue(o, 'data') as TJSONArray;
        for i := 0 to TTMSFNCUtils.GetJSONArraySize(ja) - 1 do
        begin
          fo := TTMSFNCUtils.GetJSONArrayItem(ja, I);

          jv := TTMSFNCUtils.GetJSONValue(fo, 'ch_id');
          if Assigned(jv) then
            id := TTMSFNCUtils.GetJSONProp(fo, 'ch_id');

          for J := 0 to FChannels.Count - 1 do
          begin
            if FChannels[J].ID = id then
            begin
              c := FChannels[J];

              jaa := TTMSFNCUtils.GetJSONValue(fo, 'prog') as TJSONArray;

              for K := 0 to TTMSFNCUtils.GetJSONArraySize(jaa) - 1 do
              begin
                ffo := TTMSFNCUtils.GetJSONArrayItem(jaa, K);
                s := TTVShow.Create;

                jvv := TTMSFNCUtils.GetJSONValue(ffo, 'db_id');
                if Assigned(jvv) then
                  s.FID := TTMSFNCUtils.GetJSONProp(ffo, 'db_id');

                jvv := TTMSFNCUtils.GetJSONValue(ffo, 'title');
                if Assigned(jvv) then
                  s.Title := StringReplace(TTMSFNCUtils.GetJSONProp(ffo, 'title'), '&eacute;', 'é', [rfReplaceAll]);

                jvv := TTMSFNCUtils.GetJSONValue(ffo, 'subgenre');
                if Assigned(jvv) then
                  s.Kind := StringReplace(TTMSFNCUtils.GetJSONProp(ffo, 'subgenre'), '&eacute;', 'é', [rfReplaceAll]);

                jvv := TTMSFNCUtils.GetJSONValue(ffo, 'g_id');
                if Assigned(jvv) then
                  s.Genre := GenreIdToSTring(StrToInt(TTMSFNCUtils.GetJSONProp(ffo, 'g_id')));

                jvv := TTMSFNCUtils.GetJSONValue(ffo, 's');
                if Assigned(jvv) then
                  s.StartTime :=  UNIXTimeToDateTime(TTMSFNCUtils.GetJSONProp(ffo, 's'));

                jvv := TTMSFNCUtils.GetJSONValue(ffo, 'e');
                if Assigned(jvv) then
                  s.EndTime :=  UNIXTimeToDateTime(TTMSFNCUtils.GetJSONProp(ffo, 'e'));

                c.Shows.Add(s);
              end;

              Break;
            end;
          end;
        end;
      finally
        o.Free;
      end;
    end;

    UpdatePlanner;
  end;
end;

procedure TForm1.UpdatePlanner;
var
  dt: TDateTime;
  it: TTMSFNCPlannerItem;
  I: Integer;
  J: Integer;
begin
  dt := Now;
  TMSFNCPlanner1.BeginUpdate;
  TMSFNCPlanner1.Positions.Count := FChannels.Count;
  for I := 0 to TMSFNCPlanner1.Positions.Count - 1 do
  begin
    TMSFNCPlanner1.Resources.Add;
  end;

  for I := 0 to FChannels.Count - 1 do
  begin
      TMSFNCPlanner1.Resources[I].Text := FChannels[I].Name;

    for J := 0 to FChannels[I].Shows.Count - 1 do
    begin
      it := TMSFNCPlanner1.AddOrUpdateItem(FChannels[I].FShows[J].StartTime, FChannels[I].FShows[J].EndTime, FChannels[I].FShows[J].Title, FChannels[I].FShows[J].Kind);
      it.Resource := I;
      it.Hint := it.Title + ' [' + TimeToStr(Frac(FChannels[I].FShows[J].StartTime)) + ' - ' + TimeToStr(Frac(FChannels[I].FShows[J].EndTime)) + ']';
      if (dt >= it.StartTime) and (dt <= it.EndTime) then
      begin
        it.Color := gcYellowgreen;
        it.FontColor := gcWhite;
      end;
    end;
  end;
  TMSFNCPlanner1.EndUpdate;
  TMSFNCComboBox1.ItemIndex := 0;
  TMSFNCPlanner1.Visible := True;
end;

end.

