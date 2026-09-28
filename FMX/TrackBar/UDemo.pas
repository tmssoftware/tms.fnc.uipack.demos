unit UDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.StdCtrls, FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Controls.Presentation,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCTrackBar, FMX.TMSFNCCustomControl, FMX.TMSFNCRangeSlider,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCBitmapContainer;

type
  TForm130 = class(TForm)
    Panel1: TPanel;
    TMSFNCRangeSlider1: TTMSFNCRangeSlider;
    TMSFNCTrackBar1: TTMSFNCTrackBar;
    Label1: TLabel;
    Label2: TLabel;
    CheckBox1: TCheckBox;
    Panel2: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    Label3: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
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
  case (Sender as TCheckBox).Tag of
    10: TMSFNCTrackBar1.Appearance.TickMarkLabel := Checkbox1.IsChecked;
    20: TMSFNCRangeSlider1.Appearance.TickMarkLabel := Checkbox2.IsChecked;
  end;
end;

procedure TForm130.CheckBox3Change(Sender: TObject);
begin
  if CheckBox3.IsChecked then
    TMSFNCTrackBar1.Appearance.Orientation := tboHorizontal
  else
    TMSFNCTrackBar1.Appearance.Orientation := tboVertical;
end;

procedure TForm130.CheckBox4Change(Sender: TObject);
begin
  if CheckBox4.IsChecked then
    TMSFNCRangeSlider1.Appearance.Orientation := tboHorizontal
  else
    TMSFNCRangeSlider1.Appearance.Orientation := tboVertical;
end;

procedure TForm130.CheckBox5Change(Sender: TObject);
begin
  if CheckBox5.IsChecked then
    TMSFNCTrackBar1.Appearance.ButtonShape := bsRounded
  else
    TMSFNCTrackBar1.Appearance.ButtonShape := bsNone;
end;

procedure TForm130.CheckBox6Change(Sender: TObject);
begin
  if CheckBox6.IsChecked then
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
