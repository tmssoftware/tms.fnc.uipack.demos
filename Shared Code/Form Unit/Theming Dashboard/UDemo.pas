unit UDemo;

{ TMS FNC UI Pack - Theming Dashboard demo: an order management app on FNC components.

  The page is designed in UDemo.dfm (VCL) and UDemo.fmx (FMX); the data module UOrdersData holds the
  SQLite database. Everything is set in the designer:
  * the orders grid shows the orders through a TTMSFNCDataGridDatabaseAdapter (OrderSource); its
    columns have their text roles (the order number in the accent, the date secondary) and margins;
  * the KPI cards, the goals, the counters and the subtitle are bound to the Kpis query (KpiSource)
    by a TTMSFNCDataBinder (PageBinder), which also fills the customer list; the data module
    refreshes the query after every change and when the filter changes;
  * the detail card shows the current order through DetailsBinder (one way: the card is written
    to the record by Save);
  * the KPI row arranges its cards in equal columns (ChildLayout), the status bar's spacer stretches
    and a panel shows the theme's name (spsThemeName).

  Theming: the TTMSFNCThemeManager on the form (Scope tsApplication) themes every FNC control; the
  TTMSFNCThemeSelector and the TTMSFNCAccentSelector in the header switch the theme and its accent
  by themselves (the accent selector hides in high contrast: HideInHighContrast).

  This unit only reacts to the buttons, the filters and the lists. }

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
  VCL.TMSFNCTreeViewData, VCL.TMSFNCCustomTreeView, VCL.TMSFNCTreeView, VCL.TMSFNCCheckedTreeView,
  VCL.TMSFNCDataBinding;
  {$ENDIF}
  {$IFDEF FMX}
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics,
  FMX.TMSFNCGraphicsTypes, FMX.TMSFNCTheme, FMX.TMSFNCCustomControl, FMX.TMSFNCCustomComponent, FMX.TMSFNCPanel,
  FMX.TMSFNCHTMLText, FMX.TMSFNCBadge, FMX.TMSFNCButton, FMX.TMSFNCEdit, FMX.TMSFNCComboBox, FMX.TMSFNCDatePicker,
  FMX.TMSFNCCheckBox, FMX.TMSFNCTrackBar, FMX.TMSFNCProgressBar, FMX.TMSFNCSegmentedControl, FMX.TMSFNCListBox,
  FMX.TMSFNCStatusBar, FMX.TMSFNCSwatchSelector, FMX.TMSFNCThemeSelector, FMX.TMSFNCAccentSelector,
  FMX.TMSFNCDataGridCell, FMX.TMSFNCDataGridData, FMX.TMSFNCDataGridBase, FMX.TMSFNCDataGridCore,
  FMX.TMSFNCDataGridRenderer, FMX.TMSFNCDataGrid, FMX.TMSFNCDataGridDatabaseAdapter, FMX.TMSFNCTreeViewBase,
  FMX.TMSFNCTreeViewData, FMX.TMSFNCCustomTreeView, FMX.TMSFNCTreeView, FMX.TMSFNCCheckedTreeView,
  FMX.TMSFNCDataBinding;
  {$ENDIF}

type
  TForm1 = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    OrderSource: TDataSource;
    KpiSource: TDataSource;
    CustomersSource: TDataSource;
    GridAdapter: TTMSFNCDataGridDatabaseAdapter;
    PageBinder: TTMSFNCDataBinder;
    DetailsBinder: TTMSFNCDataBinder;
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
    procedure NavListItemSelected(Sender: TObject; AItem: TTMSFNCListBoxItem);
    procedure SearchEditChange(Sender: TObject);
    procedure FilterChipsAfterSelectItem(Sender: TObject; AItemIndex: Integer);
    procedure ViewAllLinkAnchorClick(Sender: TObject; AAnchor: string);
    procedure NewOrderButtonClick(Sender: TObject);
    procedure ResetButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure FulfilmentBarValueChanged(Sender: TObject; AValue: Single);
    procedure ProjectTreeNodeChecked(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer);
  private
    FLoading: Boolean;
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

procedure TForm1.FormCreate(Sender: TObject);
begin
  FillProjects;
  { designed for 1440 x 1277: on a smaller screen the window fits the work area }
  if Height > Screen.WorkAreaHeight then
    SetBounds(Left, Round(Screen.WorkAreaTop), Width, Round(Screen.WorkAreaHeight));
end;

{ the detail card into the record (the binder shows the record again afterwards) }
procedure TForm1.SaveButtonClick(Sender: TObject);
var
  d: TOrdersData;
begin
  d := OrdersData;
  if d.Orders.IsEmpty and (d.Orders.State <> dsInsert) then
    Exit;
  DetailsBinder.BeginUpdate;
  try
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
  finally
    DetailsBinder.EndUpdate;
  end;
end;

procedure TForm1.CancelButtonClick(Sender: TObject);
begin
  if OrdersData.Orders.State in dsEditModes then
    OrdersData.Orders.Cancel
  else
  begin
    { the record again in the card }
    DetailsBinder.BeginUpdate;
    DetailsBinder.EndUpdate;
  end;
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

initialization
  { the demo's texts, amounts and dates in English (Oct 30, $1,234.50) }
  FormatSettings := TFormatSettings.Create('en-US');
  FormatSettings.ShortDateFormat := 'mmm d, yyyy';

end.
