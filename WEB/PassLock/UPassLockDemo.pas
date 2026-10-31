unit UPassLockDemo;

interface

uses
  System.SysUtils, System.Types, System.Classes, System.DateUtils, JS, Web, WEBLib.Graphics, WEBLib.Controls,
  WEBLib.Forms, VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics,
  VCL.TMSFNCGraphicsTypes, VCL.TMSFNCPassLock, Vcl.StdCtrls, WEBLib.StdCtrls,
  VCL.TMSFNCCustomControl, VCL.TMSFNCSplitter, Vcl.Controls, WEBLib.ExtCtrls,
  VCL.TMSFNCImage,
  WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox,
  WEBLib.TMSFNCCustomControl,
  WEBLib.TMSFNCGraphics,
  WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCHTMLText,
  WEBLib.TMSFNCPanel,
  WEBLib.TMSFNCTheme,
  WEBLib.TMSFNCThemeSelector,
  WEBLib.TMSFNCTypes,
  WEBLib.TMSFNCUtils;

type
  TForm1 = class(TWebForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TTMSFNCPanel;
    DemoTitle: TTMSFNCHTMLText;
    DemoDescription: TTMSFNCHTMLText;
    DemoThemeSelector: TTMSFNCThemeSelector;
    ContentPanel: TTMSFNCPanel;
    PLSecKeypad: TTMSFNCHTMLText;
    PLStatusCaption: TTMSFNCHTMLText;
    PLSecPattern: TTMSFNCHTMLText;
    PLPatternHint: TTMSFNCHTMLText;
    WebPanel1: TTMSFNCPanel;
    WebPanel3: TTMSFNCPanel;
    WebLabel5: TTMSFNCHTMLText;
    WebLabel6: TTMSFNCHTMLText;
    WebCheckBox1: TTMSFNCCheckBox;
    WebCheckBox2: TTMSFNCCheckBox;
    WebCheckBox3: TTMSFNCCheckBox;
    WebCheckBox4: TTMSFNCCheckBox;
    WebCheckBox5: TTMSFNCCheckBox;
    TMSFNCSplitter1: TTMSFNCSplitter;
    WebPanel2: TTMSFNCPanel;
    WebPanel4: TTMSFNCPanel;
    WebLabel1: TTMSFNCHTMLText;
    WebLabel2: TTMSFNCHTMLText;
    WebLabel3: TTMSFNCHTMLText;
    WebLabel4: TTMSFNCHTMLText;
    WebButton1: TTMSFNCButton;
    TMSFNCPassLock1: TTMSFNCPassLock;
    TMSFNCPassLock2: TTMSFNCPassLock;
    WebButton2: TTMSFNCButton;
    LblpwVal: TTMSFNCHTMLText;
    LblpwEntr: TTMSFNCHTMLText;
    LblLearnMode: TTMSFNCHTMLText;
    TMSFNCImage1: TTMSFNCImage;
    WebCheckBox6: TTMSFNCCheckBox;
    procedure TMSFNCPassLock1PasswordCheck(Sender: TObject; AEntry: string; var AMatch: Boolean);
    procedure WebButton1Click(Sender: TObject);
    procedure WebFormCreate(Sender: TObject);
    procedure WebButton2Click(Sender: TObject);
    procedure Check;
    procedure UpdateEntry;
    procedure WebCheckBox1Click(Sender: TObject);
    procedure WebCheckBox2Click(Sender: TObject);
    procedure WebCheckBox3Click(Sender: TObject);
    procedure WebCheckBox4Click(Sender: TObject);
    procedure WebCheckBox5Click(Sender: TObject);
    procedure WebCheckBox6Click(Sender: TObject);
    procedure WebFormShow(Sender: TObject);
    procedure TMSFNCPassLock2BeforeDrawEntry(Sender: TObject;
      AGraphics: TTMSFNCGraphics; ARect: TRectF; AChecked: Boolean; var AAllow,
      ADefaultDraw: Boolean);
    procedure TMSFNCPassLock2ConfirmPassword(Sender: TObject; AEntry: string;
      var AMatch: Boolean);
    procedure TMSFNCPassLock2LearnPassword(Sender: TObject; APassword: string);
    procedure TMSFNCPassLock2PasswordCheck(Sender: TObject; AEntry: string;
      var AMatch: Boolean);
    procedure TMSFNCPassLock2PasswordEntryChanged(Sender: TObject;
      APasswordEntry, AValue: string);
  private
    { Private declarations }
    pwCheck: Boolean;
    corr: Boolean;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{ demo-colors: TMSFNCImage1.Fill.Color and the entry colours of TMSFNCPassLock2 are the pass/fail feedback of the demo }

procedure TForm1.Check;
begin
  WebCheckBox1.Checked := TMSFNCPassLock2.Options.ShowEntry;
  WebCheckBox2.Checked := TMSFNCPassLock2.Options.ShowPasswordLength;
  WebCheckBox3.Checked := TMSFNCPassLock2.Options.ShowOKButton;
  WebCheckBox4.Checked := TMSFNCPassLock2.Options.ShowClearEntryButton;
  WebCheckBox5.Checked := TMSFNCPassLock2.Options.EnableKeyboardInput;
  WebCheckBox6.Checked := TMSFNCPassLock2.Options.LearnMode;

  UpdateEntry;
end;

procedure TForm1.TMSFNCPassLock1PasswordCheck(Sender: TObject; AEntry: string; var AMatch: Boolean);
begin
  if AMatch then
    TMSFNCPassLock1.Visible := False;
end;

procedure TForm1.TMSFNCPassLock2BeforeDrawEntry(Sender: TObject;
  AGraphics: TTMSFNCGraphics; ARect: TRectF; AChecked: Boolean; var AAllow,
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

procedure TForm1.TMSFNCPassLock2LearnPassword(Sender: TObject;
  APassword: string);
begin
  TMSFNCImage1.Fill.Kind := gfkSolid;
  TMSFNCImage1.Fill.Color := gcYellow;
  LblLearnMode.Text := 'Confirm';
end;

procedure TForm1.TMSFNCPassLock2PasswordCheck(Sender: TObject; AEntry: string;
  var AMatch: Boolean);
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

procedure TForm1.WebButton1Click(Sender: TObject);
begin
  TMSFNCPassLock1.Visible := True;
end;

procedure TForm1.WebButton2Click(Sender: TObject);
begin
  TMSFNCPassLock2.ClearPasswordEntry;
end;

procedure TForm1.WebCheckBox1Click(Sender: TObject);
begin
  TMSFNCPassLock2.Options.ShowEntry := WebCheckBox1.Checked;
  Check;
end;

procedure TForm1.WebCheckBox2Click(Sender: TObject);
begin
  TMSFNCPassLock2.Options.ShowPasswordLength := WebCheckBox2.Checked;
  Check;
end;

procedure TForm1.WebCheckBox3Click(Sender: TObject);
begin
  TMSFNCPassLock2.Options.ShowOKButton := WebCheckBox3.Checked;
  Check;
end;

procedure TForm1.WebCheckBox4Click(Sender: TObject);
begin
  TMSFNCPassLock2.Options.ShowClearEntryButton := WebCheckBox4.Checked;
  Check;
end;

procedure TForm1.WebCheckBox5Click(Sender: TObject);
begin
  TMSFNCPassLock2.Options.EnableKeyboardInput := WebCheckBox5.Checked;
  Check;
end;

procedure TForm1.WebCheckBox6Click(Sender: TObject);
begin
  TMSFNCPassLock2.Options.LearnMode := WebCheckBox6.Checked;
  Check;
end;

procedure TForm1.WebFormCreate(Sender: TObject);
var
  lbl: TWebLabel;
begin
  FormContainer := 'appcontent';
  lbl := TLabel.Create(Self);
  lbl.ElementID := 'title';
  lbl.Caption := 'TMS FNC UI Pack';

  lbl := TLabel.Create(Self);
  lbl.ElementID := 'description';
  lbl.Caption := 'TMS FNC Pass Lock';
end;

procedure TForm1.WebFormShow(Sender: TObject);
begin
  LblpwVal.Text := TMSFNCPassLock2.PasswordValue;
  Check;
  TMSFNCPassLock2.SetFocus;
end;

end.


