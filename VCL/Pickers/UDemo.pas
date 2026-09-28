unit UDemo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.UITypes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VCL.TMSFNCCustomControl,
  VCL.TMSFNCTreeViewBase, VCL.TMSFNCTreeViewData, VCL.TMSFNCCustomTreeView,
  VCL.TMSFNCTreeView, Vcl.StdCtrls, VCL.TMSFNCCustomComponent,
  VCL.TMSFNCBitmapContainer, Vcl.ExtCtrls, VCL.TMSFNCTypes, VCL.TMSFNCUtils,
  VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCDigitalTimePicker,
  VCL.TMSFNCAnalogTimePicker, VCL.TMSFNCStrokeKindPicker,
  VCL.TMSFNCStrokeKindSelector, VCL.TMSFNCCustomPicker,
  VCL.TMSFNCFillKindPicker, VCL.TMSFNCFillKindSelector, VCL.TMSFNCAnalogTimeSelector,
  VCL.TMSFNCCustomSelector, VCL.TMSFNCDigitalTimeSelector, VCL.TMSFNCPanel,
  VCL.TMSFNCColorSelector, VCL.TMSFNCColorPicker, VCL.TMSFNCColorWheel,
  VCL.TMSFNCHTMLText, VCL.TMSFNCFontDialog, VCL.TMSFNCDateTimePicker;

type
  TForm130 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    TMSFNCAnalogTimePicker1: TTMSFNCAnalogTimePicker;
    TMSFNCDigitalTimePicker1: TTMSFNCDigitalTimePicker;
    TMSFNCDigitalTimeSelector1: TTMSFNCDigitalTimeSelector;
    TMSFNCFillKindSelector1: TTMSFNCFillKindSelector;
    TMSFNCStrokeKindSelector1: TTMSFNCStrokeKindSelector;
    TMSFNCFillKindPicker1: TTMSFNCFillKindPicker;
    TMSFNCStrokeKindPicker1: TTMSFNCStrokeKindPicker;
    TMSFNCPanel1: TTMSFNCPanel;
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
    Label15: TLabel;
    Edit1: TEdit;
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
    TMSFNCAnalogTimeSelector1: TTMSFNCAnalogTimeSelector;
    Panel4: TPanel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    GroupBox4: TGroupBox;
    RadioButton9: TRadioButton;
    RadioButton10: TRadioButton;
    RadioButton11: TRadioButton;
    TMSFNCColorWheel1: TTMSFNCColorWheel;
    TMSFNCPanel2: TTMSFNCPanel;
    TMSFNCColorPicker1: TTMSFNCColorPicker;
    TMSFNCColorSelector1: TTMSFNCColorSelector;
    Panel5: TPanel;
    Label21: TLabel;
    Button1: TButton;
    TMSFNCFontDialog1: TTMSFNCFontDialog;
    TMSFNCHTMLText1: TTMSFNCHTMLText;
    Panel6: TPanel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    CheckBox5: TCheckBox;
    GroupBox5: TGroupBox;
    RadioButton12: TRadioButton;
    TMSFNCDateTimePicker1: TTMSFNCDateTimePicker;
    RadioButton13: TRadioButton;
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure RadioButton8Click(Sender: TObject);
    procedure RadioButton6Click(Sender: TObject);
    procedure RadioButton7Click(Sender: TObject);
    procedure TMSFNCDigitalTimeSelector1TimeSelected(Sender: TObject; ATime: TTime);
    procedure CheckBox1Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure RadioButton4Click(Sender: TObject);
    procedure RadioButton5Click(Sender: TObject);
    procedure TMSFNCAnalogTimePicker1TimeSelected(Sender: TObject; ATime: TTime);
    procedure TMSFNCDigitalTimePicker1TimeSelected(Sender: TObject; ATime: TTime);
    procedure TMSFNCFillKindSelector1FillKindSelected(Sender: TObject; AFillKind: TTMSFNCGraphicsFillKind);
    procedure FormCreate(Sender: TObject);
    procedure TMSFNCFillKindPicker1FillKindSelected(Sender: TObject; AFillKind: TTMSFNCGraphicsFillKind);
    procedure TMSFNCStrokeKindSelector1StrokeKindSelected(Sender: TObject; AStrokeKind: TTMSFNCGraphicsStrokeKind);
    procedure TMSFNCStrokeKindPicker1StrokeKindSelected(Sender: TObject; AStrokeKind: TTMSFNCGraphicsStrokeKind);
    procedure TMSFNCAnalogTimeSelector1TimeChanged(Sender: TObject; ATime: TTime);
    procedure RadioButton9Click(Sender: TObject);
    procedure RadioButton10Click(Sender: TObject);
    procedure RadioButton11Click(Sender: TObject);
    procedure TMSFNCColorWheel1SelectedColorChanged(Sender: TObject;
      ASelectedColor: TColor);
    procedure TMSFNCColorSelector1ColorSelected(Sender: TObject;
      AColor: TColor);
    procedure TMSFNCColorPicker1ColorSelected(Sender: TObject; AColor: TColor);
    procedure Button1Click(Sender: TObject);
    procedure TMSFNCFontDialog1DialogResult(Sender: TObject;
      AModalResult: TModalResult);
    procedure CheckBox5Click(Sender: TObject);
    procedure RadioButton12Click(Sender: TObject);
    procedure RadioButton13Click(Sender: TObject);
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

{$R *.dfm}

procedure TForm130.Button1Click(Sender: TObject);
begin
  TMSFNCFontDialog1.Execute;
end;

procedure TForm130.CheckBox1Click(Sender: TObject);
begin
  TMSFNCAnalogTimePicker1.Editable := CheckBox1.Checked;
  TMSFNCDigitalTimePicker1.Editable := CheckBox1.Checked;
