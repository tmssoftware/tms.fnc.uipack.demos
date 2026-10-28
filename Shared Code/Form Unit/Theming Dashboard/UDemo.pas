unit UDemo;

{ TMS FNC UI Pack - Theming Dashboard demo: an order management app on FNC components.

  The page is designed in UDemo.dfm (VCL) and UDemo.fmx (FMX); the data module UOrdersData holds the
  SQLite database. This unit only reacts to events:
  * the orders grid shows the orders through a TTMSFNCDataGridDatabaseAdapter (OrderSource); the
    filter chips and the search box filter them;
  * the detail card edits the current order; Save posts it to the database, New order adds one,
    Delete removes it;
  * the KPI cards, the goals and the counters follow the Kpis query (KpiSource), which the data
    module refreshes after every change;
  * the projects card lists the project tasks; checking one marks it done in the database.

  Theming: the TTMSFNCThemeManager on the form (Scope tsApplication) themes every FNC control; the
  TTMSFNCThemeSelector and the TTMSFNCAccentSelector in the header switch the theme and its accent
  by themselves. The demo only colors its secondary texts from the current theme's tokens
  (ThemeChanged), which no property of a label expresses. }

interface

uses
  System.SysUtils, System.Classes, System.Types, System.UITypes, System.Math, Data.DB, UOrdersData,
  {$IFDEF VCL}
  Vcl.Controls, Vcl.Forms, Vcl.Graphics, VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics,
  VCL.TMSFNCGraphicsTypes, VCL.TMSFNCTheme, VCL.TMSFNCCustomControl, VCL.TMSFNCCustomComponent, VCL.TMSFNCPanel,
  VCL.TMSFNCHTMLText, VCL.TMSFNCBadge, VCL.TMSFNCButton, VCL.TMSFNCEdit, VCL.TMSFNCComboBox, VCL.TMSFNCDatePicker,
  VCL.TMSFNCCheckBox, VCL.TMSFNCTrackBar, VCL.TMSFNCProgressBar, VCL.TMSFNCSegmentedControl, VCL.TMSFNCListBox,
  VCL.TMSFNCStatusBar, VCL.TMSFNCSwatchSelector, VCL.TMSFNCThemeSelector, VCL.TMSFNCAccentSelector,
  VCL.TMSFNCDataGridCell, VCL.TMSFNCDataGridData, VCL.TMSFNCDataGridBase, VCL.TMSFNCDataGridCore,
  VCL.TMSFNCDataGridRenderer, VCL.TMSFNCDataGrid, VCL.TMSFNCDataGridDatabaseAdapter, VCL.TMSFNCTreeViewBase,
  VCL.TMSFNCTreeViewData, VCL.TMSFNCCustomTreeView, VCL.TMSFNCTreeView, VCL.TMSFNCCheckedTreeView;
  {$ENDIF}
  {$IFDEF FMX}
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics,
  FMX.TMSFNCGraphicsTypes, FMX.TMSFNCTheme, FMX.TMSFNCCustomControl, FMX.TMSFNCCustomComponent, FMX.TMSFNCPanel,
  FMX.TMSFNCHTMLText, FMX.TMSFNCBadge, FMX.TMSFNCButton, FMX.TMSFNCEdit, FMX.TMSFNCComboBox, FMX.TMSFNCDatePicker,
  FMX.TMSFNCCheckBox, FMX.TMSFNCTrackBar, FMX.TMSFNCProgressBar, FMX.TMSFNCSegmentedControl, FMX.TMSFNCListBox,
  FMX.TMSFNCStatusBar, FMX.TMSFNCSwatchSelector, FMX.TMSFNCThemeSelector, FMX.TMSFNCAccentSelector,
  FMX.TMSFNCDataGridCell, FMX.TMSFNCDataGridData, FMX.TMSFNCDataGridBase, FMX.TMSFNCDataGridCore,
  FMX.TMSFNCDataGridRenderer, FMX.TMSFNCDataGrid, FMX.TMSFNCDataGridDatabaseAdapter, FMX.TMSFNCTreeViewBase,
  FMX.TMSFNCTreeViewData, FMX.TMSFNCCustomTreeView, FMX.TMSFNCTreeView, FMX.TMSFNCCheckedTreeView;
  {$ENDIF}

