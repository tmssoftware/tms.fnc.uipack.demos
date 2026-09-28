unit UDemo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, LCLTMSFNCFillKindSelector, LCLTMSFNCFillKindPicker,
  LCLTMSFNCStrokeKindSelector, LCLTMSFNCStrokeKindPicker,
  LCLTMSFNCAnalogTimeSelector, LCLTMSFNCDigitalTimeSelector,
  LCLTMSFNCAnalogTimePicker, LCLTMSFNCDigitalTimePicker, LCLTMSFNCGraphicsTypes,
  LCLTMSFNCPanel, LCLTMSFNCColorWheel, LCLTMSFNCColorSelector,
  LCLTMSFNCColorPicker, LCLTMSFNCHTMLEditor, LCLTMSFNCHTMLText,
  LCLTMSFNCFontDialog, LCLTMSFNCDateTimePicker;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    Edit1: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    RadioButton1: TRadioButton;
    RadioButton10: TRadioButton;
    RadioButton11: TRadioButton;
    RadioButton12: TRadioButton;
    RadioButton13: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    RadioButton9: TRadioButton;
    TMSFNCAnalogTimePicker1: TTMSFNCAnalogTimePicker;
    TMSFNCColorPicker1: TTMSFNCColorPicker;
    TMSFNCColorSelector1: TTMSFNCColorSelector;
    TMSFNCColorWheel1: TTMSFNCColorWheel;
    TMSFNCDateTimePicker1: TTMSFNCDateTimePicker;
    TMSFNCDigitalTimePicker1: TTMSFNCDigitalTimePicker;
    TMSFNCDigitalTimeSelector1: TTMSFNCDigitalTimeSelector;
    TMSFNCFillKindPicker1: TTMSFNCFillKindPicker;
    TMSFNCFillKindSelector1: TTMSFNCFillKindSelector;
    TMSFNCFontDialog1: TTMSFNCFontDialog;
    TMSFNCHTMLText1: TTMSFNCHTMLText;
    TMSFNCPanel1: TTMSFNCPanel;
    TMSFNCPanel2: TTMSFNCPanel;
    TMSFNCStrokeKindPicker1: TTMSFNCStrokeKindPicker;
    TMSFNCStrokeKindSelector1: TTMSFNCStrokeKindSelector;
    TMSFNCAnalogTimeSelector1: TTMSFNCAnalogTimeSelector;
    procedure Button1Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure CheckBox3Change(Sender: TObject);
    procedure CheckBox4Change(Sender: TObject);
    procedure CheckBox5Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioButton12Change(Sender: TObject);
    procedure RadioButton13Change(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure RadioButton2Change(Sender: TObject);
    procedure RadioButton3Change(Sender: TObject);
    procedure RadioButton4Change(Sender: TObject);
    procedure RadioButton5Change(Sender: TObject);
    procedure RadioButton6Change(Sender: TObject);
    procedure RadioButton7Change(Sender: TObject);
    procedure RadioButton8Change(Sender: TObject);
    procedure RadioButton9Change(Sender: TObject);
    procedure RadioButton10Change(Sender: TObject);
    procedure RadioButton11Change(Sender: TObject);
    procedure TMSFNCAnalogTimePicker1TimeSelected(Sender: TObject; ATime: TTime);
    procedure TMSFNCColorPicker1ColorSelected(Sender: TObject;
      AColor: TTMSFNCGraphicsColor);
    procedure TMSFNCColorSelector1ColorSelected(Sender: TObject;
      AColor: TTMSFNCGraphicsColor);
    procedure TMSFNCColorWheel1SelectedColorChanged(Sender: TObject;
      ASelectedColor: TTMSFNCGraphicsColor);
    procedure TMSFNCDateTimePicker1DateTimeChanged(Sender: TObject;
      ADateTime: TDateTime);
    procedure TMSFNCDigitalTimePicker1TimeSelected(Sender: TObject; ATime: TTime);
    procedure TMSFNCDigitalTimeSelector1TimeSelected(Sender: TObject; ATime: TTime);
    procedure TMSFNCFillKindPicker1FillKindSelected(Sender: TObject; AFillKind: TTMSFNCGraphicsFillKind);
    procedure TMSFNCFillKindSelector1FillKindSelected(Sender: TObject; AFillKind: TTMSFNCGraphicsFillKind);
    procedure TMSFNCFontDialog1DialogResult(Sender: TObject;
      AModalResult: TModalResult);
    procedure TMSFNCStrokeKindPicker1StrokeKindSelected(Sender: TObject; AStrokeKind: TTMSFNCGraphicsStrokeKind);
    procedure TMSFNCStrokeKindSelector1StrokeKindSelected(Sender: TObject; AStrokeKind: TTMSFNCGraphicsStrokeKind);
    procedure TMSFNCAnalogTimeSelector1TimeChanged(Sender: TObject; ATime: TTime);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.CheckBox1Change(Sender: TObject);
begin
  TMSFNCAnalogTimePicker1.Editable := CheckBox1.Checked;
  TMSFNCDigitalTimePicker1.Editable := CheckBox1.Checked;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  TMSFNCFontDialog1.Execute;
end;

procedure TForm1.CheckBox2Change(Sender: TObject);
begin
  TMSFNCAnalogTimeSelector1.Settings.Auto := CheckBox2.Checked;
  TMSFNCAnalogTimeSelector1.Appearance.ShowSecondPointer := CheckBox2.Checked;
end;

procedure TForm1.CheckBox3Change(Sender: TObject);
begin
  TMSFNCAnalogTimeSelector1.Settings.ReadOnly := CheckBox3.Checked;
end;

procedure TForm1.CheckBox4Change(Sender: TObject);
begin
  if CheckBox4.Checked then
    TMSFNCAnalogTimeSelector1.Style := wsBlackWhite
  else
  begin
    TMSFNCAnalogTimeSelector1.Style := wsClassic;
    TMSFNCAnalogTimeSelector1.Appearance.InitializeDefault;
    TMSFNCAnalogTimeSelector1.Appearance.ShowSecondPointer := CheckBox2.Checked;
  end;
end;

procedure TForm1.CheckBox5Change(Sender: TObject);
begin
  TMSFNCDateTimePicker1.Editable := CheckBox5.Checked;
end;

procedure TForm1.Edit1Change(Sender: TObject);
var
  i: Integer;
begin
  if TryStrToInt(Edit1.Text, i) then
    TMSFNCDigitalTimeSelector1.TimeInterval := i;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  TMSFNCDigitalTimePicker1.DropDownWidth := 250;

  TMSFNCPanel1.Fill.Color := gcWhite;
  TMSFNCPanel1.Fill.ColorTo := gcGray;
  TMSFNCPanel1.Stroke.Color := gcBlack;

  Label24.Caption := FormatDateTime('ddddd tt', TMSFNCDateTimePicker1.SelectedDateTime);
end;

procedure TForm1.RadioButton12Change(Sender: TObject);
begin
  TMSFNCDateTimePicker1.TimePickerMode := dtpmAnalog;
end;

procedure TForm1.RadioButton13Change(Sender: TObject);
begin
  TMSFNCDateTimePicker1.TimePickerMode := dtpmDigital;
end;

procedure TForm1.RadioButton1Change(Sender: TObject);
begin
  TMSFNCDigitalTimePicker1.StartTime := StrToTime('00:00:00');
  TMSFNCDigitalTimePicker1.EndTime := StrToTime('23:59:59');
end;

procedure TForm1.RadioButton2Change(Sender: TObject);
begin
  TMSFNCDigitalTimePicker1.StartTime := StrToTime('08:00:00');
  TMSFNCDigitalTimePicker1.EndTime := StrToTime('16:30:00');
end;

procedure TForm1.RadioButton3Change(Sender: TObject);
begin
  TMSFNCAnalogTimePicker1.TimeFormat := 'hh:nn:ss';
  TMSFNCDigitalTimePicker1.TimeFormat := 'hh:nn:ss';
end;

procedure TForm1.RadioButton4Change(Sender: TObject);
begin
  TMSFNCAnalogTimePicker1.TimeFormat := 'hh:nn:ss.zzz';
  TMSFNCDigitalTimePicker1.TimeFormat := 'hh:nn:ss.zzz';
end;

procedure TForm1.RadioButton5Change(Sender: TObject);
begin
  TMSFNCAnalogTimePicker1.TimeFormat := 'hh:nn';
  TMSFNCDigitalTimePicker1.TimeFormat := 'hh:nn';
end;

procedure TForm1.RadioButton6Change(Sender: TObject);
begin
  TMSFNCDigitalTimeSelector1.IntervalUnit := tsuSeconds;
end;

procedure TForm1.RadioButton7Change(Sender: TObject);
begin
  TMSFNCDigitalTimeSelector1.IntervalUnit := tsuMinutes;
end;

procedure TForm1.RadioButton8Change(Sender: TObject);
begin
  TMSFNCDigitalTimeSelector1.IntervalUnit := tsuHours;
end;

procedure TForm1.RadioButton9Change(Sender: TObject);
begin
  TMSFNCColorSelector1.Mode := csmSimple;
  TMSFNCColorPicker1.Mode := csmSimple;
end;

procedure TForm1.RadioButton10Change(Sender: TObject);
begin
  TMSFNCColorSelector1.Mode := csmExtended;
  TMSFNCColorPicker1.Mode := csmExtended;
end;

procedure TForm1.RadioButton11Change(Sender: TObject);
begin
  TMSFNCColorSelector1.Mode := csmExtendedMore;
  TMSFNCColorPicker1.Mode := csmExtendedMore;
end;

procedure TForm1.TMSFNCAnalogTimePicker1TimeSelected(Sender: TObject;
  ATime: TTime);
begin
  Label15.Caption := TimeToStr(ATime);
end;

procedure TForm1.TMSFNCColorPicker1ColorSelected(Sender: TObject;
  AColor: TTMSFNCGraphicsColor);
begin
  TMSFNCPanel2.Fill.Color := AColor;
end;

procedure TForm1.TMSFNCColorSelector1ColorSelected(Sender: TObject;
  AColor: TTMSFNCGraphicsColor);
begin
  TMSFNCPanel2.Fill.Color := AColor;
end;

procedure TForm1.TMSFNCColorWheel1SelectedColorChanged(Sender: TObject;
  ASelectedColor: TTMSFNCGraphicsColor);
begin
  TMSFNCPanel2.Fill.Color := ASelectedColor;
end;

procedure TForm1.TMSFNCDateTimePicker1DateTimeChanged(Sender: TObject;
  ADateTime: TDateTime);
begin
  Label24.Caption := FormatDateTime('ddddd tt', ADateTime);
end;

procedure TForm1.TMSFNCDigitalTimePicker1TimeSelected(Sender: TObject;
  ATime: TTime);
begin
  Label15.Caption := TimeToStr(ATime);
end;

procedure TForm1.TMSFNCDigitalTimeSelector1TimeSelected(Sender: TObject;
  ATime: TTime);
begin
  Label8.Caption := TimeToStr(ATime)
end;

procedure TForm1.TMSFNCFillKindPicker1FillKindSelected(Sender: TObject;
  AFillKind: TTMSFNCGraphicsFillKind);
begin
  TMSFNCFillKindSelector1.SelectedFillKind := AFillKind;
  TMSFNCPanel1.Fill.Kind := AFillKind;
end;

procedure TForm1.TMSFNCFillKindSelector1FillKindSelected(Sender: TObject;
  AFillKind: TTMSFNCGraphicsFillKind);
begin
  TMSFNCFillKindPicker1.SelectedFillKind := AFillKind;
  TMSFNCPanel1.Fill.Kind := AFillKind;
end;

procedure TForm1.TMSFNCFontDialog1DialogResult(Sender: TObject;
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

procedure TForm1.TMSFNCStrokeKindPicker1StrokeKindSelected(Sender: TObject;
  AStrokeKind: TTMSFNCGraphicsStrokeKind);
begin
  TMSFNCStrokeKindSelector1.SelectedStrokeKind := AStrokeKind;
  TMSFNCPanel1.Stroke.Kind := AStrokeKind;
end;

procedure TForm1.TMSFNCStrokeKindSelector1StrokeKindSelected(Sender: TObject;
  AStrokeKind: TTMSFNCGraphicsStrokeKind);
begin
  TMSFNCStrokeKindPicker1.SelectedStrokeKind := AStrokeKind;
  TMSFNCPanel1.Stroke.Kind := AStrokeKind;
end;

procedure TForm1.TMSFNCAnalogTimeSelector1TimeChanged(Sender: TObject; ATime: TTime);
begin
  Label8.Caption := TimeToStr(ATime);
end;

end.

