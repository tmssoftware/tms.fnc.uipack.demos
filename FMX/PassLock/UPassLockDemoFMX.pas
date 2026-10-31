unit UPassLockDemoFMX;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCSplitter, FMX.TMSFNCCustomControl, FMX.TMSFNCPassLock,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TMSFNCImage,
  FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCHTMLText, FMX.TMSFNCPanel, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector;

type
  TForm1 = class(TForm)
    ContentPanel: TTMSFNCPanel;
    PLSecKeypad: TTMSFNCHTMLText;
    PLStatusCaption: TTMSFNCHTMLText;
    PLSecPattern: TTMSFNCHTMLText;
    PLPatternHint: TTMSFNCHTMLText;
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TTMSFNCPanel;
    DemoTitle: TTMSFNCHTMLText;
    DemoDescription: TTMSFNCHTMLText;
    DemoThemeSelector: TTMSFNCThemeSelector;
    Panel1: TTMSFNCPanel;
    Panel2: TTMSFNCPanel;
    TMSFNCSplitter1: TTMSFNCSplitter;
    Panel4: TTMSFNCPanel;
    Button1: TTMSFNCButton;
    Panel3: TTMSFNCPanel;
    TMSFNCPassLock2: TTMSFNCPassLock;
    CheckBox1: TTMSFNCCheckBox;
    LblpwVal: TTMSFNCHTMLText;
    Label1: TTMSFNCHTMLText;
    CheckBox2: TTMSFNCCheckBox;
    CheckBox3: TTMSFNCCheckBox;
    CheckBox4: TTMSFNCCheckBox;
    Button2: TTMSFNCButton;
    CheckBox5: TTMSFNCCheckBox;
    Label2: TTMSFNCHTMLText;
    LblpwEntr: TTMSFNCHTMLText;
    TMSFNCImage1: TTMSFNCImage;
    CheckBox6: TTMSFNCCheckBox;
    LblLearnMode: TTMSFNCHTMLText;
    TMSFNCPassLock1: TTMSFNCPassLock;
    Label3: TTMSFNCHTMLText;
    Label4: TTMSFNCHTMLText;
    Label5: TTMSFNCHTMLText;
    Label6: TTMSFNCHTMLText;
    procedure Button1Click(Sender: TObject);
    procedure TMSFNCPassLock1PasswordCheck(Sender: TObject; AEntry: string;
      var AMatch: Boolean);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure Check;
    procedure CheckBox3Change(Sender: TObject);
    procedure CheckBox4Change(Sender: TObject);
    procedure CheckBox5Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure TMSFNCPassLock2PasswordCheck(Sender: TObject; AEntry: string;
      var AMatch: Boolean);
    procedure TMSFNCPassLock2BeforeDrawEntry(Sender: TObject;
      AGraphics: TTMSFNCGraphics; ARect: TRectF; AChecked: Boolean; var AAllow,
      ADefaultDraw: Boolean);
    procedure TMSFNCPassLock2ConfirmPassword(Sender: TObject; AEntry: string;
      var AMatch: Boolean);
    procedure UpdateEntry;
    procedure FormShow(Sender: TObject);
    procedure CheckBox6Change(Sender: TObject);
    procedure TMSFNCPassLock2LearnPassword(Sender: TObject; APassword: string);
    procedure TMSFNCPassLock2PasswordEntryChanged(Sender: TObject;
      APasswordEntry, AValue: string);

  private
    corr: boolean;
    pwCheck: boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

{ demo-colors: TMSFNCImage1.Fill.Color and the entry colours of TMSFNCPassLock2 are the pass/fail feedback of the demo }

procedure TForm1.Button1Click(Sender: TObject);
begin
  TMSFNCPassLock1.Visible := True;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  TMSFNCPassLock1.ClearPasswordEntry;
end;

