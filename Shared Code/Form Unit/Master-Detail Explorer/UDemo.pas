unit UDemo;

{ TMS FNC UI Pack - Master-Detail Explorer

  Three pages of one data grid. Database: customers with their orders and, nested under an order, its lines, from
  three datasets linked through MasterSource; expand a customer, switch the detail template (grid, form, tabs,
  cards) and its placement (inline under the row, in a detail view next to the grid, drill-down with a breadcrumb),
  give the order lines a template of their own, show a tool bar with search and Add above a detail, a peek preview
  when the mouse rests on a customer, a summary on the master rows, keep the master row sticky, edit in the detail.
  Without a database: the detail of a row comes from OnGetDetailData, with tabs. Tree grid: self-referencing rows
  (key and parent column) as a tree with aggregates per node and children loaded on expand. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCDataGrid, VCL.TMSFNCDataGridCore, VCL.TMSFNCDataGridRenderer, VCL.TMSFNCMasterDetail, VCL.TMSFNCDetailView, VCL.TMSFNCSegmentedControl,
  VCL.TMSFNCSampleData, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCDataGrid, FMX.TMSFNCDataGridCore, FMX.TMSFNCDataGridRenderer, FMX.TMSFNCMasterDetail, FMX.TMSFNCDetailView, FMX.TMSFNCSegmentedControl,
  FMX.TMSFNCSampleData, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs, DB, WEBLib.DB, WEBLib.CDS,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton, WEBLib.TMSFNCDataGrid, WEBLib.TMSFNCDataGridCore,
  WEBLib.TMSFNCDataGridRenderer,
  WEBLib.TMSFNCMasterDetail, WEBLib.TMSFNCDetailView, WEBLib.TMSFNCSegmentedControl,
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
    FBar: TTMSFNCPanel;
    FTreeBar: TTMSFNCPanel;
    FTemplate: TTMSFNCSegmentedControl;
    FPlacement: TTMSFNCSegmentedControl;
    FExpandButton: TTMSFNCButton;
    FCollapseButton: TTMSFNCButton;
    FToolBarCheck: TTMSFNCCheckBox;
    FPeekCheck: TTMSFNCCheckBox;
    FLineCardsCheck: TTMSFNCCheckBox;
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
    FView: TTMSFNCDetailView;
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
  I, L, R, c, p, lineID, orderCount: Integer;
begin
  { customers, the master table }
  names := TTMSFNCSampleData.Customers;
  FCustomers := FLayout.NewDataSet;
  { the visible fields first: the expander of a master row is drawn in the first column }
  FCustomers.FieldDefs.Add('Company', ftString, 40);
  FCustomers.FieldDefs.Add('City', ftString, 30);
  FCustomers.FieldDefs.Add('CustomerID', ftInteger);
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
  FOrders.FieldDefs.Add('Number', ftString, 10);
  FOrders.FieldDefs.Add('OrderDate', ftDate);
  FOrders.FieldDefs.Add('Status', ftString, 20);
  FOrders.FieldDefs.Add('Total', ftFloat);
  FOrders.FieldDefs.Add('OrderID', ftInteger);
  FOrders.FieldDefs.Add('CustomerID', ftInteger);
  FLayout.OpenDataSet(FOrders);
  { two or three orders per customer: the sample order and older, shipped ones }
  orders := TTMSFNCSampleData.Orders;
  orderCount := 0;
  for R := 0 to 2 do
    for I := 0 to High(orders) do
    begin
      if (R > 0) and ((I + R) mod 3 = 0) then
        Continue;
      c := 1;
      while (c <= Length(names)) and (names[c - 1] <> orders[I].Customer) do
        Inc(c);
      if c > Length(names) then
        c := 1 + I mod Length(names);
      Inc(orderCount);
      FOrders.Append;
      FOrders.FieldByName('OrderID').AsInteger := orderCount;
      FOrders.FieldByName('CustomerID').AsInteger := c;
      if R = 0 then
      begin
        FOrders.FieldByName('Number').AsString := orders[I].Number;
        FOrders.FieldByName('Status').AsString := orders[I].Status;
        FOrders.FieldByName('Total').AsFloat := orders[I].Total;
      end
      else
      begin
        { older orders: lower numbers than the sample orders, each its own (a '-2' suffix was cut off in the
          order column) }
        FOrders.FieldByName('Number').AsString := '#' + IntToStr(10240 - orderCount);
        FOrders.FieldByName('Status').AsString := 'Shipped';
        FOrders.FieldByName('Total').AsFloat := Round(orders[I].Total * (0.4 + 0.35 * R));
      end;
      FOrders.FieldByName('OrderDate').AsDateTime := orders[I].Date - 19 * R;
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
  FLines.FieldDefs.Add('Product', ftString, 30);
  FLines.FieldDefs.Add('Quantity', ftInteger);
  FLines.FieldDefs.Add('Price', ftFloat);
  FLines.FieldDefs.Add('LineID', ftInteger);
  FLines.FieldDefs.Add('OrderID', ftInteger);
  FLayout.OpenDataSet(FLines);
  lineID := 0;
  for I := 0 to orderCount - 1 do
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
  FPageRadios[dpDatabase] := FLayout.AddRadio(FSettings, 'Customers, orders, lines (datasets)', 'page', True,
    {$IFDEF WEBLIB}@{$ENDIF}PageChanged);
  {$ENDIF}
  FPageRadios[dpPlain] := FLayout.AddRadio(FSettings, 'Without a database', 'page', {$IFDEF WEBLIB}True{$ELSE}False{$ENDIF},
    {$IFDEF WEBLIB}@{$ENDIF}PageChanged);
  FPageRadios[dpTree] := FLayout.AddRadio(FSettings, 'Tree grid', 'page', False, {$IFDEF WEBLIB}@{$ENDIF}PageChanged);

  FLayout.AddCaption(FSettings, 'Detail');
  FToolBarCheck := FLayout.AddCheck(FSettings, 'Tool bar: search, Add, count', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FPeekCheck := FLayout.AddCheck(FSettings, 'Peek: rest the mouse on a row', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FNestedCheck := FLayout.AddCheck(FSettings, 'Order lines under an order', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FLineCardsCheck := FLayout.AddCheck(FSettings, 'Order lines as cards', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FEditingCheck := FLayout.AddCheck(FSettings, 'Edit in the detail', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Master rows');
  FSummaryCheck := FLayout.AddCheck(FSettings, 'Summary of the detail', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FStickyCheck := FLayout.AddCheck(FSettings, 'Sticky while scrolling', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FMultipleCheck := FLayout.AddCheck(FSettings, 'Several details open', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FAnimateCheck := FLayout.AddCheck(FSettings, 'Animate', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

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
var
  b: TTMSFNCButton;
begin
  FContent := FLayout.AddContentPanel(Self);

  { what a detail shows and where: the two choices a developer makes first }
  FBar := FLayout.AddPanel(FContent, daTop, 40, 0, 0, 0, 12);
  FBar.Fill.Kind := gfkNone;
  FBar.Stroke.Kind := gskNone;
  FTemplate := TTMSFNCSegmentedControl.Create(Self);
  FTemplate.Parent := FBar;
  FLayout.Place(FTemplate, daLeft, 240, 0, 4, 12, 4);
  FTemplate.Items.AddItem('Grid');
  FTemplate.Items.AddItem('Form');
  FTemplate.Items.AddItem('Tabs');
  FTemplate.Items.AddItem('Cards');
  FTemplate.ItemIndex := 0;
  FTemplate.OnChange := {$IFDEF WEBLIB}@{$ENDIF}SettingChanged;
  FPlacement := TTMSFNCSegmentedControl.Create(Self);
  FPlacement.Parent := FBar;
  FLayout.Place(FPlacement, daLeft, 300, 0, 4, 12, 4);
  FPlacement.Items.AddItem('Inline');
  FPlacement.Items.AddItem('Detail view');
  FPlacement.Items.AddItem('Drill-down');
  FPlacement.ItemIndex := 0;
  FPlacement.OnChange := {$IFDEF WEBLIB}@{$ENDIF}SettingChanged;
  FCollapseButton := FLayout.AddButton(FBar, 'Collapse all', {$IFDEF WEBLIB}@{$ENDIF}CollapseAllClick);
  FLayout.Place(FCollapseButton, daRight, 100, 6, 4, 0, 4);
  FExpandButton := FLayout.AddButton(FBar, 'Expand all', {$IFDEF WEBLIB}@{$ENDIF}ExpandAllClick);
  FLayout.Place(FExpandButton, daRight, 100, 6, 4, 0, 4);

  { the options of the tree grid page }
  FTreeBar := FLayout.AddPanel(FContent, daTop, 40, 0, 0, 0, 12);
  FTreeBar.Fill.Kind := gfkNone;
  FTreeBar.Stroke.Kind := gskNone;
  FLazyCheck := FLayout.AddCheck(FTreeBar, 'Load children on expand', False, {$IFDEF WEBLIB}@{$ENDIF}TreeSettingChanged);
  FLayout.Place(FLazyCheck, daLeft, 220, 0, 8, 12, 4);
  FAggregateCheck := FLayout.AddCheck(FTreeBar, 'Sum the hours per node', True, {$IFDEF WEBLIB}@{$ENDIF}TreeSettingChanged);
  FLayout.Place(FAggregateCheck, daLeft, 220, 0, 8, 12, 4);
  b := FLayout.AddButton(FTreeBar, 'Collapse all', {$IFDEF WEBLIB}@{$ENDIF}CollapseAllClick);
  FLayout.Place(b, daRight, 100, 6, 4, 0, 4);
  b := FLayout.AddButton(FTreeBar, 'Expand all', {$IFDEF WEBLIB}@{$ENDIF}ExpandAllClick);
  FLayout.Place(b, daRight, 100, 6, 4, 0, 4);

  { the detail view next to the grid: it shows the detail of the current master record }
  FView := TTMSFNCDetailView.Create(Self);
  FView.Parent := FContent;
  FLayout.Place(FView, daRight, 420, 16, 0, 0, 0);
  FView.EmptyText := 'Select a customer to see its orders here';

  {$IFNDEF WEBLIB}
  FDataGrid := NewGrid(FContent);
  FDataGrid.MasterDetail.Summary := '%count:order|orders% ' + MiddleDot + ' %sum:Total%';
  FDataGrid.MasterDetail.DrillDown.RootCaption := 'Customers';
  FDataGrid.MasterDetail.ToolBar.CountFormat := '%count:order|orders%';
  FDataGrid.DataSource := FCustomersSource;
  FDataGrid.MasterDetail.Enabled := True;
  {$ENDIF}

  FPlainGrid := NewGrid(FContent);
  FillPlainGrid;
  FPlainGrid.MasterDetail.Tabs.Text := 'Orders'#13#10'Contacts';
  FPlainGrid.MasterDetail.DrillDown.RootCaption := 'Customers';
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
  FPlainGrid.ColumnWidths[0] := FLayout.Size(240);
  FPlainGrid.ColumnWidths[1] := FLayout.Size(140);
  FPlainGrid.ColumnWidths[2] := FLayout.Size(90);
  { the customer column takes the rest of the width (the columns ended a third into the grid) }
  FPlainGrid.Options.Column.Stretching.Enabled := True;
  FPlainGrid.Options.Column.Stretching.Mode := gstmIndex;
  FPlainGrid.Options.Column.Stretching.Index := 0;
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
    ADetail.ColumnWidths[0] := FLayout.Size(90);
    ADetail.ColumnWidths[1] := FLayout.Size(110);
    ADetail.ColumnWidths[2] := FLayout.Size(160);
    ADetail.ColumnWidths[3] := FLayout.Size(100);
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
    ADetail.ColumnWidths[0] := FLayout.Size(200);
    ADetail.ColumnWidths[1] := FLayout.Size(160);
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
  FTreeGrid.ColumnWidths[2] := FLayout.Size(300);
  FTreeGrid.ColumnWidths[3] := FLayout.Size(160);
  FTreeGrid.ColumnWidths[4] := FLayout.Size(80);
  FTreeGrid.ColumnWidths[5] := FLayout.Size(120);
  FTreeGrid.Options.Column.Stretching.Enabled := True;
  FTreeGrid.Options.Column.Stretching.Mode := gstmIndex;
  FTreeGrid.Options.Column.Stretching.Index := 2;
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
  { the detail view serves the visible grid only }
  FPlainGrid.MasterDetail.Target := nil;
  {$IFNDEF WEBLIB}
  FDataGrid.MasterDetail.Target := nil;
  FDataGrid.Visible := APage = dpDatabase;
  {$ENDIF}
  FPlainGrid.Visible := APage = dpPlain;
  FTreeGrid.Visible := APage = dpTree;
  FBar.Visible := APage <> dpTree;
  FTreeBar.Visible := APage = dpTree;
  ApplySettings;
end;

procedure TForm1.ApplySettings;
const
  Templates: array[0..3] of TTMSFNCMasterDetailTemplate = (mdtGrid, mdtForm, mdtTabs, mdtCards);
  Placements: array[0..2] of TTMSFNCMasterDetailPlacement = (mdpInline, mdpTarget, mdpDrillDown);
var
  g: TTMSFNCDataGrid;
  lvl: TTMSFNCMasterDetailLevel;
  t: TTMSFNCMasterDetailTemplate;
  p: TTMSFNCMasterDetailPlacement;
  s: string;
begin
  { the detail options do not apply to the tree grid }
  FToolBarCheck.Enabled := FPage <> dpTree;
  FPeekCheck.Enabled := FPage <> dpTree;
  FSummaryCheck.Enabled := FPage <> dpTree;
  FStickyCheck.Enabled := FPage <> dpTree;
  FMultipleCheck.Enabled := FPage <> dpTree;
  FAnimateCheck.Enabled := FPage <> dpTree;
  if FPage = dpTree then
  begin
    FNestedCheck.Enabled := False;
    FLineCardsCheck.Enabled := False;
    FEditingCheck.Enabled := False;
    FView.Visible := False;
    FStatus.Text := 'Expand a project for its tasks; its hours are the sum of the tasks.';
    Exit;
  end;

  { a segmented control without a selection counts as its first segment }
  if FTemplate.ItemIndex > 0 then
    t := Templates[FTemplate.ItemIndex]
  else
    t := mdtGrid;
  if FPlacement.ItemIndex > 0 then
    p := Placements[FPlacement.ItemIndex]
  else
    p := mdpInline;
  g := ActiveGrid;
  g.BeginUpdate;
  try
    g.MasterDetail.Template := t;
    g.MasterDetail.Placement := p;
    { the link first: unlinking a target gives it back the state it had }
    if p = mdpTarget then
      g.MasterDetail.Target := FView
    else
      g.MasterDetail.Target := nil;
    FView.Visible := p = mdpTarget;

    { a template of its own for the order lines (the second level) }
    g.MasterDetail.Levels.Clear;
    if FLineCardsCheck.Checked and (FPage = dpDatabase) then
    begin
      lvl := g.MasterDetail.Levels.Add;
      lvl.Template := t;
      lvl := g.MasterDetail.Levels.Add;
      lvl.Template := mdtCards;
      lvl.Caption := 'Lines';
    end;
    g.MasterDetail.Cards.Columns := 2;

    g.MasterDetail.ToolBar.Visible := FToolBarCheck.Checked;
    g.MasterDetail.Peek.Enabled := FPeekCheck.Checked;
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
  finally
    g.EndUpdate;
  end;

  { expanding every row only makes sense for details under the rows }
  FExpandButton.Enabled := p = mdpInline;
  FCollapseButton.Enabled := p = mdpInline;
  FNestedCheck.Enabled := FPage = dpDatabase;
  FLineCardsCheck.Enabled := (FPage = dpDatabase) and FNestedCheck.Checked;
  FEditingCheck.Enabled := FPage = dpDatabase;

  case p of
    mdpTarget: s := 'The detail view on the right follows the current customer. ';
    mdpDrillDown: s := 'Click the arrow of a customer: its orders replace the list. ';
  else
    s := 'Click the arrow of a customer to open its orders. ';
  end;
  if FPage = dpPlain then
    FStatus.Text := s + 'The details come from code (OnGetDetailData).'
  else
    FStatus.Text := s + 'Three datasets linked through MasterSource.';
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
