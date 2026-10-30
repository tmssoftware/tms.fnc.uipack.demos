unit UDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCProgressBar, FMX.TMSFNCCustomControl, FMX.TMSFNCWaitingIndicator,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TMSFNCPanel, System.Threading,
  FMX.TMSFNCButton, FMX.TMSFNCHTMLText, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector;

type
  TForm2 = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TTMSFNCPanel;
    DemoTitle: TTMSFNCHTMLText;
    DemoDescription: TTMSFNCHTMLText;
    DemoThemeSelector: TTMSFNCThemeSelector;
    TMSFNCPanel1: TTMSFNCPanel;
    Label1: TTMSFNCHTMLText;
    TMSFNCRating1: TTMSFNCRating;
    Label2: TTMSFNCHTMLText;
    Label3: TTMSFNCHTMLText;
    TMSFNCRating2: TTMSFNCRating;
    Label4: TTMSFNCHTMLText;
    TMSFNCProgressBar1: TTMSFNCProgressBar;
    Button1: TTMSFNCButton;
    Label5: TTMSFNCHTMLText;
    TMSFNCRating3: TTMSFNCRating;
    Label6: TTMSFNCHTMLText;
    TMSFNCRating4: TTMSFNCRating;
    Label7: TTMSFNCHTMLText;
    TMSFNCWaitingIndicator1: TTMSFNCWaitingIndicator;
    procedure TMSFNCRating1ValueChanged(Sender: TObject; AValue: Single);
    procedure TMSFNCRating2ValueChanged(Sender: TObject; AValue: Single);
    procedure TMSFNCRating3ValueChanged(Sender: TObject; AValue: Single);
    procedure TMSFNCRating4ValueChange(Sender: TObject; AValue: Single;
      var AAllow: Boolean);
    procedure TMSFNCRating4ValueChanged(Sender: TObject; AValue: Single);
    procedure Button1Click(Sender: TObject);
  private
    cq: Boolean;
    sq: Boolean;
    cr: Boolean;
    tmsl: Boolean;
    proc: ITask;
    procedure TaskFinished;
    procedure CheckProgress;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

procedure TForm2.Button1Click(Sender: TObject);
begin
  TMSFNCWaitingIndicator1.Active := True;

  proc := TTask.Create(
    procedure
    begin
      TThread.Sleep(10000);
      TThread.Queue(nil, TaskFinished);
    end);
  proc.Start;
end;

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
    Button1.Visible := True
  else
    Button1.Visible := False;
end;

procedure TForm2.TaskFinished;
begin
  proc := nil;
  TMSFNCWaitingIndicator1.Active := False;
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

end.