end;

procedure TForm130.CheckBox2Click(Sender: TObject);
begin
  TMSFNCAnalogTimeSelector1.Settings.Auto := CheckBox2.Checked;
  TMSFNCAnalogTimeSelector1.Appearance.ShowSecondPointer := CheckBox2.Checked;
end;

procedure TForm130.CheckBox3Click(Sender: TObject);
begin
  TMSFNCAnalogTimeSelector1.Settings.ReadOnly := CheckBox3.Checked;
end;

procedure TForm130.CheckBox4Click(Sender: TObject);
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

procedure TForm130.CheckBox5Click(Sender: TObject);
begin
  TMSFNCDateTimePicker1.Editable := CheckBox5.Checked;
end;

procedure TForm130.Edit1Change(Sender: TObject);
var
  i: Integer;
begin
  if TryStrToInt(Edit1.Text, i) then
    TMSFNCDigitalTimeSelector1.TimeInterval := i;
end;

procedure TForm130.FormCreate(Sender: TObject);
begin
  TMSFNCPanel1.Fill.Color := gcWhite;
  TMSFNCPanel1.Fill.ColorTo := gcGray;
  TMSFNCPanel1.Stroke.Color := gcBlack;

  Label24.Caption := FormatDateTime('ddddd tt', TMSFNCDateTimePicker1.SelectedDateTime);
end;

procedure TForm130.RadioButton10Click(Sender: TObject);
begin
  TMSFNCColorSelector1.Mode := csmExtended;
  TMSFNCColorPicker1.Mode := csmExtended;
end;

procedure TForm130.RadioButton11Click(Sender: TObject);
begin
  TMSFNCColorSelector1.Mode := csmExtendedMore;
  TMSFNCColorPicker1.Mode := csmExtendedMore;
end;

procedure TForm130.RadioButton12Click(Sender: TObject);
begin
  TMSFNCDateTimePicker1.TimePickerMode := dtpmAnalog;
end;

procedure TForm130.RadioButton13Click(Sender: TObject);
begin
  TMSFNCDateTimePicker1.TimePickerMode := dtpmDigital;
end;

procedure TForm130.RadioButton1Click(Sender: TObject);
begin
  TMSFNCDigitalTimePicker1.StartTime := StrToTime('00:00:00');
  TMSFNCDigitalTimePicker1.EndTime := StrToTime('23:59:59');
end;

procedure TForm130.RadioButton2Click(Sender: TObject);
begin
  TMSFNCDigitalTimePicker1.StartTime := StrToTime('08:00:00');
  TMSFNCDigitalTimePicker1.EndTime := StrToTime('16:30:00');
end;

procedure TForm130.RadioButton3Click(Sender: TObject);
begin
  TMSFNCAnalogTimePicker1.TimeFormat := 'hh:nn:ss';
  TMSFNCDigitalTimePicker1.TimeFormat := 'hh:nn:ss';
end;

procedure TForm130.RadioButton4Click(Sender: TObject);
begin
  TMSFNCAnalogTimePicker1.TimeFormat := 'hh:nn:ss.zzz';
  TMSFNCDigitalTimePicker1.TimeFormat := 'hh:nn:ss.zzz';
end;

procedure TForm130.RadioButton5Click(Sender: TObject);
begin
  TMSFNCAnalogTimePicker1.TimeFormat := 'hh:nn';
  TMSFNCDigitalTimePicker1.TimeFormat := 'hh:nn';
end;

procedure TForm130.RadioButton6Click(Sender: TObject);
begin
  TMSFNCDigitalTimeSelector1.IntervalUnit := tsuSeconds;
end;

procedure TForm130.RadioButton7Click(Sender: TObject);
begin
  TMSFNCDigitalTimeSelector1.IntervalUnit := tsuMinutes;
end;

procedure TForm130.RadioButton8Click(Sender: TObject);
begin
  TMSFNCDigitalTimeSelector1.IntervalUnit := tsuHours;
end;

procedure TForm130.RadioButton9Click(Sender: TObject);
begin
  TMSFNCColorSelector1.Mode := csmSimple;
  TMSFNCColorPicker1.Mode := csmSimple;
end;

procedure TForm130.TMSFNCAnalogTimePicker1TimeSelected(Sender: TObject;
  ATime: TTime);
begin
  Label15.Caption := TimeToStr(ATime);
end;

procedure TForm130.TMSFNCAnalogTimeSelector1TimeChanged(Sender: TObject;
  ATime: TTime);
begin
  Label8.Caption := TimeToStr(ATime);
end;

procedure TForm130.TMSFNCColorPicker1ColorSelected(Sender: TObject;
  AColor: TColor);
begin
  TMSFNCPanel2.Fill.Color := AColor;
end;

procedure TForm130.TMSFNCColorSelector1ColorSelected(Sender: TObject;
  AColor: TColor);
begin
  TMSFNCPanel2.Fill.Color := AColor;
end;

procedure TForm130.TMSFNCColorWheel1SelectedColorChanged(Sender: TObject;
  ASelectedColor: TColor);
begin
  TMSFNCPanel2.Fill.Color := ASelectedColor;
end;

procedure TForm130.TMSFNCDateTimePicker1DateTimeChanged(Sender: TObject;
  ADateTime: TDateTime);
begin
  Label24.Caption := FormatDateTime('ddddd tt', ADateTime);
end;

procedure TForm130.TMSFNCDigitalTimePicker1TimeSelected(Sender: TObject;
  ATime: TTime);
begin
  Label15.Caption := TimeToStr(ATime);
end;

procedure TForm130.TMSFNCDigitalTimeSelector1TimeSelected(Sender: TObject;
  ATime: TTime);
begin
  Label8.Caption := TimeToStr(ATime)
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
