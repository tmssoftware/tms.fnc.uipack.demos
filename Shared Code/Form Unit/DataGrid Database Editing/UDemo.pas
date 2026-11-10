unit UDemo;

{ TMS FNC UI Pack - DataGrid Database Editing

  A task list edited in the grid: a new row line at the bottom to type a new record, Enter on the last row that
  appends one, rows dragged into another order with the order written to a field, undo of the last edits with
  Ctrl+Z, insert and delete with a confirmation, Escape that cancels the row. The grid works on an in-memory
  dataset through its DataSource; every option has a switch on the left. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCDataGrid, VCL.TMSFNCSampleData, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCDataGrid, FMX.TMSFNCSampleData, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs, DB, WEBLib.DB, WEBLib.CDS,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton, WEBLib.TMSFNCDataGrid, WEBLib.TMSFNCSampleData,
  WEBLib.TMSFNCTheme, WEBLib.TMSFNCThemeSelector,
  {$ENDIF}
  UDemoLayout;

type
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
    FNewRowCheck: TTMSFNCCheckBox;
    FAppendCheck: TTMSFNCCheckBox;
    FDragCheck: TTMSFNCCheckBox;
    FMoveHintCheck: TTMSFNCCheckBox;
    FUndoCheck: TTMSFNCCheckBox;
    FInsertCheck: TTMSFNCCheckBox;
    FDeleteCheck: TTMSFNCCheckBox;
    FConfirmCheck: TTMSFNCCheckBox;
    FEscapeCheck: TTMSFNCCheckBox;
    FIndicatorCheck: TTMSFNCCheckBox;
    FStatus: TTMSFNCHTMLText;
    FTasks: TDemoDataSet;
    FSource: TDataSource;
    FGrid: TTMSFNCDataGrid;
    procedure CreateData;
    procedure CreateSettings;
    procedure CreateContent;
    procedure ApplySettings;
    procedure SettingChanged(Sender: TObject);
    procedure DataChange(Sender: TObject; Field: TField);
    procedure NewRecord(DataSet: TDataSet);
    procedure SortByOrderClick(Sender: TObject);
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

procedure TForm1.FormCreate(Sender: TObject);
begin
  FLayout := TDemoLayout.Create(Self);
  CreateData;
  CreateSettings;
  CreateContent;
  ApplySettings;
  DataChange(nil, nil);
end;

procedure TForm1.CreateData;
var
  tasks: TArray<TTMSFNCSampleProjectTask>;
  I: Integer;
begin
  { the sample project tasks; Position carries the order the user drags the rows into }
  FTasks := FLayout.NewDataSet;
  FTasks.FieldDefs.Add('Position', ftInteger);
  FTasks.FieldDefs.Add('Project', ftString, 30);
  FTasks.FieldDefs.Add('Task', ftString, 60);
  FTasks.FieldDefs.Add('Owner', ftString, 30);
  FTasks.FieldDefs.Add('Status', ftString, 20);
  FTasks.FieldDefs.Add('Progress', ftInteger);
  FLayout.OpenDataSet(FTasks);
  tasks := TTMSFNCSampleData.ProjectTasks;
  for I := 0 to High(tasks) do
  begin
    FTasks.Append;
    FTasks.FieldByName('Position').AsInteger := I + 1;
    FTasks.FieldByName('Project').AsString := tasks[I].Project;
    FTasks.FieldByName('Task').AsString := tasks[I].Task;
    FTasks.FieldByName('Owner').AsString := tasks[I].Owner;
    FTasks.FieldByName('Status').AsString := tasks[I].Status;
    FTasks.FieldByName('Progress').AsInteger := tasks[I].Progress;
    FTasks.Post;
  end;
  FTasks.First;
  FTasks.OnNewRecord := {$IFDEF WEBLIB}@{$ENDIF}NewRecord;
  FSource := FLayout.NewSource(FTasks);
  FSource.OnDataChange := {$IFDEF WEBLIB}@{$ENDIF}DataChange;
end;

procedure TForm1.CreateSettings;
begin
  FSettings := FLayout.AddSettingsPanel(Self, 280);

  FLayout.AddCaption(FSettings, 'New records');
  FNewRowCheck := FLayout.AddCheck(FSettings, 'New row line at the bottom', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FAppendCheck := FLayout.AddCheck(FSettings, 'Enter on the last row appends', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FInsertCheck := FLayout.AddCheck(FSettings, 'Insert key inserts a record', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Order');
  FDragCheck := FLayout.AddCheck(FSettings, 'Drag rows into another order', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FMoveHintCheck := FLayout.AddCheck(FSettings, 'Hint while a row is dragged', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FLayout.AddButton(FSettings, 'Sort by the Position field', {$IFDEF WEBLIB}@{$ENDIF}SortByOrderClick);

  FLayout.AddCaption(FSettings, 'Editing');
  FUndoCheck := FLayout.AddCheck(FSettings, 'Undo with Ctrl+Z (10 steps)', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FEscapeCheck := FLayout.AddCheck(FSettings, 'Escape cancels the row', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FDeleteCheck := FLayout.AddCheck(FSettings, 'Ctrl+Delete deletes a record', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FConfirmCheck := FLayout.AddCheck(FSettings, 'Confirm before deleting', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FIndicatorCheck := FLayout.AddCheck(FSettings, 'Record indicator column', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Dataset');
  FStatus := FLayout.AddText(FSettings, '', 60);
end;

procedure TForm1.CreateContent;
begin
  FContent := FLayout.AddContentPanel(Self);
  FGrid := TTMSFNCDataGrid.Create(Self);
  FGrid.Parent := FContent;
  FLayout.Place(FGrid, daClient, 0, 0, 0, 0, 0);
  FGrid.DataOptions.OrderField := 'Position';
  FGrid.DataOptions.NewRowText := 'Click here to add a task';
  FGrid.DataSource := FSource;
end;

procedure TForm1.ApplySettings;
begin
  FGrid.BeginUpdate;
  FGrid.DataOptions.NewRowLine := FNewRowCheck.Checked;
  FGrid.DataOptions.AppendOnLastRow := FAppendCheck.Checked;
  FGrid.DataOptions.AllowInsert := FInsertCheck.Checked;
  FGrid.DataOptions.RowDragging := FDragCheck.Checked;
  FGrid.DataOptions.ShowMoveHint := FMoveHintCheck.Checked;
  FGrid.DataOptions.AllowUndo := FUndoCheck.Checked;
  FGrid.DataOptions.CancelOnEscape := FEscapeCheck.Checked;
  FGrid.DataOptions.AllowDelete := FDeleteCheck.Checked;
  FGrid.DataOptions.ConfirmDelete := FConfirmCheck.Checked;
  FGrid.DataOptions.ShowIndicator := FIndicatorCheck.Checked;
  FGrid.EndUpdate;
end;

procedure TForm1.SettingChanged(Sender: TObject);
begin
  ApplySettings;
end;

procedure TForm1.DataChange(Sender: TObject; Field: TField);
var
  s: string;
begin
  if not Assigned(FStatus) or not FTasks.Active then
    Exit;
  case FTasks.State of
    dsEdit: s := 'editing';
    dsInsert: s := 'inserting';
  else
    s := 'browsing';
  end;
  FStatus.Text := IntToStr(FTasks.RecordCount) + ' tasks, ' + s + '<br>Current position: <b>' +
    FTasks.FieldByName('Position').AsString + '</b>';
end;

procedure TForm1.NewRecord(DataSet: TDataSet);
begin
  { a new task starts with sensible values; the grid fills the Position from the drop or the end of the list }
  DataSet.FieldByName('Project').AsString := 'Backlog';
  DataSet.FieldByName('Status').AsString := 'Planned';
  DataSet.FieldByName('Progress').AsInteger := 0;
end;

procedure TForm1.SortByOrderClick(Sender: TObject);
begin
  { the dataset sorted on the order field shows the rows in the order they were dragged into }
  {$IFNDEF WEBLIB}
  FTasks.IndexFieldNames := 'Position';
  {$ELSE}
  FStatus.Text := 'The browser dataset has no index: sort the Position column in the grid instead.';
  {$ENDIF}
end;

end.
