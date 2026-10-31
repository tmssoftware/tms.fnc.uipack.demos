unit UDemo;

{ TMS FNC UI Pack - TreeView Database Adapter

  Page "Self-referencing": one table where every record names its parent (ParentID). The adapter
  (Mode tamSelfReferencing) builds the tree, loads children when a node expands (LoadMode
  tlmOnExpand), writes names edited in place back to the record (taoEdit), moves a record to another
  parent when a node is dropped onto another node (taoReparent) and keeps the selected node and the
  current record in sync (taoSyncSelection).
  Page "Levels": two linked tables, departments and their employees (Mode tamLevels).

  The data lives in in-memory datasets created in code: TFDMemTable (FMX, VCL) and TWebClientDataSet
  (WEB). }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCTabSet,
  VCL.TMSFNCTreeViewBase, VCL.TMSFNCTreeViewData, VCL.TMSFNCCustomTreeView, VCL.TMSFNCTreeView,
  VCL.TMSFNCTreeViewDatabaseAdapter, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector;
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCTabSet,
  FMX.TMSFNCTreeViewBase, FMX.TMSFNCTreeViewData, FMX.TMSFNCCustomTreeView, FMX.TMSFNCTreeView,
  FMX.TMSFNCTreeViewDatabaseAdapter, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector;
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs, DB, WEBLib.DB,
  WEBLib.CDS,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCTabSet, WEBLib.TMSFNCTreeViewBase, WEBLib.TMSFNCTreeViewData,
  WEBLib.TMSFNCCustomTreeView, WEBLib.TMSFNCTreeView, WEBLib.TMSFNCTreeViewDatabaseAdapter,
  WEBLib.TMSFNCTheme, WEBLib.TMSFNCThemeSelector;
  {$ENDIF}

