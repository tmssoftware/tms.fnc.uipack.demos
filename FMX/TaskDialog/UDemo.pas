unit UDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.ScrollBox, FMX.Memo, FMX.Edit, FMX.Controls.Presentation,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCTaskDialog, FMX.Layouts, FMX.TMSFNCTypes,
  FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCCustomControl, FMX.TMSFNCColorWheel, FMX.TMSFNCBitmapContainer,
  FMX.Memo.Types,
  FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCEdit, FMX.TMSFNCHTMLText, FMX.TMSFNCPanel, FMX.TMSFNCRadioButton, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector;

type
  TForm130 = class(TForm)
    ContentPanel: TTMSFNCPanel;
    TDSecReady: TTMSFNCHTMLText;
    TDReadyHint: TTMSFNCHTMLText;
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TTMSFNCPanel;
    DemoTitle: TTMSFNCHTMLText;
    DemoDescription: TTMSFNCHTMLText;
    DemoThemeSelector: TTMSFNCThemeSelector;
    Panel1: TTMSFNCPanel;
    Label1: TTMSFNCHTMLText;
    CheckBox1: TTMSFNCCheckBox;
    Edit1: TTMSFNCEdit;
    Label2: TTMSFNCHTMLText;
    CheckBox2: TTMSFNCCheckBox;
    Edit2: TTMSFNCEdit;
    Label3: TTMSFNCHTMLText;
    Label4: TTMSFNCHTMLText;
    CheckBox3: TTMSFNCCheckBox;
    CheckBox4: TTMSFNCCheckBox;
    CheckBox5: TTMSFNCCheckBox;
    Memo1: TMemo;
    RadioButton1: TTMSFNCRadioButton;
    RadioButton2: TTMSFNCRadioButton;
    RadioButton3: TTMSFNCRadioButton;
    Label6: TTMSFNCHTMLText;
    CheckBox10: TTMSFNCCheckBox;
    CheckBox11: TTMSFNCCheckBox;
    Memo2: TMemo;
    Panel2: TTMSFNCPanel;
    Label7: TTMSFNCHTMLText;
    Label10: TTMSFNCHTMLText;
    Memo3: TMemo;
    CheckBox12: TTMSFNCCheckBox;
    CheckBox13: TTMSFNCCheckBox;
    Edit5: TTMSFNCEdit;
    Label11: TTMSFNCHTMLText;
    CheckBox14: TTMSFNCCheckBox;
    Memo4: TMemo;
    CheckBox15: TTMSFNCCheckBox;
    RadioButton4: TTMSFNCRadioButton;
    RadioButton5: TTMSFNCRadioButton;
    RadioButton6: TTMSFNCRadioButton;
    Button1: TTMSFNCButton;
    Panel3: TTMSFNCPanel;
    Label12: TTMSFNCHTMLText;
    Label13: TTMSFNCHTMLText;
    Memo5: TMemo;
    CheckBox16: TTMSFNCCheckBox;
    RadioButton7: TTMSFNCRadioButton;
    RadioButton8: TTMSFNCRadioButton;
    RadioButton9: TTMSFNCRadioButton;
    TMSFNCColorWheel1: TTMSFNCColorWheel;
    Label14: TTMSFNCHTMLText;
    Label15: TTMSFNCHTMLText;
    Label16: TTMSFNCHTMLText;
    Label17: TTMSFNCHTMLText;
    Memo6: TMemo;
    Label18: TTMSFNCHTMLText;
    Label19: TTMSFNCHTMLText;
    Label20: TTMSFNCHTMLText;
    TMSFNCTaskDialog1: TTMSFNCTaskDialog;
    Button2: TTMSFNCButton;
    Button3: TTMSFNCButton;
    Button4: TTMSFNCButton;
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
    TMSFNCTaskDialog1.Content := Memo1.Text
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
  if CheckBox16.Checked and RadioButton9.Checked then
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
      if CheckBox5.Checked then
        Label19.Text := IntToStr(TMSFNCTaskDialog1.RadioButtonResult);

      if CheckBox13.Checked then
      begin
        if TMSFNCTaskDialog1.VerifyResult then
          Label20.Text := 'True'
        else
          Label20.Text := 'False';
      end;

      if CheckBox16.Checked then
      begin
        if RadioButton7.Checked or RadioButton8.Checked then
          Memo6.Text := TMSFNCTaskDialog1.InputText;
      end;
    end;
  end;
end;

end.
