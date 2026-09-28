unit UDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.ScrollBox, FMX.Memo, FMX.Edit, FMX.Controls.Presentation,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCTaskDialog, FMX.Layouts, FMX.TMSFNCTypes,
  FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCCustomControl, FMX.TMSFNCColorWheel, FMX.TMSFNCBitmapContainer,
  FMX.Memo.Types;

type
  TForm130 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    Label2: TLabel;
    CheckBox2: TCheckBox;
    Edit2: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    Memo1: TMemo;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Label6: TLabel;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    Memo2: TMemo;
    Panel2: TPanel;
    Label7: TLabel;
    Label10: TLabel;
    Memo3: TMemo;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    Edit5: TEdit;
    Label11: TLabel;
    CheckBox14: TCheckBox;
    Memo4: TMemo;
    CheckBox15: TCheckBox;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    Button1: TButton;
    Panel3: TPanel;
    Label12: TLabel;
    Label13: TLabel;
    Memo5: TMemo;
    CheckBox16: TCheckBox;
    Layout1: TLayout;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    RadioButton9: TRadioButton;
    TMSFNCColorWheel1: TTMSFNCColorWheel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Memo6: TMemo;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    TMSFNCTaskDialog1: TTMSFNCTaskDialog;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure TMSFNCTaskDialog1DialogResult(Sender: TObject;
      AModalResult: TModalResult);
  private
    { Private declarations }
    procedure TaskDialogClosed(Sender: TObject);
    procedure ClearTaskDialog;
  public
    { Public declarations }
  end;

var
  Form130: TForm130;

implementation

{$R *.fmx}


procedure TForm130.Button1Click(Sender: TObject);
var
  mr: TModalResult;
begin
  //Title
  if not CheckBox1.IsChecked then
    TMSFNCTaskDialog1.Title := Edit1.Text
  else
    TMSFNCTaskDialog1.Title := '';

  //Instruction
  if CheckBox2.IsChecked then
    TMSFNCTaskDialog1.Instruction := Edit2.Text
  else
    TMSFNCTaskDialog1.Instruction := '';

  if CheckBox3.IsChecked then
  begin
    if RadioButton1.IsChecked then
      TMSFNCTaskDialog1.Icon := tdiQuestion
    else if RadioButton2.IsChecked then
      TMSFNCTaskDialog1.Icon := tdiShield
    else if RadioButton3.IsChecked then
      TMSFNCTaskDialog1.Icon := tdiError;
  end
  else
    TMSFNCTaskDialog1.Icon := tdiBlank;

  //Content
  if CheckBox4.IsChecked then
    TMSFNCTaskDialog1.Content := Memo1.Text
  else
    TMSFNCTaskDialog1.Content := '';

  //Radio buttons
  if CheckBox5.IsChecked then
   TMSFNCTaskDialog1.RadioButtons.Assign(Memo2.Lines)
  else
    TMSFNCTaskDialog1.RadioButtons.Clear;

  //Custom buttons
  if CheckBox10.IsChecked then
   TMSFNCTaskDialog1.CustomButtons.Assign(Memo3.Lines)
  else
    TMSFNCTaskDialog1.CustomButtons.Clear;

  if CheckBox11.IsChecked then
    TMSFNCTaskDialog1.Options := TMSFNCTaskDialog1.Options + [tdoCommandLinks]
  else
    TMSFNCTaskDialog1.Options := TMSFNCTaskDialog1.Options - [tdoCommandLinks];

  //Expanded text
  if CheckBox12.IsChecked then
   TMSFNCTaskDialog1.ExpandedText := Memo4.Text
  else
    TMSFNCTaskDialog1.ExpandedText := '';

  TMSFNCTaskDialog1.ExpandControlText := 'Expand';
  TMSFNCTaskDialog1.CollapseControlText := 'Collapse';

  //Verification box
  if CheckBox13.IsChecked then
    TMSFNCTaskDialog1.VerifyText := Edit5.Text
  else
    TMSFNCTaskDialog1.VerifyText := '';

  //Footer
  if CheckBox14.IsChecked then
    TMSFNCTaskDialog1.Footer := Memo5.Text
  else
    TMSFNCTaskDialog1.Footer := '';

  if CheckBox15.IsChecked then
  begin
    if RadioButton4.IsChecked then
      TMSFNCTaskDialog1.FooterIcon := tdiAbout
    else if RadioButton5.IsChecked then
      TMSFNCTaskDialog1.FooterIcon := tdiInformation
    else if RadioButton6.IsChecked then
      TMSFNCTaskDialog1.FooterIcon := tdiWarning;
  end
  else
    TMSFNCTaskDialog1.FooterIcon := tdiBlank;

  //Input field
  if CheckBox16.IsChecked then
  begin
    if RadioButton7.IsChecked then
      TMSFNCTaskDialog1.InputType := titEdit
    else if RadioButton8.IsChecked then
      TMSFNCTaskDialog1.InputType := titDate
    else if RadioButton9.IsChecked then
      TMSFNCTaskDialog1.InputType := titCustom;
  end
  else
    TMSFNCTaskDialog1.InputType := titNone;

  TMSFNCTaskDialog1.Tag := 4;
  TMSFNCTaskDialog1.Execute;
