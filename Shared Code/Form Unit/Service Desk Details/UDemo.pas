unit UDemo;

{ TMS FNC UI Pack - Service Desk Details

  One detail view (TTMSFNCDetailView) beside the list controls of a service desk, each a master through its
  MasterDetail: a tree of customers with their tickets (a customer shows its tickets, a ticket its comments through
  the MasterDetail of the tree's ticket level), a ticket board (the comments of the selected card) and a list of
  agents without a database (the open tickets of an agent, filled in OnGetDetailData). Pick how the detail shows
  (grid, form, cards, tabs), where (beside, below or in place of the list, with Back to return), the tool bar and
  editing. At design time the same setup takes a few clicks: Data > Details in the context menu of a list control,
  or the Details section of its quick setup. }

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
  {$ENDIF}
  UDemoLayout;

type
  TDemoMaster = (dmCustomers, dmBoard, dmAgents);
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
    FMasterRadios: array[TDemoMaster] of TTMSFNCRadioButton;
    FTemplateRadios: array[0..3] of TTMSFNCRadioButton;
    FPlacement: TTMSFNCSegmentedControl;
    FToolBarCheck: TTMSFNCCheckBox;
    FEditingCheck: TTMSFNCCheckBox;
    FStatus: TTMSFNCHTMLText;
    FTree: TTMSFNCTreeView;
    FBoard: TTMSFNCKanbanBoard;
    FAgents: TTMSFNCListBox;
    FSplitter: TTMSFNCSplitter;
    FView: TTMSFNCDetailView;
    FCustomers: TDemoDataSet;
    FTickets: TDemoDataSet;
    FCustomerTickets: TDemoDataSet;
    FComments: TDemoDataSet;
    FCustomersSource: TDataSource;
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
    function MasterControl(AMaster: TDemoMaster): TControl;
    function MasterSettings(AMaster: TDemoMaster): TTMSFNCMasterDetail;
    procedure MasterChanged(Sender: TObject);
    procedure SettingChanged(Sender: TObject);
    procedure ViewGetDetailData(Sender: TObject; AMaster: TTMSFNCDataGridRenderer; AMasterRow, ATab: Integer;
      ADetail: TTMSFNCDataGridRenderer; var ANested: Boolean);
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
  FCustomers.FieldDefs.Add('City', ftString, 30);
  FLayout.OpenDataSet(FCustomers);
  for I := 0 to High(Companies) do
    FCustomers.AppendRecord([I + 1, Companies[I], Cities[I]]);
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

  FComments := FLayout.NewDataSet;
  FComments.FieldDefs.Add('CommentID', ftInteger);
  FComments.FieldDefs.Add('TicketID', ftInteger);
  FComments.FieldDefs.Add('Author', ftString, 30);
  FComments.FieldDefs.Add('Comment', ftString, 120);
  FComments.FieldDefs.Add('Posted', ftDateTime);
  FLayout.OpenDataSet(FComments);
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
  FTicketsSource := FLayout.NewSource(FTickets);
  FCustomerTicketsSource := FLayout.NewSource(FCustomerTickets);
  FCommentsSource := FLayout.NewSource(FComments);
end;

procedure TForm1.CreateSettings;
begin
  FSettings := FLayout.AddSettingsPanel(Self);

  FLayout.AddCaption(FSettings, 'Master');
  FMasterRadios[dmCustomers] := FLayout.AddRadio(FSettings, 'Customers and their tickets', 'master', True, MasterChanged);
  FMasterRadios[dmBoard] := FLayout.AddRadio(FSettings, 'Ticket board', 'master', False, MasterChanged);
  FMasterRadios[dmAgents] := FLayout.AddRadio(FSettings, 'Agents (no database)', 'master', False, MasterChanged);

  FLayout.AddCaption(FSettings, 'Show the detail as');
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

  FView := TTMSFNCDetailView.Create(Self);
  FView.Parent := FContent;
  FView.OnGetDetailData := ViewGetDetailData;
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
    dmBoard: Result := FBoard;
    dmAgents: Result := FAgents;
  else
    Result := FTree;
  end;
end;

function TForm1.MasterSettings(AMaster: TDemoMaster): TTMSFNCMasterDetail;
begin
  case AMaster of
    dmBoard: Result := FBoard.MasterDetail;
    dmAgents: Result := FAgents.MasterDetail;
  else
    Result := FTree.MasterDetail;
  end;
end;

procedure TForm1.PlaceDetail(AWhere: TDemoWhere);
begin
  FView.DrillBack;
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
  FView.Visible := AWhere <> dwInPlace;
  FSplitter.Visible := AWhere <> dwInPlace;
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

  // one master at a time feeds the view
  FTree.MasterDetail.Enabled := AMaster = dmCustomers;
  FTree.DataOptions.Levels[0].MasterDetail.Enabled := AMaster = dmCustomers;
  FBoard.MasterDetail.Enabled := AMaster = dmBoard;
  FAgents.MasterDetail.Enabled := AMaster = dmAgents;
  if (AMaster = dmAgents) and (FAgents.ItemIndex < 0) then
    FAgents.ItemIndex := 0;
  ApplySettings;
end;

procedure TForm1.ApplySettings;
const
  Templates: array[0..3] of TTMSFNCMasterDetailTemplate = (mdtGrid, mdtForm, mdtCards, mdtTabs);
var
  m: TDemoMaster;
  md: TTMSFNCMasterDetail;
  s: string;
  t, I: Integer;
begin
  t := 0;
  for I := 0 to High(FTemplateRadios) do
    if FTemplateRadios[I].Checked then
      t := I;

  for m := Low(TDemoMaster) to High(TDemoMaster) do
  begin
    md := MasterSettings(m);
    md.BeginUpdate;
    try
      md.Template := Templates[t];
      md.ToolBar.Visible := FToolBarCheck.Checked;
      md.Editing := FEditingCheck.Checked;
      if FWhere = dwInPlace then
        md.Placement := mdpDrillDown
      else
        md.Placement := mdpTarget;
    finally
      md.EndUpdate;
    end;
  end;
  with FTree.DataOptions.Levels[0].MasterDetail do
  begin
    Template := FTree.MasterDetail.Template;
    ToolBar.Visible := FToolBarCheck.Checked;
    Editing := FEditingCheck.Checked;
    Placement := FTree.MasterDetail.Placement;
  end;

  case FMaster of
    dmBoard: s := 'Select a card: the view shows its comments.';
    dmAgents: s := 'Select an agent: the open tickets come from OnGetDetailData (no database).';
  else
    s := 'Select a customer for its tickets, a ticket for its comments.';
  end;
  if FWhere = dwInPlace then
    s := s + ' Enter or a double click opens the detail in place of the list; Back returns.'
  else
    s := s + ' Enter moves the keyboard into the detail.';
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
begin
  w := TDemoWhere(FPlacement.ItemIndex);
  if w <> FWhere then
  begin
    FWhere := w;
    PlaceDetail(w);
  end;
  ApplySettings;
end;

{ the open tickets of the selected agent: a header row, then a row per ticket }
procedure TForm1.ViewGetDetailData(Sender: TObject; AMaster: TTMSFNCDataGridRenderer; AMasterRow, ATab: Integer;
  ADetail: TTMSFNCDataGridRenderer; var ANested: Boolean);
var
  agent: string;
  r: Integer;
  bm: TBookmark;
begin
  if (FMaster <> dmAgents) or (FAgents.ItemIndex < 0) then
    Exit;

  agent := FAgents.Items[FAgents.ItemIndex].Text;
  ADetail.ColumnCount := 4;
  ADetail.RowCount := 1;
  ADetail.Cells[0, 0] := 'Ticket';
  ADetail.Cells[1, 0] := 'Title';
  ADetail.Cells[2, 0] := 'Status';
  ADetail.Cells[3, 0] := 'Priority';

  bm := FTickets.GetBookmark;
  FTickets.DisableControls;
  try
    r := 1;
    FTickets.First;
    while not FTickets.Eof do
    begin
      if (FTickets.FieldByName('Agent').AsString = agent) and (FTickets.FieldByName('Status').AsString <> 'Done') then
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

end.
