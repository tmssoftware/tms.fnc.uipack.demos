unit UDemo;

{ TMS FNC UI Pack - Master-Detail Explorer

  Three pages of one data grid. Database: customers with their orders and, nested under an order, its lines, from
  three datasets linked through MasterSource; expand a customer, switch the detail template (grid, form, tabs) and
  its placement (inline, side panel, linked grid), show a summary on the master rows, keep the master row sticky,
  edit in the detail. Without a database: the detail of a row comes from OnGetDetailData, with tabs. Tree grid:
  self-referencing rows (key and parent column) as a tree with aggregates per node and children loaded on expand. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCDataGrid, VCL.TMSFNCDataGridRenderer, VCL.TMSFNCSampleData, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCDataGrid, FMX.TMSFNCDataGridRenderer, FMX.TMSFNCSampleData, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs, DB, WEBLib.DB, WEBLib.CDS,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton, WEBLib.TMSFNCDataGrid, WEBLib.TMSFNCDataGridRenderer,
  WEBLib.TMSFNCSampleData, WEBLib.TMSFNCTheme, WEBLib.TMSFNCThemeSelector,
  {$ENDIF}
  UDemoLayout;

type
  TDemoPage = (dpDatabase, dpPlain, dpTree);

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
    FPage: TDemoPage;
    FPageRadios: array[TDemoPage] of TTMSFNCRadioButton;
    FTemplateRadios: array[TTMSFNCDataGridMasterDetailTemplate] of TTMSFNCRadioButton;
    FPlacementRadios: array[TTMSFNCDataGridMasterDetailPlacement] of TTMSFNCRadioButton;
    FSummaryCheck: TTMSFNCCheckBox;
    FStickyCheck: TTMSFNCCheckBox;
    FMultipleCheck: TTMSFNCCheckBox;
    FAnimateCheck: TTMSFNCCheckBox;
    FEditingCheck: TTMSFNCCheckBox;
    FNestedCheck: TTMSFNCCheckBox;
    FLazyCheck: TTMSFNCCheckBox;
    FAggregateCheck: TTMSFNCCheckBox;
    FStatus: TTMSFNCHTMLText;
    FDataGrid: TTMSFNCDataGrid;
    FPlainGrid: TTMSFNCDataGrid;
    FTreeGrid: TTMSFNCDataGrid;
    FTarget: TTMSFNCDataGrid;
    FTargetPanel: TTMSFNCPanel;
    {$IFNDEF WEBLIB}
    FCustomers: TDemoDataSet;
    FOrders: TDemoDataSet;
    FLines: TDemoDataSet;
    FCustomersSource: TDataSource;
    FOrdersSource: TDataSource;
    FLinesSource: TDataSource;
    procedure CreateData;
    {$ENDIF}
    procedure CreateSettings;
    procedure CreateContent;
    function NewGrid(AParent: TDemoParent): TTMSFNCDataGrid;
    procedure FillPlainGrid;
    procedure FillTreeGrid;
    procedure ApplySettings;
    procedure ShowPage(APage: TDemoPage);
    function ActiveGrid: TTMSFNCDataGrid;
    procedure PageChanged(Sender: TObject);
    procedure SettingChanged(Sender: TObject);
    procedure TreeSettingChanged(Sender: TObject);
    procedure ExpandAllClick(Sender: TObject);
    procedure CollapseAllClick(Sender: TObject);
    procedure GetDetailData(Sender: TObject; AMaster: TTMSFNCDataGridRenderer; AMasterRow, ATab: Integer;
      ADetail: TTMSFNCDataGridRenderer; var ANested: Boolean);
    procedure GetTreeChildren(Sender: TObject; ARow: Integer; const AKey: string);
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
  Cities: array[0..7] of string = ('Seattle', 'Brussels', 'Ghent', 'Lyon', 'Austin', 'Rotterdam', 'Porto', 'Graz');
  Products: array[0..5] of string = ('Desk lamp', 'Monitor arm', 'Keyboard', 'Headset', 'Docking station', 'Webcam');
  Prices: array[0..5] of Double = (39.5, 89, 64.9, 129, 199, 59);
  Contacts: array[0..3] of string = ('Purchasing', 'Accounting', 'Warehouse', 'Management');
  MiddleDot = #$00B7;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FLayout := TDemoLayout.Create(Self);
  {$IFNDEF WEBLIB}
  CreateData;
  {$ENDIF}
  CreateSettings;
  CreateContent;
  {$IFDEF WEBLIB}
  ShowPage(dpPlain);
  {$ELSE}
  ShowPage(dpDatabase);
  {$ENDIF}
end;

{$IFNDEF WEBLIB}
procedure TForm1.CreateData;
var
  names: TArray<string>;
  orders: TArray<TTMSFNCSampleOrder>;
  I, L, c, p, lineID: Integer;
begin
  { customers, the master table }
  names := TTMSFNCSampleData.Customers;
  FCustomers := FLayout.NewDataSet;
  FCustomers.FieldDefs.Add('CustomerID', ftInteger);
  FCustomers.FieldDefs.Add('Company', ftString, 40);
  FCustomers.FieldDefs.Add('City', ftString, 30);
  FLayout.OpenDataSet(FCustomers);
  for I := 0 to High(names) do
  begin
    FCustomers.Append;
    FCustomers.FieldByName('CustomerID').AsInteger := I + 1;
    FCustomers.FieldByName('Company').AsString := names[I];
    FCustomers.FieldByName('City').AsString := Cities[I mod Length(Cities)];
    FCustomers.Post;
  end;
  FCustomers.FieldByName('CustomerID').Visible := False;
  FCustomers.First;
  FCustomersSource := FLayout.NewSource(FCustomers);

  { orders, linked to the customers: the grid finds this detail table through MasterSource }
  FOrders := FLayout.NewDataSet;
  FOrders.FieldDefs.Add('OrderID', ftInteger);
  FOrders.FieldDefs.Add('CustomerID', ftInteger);
  FOrders.FieldDefs.Add('Number', ftString, 10);
  FOrders.FieldDefs.Add('OrderDate', ftDate);
  FOrders.FieldDefs.Add('Status', ftString, 20);
  FOrders.FieldDefs.Add('Total', ftFloat);
  FLayout.OpenDataSet(FOrders);
  orders := TTMSFNCSampleData.Orders;
  for I := 0 to High(orders) do
  begin
    c := 1;
    while (c <= Length(names)) and (names[c - 1] <> orders[I].Customer) do
      Inc(c);
    if c > Length(names) then
      c := 1 + I mod Length(names);
    FOrders.Append;
    FOrders.FieldByName('OrderID').AsInteger := I + 1;
    FOrders.FieldByName('CustomerID').AsInteger := c;
    FOrders.FieldByName('Number').AsString := orders[I].Number;
    FOrders.FieldByName('OrderDate').AsDateTime := orders[I].Date;
    FOrders.FieldByName('Status').AsString := orders[I].Status;
    FOrders.FieldByName('Total').AsFloat := orders[I].Total;
    FOrders.Post;
  end;
  FOrders.FieldByName('OrderID').Visible := False;
  FOrders.FieldByName('Number').DisplayLabel := 'Order';
  FOrders.FieldByName('OrderDate').DisplayLabel := 'Date';
  TFloatField(FOrders.FieldByName('Total')).DisplayFormat := '#,##0.00';
  FOrders.IndexFieldNames := 'CustomerID';
  FOrders.MasterSource := FCustomersSource;
  FOrders.MasterFields := 'CustomerID';
  FOrdersSource := FLayout.NewSource(FOrders);

  { order lines, the nested level under an order }
  FLines := FLayout.NewDataSet;
  FLines.FieldDefs.Add('LineID', ftInteger);
  FLines.FieldDefs.Add('OrderID', ftInteger);
  FLines.FieldDefs.Add('Product', ftString, 30);
  FLines.FieldDefs.Add('Quantity', ftInteger);
  FLines.FieldDefs.Add('Price', ftFloat);
  FLayout.OpenDataSet(FLines);
  lineID := 0;
  for I := 0 to High(orders) do
    for L := 0 to 1 + I mod 3 do
    begin
      Inc(lineID);
      p := (I + L) mod Length(Products);
      FLines.Append;
      FLines.FieldByName('LineID').AsInteger := lineID;
      FLines.FieldByName('OrderID').AsInteger := I + 1;
      FLines.FieldByName('Product').AsString := Products[p];
      FLines.FieldByName('Quantity').AsInteger := 1 + (I + L) mod 4;
      FLines.FieldByName('Price').AsFloat := Prices[p];
      FLines.Post;
    end;
  FLines.FieldByName('LineID').Visible := False;
  TFloatField(FLines.FieldByName('Price')).DisplayFormat := '#,##0.00';
  FLines.IndexFieldNames := 'OrderID';
  FLines.MasterSource := FOrdersSource;
  FLines.MasterFields := 'OrderID';
  FLinesSource := FLayout.NewSource(FLines);
end;
{$ENDIF}

procedure TForm1.CreateSettings;
begin
  FSettings := FLayout.AddSettingsPanel(Self);

  FLayout.AddCaption(FSettings, 'Page');
  {$IFNDEF WEBLIB}
  FPageRadios[dpDatabase] := FLayout.AddRadio(FSettings, 'Customers, orders, lines (datasets)', 'page', True, {$IFDEF WEBLIB}@{$ENDIF}PageChanged);
  {$ENDIF}
  FPageRadios[dpPlain] := FLayout.AddRadio(FSettings, 'Without a database', 'page', {$IFDEF WEBLIB}True{$ELSE}False{$ENDIF}, {$IFDEF WEBLIB}@{$ENDIF}PageChanged);
  FPageRadios[dpTree] := FLayout.AddRadio(FSettings, 'Tree grid', 'page', False, {$IFDEF WEBLIB}@{$ENDIF}PageChanged);

  FLayout.AddCaption(FSettings, 'Detail template');
  FTemplateRadios[gmdtGrid] := FLayout.AddRadio(FSettings, 'Grid', 'template', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FTemplateRadios[gmdtForm] := FLayout.AddRadio(FSettings, 'Form', 'template', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FTemplateRadios[gmdtTabs] := FLayout.AddRadio(FSettings, 'Tabs', 'template', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Detail placement');
  FPlacementRadios[gmdpInline] := FLayout.AddRadio(FSettings, 'Inline, under the master row', 'placement', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FPlacementRadios[gmdpSidePanel] := FLayout.AddRadio(FSettings, 'Side panel', 'placement', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FPlacementRadios[gmdpLinkedGrid] := FLayout.AddRadio(FSettings, 'Linked grid', 'placement', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Options');
  FSummaryCheck := FLayout.AddCheck(FSettings, 'Summary on the master rows', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FStickyCheck := FLayout.AddCheck(FSettings, 'Sticky master row', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FMultipleCheck := FLayout.AddCheck(FSettings, 'Several details open', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FAnimateCheck := FLayout.AddCheck(FSettings, 'Animate', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FNestedCheck := FLayout.AddCheck(FSettings, 'Nested levels (lines under an order)', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FEditingCheck := FLayout.AddCheck(FSettings, 'Edit in the detail', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FLayout.AddButton(FSettings, 'Expand all', {$IFDEF WEBLIB}@{$ENDIF}ExpandAllClick);
  FLayout.AddButton(FSettings, 'Collapse all', {$IFDEF WEBLIB}@{$ENDIF}CollapseAllClick);

  FLayout.AddCaption(FSettings, 'Tree grid');
  FLazyCheck := FLayout.AddCheck(FSettings, 'Load children on expand', False, {$IFDEF WEBLIB}@{$ENDIF}TreeSettingChanged);
  FAggregateCheck := FLayout.AddCheck(FSettings, 'Sum the hours per node', True, {$IFDEF WEBLIB}@{$ENDIF}TreeSettingChanged);

  FStatus := FLayout.AddText(FSettings, '', 72);
end;

function TForm1.NewGrid(AParent: TDemoParent): TTMSFNCDataGrid;
begin
  Result := TTMSFNCDataGrid.Create(Self);
  Result.Parent := AParent;
  FLayout.Place(Result, daClient, 0, 0, 0, 0, 0);
  Result.FixedColumnCount := 0;
end;

procedure TForm1.CreateContent;
begin
  FContent := FLayout.AddContentPanel(Self);

  { the side panel or linked grid that shows the detail with those placements }
  FTargetPanel := FLayout.AddPanel(FContent, daRight, 360, 16, 0, 0, 0);
  FTargetPanel.Fill.Kind := gfkNone;
  FTargetPanel.Stroke.Kind := gskNone;
  FLayout.AddCaption(FTargetPanel, 'Detail', 0);
  FTarget := NewGrid(FTargetPanel);

  {$IFNDEF WEBLIB}
  FDataGrid := NewGrid(FContent);
  FDataGrid.MasterDetail.Summary := '%count% orders ' + MiddleDot + ' %sum:Total%';
  FDataGrid.DataSource := FCustomersSource;
  FDataGrid.MasterDetail.Enabled := True;
  {$ENDIF}

  FPlainGrid := NewGrid(FContent);
  FillPlainGrid;
  FPlainGrid.MasterDetail.Tabs.Text := 'Orders'#13#10'Contacts';
  FPlainGrid.OnGetDetailData := {$IFDEF WEBLIB}@{$ENDIF}GetDetailData;
  FPlainGrid.MasterDetail.Enabled := True;
  FPlainGrid.MasterDetail.Load;

  FTreeGrid := NewGrid(FContent);
  FTreeGrid.OnGetTreeChildren := {$IFDEF WEBLIB}@{$ENDIF}GetTreeChildren;
  FillTreeGrid;
end;

procedure TForm1.FillPlainGrid;
var
  names: TArray<string>;
  I: Integer;
begin
  names := TTMSFNCSampleData.Customers;
  FPlainGrid.ColumnCount := 3;
  FPlainGrid.RowCount := 1 + Length(names);
  FPlainGrid.Cells[0, 0] := 'Customer';
  FPlainGrid.Cells[1, 0] := 'City';
  FPlainGrid.Cells[2, 0] := 'Since';
  for I := 0 to High(names) do
  begin
    FPlainGrid.Cells[0, I + 1] := names[I];
    FPlainGrid.Cells[1, I + 1] := Cities[I mod Length(Cities)];
    FPlainGrid.Cells[2, I + 1] := IntToStr(2012 + (I * 7) mod 13);
  end;
  FPlainGrid.ColumnWidths[0] := 240;
  FPlainGrid.ColumnWidths[1] := 140;
  FPlainGrid.ColumnWidths[2] := 90;
end;

procedure TForm1.GetDetailData(Sender: TObject; AMaster: TTMSFNCDataGridRenderer; AMasterRow, ATab: Integer;
  ADetail: TTMSFNCDataGridRenderer; var ANested: Boolean);
var
  people: TArray<string>;
  I, n: Integer;
begin
  { the detail of a master row from code: here two to four orders and two contacts per customer }
  if ATab = 0 then
  begin
    n := 2 + AMasterRow mod 3;
    ADetail.ColumnCount := 4;
    ADetail.RowCount := 1 + n;
    ADetail.Cells[0, 0] := 'Order';
    ADetail.Cells[1, 0] := 'Date';
    ADetail.Cells[2, 0] := 'Product';
    ADetail.Cells[3, 0] := 'Total';
    for I := 1 to n do
    begin
      ADetail.Cells[0, I] := TTMSFNCSampleData.FormatID(AMasterRow * 10 + I, 4);
      ADetail.Cells[1, I] := FormatDateTime('yyyy-mm-dd', EncodeDate(2026, 1 + (AMasterRow + I) mod 12, 1 + (I * 9) mod 28));
      ADetail.Cells[2, I] := Products[(AMasterRow + I) mod Length(Products)];
      ADetail.Cells[3, I] := TTMSFNCSampleData.FormatMoney(Prices[(AMasterRow + I) mod Length(Prices)] * (1 + I mod 4));
    end;
    ADetail.ColumnWidths[0] := 90;
    ADetail.ColumnWidths[1] := 110;
    ADetail.ColumnWidths[2] := 160;
    ADetail.ColumnWidths[3] := 100;
  end
  else
  begin
    ADetail.ColumnCount := 2;
    ADetail.RowCount := 3;
    ADetail.Cells[0, 0] := 'Contact';
    ADetail.Cells[1, 0] := 'Department';
    people := TTMSFNCSampleData.People;
    for I := 1 to 2 do
    begin
      ADetail.Cells[0, I] := people[(AMasterRow * 2 + I) mod Length(people)];
      ADetail.Cells[1, I] := Contacts[(AMasterRow + I) mod Length(Contacts)];
    end;
    ADetail.ColumnWidths[0] := 200;
    ADetail.ColumnWidths[1] := 160;
  end;
end;

procedure TForm1.FillTreeGrid;
var
  projects: TArray<string>;
  tasks: TArray<TTMSFNCSampleProjectTask>;
  I, P, r: Integer;
begin
  { key, parent and tree column; with children loaded on expand only the projects are rows at first }
  projects := TTMSFNCSampleData.Projects;
  tasks := TTMSFNCSampleData.ProjectTasks;
  FTreeGrid.BeginUpdate;
  FTreeGrid.TreeOptions.Enabled := False;
  FTreeGrid.ColumnCount := 6;
  FTreeGrid.RowCount := 1 + Length(projects);
  if not FLazyCheck.Checked then
    FTreeGrid.RowCount := FTreeGrid.RowCount + Length(tasks);
  FTreeGrid.Cells[0, 0] := 'ID';
  FTreeGrid.Cells[1, 0] := 'Parent';
  FTreeGrid.Cells[2, 0] := 'Task';
  FTreeGrid.Cells[3, 0] := 'Owner';
  FTreeGrid.Cells[4, 0] := 'Hours';
  FTreeGrid.Cells[5, 0] := 'Status';
  for P := 0 to High(projects) do
  begin
    FTreeGrid.Cells[0, 1 + P] := 'P' + IntToStr(P + 1);
    FTreeGrid.Cells[1, 1 + P] := '';
    FTreeGrid.Cells[2, 1 + P] := projects[P];
    FTreeGrid.Cells[3, 1 + P] := '';
    FTreeGrid.Cells[4, 1 + P] := 0;
    FTreeGrid.Cells[5, 1 + P] := '';
  end;
  if not FLazyCheck.Checked then
  begin
    r := 1 + Length(projects);
    for I := 0 to High(tasks) do
    begin
      P := 0;
      while (P < High(projects)) and (projects[P] <> tasks[I].Project) do
        Inc(P);
      FTreeGrid.Cells[0, r] := 'T' + IntToStr(I + 1);
      FTreeGrid.Cells[1, r] := 'P' + IntToStr(P + 1);
      FTreeGrid.Cells[2, r] := tasks[I].Task;
      FTreeGrid.Cells[3, r] := tasks[I].Owner;
      FTreeGrid.Cells[4, r] := 4 + (I * 3) mod 9;
      FTreeGrid.Cells[5, r] := tasks[I].Status;
      Inc(r);
    end;
  end;
  FTreeGrid.HideColumn(0);
  FTreeGrid.HideColumn(1);
  FTreeGrid.ColumnWidths[2] := 300;
  FTreeGrid.ColumnWidths[3] := 160;
  FTreeGrid.ColumnWidths[4] := 80;
  FTreeGrid.ColumnWidths[5] := 120;
  FTreeGrid.TreeOptions.KeyColumn := 0;
  FTreeGrid.TreeOptions.ParentColumn := 1;
  FTreeGrid.TreeOptions.TreeColumn := 2;
  FTreeGrid.TreeOptions.LazyLoad := FLazyCheck.Checked;
  if FAggregateCheck.Checked then
    FTreeGrid.TreeOptions.AggregateColumns := '4'
  else
    FTreeGrid.TreeOptions.AggregateColumns := '';
  FTreeGrid.TreeOptions.Enabled := True;
  if FLazyCheck.Checked then
    for P := 0 to High(projects) do
      FTreeGrid.TreeOptions.SetHasChildren(FTreeGrid.TreeOptions.FindRow('P' + IntToStr(P + 1)));
  FTreeGrid.EndUpdate;
end;

procedure TForm1.GetTreeChildren(Sender: TObject; ARow: Integer; const AKey: string);
var
  projects: TArray<string>;
  tasks: TArray<TTMSFNCSampleProjectTask>;
  I, P, r: Integer;
begin
  { the tasks of a project, added the first time the project row is expanded }
  projects := TTMSFNCSampleData.Projects;
  tasks := TTMSFNCSampleData.ProjectTasks;
  P := StrToIntDef(Copy(AKey, 2, 5), 1) - 1;
  if (P < 0) or (P > High(projects)) then
    Exit;
  for I := 0 to High(tasks) do
    if tasks[I].Project = projects[P] then
    begin
      r := FTreeGrid.TreeOptions.AddChild(ARow);
      FTreeGrid.Cells[0, r] := 'T' + IntToStr(I + 1);
      FTreeGrid.Cells[1, r] := AKey;
      FTreeGrid.Cells[2, r] := tasks[I].Task;
      FTreeGrid.Cells[3, r] := tasks[I].Owner;
      FTreeGrid.Cells[4, r] := 4 + (I * 3) mod 9;
      FTreeGrid.Cells[5, r] := tasks[I].Status;
    end;
  FTreeGrid.TreeOptions.UpdateAggregates;
end;

function TForm1.ActiveGrid: TTMSFNCDataGrid;
begin
  case FPage of
    dpPlain: Result := FPlainGrid;
    dpTree: Result := FTreeGrid;
  else
    {$IFDEF WEBLIB}
    Result := FPlainGrid;
    {$ELSE}
    Result := FDataGrid;
    {$ENDIF}
  end;
end;

procedure TForm1.ShowPage(APage: TDemoPage);
begin
  FPage := APage;
  { the detail target grid serves the visible grid only }
  FPlainGrid.MasterDetail.Target := nil;
  {$IFNDEF WEBLIB}
  FDataGrid.MasterDetail.Target := nil;
  FDataGrid.Visible := APage = dpDatabase;
  {$ENDIF}
  FPlainGrid.Visible := APage = dpPlain;
  FTreeGrid.Visible := APage = dpTree;
  ApplySettings;
end;

procedure TForm1.ApplySettings;
var
  g: TTMSFNCDataGrid;
  t: TTMSFNCDataGridMasterDetailTemplate;
  p: TTMSFNCDataGridMasterDetailPlacement;
begin
  if FPage = dpTree then
  begin
    FTargetPanel.Visible := False;
    FStatus.Text := 'Expand a project for its tasks; the hours of a project are the sum of its tasks. ' +
      'Load children on expand fills a project the first time it opens.';
    Exit;
  end;

  g := ActiveGrid;
  for t := Low(t) to High(t) do
    if FTemplateRadios[t].Checked then
      g.MasterDetail.Template := t;
  for p := Low(p) to High(p) do
    if FPlacementRadios[p].Checked then
      g.MasterDetail.Placement := p;
  FTargetPanel.Visible := g.MasterDetail.Placement <> gmdpInline;
  if FTargetPanel.Visible then
    g.MasterDetail.Target := FTarget
  else
    g.MasterDetail.Target := nil;
  if FSummaryCheck.Checked then
  begin
    if FPage = dpPlain then
      g.MasterDetail.Summary := '%count% orders'
    else
      g.MasterDetail.Summary := '%count% orders ' + MiddleDot + ' %sum:Total%';
  end
  else
    g.MasterDetail.Summary := '';
  g.MasterDetail.StickyMaster := FStickyCheck.Checked;
  g.MasterDetail.MultipleExpand := FMultipleCheck.Checked;
  g.MasterDetail.Animate := FAnimateCheck.Checked;
  g.MasterDetail.Nested := FNestedCheck.Checked;
  g.MasterDetail.Editing := FEditingCheck.Checked;

  if FPage = dpPlain then
    FStatus.Text := 'The rows and their details come from code (OnGetDetailData); the tabs template shows the ' +
      'orders and the contacts of a customer.'
  else
    FStatus.Text := 'Three datasets linked through MasterSource: the grid finds the orders of a customer and the ' +
      'lines of an order by itself. Edit a detail cell, insert a record with Insert, delete one with Ctrl+Del.';
end;

procedure TForm1.PageChanged(Sender: TObject);
var
  pg: TDemoPage;
begin
  for pg := Low(pg) to High(pg) do
    if Assigned(FPageRadios[pg]) and FPageRadios[pg].Checked then
      ShowPage(pg);
end;

procedure TForm1.SettingChanged(Sender: TObject);
begin
  ApplySettings;
end;

procedure TForm1.TreeSettingChanged(Sender: TObject);
begin
  FillTreeGrid;
end;

procedure TForm1.ExpandAllClick(Sender: TObject);
begin
  if FPage = dpTree then
    FTreeGrid.ExpandAllNodes
  else
    ActiveGrid.MasterDetail.ExpandAll;
end;

procedure TForm1.CollapseAllClick(Sender: TObject);
begin
  if FPage = dpTree then
    FTreeGrid.CollapseAllNodes
  else
    ActiveGrid.MasterDetail.CollapseAll;
end;

end.
