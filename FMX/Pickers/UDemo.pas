unit UDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.StdCtrls, FMX.Types, FMX.Controls, FMX.Forms, FMX.Controls.Presentation,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCBitmapContainer, FMX.TMSFNCCustomControl,
  FMX.Layouts, FMX.ListBox, FMX.TMSFNCCustomPicker,
  FMX.TMSFNCDatePicker, FMX.TMSFNCCalendar, FMX.TMSFNCStrokeKindPicker,
  FMX.TMSFNCFillKindPicker, FMX.TMSFNCStrokeKindSelector,
  FMX.TMSFNCFillKindSelector, FMX.TMSFNCDigitalTimePicker,
  FMX.TMSFNCAnalogTimePicker, FMX.TMSFNCCustomSelector,
  FMX.TMSFNCDigitalTimeSelector, FMX.TMSFNCAnalogTimeSelector, FMX.TMSFNCPanel, FMX.Edit,
  FMX.TMSFNCColorSelector, FMX.TMSFNCColorPicker, FMX.TMSFNCColorWheel,
  FMX.TMSFNCHTMLText, FMX.TMSFNCFontDialog, FMX.TMSFNCDateTimePicker;

type
  TForm130 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    GroupBox2: TGroupBox;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    GroupBox3: TGroupBox;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    TMSFNCPanel1: TTMSFNCPanel;
    Label15: TLabel;
    TMSFNCDigitalTimeSelector1: TTMSFNCDigitalTimeSelector;
    TMSFNCAnalogTimePicker1: TTMSFNCAnalogTimePicker;
    TMSFNCDigitalTimePicker1: TTMSFNCDigitalTimePicker;
    TMSFNCFillKindSelector1: TTMSFNCFillKindSelector;
    TMSFNCStrokeKindSelector1: TTMSFNCStrokeKindSelector;
    TMSFNCFillKindPicker1: TTMSFNCFillKindPicker;
    TMSFNCStrokeKindPicker1: TTMSFNCStrokeKindPicker;
    Edit1: TEdit;
    TMSFNCAnalogTimeSelector1: TTMSFNCAnalogTimeSelector;
    Panel4: TPanel;
    Label16: TLabel;
    TMSFNCColorWheel1: TTMSFNCColorWheel;
    TMSFNCPanel2: TTMSFNCPanel;
    Label17: TLabel;
    TMSFNCColorPicker1: TTMSFNCColorPicker;
    TMSFNCColorSelector1: TTMSFNCColorSelector;
    Label18: TLabel;
    GroupBox4: TGroupBox;
    RadioButton9: TRadioButton;
    RadioButton10: TRadioButton;
    RadioButton11: TRadioButton;
    Label19: TLabel;
    Label20: TLabel;
    Panel5: TPanel;
    Label21: TLabel;
    TMSFNCFontDialog1: TTMSFNCFontDialog;
    Button1: TButton;
    TMSFNCHTMLText1: TTMSFNCHTMLText;
    Panel6: TPanel;
    Label22: TLabel;
    Label23: TLabel;
    TMSFNCDateTimePicker1: TTMSFNCDateTimePicker;
    CheckBox5: TCheckBox;
    GroupBox5: TGroupBox;
    RadioButton12: TRadioButton;
    RadioButton13: TRadioButton;
    Label24: TLabel;
    procedure RadioButton1Change(Sender: TObject);
    procedure RadioButton2Change(Sender: TObject);
    procedure RadioButton3Change(Sender: TObject);
    procedure RadioButton4Change(Sender: TObject);
    procedure RadioButton5Change(Sender: TObject);
    procedure RadioButton6Change(Sender: TObject);
    procedure RadioButton7Change(Sender: TObject);
    procedure RadioButton8Change(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure CheckBox3Change(Sender: TObject);
    procedure CheckBox4Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure TMSFNCDigitalTimeSelector1TimeSelected(Sender: TObject; ATime: TTime);
    procedure TMSFNCAnalogTimePicker1TimeSelected(Sender: TObject; ATime: TTime);
    procedure TMSFNCDigitalTimePicker1TimeSelected(Sender: TObject; ATime: TTime);
    procedure TMSFNCFillKindSelector1FillKindSelected(Sender: TObject; AFillKind: TTMSFNCGraphicsFillKind);
    procedure TMSFNCFillKindPicker1FillKindSelected(Sender: TObject; AFillKind: TTMSFNCGraphicsFillKind);
    procedure TMSFNCStrokeKindSelector1StrokeKindSelected(Sender: TObject; AStrokeKind: TTMSFNCGraphicsStrokeKind);
    procedure TMSFNCStrokeKindPicker1StrokeKindSelected(Sender: TObject; AStrokeKind: TTMSFNCGraphicsStrokeKind);
    procedure FormCreate(Sender: TObject);
    procedure TMSFNCAnalogTimeSelector1TimeChanged(Sender: TObject; ATime: TTime);
    procedure RadioButton9Change(Sender: TObject);
    procedure RadioButton10Change(Sender: TObject);
    procedure RadioButton11Change(Sender: TObject);
    procedure TMSFNCColorWheel1SelectedColorChanged(Sender: TObject;
      ASelectedColor: TAlphaColor);
    procedure TMSFNCColorSelector1ColorSelected(Sender: TObject;
      AColor: TAlphaColor);
    procedure TMSFNCColorPicker1ColorSelected(Sender: TObject;
      AColor: TAlphaColor);
    procedure Button1Click(Sender: TObject);
    procedure TMSFNCFontDialog1DialogResult(Sender: TObject;
      AModalResult: TModalResult);
    procedure CheckBox5Change(Sender: TObject);
    procedure RadioButton12Change(Sender: TObject);
    procedure RadioButton13Change(Sender: TObject);
    procedure TMSFNCDateTimePicker1DateTimeChanged(Sender: TObject;
      ADateTime: TDateTime);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form130: TForm130;

implementation

{$R *.fmx}

procedure TForm130.Button1Click(Sender: TObject);
begin
  TMSFNCFontDialog1.Execute;
end;

procedure TForm130.CheckBox1Change(Sender: TObject);
begin
  TMSFNCAnalogTimePicker1.Editable := CheckBox1.IsChecked;
  TMSFNCDigitalTimePicker1.Editable := CheckBox1.IsChecked;
end;

procedure TForm130.CheckBox2Change(Sender: TObject);
begin
  TMSFNCAnalogTimeSelector1.Settings.Auto := CheckBox2.IsChecked;
  TMSFNCAnalogTimeSelector1.Appearance.ShowSecondPointer := CheckBox2.IsChecked;
end;

procedure TForm130.CheckBox3Change(Sender: TObject);
begin
  TMSFNCAnalogTimeSelector1.Settings.ReadOnly := CheckBox3.IsChecked;
end;

procedure TForm130.CheckBox4Change(Sender: TObject);
begin
  if CheckBox4.IsChecked then
    TMSFNCAnalogTimeSelector1.Style := wsBlackWhite
  else
  begin
    TMSFNCAnalogTimeSelector1.Style := wsClassic;
    TMSFNCAnalogTimeSelector1.Appearance.InitializeDefault;
    TMSFNCAnalogTimeSelector1.Appearance.ShowSecondPointer := CheckBox2.IsChecked;
  end;
end;

procedure TForm130.Edit1Change(Sender: TObject);
var
  i: Integer;
begin
  if TryStrToInt(Edit1.Text, i) then
    TMSFNCDigitalTimeSelector1.TimeInterval := i;
end;

procedure TForm130.CheckBox5Change(Sender: TObject);
begin
  TMSFNCDateTimePicker1.Editable := CheckBox5.IsChecked;
end;

procedure TForm130.FormCreate(Sender: TObject);
begin
  TMSFNCDigitalTimePicker1.DropDownWidth := 260;

  TMSFNCPanel1.Fill.Color := gcWhite;
  TMSFNCPanel1.Fill.ColorTo := gcGray;
  TMSFNCPanel1.Stroke.Color := gcBlack;

  Label24.Text := FormatDateTime('ddddd tt', TMSFNCDateTimePicker1.SelectedDateTime);
end;

procedure TForm130.RadioButton10Change(Sender: TObject);
begin
  TMSFNCColorSelector1.Mode := csmExtended;
  TMSFNCColorPicker1.Mode := csmExtended;
end;

procedure TForm130.RadioButton11Change(Sender: TObject);
begin
  TMSFNCColorSelector1.Mode := csmExtendedMore;
  TMSFNCColorPicker1.Mode := csmExtendedMore;
end;

procedure TForm130.RadioButton12Change(Sender: TObject);
begin
  TMSFNCDateTimePicker1.TimePickerMode := dtpmAnalog;
end;

procedure TForm130.RadioButton13Change(Sender: TObject);
begin
  TMSFNCDateTimePicker1.TimePickerMode := dtpmDigital;
end;

procedure TForm130.RadioButton1Change(Sender: TObject);
begin
  TMSFNCDigitalTimePicker1.StartTime := StrToTime('00:00:00');
  TMSFNCDigitalTimePicker1.EndTime := StrToTime('23:59:59');
end;

procedure TForm130.RadioButton2Change(Sender: TObject);
begin
  TMSFNCDigitalTimePicker1.StartTime := StrToTime('08:00:00');
  TMSFNCDigitalTimePicker1.EndTime := StrToTime('16:30:00');
end;

procedure TForm130.RadioButton3Change(Sender: TObject);
begin
  TMSFNCAnalogTimePicker1.TimeFormat := 'hh:nn:ss';
  TMSFNCDigitalTimePicker1.TimeFormat := 'hh:nn:ss';
end;

procedure TForm130.RadioButton4Change(Sender: TObject);
begin
  TMSFNCAnalogTimePicker1.TimeFormat := 'hh:nn:ss.zzz';
  TMSFNCDigitalTimePicker1.TimeFormat := 'hh:nn:ss.zzz';
end;

procedure TForm130.RadioButton5Change(Sender: TObject);
begin
  TMSFNCAnalogTimePicker1.TimeFormat := 'hh:nn';
  TMSFNCDigitalTimePicker1.TimeFormat := 'hh:nn';
end;

procedure TForm130.RadioButton6Change(Sender: TObject);
begin
  TMSFNCDigitalTimeSelector1.IntervalUnit := tsuSeconds;
end;

procedure TForm130.RadioButton7Change(Sender: TObject);
begin
  TMSFNCDigitalTimeSelector1.IntervalUnit := tsuMinutes;
end;

procedure TForm130.RadioButton8Change(Sender: TObject);
begin
  TMSFNCDigitalTimeSelector1.IntervalUnit := tsuHours;
end;

procedure TForm130.RadioButton9Change(Sender: TObject);
begin
  TMSFNCColorSelector1.Mode := csmSimple;
  TMSFNCColorPicker1.Mode := csmSimple;
end;

procedure TForm130.TMSFNCAnalogTimePicker1TimeSelected(Sender: TObject;
  ATime: TTime);
begin
  Label15.Text := TimeToStr(ATime);
end;

procedure TForm130.TMSFNCAnalogTimeSelector1TimeChanged(Sender: TObject;
  ATime: TTime);
begin
  Label8.Text := TimeToStr(ATime);
end;

procedure TForm130.TMSFNCColorPicker1ColorSelected(Sender: TObject;
  AColor: TAlphaColor);
begin
  TMSFNCPanel2.Fill.Color := AColor;
end;

procedure TForm130.TMSFNCColorSelector1ColorSelected(Sender: TObject;
  AColor: TAlphaColor);
begin
  TMSFNCPanel2.Fill.Color := AColor;
end;

procedure TForm130.TMSFNCColorWheel1SelectedColorChanged(Sender: TObject;
  ASelectedColor: TAlphaColor);
begin
  TMSFNCPanel2.Fill.Color := ASelectedColor;
end;

procedure TForm130.TMSFNCDateTimePicker1DateTimeChanged(Sender: TObject;
  ADateTime: TDateTime);
begin
  Label24.Text := FormatDateTime('ddddd tt', ADateTime);
end;

procedure TForm130.TMSFNCDigitalTimePicker1TimeSelected(Sender: TObject;
  ATime: TTime);
begin
  Label15.Text := TimeToStr(ATime);
end;

procedure TForm130.TMSFNCDigitalTimeSelector1TimeSelected(Sender: TObject;
  ATime: TTime);
begin
  Label8.Text := TimeToStr(ATime);
end;

procedure TForm130.TMSFNCFillKindPicker1FillKindSelected(Sender: TObject;
  AFillKind: TTMSFNCGraphicsFillKind);
begin
  TMSFNCFillKindSelector1.SelectedFillKind := AFillKind;
  TMSFNCPanel1.Fill.Kind := AFillKind;
end;

procedure TForm130.TMSFNCFillKindSelector1FillKindSelected(Sender: TObject;
  AFillKind: TTMSFNCGraphicsFillKind);
begin
  TMSFNCFillKindPicker1.SelectedFillKind := AFillKind;
  TMSFNCPanel1.Fill.Kind := AFillKind;
end;

procedure TForm130.TMSFNCFontDialog1DialogResult(Sender: TObject;
  AModalResult: TModalResult);
begin
  if AModalResult = mrOK then
  begin
    TMSFNCHTMLText1.Font.Name := TMSFNCFontDialog1.FontName;
    TMSFNCHTMLText1.Font.Size := TMSFNCFontDialog1.FontSize;
    TMSFNCHTMLText1.Font.Color := TMSFNCFontDialog1.FontColor;
    if TMSFNCFontDialog1.BoldSelected then
      TMSFNCHTMLText1.Font.Style := TMSFNCHTMLText1.Font.Style + [TFontStyle.fsBold]
    else
      TMSFNCHTMLText1.Font.Style := TMSFNCHTMLText1.Font.Style - [TFontStyle.fsBold];

    if TMSFNCFontDialog1.ItalicSelected then
      TMSFNCHTMLText1.Font.Style := TMSFNCHTMLText1.Font.Style + [TFontStyle.fsItalic]
    else
      TMSFNCHTMLText1.Font.Style := TMSFNCHTMLText1.Font.Style - [TFontStyle.fsItalic];

    if TMSFNCFontDialog1.UnderlineSelected then
      TMSFNCHTMLText1.Font.Style := TMSFNCHTMLText1.Font.Style + [TFontStyle.fsUnderline]
    else
      TMSFNCHTMLText1.Font.Style := TMSFNCHTMLText1.Font.Style - [TFontStyle.fsUnderline];

    if TMSFNCFontDialog1.StrikethroughSelected then
      TMSFNCHTMLText1.Font.Style := TMSFNCHTMLText1.Font.Style + [TFontStyle.fsStrikeOut]
    else
      TMSFNCHTMLText1.Font.Style := TMSFNCHTMLText1.Font.Style - [TFontStyle.fsStrikeOut];

    TMSFNCHTMLText1.Invalidate;
  end;
end;

procedure TForm130.TMSFNCStrokeKindPicker1StrokeKindSelected(Sender: TObject;
  AStrokeKind: TTMSFNCGraphicsStrokeKind);
begin
  TMSFNCStrokeKindSelector1.SelectedStrokeKind := AStrokeKind;
  TMSFNCPanel1.Stroke.Kind := AStrokeKind;
end;

procedure TForm130.TMSFNCStrokeKindSelector1StrokeKindSelected(Sender: TObject;
  AStrokeKind: TTMSFNCGraphicsStrokeKind);
begin
  TMSFNCStrokeKindPicker1.SelectedStrokeKind := AStrokeKind;
  TMSFNCPanel1.Stroke.Kind := AStrokeKind;
end;

end.
