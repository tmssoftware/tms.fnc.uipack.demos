unit UDemo;

{ TMS FNC UI Pack - Service Desk Details

  One detail view (TTMSFNCDetailView) beside the list controls of a service desk, each a master through its
  MasterDetail: a tree of customers with their tickets (a customer shows its tickets, a ticket its comments through
  the MasterDetail of the tree's ticket level), a ticket board (the comments of the selected card) and a list of
  agents without a database (the tickets of an agent, filled in OnGetDetailData: open and done ones in two sections).
  A data grid of customers shows its details in the rows, under captions over its columns (ColumnGroups).
  Sections split a detail: the records and the record itself as a form that is edited in place (MasterDetail.Sections,
  Ctrl+PgDn / Ctrl+PgUp change the section). Pick how the records show (grid, form, cards, tabs), where (beside,
  below or in place of the list, with Back to return), the tool bar (search, the record count and Add through
  OnAddRecord) and editing. At design time the same setup takes a few clicks: Data > Details in the context menu of a
  list control, or the Details section of its quick setup. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCSegmentedControl, VCL.TMSFNCSplitter, VCL.TMSFNCTreeView, VCL.TMSFNCKanbanBoard, VCL.TMSFNCListBox,
  VCL.TMSFNCDataGridRenderer, VCL.TMSFNCMasterDetail, VCL.TMSFNCDetailView, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  VCL.TMSFNCDataGrid,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCSegmentedControl, FMX.TMSFNCSplitter, FMX.TMSFNCTreeView, FMX.TMSFNCKanbanBoard, FMX.TMSFNCListBox,
  FMX.TMSFNCDataGridRenderer, FMX.TMSFNCMasterDetail, FMX.TMSFNCDetailView, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
  FMX.TMSFNCDataGrid,
  {$ENDIF}
  UDemoLayout;

type
  TDemoMaster = (dmCustomers, dmGrid, dmBoard, dmAgents);
  TDemoWhere = (dwBeside, dwBelow, dwInPlace);

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
    FMaster: TDemoMaster;
    FWhere: TDemoWhere;
    FTemplate: Integer;
    FMasterRadios: array[TDemoMaster] of TTMSFNCRadioButton;
    FTemplateRadios: array[0..3] of TTMSFNCRadioButton;
    FPlacement: TTMSFNCSegmentedControl;
    FToolBarCheck: TTMSFNCCheckBox;
    FEditingCheck: TTMSFNCCheckBox;
    FSectionsCheck: TTMSFNCCheckBox;
    FStatus: TTMSFNCHTMLText;
    FTree: TTMSFNCTreeView;
    FBoard: TTMSFNCKanbanBoard;
    FAgents: TTMSFNCListBox;
    FGrid: TTMSFNCDataGrid;
    FSplitter: TTMSFNCSplitter;
    FView: TTMSFNCDetailView;
    FCustomers: TDemoDataSet;
    FTickets: TDemoDataSet;
    FCustomerTickets: TDemoDataSet;
    FComments: TDemoDataSet;
    FGridTickets: TDemoDataSet;
    FGridComments: TDemoDataSet;
    FCustomersSource: TDataSource;
    FGridTicketsSource: TDataSource;
    FTicketsSource: TDataSource;
    FCustomerTicketsSource: TDataSource;
    FCommentsSource: TDataSource;
    procedure CreateData;
    procedure CreateSettings;
    procedure CreateContent;
    procedure LinkMasters;
    procedure ShowMaster(AMaster: TDemoMaster);
    procedure PlaceDetail(AWhere: TDemoWhere);
    procedure ApplySettings;
    procedure SetSections(AMaster: TDemoMaster; ASettings: TTMSFNCMasterDetail; ATemplate: TTMSFNCMasterDetailTemplate;
      const ARecords: string);
    function MasterControl(AMaster: TDemoMaster): TControl;
    function MasterSettings(AMaster: TDemoMaster): TTMSFNCMasterDetail;
    procedure MasterChanged(Sender: TObject);
    procedure SettingChanged(Sender: TObject);
    procedure ViewGetDetailData(Sender: TObject; AMaster: TTMSFNCDataGridRenderer; AMasterRow, ATab: Integer;
      ADetail: TTMSFNCDataGridRenderer; var ANested: Boolean);
    procedure ViewAddRecord(Sender: TObject; ADetail: TTMSFNCDataGridRenderer; var AHandled: Boolean);
    procedure SetFields(ADataSet: TDataSet);
    function AgentTickets(const AAgent: string; ADone: Boolean): Integer;
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

const
  Companies: array[0..5] of string = ('Northwind Traders', 'Blue Harbor Hotels', 'Contoso Clinics', 'Fabrikam Labs',
    'Alpine Ski House', 'Tailspin Air');
  Cities: array[0..5] of string = ('Seattle', 'Ghent', 'Lyon', 'Graz', 'Innsbruck', 'Porto');
  Countries: array[0..5] of string = ('United States', 'Belgium', 'France', 'Austria', 'Austria', 'Portugal');
  Agents: array[0..3] of string = ('Ann Peeters', 'Bart Claes', 'Chen Li', 'Dana Novak');
  Statuses: array[0..3] of string = ('Open', 'In progress', 'Waiting', 'Done');
  Priorities: array[0..2] of string = ('Low', 'Normal', 'High');
  Titles: array[0..13] of string = ('Printer queue stuck', 'VPN drops every hour', 'New laptop for intern',
    'Mailbox full', 'Badge reader offline', 'License renewal', 'Slow file share', 'Password reset loop',
    'Wi-Fi in meeting room 2', 'Monitor flickers', 'Backup failed', 'Install design tools', 'Phone not ringing',
    'Shared calendar missing');
  Notes: array[0..5] of string = ('Asked for the exact error message.', 'Reproduced on a second machine.',
    'Waiting for the vendor to answer.', 'Applied the latest update.', 'Customer confirmed it works again.',
    'Scheduled a visit on site.');

procedure TForm1.FormCreate(Sender: TObject);
begin
  FLayout := TDemoLayout.Create(Self);
  CreateData;
  CreateSettings;
  CreateContent;
  LinkMasters;
  FWhere := dwBeside;
  PlaceDetail(dwBeside);
  ShowMaster(dmCustomers);
end;

procedure TForm1.CreateData;
var
  I, t, c: Integer;
begin
  FCustomers := FLayout.NewDataSet;
  FCustomers.FieldDefs.Add('CustomerID', ftInteger);
  FCustomers.FieldDefs.Add('Company', ftString, 40);
  FCustomers.FieldDefs.Add('Active', ftBoolean);
  FCustomers.FieldDefs.Add('City', ftString, 30);
  FCustomers.FieldDefs.Add('Country', ftString, 30);
  FCustomers.FieldDefs.Add('Since', ftDate);
  FLayout.OpenDataSet(FCustomers);
  for I := 0 to High(Companies) do
    FCustomers.AppendRecord([I + 1, Companies[I], I <> 4, Cities[I], Countries[I], EncodeDate(2018 + I, 1 + I * 2, 1)]);
  FCustomers.First;

  FTickets := FLayout.NewDataSet;
  FTickets.FieldDefs.Add('TicketID', ftInteger);
  FTickets.FieldDefs.Add('CustomerID', ftInteger);
  FTickets.FieldDefs.Add('Title', ftString, 60);
  FTickets.FieldDefs.Add('Status', ftString, 20);
  FTickets.FieldDefs.Add('Priority', ftString, 10);
  FTickets.FieldDefs.Add('Agent', ftString, 30);
  FTickets.FieldDefs.Add('Opened', ftDate);
  FLayout.OpenDataSet(FTickets);
  for I := 0 to High(Titles) do
    FTickets.AppendRecord([101 + I, (I mod Length(Companies)) + 1, Titles[I], Statuses[(I * 3 + I div 4) mod Length(Statuses)],
      Priorities[(I * 2) mod Length(Priorities)], Agents[I mod Length(Agents)], Date - 20 + I]);
  FTickets.First;

  // the tickets of a customer: a second cursor on the same records, filtered by the tree's MasterDetail
  FCustomerTickets := FLayout.NewDataSet;
  FCustomerTickets.CloneCursor(FTickets, False, False);
  // the tab of a detail table is named after the table
  FCustomerTickets.Name := 'Tickets';

  FComments := FLayout.NewDataSet;
  FComments.FieldDefs.Add('CommentID', ftInteger);
  FComments.FieldDefs.Add('TicketID', ftInteger);
  FComments.FieldDefs.Add('Author', ftString, 30);
  FComments.FieldDefs.Add('Comment', ftString, 120);
  FComments.FieldDefs.Add('Posted', ftDateTime);
  FLayout.OpenDataSet(FComments);
  FComments.Name := 'Comments';
  // the number of a comment is no news to a reader of the detail
  FComments.FieldByName('CommentID').Visible := False;
  c := 1;
  for t := 0 to High(Titles) do
    for I := 0 to (t mod 3) do
    begin
      FComments.AppendRecord([c, 101 + t, Agents[(t + I) mod Length(Agents)], Notes[(t + I) mod Length(Notes)],
        Date - 20 + t + I * 0.25]);
      Inc(c);
    end;
  FComments.First;

  FCustomersSource := FLayout.NewSource(FCustomers);

  // the data grid: tables that follow the customers (MasterSource), the tickets with their comments
  FGridTickets := FLayout.NewDataSet;
  FGridTickets.CloneCursor(FTickets, False, False);
  FGridTickets.Name := 'GridTickets';
  FGridTickets.IndexFieldNames := 'CustomerID';
  FGridTickets.MasterSource := FCustomersSource;
  FGridTickets.MasterFields := 'CustomerID';
  FGridTicketsSource := FLayout.NewSource(FGridTickets);
  FGridComments := FLayout.NewDataSet;
  FGridComments.CloneCursor(FComments, False, False);
  FGridComments.Name := 'GridComments';
  FGridComments.IndexFieldNames := 'TicketID';
  FGridComments.MasterSource := FGridTicketsSource;
  FGridComments.MasterFields := 'TicketID';

  SetFields(FCustomers);
  SetFields(FTickets);
  SetFields(FCustomerTickets);
  SetFields(FComments);
  SetFields(FGridTickets);
  SetFields(FGridComments);
  // the tickets of a customer fit the view beside the tree without the date
  FCustomerTickets.FieldByName('Opened').Visible := False;
  FGridComments.FieldByName('CommentID').Visible := False;
  // the number of a ticket next to the button that opens its comments
  FGridTickets.FieldByName('TicketID').DisplayWidth := 8;

  FTicketsSource := FLayout.NewSource(FTickets);
  FCustomerTicketsSource := FLayout.NewSource(FCustomerTickets);
  FCommentsSource := FLayout.NewSource(FComments);
end;

{ the captions a reader sees in a form, a card and a column header, and the widths of the columns: a column is as
  wide as the DisplayWidth of its field, and the size of a text field is more than its texts need }
procedure TForm1.SetFields(ADataSet: TDataSet);
const
  Names: array[0..14] of string = ('CustomerID', 'TicketID', 'CommentID', 'Company', 'City', 'Title', 'Status',
    'Priority', 'Agent', 'Author', 'Comment', 'Posted', 'Country', 'Active', 'Since');
  Labels: array[0..14] of string = ('Customer no.', 'Ticket', 'Comment no.', '', '', '', '', '', '', '', '', '', '',
    '', 'Customer since');
  Widths: array[0..14] of Integer = (6, 5, 6, 20, 12, 18, 9, 6, 10, 10, 34, 10, 12, 6, 10);
var
  I: Integer;
  f: TField;
begin
  for I := 0 to High(Names) do
  begin
    f := ADataSet.FindField(Names[I]);
    if not Assigned(f) then
      Continue;

    if Labels[I] <> '' then
      f.DisplayLabel := Labels[I];
    f.DisplayWidth := Widths[I];
    if f is TDateTimeField then
      TDateTimeField(f).DisplayFormat := FormatSettings.ShortDateFormat;
  end;
end;

procedure TForm1.CreateSettings;
begin
  FSettings := FLayout.AddSettingsPanel(Self);

  FLayout.AddCaption(FSettings, 'Master');
  FMasterRadios[dmCustomers] := FLayout.AddRadio(FSettings, 'Customers and their tickets', 'master', True, MasterChanged);
  FMasterRadios[dmGrid] := FLayout.AddRadio(FSettings, 'Customer grid', 'master', False, MasterChanged);
  FMasterRadios[dmBoard] := FLayout.AddRadio(FSettings, 'Ticket board', 'master', False, MasterChanged);
  FMasterRadios[dmAgents] := FLayout.AddRadio(FSettings, 'Agents (no database)', 'master', False, MasterChanged);

  FLayout.AddCaption(FSettings, 'Show the records as');
  FTemplateRadios[0] := FLayout.AddRadio(FSettings, 'Grid of the detail records', 'template', True, SettingChanged);
  FTemplateRadios[1] := FLayout.AddRadio(FSettings, 'Form of one record', 'template', False, SettingChanged);
  FTemplateRadios[2] := FLayout.AddRadio(FSettings, 'Cards', 'template', False, SettingChanged);
  FTemplateRadios[3] := FLayout.AddRadio(FSettings, 'Tabs', 'template', False, SettingChanged);

  FLayout.AddCaption(FSettings, 'Where');
  FPlacement := TTMSFNCSegmentedControl.Create(Self);
  FPlacement.Parent := FSettings;
  FLayout.Place(FPlacement, daTop, 32, 16, 0, 16, 0);
  FPlacement.Items.AddItem('Beside');
  FPlacement.Items.AddItem('Below');
  FPlacement.Items.AddItem('In place');
  FPlacement.ItemIndex := 0;
  FPlacement.OnChange := SettingChanged;

  FLayout.AddCaption(FSettings, 'Detail');
  FSectionsCheck := FLayout.AddCheck(FSettings, 'Sections: records, details', True, SettingChanged);
  FToolBarCheck := FLayout.AddCheck(FSettings, 'Tool bar: search, Add, count', False, SettingChanged);
  FEditingCheck := FLayout.AddCheck(FSettings, 'Edit in the detail', True, SettingChanged);

  FStatus := FLayout.AddText(FSettings, '', 112);
end;

procedure TForm1.CreateContent;
begin
  FContent := FLayout.AddContentPanel(Self);

  FTree := TTMSFNCTreeView.Create(Self);
  FTree.Parent := FContent;
  FTree.DataOptions.KeyField := 'CustomerID';
  FTree.DataOptions.TextField := 'Company';
  FTree.DataOptions.ExpandLevel := 1;
  with FTree.DataOptions.Levels.Add do
  begin
    DataSource := FTicketsSource;
    KeyField := 'TicketID';
    MasterKeyField := 'CustomerID';
    TextField := 'Title';
  end;
  FTree.DataSource := FCustomersSource;

  FBoard := TTMSFNCKanbanBoard.Create(Self);
  FBoard.Parent := FContent;
  FBoard.DataOptions.KeyField := 'TicketID';
  FBoard.DataOptions.StatusField := 'Status';
  FBoard.DataOptions.TitleField := 'Title';
  FBoard.DataOptions.TextField := 'Agent';
  FBoard.DataSource := FTicketsSource;

  FAgents := TTMSFNCListBox.Create(Self);
  FAgents.Parent := FContent;
  FAgents.BeginUpdate;
  try
    FAgents.Items.Clear;
    FAgents.Items.Add.Text := Agents[0];
    FAgents.Items.Add.Text := Agents[1];
    FAgents.Items.Add.Text := Agents[2];
    FAgents.Items.Add.Text := Agents[3];
  finally
    FAgents.EndUpdate;
  end;

  // the details of a customer in the rows of the grid, its columns under two captions
  FGrid := TTMSFNCDataGrid.Create(Self);
  FGrid.Parent := FContent;
  FGrid.DataOptions.NewRowLine := False;
  FGrid.DataSource := FCustomersSource;
  FGrid.MasterDetail.DetailHeight := 300;
  FGrid.ColumnGroups.Add('Customer', ['CustomerID', 'Company', 'Active']);
  FGrid.ColumnGroups.Add('Location', ['City', 'Country']);

  FView := TTMSFNCDetailView.Create(Self);
  FView.Parent := FContent;
  FView.OnGetDetailData := ViewGetDetailData;
  FView.OnAddRecord := ViewAddRecord;
  FSplitter := TTMSFNCSplitter.Create(Self);
  FSplitter.Parent := FContent;
end;

{ what Data > Details sets at design time: the target, the detail table and its link field }
procedure TForm1.LinkMasters;
begin
  FTree.MasterDetail.DataSource := FCustomerTicketsSource;
  FTree.MasterDetail.DetailFields := 'CustomerID';
  FTree.MasterDetail.Target := FView;
  FTree.DataOptions.Levels[0].MasterDetail.DataSource := FCommentsSource;
  FTree.DataOptions.Levels[0].MasterDetail.DetailFields := 'TicketID';
  FTree.DataOptions.Levels[0].MasterDetail.Target := FView;

  FBoard.MasterDetail.DataSource := FCommentsSource;
  FBoard.MasterDetail.DetailFields := 'TicketID';
  FBoard.MasterDetail.Target := FView;

  FAgents.MasterDetail.Target := FView;
end;

function TForm1.MasterControl(AMaster: TDemoMaster): TControl;
begin
  case AMaster of
    dmGrid: Result := FGrid;
    dmBoard: Result := FBoard;
    dmAgents: Result := FAgents;
  else
    Result := FTree;
  end;
end;

function TForm1.MasterSettings(AMaster: TDemoMaster): TTMSFNCMasterDetail;
begin
  case AMaster of
    dmGrid: Result := FGrid.MasterDetail;
    dmBoard: Result := FBoard.MasterDetail;
    dmAgents: Result := FAgents.MasterDetail;
  else
    Result := FTree.MasterDetail;
  end;
end;

procedure TForm1.PlaceDetail(AWhere: TDemoWhere);
begin
  FView.DrillBack;
  { the view and the splitter get their place in one go: aligned one after the other (a control that is shown again
    is aligned on its own), VCL puts the one aligned last at the edge and the splitter ends up outside the view }
  {$IFDEF VCL}
  FContent.DisableAlign;
  try
  {$ENDIF}
    // the grid shows the details in its rows: no view beside it
    FView.Visible := (AWhere <> dwInPlace) and (FMaster <> dmGrid);
    FSplitter.Visible := FView.Visible;
    case AWhere of
      dwBeside:
      begin
        FLayout.Place(FView, daRight, 480, 0, 0, 0, 0);
        FLayout.Place(FSplitter, daRight, 8, 0, 0, 0, 0);
      end;
      dwBelow:
      begin
        FLayout.Place(FSplitter, daBottom, 8, 0, 0, 0, 0);
        FLayout.Place(FView, daBottom, 280, 0, 0, 0, 0);
      end;
    end;
  {$IFDEF VCL}
  finally
    FContent.EnableAlign;
  end;
  {$ENDIF}
end;

procedure TForm1.ShowMaster(AMaster: TDemoMaster);
var
  m: TDemoMaster;
begin
  FView.DrillBack;
  FMaster := AMaster;
  for m := Low(TDemoMaster) to High(TDemoMaster) do
  begin
    MasterControl(m).Visible := m = AMaster;
    if m = AMaster then
      FLayout.Place(MasterControl(m), daClient, 0, 0, 0, 0, 0);
  end;

  // one master at a time feeds the view; the grid shows its details itself
  FTree.MasterDetail.Enabled := AMaster = dmCustomers;
  FTree.DataOptions.Levels[0].MasterDetail.Enabled := AMaster = dmCustomers;
  FBoard.MasterDetail.Enabled := AMaster = dmBoard;
  FAgents.MasterDetail.Enabled := AMaster = dmAgents;
  FGrid.MasterDetail.Enabled := AMaster = dmGrid;
  if (AMaster = dmAgents) and (FAgents.ItemIndex < 0) then
    FAgents.ItemIndex := 0;

  PlaceDetail(FWhere);
  ApplySettings;
end;

{ the sections of a detail: the records (shown as the radio buttons say) and the record itself as a form that is
  edited in place; an agent has the open and the done tickets, filled in OnGetDetailData (ATab is the section) }
procedure TForm1.SetSections(AMaster: TDemoMaster; ASettings: TTMSFNCMasterDetail; ATemplate: TTMSFNCMasterDetailTemplate;
  const ARecords: string);
var
  s: TTMSFNCMasterDetailSection;
begin
  ASettings.Sections.BeginUpdate;
  try
    ASettings.Sections.Clear;
    if not FSectionsCheck.Checked then
      Exit;

    if AMaster = dmAgents then
    begin
      s := ASettings.Sections.Add;
      s.Caption := 'Open';
      s.Content := mdscCustom;
      s := ASettings.Sections.Add;
      s.Caption := 'Done';
      s.Content := mdscCustom;
      Exit;
    end;

    s := ASettings.Sections.Add;
    s.Caption := ARecords;
    if ATemplate <> mdtTabs then
      s.Template := ATemplate;
    s := ASettings.Sections.Add;
    s.Caption := 'Details';
    s.Content := mdscMasterRecord;
  finally
    ASettings.Sections.EndUpdate;
  end;
end;

procedure TForm1.ApplySettings;
const
  Templates: array[0..3] of TTMSFNCMasterDetailTemplate = (mdtGrid, mdtForm, mdtCards, mdtTabs);
var
  m: TDemoMaster;
  md: TTMSFNCMasterDetail;
  s: string;
  t: Integer;
begin
  t := FTemplate;
  for m := Low(TDemoMaster) to High(TDemoMaster) do
  begin
    md := MasterSettings(m);
    md.BeginUpdate;
    try
      md.Template := Templates[t];
      md.ToolBar.Visible := FToolBarCheck.Checked;
      // Add adds a ticket or a comment (OnAddRecord); the tickets of an agent are a list to read
      md.ToolBar.AddButton := m <> dmAgents;
      md.Cards.TitleField := 'Title';
      md.Editing := FEditingCheck.Checked;
      if m = dmGrid then
        md.Placement := mdpInline
      else if FWhere = dwInPlace then
        md.Placement := mdpDrillDown
      else
        md.Placement := mdpTarget;
      if m = dmBoard then
        SetSections(m, md, Templates[t], 'Comments')
      else
        SetSections(m, md, Templates[t], 'Tickets');
    finally
      md.EndUpdate;
    end;
  end;
  md := FTree.DataOptions.Levels[0].MasterDetail;
  md.BeginUpdate;
  try
    md.Template := FTree.MasterDetail.Template;
    md.ToolBar.Visible := FToolBarCheck.Checked;
    md.Cards.TitleField := 'Author';
    md.Editing := FEditingCheck.Checked;
    md.Placement := FTree.MasterDetail.Placement;
    SetSections(dmCustomers, md, Templates[t], 'Comments');
  finally
    md.EndUpdate;
  end;

  FBoard.MasterDetail.Cards.TitleField := 'Author';

  case FMaster of
    dmGrid: s := 'Expand a customer for its tickets. Drag a caption above the columns to move them.';
    dmBoard: s := 'Select a card: the view shows its comments.';
    dmAgents: s := 'Select an agent: the tickets come from OnGetDetailData (no database).';
  else
    s := 'Select a customer for its tickets, a ticket for its comments.';
  end;
  if FSectionsCheck.Checked then
    s := s + ' Details: the record, edited in place (Ctrl+PgDn).';
  if FMaster = dmGrid then
    s := s + ' Enter moves the keyboard into the detail of the row.'
  else if FWhere = dwInPlace then
    s := s + ' Enter or a double click opens the detail in place of the list; Back returns.'
  else
    s := s + ' Enter moves the keyboard into the detail.';
  if FToolBarCheck.Checked and (Templates[t] <> mdtForm) then
  begin
    if FMaster = dmAgents then
      s := s + ' The tool bar searches and counts.'
    else
      s := s + ' The tool bar searches and counts; Add adds a record in OnAddRecord.';
  end
  else if (Templates[t] = mdtCards) and (FMaster <> dmAgents) then
    s := s + ' Enter or a double click on a card shows its record.';
  FStatus.Text := s;
end;

procedure TForm1.MasterChanged(Sender: TObject);
var
  m: TDemoMaster;
begin
  for m := Low(TDemoMaster) to High(TDemoMaster) do
    if (Sender = FMasterRadios[m]) and FMasterRadios[m].Checked and (m <> FMaster) then
      ShowMaster(m);
end;

procedure TForm1.SettingChanged(Sender: TObject);
var
  w: TDemoWhere;
  I: Integer;
begin
  // the radio button that lost its check tells it too: the one that got it applies the choice
  if (Sender is TTMSFNCRadioButton) and not TTMSFNCRadioButton(Sender).Checked then
    Exit;

  for I := 0 to High(FTemplateRadios) do
    if Sender = FTemplateRadios[I] then
      FTemplate := I;

  w := TDemoWhere(FPlacement.ItemIndex);
  if w <> FWhere then
  begin
    FWhere := w;
    PlaceDetail(w);
  end;
  ApplySettings;
end;

{ the number of tickets of an agent that are done, or that are not }
function TForm1.AgentTickets(const AAgent: string; ADone: Boolean): Integer;
var
  bm: TBookmark;
begin
  Result := 0;
  bm := FTickets.GetBookmark;
  FTickets.DisableControls;
  try
    FTickets.First;
    while not FTickets.Eof do
    begin
      if (FTickets.FieldByName('Agent').AsString = AAgent) and ((FTickets.FieldByName('Status').AsString = 'Done') = ADone) then
        Inc(Result);
      FTickets.Next;
    end;
  finally
    FTickets.GotoBookmark(bm);
    FTickets.FreeBookmark(bm);
    FTickets.EnableControls;
  end;
end;

{ the tickets of the selected agent: a header row, then a row per ticket; the open ones, or with the tabs the done
  ones on the second tab. The form of an agent gets two lines more }
procedure TForm1.ViewGetDetailData(Sender: TObject; AMaster: TTMSFNCDataGridRenderer; AMasterRow, ATab: Integer;
  ADetail: TTMSFNCDataGridRenderer; var ANested: Boolean);
var
  agent: string;
  r: Integer;
  bm: TBookmark;
  done: Boolean;
begin
  if (FMaster <> dmAgents) or (FAgents.ItemIndex < 0) then
    Exit;

  agent := FAgents.Items[FAgents.ItemIndex].Text;
  if (FAgents.MasterDetail.Template = mdtForm) and (FAgents.MasterDetail.Sections.Count = 0) then
  begin
    // the form of an item has a line per field of the item: its text, called Agent here
    r := ADetail.RowCount;
    if r > 0 then
      ADetail.Cells[0, 0] := 'Agent';
    ADetail.RowCount := r + 2;
    ADetail.Cells[0, r] := 'Open tickets';
    ADetail.Cells[1, r] := AgentTickets(agent, False);
    ADetail.Cells[0, r + 1] := 'Done';
    ADetail.Cells[1, r + 1] := AgentTickets(agent, True);
    Exit;
  end;

  // with sections ATab is the section (Open, Done); the tabs template without sections has the same two
  done := ((FAgents.MasterDetail.Sections.Count > 0) or (FAgents.MasterDetail.Template = mdtTabs)) and (ATab = 1);
  ADetail.ColumnCount := 4;
  ADetail.RowCount := 1;
  ADetail.Cells[0, 0] := 'Ticket';
  ADetail.Cells[1, 0] := 'Title';
  ADetail.Cells[2, 0] := 'Status';
  ADetail.Cells[3, 0] := 'Priority';
  // the widths of the columns to each other: the view gives them its room
  ADetail.ColumnWidths[0] := 60;
  ADetail.ColumnWidths[1] := 190;
  ADetail.ColumnWidths[2] := 100;
  ADetail.ColumnWidths[3] := 80;

  bm := FTickets.GetBookmark;
  FTickets.DisableControls;
  try
    r := 1;
    FTickets.First;
    while not FTickets.Eof do
    begin
      if (FTickets.FieldByName('Agent').AsString = agent) and ((FTickets.FieldByName('Status').AsString = 'Done') = done) then
      begin
        ADetail.RowCount := r + 1;
        ADetail.Cells[0, r] := FTickets.FieldByName('TicketID').AsInteger;
        ADetail.Cells[1, r] := FTickets.FieldByName('Title').AsString;
        ADetail.Cells[2, r] := FTickets.FieldByName('Status').AsString;
        ADetail.Cells[3, r] := FTickets.FieldByName('Priority').AsString;
        Inc(r);
      end;
      FTickets.Next;
    end;
  finally
    FTickets.GotoBookmark(bm);
    FTickets.FreeBookmark(bm);
    FTickets.EnableControls;
  end;
end;

{ the Add button of the tool bar: a ticket for the customer, or a comment for the ticket. The link of the view knows
  the detail table, its link field and the record of the master }
procedure TForm1.ViewAddRecord(Sender: TObject; ADetail: TTMSFNCDataGridRenderer; var AHandled: Boolean);
var
  ds: TDataSet;
  key: Variant;
begin
  if (FMaster = dmAgents) or not Assigned(FView.Link) or (FView.Link.DataSource = nil) or
    (Length(FView.Link.MasterRecord.Keys) = 0) then
    Exit;

  ds := FView.Link.DataSource.DataSet;
  key := FView.Link.MasterRecord.Keys[0];
  ds.Append;
  ds.FieldByName(FView.Link.ActiveDetailFields).Value := key;
  if ds = FComments then
  begin
    ds.FieldByName('CommentID').AsInteger := FComments.RecordCount + 1000;
    ds.FieldByName('Author').AsString := 'You';
    ds.FieldByName('Comment').AsString := 'Added with the Add button.';
    ds.FieldByName('Posted').AsDateTime := Now;
  end
  else
  begin
    ds.FieldByName('TicketID').AsInteger := 101 + FTickets.RecordCount;
    ds.FieldByName('Title').AsString := 'New ticket';
    ds.FieldByName('Status').AsString := Statuses[0];
    ds.FieldByName('Priority').AsString := Priorities[1];
    ds.FieldByName('Agent').AsString := Agents[0];
    ds.FieldByName('Opened').AsDateTime := Date;
  end;
  ds.Post;
  AHandled := True;
end;

end.
