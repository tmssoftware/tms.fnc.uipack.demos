unit UDemo;

{ TMS FNC UI Pack - Toast

  Stackly project board. Six tasks in two status columns. Completing a task fires a success
  toast; assigning one fires an info toast; a task with a past due date fires a warning on
  load. All five toast kinds appear when the demo header sends a sampler. The toast host is
  the form; the position can be changed with the corner radio buttons in the content. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCCardPanel, VCL.TMSFNCStackPanel, VCL.TMSFNCToast,
  VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCCardPanel, FMX.TMSFNCStackPanel, FMX.TMSFNCToast,
  FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton,
  WEBLib.TMSFNCCardPanel, WEBLib.TMSFNCStackPanel, WEBLib.TMSFNCToast,
  WEBLib.TMSFNCTheme, WEBLib.TMSFNCThemeSelector,
  {$ENDIF}
  UDemoLayout;

type
  TTask = record
    Name: string;
    Owner: string;
    Due: string;
    Done: Boolean;
    Overdue: Boolean;
  end;

  TForm1 = class(TDemoForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TTMSFNCPanel;
    DemoTitle: TTMSFNCHTMLText;
    DemoDescription: TTMSFNCHTMLText;
    DemoThemeSelector: TTMSFNCThemeSelector;
    procedure FormCreate(Sender: TObject);
  private
    FLayout: TDemoLayout;
    FContent: TTMSFNCPanel;
    FToast: TTMSFNCToast;
    FPositionRadios: array[0..3] of TTMSFNCRadioButton;
    FTaskDone: array[0..5] of Boolean;
    FTaskButtons: array[0..5] of TTMSFNCButton;
    procedure CreateContent;
    procedure AddTaskCard(AParent: TDemoParent; AIndex: Integer);
    procedure DoneClick(Sender: TObject);
    procedure AssignClick(Sender: TObject);
    procedure SamplerClick(Sender: TObject);
    procedure PositionChanged(Sender: TObject);
    procedure ToastActionClick(Sender: TObject; AItem: TTMSFNCToastItem);
  public
  end;

var
  Form1: TForm1;

const
  Tasks: array[0..5] of TTask = (
    (Name: 'Redesign landing page'; Owner: 'Olivia'; Due: 'Nov 15'; Done: False; Overdue: False),
    (Name: 'Write API documentation'; Owner: 'Noah'; Due: 'Nov 10'; Done: False; Overdue: True),
    (Name: 'Set up CI pipeline'; Owner: 'Lucas'; Due: 'Nov 20'; Done: False; Overdue: False),
    (Name: 'User research interviews'; Owner: 'Emma'; Due: 'Nov 12'; Done: True; Overdue: False),
    (Name: 'Fix login timeout bug'; Owner: 'Liam'; Due: 'Nov 8'; Done: True; Overdue: False),
    (Name: 'Q4 roadmap review'; Owner: 'Ava'; Due: 'Nov 25'; Done: False; Overdue: False)
  );

  PositionNames: array[0..3] of string = ('Top left', 'Top right', 'Bottom left', 'Bottom right');
  PositionValues: array[0..3] of TTMSFNCToastPosition = (tpsTopLeft, tpsTopRight, tpsBottomLeft, tpsBottomRight);

implementation

{$IFDEF FMX}
{$R *.fmx}
{$ENDIF}
{$IFDEF VCL}
{$R *.dfm}
{$ENDIF}
{$IFDEF WEBLIB}
{$R *.dfm}
{$ENDIF}

procedure TForm1.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  FLayout := TDemoLayout.Create(Self);
  for I := 0 to 5 do
    FTaskDone[I] := Tasks[I].Done;
  FToast := TTMSFNCToast.Create(Self);
  FToast.Position := tpsBottomRight;
  FToast.OnActionClick := {$IFDEF WEBLIB}@{$ENDIF}ToastActionClick;
  FContent := FLayout.AddContentPanel(Self);
  FToast.Host := FContent;
  CreateContent;
  { warn about overdue tasks on load }
  for I := 0 to 5 do
    if Tasks[I].Overdue and not Tasks[I].Done then
      FToast.Show(Tasks[I].Name, 'Due ' + Tasks[I].Due + ' - past due', toastWarning, 6000);
end;

procedure TForm1.CreateContent;
const
  ColTitles: array[0..1] of string = ('To Do', 'Done');
var
  toolbar: TTMSFNCPanel;
  samplerBtn: TTMSFNCButton;
  posLabel: TTMSFNCHTMLText;
  cols: TTMSFNCPanel;
  colTodo: TTMSFNCPanel;
  colDone: TTMSFNCPanel;
  I: Integer;
begin
  { top toolbar: sampler button + corner radios }
  toolbar := FLayout.AddPanel(FContent, daTop, 48, 0, 0, 0, 1);
  toolbar.Fill.Kind := gfkNone;
  toolbar.Stroke.Kind := gskNone;

  samplerBtn := TTMSFNCButton.Create(Self);
  samplerBtn.Parent := toolbar;
  FLayout.Place(samplerBtn, daLeft, 160, 16, 8, 0, 8);
  samplerBtn.Text := 'Send all kinds';
  samplerBtn.OnClick := {$IFDEF WEBLIB}@{$ENDIF}SamplerClick;

  posLabel := TTMSFNCHTMLText.Create(Self);
  posLabel.Parent := toolbar;
  FLayout.Place(posLabel, daLeft, 56, 16, 0, 0, 0);
  posLabel.Text := 'Corner:';
  posLabel.VerticalTextAlign := gtaCenter;

  for I := 0 to 3 do
  begin
    FPositionRadios[I] := TTMSFNCRadioButton.Create(Self);
    FPositionRadios[I].Parent := toolbar;
    FLayout.Place(FPositionRadios[I], daLeft, 108, 0, 8, 0, 8);
    FPositionRadios[I].Text := PositionNames[I];
    FPositionRadios[I].GroupName := 'Pos';
    FPositionRadios[I].Checked := I = 3;
    FPositionRadios[I].Tag := I;
    FPositionRadios[I].OnChange := {$IFDEF WEBLIB}@{$ENDIF}PositionChanged;
  end;

  { two-column task board }
  cols := FLayout.AddPanel(FContent, daClient, 0, 0, 0, 0, 0);
  cols.Fill.Kind := gfkNone;
  cols.Stroke.Kind := gskNone;

  colTodo := FLayout.AddPanel(cols, daLeft, 320, 16, 16, 16, 16);
  FLayout.AddCaption(colTodo, ColTitles[0], 0);

  colDone := FLayout.AddPanel(cols, daLeft, 320, 0, 16, 16, 16);
  FLayout.AddCaption(colDone, ColTitles[1], 0);

  { add task cards to the right column based on done state }
  for I := 0 to 5 do
    if not Tasks[I].Done then
      AddTaskCard(colTodo, I)
    else
      AddTaskCard(colDone, I);
end;

procedure TForm1.AddTaskCard(AParent: TDemoParent; AIndex: Integer);
var
  card: TTMSFNCCardPanel;
  doneBtn: TTMSFNCButton;
  assignBtn: TTMSFNCButton;
  row: TTMSFNCStackPanel;
begin
  card := TTMSFNCCardPanel.Create(Self);
  card.Parent := AParent;
  { a card with buttons is taller: at 100 the button row covered the owner and due date under the title; at 124
    the fourth card of To Do fell below the form }
  if Tasks[AIndex].Done then
    FLayout.Place(card, daTop, 76, 0, 8, 0, 0)
  else
    FLayout.Place(card, daTop, 112, 0, 8, 0, 0);
  card.Header.Text := Tasks[AIndex].Name;
  card.Header.Description := Tasks[AIndex].Owner + '  ·  Due ' + Tasks[AIndex].Due;
  card.Header.Height := FLayout.Size(48);
  if Tasks[AIndex].Overdue then
  begin
    card.Appearance.AccentPosition := capLeft;
    card.Appearance.AccentColor := gcOrange;
  end
  else
    card.Appearance.AccentPosition := capNone;
  card.Tag := AIndex;

  if not Tasks[AIndex].Done then
  begin
    row := TTMSFNCStackPanel.Create(Self);
    row.Parent := card;
    FLayout.Place(row, daBottom, 36, 8, 0, 8, 8);
    row.Orientation := spoHorizontal;
    row.Gap := 8;
    row.Appearance.Fill.Kind := gfkNone;
    row.Appearance.Stroke.Kind := gskNone;

    doneBtn := TTMSFNCButton.Create(Self);
    doneBtn.Parent := row;
    doneBtn.Width := FLayout.Size(100);
    doneBtn.Height := FLayout.Size(28);
    doneBtn.Text := 'Mark done';
    doneBtn.Tag := AIndex;
    doneBtn.OnClick := {$IFDEF WEBLIB}@{$ENDIF}DoneClick;
    FTaskButtons[AIndex] := doneBtn;

    assignBtn := TTMSFNCButton.Create(Self);
    assignBtn.Parent := row;
    assignBtn.Width := FLayout.Size(80);
    assignBtn.Height := FLayout.Size(28);
    assignBtn.Text := 'Assign';
    assignBtn.Tag := AIndex;
    assignBtn.OnClick := {$IFDEF WEBLIB}@{$ENDIF}AssignClick;
  end;
end;

procedure TForm1.DoneClick(Sender: TObject);
var
  idx: Integer;
begin
  idx := (Sender as TTMSFNCButton).Tag;
  FTaskDone[idx] := True;
  (Sender as TTMSFNCButton).Enabled := False;
  FToast.Show(Tasks[idx].Name, 'Task completed by ' + Tasks[idx].Owner, toastSuccess);
end;

procedure TForm1.AssignClick(Sender: TObject);
var
  idx: Integer;
  owners: array[0..3] of string;
  I: Integer;
begin
  idx := (Sender as TTMSFNCButton).Tag;
  owners[0] := 'Olivia'; owners[1] := 'Noah'; owners[2] := 'Ava'; owners[3] := 'Mateo';
  I := (idx + 1) mod 4;
  FToast.Show(Tasks[idx].Name, 'Reassigned to ' + owners[I], toastInfo);
end;

procedure TForm1.SamplerClick(Sender: TObject);
begin
  FToast.Show('Information', 'The build started on the CI server.', toastInfo, 4000);
  FToast.Show('Success', 'All 42 tests passed.', toastSuccess, 4000);
  FToast.Show('Warning', 'Disk space below 10 %.', toastWarning, 4000);
  FToast.Show('Error', 'Deploy failed: permission denied.', toastError, 4000);
  FToast.ShowAction('Update ready', 'Version 2.4.1 is available.', 'Install now',
    toastNeutral, 8000);
end;

procedure TForm1.PositionChanged(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to 3 do
    if FPositionRadios[I].Checked then
      FToast.Position := PositionValues[I];
end;

procedure TForm1.ToastActionClick(Sender: TObject; AItem: TTMSFNCToastItem);
begin
  FToast.Show('Installing', 'Update 2.4.1 is being installed...', toastInfo, 3000);
end;

end.