procedure TForm1.Check;
begin
  CheckBox1.Checked := TMSFNCPassLock2.Options.ShowEntry;
  CheckBox2.Checked := TMSFNCPassLock2.Options.ShowPasswordLength;
  CheckBox3.Checked := TMSFNCPassLock2.Options.ShowOKButton;
  CheckBox4.Checked := TMSFNCPassLock2.Options.ShowClearEntryButton;
  CheckBox5.Checked := TMSFNCPassLock2.Options.EnableKeyboardInput;
  CheckBox6.Checked := TMSFNCPassLock2.Options.LearnMode;

  UpdateEntry;
end;

procedure TForm1.CheckBox1Change(Sender: TObject);
begin
  TMSFNCPassLock2.Options.ShowEntry := CheckBox1.Checked;
  Check;
end;

procedure TForm1.CheckBox2Change(Sender: TObject);
begin
  TMSFNCPassLock2.Options.ShowPasswordLength := CheckBox2.Checked;
  Check;
end;

procedure TForm1.CheckBox3Change(Sender: TObject);
begin
  TMSFNCPassLock2.Options.ShowOKButton := CheckBox3.Checked;
  Check;
end;

procedure TForm1.CheckBox4Change(Sender: TObject);
begin
  TMSFNCPassLock2.Options.ShowClearEntryButton := CheckBox4.Checked;
  Check;
end;

procedure TForm1.CheckBox5Change(Sender: TObject);
begin
  TMSFNCPassLock2.Options.EnableKeyboardInput := CheckBox5.Checked;
  Check;
end;

procedure TForm1.CheckBox6Change(Sender: TObject);
begin
  TMSFNCPassLock2.Options.LearnMode := CheckBox6.Checked;
  Check;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  LblpwVal.Text := TMSFNCPassLock2.PasswordValue;
  Check;
end;

procedure TForm1.TMSFNCPassLock1PasswordCheck(Sender: TObject; AEntry: string;  var AMatch: Boolean);
begin
  if AMatch then
    TMSFNCPassLock1.Visible := False;
end;

procedure TForm1.TMSFNCPassLock2BeforeDrawEntry(Sender: TObject; AGraphics: TTMSFNCGraphics; ARect: TRectF; AChecked: Boolean; var AAllow,
  ADefaultDraw: Boolean);
begin
  if pwCheck then
  begin
    if corr then
      AGraphics.Fill.Color := gcLime
    else
      AGraphics.Stroke.Color := gcTomato;
  end;
end;

procedure TForm1.TMSFNCPassLock2ConfirmPassword(Sender: TObject; AEntry: string;
  var AMatch: Boolean);
begin
  if AMatch then
  begin
    LblpwVal.Text := AEntry;
    LblLearnMode.Text := 'New password set';
    TMSFNCImage1.Fill.Kind := gfkSolid;
    TMSFNCImage1.Fill.Color := gcLime;
  end
  else
    LblLearnMode.Text := 'Not the same';

  UpdateEntry;
end;

procedure TForm1.TMSFNCPassLock2LearnPassword(Sender: TObject; APassword: string);
begin
  TMSFNCImage1.Fill.Kind := gfkSolid;
  TMSFNCImage1.Fill.Color := gcYellow;
  LblLearnMode.Text := 'Confirm';
end;

procedure TForm1.TMSFNCPassLock2PasswordCheck(Sender: TObject; AEntry: string; var AMatch: Boolean);
begin
  pwCheck := True;
  TMSFNCImage1.Fill.Kind := gfkSolid;
  if AMatch then
  begin
    corr := True;
    TMSFNCImage1.Fill.Color := gcLime;
  end
  else
  begin
    corr := False;
    TMSFNCImage1.Fill.Color := gcTomato;
  end;
  UpdateEntry;
end;

procedure TForm1.TMSFNCPassLock2PasswordEntryChanged(Sender: TObject;
  APasswordEntry, AValue: string);
begin
  UpdateEntry;
  if pwCheck then
    pwCheck := False;
end;

procedure TForm1.UpdateEntry;
begin
  LblpwEntr.Text := TMSFNCPassLock2.PasswordEntry;
end;

end.
