unit UDemo;

{ TMS FNC UI Pack - TreeView Database

  The tree view binds to a data source by itself: DataSource names the dataset and DataOptions says how its
  records become nodes, no adapter component needed.

  Page "Catalog": one self-referencing table (ID / ParentID) of categories and products. ColumnFields makes a
  column per field with an editor per field type, the Active field is the node check box, dragging a node onto
  another writes ParentID, dragging between siblings writes the Order field. A data navigator on the same data
  source shows the selection in sync.

  Page "Customers and orders": two linked tables as node levels (DataOptions.Levels), each with its own columns,
  the status drawn as pills (Columns[].StatusValues) and the company as an avatar (Columns[].Avatar)
  and a caption row (LevelHeaders); the lines of the selected order appear in a data grid through the level's
  Detail options. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCTabSet, VCL.TMSFNCTreeViewData, VCL.TMSFNCCustomTreeView, VCL.TMSFNCTreeView,
  VCL.TMSFNCTreeViewDatabaseAdapter,
  VCL.TMSFNCDataGrid, VCL.TMSFNCDataNavigator, VCL.TMSFNCSampleData, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,
  Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCTabSet, FMX.TMSFNCTreeViewData, FMX.TMSFNCCustomTreeView, FMX.TMSFNCTreeView,
  FMX.TMSFNCTreeViewDatabaseAdapter,
  FMX.TMSFNCDataGrid, FMX.TMSFNCDataNavigator, FMX.TMSFNCSampleData, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs, DB, WEBLib.DB, WEBLib.CDS,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton, WEBLib.TMSFNCTabSet, WEBLib.TMSFNCTreeViewData,
  WEBLib.TMSFNCCustomTreeView, WEBLib.TMSFNCTreeView, WEBLib.TMSFNCTreeViewDatabaseAdapter, WEBLib.TMSFNCDataGrid, WEBLib.TMSFNCDataNavigator,
  WEBLib.TMSFNCSampleData, WEBLib.TMSFNCTheme, WEBLib.TMSFNCThemeSelector,
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
    FTabs: TTMSFNCTabSet;
    FPages: array[0..1] of TTMSFNCPanel;
    FCatalog: TDemoDataSet;
    FCatalogSource: TDataSource;
    FCustomers: TDemoDataSet;
    FCustomersSource: TDataSource;
    FOrders: TDemoDataSet;
    FOrdersSource: TDataSource;
    FLines: TDemoDataSet;
    FLinesSource: TDataSource;
    FCatalogTree: TTMSFNCTreeView;
    FNavigator: TTMSFNCDataNavigator;
    FOrdersTree: TTMSFNCTreeView;
    FLinesGrid: TTMSFNCDataGrid;
    FEditCheck: TTMSFNCCheckBox;
    FCheckCheck: TTMSFNCCheckBox;
    FReparentCheck: TTMSFNCCheckBox;
    FReorderCheck: TTMSFNCCheckBox;
    FSyncCheck: TTMSFNCCheckBox;
    FOnExpandCheck: TTMSFNCCheckBox;
    FHeadersCheck: TTMSFNCCheckBox;
    FExpandRadios: array[0..2] of TTMSFNCRadioButton;
    FStatus: TTMSFNCHTMLText;
    FNextID: Integer;
    procedure AddItem(AID, AParentID, AOrder: Integer; const AName: string; APrice: Double; AStock: Integer;
      AActive: Boolean);
    procedure CreateData;
    procedure CreateSettings;
    procedure CreatePages;
    procedure BindTrees;
    procedure ApplySettings;
    procedure SettingChanged(Sender: TObject);
    procedure TabChanged(Sender: TObject; APreviousTabIndex, ACurrentTabIndex: Integer);
    procedure AddChildClick(Sender: TObject);
    procedure AddRootClick(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure CatalogDataChange(Sender: TObject; Field: TField);
    procedure CatalogNewRecord(DataSet: TDataSet);
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
  CreatePages;
  BindTrees;
  ApplySettings;
end;

{ data }

procedure TForm1.AddItem(AID, AParentID, AOrder: Integer; const AName: string; APrice: Double; AStock: Integer;
  AActive: Boolean);
begin
  FCatalog.Append;
  FCatalog.FieldByName('ID').AsInteger := AID;
  FCatalog.FieldByName('ParentID').AsInteger := AParentID;
  FCatalog.FieldByName('SortOrder').AsInteger := AOrder;
  FCatalog.FieldByName('Name').AsString := AName;
  if APrice > 0 then
    FCatalog.FieldByName('Price').AsFloat := APrice;
  if AStock >= 0 then
    FCatalog.FieldByName('Stock').AsInteger := AStock;
  FCatalog.FieldByName('Active').AsBoolean := AActive;
  FCatalog.Post;
end;

procedure TForm1.CreateData;
const
  Cities: array[0..7] of string = ('Antwerp', 'Lyon', 'Munich', 'Innsbruck', 'Porto', 'Utrecht', 'Milan', 'Dublin');
  Items: array[0..5] of string = ('Developer licence', 'Site licence', 'Support extension', 'Training day',
    'Source code', 'Consulting hour');
  Prices: array[0..5] of Double = (295, 1195, 95, 850, 495, 150);
var
  customers: TArray<string>;
  orders: TArray<TTMSFNCSampleOrder>;
  I, J, cust, no: Integer;
begin
  { a self-referencing table: categories and the products under them }
  FCatalog := FLayout.NewDataSet;
  FCatalog.FieldDefs.Add('ID', ftInteger);
  FCatalog.FieldDefs.Add('ParentID', ftInteger);
  FCatalog.FieldDefs.Add('SortOrder', ftInteger);
  FCatalog.FieldDefs.Add('Name', ftString, 40);
  FCatalog.FieldDefs.Add('Price', ftFloat);
  FCatalog.FieldDefs.Add('Stock', ftInteger);
  FCatalog.FieldDefs.Add('Active', ftBoolean);
  FLayout.OpenDataSet(FCatalog);
  AddItem(1, 0, 1, 'Components', 0, -1, True);
  AddItem(2, 1, 1, 'FNC UI Pack', 295, 120, True);
  AddItem(3, 1, 2, 'FNC Core', 0, 500, True);
  AddItem(4, 1, 3, 'FNC Cloud Pack', 195, 80, True);
  AddItem(5, 1, 4, 'FNC Maps', 175, 65, True);
  AddItem(6, 1, 5, 'FNC Chart', 125, 40, False);
  AddItem(7, 0, 2, 'Tools', 0, -1, True);
  AddItem(8, 7, 1, 'Smart Setup', 0, 999, True);
  AddItem(9, 7, 2, 'WEB Core', 395, 210, True);
  AddItem(10, 7, 3, 'Business Subscription', 2495, 15, True);
  AddItem(11, 0, 3, 'Services', 0, -1, True);
  AddItem(12, 11, 1, 'Training day', 850, 12, True);
  AddItem(13, 11, 2, 'Consulting hour', 150, 300, True);
  AddItem(14, 11, 3, 'Priority support', 495, 50, False);
  FNextID := 100;
  FCatalog.First;
  FCatalogSource := FLayout.NewSource(FCatalog);
  FCatalogSource.OnDataChange := {$IFDEF WEBLIB}@{$ENDIF}CatalogDataChange;
  FCatalog.OnNewRecord := {$IFDEF WEBLIB}@{$ENDIF}CatalogNewRecord;

  { customers, their orders and the order lines, linked by CustNo and OrderNo }
  FCustomers := FLayout.NewDataSet;
  FCustomers.FieldDefs.Add('CustNo', ftInteger);
  FCustomers.FieldDefs.Add('Company', ftString, 40);
  FCustomers.FieldDefs.Add('City', ftString, 30);
  FLayout.OpenDataSet(FCustomers);
  customers := TTMSFNCSampleData.Customers;
  for I := 0 to Length(customers) - 1 do
  begin
    FCustomers.Append;
    FCustomers.FieldByName('CustNo').AsInteger := 1001 + I;
    FCustomers.FieldByName('Company').AsString := customers[I];
    FCustomers.FieldByName('City').AsString := Cities[I mod Length(Cities)];
    FCustomers.Post;
  end;
  FCustomers.First;
  FCustomersSource := FLayout.NewSource(FCustomers);

  FOrders := FLayout.NewDataSet;
  FOrders.FieldDefs.Add('OrderNo', ftInteger);
  FOrders.FieldDefs.Add('CustNo', ftInteger);
  FOrders.FieldDefs.Add('SaleDate', ftDate);
  FOrders.FieldDefs.Add('Total', ftFloat);
  FOrders.FieldDefs.Add('Status', ftString, 20);
  FLayout.OpenDataSet(FOrders);

  FLines := FLayout.NewDataSet;
  FLines.FieldDefs.Add('OrderNo', ftInteger);
  FLines.FieldDefs.Add('Item', ftString, 40);
  FLines.FieldDefs.Add('Quantity', ftInteger);
  FLines.FieldDefs.Add('Price', ftFloat);
  FLayout.OpenDataSet(FLines);

  orders := TTMSFNCSampleData.Orders;
  for I := 0 to Length(orders) - 1 do
  begin
    cust := I mod Length(customers);
    for J := 0 to Length(customers) - 1 do
      if customers[J] = orders[I].Customer then
        cust := J;
    no := 10240 + I;
    FOrders.Append;
    FOrders.FieldByName('OrderNo').AsInteger := no;
    FOrders.FieldByName('CustNo').AsInteger := 1001 + cust;
    FOrders.FieldByName('SaleDate').AsDateTime := orders[I].Date;
    FOrders.FieldByName('Total').AsFloat := orders[I].Total;
    FOrders.FieldByName('Status').AsString := orders[I].Status;
    FOrders.Post;

    { two or three lines per order, named after the catalogue }
    for J := 0 to 1 + I mod 2 do
    begin
      FLines.Append;
      FLines.FieldByName('OrderNo').AsInteger := no;
      FLines.FieldByName('Item').AsString := Items[(I + J) mod Length(Items)];
      FLines.FieldByName('Quantity').AsInteger := 1 + (I + J) mod 3;
      FLines.FieldByName('Price').AsFloat := Prices[(I + J) mod Length(Prices)];
      FLines.Post;
    end;
  end;
  FOrders.First;
  FLines.First;
  FOrdersSource := FLayout.NewSource(FOrders);
  FLinesSource := FLayout.NewSource(FLines);
end;

{ user interface }

procedure TForm1.CreateSettings;
begin
  FSettings := FLayout.AddSettingsPanel(Self);

  FLayout.AddCaption(FSettings, 'DataOptions.Options');
  FEditCheck := FLayout.AddCheck(FSettings, 'Edit in place (taoEdit)', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FCheckCheck := FLayout.AddCheck(FSettings, 'Check box writes Active (taoCheck)', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FReparentCheck := FLayout.AddCheck(FSettings, 'Drag onto a node moves it (taoReparent)', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FReorderCheck := FLayout.AddCheck(FSettings, 'Drag between siblings reorders (taoReorder)', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FSyncCheck := FLayout.AddCheck(FSettings, 'Selection follows the record (taoSyncSelection)', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Loading');
  FOnExpandCheck := FLayout.AddCheck(FSettings, 'Load children when a node expands', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FExpandRadios[0] := FLayout.AddRadio(FSettings, 'Collapsed', 'Expand', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FExpandRadios[1] := FLayout.AddRadio(FSettings, 'Expand the first level', 'Expand', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FExpandRadios[2] := FLayout.AddRadio(FSettings, 'Expand everything', 'Expand', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FHeadersCheck := FLayout.AddCheck(FSettings, 'Caption row per level (LevelHeaders)', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Catalog records');
  FLayout.AddButton(FSettings, 'Add a child of the selected node', {$IFDEF WEBLIB}@{$ENDIF}AddChildClick);
  FLayout.AddButton(FSettings, 'Add a root category', {$IFDEF WEBLIB}@{$ENDIF}AddRootClick);
  FLayout.AddButton(FSettings, 'Delete the selected node', {$IFDEF WEBLIB}@{$ENDIF}DeleteClick);

  FStatus := FLayout.AddText(FSettings, 'Deleting a category moves its products to its parent ' +
    '(DeleteChildrenMode of the internal adapter).', 48);
end;

procedure TForm1.CreatePages;
var
  I: Integer;
begin
  FContent := FLayout.AddContentPanel(Self);

  FTabs := TTMSFNCTabSet.Create(Self);
  FTabs.Parent := FContent;
  FLayout.Place(FTabs, daTop, 36, 0, 0, 0, 0);
  FTabs.Tabs.Clear;
  FTabs.Tabs.Add.Text := 'Catalog';
  FTabs.Tabs.Add.Text := 'Customers and orders';
  FTabs.ActiveTabIndex := 0;
  FTabs.OnChangeTab := {$IFDEF WEBLIB}@{$ENDIF}TabChanged;

  for I := 0 to 1 do
  begin
    FPages[I] := FLayout.AddPanel(FContent, daClient, 0, 0, 0, 0, 0);
    FPages[I].Fill.Kind := gfkNone;
    FPages[I].Stroke.Kind := gskNone;
    FPages[I].Visible := I = 0;
  end;

  { page 1: the catalog tree with a data navigator on the same data source }
  FNavigator := TTMSFNCDataNavigator.Create(Self);
  FNavigator.Parent := FPages[0];
  FLayout.Place(FNavigator, daBottom, 36, 0, 8, 0, 0);
  FNavigator.DataSource := FCatalogSource;
  FNavigator.VisibleButtons := [dnbFirst, dnbPrior, dnbNext, dnbLast, dnbDelete];

  FCatalogTree := TTMSFNCTreeView.Create(Self);
  FCatalogTree.Parent := FPages[0];
  FLayout.Place(FCatalogTree, daClient, 0, 0, 8, 0, 0);
  FCatalogTree.Interaction.DragDropMode := tdmMove;
  FCatalogTree.Interaction.MultiSelect := True;

  { page 2: customers and orders as levels, the lines of the selected order in a grid }
  FLinesGrid := TTMSFNCDataGrid.Create(Self);
  FLinesGrid.Parent := FPages[1];
  FLayout.Place(FLinesGrid, daRight, 300, 8, 8, 0, 0);
  FLinesGrid.Options.Editing.Enabled := False;

  FOrdersTree := TTMSFNCTreeView.Create(Self);
  FOrdersTree.Parent := FPages[1];
  FLayout.Place(FOrdersTree, daClient, 0, 0, 8, 0, 0);
end;

procedure TForm1.BindTrees;
var
  lv: TTMSFNCTreeViewDataLevel;
begin
  FCatalogTree.DataOptions.KeyField := 'ID';
  FCatalogTree.DataOptions.ParentField := 'ParentID';
  FCatalogTree.DataOptions.OrderField := 'SortOrder';
  FCatalogTree.DataOptions.ColumnFields := 'Name;Price;Stock';
  FCatalogTree.DataOptions.CheckField := 'Active';
  FCatalogTree.DataOptions.ExpandLevel := 1;
  FCatalogTree.DataSource := FCatalogSource;
  FCatalogTree.DataAdapter.DeleteChildrenMode := tdcReparent;

  FOrdersTree.DataOptions.KeyField := 'CustNo';
  FOrdersTree.DataOptions.ColumnFields := 'Company;City';
  FOrdersTree.DataOptions.ExpandLevel := 1;
  FOrdersTree.DataOptions.LevelHeaders := True;
  lv := FOrdersTree.DataOptions.Levels.Add;
  lv.DataSource := FOrdersSource;
  lv.KeyField := 'OrderNo';
  lv.MasterKeyField := 'CustNo';
  lv.ColumnFields := 'OrderNo;SaleDate;Total;Status';
  lv.Detail.DataSource := FLinesSource;
  lv.Detail.DetailField := 'OrderNo';
  lv.Detail.Target := FLinesGrid;
  FOrdersTree.DataSource := FCustomersSource;

  { the bound columns: the status as pills coloured by the theme, the company as an avatar }
  if FOrdersTree.Columns.Count > 3 then
  begin
    FOrdersTree.Columns[0].Avatar := True;
    FOrdersTree.Columns[3].StatusValues.Text := 'Shipped=Success'#13#10'Open=Info'#13#10'Packing=Warning'#13#10'Late=Error';
  end;
end;

procedure TForm1.ApplySettings;
var
  o: TTMSFNCTreeViewDatabaseAdapterOptions;
  lm: TTMSFNCTreeViewDatabaseAdapterLoadMode;
  level: Integer;
begin
  if not Assigned(FOrdersTree) then
    Exit;

  o := [taoInsert, taoDelete];
  if FEditCheck.Checked then
    Include(o, taoEdit);
  if FCheckCheck.Checked then
    Include(o, taoCheck);
  if FReparentCheck.Checked then
    Include(o, taoReparent);
  if FReorderCheck.Checked then
    Include(o, taoReorder);
  if FSyncCheck.Checked then
    Include(o, taoSyncSelection);

  if FOnExpandCheck.Checked then
    lm := tlmOnExpand
  else
    lm := tlmAll;

  if FExpandRadios[0].Checked then
    level := 0
  else if FExpandRadios[2].Checked then
    level := 10
  else
    level := 1;

  FCatalogTree.DataOptions.Options := o;
  FCatalogTree.DataOptions.LoadMode := lm;
  FCatalogTree.DataOptions.ExpandLevel := level;

  FOrdersTree.DataOptions.Options := o - [taoReparent, taoReorder];
  FOrdersTree.DataOptions.LoadMode := lm;
  FOrdersTree.DataOptions.ExpandLevel := level;
  FOrdersTree.DataOptions.LevelHeaders := FHeadersCheck.Checked;
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

procedure TForm1.AddChildClick(Sender: TObject);
begin
  { the adapter fills ParentID and SortOrder, CatalogNewRecord the other fields }
  if Assigned(FCatalogTree.SelectedNode) then
    FCatalogTree.DataAdapter.AddRecord(FCatalogTree.SelectedNode);
end;

procedure TForm1.AddRootClick(Sender: TObject);
begin
  FCatalogTree.DataAdapter.AddRecord(nil);
end;

procedure TForm1.DeleteClick(Sender: TObject);
var
  n: TTMSFNCTreeViewNode;
begin
  n := FCatalogTree.SelectedNode;
  if Assigned(n) then
    FCatalogTree.DataAdapter.DeleteRecord(n);
end;

procedure TForm1.CatalogNewRecord(DataSet: TDataSet);
begin
  Inc(FNextID);
  DataSet.FieldByName('ID').AsInteger := FNextID;
  DataSet.FieldByName('Name').AsString := 'New item ' + IntToStr(FNextID);
  DataSet.FieldByName('Stock').AsInteger := 0;
  DataSet.FieldByName('Active').AsBoolean := True;
end;

procedure TForm1.CatalogDataChange(Sender: TObject; Field: TField);
begin
  if Assigned(Field) or not Assigned(FStatus) or FCatalog.IsEmpty then
    Exit;
  FStatus.Text := 'Current record: ' + FCatalog.FieldByName('Name').AsString + ' (ID ' +
    FCatalog.FieldByName('ID').AsString + '). Deleting a category moves its products to its parent.';
end;

end.
