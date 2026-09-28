unit UDemo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Types,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes,
  VCL.TMSFNCCustomPicker, VCL.TMSFNCDatePicker, VCL.TMSFNCCustomControl,
  VCL.TMSFNCCalendar, VCL.TMSFNCCustomComponent, VCL.TMSFNCBitmapContainer,
  VCL.TMSFNCPanel;

type
  TForm130 = class(TForm)
    TMSFNCCalendar1: TTMSFNCCalendar;
    TMSFNCCalendar2: TTMSFNCCalendar;
    TMSFNCDatePicker1: TTMSFNCDatePicker;
    TMSFNCDatePicker2: TTMSFNCDatePicker;
    Panel1: TPanel;
    Panel2: TPanel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    ListBox1: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    Label3: TLabel;
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TMSFNCCalendar1CustomNavigation(Sender: TObject; ADate, AFocusedDate: TDate; ADirection: Boolean);
    procedure TMSFNCDatePicker1CustomNavigation(Sender: TObject; ADate, AFocusedDate: TDate; ADirection: Boolean);
    procedure TMSFNCCalendar2CustomArrowDraw(Sender: TObject; AGraphics: TTMSFNCGraphics; ARect: TRectF; ADirection: Boolean);
    procedure TMSFNCCalendar1SelectMultiDate(Sender: TObject; AStartDate, AEndDate: TDate);
    procedure TMSFNCCalendar1SelectDate(Sender: TObject; ADate: TDate);
    procedure TMSFNCDatePicker1DateSelected(Sender: TObject; ADate: TDate);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure RadioButton4Click(Sender: TObject);
    procedure RadioButton5Click(Sender: TObject);
    procedure RadioButton6Click(Sender: TObject);
    procedure RadioButton7Click(Sender: TObject);
    procedure RadioButton8Click(Sender: TObject);
    procedure TMSFNCDatePicker1YearChanged(Sender: TObject; AYear: Integer);
    procedure TMSFNCDatePicker1MonthChanged(Sender: TObject; AMonth: Integer);
    procedure TMSFNCCalendar1YearChanged(Sender: TObject; AYear: Integer);
    procedure TMSFNCCalendar1MonthChanged(Sender: TObject; AMonth: Integer);
    procedure TMSFNCDatePicker2CustomArrowDraw(Sender: TObject; AGraphics: TTMSFNCGraphics; ARect: TRectF; ADirection: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form130: TForm130;

implementation

{$R *.dfm}

procedure TForm130.CheckBox1Click(Sender: TObject);
begin
  TMSFNCCalendar1.Interaction.SwipeOnHeader := CheckBox1.Checked;
  TMSFNCDatePicker1.Interaction.SwipeOnHeader := CheckBox1.Checked;
end;

procedure TForm130.CheckBox2Click(Sender: TObject);
begin
  TMSFNCCalendar1.Interaction.MultiSelect := CheckBox2.Checked;
end;

procedure TForm130.CheckBox3Click(Sender: TObject);
begin
  TMSFNCDatePicker2.Editable := CheckBox3.Checked;
end;

procedure TForm130.CheckBox4Click(Sender: TObject);
begin
  if CheckBox4.Checked then
  begin
    TMSFNCCalendar2.WeekNumberAppearance.Visible := True;
    TMSFNCCalendar2.DateAppearance.ShowDaysBefore := True;
    TMSFNCCalendar2.DateAppearance.ShowDaysAfter := True;
    TMSFNCCalendar2.Header.Fill.Color := gcSeagreen;
    TMSFNCCalendar2.Header.Stroke.Color := gcDarkgreen;
    TMSFNCCalendar2.Header.Font.Color := gcWhite;
    TMSFNCCalendar2.Header.Arrow.Color := gcDarkgreen;
    TMSFNCCalendar2.Footer.Fill.Color := gcSeagreen;
    TMSFNCCalendar2.Footer.Stroke.Color := gcDarkgreen;
    TMSFNCCalendar2.Footer.Font.Color := gcWhite;
    TMSFNCCalendar2.Fill.Color := gcMoneyGreen;
    TMSFNCCalendar2.Stroke.Color := gcDarkgreen;
    TMSFNCCalendar2.LineAppearance.Stroke.Color := gcDarkgreen;
    TMSFNCCalendar2.DateAppearance.SelectedFill.Color := gcLimegreen;
    TMSFNCCalendar2.DateAppearance.SelectedStroke.Color := gcLimegreen;

    TMSFNCDatePicker2.WeekNumberAppearance.Visible := True;
    TMSFNCDatePicker2.DateAppearance.ShowDaysBefore := True;
    TMSFNCDatePicker2.DateAppearance.ShowDaysAfter := True;
    TMSFNCDatePicker2.Header.Fill.Color := gcSeagreen;
    TMSFNCDatePicker2.Header.Stroke.Color := gcDarkgreen;
    TMSFNCDatePicker2.Header.Font.Color := gcWhite;
    TMSFNCDatePicker2.Header.Arrow.Color := gcDarkgreen;
    TMSFNCDatePicker2.Footer.Fill.Color := gcSeagreen;
    TMSFNCDatePicker2.Footer.Stroke.Color := gcDarkgreen;
    TMSFNCDatePicker2.Footer.Font.Color := gcWhite;
    TMSFNCDatePicker2.CalendarFill.Color := gcMoneyGreen;
    TMSFNCDatePicker2.CalendarStroke.Color := gcDarkgreen;
    TMSFNCDatePicker2.LineAppearance.Stroke.Color := gcDarkgreen;
    TMSFNCDatePicker2.DateAppearance.SelectedFill.Color := gcLimegreen;
    TMSFNCDatePicker2.DateAppearance.SelectedStroke.Color := gcLimegreen;
  end
  else
  begin
    TMSFNCCalendar2.WeekNumberAppearance.Visible := False;
    TMSFNCCalendar2.DateAppearance.ShowDaysBefore := False;
    TMSFNCCalendar2.DateAppearance.ShowDaysAfter := False;
    TMSFNCCalendar2.Header.Fill.Color := MakeGraphicsColor(228, 228, 228);
    TMSFNCCalendar2.Header.Stroke.Color := gcSilver;
    TMSFNCCalendar2.Header.Font.Color := gcBlack;
    TMSFNCCalendar2.Header.Arrow.Color := gcDimgrey;
    TMSFNCCalendar2.Footer.Fill.Color := MakeGraphicsColor(228, 228, 228);
    TMSFNCCalendar2.Footer.Stroke.Color := gcSilver;
    TMSFNCCalendar2.Footer.Font.Color := gcBlack;
    TMSFNCCalendar2.Fill.Color := gcWhite;
    TMSFNCCalendar2.Stroke.Color := gcSilver;
    TMSFNCCalendar2.LineAppearance.Stroke.Color := gcSilver;
    TMSFNCCalendar2.DateAppearance.SelectedFill.Color := gcDodgerblue;
    TMSFNCCalendar2.DateAppearance.SelectedStroke.Color := gcDodgerblue;

    TMSFNCDatePicker2.WeekNumberAppearance.Visible := False;
    TMSFNCDatePicker2.DateAppearance.ShowDaysBefore := False;
    TMSFNCDatePicker2.DateAppearance.ShowDaysAfter := False;
    TMSFNCDatePicker2.Header.Fill.Color := MakeGraphicsColor(228, 228, 228);
    TMSFNCDatePicker2.Header.Stroke.Color := gcSilver;
    TMSFNCDatePicker2.Header.Font.Color := gcBlack;
    TMSFNCDatePicker2.Header.Arrow.Color := gcDimgrey;
    TMSFNCDatePicker2.Footer.Fill.Color := MakeGraphicsColor(228, 228, 228);
    TMSFNCDatePicker2.Footer.Stroke.Color := gcSilver;
    TMSFNCDatePicker2.Footer.Font.Color := gcBlack;
    TMSFNCDatePicker2.CalendarFill.Color := gcWhite;
    TMSFNCDatePicker2.CalendarStroke.Color := gcSilver;
    TMSFNCDatePicker2.LineAppearance.Stroke.Color := gcSilver;
    TMSFNCDatePicker2.DateAppearance.SelectedFill.Color := gcDodgerblue;
    TMSFNCDatePicker2.DateAppearance.SelectedStroke.Color := gcDodgerblue;
  end;
end;

procedure TForm130.FormCreate(Sender: TObject);
var
  y, m, d, I: Integer;
begin
  RadioButton1.Checked := True;
  RadioButton6.Checked := True;

  y := TMSFNCCalendar1.CurrentYear;
  m := TMSFNCCalendar1.CurrentMonth;
  d := TMSFNCCalendar1.CurrentDay;
  TMSFNCCalendar1.Date := EncodeDate(y, m, d);
  TMSFNCCalendar2.Date := EncodeDate(y, m, d);
  TMSFNCDatePicker1.SelectedDate := TMSFNCCalendar1.Date;
  TMSFNCDatePicker2.SelectedDate := TMSFNCCalendar2.Date;

  ListBox1.Items.Add(DateToStr(TMSFNCCalendar1.SelectedDate));

  TMSFNCCalendar2.ShowHint := True;
  TMSFNCDatePicker2.ShowHint := True;
  TMSFNCDatePicker2.BadgeSize := 10;

  for I := 0 to 4 do
  begin
    TMSFNCCalendar2.Events.Add;
    TMSFNCDatePicker2.Events.Add;
  end;

  TMSFNCCalendar2.Events.Items[0].Date := EncodeDate(y, m, 3);
  TMSFNCCalendar2.Events.Items[0].BadgeValue := 1;
  TMSFNCCalendar2.Events.Items[0].Hint := 'Linda''s birthday';
  TMSFNCCalendar2.Events.Items[1].Date := EncodeDate(y, m, 14);
  TMSFNCCalendar2.Events.Items[1].BadgeValue := 2;
  TMSFNCCalendar2.Events.Items[1].Hint := 'Tom''s birthday' + sLineBreak + 'Jerry''s birthday';
  TMSFNCCalendar2.Events.Items[2].Date := EncodeDate(y, m, 26);
  TMSFNCCalendar2.Events.Items[2].BadgeValue := 1;
  TMSFNCCalendar2.Events.Items[2].Hint := 'Wendy''s birthday';
  TMSFNCCalendar2.Events.Items[3].Date := EncodeDate(y, m, 12);
  TMSFNCCalendar2.Events.Items[3].BadgeValue := 1;
  TMSFNCCalendar2.Events.Items[3].Hint := 'Meeting with customer';
  TMSFNCCalendar2.Events.Items[3].BadgeColor := gcYellow;
  TMSFNCCalendar2.Events.Items[3].BadgeFontColor := gcBlack;
  TMSFNCCalendar2.Events.Items[4].Date := EncodeDate(y, m, 25);
  TMSFNCCalendar2.Events.Items[4].BadgeValue := 1;
  TMSFNCCalendar2.Events.Items[4].Hint := 'Meeting with staff';
  TMSFNCCalendar2.Events.Items[4].BadgeColor := gcYellow;
  TMSFNCCalendar2.Events.Items[4].BadgeFontColor := gcBlack;
  TMSFNCDatePicker2.Events.Items[0].Date := EncodeDate(y, m, 3);
  TMSFNCDatePicker2.Events.Items[0].BadgeValue := 1;
  TMSFNCDatePicker2.Events.Items[0].Hint := 'Linda''s birthday';
  TMSFNCDatePicker2.Events.Items[1].Date := EncodeDate(y, m, 14);
  TMSFNCDatePicker2.Events.Items[1].BadgeValue := 2;
  TMSFNCDatePicker2.Events.Items[1].Hint := 'Tom''s birthday' + sLineBreak + 'Jerry''s birthday';
  TMSFNCDatePicker2.Events.Items[2].Date := EncodeDate(y, m, 26);
  TMSFNCDatePicker2.Events.Items[2].BadgeValue := 1;
  TMSFNCDatePicker2.Events.Items[2].Hint := 'Wendy''s birthday';
  TMSFNCDatePicker2.Events.Items[3].Date := EncodeDate(y, m, 12);
  TMSFNCDatePicker2.Events.Items[3].BadgeValue := 1;
  TMSFNCDatePicker2.Events.Items[3].Hint := 'Meeting with customer';
  TMSFNCDatePicker2.Events.Items[3].BadgeColor := gcYellow;
  TMSFNCDatePicker2.Events.Items[3].BadgeFontColor := gcBlack;
  TMSFNCDatePicker2.Events.Items[4].Date := EncodeDate(y, m, 25);
  TMSFNCDatePicker2.Events.Items[4].BadgeValue := 1;
  TMSFNCDatePicker2.Events.Items[4].Hint := 'Meeting with staff';
  TMSFNCDatePicker2.Events.Items[4].BadgeColor := gcYellow;
  TMSFNCDatePicker2.Events.Items[4].BadgeFontColor := gcBlack;
end;

procedure TForm130.RadioButton1Click(Sender: TObject);
begin
  TMSFNCCalendar2.Header.Arrow.ArrowLeftType := atArrow;
  TMSFNCCalendar2.Header.Arrow.ArrowRightType := atArrow;
  TMSFNCDatePicker2.Header.Arrow.ArrowLeftType := atArrow;
  TMSFNCDatePicker2.Header.Arrow.ArrowRightType := atArrow;
end;

procedure TForm130.RadioButton2Click(Sender: TObject);
begin
  TMSFNCCalendar2.Header.Arrow.ArrowLeftType := atTriangle;
  TMSFNCCalendar2.Header.Arrow.ArrowRightType := atTriangle;
  TMSFNCDatePicker2.Header.Arrow.ArrowLeftType := atTriangle;
  TMSFNCDatePicker2.Header.Arrow.ArrowRightType := atTriangle;
end;

procedure TForm130.RadioButton3Click(Sender: TObject);
begin
  TMSFNCCalendar2.Header.Arrow.ArrowLeftType := atBitmap;
  TMSFNCCalendar2.Header.Arrow.ArrowRightType := atBitmap;
  TMSFNCDatePicker2.Header.Arrow.ArrowLeftType := atBitmap;
  TMSFNCDatePicker2.Header.Arrow.ArrowRightType := atBitmap;
end;

procedure TForm130.RadioButton4Click(Sender: TObject);
begin
  TMSFNCCalendar2.Header.Arrow.ArrowLeftType := atCustom;
  TMSFNCCalendar2.Header.Arrow.ArrowRightType := atCustom;
  TMSFNCDatePicker2.Header.Arrow.ArrowLeftType := atCustom;
  TMSFNCDatePicker2.Header.Arrow.ArrowRightType := atCustom;
end;

procedure TForm130.RadioButton5Click(Sender: TObject);
begin
  TMSFNCCalendar1.Interaction.NavigationMode := nmFocusedDate;
  TMSFNCDatePicker1.Interaction.NavigationMode := nmFocusedDate;
end;

procedure TForm130.RadioButton6Click(Sender: TObject);
begin
  TMSFNCCalendar1.Interaction.NavigationMode := nmMonth;
  TMSFNCDatePicker1.Interaction.NavigationMode := nmMonth;
end;

procedure TForm130.RadioButton7Click(Sender: TObject);
begin
  TMSFNCCalendar1.Interaction.NavigationMode := nmYear;
  TMSFNCDatePicker1.Interaction.NavigationMode := nmYear;
end;

procedure TForm130.RadioButton8Click(Sender: TObject);
begin
  TMSFNCCalendar1.Interaction.NavigationMode := nmCustom;
  TMSFNCDatePicker1.Interaction.NavigationMode := nmCustom;
end;

procedure TForm130.TMSFNCCalendar1CustomNavigation(Sender: TObject; ADate,
  AFocusedDate: TDate; ADirection: Boolean);
begin
  if ADirection then
    TMSFNCCalendar1.Year := TMSFNCCalendar1.Year - 10
  else
    TMSFNCCalendar1.Year := TMSFNCCalendar1.Year + 10;
end;

procedure TForm130.TMSFNCCalendar1MonthChanged(Sender: TObject;
  AMonth: Integer);
begin
  TMSFNCDatePicker1.Month := TMSFNCCalendar1.Month;
end;

procedure TForm130.TMSFNCCalendar1SelectDate(Sender: TObject; ADate: TDate);
var
  I, c: Integer;
begin
  ListBox1.Clear;
  c := TMSFNCCalendar1.SelectedDates.Count - 1;
  for I := 0 to c do
    ListBox1.Items.Add(DateToStr(TMSFNCCalendar1.SelectedDates.Items[I].Date));

  TMSFNCDatePicker1.SelectedDate := TMSFNCCalendar1.SelectedDates.Items[c].Date;
end;

procedure TForm130.TMSFNCCalendar1SelectMultiDate(Sender: TObject; AStartDate,
  AEndDate: TDate);
var
  I: Integer;
begin
  ListBox1.Clear;
  for I := 0 to TMSFNCCalendar1.SelectedDates.Count - 1 do
    ListBox1.Items.Add(DateToStr(TMSFNCCalendar1.SelectedDates.Items[I].Date));
end;

procedure TForm130.TMSFNCCalendar1YearChanged(Sender: TObject; AYear: Integer);
begin
  TMSFNCDatePicker1.Year := TMSFNCCalendar1.Year;
end;

procedure TForm130.TMSFNCCalendar2CustomArrowDraw(Sender: TObject;
  AGraphics: TTMSFNCGraphics; ARect: TRectF; ADirection: Boolean);
var
  pr, pl: TPointF;
  h, r, l: Single;
begin
  h := (ARect.Bottom - ARect.Top);
  pl := PointF(ARect.Left, ARect.Top + h / 2);
  pr := PointF(ARect.Right, ARect.Top + h / 2);
  r := ARect.Left + (ARect.Right - ARect.Left) / 2;
  l := ARect.Left + (ARect.Right - ARect.Left) / 2;
  AGraphics.Stroke.Width := 2;

  if ADirection then
  begin
    AGraphics.DrawLine(PointF(r, ARect.Top), pl);
    AGraphics.DrawLine(pl, PointF(r, ARect.Bottom));
    AGraphics.DrawLine(pl, pr);
  end
  else
  begin
    AGraphics.DrawLine(PointF(l, ARect.Top), pr);
    AGraphics.DrawLine(PointF(l, ARect.Bottom), pr);
    AGraphics.DrawLine(pr, pl);
  end;
end;

procedure TForm130.TMSFNCDatePicker1CustomNavigation(Sender: TObject; ADate,
  AFocusedDate: TDate; ADirection: Boolean);
begin
  if ADirection then
    TMSFNCDatePicker1.Year := TMSFNCDatePicker1.Year - 10
  else
    TMSFNCDatePicker1.Year := TMSFNCDatePicker1.Year + 10;
end;
procedure TForm130.TMSFNCDatePicker1DateSelected(Sender: TObject; ADate: TDate);
begin
  ListBox1.Clear;
  ListBox1.Items.Add(DateToStr(TMSFNCDatePicker1.SelectedDate));
  TMSFNCCalendar1.SelectADate(TMSFNCDatePicker1.SelectedDate);
end;

procedure TForm130.TMSFNCDatePicker1MonthChanged(Sender: TObject;
  AMonth: Integer);
begin
  TMSFNCCalendar1.Month := TMSFNCDatePicker1.Month;
end;

procedure TForm130.TMSFNCDatePicker1YearChanged(Sender: TObject;
  AYear: Integer);
begin
  TMSFNCCalendar1.Year := TMSFNCDatePicker1.Year;
end;

procedure TForm130.TMSFNCDatePicker2CustomArrowDraw(Sender: TObject;
  AGraphics: TTMSFNCGraphics; ARect: TRectF; ADirection: Boolean);
var
  pr, pl: TPointF;
  h, r, l: Single;
begin
  h := (ARect.Bottom - ARect.Top);
  pl := PointF(ARect.Left, ARect.Top + h / 2);
  pr := PointF(ARect.Right, ARect.Top + h / 2);
  r := ARect.Left + (ARect.Right - ARect.Left) / 2;
  l := ARect.Left + (ARect.Right - ARect.Left) / 2;
  AGraphics.Stroke.Width := 2;

  if ADirection then
  begin
    AGraphics.DrawLine(PointF(r, ARect.Top), pl);
    AGraphics.DrawLine(pl, PointF(r, ARect.Bottom));
    AGraphics.DrawLine(pl, pr);
  end
  else
  begin
    AGraphics.DrawLine(PointF(l, ARect.Top), pr);
    AGraphics.DrawLine(PointF(l, ARect.Bottom), pr);
    AGraphics.DrawLine(pr, pl);
  end;
end;

end.
