unit UDemo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VCL.TMSFNCCustomControl,
  VCL.TMSFNCListBox, VCL.TMSFNCCustomComponent, VCL.TMSFNCBitmapContainer,
  Vcl.StdCtrls, VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics,
  VCL.TMSFNCGraphicsTypes, Vcl.ExtCtrls, VCL.TMSFNCTaskDialog,
  VCL.TMSFNCColorWheel, VCL.TMSFNCCustomGrid, VCL.TMSFNCDataGridDatabaseAdapter;

type
  TForm130 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
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
    Label20: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    CheckBox14: TCheckBox;
    CheckBox15: TCheckBox;
    CheckBox16: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit5: TEdit;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    Memo4: TMemo;
    Memo5: TMemo;
    Memo6: TMemo;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    Panel4: TPanel;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    RadioButton9: TRadioButton;
    Button1: TButton;
    TMSFNCColorWheel1: TTMSFNCColorWheel;
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

{$R *.dfm}

procedure TForm130.Button1Click(Sender: TObject);
var
  mr: TModalResult;
begin
  //Title
  if not CheckBox1.Checked then
    TMSFNCTaskDialog1.Title := Edit1.Text
  else
    TMSFNCTaskDialog1.Title := '';

  //Instruction
  if CheckBox2.Checked then
    TMSFNCTaskDialog1.Instruction := Edit2.Text
  else
    TMSFNCTaskDialog1.Instruction := '';

  if CheckBox3.Checked then
  begin
    if RadioButton1.Checked then
      TMSFNCTaskDialog1.Icon := tdiQuestion
    else if RadioButton2.Checked then
      TMSFNCTaskDialog1.Icon := tdiShield
    else if RadioButton3.Checked then
      TMSFNCTaskDialog1.Icon := tdiError;
  end
  else
    TMSFNCTaskDialog1.Icon := tdiBlank;

  //Content
  if CheckBox4.Checked then
  begin
    TMSFNCTaskDialog1.Content := Memo1.Text;
  end
  else
    TMSFNCTaskDialog1.Content := '';

  //Radio buttons
  if CheckBox5.Checked then
   TMSFNCTaskDialog1.RadioButtons.Assign(Memo2.Lines)
  else
    TMSFNCTaskDialog1.RadioButtons.Clear;

  //Custom buttons
  if CheckBox10.Checked then
   TMSFNCTaskDialog1.CustomButtons.Assign(Memo3.Lines)
  else
    TMSFNCTaskDialog1.CustomButtons.Clear;

  if CheckBox11.Checked then
    TMSFNCTaskDialog1.Options := TMSFNCTaskDialog1.Options + [tdoCommandLinks]
  else
    TMSFNCTaskDialog1.Options := TMSFNCTaskDialog1.Options - [tdoCommandLinks];

  //Expanded text
  if CheckBox12.Checked then
   TMSFNCTaskDialog1.ExpandedText := Memo4.Text
  else
    TMSFNCTaskDialog1.ExpandedText := '';

  TMSFNCTaskDialog1.ExpandControlText := 'Expand';
  TMSFNCTaskDialog1.CollapseControlText := 'Collapse';

  //Verification box
  if CheckBox13.Checked then
    TMSFNCTaskDialog1.VerifyText := Edit5.Text
  else
    TMSFNCTaskDialog1.VerifyText := '';

  //Footer
  if CheckBox14.Checked then
    TMSFNCTaskDialog1.Footer := Memo5.Text
  else
    TMSFNCTaskDialog1.Footer := '';

  if CheckBox15.Checked then
  begin
    if RadioButton4.Checked then
      TMSFNCTaskDialog1.FooterIcon := tdiAbout
    else if RadioButton5.Checked then
      TMSFNCTaskDialog1.FooterIcon := tdiInformation
    else if RadioButton6.Checked then
      TMSFNCTaskDialog1.FooterIcon := tdiWarning;
  end
  else
    TMSFNCTaskDialog1.FooterIcon := tdiBlank;

  //Input field
  if CheckBox16.Checked then
  begin
    if RadioButton7.Checked then
      TMSFNCTaskDialog1.InputType := titEdit
    else if RadioButton8.Checked then
      TMSFNCTaskDialog1.InputType := titDate
    else if RadioButton9.Checked then
      TMSFNCTaskDialog1.InputType := titCustom;
  end
  else
    TMSFNCTaskDialog1.InputType := titNone;

  mr := TMSFNCTaskDialog1.Execute;

  //Results
  case mr of
    mrOk: Label18.Caption := 'OK clicked';
    mrYes: Label18.Caption := 'Yes clicked';
    mrNo: Label18.Caption := 'No clicked';
    mrCancel: Label18.Caption := 'Cancelled';
    mrClose: Label18.Caption := 'Close clicked';
    mrAbort: Label18.Caption := 'Aborted';
  else
    Label18.Caption := IntToStr(mr);
  end;

  if CheckBox5.Checked then
    Label19.Caption := IntToStr(TMSFNCTaskDialog1.RadioButtonResult);

  if CheckBox13.Checked then
  begin
    if TMSFNCTaskDialog1.VerifyResult then
      Label20.Caption := 'True'
    else
      Label20.Caption := 'False';
  end;

  if CheckBox16.Checked then
  begin
    if RadioButton7.Checked or RadioButton8.Checked then
      Memo6.Text := TMSFNCTaskDialog1.InputText;
  end;
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

  mr := TMSFNCTaskDialog1.Execute;

  case mr of
    mrOk: Label18.Caption := 'OK clicked';
    mrYes: Label18.Caption := 'Yes clicked';
    mrNo: Label18.Caption := 'No clicked';
    mrCancel: Label18.Caption := 'Cancelled';
    mrClose: Label18.Caption := 'Close clicked';
    mrAbort: Label18.Caption := 'Aborted';
  else
    Label18.Caption := IntToStr(mr);
  end;

  Label19.Caption := IntToStr(TMSFNCTaskDialog1.RadioButtonResult);
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

  mr := TMSFNCTaskDialog1.Execute;

  case mr of
    mrOk: Label18.Caption := 'OK clicked';
    mrYes: Label18.Caption := 'Yes clicked';
    mrNo: Label18.Caption := 'No clicked';
    mrCancel: Label18.Caption := 'Cancelled';
    mrClose: Label18.Caption := 'Close clicked';
    mrAbort: Label18.Caption := 'Aborted';
  else
    Label18.Caption := IntToStr(mr);
  end;
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

  mr := TMSFNCTaskDialog1.Execute;

  case mr of
    mrOk: Label18.Caption := 'OK clicked';
    mrYes: Label18.Caption := 'Yes clicked';
    mrNo: Label18.Caption := 'No clicked';
    mrCancel: Label18.Caption := 'Cancelled';
    mrClose: Label18.Caption := 'Close clicked';
    mrAbort: Label18.Caption := 'Aborted';
  else
    Label18.Caption := IntToStr(mr);
  end;

  if TMSFNCTaskDialog1.VerifyResult then
    Label20.Caption := 'True'
  else
    Label20.Caption := 'False';
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
   if CheckBox16.Checked and RadioButton9.Checked then
  begin
    Memo6.Text := TTMSFNCColorWheel(TMSFNCTaskDialog1.InputControl).HEXValue;
  end;
end;

end.