type
  TForm1 = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    OrderSource: TDataSource;
    KpiSource: TDataSource;
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
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure OrderSourceDataChange(Sender: TObject; Field: TField);
    procedure KpiSourceDataChange(Sender: TObject; Field: TField);
    procedure NavListItemSelected(Sender: TObject; AItem: TTMSFNCListBoxItem);
    procedure SearchEditChange(Sender: TObject);
    procedure FilterChipsAfterSelectItem(Sender: TObject; AItemIndex: Integer);
    procedure ViewAllLinkAnchorClick(Sender: TObject; AAnchor: string);
    procedure OrdersGridGetCellLayout(Sender: TObject; ACell: TTMSFNCDataGridCell);
    procedure NewOrderButtonClick(Sender: TObject);
    procedure ResetButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure FulfilmentBarValueChanged(Sender: TObject; AValue: Single);
    procedure ProjectTreeNodeChecked(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer);
    procedure ProjectTreeGetNodeTextColor(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer;
      var ATextColor: TTMSFNCGraphicsColor);
  private
    FLoading: Boolean;
    procedure ThemeChanged(Sender: TObject);
    procedure FillProjects;
  end;

var
  Form1: TForm1;

implementation

{$IFDEF FMX}
{$R *.fmx}
{$ELSE}
{$R *.dfm}
{$ENDIF}

{$IFDEF DASHBOARD_AUTOMATION}
{ the unattended tests of the TMS build (not part of the demo, only in a build with this define) }
uses
  UDashboardAutomation;
{$ENDIF}

const
  StatusKinds: array[0..3] of TTMSFNCStatusKind = (tskInfo, tskWarning, tskSuccess, tskError);

type
  TControlAccess = class(TTMSFNCCustomControl);

function Theme: TTMSFNCResolvedTheme;
begin
  Result := nil;
  if TTMSFNCTheme.Current <> '' then
    Result := TTMSFNCTheme.Resolve(TTMSFNCTheme.Current);
end;

procedure TForm1.FormCreate(Sender: TObject);
{$IFDEF VCL}
var
  c: TTMSFNCCustomControl;
{$ENDIF}
begin
  {$IFDEF VCL}
  { VCL: the pills and bars of the grid and the tree antialiased (GDI+, ClearType text). These properties
    are not published. }
  for c in TArray<TTMSFNCCustomControl>.Create(OrdersGrid, ProjectTree) do
  begin
    TControlAccess(c).NativeCanvas := True;
    TControlAccess(c).TextQuality := gtqClearType;
  end;
  {$ENDIF}
  OrdersData.Customers.First;
  while not OrdersData.Customers.Eof do
  begin
    CustomerCombo.Items.Add(OrdersData.Customers.Fields[0].AsString);
    OrdersData.Customers.Next;
  end;
  FillProjects;
  TTMSFNCTheme.AddChangeListener(ThemeChanged);
  ThemeChanged(nil);
  { designed for 1440 x 1277: on a smaller screen the window fits the work area }
  if Height > Screen.WorkAreaHeight then
    SetBounds(Left, Round(Screen.WorkAreaTop), Width, Round(Screen.WorkAreaHeight));
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  TTMSFNCTheme.RemoveChangeListener(ThemeChanged);
end;