end;

procedure TForm130.Button2Click(Sender: TObject);
var
  mr: TModalResult;
begin
  ClearTaskDialog;

  TMSFNCTaskDialog1.Icon := tdiInformation;
  TMSFNCTaskDialog1.Instruction := 'TaskDialog with radio buttons';
  TMSFNCTaskDialog1.RadioButtons.Add('First radio button');
  TMSFNCTaskDialog1.RadioButtons.Add('Second radio button');
  TMSFNCTaskDialog1.RadioButtons.Add('Third radio button');

  TMSFNCTaskDialog1.Tag := 1;
  TMSFNCTaskDialog1.Execute;
end;

procedure TForm130.Button3Click(Sender: TObject);
var
  mr: TModalResult;
begin
  ClearTaskDialog;

  TMSFNCTaskDialog1.Icon := tdiInformation;
  TMSFNCTaskDialog1.Instruction := 'TaskDialog with radio buttons';
  TMSFNCTaskDialog1.CustomButtons.Add('First custom button');
  TMSFNCTaskDialog1.CustomButtons.Add('Second custom button');
  TMSFNCTaskDialog1.CustomButtons.Add('Third custom button');
  TMSFNCTaskDialog1.Options := TMSFNCTaskDialog1.Options + [tdoCommandLinks];

  TMSFNCTaskDialog1.Tag := 2;
  TMSFNCTaskDialog1.Execute;
end;

procedure TForm130.Button4Click(Sender: TObject);
var
  mr: TModalResult;
begin
  ClearTaskDialog;

  TMSFNCTaskDialog1.Icon := tdiInformation;
  TMSFNCTaskDialog1.Instruction := 'TaskDialog with footer';
  TMSFNCTaskDialog1.Content := 'Content area of the task dialog';
  TMSFNCTaskDialog1.FooterIcon := tdiInformation;
  TMSFNCTaskDialog1.Footer := 'Footer area of the task dialog';
  TMSFNCTaskDialog1.VerifyText := 'Verify box';

  TMSFNCTaskDialog1.Tag := 3;
  TMSFNCTaskDialog1.Execute;
end;

procedure TForm130.ClearTaskDialog;
begin
  TMSFNCTaskDialog1.Title := '';
  TMSFNCTaskDialog1.Instruction := '';
  TMSFNCTaskDialog1.Content := '';
  TMSFNCTaskDialog1.InputType := titNone;
  TMSFNCTaskDialog1.ExpandedText := '';
  TMSFNCTaskDialog1.VerifyText := '';
  TMSFNCTaskDialog1.Footer := '';
  TMSFNCTaskDialog1.CustomButtons.Clear;
  TMSFNCTaskDialog1.RadioButtons.Clear;
  TMSFNCTaskDialog1.Options := [];
end;

procedure TForm130.FormCreate(Sender: TObject);
begin
  TMSFNCTaskDialog1.InputControl := TMSFNCColorWheel1;
  TMSFNCTaskDialog1.OnDialogClosed := TaskDialogClosed;
end;

procedure TForm130.TaskDialogClosed(Sender: TObject);
begin
  if CheckBox16.IsChecked and RadioButton9.IsChecked then
  begin
    Memo6.Text := TTMSFNCColorWheel(TMSFNCTaskDialog1.InputControl).HEXValue;
  end;
end;

procedure TForm130.TMSFNCTaskDialog1DialogResult(Sender: TObject;
  AModalResult: TModalResult);
begin
  case AModalResult of
    mrOk: Label18.Text := 'OK clicked';
    mrYes: Label18.Text := 'Yes clicked';
    mrNo: Label18.Text := 'No clicked';
    mrCancel: Label18.Text := 'Cancelled';
    mrClose: Label18.Text := 'Close clicked';
    mrAbort: Label18.Text := 'Aborted';
  else
    Label18.Text := IntToStr(AModalResult);
  end;

  case TMSFNCTaskDialog1.Tag of
    1: Label19.Text := IntToStr(TMSFNCTaskDialog1.RadioButtonResult);
    3:
    begin
      if TMSFNCTaskDialog1.VerifyResult then
        Label20.Text := 'True'
      else
        Label20.Text := 'False';
    end;
    4:
    begin
      if CheckBox5.IsChecked then
        Label19.Text := IntToStr(TMSFNCTaskDialog1.RadioButtonResult);

      if CheckBox13.IsChecked then
      begin
        if TMSFNCTaskDialog1.VerifyResult then
          Label20.Text := 'True'
        else
          Label20.Text := 'False';
      end;

      if CheckBox16.IsChecked then
      begin
        if RadioButton7.IsChecked or RadioButton8.IsChecked then
          Memo6.Text := TMSFNCTaskDialog1.InputText;
      end;
    end;
  end;
end;

end.
