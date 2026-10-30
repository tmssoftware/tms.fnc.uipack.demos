unit UDemo;

interface

uses
  System.SysUtils, System.Classes, JS, Web, WEBLib.Graphics, WEBLib.Controls,
  WEBLib.Forms, WEBLib.Dialogs, VCL.TMSFNCTypes, VCL.TMSFNCUtils,
  VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, Vcl.Controls,
  VCL.TMSFNCCustomControl, VCL.TMSFNCPanel, VCL.TMSFNCProgressBar, Vcl.StdCtrls,
  WEBLib.StdCtrls, WEBLib.TMSFNCButton, VCL.TMSFNCWaitingIndicator, WEBLib.ExtCtrls,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCPanel, WEBLib.TMSFNCTheme, WEBLib.TMSFNCThemeSelector, WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils;

type
  TForm2 = class(TWebForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TTMSFNCPanel;
    DemoTitle: TTMSFNCHTMLText;
    DemoDescription: TTMSFNCHTMLText;
    DemoThemeSelector: TTMSFNCThemeSelector;
    TMSFNCPanel1: TTMSFNCPanel;
    WebLabel1: TTMSFNCHTMLText;
    WebLabel2: TTMSFNCHTMLText;
    WebLabel3: TTMSFNCHTMLText;
    WebLabel4: TTMSFNCHTMLText;
    WebLabel5: TTMSFNCHTMLText;
    WebLabel7: TTMSFNCHTMLText;
    WebLabel8: TTMSFNCHTMLText;
    TMSFNCProgressBar1: TTMSFNCProgressBar;
    WebButton1: TTMSFNCButton;
    TMSFNCWaitingIndicator1: TTMSFNCWaitingIndicator;
    WebTimer1: TWebTimer;
    TMSFNCRating1: TTMSFNCRating;
    TMSFNCRating2: TTMSFNCRating;
    TMSFNCRating3: TTMSFNCRating;
    TMSFNCRating4: TTMSFNCRating;
    procedure TMSFNCRating1ValueChanged(Sender: TObject; AValue: Single);
    procedure TMSFNCRating2ValueChanged(Sender: TObject; AValue: Single);
    procedure TMSFNCRating3ValueChanged(Sender: TObject; AValue: Single);
    procedure TMSFNCRating4ValueChanged(Sender: TObject; AValue: Single);
    procedure TMSFNCRating4ValueChange(Sender: TObject; AValue: Single;
      var AAllow: Boolean);
    procedure WebButton1Click(Sender: TObject);
    procedure WebTimer1Timer(Sender: TObject);
  private
    { Private declarations }
    cq: Boolean;
    sq: Boolean;
    cr: Boolean;
    tmsl: Boolean;
    procedure CheckProgress;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.CheckProgress;
var
  val: Single;
begin
  val := 0;
  if cq then
    val := val + 20;
  if sq then
    val := val + 30;
  if cr then
    val := val + 20;
  if tmsl then
    val := val + 30;

  if val > 0 then
    TMSFNCProgressBar1.Layout.ShowValue := True;

  TMSFNCProgressBar1.Value := val;

  if TMSFNCProgressBar1.Value = TMSFNCProgressBar1.Maximum then
    WebButton1.Visible := True
  else
    WebButton1.Visible := False;
end;

procedure TForm2.TMSFNCRating1ValueChanged(Sender: TObject; AValue: Single);
begin
  cq := True;
  CheckProgress;
end;

procedure TForm2.TMSFNCRating2ValueChanged(Sender: TObject; AValue: Single);
begin
  sq := True;
  CheckProgress;
end;

procedure TForm2.TMSFNCRating3ValueChanged(Sender: TObject; AValue: Single);
begin
  cr := True;
  CheckProgress;
end;

procedure TForm2.TMSFNCRating4ValueChange(Sender: TObject; AValue: Single;
  var AAllow: Boolean);
begin
  if AValue < 3 then
    AAllow := False;
end;

procedure TForm2.TMSFNCRating4ValueChanged(Sender: TObject; AValue: Single);
begin
  tmsl := True;
  CheckProgress;
end;

procedure TForm2.WebButton1Click(Sender: TObject);
begin
  TMSFNCWaitingIndicator1.Active := True;
  WebTimer1.Enabled := True;

end;

procedure TForm2.WebTimer1Timer(Sender: TObject);
begin
  TMSFNCWaitingIndicator1.Active := False;
  WebTimer1.Enabled := False;
end;

end.