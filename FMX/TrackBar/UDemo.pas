unit UDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.StdCtrls, FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Controls.Presentation,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCTrackBar, FMX.TMSFNCCustomControl, FMX.TMSFNCRangeSlider,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCBitmapContainer,
  FMX.TMSFNCCheckBox, FMX.TMSFNCHTMLText, FMX.TMSFNCPanel, FMX.TMSFNCRadioButton, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector;

type
  TForm130 = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TTMSFNCPanel;
    DemoTitle: TTMSFNCHTMLText;
    DemoDescription: TTMSFNCHTMLText;
    DemoThemeSelector: TTMSFNCThemeSelector;
    Panel1: TTMSFNCPanel;
    TMSFNCRangeSlider1: TTMSFNCRangeSlider;
    TMSFNCTrackBar1: TTMSFNCTrackBar;
    Label1: TTMSFNCHTMLText;
    Label2: TTMSFNCHTMLText;
    CheckBox1: TTMSFNCCheckBox;
    Panel2: TTMSFNCPanel;
    Label4: TTMSFNCHTMLText;
    Label5: TTMSFNCHTMLText;
    CheckBox2: TTMSFNCCheckBox;
    CheckBox3: TTMSFNCCheckBox;
    CheckBox4: TTMSFNCCheckBox;
    CheckBox5: TTMSFNCCheckBox;
    CheckBox6: TTMSFNCCheckBox;
    RadioButton1: TTMSFNCRadioButton;
    RadioButton2: TTMSFNCRadioButton;
    RadioButton3: TTMSFNCRadioButton;
    RadioButton4: TTMSFNCRadioButton;
    Label3: TTMSFNCHTMLText;
    Label6: TTMSFNCHTMLText;
    Label7: TTMSFNCHTMLText;
    Label8: TTMSFNCHTMLText;
    RadioButton5: TTMSFNCRadioButton;
    RadioButton6: TTMSFNCRadioButton;
    RadioButton7: TTMSFNCRadioButton;
    RadioButton8: TTMSFNCRadioButton;
    TMSFNCTrackBar2: TTMSFNCTrackBar;
    TMSFNCRangeSlider2: TTMSFNCRangeSlider;
    procedure TMSFNCTrackBar2ValueChanged(Sender: TObject; AValue: Single);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox3Change(Sender: TObject);
    procedure CheckBox4Change(Sender: TObject);
    procedure TMSFNCRangeSlider1ValueChanged(Sender: TObject; AValue: Single;
      ALeft: Boolean);
    procedure CheckBox5Change(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure RadioButton2Change(Sender: TObject);
    procedure RadioButton3Change(Sender: TObject);
    procedure RadioButton4Change(Sender: TObject);
    procedure CheckBox6Change(Sender: TObject);
    procedure RadioButton5Change(Sender: TObject);
    procedure RadioButton6Change(Sender: TObject);
    procedure RadioButton7Change(Sender: TObject);
    procedure RadioButton8Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form130: TForm130;

implementation

{$R *.fmx}

procedure TForm130.CheckBox1Change(Sender: TObject);
begin
  case (Sender as TTMSFNCCheckBox).Tag of
    10: TMSFNCTrackBar1.Appearance.TickMarkLabel := Checkbox1.Checked;
    20: TMSFNCRangeSlider1.Appearance.TickMarkLabel := Checkbox2.Checked;
  end;
end;

procedure TForm130.CheckBox3Change(Sender: TObject);
begin
  if CheckBox3.Checked then
    TMSFNCTrackBar1.Appearance.Orientation := tboHorizontal
  else
    TMSFNCTrackBar1.Appearance.Orientation := tboVertical;
end;

procedure TForm130.CheckBox4Change(Sender: TObject);
begin
  if CheckBox4.Checked then
    TMSFNCRangeSlider1.Appearance.Orientation := tboHorizontal
  else
    TMSFNCRangeSlider1.Appearance.Orientation := tboVertical;
end;

procedure TForm130.CheckBox5Change(Sender: TObject);
begin
  if CheckBox5.Checked then
    TMSFNCTrackBar1.Appearance.ButtonShape := bsRounded
  else
    TMSFNCTrackBar1.Appearance.ButtonShape := bsNoButton;
end;

procedure TForm130.CheckBox6Change(Sender: TObject);
begin
  if CheckBox6.Checked then
    TMSFNCRangeSlider1.Appearance.TrackLabelPosition := tlpTopCenter
  else
    TMSFNCRangeSlider1.Appearance.TrackLabelPosition := tlpNone;
end;

procedure TForm130.RadioButton1Change(Sender: TObject);
begin
  TMSFNCTrackBar1.Interaction.Frequency := 1;
end;

procedure TForm130.RadioButton2Change(Sender: TObject);
begin
  TMSFNCTrackBar1.Interaction.Frequency := 2;
end;

procedure TForm130.TMSFNCRangeSlider1ValueChanged(Sender: TObject;
  AValue: Single; ALeft: Boolean);
begin
  case (Sender as TTMSFNCRangeSlider).Tag of
    30: Label5.Text := 'Selected left: ' + FloatTostr(TMSFNCRangeSlider1.ValueLeft) + ' - Selected right: ' + FloatToStr(TMSFNCRangeSlider1.ValueRight);
    31: Label5.Text := 'Selected left: ' + FloatTostr(TMSFNCRangeSlider2.ValueLeft) + ' - Selected right: ' + FloatToStr(TMSFNCRangeSlider2.ValueRight);
  end;
end;

procedure TForm130.TMSFNCTrackBar2ValueChanged(Sender: TObject; AValue: Single);
begin
  Label2.Text := 'Selected value: ' + FloatToStr(AValue);
end;

procedure TForm130.RadioButton3Change(Sender: TObject);
begin
  TMSFNCTrackBar1.Appearance.TickMarkDivision := 5;
end;

procedure TForm130.RadioButton4Change(Sender: TObject);
begin
  TMSFNCTrackBar1.Appearance.TickMarkDivision := 10;
end;

procedure TForm130.RadioButton5Change(Sender: TObject);
begin
  TMSFNCRangeSlider1.Interaction.Frequency := 1;
end;

procedure TForm130.RadioButton6Change(Sender: TObject);
begin
  TMSFNCRangeSlider1.Interaction.Frequency := 2;
end;

procedure TForm130.RadioButton7Change(Sender: TObject);
begin
  TMSFNCRangeSlider1.Appearance.TickMarkDivision := 5;
end;

procedure TForm130.RadioButton8Change(Sender: TObject);
begin
  TMSFNCRangeSlider1.Appearance.TickMarkDivision := 10;
end;

end.
