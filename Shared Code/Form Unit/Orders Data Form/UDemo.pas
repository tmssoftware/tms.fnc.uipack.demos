unit UDemo;

{ TMS FNC UI Pack - Orders Data Form

  Orders and their customers on one data source: the grid takes its columns from the fields (labels, widths,
  formats, a lookup to the customer, a check box for a boolean), the form on the right edits the current order
  with data-aware FNC editors (edit, lookup edit that searches the customers while typing, combo box, date
  picker, track bar, switch, check box and a read-only HTML text) and the navigator moves and posts. The grid
  can show the record indicator, aggregates in the footer and find a record by typing in it. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCEdit, VCL.TMSFNCComboBox, VCL.TMSFNCDatePicker, VCL.TMSFNCTrackBar, VCL.TMSFNCSwitch,
  VCL.TMSFNCStackPanel, VCL.TMSFNCDataGrid, VCL.TMSFNCDataNavigator, VCL.TMSFNCSampleData, VCL.TMSFNCTheme,
  VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCEdit, FMX.TMSFNCComboBox, FMX.TMSFNCDatePicker, FMX.TMSFNCTrackBar, FMX.TMSFNCSwitch,
  FMX.TMSFNCStackPanel, FMX.TMSFNCDataGrid, FMX.TMSFNCDataNavigator, FMX.TMSFNCSampleData, FMX.TMSFNCTheme,
  FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs, DB, WEBLib.DB, WEBLib.CDS,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton, WEBLib.TMSFNCEdit, WEBLib.TMSFNCComboBox,
  WEBLib.TMSFNCDatePicker, WEBLib.TMSFNCTrackBar, WEBLib.TMSFNCSwitch, WEBLib.TMSFNCStackPanel,
  WEBLib.TMSFNCDataGrid, WEBLib.TMSFNCDataNavigator, WEBLib.TMSFNCSampleData, WEBLib.TMSFNCTheme,
  WEBLib.TMSFNCThemeSelector,
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
    FIndicatorCheck: TTMSFNCCheckBox;
    FAggregatesCheck: TTMSFNCCheckBox;
    FSearchCheck: TTMSFNCCheckBox;
    FStretchCheck: TTMSFNCCheckBox;
    FBooleanCheck: TTMSFNCCheckBox;
    FStatus: TTMSFNCHTMLText;
    FCustomers: TDemoDataSet;
    FOrders: TDemoDataSet;
    FCustomersSource: TDataSource;
    FOrdersSource: TDataSource;
    FGrid: TTMSFNCDataGrid;
    FNavigator: TTMSFNCDataNavigator;
    FCustomerEdit: TTMSFNCEdit;
    procedure CreateData;
    procedure CreateSettings;
    procedure CreateContent;
    procedure CreateForm(AParent: TDemoParent);
    procedure ApplySettings;
    procedure SettingChanged(Sender: TObject);
    procedure DataChange(Sender: TObject; Field: TField);
    procedure NewRecord(DataSet: TDataSet);
    function FieldLabel(AParent: TDemoParent; const AText: string): TTMSFNCHTMLText;
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
  Carriers: array[0..3] of string = ('Post', 'Courier', 'Express', 'Pick-up');

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
  names: TArray<string>;
  orders: TArray<TTMSFNCSampleOrder>;
  I, c: Integer;
begin
  { customers: the lookup table of the orders }
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
  FCustomers.First;
  FCustomersSource := FLayout.NewSource(FCustomers);

  { orders: the fields carry the labels, widths and formats the grid columns take over }
  FOrders := FLayout.NewDataSet;
  FOrders.FieldDefs.Add('Number', ftString, 10);
  FOrders.FieldDefs.Add('OrderDate', ftDate);
  FOrders.FieldDefs.Add('CustomerID', ftInteger);
  FOrders.FieldDefs.Add('Carrier', ftString, 20);
  FOrders.FieldDefs.Add('Total', ftFloat);
  FOrders.FieldDefs.Add('Progress', ftInteger);
  FOrders.FieldDefs.Add('Paid', ftBoolean);
  FOrders.FieldDefs.Add('Priority', ftString, 1);
  FOrders.FieldDefs.Add('Note', ftString, 200);
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
    FOrders.FieldByName('Number').AsString := orders[I].Number;
    FOrders.FieldByName('OrderDate').AsDateTime := orders[I].Date;
    FOrders.FieldByName('CustomerID').AsInteger := c;
    FOrders.FieldByName('Carrier').AsString := Carriers[I mod Length(Carriers)];
    FOrders.FieldByName('Total').AsFloat := orders[I].Total;
    FOrders.FieldByName('Progress').AsInteger := orders[I].Progress;
    FOrders.FieldByName('Paid').AsBoolean := orders[I].Status = 'Delivered';
    if I mod 3 = 0 then
      FOrders.FieldByName('Priority').AsString := 'Y'
    else
      FOrders.FieldByName('Priority').AsString := 'N';
    FOrders.FieldByName('Note').AsString := '<b>' + orders[I].Status + '</b>: ' + orders[I].Customer + ', ' +
      orders[I].TotalText;
    FOrders.Post;
  end;
  FOrders.First;
  FOrders.FieldByName('Number').DisplayLabel := 'Order';
  FOrders.FieldByName('Number').DisplayWidth := 8;
  FOrders.FieldByName('OrderDate').DisplayLabel := 'Date';
  FOrders.FieldByName('CustomerID').DisplayLabel := 'Customer';
  FOrders.FieldByName('Total').DisplayLabel := 'Total';
  FOrders.FieldByName('Total').DisplayWidth := 10;
  {$IFNDEF WEBLIB}
  TFloatField(FOrders.FieldByName('Total')).DisplayFormat := '#,##0.00';
  {$ENDIF}
  FOrders.FieldByName('Progress').DisplayLabel := 'Done %';
  FOrders.FieldByName('Progress').DisplayWidth := 6;
  FOrders.FieldByName('Priority').Visible := False;
  FOrders.FieldByName('Note').Visible := False;
  FOrders.OnNewRecord := {$IFDEF WEBLIB}@{$ENDIF}NewRecord;
  FOrdersSource := FLayout.NewSource(FOrders);
  FOrdersSource.OnDataChange := {$IFDEF WEBLIB}@{$ENDIF}DataChange;
end;

procedure TForm1.CreateSettings;
begin
  FSettings := FLayout.AddSettingsPanel(Self, 240);

  FLayout.AddCaption(FSettings, 'Grid');
  FIndicatorCheck := FLayout.AddCheck(FSettings, 'Record indicator', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FAggregatesCheck := FLayout.AddCheck(FSettings, 'Aggregates in the footer', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FSearchCheck := FLayout.AddCheck(FSettings, 'Find by typing in the grid', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FStretchCheck := FLayout.AddCheck(FSettings, 'Stretch the last column', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FBooleanCheck := FLayout.AddCheck(FSettings, 'Boolean field as a check box', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FLayout.AddText(FSettings, 'The grid, the editors and the navigator share one TDataSource; there is no adapter ' +
    'component. Type in the customer field to search the customers.', 84);

  FLayout.AddCaption(FSettings, 'Current order');
  FStatus := FLayout.AddText(FSettings, '', 80);
end;

function TForm1.FieldLabel(AParent: TDemoParent; const AText: string): TTMSFNCHTMLText;
begin
  Result := FLayout.AddCaption(AParent, AText, 6);
  Result.Font.Style := [];
  Result.TextRole := htrSecondary;
end;

procedure TForm1.CreateForm(AParent: TDemoParent);
var
  stack: TTMSFNCStackPanel;
  e: TTMSFNCEdit;
  cb: TTMSFNCComboBox;
  dp: TTMSFNCDatePicker;
  tb: TTMSFNCTrackBar;
  sw: TTMSFNCSwitch;
  ck: TTMSFNCCheckBox;
  t: TTMSFNCHTMLText;
  I: Integer;
begin
  stack := TTMSFNCStackPanel.Create(Self);
  stack.Parent := AParent;
  FLayout.Place(stack, daClient, 0, 0, 0, 0, 0);
  stack.Appearance.Stroke.Kind := gskNone;
  stack.Gap := 2;

  FieldLabel(stack, 'Order number');
  e := TTMSFNCEdit.Create(Self);
  e.Parent := stack;
  e.Width := FLayout.Size(260);
  e.Height := FLayout.Size(32);
  e.DataSource := FOrdersSource;
  e.DataField := 'Number';

  { the lookup edit: the customers while typing, the key written to the order }
  FieldLabel(stack, 'Customer (type to search)');
  FCustomerEdit := TTMSFNCEdit.Create(Self);
  FCustomerEdit.Parent := stack;
  FCustomerEdit.Width := FLayout.Size(260);
  FCustomerEdit.Height := FLayout.Size(32);
  FCustomerEdit.Lookup.Enabled := True;
  FCustomerEdit.Lookup.ListSource := FCustomersSource;
  FCustomerEdit.Lookup.ListField := 'Company';
  FCustomerEdit.Lookup.KeyField := 'CustomerID';
  FCustomerEdit.Lookup.MatchMode := elmContains;
  FCustomerEdit.Lookup.HighlightMatch := True;
  FCustomerEdit.Lookup.EmptyText := 'No customer matches';
  FCustomerEdit.DataSource := FOrdersSource;
  FCustomerEdit.DataField := 'CustomerID';

  FieldLabel(stack, 'Order date');
  dp := TTMSFNCDatePicker.Create(Self);
  dp.Parent := stack;
  dp.Width := FLayout.Size(180);
  dp.Height := FLayout.Size(32);
  dp.DataSource := FOrdersSource;
  dp.DataField := 'OrderDate';

  FieldLabel(stack, 'Carrier');
  cb := TTMSFNCComboBox.Create(Self);
  cb.Parent := stack;
  cb.Width := FLayout.Size(180);
  cb.Height := FLayout.Size(32);
  for I := 0 to High(Carriers) do
    cb.Items.Add(Carriers[I]);
  cb.DataSource := FOrdersSource;
  cb.DataField := 'Carrier';

  FieldLabel(stack, 'Total');
  e := TTMSFNCEdit.Create(Self);
  e.Parent := stack;
  e.Width := FLayout.Size(180);
  e.Height := FLayout.Size(32);
  e.DataSource := FOrdersSource;
  e.DataField := 'Total';

  FieldLabel(stack, 'Done');
  tb := TTMSFNCTrackBar.Create(Self);
  tb.Parent := stack;
  tb.Width := FLayout.Size(260);
  tb.Height := FLayout.Size(32);
  tb.Min := 0;
  tb.Max := 100;
  tb.DataSource := FOrdersSource;
  tb.DataField := 'Progress';

  FieldLabel(stack, 'Paid');
  sw := TTMSFNCSwitch.Create(Self);
  sw.Parent := stack;
  sw.Width := FLayout.Size(48);
  sw.Height := FLayout.Size(24);
  sw.DataSource := FOrdersSource;
  sw.DataField := 'Paid';

  { a Y/N string field on a check box, its caption from the field label }
  ck := TTMSFNCCheckBox.Create(Self);
  ck.Parent := stack;
  ck.Width := FLayout.Size(260);
  ck.Height := FLayout.Size(32);
  ck.Text := 'Priority order';
  ck.ValueChecked := 'Y';
  ck.ValueUnchecked := 'N';
  ck.DataSource := FOrdersSource;
  ck.DataField := 'Priority';

  FieldLabel(stack, 'Note (read-only HTML)');
  t := TTMSFNCHTMLText.Create(Self);
  t.Parent := stack;
  t.Width := FLayout.Size(260);
  t.Height := FLayout.Size(48);
  t.HorizontalTextAlign := gtaLeading;
  t.VerticalTextAlign := gtaLeading;
  t.WordWrapping := True;
  t.DataSource := FOrdersSource;
  t.DataField := 'Note';
end;

procedure TForm1.CreateContent;
var
  form: TTMSFNCPanel;
begin
  FContent := FLayout.AddContentPanel(Self);

  form := FLayout.AddPanel(FContent, daRight, 300, 16, 0, 0, 0);
  FLayout.AddCaption(form, 'Order', 12);
  CreateForm(form);

  FNavigator := TTMSFNCDataNavigator.Create(Self);
  FNavigator.Parent := FContent;
  FLayout.Place(FNavigator, daTop, 36, 0, 0, 0, 8);
  FNavigator.DataSource := FOrdersSource;

  FGrid := TTMSFNCDataGrid.Create(Self);
  FGrid.Parent := FContent;
  FLayout.Place(FGrid, daClient, 0, 0, 0, 0, 0);
  FGrid.DataSource := FOrdersSource;
end;

procedure TForm1.ApplySettings;
begin
  FGrid.BeginUpdate;
  FGrid.DataOptions.ShowIndicator := FIndicatorCheck.Checked;
  FGrid.DataOptions.ShowAggregates := FAggregatesCheck.Checked;
  FGrid.DataOptions.IncrementalSearch := FSearchCheck.Checked;
  if FStretchCheck.Checked then
    FGrid.DataOptions.ColumnStretch := gdcsLastColumn
  else
    FGrid.DataOptions.ColumnStretch := gdcsNone;
  FGrid.DataOptions.ShowBooleanFields := FBooleanCheck.Checked;
  FGrid.EndUpdate;
end;

procedure TForm1.SettingChanged(Sender: TObject);
begin
  ApplySettings;
end;

procedure TForm1.DataChange(Sender: TObject; Field: TField);
begin
  if not Assigned(FStatus) or not FOrders.Active then
    Exit;
  if FOrders.IsEmpty then
    FStatus.Text := 'No orders'
  else
    FStatus.Text := 'Record ' + IntToStr(FOrders.RecNo) + ' of ' + IntToStr(FOrders.RecordCount) + '<br><b>' +
      FOrders.FieldByName('Number').AsString + '</b>, ' + FormatFloat('#,##0.00', FOrders.FieldByName('Total').AsFloat);
end;

procedure TForm1.NewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('Number').AsString := TTMSFNCSampleData.FormatID(FOrders.RecordCount + 1);
  DataSet.FieldByName('OrderDate').AsDateTime := Date;
  DataSet.FieldByName('CustomerID').AsInteger := 1;
  DataSet.FieldByName('Carrier').AsString := Carriers[0];
  DataSet.FieldByName('Progress').AsInteger := 0;
  DataSet.FieldByName('Paid').AsBoolean := False;
  DataSet.FieldByName('Priority').AsString := 'N';
end;

end.