{ the four KPI cards share the row; the status bar's spacer pushes the versions to the end }
procedure TForm1.FormResize(Sender: TObject);
var
  I: Integer;
  w: Single;
begin
  if not Assigned(StatusBar) then
    Exit;
  w := (KpiRow.Width - 3 * RevenueCard.Margins.Right) / 4;
  RevenueCard.Width := Round(w);
  OpenCard.Width := Round(w);
  CustomersCard.Width := Round(w);
  w := StatusBar.Width;
  for I := 0 to StatusBar.Panels.Count - 1 do
    if I <> 3 then
      w := w - StatusBar.Panels.Items[I].Width;
  StatusBar.Panels.Items[3].Width := Round(w);
end;

{ the theme's secondary text color for the settings item, its name in the status bar }
procedure TForm1.ThemeChanged(Sender: TObject);
var
  t: TTMSFNCResolvedTheme;
begin
  t := Theme;
  if not Assigned(t) then
    Exit;
  SettingsList.Items[0].TextColor := t[ttTextSecondary];
  StatusBar.Panels.Items[1].Text := Format('Theme: <font color="%s"><b>%s</b></font>',
    [TTMSFNCGraphics.ColorToHTML(t[ttText]), TTMSFNCTheme.Current]);
  { High Contrast uses the system's colors: no accent swatches }
  AccentSelector.Visible := t.Mode <> tmHighContrast;
end;

{ the KPI cards, the goals and the counters: the Kpis query has the figures and their texts }
procedure TForm1.KpiSourceDataChange(Sender: TObject; Field: TField);
const
  Change: array[Boolean] of TTMSFNCStatusKind = (tskError, tskSuccess);
  Late: array[Boolean] of TTMSFNCStatusKind = (tskSuccess, tskWarning);
var
  k: TDataSet;
begin
  k := OrdersData.Kpis;
  if k.IsEmpty then
    Exit;
  RevenueValue.Text := k['revenue_text'];
  RevenueDelta.Text := k['revenue_change'];
  RevenueDelta.Kind := Change[k['revenue'] >= k['revenue_prev']];
  OpenValue.Text := k['open_orders'];
  OpenDelta.Text := k['late_text'];
  OpenDelta.Kind := Late[k['late_orders'] > 0];
  CustomersValue.Text := k['customers'];
  CustomersDelta.Text := k['new_text'];
  AverageValue.Text := k['average_text'];
  AverageDelta.Text := k['average_change'];
  AverageDelta.Kind := Change[k['avg_order'] >= k['avg_order_prev']];
  RevenueGoalBar.Value := k['goal_revenue'];
  RevenueGoalValue.Text := k['goal_revenue_text'];
  OnTimeGoalBar.Value := k['goal_on_time'];
  OnTimeGoalValue.Text := k['goal_on_time_text'];
  RetentionGoalBar.Value := k['goal_retention'];
  RetentionGoalValue.Text := k['goal_retention_text'];
  NavList.Items[1].Badge := k['open_orders'];
  PageSubtitle.Text := FormatDateTime('mmmm yyyy', EncodeDate(k['ref_year'], k['ref_month'], 1)) + ' '#$00B7' all regions';
  StatusBar.Panels.Items[2].Text := Format('%d orders', [Integer(k['order_count'])]);
  OrdersCard.Footer.Text := Format('%d of %d orders', [OrdersData.Orders.RecordCount, Integer(k['order_count'])]);
end;

{ the detail card shows the current order (Field = nil: another record, or the dataset changed); not
  while Save writes the card to the record (dsEdit) }
procedure TForm1.OrderSourceDataChange(Sender: TObject; Field: TField);
var
  d: TOrdersData;
begin
  d := OrdersData;
  if Assigned(Field) or not Assigned(d) or (d.Orders.State = dsEdit) then
    Exit;
  if d.Orders.State = dsInsert then
    DetailsCard.Header.Text := 'New order'
  else
    DetailsCard.Header.Text := 'Order ' + d.OrdersId.DisplayText;
  CustomerCombo.Text := d.OrdersCustomer.AsString;
  DatePicker.SelectedDate := d.OrdersOrderDate.AsDateTime;
  AmountEdit.FloatValue := d.OrdersAmount.AsFloat;
  StatusCombo.ItemIndex := StatusCombo.Items.IndexOf(d.OrdersStatus.AsString);
  ExpressCheck.Checked := d.OrdersExpress.AsBoolean;
  FulfilmentBar.Value := d.OrdersFulfilment.AsInteger;
  DetailsStatus.Text := d.OrdersStatus.AsString;
  if StatusCombo.ItemIndex >= 0 then
    DetailsStatus.Kind := StatusKinds[StatusCombo.ItemIndex];
end;

procedure TForm1.SaveButtonClick(Sender: TObject);
var
  d: TOrdersData;
begin
  d := OrdersData;
  if d.Orders.IsEmpty and (d.Orders.State <> dsInsert) then
    Exit;
  d.Orders.Edit;
  d.OrdersCustomer.AsString := Trim(CustomerCombo.Text);
  d.OrdersOrderDate.AsDateTime := DatePicker.SelectedDate;
  d.OrdersAmount.AsFloat := AmountEdit.FloatValue;
  d.OrdersStatus.AsString := StatusCombo.Items[Max(0, StatusCombo.ItemIndex)];
  { a shipped order is complete }
  if StatusCombo.ItemIndex = 2 then
    d.OrdersFulfilment.AsInteger := 100
  else
    d.OrdersFulfilment.AsInteger := Round(FulfilmentBar.Value);
  d.OrdersExpress.AsBoolean := ExpressCheck.Checked;
  d.Orders.Post;
end;

procedure TForm1.CancelButtonClick(Sender: TObject);
begin
  if OrdersData.Orders.State in dsEditModes then
    OrdersData.Orders.Cancel
  else
    OrderSourceDataChange(nil, nil);
end;

procedure TForm1.NewOrderButtonClick(Sender: TObject);
begin
  OrdersData.Orders.First;
  OrdersData.Orders.Insert;
end;

procedure TForm1.DeleteButtonClick(Sender: TObject);
begin
  if OrdersData.Orders.State = dsInsert then
    OrdersData.Orders.Cancel
  else if not OrdersData.Orders.IsEmpty then
    OrdersData.Orders.Delete;
end;

procedure TForm1.ResetButtonClick(Sender: TObject);
begin
  OrdersData.Reset;
  FillProjects;
end;

procedure TForm1.FilterChipsAfterSelectItem(Sender: TObject; AItemIndex: Integer);
begin
  SearchEditChange(Sender);
end;

procedure TForm1.SearchEditChange(Sender: TObject);
begin
  if FilterChips.ItemIndex > 0 then
    OrdersData.Filter(FilterChips.Items[FilterChips.ItemIndex].Text, SearchEdit.Text)
  else
    OrdersData.Filter('', SearchEdit.Text);
  KpiSourceDataChange(nil, nil);
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
end;

procedure TForm1.FulfilmentBarValueChanged(Sender: TObject; AValue: Single);
begin
  FulfilmentValue.Text := Format('%d%%', [Round(AValue)]);
end;

{ the projects, each with its tasks; a checked task is done }
procedure TForm1.FillProjects;
var
  q: TDataSet;
  n, project: TTMSFNCTreeViewNode;
  done, total: Integer;
begin
  FLoading := True;
  ProjectTree.BeginUpdate;
  try
    ProjectTree.ClearNodes;
    q := OrdersData.Projects;
    q.First;
    project := nil;
    done := 0;
    total := 0;
    while not q.Eof do
    begin
      if q.FieldByName('parent_id').IsNull then
      begin
        n := ProjectTree.AddNode(nil);
        project := n;
      end
      else
      begin
        n := ProjectTree.AddNode(project);
        Inc(total);
        Inc(done, q.FieldByName('done').AsInteger);
      end;
      n.Text[0] := q.FieldByName('name').AsString;
      n.Text[1] := q.FieldByName('owner').AsString;
      n.Text[2] := q.FieldByName('status').AsString;
      n.DataInteger := q.FieldByName('id').AsInteger;
      n.CheckTypes[0] := tvntCheckBox;
      ProjectTree.Checked[n] := q.FieldByName('done').AsInteger <> 0;
      q.Next;
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
  OrdersData.SetDone(ANode.Node.DataInteger, ProjectTree.Checked[ANode.Node]);
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
    {$IFDEF FMX}
    ACell.Layout.Font.StyleExt := TFontStyleExt.Create(TFontWeight.Semibold, TFontSlant.Regular, TFontStretch.Regular);
    {$ELSE}
    if TTMSFNCTheme.SemiboldFamily(ACell.Layout.Font.Name) <> '' then
      ACell.Layout.Font.Name := TTMSFNCTheme.SemiboldFamily(ACell.Layout.Font.Name);
    {$ENDIF}
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


initialization
  { the demo's texts, amounts and dates in English (Oct 30, $1,234.50) }
  FormatSettings := TFormatSettings.Create('en-US');
  FormatSettings.ShortDateFormat := 'mmm d, yyyy';

end.
