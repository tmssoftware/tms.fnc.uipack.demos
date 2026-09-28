unit UPassLockDemoFMX;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCSplitter, FMX.TMSFNCCustomControl, FMX.TMSFNCPassLock,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TMSFNCImage;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    TMSFNCSplitter1: TTMSFNCSplitter;
    Panel4: TPanel;
    Button1: TButton;
    Panel3: TPanel;
    TMSFNCPassLock2: TTMSFNCPassLock;
    CheckBox1: TCheckBox;
    LblpwVal: TLabel;
    Label1: TLabel;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    Button2: TButton;
    CheckBox5: TCheckBox;
    Label2: TLabel;
    LblpwEntr: TLabel;
    TMSFNCImage1: TTMSFNCImage;
    CheckBox6: TCheckBox;
    LblLearnMode: TLabel;
    TMSFNCPassLock1: TTMSFNCPassLock;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
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
  CheckBox1.IsChecked := TMSFNCPassLock2.Options.ShowEntry;
  CheckBox2.IsChecked := TMSFNCPassLock2.Options.ShowPasswordLength;
  CheckBox3.IsChecked := TMSFNCPassLock2.Options.ShowOKButton;
  CheckBox4.IsChecked := TMSFNCPassLock2.Options.ShowClearEntryButton;
  CheckBox5.IsChecked := TMSFNCPassLock2.Options.EnableKeyboardInput;
  CheckBox6.IsChecked := TMSFNCPassLock2.Options.LearnMode;

  UpdateEntry;
end;

procedure TForm1.CheckBox1Change(Sender: TObject);
begin
  TMSFNCPassLock2.Options.ShowEntry := CheckBox1.IsChecked;
  Check;
end;

procedure TForm1.CheckBox2Change(Sender: TObject);
begin
  TMSFNCPassLock2.Options.ShowPasswordLength := CheckBox2.IsChecked;
  Check;
end;

procedure TForm1.CheckBox3Change(Sender: TObject);
begin
  TMSFNCPassLock2.Options.ShowOKButton := CheckBox3.IsChecked;
  Check;
end;

procedure TForm1.CheckBox4Change(Sender: TObject);
begin
  TMSFNCPassLock2.Options.ShowClearEntryButton := CheckBox4.IsChecked;
  Check;
end;

procedure TForm1.CheckBox5Change(Sender: TObject);
begin
  TMSFNCPassLock2.Options.EnableKeyboardInput := CheckBox5.IsChecked;
  Check;
end;

procedure TForm1.CheckBox6Change(Sender: TObject);
begin
  TMSFNCPassLock2.Options.LearnMode := CheckBox6.IsChecked;
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
    TMSFNCImage1.Fill.Color := gcLime;
  end
  else
    LblLearnMode.Text := 'Not the same';

  UpdateEntry;
end;

procedure TForm1.TMSFNCPassLock2LearnPassword(Sender: TObject; APassword: string);
begin
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
