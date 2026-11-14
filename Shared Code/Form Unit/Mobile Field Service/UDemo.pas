unit UDemo;

{ TMS FNC UI Pack - Mobile Field Service

  The phone app of a service technician, shown in a device frame whose width you switch (phone, tablet, full width).
  Jobs: a data grid with the Mobile preset of Quick setup applied in code (44 px rows, touch scrolling, finger-sized
  click and sizing margins, single-row selection); the columns with a HidePriority leave the grid one by one when it
  gets narrow, and a job opens its tasks under the row or, on a phone (DrillDown.Width), in place of the list with a
  breadcrumb back. Customers: a tree view with 44 px nodes and a breadcrumb that follows the selected node. Parts: a
  list box with 44 px items and a search edit. On Android and iOS the app fills the screen without the frame. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCEdit, VCL.TMSFNCSegmentedControl, VCL.TMSFNCBreadcrumb, VCL.TMSFNCDataGrid,
  VCL.TMSFNCDataGridRenderer, VCL.TMSFNCTreeView, VCL.TMSFNCTreeViewData, VCL.TMSFNCCustomTreeView,
  VCL.TMSFNCListBox, VCL.TMSFNCMasterDetail, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCEdit, FMX.TMSFNCSegmentedControl, FMX.TMSFNCBreadcrumb, FMX.TMSFNCDataGrid,
  FMX.TMSFNCDataGridRenderer, FMX.TMSFNCTreeView, FMX.TMSFNCTreeViewData, FMX.TMSFNCCustomTreeView,
  FMX.TMSFNCListBox, FMX.TMSFNCMasterDetail, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton, WEBLib.TMSFNCEdit, WEBLib.TMSFNCSegmentedControl,
  WEBLib.TMSFNCBreadcrumb, WEBLib.TMSFNCDataGrid, WEBLib.TMSFNCDataGridRenderer, WEBLib.TMSFNCTreeView,
  WEBLib.TMSFNCTreeViewData, WEBLib.TMSFNCCustomTreeView, WEBLib.TMSFNCListBox, WEBLib.TMSFNCMasterDetail,
  WEBLib.TMSFNCTheme, WEBLib.TMSFNCThemeSelector,
  {$ENDIF}
  UDemoLayout;

type
  TDemoDevice = (ddPhone, ddTablet, ddFull);
  TAppPage = (apJobs, apCustomers, apParts);

  TJob = record
    Slot, Number, Customer, Address, Kind, Technician, Status: string;
    Minutes: Integer;
  end;

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
    FDeviceRadios: array[TDemoDevice] of TTMSFNCRadioButton;
    FPresetCheck: TTMSFNCCheckBox;
    FHideCheck: TTMSFNCCheckBox;
    FDrillCheck: TTMSFNCCheckBox;
    FStatus: TTMSFNCHTMLText;
    FFrame: TTMSFNCPanel;
    FAppBar: TTMSFNCPanel;
    FAppTitle: TTMSFNCHTMLText;
    FPages: TTMSFNCSegmentedControl;
    FPageHosts: array[TAppPage] of TTMSFNCPanel;
    FJobs: TTMSFNCDataGrid;
    FPath: TTMSFNCBreadcrumb;
    FTree: TTMSFNCTreeView;
    FSearch: TTMSFNCEdit;
    FParts: TTMSFNCListBox;
    FDevice: TDemoDevice;
    procedure CreateSettings;
    procedure CreateContent;
    procedure CreateJobs;
    procedure CreateCustomers;
    procedure CreateParts;
    procedure FillParts;
    procedure ApplySettings;
    procedure LayoutFrame;
    procedure UpdatePath;
    function IsMobilePlatform: Boolean;
    procedure SettingChanged(Sender: TObject);
    procedure PageChanged(Sender: TObject);
    procedure ContentResized(Sender: TObject);
    procedure SearchChanged(Sender: TObject);
    procedure TreeSelected(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode);
    procedure PathClicked(Sender: TObject; AIndex: Integer);
    procedure GetJobTasks(Sender: TObject; AMaster: TTMSFNCDataGridRenderer; AMasterRow, ATab: Integer;
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
{$IFDEF WEBLIB}
{$R *.dfm}
{$ENDIF}

const
  DeviceWidths: array[TDemoDevice] of Integer = (390, 768, 0);
  { a phone narrower than this opens a job in place of the list }
  PhoneWidth = 520;
  Jobs: array[0..8] of TJob = (
    (Slot: '08:00'; Number: 'J-2041'; Customer: 'Northwind Bakery'; Address: 'Market Street 12'; Kind: 'Oven service';
      Technician: 'Ava Lindqvist'; Status: 'Done'; Minutes: 45),
    (Slot: '09:15'; Number: 'J-2042'; Customer: 'Harbor Dental'; Address: 'Quay 3, unit 7'; Kind: 'Compressor repair';
      Technician: 'Ava Lindqvist'; Status: 'Done'; Minutes: 60),
    (Slot: '10:30'; Number: 'J-2043'; Customer: 'Bluebell Hotel'; Address: 'Station Road 88'; Kind: 'Boiler inspection';
      Technician: 'Ravi Menon'; Status: 'On site'; Minutes: 90),
    (Slot: '11:45'; Number: 'J-2044'; Customer: 'City Library'; Address: 'Grand Place 1'; Kind: 'Lift check';
      Technician: 'Ravi Menon'; Status: 'Travelling'; Minutes: 30),
    (Slot: '13:00'; Number: 'J-2045'; Customer: 'Oak & Ivy'; Address: 'Linden Lane 5'; Kind: 'Cooling unit';
      Technician: 'Ava Lindqvist'; Status: 'Planned'; Minutes: 75),
    (Slot: '14:15'; Number: 'J-2046'; Customer: 'Greenleaf School'; Address: 'Park Avenue 40'; Kind: 'Heat pump';
      Technician: 'Sam Okafor'; Status: 'Planned'; Minutes: 60),
    (Slot: '15:30'; Number: 'J-2047'; Customer: 'Riverside Clinic'; Address: 'Bridge Street 9'; Kind: 'Ventilation';
      Technician: 'Sam Okafor'; Status: 'Delayed'; Minutes: 45),
    (Slot: '16:30'; Number: 'J-2048'; Customer: 'Sunrise Gym'; Address: 'Dock Road 21'; Kind: 'Water heater';
      Technician: 'Ravi Menon'; Status: 'Planned'; Minutes: 30),
    (Slot: '17:15'; Number: 'J-2049'; Customer: 'Corner Pharmacy'; Address: 'Main Street 77'; Kind: 'Fridge alarm';
      Technician: 'Ava Lindqvist'; Status: 'Planned'; Minutes: 20));
  Tasks: array[0..4] of string = ('Check the safety switch', 'Clean the filters', 'Measure the pressure',
    'Replace worn seals', 'Test run and sign off');
  Regions: array[0..2] of string = ('North', 'Centre', 'Harbour');
  Parts: array[0..11] of string = ('Air filter F7', 'Ball valve 15 mm', 'Boiler pump', 'Capacitor 35 uF',
    'Door seal 60 cm', 'Expansion vessel 8 L', 'Fan motor 120 W', 'Flue gasket', 'Pressure sensor',
    'Relay 24 V', 'Thermostat dial', 'Water filter cartridge');
  Stock: array[0..11] of Integer = (14, 30, 2, 9, 0, 3, 5, 22, 7, 40, 11, 6);
  { the job columns that leave first on a narrow screen: the highest number; 0 stays }
  Priorities: array[0..6] of Integer = (0, 2, 0, 5, 3, 4, 1);

function StatusHTML(const AStatus: string): string;
var
  c: string;
begin
  if AStatus = 'Done' then
    c := 'var(--success)'
  else if AStatus = 'Delayed' then
    c := 'var(--error)'
  else if (AStatus = 'On site') or (AStatus = 'Travelling') then
    c := 'var(--warning)'
  else
    c := 'var(--text-secondary)';
  Result := '<font color="' + c + '">&#9679;</font> ' + AStatus;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FLayout := TDemoLayout.Create(Self);
  if IsMobilePlatform then
    FDevice := ddFull
  else
    FDevice := ddPhone;
  CreateSettings;
  CreateContent;
  ApplySettings;
end;

function TForm1.IsMobilePlatform: Boolean;
begin
  Result := False;
  {$IFDEF ANDROID}
  Result := True;
  {$ENDIF}
  {$IFDEF IOS}
  Result := True;
  {$ENDIF}
end;

procedure TForm1.CreateSettings;
begin
  FSettings := FLayout.AddSettingsPanel(Self);

  FLayout.AddCaption(FSettings, 'Device');
  FDeviceRadios[ddPhone] := FLayout.AddRadio(FSettings, 'Phone (390 px)', 'device', FDevice = ddPhone,
    {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FDeviceRadios[ddTablet] := FLayout.AddRadio(FSettings, 'Tablet (768 px)', 'device', FDevice = ddTablet,
    {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FDeviceRadios[ddFull] := FLayout.AddRadio(FSettings, 'Full width', 'device', FDevice = ddFull,
    {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Touch');
  FPresetCheck := FLayout.AddCheck(FSettings, 'Mobile preset: 44 px rows', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FHideCheck := FLayout.AddCheck(FSettings, 'Hide columns that do not fit', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FDrillCheck := FLayout.AddCheck(FSettings, 'Open a job in place on a phone', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FStatus := FLayout.AddText(FSettings, '', 150);

  { on a phone or tablet the app is the whole screen }
  FSettings.Visible := not IsMobilePlatform;
end;

procedure TForm1.CreateContent;
const
  PageNames: array[TAppPage] of string = ('Jobs', 'Customers', 'Parts');
var
  pg: TAppPage;
begin
  FContent := FLayout.AddContentPanel(Self);
  FContent.OnResize := {$IFDEF WEBLIB}@{$ENDIF}ContentResized;

  { the device: a card the width of a phone or tablet, centred in the page }
  FFrame := TTMSFNCPanel.Create(Self);
  FFrame.Parent := FContent;
  FFrame.Header.Visible := False;

  FAppBar := FLayout.AddPanel(FFrame, daTop, 96, 0, 0, 0, 0);
  FAppBar.Fill.Kind := gfkNone;
  FAppBar.Stroke.Kind := gskNone;
  FAppTitle := FLayout.AddText(FAppBar, '<b>Today</b><br><font color="var(--text-secondary)">Friday 14 November, ' +
    IntToStr(Length(Jobs)) + ' jobs</font>', 44);
  FLayout.Place(FAppTitle, daTop, 44, 16, 8, 16, 0);
  FPages := TTMSFNCSegmentedControl.Create(Self);
  FPages.Parent := FAppBar;
  FLayout.Place(FPages, daTop, 36, 12, 4, 12, 4);
  for pg := Low(TAppPage) to High(TAppPage) do
    FPages.Items.AddItem(PageNames[pg]);
  FPages.ItemIndex := 0;
  FPages.OnChange := {$IFDEF WEBLIB}@{$ENDIF}PageChanged;

  for pg := Low(TAppPage) to High(TAppPage) do
  begin
    FPageHosts[pg] := FLayout.AddPanel(FFrame, daClient, 0, 0, 0, 0, 0);
    FPageHosts[pg].Fill.Kind := gfkNone;
    FPageHosts[pg].Stroke.Kind := gskNone;
    FPageHosts[pg].Visible := pg = apJobs;
  end;

  CreateJobs;
  CreateCustomers;
  CreateParts;
end;

procedure TForm1.CreateJobs;
const
  Captions: array[0..6] of string = ('Time', 'Job', 'Customer', 'Address', 'Work', 'Technician', 'Status');
  Widths: array[0..6] of Integer = (64, 76, 150, 150, 140, 120, 110);
var
  I, c: Integer;
begin
  FJobs := TTMSFNCDataGrid.Create(Self);
  FJobs.Parent := FPageHosts[apJobs];
  FLayout.Place(FJobs, daClient, 0, 0, 0, 0, 0);
  FJobs.BeginUpdate;
  try
    FJobs.FixedColumnCount := 0;
    FJobs.ColumnCount := Length(Captions);
    FJobs.RowCount := 1 + Length(Jobs);
    for c := 0 to High(Captions) do
    begin
      FJobs.Cells[c, 0] := Captions[c];
      FJobs.ColumnWidths[c] := Widths[c];
    end;
    for I := 0 to High(Jobs) do
    begin
      FJobs.Cells[0, I + 1] := Jobs[I].Slot;
      FJobs.Cells[1, I + 1] := Jobs[I].Number;
      FJobs.Cells[2, I + 1] := Jobs[I].Customer;
      FJobs.Cells[3, I + 1] := Jobs[I].Address;
      FJobs.Cells[4, I + 1] := Jobs[I].Kind;
      FJobs.Cells[5, I + 1] := Jobs[I].Technician;
      FJobs.Cells[6, I + 1] := StatusHTML(Jobs[I].Status);
    end;
  finally
    FJobs.EndUpdate;
  end;

  { a job opens its tasks }
  FJobs.OnGetDetailData := {$IFDEF WEBLIB}@{$ENDIF}GetJobTasks;
  FJobs.MasterDetail.Template := mdtGrid;
  FJobs.MasterDetail.DrillDown.RootCaption := 'Jobs';
  FJobs.MasterDetail.Summary := '%count% tasks';
  FJobs.MasterDetail.MultipleExpand := False;
  FJobs.MasterDetail.Enabled := True;
  FJobs.MasterDetail.Load;
end;

procedure TForm1.GetJobTasks(Sender: TObject; AMaster: TTMSFNCDataGridRenderer; AMasterRow, ATab: Integer;
  ADetail: TTMSFNCDataGridRenderer; var ANested: Boolean);
var
  I, n, job: Integer;
begin
  job := (AMasterRow - 1) mod Length(Jobs);
  if job < 0 then
    job := 0;
  n := 3 + job mod 3;
  ADetail.ColumnCount := 2;
  ADetail.RowCount := 1 + n;
  ADetail.Cells[0, 0] := 'Task';
  ADetail.Cells[1, 0] := 'State';
  for I := 1 to n do
  begin
    ADetail.Cells[0, I] := Tasks[(job + I - 1) mod Length(Tasks)];
    if Jobs[job].Status = 'Done' then
      ADetail.Cells[1, I] := StatusHTML('Done')
    else if (Jobs[job].Status = 'On site') and (I < n) then
      ADetail.Cells[1, I] := StatusHTML('Done')
    else
      ADetail.Cells[1, I] := StatusHTML('Planned');
  end;
  ADetail.ColumnWidths[0] := 200;
  ADetail.ColumnWidths[1] := 110;
end;

procedure TForm1.CreateCustomers;
var
  r, I: Integer;
  region, n: TTMSFNCTreeViewNode;
begin
  FPath := TTMSFNCBreadcrumb.Create(Self);
  FPath.Parent := FPageHosts[apCustomers];
  FLayout.Place(FPath, daTop, 36, 8, 4, 8, 4);
  FPath.OnItemClick := {$IFDEF WEBLIB}@{$ENDIF}PathClicked;

  FTree := TTMSFNCTreeView.Create(Self);
  FTree.Parent := FPageHosts[apCustomers];
  FLayout.Place(FTree, daClient, 0, 0, 0, 0, 0);
  FTree.BeginUpdate;
  try
    FTree.Columns.Clear;
    FTree.Columns.Add.Text := 'Customer';
    FTree.ColumnsAppearance.Stretch := True;
    FTree.ColumnsAppearance.TopSize := 0;
    for r := 0 to High(Regions) do
    begin
      region := FTree.AddNode(nil);
      region.Text[0] := '<b>' + Regions[r] + '</b>';
      for I := 0 to High(Jobs) do
        if I mod Length(Regions) = r then
        begin
          n := FTree.AddNode(region);
          n.Text[0] := Jobs[I].Customer + '<br><font color="var(--text-secondary)">' + Jobs[I].Address + '</font>';
          n.DataInteger := I;
        end;
      region.Expanded := r = 0;
    end;
  finally
    FTree.EndUpdate;
  end;
  FTree.OnAfterSelectNode := {$IFDEF WEBLIB}@{$ENDIF}TreeSelected;
  UpdatePath;
end;

procedure TForm1.CreateParts;
begin
  FSearch := TTMSFNCEdit.Create(Self);
  FSearch.Parent := FPageHosts[apParts];
  FLayout.Place(FSearch, daTop, 40, 12, 4, 12, 8);
  {$IFDEF FMX}
  FSearch.TextPrompt := 'Search parts';
  {$ELSE}
  FSearch.TextHint := 'Search parts';
  {$ENDIF}
  FSearch.OnChange := {$IFDEF WEBLIB}@{$ENDIF}SearchChanged;

  FParts := TTMSFNCListBox.Create(Self);
  FParts.Parent := FPageHosts[apParts];
  FLayout.Place(FParts, daClient, 0, 0, 0, 0, 0);
  FParts.Header.Visible := False;
  FParts.ItemsAppearance.Look := tnlFluent;
  FillParts;
end;

procedure TForm1.FillParts;
var
  I: Integer;
  it: TTMSFNCListBoxItem;
  s, q: string;
begin
  q := LowerCase(Trim(FSearch.Text));
  FParts.BeginUpdate;
  try
    FParts.Items.Clear;
    for I := 0 to High(Parts) do
      if (q = '') or (Pos(q, LowerCase(Parts[I])) > 0) then
      begin
        it := FParts.Items.Add;
        if Stock[I] = 0 then
          s := '<font color="var(--error)">out of stock</font>'
        else if Stock[I] < 5 then
          s := '<font color="var(--warning)">' + IntToStr(Stock[I]) + ' in the van</font>'
        else
          s := '<font color="var(--text-secondary)">' + IntToStr(Stock[I]) + ' in the van</font>';
        it.Text := Parts[I] + '&nbsp;&nbsp;' + s;
      end;
  finally
    FParts.EndUpdate;
  end;
end;

procedure TForm1.ApplySettings;
var
  d: TDemoDevice;
  rowH: Integer;
  c: Integer;
begin
  for d := Low(TDemoDevice) to High(TDemoDevice) do
    if FDeviceRadios[d].Checked then
      FDevice := d;

  { the Mobile preset of Quick setup, applied in code }
  if FPresetCheck.Checked then
    rowH := 44
  else
    rowH := 30;
  FJobs.BeginUpdate;
  try
    FJobs.DefaultRowHeight := rowH;
    FJobs.Options.Selection.Mode := gsmSingleRow;
    FJobs.Options.Sorting.Enabled := True;
    FJobs.Options.Banding.Enabled := not FPresetCheck.Checked;
    FJobs.Options.Mouse.TouchScrolling := FPresetCheck.Checked;
    if FPresetCheck.Checked then
    begin
      FJobs.Options.Mouse.ClickMargin := 8;
      FJobs.Options.Mouse.ColumnSizeMargin := 12;
      FJobs.Options.Mouse.RowSizeMargin := 12;
    end
    else
    begin
      FJobs.Options.Mouse.ClickMargin := 2;
      FJobs.Options.Mouse.ColumnSizeMargin := 6;
      FJobs.Options.Mouse.RowSizeMargin := 6;
    end;
    for c := 0 to High(Priorities) do
      if FHideCheck.Checked then
        FJobs.Columns[c].HidePriority := Priorities[c]
      else
        FJobs.Columns[c].HidePriority := 0;
    if FDrillCheck.Checked then
      FJobs.MasterDetail.DrillDown.Width := PhoneWidth
    else
      FJobs.MasterDetail.DrillDown.Width := 0;
  finally
    FJobs.EndUpdate;
  end;

  FTree.NodesAppearance.HeightMode := tnhmFixed;
  FTree.NodesAppearance.FixedHeight := rowH;
  FTree.NodesAppearance.ShowLines := not FPresetCheck.Checked;
  FParts.ItemsAppearance.HeightMode := lihmFixed;
  FParts.ItemsAppearance.FixedHeight := rowH;

  LayoutFrame;

  FStatus.Text := 'Make the device narrow: the address, technician and work columns leave the grid, the job and ' +
    'status columns follow. On a phone a job opens in place of the list (tap it twice); the breadcrumb leads back. ' +
    'Switch the preset off to compare with desktop rows.';
end;

procedure TForm1.LayoutFrame;
var
  w, h, maxW: Integer;
begin
  if not Assigned(FFrame) then
    Exit;
  maxW := Round(FContent.Width);
  h := Round(FContent.Height);
  if (FDevice = ddFull) or IsMobilePlatform then
    w := maxW
  else
    w := FLayout.Size(DeviceWidths[FDevice]);
  if w > maxW then
    w := maxW;
  {$IFDEF FMX}
  FFrame.Align := TAlignLayout.None;
  FFrame.SetBounds((maxW - w) / 2, 0, w, h);
  {$ELSE}
  FFrame.Align := alNone;
  FFrame.SetBounds((maxW - w) div 2, 0, w, h);
  {$ENDIF}
end;

procedure TForm1.UpdatePath;
var
  n: TTMSFNCTreeViewNode;
  names: array of string;
  I: Integer;
  s: string;
begin
  FPath.BeginUpdate;
  try
    FPath.Items.Clear;
    FPath.Items.AddItem('Customers');
    n := FTree.SelectedNode;
    SetLength(names, 0);
    while Assigned(n) do
    begin
      s := n.Text[0];
      if Pos('<br>', s) > 0 then
        s := Copy(s, 1, Pos('<br>', s) - 1);
      s := StringReplace(StringReplace(s, '<b>', '', [rfReplaceAll]), '</b>', '', [rfReplaceAll]);
      SetLength(names, Length(names) + 1);
      names[High(names)] := s;
      n := FTree.GetParentNode(n);
    end;
    for I := High(names) downto 0 do
      FPath.Items.AddItem(names[I]);
  finally
    FPath.EndUpdate;
  end;
end;

procedure TForm1.SettingChanged(Sender: TObject);
begin
  ApplySettings;
end;

procedure TForm1.PageChanged(Sender: TObject);
var
  pg: TAppPage;
begin
  for pg := Low(TAppPage) to High(TAppPage) do
    FPageHosts[pg].Visible := Ord(pg) = FPages.ItemIndex;
end;

procedure TForm1.ContentResized(Sender: TObject);
begin
  LayoutFrame;
end;

procedure TForm1.SearchChanged(Sender: TObject);
begin
  FillParts;
end;

procedure TForm1.TreeSelected(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode);
begin
  UpdatePath;
end;

procedure TForm1.PathClicked(Sender: TObject; AIndex: Integer);
var
  n: TTMSFNCTreeViewNode;
  I, depth: Integer;
begin
  { the segment clicked: 0 is the root, then the region, then the customer }
  n := FTree.SelectedNode;
  depth := FPath.Items.Count - 1;
  for I := depth downto AIndex + 1 do
    if Assigned(n) then
      n := FTree.GetParentNode(n);
  if AIndex = 0 then
  begin
    FTree.UnSelectAllNodes;
    FTree.CollapseAll;
  end
  else if Assigned(n) then
    FTree.SelectedNode := n;
  UpdatePath;
end;

end.
