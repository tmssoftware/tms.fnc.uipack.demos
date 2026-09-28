unit UDemo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VCL.TMSFNCTypes, VCL.TMSFNCUtils,
  VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCProgressBar,
  VCL.TMSFNCCustomControl, VCL.TMSFNCPanel, Vcl.StdCtrls, System.Threading,
  VCL.TMSFNCWaitingIndicator;

type
  TForm2 = class(TForm)
    TMSFNCPanel1: TTMSFNCPanel;
    TMSFNCRating1: TTMSFNCRating;
    Label1: TLabel;
    Label3: TLabel;
    TMSFNCRating2: TTMSFNCRating;
    Label4: TLabel;
    Label5: TLabel;
    TMSFNCRating3: TTMSFNCRating;
    Label7: TLabel;
    TMSFNCRating4: TTMSFNCRating;
    Label8: TLabel;
    TMSFNCProgressBar1: TTMSFNCProgressBar;
    Button1: TButton;
    TMSFNCWaitingIndicator1: TTMSFNCWaitingIndicator;
    procedure TMSFNCRating1ValueChanged(Sender: TObject; AValue: Single);
    procedure TMSFNCRating2ValueChanged(Sender: TObject; AValue: Single);
    procedure TMSFNCRating3ValueChanged(Sender: TObject; AValue: Single);
    procedure TMSFNCRating4ValueChanged(Sender: TObject; AValue: Single);
    procedure TMSFNCRating4ValueChange(Sender: TObject; AValue: Single;
      var AAllow: Boolean);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    cq: Boolean;
    sq: Boolean;
    cr: Boolean;
    tmsl: Boolean;
    proc: ITask;
    procedure TaskFinished;
    procedure CheckProgress;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

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