type
  {$IFDEF WEBLIB}
  TDemoDataSet = TWebClientDataSet;
  TDemoForm = TWebForm;
  {$ENDIF}
  {$IFNDEF WEBLIB}
  TDemoDataSet = TFDMemTable;
  TDemoForm = TForm;
  {$ENDIF}

  TDemoAlign = (daTop, daLeft, daClient);

  TForm1 = class(TDemoForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TTMSFNCPanel;
    DemoTitle: TTMSFNCHTMLText;
    DemoDescription: TTMSFNCHTMLText;
    DemoThemeSelector: TTMSFNCThemeSelector;
    procedure FormCreate(Sender: TObject);
  private
    FNextID: Integer;
    FPlaceOrder: Integer;
    { data }
    FUnits: TDemoDataSet;
    FDepartments: TDemoDataSet;
    FEmployees: TDemoDataSet;
    FUnitsSource: TDataSource;
    FDepartmentsSource: TDataSource;
    FEmployeesSource: TDataSource;
    { settings }
    FSettings: TTMSFNCPanel;
    FLazyCheck: TTMSFNCCheckBox;
    FEditCheck: TTMSFNCCheckBox;
    FDragCheck: TTMSFNCCheckBox;
    FCurrentText: TTMSFNCHTMLText;
    { content }
    FContent: TTMSFNCPanel;
    FTabs: TTMSFNCTabSet;
    FPages: array[0..1] of TTMSFNCPanel;
    FTrees: array[0..1] of TTMSFNCTreeView;
    FAdapters: array[0..1] of TTMSFNCTreeViewDatabaseAdapter;
    function DemoSize(AValue: Integer): Integer;
    procedure Place(AControl: TControl; AAlign: TDemoAlign; ASize, ALeft, ATop, ARight, ABottom: Integer);
    function AddCaption(AParent: TTMSFNCPanel; const AText: string; ATop: Integer): TTMSFNCHTMLText;
    function AddText(AParent: TTMSFNCPanel; const AText: string; AHeight: Integer): TTMSFNCHTMLText;
    function AddCheck(AParent: TTMSFNCPanel; const AText: string; AChecked: Boolean): TTMSFNCCheckBox;
    function AddButton(AParent: TTMSFNCPanel; const AText: string; AOnClick: TNotifyEvent): TTMSFNCButton;
    function NewDataSet: TDemoDataSet;
    procedure OpenDataSet(ADataSet: TDemoDataSet);
    function NewSource(ADataSet: TDataSet): TDataSource;
    procedure AddUnit(AID, AParentID: Integer; const AName: string);
    procedure CreateData;
    procedure CreateSettings;
    procedure CreatePages;
    function ActiveAdapter: TTMSFNCTreeViewDatabaseAdapter;
    procedure ApplySettings;
    procedure SettingChanged(Sender: TObject);
    procedure AddChildClick(Sender: TObject);
    procedure AddRootClick(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure TabChanged(Sender: TObject; APreviousTabIndex, ACurrentTabIndex: Integer);
    procedure UnitsDataChange(Sender: TObject; Field: TField);
    procedure NodeToFields(Sender: TObject; ANode: TTMSFNCTreeViewNode; ALevel: Integer; AFields: TFields);
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

{ layout helpers: the same code for FMX, VCL and WEB }

{ a size in pixels at 96 DPI for the form's DPI (VCL: the form is scaled when it loads, controls made in code are
  not); FMX and WEB work in device independent pixels }
function TForm1.DemoSize(AValue: Integer): Integer;
begin
  {$IFDEF VCL}
  Result := MulDiv(AValue, CurrentPPI, 96);
  {$ELSE}
  Result := AValue;
  {$ENDIF}
end;

procedure TForm1.Place(AControl: TControl; AAlign: TDemoAlign; ASize, ALeft, ATop, ARight, ABottom: Integer);
begin
  { after the controls aligned before it: a position beyond every earlier one (VCL and WEB order controls of the
    same alignment by their position less their margin, so the steps are larger than any margin) }
  Inc(FPlaceOrder);
  {$IFDEF FMX}
  AControl.Position.Y := 100000 + FPlaceOrder * 1000;
  AControl.Position.X := 100000 + FPlaceOrder * 1000;
  {$ELSE}
  AControl.Top := 100000 + FPlaceOrder * 1000;
  AControl.Left := 100000 + FPlaceOrder * 1000;
  {$ENDIF}
  {$IFDEF FMX}
  case AAlign of
    daTop: begin AControl.Align := TAlignLayout.Top; AControl.Height := ASize; end;
    daLeft: begin AControl.Align := TAlignLayout.Left; AControl.Width := ASize; end;
    daClient: AControl.Align := TAlignLayout.Client;
  end;
  AControl.Margins.Rect := RectF(ALeft, ATop, ARight, ABottom);
  {$ELSE}
  case AAlign of
    daTop: begin AControl.Align := alTop; AControl.Height := DemoSize(ASize); end;
    daLeft: begin AControl.Align := alLeft; AControl.Width := DemoSize(ASize); end;
    daClient: AControl.Align := alClient;
  end;
  AControl.AlignWithMargins := True;
  AControl.Margins.Left := DemoSize(ALeft);
  AControl.Margins.Top := DemoSize(ATop);
  AControl.Margins.Right := DemoSize(ARight);
  AControl.Margins.Bottom := DemoSize(ABottom);
  {$ENDIF}
end;

function TForm1.AddCaption(AParent: TTMSFNCPanel; const AText: string; ATop: Integer): TTMSFNCHTMLText;
begin
  Result := TTMSFNCHTMLText.Create(Self);
  Result.Parent := AParent;
  Place(Result, daTop, 24, 16, ATop, 16, 4);
  Result.Text := AText;
  Result.HorizontalTextAlign := gtaLeading;
  Result.Fill.Kind := gfkNone;
  Result.Stroke.Kind := gskNone;
  { 13 px, as the section captions of the Theming Dashboard }
  {$IFDEF FMX}
  Result.Font.Size := 13;
  Result.Font.Style := [TFontStyle.fsBold];
  {$ELSE}
  Result.Font.Height := -DemoSize(13);
  Result.Font.Style := [fsBold];
  {$ENDIF}
end;

function TForm1.AddText(AParent: TTMSFNCPanel; const AText: string; AHeight: Integer): TTMSFNCHTMLText;
begin
  Result := TTMSFNCHTMLText.Create(Self);
  Result.Parent := AParent;
  Place(Result, daTop, AHeight, 16, 4, 16, 4);
  Result.Text := AText;
  Result.TextRole := htrSecondary;
  Result.HorizontalTextAlign := gtaLeading;
  Result.VerticalTextAlign := gtaLeading;
  Result.WordWrapping := True;
  Result.Fill.Kind := gfkNone;
  Result.Stroke.Kind := gskNone;
end;

function TForm1.AddCheck(AParent: TTMSFNCPanel; const AText: string; AChecked: Boolean): TTMSFNCCheckBox;
begin
  Result := TTMSFNCCheckBox.Create(Self);
  Result.Parent := AParent;
  Place(Result, daTop, 32, 16, 0, 16, 0);
  Result.Text := AText;
  Result.Checked := AChecked;
  Result.OnChange := {$IFDEF WEBLIB}@{$ENDIF}SettingChanged;
end;

function TForm1.AddButton(AParent: TTMSFNCPanel; const AText: string; AOnClick: TNotifyEvent): TTMSFNCButton;
begin
  Result := TTMSFNCButton.Create(Self);
  Result.Parent := AParent;
  Place(Result, daTop, 32, 16, 8, 16, 0);
  Result.Text := AText;
  Result.OnClick := AOnClick;
end;

{ data }

function TForm1.NewDataSet: TDemoDataSet;
begin
  Result := TDemoDataSet.Create(Self);
end;

procedure TForm1.OpenDataSet(ADataSet: TDemoDataSet);
begin
  { an empty in-memory dataset with the field definitions (WEB: opening it creates it) }
  {$IFDEF WEBLIB}
  ADataSet.Active := True;
  {$ELSE}
  ADataSet.CreateDataSet;
  ADataSet.LogChanges := False;
  {$ENDIF}
end;

function TForm1.NewSource(ADataSet: TDataSet): TDataSource;
begin
  {$IFDEF WEBLIB}
  Result := TWebDataSource.Create(Self);
  {$ELSE}
  Result := TDataSource.Create(Self);
  {$ENDIF}
  Result.DataSet := ADataSet;
end;

procedure TForm1.AddUnit(AID, AParentID: Integer; const AName: string);
begin
  FUnits.Append;
  FUnits.FieldByName('ID').AsInteger := AID;
  if AParentID > 0 then
    FUnits.FieldByName('ParentID').AsInteger := AParentID;
  FUnits.FieldByName('Name').AsString := AName;
  FUnits.Post;
end;

procedure TForm1.CreateData;
const
  Departments: array[0..3] of string = ('Development', 'Sales', 'Support', 'Marketing');
  Employees: array[0..11] of string = ('Ann Becker', 'Bruno Costa', 'Chen Wei', 'Dana Ilic', 'Emil Novak',
    'Fatima Haddad', 'Gert Jansen', 'Hana Sato', 'Ivo Peeters', 'Jade Moreau', 'Karim Aziz', 'Lena Vogel');
var
  I: Integer;
begin
  { a self-referencing table: every unit names its parent; roots have no parent }
  FUnits := NewDataSet;
  FUnits.FieldDefs.Add('ID', ftInteger);
  FUnits.FieldDefs.Add('ParentID', ftInteger);
  FUnits.FieldDefs.Add('Name', ftString, 40);
  OpenDataSet(FUnits);
  AddUnit(1, 0, 'TMS Software');
  AddUnit(2, 1, 'Development');
  AddUnit(3, 2, 'FNC components');
  AddUnit(4, 3, 'UI Pack');
  AddUnit(5, 3, 'Core');
  AddUnit(6, 3, 'Cloud Pack');
  AddUnit(7, 3, 'Maps');
  AddUnit(8, 2, 'VCL components');
  AddUnit(9, 8, 'Grid');
  AddUnit(10, 8, 'Planner');
  AddUnit(11, 2, 'WEB Core');
  AddUnit(12, 11, 'Compiler');
  AddUnit(13, 11, 'Component library');
  AddUnit(14, 1, 'Sales');
  AddUnit(15, 14, 'Europe');
  AddUnit(16, 14, 'Americas');
  AddUnit(17, 14, 'Asia Pacific');
  AddUnit(18, 1, 'Support');
  AddUnit(19, 18, 'Helpdesk');
  AddUnit(20, 18, 'Forum');
  AddUnit(21, 18, 'Documentation');
  AddUnit(22, 0, 'Partners');
  AddUnit(23, 22, 'Resellers');
  AddUnit(24, 22, 'Consultants');
  AddUnit(25, 22, 'Training centres');
  FNextID := 100;
  FUnits.First;
  FUnitsSource := NewSource(FUnits);
  FUnitsSource.OnDataChange := {$IFDEF WEBLIB}@{$ENDIF}UnitsDataChange;

  { two linked tables: departments (level 0) and their employees (level 1, DeptID) }
  FDepartments := NewDataSet;
  FDepartments.FieldDefs.Add('ID', ftInteger);
  FDepartments.FieldDefs.Add('Name', ftString, 40);
  OpenDataSet(FDepartments);
  for I := 0 to Length(Departments) - 1 do
  begin
    FDepartments.Append;
    FDepartments.FieldByName('ID').AsInteger := I + 1;
    FDepartments.FieldByName('Name').AsString := Departments[I];
    FDepartments.Post;
  end;
  FDepartments.First;
  FDepartmentsSource := NewSource(FDepartments);

  FEmployees := NewDataSet;
  FEmployees.FieldDefs.Add('ID', ftInteger);
  FEmployees.FieldDefs.Add('DeptID', ftInteger);
  FEmployees.FieldDefs.Add('Name', ftString, 40);
  OpenDataSet(FEmployees);
  for I := 0 to Length(Employees) - 1 do
  begin
    FEmployees.Append;
    FEmployees.FieldByName('ID').AsInteger := 101 + I;
    FEmployees.FieldByName('DeptID').AsInteger := I mod Length(Departments) + 1;
    FEmployees.FieldByName('Name').AsString := Employees[I];
    FEmployees.Post;
  end;
  FEmployees.First;
  FEmployeesSource := NewSource(FEmployees);
end;

{ user interface }

procedure TForm1.CreateSettings;
begin
  FSettings := TTMSFNCPanel.Create(Self);
  FSettings.Parent := Self;
  Place(FSettings, daLeft, 260, 16, 0, 0, 16);
  FSettings.Header.Visible := False;

  AddCaption(FSettings, 'Tree', 16);
  FLazyCheck := AddCheck(FSettings, 'Load children on expand', True);
  FEditCheck := AddCheck(FSettings, 'Edit names in place', True);
  FDragCheck := AddCheck(FSettings, 'Drag and drop to move', True);

  AddCaption(FSettings, 'Records', 16);
  AddButton(FSettings, 'Add child', {$IFDEF WEBLIB}@{$ENDIF}AddChildClick);
  AddButton(FSettings, 'Add root', {$IFDEF WEBLIB}@{$ENDIF}AddRootClick);
  AddButton(FSettings, 'Delete', {$IFDEF WEBLIB}@{$ENDIF}DeleteClick);

  AddCaption(FSettings, 'Current record', 16);
  FCurrentText := AddText(FSettings, '', 44);
  AddText(FSettings, 'The selected node and the current record of the dataset follow each other. ' +
    'Click a selected node to edit its name; a deleted record''s children move up to its parent.', 96);
end;

procedure TForm1.CreatePages;
var
  I: Integer;
  lv: TTMSFNCTreeViewDatabaseAdapterLevel;
begin
  FContent := TTMSFNCPanel.Create(Self);
  FContent.Parent := Self;
  Place(FContent, daClient, 0, 16, 0, 16, 16);
  FContent.Header.Visible := False;
  FContent.Fill.Kind := gfkNone;
  FContent.Stroke.Kind := gskNone;

  FTabs := TTMSFNCTabSet.Create(Self);
  FTabs.Parent := FContent;
  Place(FTabs, daTop, 36, 0, 0, 0, 0);
  FTabs.Tabs.Clear;
  FTabs.Tabs.Add.Text := 'Self-referencing';
  FTabs.Tabs.Add.Text := 'Levels';
  FTabs.ActiveTabIndex := 0;
  FTabs.OnChangeTab := {$IFDEF WEBLIB}@{$ENDIF}TabChanged;

  for I := 0 to 1 do
  begin
    FPages[I] := TTMSFNCPanel.Create(Self);
    FPages[I].Parent := FContent;
    Place(FPages[I], daClient, 0, 0, 0, 0, 0);
    FPages[I].Header.Visible := False;
    FPages[I].Stroke.Kind := gskNone;
    FPages[I].Visible := I = 0;

    FTrees[I] := TTMSFNCTreeView.Create(Self);
    FTrees[I].Parent := FPages[I];
    Place(FTrees[I], daClient, 0, 0, 0, 0, 0);
    FTrees[I].Interaction.DragDropMode := tdmMove;
    FTrees[I].Columns.Clear;
    if I = 0 then
      FTrees[I].Columns.Add.Text := 'Organisation unit'
    else
      FTrees[I].Columns.Add.Text := 'Department and employees';

    FAdapters[I] := TTMSFNCTreeViewDatabaseAdapter.Create(Self);
    FAdapters[I].TreeView := FTrees[I];
    FAdapters[I].OnNodeToFields := {$IFDEF WEBLIB}@{$ENDIF}NodeToFields;
  end;

  { page 1: a self-referencing table, children loaded when a node expands }
  FAdapters[0].Mode := tamSelfReferencing;
  FAdapters[0].KeyField := 'ID';
  FAdapters[0].ParentField := 'ParentID';
  FAdapters[0].TextField := 'Name';
  FAdapters[0].ExpandLevel := 1;
  FAdapters[0].DeleteChildrenMode := tdcReparent;
  FAdapters[0].DataSource := FUnitsSource;

  { page 2: departments with their employees }
  FAdapters[1].Mode := tamLevels;
  FAdapters[1].KeyField := 'ID';
  FAdapters[1].TextField := 'Name';
  FAdapters[1].ExpandLevel := 1;
  FAdapters[1].DataSource := FDepartmentsSource;
  lv := FAdapters[1].Levels.Add;
  lv.DataSource := FEmployeesSource;
  lv.KeyField := 'ID';
  lv.MasterKeyField := 'DeptID';
  lv.TextField := 'Name';

  ApplySettings;
  for I := 0 to 1 do
    FAdapters[I].Active := True;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  CreateData;
  CreateSettings;
  CreatePages;
  UnitsDataChange(nil, nil);
end;

function TForm1.ActiveAdapter: TTMSFNCTreeViewDatabaseAdapter;
begin
  Result := FAdapters[FTabs.ActiveTabIndex];
end;

procedure TForm1.ApplySettings;
var
  I: Integer;
  o: TTMSFNCTreeViewDatabaseAdapterOptions;
begin
  for I := 0 to 1 do
  begin
    if FLazyCheck.Checked then
      FAdapters[I].LoadMode := tlmOnExpand
    else
      FAdapters[I].LoadMode := tlmAll;
    o := [taoSyncSelection, taoInsert, taoDelete];
    if FEditCheck.Checked then
      Include(o, taoEdit);
    if FDragCheck.Checked then
      Include(o, taoReparent);
    FAdapters[I].Options := o;
    FTrees[I].Interaction.ReadOnly := not FEditCheck.Checked;
    { the in-place editor of the column; the adapter writes the edited text to the field (taoEdit) }
    if FEditCheck.Checked then
      FTrees[I].Columns[0].EditorType := tcetEdit
    else
      FTrees[I].Columns[0].EditorType := tcetNone;
    if FDragCheck.Checked then
      FTrees[I].Interaction.DragDropMode := tdmMove
    else
      FTrees[I].Interaction.DragDropMode := tdmNone;
  end;
end;

procedure TForm1.SettingChanged(Sender: TObject);
begin
  ApplySettings;
end;

procedure TForm1.TabChanged(Sender: TObject; APreviousTabIndex, ACurrentTabIndex: Integer);
var
  I: Integer;
begin
  for I := 0 to 1 do
    FPages[I].Visible := I = ACurrentTabIndex;
end;

procedure TForm1.NodeToFields(Sender: TObject; ANode: TTMSFNCTreeViewNode; ALevel: Integer; AFields: TFields);
begin
  { a record added with AddRecord (ANode is nil): give it a key and a name }
  if not Assigned(ANode) and (AFields.DataSet.State = dsInsert) then
  begin
    Inc(FNextID);
    AFields.FieldByName('ID').AsInteger := FNextID;
    AFields.FieldByName('Name').AsString := 'New item ' + IntToStr(FNextID);
  end;
end;

procedure TForm1.AddChildClick(Sender: TObject);
var
  a: TTMSFNCTreeViewDatabaseAdapter;
  n: TTMSFNCTreeViewNode;
begin
  a := ActiveAdapter;
  n := a.TreeView.SelectedNode;
  if Assigned(n) then
  begin
    n := a.AddRecord(n);
    if Assigned(n) then
      a.TreeView.SelectNode(n);
  end;
end;

procedure TForm1.AddRootClick(Sender: TObject);
var
  a: TTMSFNCTreeViewDatabaseAdapter;
  n: TTMSFNCTreeViewNode;
begin
  a := ActiveAdapter;
  n := a.AddRecord(nil);
  if Assigned(n) then
    a.TreeView.SelectNode(n);
end;

procedure TForm1.DeleteClick(Sender: TObject);
var
  a: TTMSFNCTreeViewDatabaseAdapter;
begin
  a := ActiveAdapter;
  if Assigned(a.TreeView.SelectedNode) then
    a.DeleteRecord(a.TreeView.SelectedNode);
end;

procedure TForm1.UnitsDataChange(Sender: TObject; Field: TField);
var
  s: string;
begin
  if not Assigned(FCurrentText) or not Assigned(FUnits) or not FUnits.Active then
    Exit;
  if FUnits.IsEmpty then
    s := 'No records'
  else
  begin
    s := '<b>' + FUnits.FieldByName('Name').AsString + '</b><br>ID ' + FUnits.FieldByName('ID').AsString;
    if FUnits.FieldByName('ParentID').IsNull then
      s := s + ', a root'
    else
      s := s + ', parent ' + FUnits.FieldByName('ParentID').AsString;
  end;
  FCurrentText.Text := s;
end;

end.
