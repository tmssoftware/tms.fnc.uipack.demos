unit UDemo;

{ TMS FNC UI Pack - Theming Dashboard demo, TMS WEB Core version: the order management app of the VCL
  and FMX demos, designed in UDemo.dfm with the same FNC components.

  The data is orders.json (UOrdersData): the orders are a TWebClientDataSet the grid shows through a
  TTMSFNCDataGridDatabaseAdapter (OrderSource); the KPI cards, the goals and the projects are computed
  from the rows. The detail card edits the current order; every change is kept for the browser tab.

  Theming: the TTMSFNCThemeManager, the TTMSFNCThemeSelector and the TTMSFNCAccentSelector on the
  form do it all; the demo colors its secondary texts and (WEB draws images as loaded) its icons from
  the current theme's tokens in ThemeChanged. }

interface

uses
  System.SysUtils, System.Classes, Math, JS, Web, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, Data.DB, WEBLib.DB,
  WEBLib.CDS, WEBLib.REST, WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCTheme, WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCCustomComponent, WEBLib.TMSFNCPanel,
  WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCBadge, WEBLib.TMSFNCButton, WEBLib.TMSFNCEdit, WEBLib.TMSFNCComboBox,
  WEBLib.TMSFNCDatePicker, WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCTrackBar, WEBLib.TMSFNCProgressBar,
  WEBLib.TMSFNCSegmentedControl, WEBLib.TMSFNCListBox, WEBLib.TMSFNCStatusBar, WEBLib.TMSFNCSwatchSelector,
  WEBLib.TMSFNCThemeSelector, WEBLib.TMSFNCAccentSelector, WEBLib.TMSFNCDataGridCell, WEBLib.TMSFNCDataGridData,
  WEBLib.TMSFNCDataGridBase, WEBLib.TMSFNCDataGridCore, WEBLib.TMSFNCDataGridRenderer, WEBLib.TMSFNCDataGrid,
  WEBLib.TMSFNCDataGridDatabaseAdapter, WEBLib.TMSFNCTreeViewBase, WEBLib.TMSFNCTreeViewData,
  WEBLib.TMSFNCCustomTreeView, WEBLib.TMSFNCTreeView, WEBLib.TMSFNCCheckedTreeView, UOrdersData;

type
  TForm1 = class(TWebForm)
    ThemeManager: TTMSFNCThemeManager;
    DataRequest: TWebHttpRequest;
    Orders: TWebClientDataSet;
    OrdersId: TIntegerField;
    OrdersCustomer: TStringField;
    OrdersOrderDate: TStringField;
    OrdersAmount: TFloatField;
    OrdersStatus: TStringField;
    OrdersFulfilment: TIntegerField;
    OrdersExpress: TBooleanField;
    OrderSource: TWebDataSource;
    GridAdapter: TTMSFNCDataGridDatabaseAdapter;
    PageHeader: TTMSFNCPanel;
    PageTitle: TTMSFNCHTMLText;
    PageSubtitle: TTMSFNCHTMLText;
    NewOrderButton: TTMSFNCButton;
    ResetButton: TTMSFNCButton;
    KpiRow: TTMSFNCPanel;
    RevenueCard: TTMSFNCPanel;
    RevenueTitle: TTMSFNCHTMLText;
    RevenueValue: TTMSFNCHTMLText;
    RevenueNote: TTMSFNCHTMLText;
    RevenueDelta: TTMSFNCBadge;
    OpenCard: TTMSFNCPanel;
    OpenTitle: TTMSFNCHTMLText;
    OpenValue: TTMSFNCHTMLText;
    OpenNote: TTMSFNCHTMLText;
    OpenDelta: TTMSFNCBadge;
    CustomersCard: TTMSFNCPanel;
    CustomersTitle: TTMSFNCHTMLText;
    CustomersValue: TTMSFNCHTMLText;
    CustomersNote: TTMSFNCHTMLText;
    CustomersDelta: TTMSFNCBadge;
    AverageCard: TTMSFNCPanel;
    AverageTitle: TTMSFNCHTMLText;
    AverageValue: TTMSFNCHTMLText;
    AverageNote: TTMSFNCHTMLText;
    AverageDelta: TTMSFNCBadge;
    Content: TTMSFNCPanel;
    RightColumn: TTMSFNCPanel;
    DetailsCard: TTMSFNCPanel;
    CustomerLabel: TTMSFNCHTMLText;
    CustomerCombo: TTMSFNCComboBox;
    DateLabel: TTMSFNCHTMLText;
    DatePicker: TTMSFNCDatePicker;
    AmountLabel: TTMSFNCHTMLText;
    AmountEdit: TTMSFNCEdit;
    StatusLabel: TTMSFNCHTMLText;
    StatusCombo: TTMSFNCComboBox;
    ExpressCheck: TTMSFNCCheckBox;
    FulfilmentLabel: TTMSFNCHTMLText;
    FulfilmentValue: TTMSFNCHTMLText;
    FulfilmentBar: TTMSFNCTrackBar;
    DeleteButton: TTMSFNCButton;
    SaveButton: TTMSFNCButton;
    CancelButton: TTMSFNCButton;
    DetailsStatus: TTMSFNCBadge;
    GoalsCard: TTMSFNCPanel;
    RevenueGoalLabel: TTMSFNCHTMLText;
    RevenueGoalValue: TTMSFNCHTMLText;
    RevenueGoalBar: TTMSFNCProgressBar;
    OnTimeGoalLabel: TTMSFNCHTMLText;
    OnTimeGoalValue: TTMSFNCHTMLText;
    OnTimeGoalBar: TTMSFNCProgressBar;
    RetentionGoalLabel: TTMSFNCHTMLText;
    RetentionGoalValue: TTMSFNCHTMLText;
    RetentionGoalBar: TTMSFNCProgressBar;
    LeftColumn: TTMSFNCPanel;
    OrdersCard: TTMSFNCPanel;
    FilterChips: TTMSFNCSegmentedControl;
    SearchEdit: TTMSFNCEditButton;
    OrdersGrid: TTMSFNCDataGrid;
    ViewAllLink: TTMSFNCHTMLText;
    ProjectsCard: TTMSFNCPanel;
    ProjectsNote: TTMSFNCHTMLText;
    ProjectTree: TTMSFNCCheckedTreeView;
    NavPanel: TTMSFNCPanel;
    NavList: TTMSFNCListBox;
    SettingsList: TTMSFNCListBox;
    StatusBar: TTMSFNCStatusBar;
    TopBar: TTMSFNCPanel;
    AppTitle: TTMSFNCHTMLText;
    AccentSelector: TTMSFNCAccentSelector;
    Avatar: TTMSFNCBadge;
    AppMark: TTMSFNCBadge;
    ThemeSelector: TTMSFNCThemeSelector;
    procedure WebFormCreate(Sender: TObject);
    procedure WebFormResize(Sender: TObject);
    procedure DataRequestResponse(Sender: TObject; AResponse: string);
    procedure OrdersAfterOpen(DataSet: TDataSet);
    procedure OrdersChanged(DataSet: TDataSet);
    procedure OrdersNewRecord(DataSet: TDataSet);
    procedure OrdersFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure OrdersIdGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure OrdersOrderDateGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure OrdersAmountGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure OrderSourceDataChange(Sender: TObject; Field: TField);
    procedure NavListItemSelected(Sender: TObject; AItem: TTMSFNCListBoxItem);
    procedure FilterChipsAfterSelectItem(Sender: TObject; AItemIndex: Integer);
    procedure ViewAllLinkAnchorClick(Sender: TObject; AAnchor: string);
    procedure OrdersGridGetCellLayout(Sender: TObject; ACell: TTMSFNCDataGridCell);
    procedure NewOrderButtonClick(Sender: TObject);
    procedure ResetButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure FulfilmentBarValueChanged(Sender: TObject; AValue: Single);
    procedure DatePickerDateSelected(Sender: TObject; ADate: TDate);
    procedure ProjectTreeNodeChecked(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer);
    procedure ProjectTreeGetNodeTextColor(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer;
      var ATextColor: TTMSFNCGraphicsColor);
  private
    FData: TOrdersData;
    FLoading: Boolean;
    FOrderDate: TDate;
    procedure SearchEditChange(Sender: TObject);
    procedure ThemeChanged(Sender: TObject);
    procedure ShowKpis;
    procedure FillProjects;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

const
  StatusNames: array[0..3] of string = ('Open', 'Packing', 'Shipped', 'Late');
  StatusKinds: array[0..3] of TTMSFNCStatusKind = (tskInfo, tskWarning, tskSuccess, tskError);
  { the icons (WEB draws an image as it is loaded: they are loaded in the colors of the theme) }
  NavIcons: array[0..5] of string = ('<path d="M3 9.5 9 4l6 5.5V15H3z"/>',
    '<rect x="3" y="3.5" width="12" height="11" rx="1.5"/><path d="M3 7.5h12"/>',
    '<circle cx="9" cy="6.5" r="3"/><path d="M3.5 15c.8-2.8 3-4 5.5-4s4.7 1.2 5.5 4"/>',
    '<rect x="3" y="4" width="12" height="11" rx="1.5"/><path d="M3 8h12M6.5 2.5v3M11.5 2.5v3"/>',
    '<path d="M4 14.5V9M9 14.5V4M14 14.5v-7"/>', '<circle cx="9" cy="9" r="2.5"/><path d="M9 2.5v2M9 13.5v2M2.5 ' +
    '9h2M13.5 9h2M4.4 4.4l1.4 1.4M12.2 12.2l1.4 1.4M4.4 13.6l1.4-1.4M12.2 5.8l1.4-1.4"/>');
  MarkIcon = '<g transform="translate(4 4)"><rect x="2.5" y="2.5" width="4.5" height="4.5" rx="1"/><rect x="9" ' +
    'y="2.5" width="4.5" height="4.5" rx="1"/><rect x="2.5" y="9" width="4.5" height="4.5" rx="1"/><rect x="9" ' +
    'y="9" width="4.5" height="4.5" rx="1"/></g>';
  SearchIcon = '<circle cx="7" cy="7" r="4.5"/><path d="m10.5 10.5 3 3"/>';

function Theme: TTMSFNCResolvedTheme;
begin
  Result := nil;
  if TTMSFNCTheme.Current <> '' then
    Result := TTMSFNCTheme.Resolve(TTMSFNCTheme.Current);
end;

{ an SVG icon in a color, as a data URL a bitmap loads }
function Icon(const ABody: string; AColor: TTMSFNCGraphicsColor; AWidth, AHeight, AShift: Integer): string;
var
  s: string;
begin
  s := Format('<svg xmlns="http://www.w3.org/2000/svg" width="%d" height="%d" viewBox="0 0 %d %d" fill="none" ' +
    'stroke="%s" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><g transform="translate(%d 0)">%s' +
    '</g></svg>', [AWidth, AHeight, AWidth, AHeight, TTMSFNCGraphics.ColorToHTML(AColor), AShift, ABody]);
  asm
    s = 'data:image/svg+xml;base64,' + window.btoa(s);
  end;
  Result := s;
end;

{ a change against the month before: '+12.4%' (success) or '-0.1%' (error) }
procedure ShowChange(ABadge: TTMSFNCBadge; ANow, APrevious: Double);
begin
  if ANow >= APrevious then
    ABadge.Text := Format('+%.1f%%', [100 * (ANow - APrevious) / Max(APrevious, 1)])
  else
    ABadge.Text := Format(#$2212'%.1f%%', [100 * (APrevious - ANow) / APrevious]);
  if ANow >= APrevious then
    ABadge.Kind := tskSuccess
  else
    ABadge.Kind := tskError;
end;

procedure TForm1.WebFormCreate(Sender: TObject);
begin
  FormatSettings := TFormatSettings.Create('en-US');
  FormatSettings.ShortDateFormat := 'mmm d, yyyy';
  { the edit inside the search box: its events and placeholder are not published }
  SearchEdit.Edit.OnChange := @SearchEditChange;
  SearchEdit.Edit.TextHint := 'Search orders';
  NavList.ItemIndex := 0;
  TTMSFNCTheme.AddChangeListener(@ThemeChanged);
  ThemeChanged(nil);
  { this tab's data, or orders.json }
  FData := TOrdersData.Create(Orders);
  if not FData.Restore then
    DataRequest.Execute;
end;

procedure TForm1.DataRequestResponse(Sender: TObject; AResponse: string);
begin
  FData.Load(AResponse);
end;

{ the four KPI cards share the row; the status bar's spacer pushes the versions to the end }
procedure TForm1.WebFormResize(Sender: TObject);
var
  I, w: Integer;
begin
  w := (KpiRow.Width - 3 * RevenueCard.Margins.Right) div 4;
  RevenueCard.Width := w;
  OpenCard.Width := w;
  CustomersCard.Width := w;
  w := StatusBar.Width;
  for I := 0 to StatusBar.Panels.Count - 1 do
    if I <> 3 then
      w := w - StatusBar.Panels.Items[I].Width;
  StatusBar.Panels.Items[3].Width := w;
end;

{ the theme's secondary text color for the secondary labels, its name in the status bar, the icons }
procedure TForm1.ThemeChanged(Sender: TObject);
var
  t: TTMSFNCResolvedTheme;
  l: TTMSFNCHTMLText;
  ls: array of TTMSFNCHTMLText;
  I: Integer;
begin
  t := Theme;
  if not Assigned(t) then
    Exit;
  ls := [PageSubtitle, RevenueTitle, RevenueNote, OpenTitle, OpenNote, CustomersTitle, CustomersNote, AverageTitle,
    AverageNote, FulfilmentValue, RevenueGoalValue, OnTimeGoalValue, RetentionGoalValue, ProjectsNote];
  for l in ls do
    l.Font.Color := t[ttTextSecondary];
  SettingsList.Items[0].TextColor := t[ttTextSecondary];
  StatusBar.Panels.Items[1].Text := Format('Theme: <font color="%s"><b>%s</b></font>',
    [TTMSFNCGraphics.ColorToHTML(t[ttText]), TTMSFNCTheme.Current]);
  AccentSelector.Visible := t.Mode <> tmHighContrast;
  for I := 0 to NavList.Items.Count - 1 do
    if I = NavList.ItemIndex then
      NavList.Items[I].Bitmap.LoadFromURL(Icon(NavIcons[I], NavList.ItemsAppearance.SelectedFont.Color, 25, 18, 5))
    else
      NavList.Items[I].Bitmap.LoadFromURL(Icon(NavIcons[I], NavList.ItemsAppearance.Font.Color, 25, 18, 5));
  SettingsList.Items[0].Bitmap.LoadFromURL(Icon(NavIcons[5], t[ttTextSecondary], 25, 18, 5));
  AppMark.Bitmap.LoadFromURL(Icon(MarkIcon, t[ttAccentText], 24, 24, 0));
  SearchEdit.Bitmap.LoadFromURL(Icon(SearchIcon, t[ttTextTertiary], 16, 16, 0));
end;

procedure TForm1.OrdersAfterOpen(DataSet: TDataSet);
var
  c: JSValue;
begin
  CustomerCombo.Items.Clear;
  for c in FData.Customers do
    CustomerCombo.Items.Add(string(TJSObject(c)['name']));
  FillProjects;
  ShowKpis;
end;

{ after a post or a delete: kept for the tab, the figures again }
procedure TForm1.OrdersChanged(DataSet: TDataSet);
begin
  FData.Save;
  ShowKpis;
end;

procedure TForm1.ShowKpis;
var
  k: TOrderKpis;
begin
  k := FData.Kpis;
  RevenueValue.Text := Format('$%.1nK', [k.Revenue / 1000]);
  ShowChange(RevenueDelta, k.Revenue, k.RevenuePrev);
  OpenValue.Text := IntToStr(k.OpenOrders);
  OpenDelta.Text := IntToStr(k.LateOrders) + ' late';
  if k.LateOrders > 0 then
    OpenDelta.Kind := tskWarning
  else
    OpenDelta.Kind := tskSuccess;
  CustomersValue.Text := IntToStr(k.Customers);
  CustomersDelta.Text := '+' + IntToStr(k.NewCustomers) + ' new';
  AverageValue.Text := Format('$%.0n', [k.AvgOrder]);
  ShowChange(AverageDelta, k.AvgOrder, k.AvgOrderPrev);
  RevenueGoalBar.Value := k.GoalRevenue;
  RevenueGoalValue.Text := Format('%.0f%%', [k.GoalRevenue]);
  OnTimeGoalBar.Value := k.GoalOnTime;
  OnTimeGoalValue.Text := Format('%.0f%%', [k.GoalOnTime]);
  RetentionGoalBar.Value := k.GoalRetention;
  RetentionGoalValue.Text := Format('%.0f%%', [k.GoalRetention]);
  NavList.Items[1].Badge := IntToStr(k.OpenOrders);
  PageSubtitle.Text := FormatDateTime('mmmm yyyy', k.RefDate) + ' '#$00B7' all regions';
  StatusBar.Panels.Items[2].Text := IntToStr(k.OrderCount) + ' orders';
  OrdersCard.Footer.Text := Format('%d of %d orders', [Orders.RecordCount, k.OrderCount]);
end;

procedure TForm1.OrdersNewRecord(DataSet: TDataSet);
begin
  OrdersId.AsInteger := FData.NextId;
  OrdersCustomer.AsString := CustomerCombo.Items[0];
  OrdersOrderDate.AsString := ISODate(Date);
  OrdersAmount.AsFloat := 0;
  OrdersStatus.AsString := 'Open';
  OrdersFulfilment.AsInteger := 0;
  OrdersExpress.AsBoolean := False;
end;

procedure TForm1.OrdersFilterRecord(DataSet: TDataSet; var Accept: Boolean);
var
  q: string;
begin
  q := LowerCase(Trim(SearchEdit.Text));
  Accept := ((FilterChips.ItemIndex <= 0) or (OrdersStatus.AsString = FilterChips.Items[FilterChips.ItemIndex].Text)) and
    ((q = '') or (Pos(q, LowerCase(OrdersCustomer.AsString + ' #' + OrdersId.AsString)) > 0));
end;

procedure TForm1.OrdersIdGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  Text := '#' + Sender.AsString;
end;

procedure TForm1.OrdersOrderDateGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  Text := FormatDateTime('mmm dd', ParseISODate(Sender.AsString));
end;

procedure TForm1.OrdersAmountGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  Text := FormatFloat('$#,##0.00', Sender.AsFloat);
end;

{ the detail card shows the current order; not while Save writes the card to the record }
procedure TForm1.OrderSourceDataChange(Sender: TObject; Field: TField);
var
  s: Integer;
begin
  if Assigned(Field) or (Orders.State = dsEdit) or not Orders.Active then
    Exit;
  if Orders.State = dsInsert then
    DetailsCard.Header.Text := 'New order'
  else
    DetailsCard.Header.Text := 'Order #' + OrdersId.AsString;
  CustomerCombo.Text := OrdersCustomer.AsString;
  FOrderDate := ParseISODate(OrdersOrderDate.AsString);
  DatePicker.SelectedDate := FOrderDate;
  AmountEdit.FloatValue := OrdersAmount.AsFloat;
  s := StatusCombo.Items.IndexOf(OrdersStatus.AsString);
  StatusCombo.ItemIndex := s;
  ExpressCheck.Checked := OrdersExpress.AsBoolean;
  FulfilmentBar.Value := OrdersFulfilment.AsInteger;
  DetailsStatus.Text := OrdersStatus.AsString;
  if s >= 0 then
    DetailsStatus.Kind := StatusKinds[s];
end;

procedure TForm1.SaveButtonClick(Sender: TObject);
begin
  if Orders.IsEmpty and (Orders.State <> dsInsert) then
    Exit;
  Orders.Edit;
  OrdersCustomer.AsString := Trim(CustomerCombo.Text);
  OrdersOrderDate.AsString := ISODate(FOrderDate);
  OrdersAmount.AsFloat := AmountEdit.FloatValue;
  OrdersStatus.AsString := StatusNames[Max(0, StatusCombo.ItemIndex)];
  { a shipped order is complete }
  if StatusCombo.ItemIndex = 2 then
    OrdersFulfilment.AsInteger := 100
  else
    OrdersFulfilment.AsInteger := Round(FulfilmentBar.Value);
  OrdersExpress.AsBoolean := ExpressCheck.Checked;
  Orders.Post;
end;

procedure TForm1.CancelButtonClick(Sender: TObject);
begin
  if Orders.State in dsEditModes then
    Orders.Cancel
  else
    OrderSourceDataChange(nil, nil);
end;

procedure TForm1.NewOrderButtonClick(Sender: TObject);
begin
  Orders.First;
  Orders.Insert;
end;

procedure TForm1.DeleteButtonClick(Sender: TObject);
begin
  if Orders.State = dsInsert then
    Orders.Cancel
  else if not Orders.IsEmpty then
    Orders.Delete;
end;

{ forget this tab's changes: orders.json again }
procedure TForm1.ResetButtonClick(Sender: TObject);
begin
  FData.Forget;
  DataRequest.Execute;
end;

procedure TForm1.FilterChipsAfterSelectItem(Sender: TObject; AItemIndex: Integer);
begin
  SearchEditChange(Sender);
end;

procedure TForm1.SearchEditChange(Sender: TObject);
begin
  Orders.Filtered := False;
  Orders.Filtered := (FilterChips.ItemIndex > 0) or (Trim(SearchEdit.Text) <> '');
  ShowKpis;
end;

procedure TForm1.ViewAllLinkAnchorClick(Sender: TObject; AAnchor: string);
begin
  FilterChips.ItemIndex := 0;
  SearchEdit.Text := '';
  SearchEditChange(Sender);
end;

procedure TForm1.NavListItemSelected(Sender: TObject; AItem: TTMSFNCListBoxItem);
begin
  if FLoading or not Assigned(AItem) then
    Exit;
  FLoading := True;
  try
    if Sender = NavList then
      SettingsList.ItemIndex := -1
    else
      NavList.ItemIndex := -1;
  finally
    FLoading := False;
  end;
  PageTitle.Text := AItem.Text;
  ThemeChanged(nil);
end;

procedure TForm1.FulfilmentBarValueChanged(Sender: TObject; AValue: Single);
begin
  FulfilmentValue.Text := Format('%d%%', [Round(AValue)]);
end;

{ the picked date (the picker's SelectedDate reads its calendar, which an assigned date does not reach) }
procedure TForm1.DatePickerDateSelected(Sender: TObject; ADate: TDate);
begin
  FOrderDate := ADate;
end;

{ the projects, each with its tasks; a checked task is done }
procedure TForm1.FillProjects;
var
  v: JSValue;
  p: TJSObject;
  n, project: TTMSFNCTreeViewNode;
  done, total: Integer;
begin
  FLoading := True;
  ProjectTree.BeginUpdate;
  try
    ProjectTree.ClearNodes;
    project := nil;
    done := 0;
    total := 0;
    for v in FData.Projects do
    begin
      p := TJSObject(v);
      if Integer(p['parent_id']) = 0 then
      begin
        n := ProjectTree.AddNode(nil);
        project := n;
      end
      else
      begin
        n := ProjectTree.AddNode(project);
        Inc(total);
        if Boolean(p['done']) then
          Inc(done);
      end;
      n.Text[0] := string(p['name']);
      n.Text[1] := string(p['owner']);
      n.Text[2] := string(p['status']);
      n.DataInteger := Integer(p['id']);
      n.CheckTypes[0] := tvntCheckBox;
      ProjectTree.Checked[n] := Boolean(p['done']);
    end;
    ProjectTree.ExpandAll;
  finally
    ProjectTree.EndUpdate;
    FLoading := False;
  end;
  ProjectsNote.Text := Format('%d of %d tasks done', [done, total]);
end;

procedure TForm1.ProjectTreeNodeChecked(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer);
begin
  if FLoading or not Assigned(ANode.Node) then
    Exit;
  FData.SetDone(ANode.Node.DataInteger, ProjectTree.Checked[ANode.Node]);
  FillProjects;
end;

{ the order number semibold in the accent's text color, the date in the secondary text color; the
  text 18 px in at the card's edges, 12 px between the columns }
procedure TForm1.OrdersGridGetCellLayout(Sender: TObject; ACell: TTMSFNCDataGridCell);
var
  t: TTMSFNCResolvedTheme;
begin
  if ACell.Column = 0 then
    ACell.Layout.TextMargins.Left := 18
  else
    ACell.Layout.TextMargins.Left := 12;
  if ACell.Column = 3 then
  begin
    ACell.Layout.TextAlign := gtaTrailing;
    ACell.Layout.TextMargins.Right := 12;
  end;
  t := Theme;
  { the header and the selected row keep the grid's colors }
  if (ACell.Row = 0) or not Assigned(t) or OrdersGrid.IsCellSelected(MakeCell(ACell.Column, ACell.Row)) then
    Exit;
  if ACell.Column = 0 then
  begin
    ACell.Layout.Font.Color := t[ttAccentText];
    ACell.Layout.Font.Name := TTMSFNCTheme.SemiboldFamily(ACell.Layout.Font.Name);
  end
  else if ACell.Column = 2 then
    ACell.Layout.Font.Color := t[ttTextSecondary];
end;

{ the owners in the secondary text color }
procedure TForm1.ProjectTreeGetNodeTextColor(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer;
  var ATextColor: TTMSFNCGraphicsColor);
var
  t: TTMSFNCResolvedTheme;
begin
  t := Theme;
  if (AColumn = 1) and Assigned(t) then
    ATextColor := t[ttTextSecondary];
end;

end.
