unit UTMSFNCRatingLCL;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  LCLTMSFNCProgressBar, LCLTMSFNCPanel, LCLTMSFNCWaitingIndicator;

type

  TRunEvent = procedure of object;

  TTaskStatus = (Created, WaitingToRun, Running, Completed, WaitingForChildren, Canceled, Exception);

  ITask = interface
  ['{5A2BE42C-8E7B-468B-8D6A-2B27EAE87B55}']
    function GetStatus: TTaskStatus;
    procedure Start;
    procedure Cancel;
    property Status: TTaskStatus read GetStatus;
  end;

  TTaskWorkerThread = class(TThread)
  private
    FRunEvent: TRunEvent;
  protected
    procedure Execute; override;
  public
    constructor Create(const ARunEvent: TRunEvent);
  end;

  TTask = class(TInterfacedObject, ITask)
  private
    FWorkerThread: TTaskWorkerThread;
    FTaskStatus: TTaskStatus;
    FRunEvent: TRunEvent;
    function GetStatus: TTaskStatus;
  public
    constructor Create(const ARunEvent: TRunEvent);
    destructor Destroy; override;
    procedure Start;
    procedure Cancel;
    property Status: TTaskStatus read GetStatus;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    TMSFNCPanel1: TTMSFNCPanel;
    TMSFNCRating1: TTMSFNCRating;
    TMSFNCRating2: TTMSFNCRating;
    TMSFNCRating3: TTMSFNCRating;
    TMSFNCProgressBar1: TTMSFNCProgressBar;
    TMSFNCRating4: TTMSFNCRating;
    TMSFNCWaitingIndicator1: TTMSFNCWaitingIndicator;
    ToggleBox1: TToggleBox;
    procedure Button2Click(Sender: TObject);
    procedure TMSFNCRating1ValueChanged(Sender: TObject; AValue: Single);
    procedure TMSFNCRating2ValueChanged(Sender: TObject; AValue: Single);
    procedure TMSFNCRating3ValueChanged(Sender: TObject; AValue: Single);
    procedure TMSFNCRating4ValueChange(Sender: TObject; AValue: Single;
      var AAllow: Boolean);
    procedure TMSFNCRating4ValueChanged(Sender: TObject; AValue: Single);
  private
    cq: Boolean;
    sq: Boolean;
    cr: Boolean;
    tmsl: Boolean;
    proc: ITask;
    procedure TaskFinished;
    procedure TaskRun;
    procedure CheckProgress;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.CheckProgress;
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
    Button2.Visible := True
  else
    Button2.Visible := False;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  TMSFNCWaitingIndicator1.Active := True;

  proc := TTask.Create(@TaskRun);
  proc.Start;
end;

procedure TForm1.TMSFNCRating1ValueChanged(Sender: TObject; AValue: Single);
begin
  cq := True;
  CheckProgress;
end;


procedure TForm1.TMSFNCRating2ValueChanged(Sender: TObject; AValue: Single);
begin
  sq := True;
  CheckProgress;
end;

procedure TForm1.TMSFNCRating3ValueChanged(Sender: TObject; AValue: Single);
begin
  cr := True;
  CheckProgress;
end;

procedure TForm1.TMSFNCRating4ValueChange(Sender: TObject; AValue: Single;
  var AAllow: Boolean);
begin
  if AValue < 3 then
    AAllow := False;
end;

procedure TForm1.TMSFNCRating4ValueChanged(Sender: TObject; AValue: Single);
begin
  tmsl := True;
  CheckProgress;
end;

procedure TForm1.TaskFinished;
begin
  proc := nil;
  TMSFNCWaitingIndicator1.Active := False;
end;

procedure TForm1.TaskRun;
begin
  TThread.Sleep(4000);
  TThread.Queue(nil, @TaskFinished);
end;

constructor TTask.Create(const ARunEvent: TRunEvent);
begin
  FTaskStatus := TTaskStatus.Created;
  FRunEvent := ARunEvent;
end;

destructor TTask.Destroy;
begin
  FRunEvent := nil;
  inherited;
end;

function TTask.GetStatus: TTaskStatus;
begin
  Result := FTaskStatus;
end;

procedure TTask.Cancel;
begin
  FWorkerThread.Terminate;
  FTaskStatus := TTaskStatus.Canceled;
end;

procedure TTask.Start;
begin
  FWorkerThread := TTaskWorkerThread.Create(FRunEvent);
  FTaskStatus := TTaskStatus.Running;
end;

constructor TTaskWorkerThread.Create(const ARunEvent: TRunEvent);
begin
  inherited Create(False);
  FRunEvent := ARunEvent;
  FreeOnTerminate := False;
end;

procedure TTaskWorkerThread.Execute;
begin
  if Assigned(FRunEvent) then
  begin
    FRunEvent();
  end;
end;

end.

