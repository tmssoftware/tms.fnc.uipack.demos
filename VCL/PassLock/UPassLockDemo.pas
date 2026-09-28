unit UPassLockDemo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VCL.TMSFNCTypes, VCL.TMSFNCUtils,
  VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, Vcl.StdCtrls, VCL.TMSFNCPassLock,
  VCL.TMSFNCCustomControl, VCL.TMSFNCSplitter, Vcl.ExtCtrls, VCL.TMSFNCImage;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    TMSFNCSplitter1: TTMSFNCSplitter;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Button1: TButton;
    TMSFNCPassLock2: TTMSFNCPassLock;
    TMSFNCPassLock1: TTMSFNCPassLock;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    Button2: TButton;
    LblLearnMode: TLabel;
    LblpwEntr: TLabel;
    LblpwVal: TLabel;
    TMSFNCImage1: TTMSFNCImage;
    procedure TMSFNCPassLock1PasswordCheck(Sender: TObject; AEntry: string;
      var AMatch: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Check;
    procedure UpdateEntry;
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure CheckBox6Click(Sender: TObject);
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
    procedure FormShow(Sender: TObject);
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

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  TMSFNCPassLock2.Options.ShowEntry := CheckBox1.Checked;
  Check;
end;

procedure TForm1.CheckBox2Click(Sender: TObject);
begin
  TMSFNCPassLock2.Options.ShowPasswordLength := CheckBox2.Checked;
  Check;
end;

procedure TForm1.CheckBox3Click(Sender: TObject);
begin
  TMSFNCPassLock2.Options.ShowOKButton := CheckBox3.Checked;
  Check;
end;

procedure TForm1.CheckBox4Click(Sender: TObject);
begin
  TMSFNCPassLock2.Options.ShowClearEntryButton := CheckBox4.Checked;
  Check;
end;

procedure TForm1.CheckBox5Click(Sender: TObject);
begin
  TMSFNCPassLock2.Options.EnableKeyboardInput := CheckBox5.Checked;
  Check;
end;

procedure TForm1.CheckBox6Click(Sender: TObject);
begin
  TMSFNCPassLock2.Options.LearnMode := CheckBox6.Checked;
  Check;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  LblpwVal.Caption := TMSFNCPassLock2.PasswordValue;
  Check;
  TMSFNCPassLock2.SetFocus;
end;

procedure TForm1.TMSFNCPassLock1PasswordCheck(Sender: TObject; AEntry: string;
  var AMatch: Boolean);
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
    LblpwVal.Caption := AEntry;
    LblLearnMode.Caption := 'New password set';
    TMSFNCImage1.Fill.Color := gcLime;
  end
  else
    LblLearnMode.Caption := 'Not the same';

  UpdateEntry;
end;

procedure TForm1.TMSFNCPassLock2LearnPassword(Sender: TObject;
  APassword: string);
begin
  TMSFNCImage1.Fill.Color := gcYellow;
  LblLearnMode.Caption := 'Confirm';
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
  LblpwEntr.Caption := TMSFNCPassLock2.PasswordEntry;
end;

end.
