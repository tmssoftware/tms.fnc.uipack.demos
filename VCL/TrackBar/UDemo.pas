unit UDemo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Types,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes,
  VCL.TMSFNCRangeSlider, VCL.TMSFNCCustomControl, VCL.TMSFNCTrackBar;

type
  TForm130 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    TMSFNCTrackBar1: TTMSFNCTrackBar;
    TMSFNCRangeSlider1: TTMSFNCRangeSlider;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Panel3: TPanel;
    Panel4: TPanel;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    Panel5: TPanel;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    Panel6: TPanel;
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

{$R *.dfm}

procedure TForm130.CheckBox1Change(Sender: TObject);
begin
  case (Sender as TCheckBox).Tag of
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
    TMSFNCTrackBar1.Appearance.ButtonShape := bsNone;
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
    30: Label5.Caption := 'Selected left: ' + FloatTostr(TMSFNCRangeSlider1.ValueLeft) + ' - Selected right: ' + FloatToStr(TMSFNCRangeSlider1.ValueRight);
    31: Label5.Caption := 'Selected left: ' + FloatTostr(TMSFNCRangeSlider2.ValueLeft) + ' - Selected right: ' + FloatToStr(TMSFNCRangeSlider2.ValueRight);
  end;
end;

procedure TForm130.TMSFNCTrackBar2ValueChanged(Sender: TObject; AValue: Single);
begin
  Label2.Caption := 'Selected value: ' + FloatToStr(AValue);
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
