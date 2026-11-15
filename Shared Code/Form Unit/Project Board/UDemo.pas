unit UDemo;

{ TMS FNC UI Pack - Project Board

  One tasks dataset shown as a Kanban board, a planner and a timeline, each bound through DataSource with
  write-back: dragging a card to another column or lane, moving or sizing a planner item or a timeline section
  writes the record, and the other views and the task grid follow. The board columns come from a status table
  (order and work-in-progress limit), the swimlanes and the planner resources from the owners table, and the
  selected task drives the checklist grid. A data navigator and a grid work on the same records. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCKanbanBoard, VCL.TMSFNCPlanner, VCL.TMSFNCPlannerData, VCL.TMSFNCTimeline, VCL.TMSFNCDataGrid,
  VCL.TMSFNCDataNavigator, VCL.TMSFNCSampleData, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCKanbanBoard, FMX.TMSFNCPlanner, FMX.TMSFNCPlannerData, FMX.TMSFNCTimeline, FMX.TMSFNCDataGrid,
  FMX.TMSFNCDataNavigator, FMX.TMSFNCSampleData, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs, DB, WEBLib.DB, WEBLib.CDS,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton, WEBLib.TMSFNCKanbanBoard, WEBLib.TMSFNCPlanner,
  WEBLib.TMSFNCPlannerData, WEBLib.TMSFNCTimeline, WEBLib.TMSFNCDataGrid, WEBLib.TMSFNCDataNavigator,
  WEBLib.TMSFNCSampleData, WEBLib.TMSFNCTheme, WEBLib.TMSFNCThemeSelector,
  {$ENDIF}
  UDemoLayout;

type
  TDemoView = (dvBoard, dvPlanner, dvTimeline);

  TForm1 = class(TDemoForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TTMSFNCPanel;
    DemoTitle: TTMSFNCHTMLText;
    DemoDescription: TTMSFNCHTMLText;
    DemoThemeSelector: TTMSFNCThemeSelector;
    procedure FormCreate(Sender: TObject);
  private
    FLayout: TDemoLayout;
    FSettings: TTMSFNCPanel;
    FContent: TTMSFNCPanel;
    FViewRadios: array[TDemoView] of TTMSFNCRadioButton;
    FLanesCheck: TTMSFNCCheckBox;
    FColumnsCheck: TTMSFNCCheckBox;
    FGridCheck: TTMSFNCCheckBox;
    FDayText: TTMSFNCHTMLText;
    FStatus: TTMSFNCHTMLText;
    FStatuses: TDemoDataSet;
    FOwners: TDemoDataSet;
    FTasks: TDemoDataSet;
    FChecklist: TDemoDataSet;
    FStatusesSource: TDataSource;
    FOwnersSource: TDataSource;
    FTasksSource: TDataSource;
    FChecklistSource: TDataSource;
    FBoard: TTMSFNCKanbanBoard;
    FPlanner: TTMSFNCPlanner;
    FTimeline: TTMSFNCTimeline;
    FChecklistGrid: TTMSFNCDataGrid;
    FTaskGrid: TTMSFNCDataGrid;
    FGridPanel: TTMSFNCPanel;
    FDay: TDateTime;
    FMonday: TDateTime;
    FPeople: TArray<string>;
    procedure CreateData;
    procedure CreateSettings;
    procedure CreateContent;
    procedure CreateBoard;
    procedure CreatePlanner;
    procedure CreateTimeline;
    procedure ShowView(AView: TDemoView);
    procedure ShowDay;
    procedure ViewChanged(Sender: TObject);
    procedure BoardSettingChanged(Sender: TObject);
    procedure GridCheckChanged(Sender: TObject);
    procedure PreviousDayClick(Sender: TObject);
    procedure NextDayClick(Sender: TObject);
    procedure TaskPosted(DataSet: TDataSet);
    procedure NewTask(DataSet: TDataSet);
    procedure BoardDataError(Sender: TObject; AItem: TTMSFNCKanbanBoardItem; const AMessage: string; var AHandled: Boolean);
    procedure PlannerDataError(Sender: TObject; AItem: TTMSFNCPlannerItem; const AMessage: string; var AHandled: Boolean);
    procedure TimelineDataError(Sender: TObject; AItem: TCollectionItem; const AMessage: string; var AHandled: Boolean);
    procedure ShowError(const AMessage: string);
  public
  end;

var
  Form1: TForm1;

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

const
  StatusCodes: array[0..4] of string = ('new', 'planned', 'doing', 'risk', 'done');
  StatusNames: array[0..4] of string = ('Not started', 'Planned', 'In progress', 'At risk', 'Done');
  StatusLimits: array[0..4] of Integer = (0, 0, 3, 2, 0);
  ChecklistItems: array[0..3] of string = ('Write the brief', 'Review with the team', 'Update the documentation', 'Inform the customer');

procedure TForm1.FormCreate(Sender: TObject);
begin
  FLayout := TDemoLayout.Create(Self);
  FMonday := Trunc(Date) - (DayOfWeek(Date) + 5) mod 7;
  FDay := FMonday;
  CreateData;
  CreateSettings;
  CreateContent;
  ShowView(dvBoard);
  ShowDay;
end;

procedure TForm1.CreateData;
var
  project: TArray<TTMSFNCSampleProjectTask>;
  todo: TArray<TTMSFNCSampleTask>;
  I, c, status, owner, count: Integer;
  start: TDateTime;

  procedure AddTask(const ATitle, ANotes: string; AStatus, AOwner, AIndex: Integer);
  begin
    FTasks.Append;
    FTasks.FieldByName('ID').AsInteger := AIndex + 1;
    FTasks.FieldByName('Title').AsString := ATitle;
    FTasks.FieldByName('Notes').AsString := ANotes;
    FTasks.FieldByName('Status').AsString := StatusCodes[AStatus];
    FTasks.FieldByName('OwnerID').AsInteger := AOwner + 1;
    start := FMonday + AIndex mod 5 + (9 + 2.5 * (AIndex mod 3)) / 24;
    FTasks.FieldByName('StartTime').AsDateTime := start;
    FTasks.FieldByName('EndTime').AsDateTime := start + (1.5 + AIndex mod 2) / 24;
    FTasks.FieldByName('Position').AsInteger := AIndex;
    FTasks.Post;
  end;

begin
  { the status table: the board columns, in order, with a work-in-progress limit }
  FStatuses := FLayout.NewDataSet;
  FStatuses.FieldDefs.Add('Code', ftString, 10);
  FStatuses.FieldDefs.Add('Name', ftString, 30);
  FStatuses.FieldDefs.Add('SortOrder', ftInteger);
  FStatuses.FieldDefs.Add('WIPLimit', ftInteger);
  FLayout.OpenDataSet(FStatuses);
  for I := 0 to High(StatusCodes) do
  begin
    FStatuses.Append;
    FStatuses.FieldByName('Code').AsString := StatusCodes[I];
    FStatuses.FieldByName('Name').AsString := StatusNames[I];
    FStatuses.FieldByName('SortOrder').AsInteger := I;
    FStatuses.FieldByName('WIPLimit').AsInteger := StatusLimits[I];
    FStatuses.Post;
  end;
  FStatuses.First;
  FStatusesSource := FLayout.NewSource(FStatuses);

  { the owners: the swimlanes of the board and the resources of the planner }
  FPeople := TTMSFNCSampleData.People;
  FOwners := FLayout.NewDataSet;
  FOwners.FieldDefs.Add('OwnerID', ftInteger);
  FOwners.FieldDefs.Add('Name', ftString, 40);
  FOwners.FieldDefs.Add('SortOrder', ftInteger);
  FLayout.OpenDataSet(FOwners);
  for I := 0 to High(FPeople) do
  begin
    FOwners.Append;
    FOwners.FieldByName('OwnerID').AsInteger := I + 1;
    FOwners.FieldByName('Name').AsString := FPeople[I];
    FOwners.FieldByName('SortOrder').AsInteger := I;
    FOwners.Post;
  end;
  FOwners.First;
  FOwnersSource := FLayout.NewSource(FOwners);

  { the tasks, shared by every view }
  FTasks := FLayout.NewDataSet;
  FTasks.FieldDefs.Add('ID', ftInteger);
  FTasks.FieldDefs.Add('Title', ftString, 60);
  FTasks.FieldDefs.Add('Notes', ftString, 200);
  FTasks.FieldDefs.Add('Status', ftString, 10);
  FTasks.FieldDefs.Add('OwnerID', ftInteger);
  FTasks.FieldDefs.Add('StartTime', ftDateTime);
  FTasks.FieldDefs.Add('EndTime', ftDateTime);
  FTasks.FieldDefs.Add('Position', ftInteger);
  FLayout.OpenDataSet(FTasks);
  project := TTMSFNCSampleData.ProjectTasks;
  count := 0;
  for I := 0 to High(project) do
  begin
    status := 0;
    while (status < High(StatusNames)) and (StatusNames[status] <> project[I].Status) do
      Inc(status);
    owner := 0;
    while (owner < High(FPeople)) and (FPeople[owner] <> project[I].Owner) do
      Inc(owner);
    AddTask(project[I].Task, project[I].Project + ', ' + IntToStr(project[I].Progress) + '% done', status, owner, count);
    Inc(count);
  end;
  todo := TTMSFNCSampleData.Tasks;
  for I := 0 to High(todo) do
  begin
    if todo[I].Badge = 'Done' then
      status := 4
    else if todo[I].Badge = 'Overdue' then
      status := 3
    else
      status := 1 + I mod 2;
    AddTask(todo[I].Text, 'To do', status, (I + 2) mod Length(FPeople), count);
    Inc(count);
  end;
  FTasks.First;
  FTasks.FieldByName('ID').Visible := False;
  FTasks.FieldByName('Notes').Visible := False;
  FTasks.FieldByName('Position').Visible := False;
  FTasks.FieldByName('OwnerID').DisplayLabel := 'Owner';
  FTasks.FieldByName('StartTime').DisplayLabel := 'Start';
  FTasks.FieldByName('EndTime').DisplayLabel := 'End';
  FTasks.AfterPost := {$IFDEF WEBLIB}@{$ENDIF}TaskPosted;
  FTasks.OnNewRecord := {$IFDEF WEBLIB}@{$ENDIF}NewTask;
  FTasksSource := FLayout.NewSource(FTasks);

  { the checklist of a task, shown for the selected card, item or section }
  FChecklist := FLayout.NewDataSet;
  FChecklist.FieldDefs.Add('ItemID', ftInteger);
  FChecklist.FieldDefs.Add('TaskID', ftInteger);
  FChecklist.FieldDefs.Add('Item', ftString, 60);
  FChecklist.FieldDefs.Add('Done', ftBoolean);
  FLayout.OpenDataSet(FChecklist);
  for I := 0 to count - 1 do
    for c := 0 to 1 + I mod 3 do
    begin
      FChecklist.Append;
      FChecklist.FieldByName('ItemID').AsInteger := I * 10 + c;
      FChecklist.FieldByName('TaskID').AsInteger := I + 1;
      FChecklist.FieldByName('Item').AsString := ChecklistItems[c mod Length(ChecklistItems)];
      FChecklist.FieldByName('Done').AsBoolean := c < I mod 3;
      FChecklist.Post;
    end;
  FChecklist.First;
  FChecklist.FieldByName('ItemID').Visible := False;
  FChecklist.FieldByName('TaskID').Visible := False;
  FChecklistSource := FLayout.NewSource(FChecklist);
end;

procedure TForm1.CreateSettings;
begin
  FSettings := FLayout.AddSettingsPanel(Self);

  FLayout.AddCaption(FSettings, 'View');
  FViewRadios[dvBoard] := FLayout.AddRadio(FSettings, 'Kanban board', 'view', True, {$IFDEF WEBLIB}@{$ENDIF}ViewChanged);
  FViewRadios[dvPlanner] := FLayout.AddRadio(FSettings, 'Planner (one day per owner)', 'view', False, {$IFDEF WEBLIB}@{$ENDIF}ViewChanged);
  FViewRadios[dvTimeline] := FLayout.AddRadio(FSettings, 'Timeline', 'view', False, {$IFDEF WEBLIB}@{$ENDIF}ViewChanged);

  FLayout.AddCaption(FSettings, 'Board');
  FColumnsCheck := FLayout.AddCheck(FSettings, 'Columns from the status table', True, {$IFDEF WEBLIB}@{$ENDIF}BoardSettingChanged);
  FLanesCheck := FLayout.AddCheck(FSettings, 'Swimlanes per owner', False, {$IFDEF WEBLIB}@{$ENDIF}BoardSettingChanged);
  FLayout.AddText(FSettings, 'Drag a card to another column or lane: the status and the owner are written to the ' +
    'record and the planner, the timeline and the grid follow.', 24);

  FLayout.AddCaption(FSettings, 'Day of the planner and the timeline');
  FDayText := FLayout.AddText(FSettings, '', 24);
  FLayout.AddButton(FSettings, 'Previous day', {$IFDEF WEBLIB}@{$ENDIF}PreviousDayClick);
  FLayout.AddButton(FSettings, 'Next day', {$IFDEF WEBLIB}@{$ENDIF}NextDayClick);

  FLayout.AddCaption(FSettings, 'Records');
  FGridCheck := FLayout.AddCheck(FSettings, 'Task grid with navigator', True, {$IFDEF WEBLIB}@{$ENDIF}GridCheckChanged);
  FStatus := FLayout.AddText(FSettings, 'Nothing written yet.', 96);
end;

procedure TForm1.CreateBoard;
begin
  FBoard := TTMSFNCKanbanBoard.Create(Self);
  FBoard.Parent := FContent;
  FLayout.Place(FBoard, daClient, 0, 0, 0, 0, 0);
  FBoard.Interaction.DragDropMode := kbdmMove;
  FBoard.DataOptions.KeyField := 'ID';
  FBoard.DataOptions.StatusField := 'Status';
  FBoard.DataOptions.TitleField := 'Title';
  FBoard.DataOptions.TextField := 'Notes';
  FBoard.DataOptions.OrderField := 'Position';
  FBoard.DataOptions.ColumnKeyField := 'Code';
  FBoard.DataOptions.ColumnTextField := 'Name';
  FBoard.DataOptions.ColumnOrderField := 'SortOrder';
  FBoard.DataOptions.ColumnLimitField := 'WIPLimit';
  FBoard.DataOptions.LaneKeyField := 'OwnerID';
  FBoard.DataOptions.LaneTextField := 'Name';
  FBoard.DataOptions.LaneOrderField := 'SortOrder';
  FBoard.DataOptions.Detail.DataSource := FChecklistSource;
  FBoard.DataOptions.Detail.DetailField := 'TaskID';
  FBoard.DataOptions.Detail.Target := FChecklistGrid;
  FBoard.OnDataError := {$IFDEF WEBLIB}@{$ENDIF}BoardDataError;
  BoardSettingChanged(nil);
  FBoard.DataSource := FTasksSource;
end;

procedure TForm1.CreatePlanner;
begin
  FPlanner := TTMSFNCPlanner.Create(Self);
  FPlanner.Parent := FContent;
  FLayout.Place(FPlanner, daClient, 0, 0, 0, 0, 0);
  FPlanner.Mode := pmDay;
  FPlanner.TimeLine.DisplayStart := 16;
  FPlanner.TimeLine.DisplayEnd := 37;
  FPlanner.DataOptions.KeyField := 'ID';
  FPlanner.DataOptions.StartTimeField := 'StartTime';
  FPlanner.DataOptions.EndTimeField := 'EndTime';
  FPlanner.DataOptions.TitleField := 'Title';
  FPlanner.DataOptions.TextField := 'Notes';
  FPlanner.DataOptions.ResourceField := 'OwnerID';
  FPlanner.DataOptions.ResourceSource := FOwnersSource;
  FPlanner.DataOptions.ResourceKeyField := 'OwnerID';
  FPlanner.DataOptions.ResourceTextField := 'Name';
  FPlanner.DataOptions.ResourceOrderField := 'SortOrder';
  FPlanner.DataOptions.Detail.DataSource := FChecklistSource;
  FPlanner.DataOptions.Detail.DetailField := 'TaskID';
  FPlanner.DataOptions.Detail.Target := FChecklistGrid;
  FPlanner.OnDataError := {$IFDEF WEBLIB}@{$ENDIF}PlannerDataError;
  FPlanner.DataSource := FTasksSource;
end;

procedure TForm1.CreateTimeline;
begin
  FTimeline := TTMSFNCTimeline.Create(Self);
  FTimeline.Parent := FContent;
  FLayout.Place(FTimeline, daClient, 0, 0, 0, 0, 0);
  { the working hours of the day of the planner (Previous / Next day): a week in one strip put every task in a few
    pixels with the titles on top of each other }
  FTimeline.Range.RangeType := tlrHour;
  FTimeline.DataOptions.KeyField := 'ID';
  FTimeline.DataOptions.StartField := 'StartTime';
  FTimeline.DataOptions.EndField := 'EndTime';
  FTimeline.DataOptions.TextField := 'Title';
  FTimeline.DataOptions.Detail.DataSource := FChecklistSource;
  FTimeline.DataOptions.Detail.DetailField := 'TaskID';
  FTimeline.DataOptions.Detail.Target := FChecklistGrid;
  FTimeline.OnDataError := {$IFDEF WEBLIB}@{$ENDIF}TimelineDataError;
  FTimeline.DataSource := FTasksSource;
end;

procedure TForm1.CreateContent;
var
  bottom, side: TTMSFNCPanel;
  nav: TTMSFNCDataNavigator;
begin
  FContent := FLayout.AddContentPanel(Self);

  { below the views, so the board keeps the full width: the checklist of the selected task on the right }
  bottom := FLayout.AddPanel(FContent, daBottom, 220, 0, 16, 0, 0);
  bottom.Fill.Kind := gfkNone;
  bottom.Stroke.Kind := gskNone;
  side := FLayout.AddPanel(bottom, daRight, 300, 16, 0, 0, 0);
  side.Fill.Kind := gfkNone;
  side.Stroke.Kind := gskNone;
  FLayout.AddCaption(side, 'Checklist of the selected task', 0);
  FChecklistGrid := TTMSFNCDataGrid.Create(Self);
  FChecklistGrid.Parent := side;
  FLayout.Place(FChecklistGrid, daClient, 0, 0, 0, 0, 0);
  FChecklistGrid.FixedColumnCount := 0;
  FChecklistGrid.DataOptions.ColumnStretch := gdcsLastColumn;
  FChecklistGrid.DataOptions.ShowIndicator := False;

  { the same tasks as records: a navigator and a grid }
  FGridPanel := FLayout.AddPanel(bottom, daClient, 0, 0, 0, 0, 0);
  FGridPanel.Fill.Kind := gfkNone;
  FGridPanel.Stroke.Kind := gskNone;
  nav := TTMSFNCDataNavigator.Create(Self);
  nav.Parent := FGridPanel;
  FLayout.Place(nav, daTop, 36, 0, 0, 0, 8);
  nav.DataSource := FTasksSource;
  FTaskGrid := TTMSFNCDataGrid.Create(Self);
  FTaskGrid.Parent := FGridPanel;
  FLayout.Place(FTaskGrid, daClient, 0, 0, 0, 0, 0);
  FTaskGrid.FixedColumnCount := 0;
  FTaskGrid.DataOptions.ColumnStretch := gdcsLastColumn;
  FTaskGrid.DataSource := FTasksSource;

  CreateBoard;
  CreatePlanner;
  CreateTimeline;
end;

procedure TForm1.ShowView(AView: TDemoView);
begin
  FBoard.Visible := AView = dvBoard;
  FPlanner.Visible := AView = dvPlanner;
  FTimeline.Visible := AView = dvTimeline;
end;

procedure TForm1.ShowDay;
begin
  FPlanner.ModeSettings.StartTime := FDay;
  FPlanner.ModeSettings.EndTime := FDay;
  FTimeline.Range.MinimumDate := FDay + 8 / 24;
  FTimeline.Range.MaximumDate := FDay + 18 / 24;
  FDayText.Text := FormatDateTime('dddd d mmmm', FDay);
end;

procedure TForm1.ViewChanged(Sender: TObject);
var
  v: TDemoView;
begin
  for v := Low(v) to High(v) do
    if FViewRadios[v].Checked then
      ShowView(v);
end;

procedure TForm1.BoardSettingChanged(Sender: TObject);
begin
  FBoard.BeginUpdate;
  if FColumnsCheck.Checked then
    FBoard.DataOptions.ColumnSource := FStatusesSource
  else
    FBoard.DataOptions.ColumnSource := nil;
  if FLanesCheck.Checked then
  begin
    FBoard.DataOptions.LaneField := 'OwnerID';
    FBoard.DataOptions.LaneSource := FOwnersSource;
  end
  else
  begin
    FBoard.DataOptions.LaneField := '';
    FBoard.DataOptions.LaneSource := nil;
  end;
  FBoard.EndUpdate;
end;

procedure TForm1.GridCheckChanged(Sender: TObject);
begin
  FGridPanel.Visible := FGridCheck.Checked;
end;

procedure TForm1.PreviousDayClick(Sender: TObject);
begin
  FDay := FDay - 1;
  ShowDay;
end;

procedure TForm1.NextDayClick(Sender: TObject);
begin
  FDay := FDay + 1;
  ShowDay;
end;

procedure TForm1.TaskPosted(DataSet: TDataSet);
var
  owner: string;
  id: Integer;
begin
  { every write-back of a view ends in a post of the tasks dataset }
  id := DataSet.FieldByName('OwnerID').AsInteger;
  if (id >= 1) and (id <= Length(FPeople)) then
    owner := FPeople[id - 1]
  else
    owner := 'nobody';
  FStatus.Text := 'Written: <b>' + DataSet.FieldByName('Title').AsString + '</b><br>' +
    DataSet.FieldByName('Status').AsString + ', ' + owner + ', ' +
    FormatDateTime('ddd hh:nn', DataSet.FieldByName('StartTime').AsDateTime) + ' to ' +
    FormatDateTime('hh:nn', DataSet.FieldByName('EndTime').AsDateTime);
end;

procedure TForm1.NewTask(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').AsInteger := FTasks.RecordCount + 1;
  DataSet.FieldByName('Title').AsString := 'New task';
  DataSet.FieldByName('Status').AsString := StatusCodes[0];
  DataSet.FieldByName('OwnerID').AsInteger := 1;
  DataSet.FieldByName('StartTime').AsDateTime := FDay + 9 / 24;
  DataSet.FieldByName('EndTime').AsDateTime := FDay + 10 / 24;
  DataSet.FieldByName('Position').AsInteger := FTasks.RecordCount;
end;

procedure TForm1.ShowError(const AMessage: string);
begin
  FStatus.Text := 'Not written: ' + AMessage;
end;

procedure TForm1.BoardDataError(Sender: TObject; AItem: TTMSFNCKanbanBoardItem; const AMessage: string; var AHandled: Boolean);
begin
  ShowError(AMessage);
  AHandled := True;
end;

procedure TForm1.PlannerDataError(Sender: TObject; AItem: TTMSFNCPlannerItem; const AMessage: string; var AHandled: Boolean);
begin
  ShowError(AMessage);
  AHandled := True;
end;

procedure TForm1.TimelineDataError(Sender: TObject; AItem: TCollectionItem; const AMessage: string; var AHandled: Boolean);
begin
  ShowError(AMessage);
  AHandled := True;
end;

end.
