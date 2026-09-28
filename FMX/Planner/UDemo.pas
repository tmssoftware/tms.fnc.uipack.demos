unit UDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TMSFNCGraphics,
  FMX.TMSFNCPlanner, FMX.TMSFNCPlannerData, Math, FMX.StdCtrls, FMX.ListBox,
  FMX.TMSFNCCustomControl, FMX.TMSFNCPlannerBase, DateUtils,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCBitmapContainer, FMX.Objects,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphicsTypes,
  FMX.Controls.Presentation;

type
  TForm130 = class(TForm)
    TMSFNCPlanner1: TTMSFNCPlanner;
    Panel1: TRectangle;
    Label4: TLabel;
    ComboBox2: TComboBox;
    ComboBox1: TComboBox;
    Label2: TLabel;
    CheckBox1: TCheckBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure TMSFNCPlanner1ItemAnchorClick(Sender: TObject;
      AItem: TTMSFNCPlannerItem; AAnchor: string);
    procedure TMSFNCPlanner1BeforeDrawPosition(Sender: TObject;
      AGraphics: TTMSFNCGraphics; ARect: TRectF; APosition: Integer;
      AKind: TTMSFNCPlannerCacheItemKind; var AAllow, ADefaultDraw: Boolean);
    procedure TMSFNCPlanner1BeforeDrawTimeText(Sender: TObject;
      AGraphics: TTMSFNCGraphics; ARect: TRectF; AValue: Double; ARow: Integer;
      ASubUnit: Boolean; AKind: TTMSFNCPlannerCacheItemKind; AText: string;
      var AAllow: Boolean);
    procedure TMSFNCPlanner1BeforeDrawPositionText(Sender: TObject;
      AGraphics: TTMSFNCGraphics; ARect: TRectF; APosition: Integer;
      AKind: TTMSFNCPlannerCacheItemKind; AText: string; var AAllow: Boolean);
    procedure TMSFNCPlanner1BeforeDrawGroupText(Sender: TObject;
      AGraphics: TTMSFNCGraphics; ARect: TRectF; AGroup, AStartPosition,
      AEndPosition: Integer; AKind: TTMSFNCPlannerCacheItemKind; AText: string;
      var AAllow: Boolean);
    procedure ComboBox2Change(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure RadioButton2Change(Sender: TObject);
    procedure RadioButton3Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ChangeMode;
    procedure ChangeDisplayUnit;
    procedure AddItems;
    procedure DrawCustomPositionText(AGraphics: TTMSFNCGraphics; APosition: Integer);
  end;

var
  Form130: TForm130;

implementation

{$R *.fmx}

procedure TForm130.FormCreate(Sender: TObject);
var
  dt: TDateTime;
  I: Integer;
begin
  dt := Now;
  TMSFNCPlanner1.Stroke.Kind := gskNone;
  TMSFNCPlanner1.BeginUpdate;
  TMSFNCPlanner1.BitmapContainer := TMSFNCBitmapContainer1;

  TMSFNCPlanner1.Interaction.KeyboardInsertMode := pkimSelection;
  TMSFNCPlanner1.Interaction.MouseInsertMode := pmimDialogAfterSelection;
  TMSFNCPlanner1.Interaction.UpdateMode := pumDialog;
  TMSFNCPlanner1.ModeSettings.StartTime := dt;

  Fill.Color := MakeGraphicsColor(237, 243, 248);
  Fill.Kind := TBrushKind.Solid;
  TMSFNCPlanner1.Fill.Color := Fill.Color;
  Panel1.Fill.Assign(Fill);
  Panel1.Stroke.Kind := TBrushKind.None;

  TMSFNCPlanner1.TimeLineAppearance.LeftStroke.Color := Fill.Color;
  TMSFNCPlanner1.TimeLineAppearance.LeftFont.Color := MakeGraphicsColor(115, 115, 115);
  TMSFNCPlanner1.TimeLineAppearance.LeftFont.Style := [TFontStyle.fsBold];
  TMSFNCPlanner1.TimeLineAppearance.LeftFont.Size := 18;
  TMSFNCPlanner1.TimeLineAppearance.LeftSubUnitFontSize := 12;

  TMSFNCPlanner1.Positions.Count := 7;
  TMSFNCPlanner1.Positions.Format := 'dddd d';
  TMSFNCPlanner1.PositionsAppearance.TopStroke.Color := Fill.Color;
  TMSFNCPlanner1.PositionsAppearance.TopFont.Color := MakeGraphicsColor(115, 115, 115);
  TMSFNCPlanner1.PositionsAppearance.TopFont.Size := 16;
  TMSFNCPlanner1.PositionsAppearance.TopFont.Color := MakeGraphicsColor(115, 115, 115);

  TMSFNCPlanner1.GroupsAppearance.TopStroke.Color := Fill.Color;
  TMSFNCPlanner1.GroupsAppearance.TopFont.Color := MakeGraphicsColor(115, 115, 115);
  TMSFNCPlanner1.GroupsAppearance.TopFont.Size := 16;
  TMSFNCPlanner1.GroupsAppearance.TopFont.Color := MakeGraphicsColor(115, 115, 115);

  TMSFNCPlanner1.GridCellAppearance.Fill.Kind := gfkSolid;
  TMSFNCPlanner1.Margins.Left := 10;
  TMSFNCPlanner1.Margins.Bottom := 10;
  TMSFNCPlanner1.StretchScrollBars := False;

  Label1.Width := 1000;
  Label1.AutoSize := True;
  Label1.Font.Size := 24;
  Label1.FontColor := MakeGraphicsColor(115, 115, 115);
  Label1.StyledSettings := [];
  Label1.Text := FormatDateTime('d mmmm, yyyy', dt) + ' (week ' + inttostr(WeekOf(dt))+')';
  Label1.Align := TAlignLayout.Right;
  Label1.Margins.Bottom := 10;
  Label1.Margins.Right := 10;
  Label1.Margins.Top := 10;
  TMSFNCPlanner1.ItemsAppearance.MoveAreaColor := gcDarkgray;
  TMSFNCPlanner1.ItemsAppearance.SizeAreaColor := gcDarkgray;

  for I := 0 to TMSFNCPlanner1.Resources.Count - 1 do
  begin
    TMSFNCPlanner1.Resources[I].Name := TMSFNCPlanner1.Resources[I].Text;
    TMSFNCPlanner1.Resources[I].Text := '<img src="'+TMSFNCPlanner1.Resources[I].Text+'" height="45"/>';
  end;

  ChangeMode;
  TMSFNCPlanner1.EndUpdate;
  TMSFNCPlanner1.TimeLine.ViewStart := Int(Now) + EncodeTime(5, 0, 0, 0);
  AddItems;
end;

procedure TForm130.AddItems;
var
  dt: TDateTime;
  it: TTMSFNCPlannerItem;
  c: Double;
  I: Integer;
begin
  TMSFNCPlanner1.BeginUpdate;

  dt := Now;
  TMSFNCPlanner1.Items.Clear;
  c := 0;
  if (TMSFNCPlanner1.Mode = pmMultiDay) then
    c := 2;

  it := TMSFNCPlanner1.AddOrUpdateItem(Int(dt) + EncodeTime(6, 30, 0, 0), Int(dt) + EncodeTime(13, 0, 0, 0), 'Meeting with John',
    '<u>Necessities</u><br><ul><li>Notebook<li>Digital lineout<li>Model artwork</ul>');
  it.Color := MakeGraphicsColor(255, 246, 210);
  it.TitleColor := MakeGraphicsColor(255, 211, 39);
  it.FontColor := MakeGraphicsColor(190, 165, 59);

  it := TMSFNCPlanner1.AddOrUpdateItem(Int(dt) + c + EncodeTime(13, 30, 0, 0), Int(dt) + c + EncodeTime(16, 30, 0, 0), 'Presentation', 'The new A3');
  it.Resource := 2;
  it.Color := MakeGraphicsColor(210, 239, 255);
  it.TitleColor := MakeGraphicsColor(61, 185, 249);
  it.FontColor := MakeGraphicsColor(17, 111, 159);

  it := TMSFNCPlanner1.AddOrUpdateItem(Int(dt) + c + 1 + EncodeTime(20, 30, 0, 0), Int(dt) + c + 1 + EncodeTime(21, 30, 0, 0), 'Audi Conditions', '<ul><li>Update iOS application<li>Change Audi packs<li>Change online terms</ul>');
  it.Resource := 2;
  it.Color := MakeGraphicsColor(210, 239, 255);
  it.TitleColor := MakeGraphicsColor(61, 185, 249);
  it.FontColor := MakeGraphicsColor(17, 111, 159);

  it := TMSFNCPlanner1.AddOrUpdateItem(Int(dt) + c + 1 + EncodeTime(9, 30, 0, 0), Int(dt) + c + 1 + EncodeTime(12, 45, 0, 0), 'Audi - Mercedes fusion', 'Meeting with Bruno Fierens for approval<br><a href="http://www.tmssoftware.com">http://www.tmssoftware.com</a>');
  it.Resource := 2;
  it.Color := MakeGraphicsColor(210, 239, 255);
  it.TitleColor := MakeGraphicsColor(61, 185, 249);
  it.FontColor := MakeGraphicsColor(17, 111, 159);

  it := TMSFNCPlanner1.AddOrUpdateItem(Int(dt) + 1 + C + EncodeTime(5, 45, 0, 0), Int(dt) + 1 + c + EncodeTime(7, 35, 0, 0), 'Test drive',
    'Test drive of the new BMW i8');
  it.Color := MakeGraphicsColor(255, 246, 210);
  it.TitleColor := MakeGraphicsColor(255, 211, 39);
  it.FontColor := MakeGraphicsColor(190, 165, 59);

  it := TMSFNCPlanner1.AddOrUpdateItem(Int(dt) + 1 + C + EncodeTime(9, 30, 0, 0), Int(dt) + 1 + c + EncodeTime(11, 35, 0, 0), 'Reminder',
    'Trip to Brussels to present the future of BMW');
  it.Color := MakeGraphicsColor(255, 246, 210);
  it.TitleColor := MakeGraphicsColor(255, 211, 39);
  it.FontColor := MakeGraphicsColor(190, 165, 59);

  c := 0;
  if TMSFNCPlanner1.Mode = pmMultiResDay then
    c := -5;

  it := TMSFNCPlanner1.AddOrUpdateItem(Int(dt) + c + 6 + EncodeTime(12, 35, 0, 0), Int(dt) + c + 6 + EncodeTime(16, 50, 0, 0), 'Exposition', 'Mercedes exposition on the AMG GT Coupé');
  it.Resource := 1;
  it.Color := MakeGraphicsColor(222, 255, 210);
  it.TitleColor := MakeGraphicsColor(122, 223, 86);
  it.FontColor := MakeGraphicsColor(114, 172, 93);

  it := TMSFNCPlanner1.AddOrUpdateItem(Int(dt) + c + 5 + EncodeTime(8, 35, 0, 0), Int(dt) + c + 5 + EncodeTime(10, 50, 0, 0), 'Meeting', 'Meeting with sponsors for 2015');
  it.Resource := 1;
  it.Color := MakeGraphicsColor(222, 255, 210);
  it.TitleColor := MakeGraphicsColor(122, 223, 86);
  it.FontColor := MakeGraphicsColor(114, 172, 93);

  for I := 0 to TMSFNCPlanner1.Items.Count - 1 do
  begin
    it := TMSFNCPlanner1.Items[I];
    if (TMSFNCPlanner1.Mode = pmMonth) or (TMSFNCPlanner1.Mode = pmMultiMonth) then
    begin
      Randomize;
      if TMSFNCPlanner1.Mode = pmMultiMonth then
        c := Random(100)
      else
        c := RandomRange(-20, 20);

      it.StartTime := it.StartTime + c;
      it.EndTime := it.EndTime + c + 6;
    end;

    {$IFNDEF IOS}
    it.Hint := it.Title;
    {$ENDIF}
    it.TitleFontColor := it.FontColor;
    it.ActiveColor := it.TitleColor;
    it.ActiveTitleFontColor := it.TitleFontColor;
    it.ActiveFontColor := it.FontColor;
  end;

  TMSFNCPlanner1.EndUpdate;
end;

procedure TForm130.ChangeDisplayUnit;
begin
  if (TMSFNCPlanner1.Mode <> pmMonth) and (TMSFNCPlanner1.Mode <> pmMultiMonth) then
  begin
    TMSFNCPlanner1.BeginUpdate;
    case ComboBox2.ItemIndex of
      0: TMSFNCPlanner1.TimeLine.DisplayUnit := 5;
      1: TMSFNCPlanner1.TimeLine.DisplayUnit := 10;
      2: TMSFNCPlanner1.TimeLine.DisplayUnit := 12;
      3: TMSFNCPlanner1.TimeLine.DisplayUnit := 15;
      4: TMSFNCPlanner1.TimeLine.DisplayUnit := 20;
      5: TMSFNCPlanner1.TimeLine.DisplayUnit := 30;
      6: TMSFNCPlanner1.TimeLine.DisplayUnit := 60;
    end;
    TMSFNCPlanner1.TimeLine.DisplayEnd := 10000;
    TMSFNCPlanner1.EndUpdate;
  end;
end;

procedure TForm130.ChangeMode;
begin
  TMSFNCPlanner1.BeginUpdate;
  if CheckBox1.IsChecked then
  begin
    if RadioButton1.IsChecked then
    begin
      TMSFNCPlanner1.Mode := pmMultiResDay;
      TMSFNCPlanner1.Positions.Count := 3;
      TMSFNCPlanner1.Positions.Format := 'dddd d';
    end
    else if RadioButton2.IsChecked then
    begin
      TMSFNCPlanner1.Mode := pmMultiResDay;
      TMSFNCPlanner1.Positions.Count := 6;
      TMSFNCPlanner1.Positions.Format := 'dddd d';
    end
    else if RadioButton3.IsChecked then
    begin
      TMSFNCPlanner1.Mode := pmMonth;
      TMSFNCPlanner1.Positions.Count := 3;
      TMSFNCPlanner1.Positions.Format := 'mmmm';
    end;
  end
  else
  begin
    if RadioButton1.IsChecked then
    begin
      TMSFNCPlanner1.Mode := pmMultiDay;
      TMSFNCPlanner1.Positions.Count := 1;
      TMSFNCPlanner1.Positions.Format := 'dddd d';
    end
    else if RadioButton2.IsChecked then
    begin
      TMSFNCPlanner1.Mode := pmMultiDay;
      TMSFNCPlanner1.Positions.Count := 7;
      TMSFNCPlanner1.Positions.Format := 'dddd d';
    end
    else if RadioButton3.IsChecked then
    begin
      TMSFNCPlanner1.Mode := pmMultiMonth;
      TMSFNCPlanner1.Positions.Count := 5;
      TMSFNCPlanner1.Positions.Format := 'mmmm';
    end;
  end;

  TMSFNCPlanner1.EndUpdate;
  if not RadioButton3.IsChecked then
    TMSFNCPlanner1.TimeLine.ViewStart := Int(Now) + EncodeTime(5, 0, 0, 0);

  ChangeDisplayUnit;
  AddItems;
end;

procedure TForm130.CheckBox1Change(Sender: TObject);
begin
  ChangeMode;
end;

procedure TForm130.ComboBox1Change(Sender: TObject);
begin
  ChangeDisplayUnit;
end;

procedure TForm130.ComboBox2Change(Sender: TObject);
begin
  TMSFNCPlanner1.OrientationMode := TTMSFNCPlannerOrientationMode(ComboBox1.ItemIndex);
end;

procedure TForm130.DrawCustomPositionText(AGraphics: TTMSFNCGraphics; APosition: Integer);
begin
  if Int(Now) = TMSFNCPlanner1.PositionToDateTime(APosition) then
  begin
    AGraphics.Fill.Color := MakeGraphicsColor(50, 142, 238);
    AGraphics.Font.Style := [TFontStyle.fsBold];
  end
  else if DayOfTheWeek(TMSFNCPlanner1.PositionToDateTime(APosition)) in [6, 7] then
    AGraphics.Fill.Color := MakeGraphicsColor(203, 64, 64);
end;

procedure TForm130.RadioButton1Change(Sender: TObject);
begin
  ChangeMode;
end;

procedure TForm130.RadioButton2Change(Sender: TObject);
begin
  ChangeMode;
end;

procedure TForm130.RadioButton3Change(Sender: TObject);
begin
  ChangeMode;
end;

procedure TForm130.TMSFNCPlanner1BeforeDrawGroupText(Sender: TObject;
  AGraphics: TTMSFNCGraphics; ARect: TRectF; AGroup, AStartPosition,
  AEndPosition: Integer; AKind: TTMSFNCPlannerCacheItemKind; AText: string;
  var AAllow: Boolean);
begin
  if TMSFNCPlanner1.Mode = pmMultiResDay then
    DrawCustomPositionText(AGraphics, AStartPosition);
end;

procedure TForm130.TMSFNCPlanner1BeforeDrawPosition(Sender: TObject;
  AGraphics: TTMSFNCGraphics; ARect: TRectF; APosition: Integer;
  AKind: TTMSFNCPlannerCacheItemKind; var AAllow, ADefaultDraw: Boolean);
begin
  if TMSFNCPlanner1.Mode = pmMultiResDay then
  begin
    AGraphics.Stroke.Kind := gskSolid;
    AGraphics.Stroke.Color := gcDarkgray;
    ADefaultDraw := False;
    AGraphics.DrawLine(PointF(ARect.Left, ARect.Top + 1), PointF(ARect.Right, ARect.Top + 1));
  end;
end;

procedure TForm130.TMSFNCPlanner1BeforeDrawPositionText(Sender: TObject;
  AGraphics: TTMSFNCGraphics; ARect: TRectF; APosition: Integer;
  AKind: TTMSFNCPlannerCacheItemKind; AText: string; var AAllow: Boolean);
begin
  if (TMSFNCPlanner1.Mode = pmMultiDay) or (TMSFNCPlanner1.Mode = pmDay) then
    DrawCustomPositionText(AGraphics, APosition);
end;

procedure TForm130.TMSFNCPlanner1BeforeDrawTimeText(Sender: TObject;
  AGraphics: TTMSFNCGraphics; ARect: TRectF; AValue: Double; ARow: Integer;
  ASubUnit: Boolean; AKind: TTMSFNCPlannerCacheItemKind; AText: string;
  var AAllow: Boolean);
begin
  if ASubUnit then
    AGraphics.Font.Style := [];

  if (TMSFNCPlanner1.Mode = pmMonth) then
  begin
    if Int(Now) = AValue then
    begin
      AGraphics.Fill.Color := MakeGraphicsColor(50, 142, 238);
      AGraphics.Font.Style := [TFontStyle.fsBold];
    end
    else if DayOfTheWeek(AValue) in [6, 7] then
      AGraphics.Fill.Color := MakeGraphicsColor(203, 64, 64);
  end;
end;

procedure TForm130.TMSFNCPlanner1ItemAnchorClick(Sender: TObject;
  AItem: TTMSFNCPlannerItem; AAnchor: string);
begin
  ShowMessage(AAnchor);
end;


end.
