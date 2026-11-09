unit UDemo;

{ TMS FNC UI Pack - ListView

  Files and folders in a list view: the report view with sortable columns, groups that collapse, check boxes
  and multi-selection; large icons, small icons and the list view of the same items; rename in place with F2
  or a second click. The second list is virtual: a million rows supplied by OnGetItemData as they come into
  view. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCListView, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCListView, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton, WEBLib.TMSFNCListView, WEBLib.TMSFNCTheme,
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
    FViewRadios: array[TTMSFNCListViewViewStyle] of TTMSFNCRadioButton;
    FGroupsCheck: TTMSFNCCheckBox;
    FChecksCheck: TTMSFNCCheckBox;
    FMultiCheck: TTMSFNCCheckBox;
    FRenameCheck: TTMSFNCCheckBox;
    FGridCheck: TTMSFNCCheckBox;
    FStatus: TTMSFNCHTMLText;
    FFiles: TTMSFNCListView;
    FOrders: TTMSFNCListView;
    procedure CreateSettings;
    procedure CreateContent;
    procedure ApplySettings;
    procedure SettingChanged(Sender: TObject);
    procedure FilesSelectionChanged(Sender: TObject);
    procedure FilesCheckChanged(Sender: TObject; AIndex: Integer);
    procedure FilesAfterEdit(Sender: TObject; AIndex: Integer; var AText: string; var AAllow: Boolean);
    procedure OrdersData(Sender: TObject; AIndex: Integer; AItem: TTMSFNCListViewItem);
    procedure OrdersItemIndexChanged(Sender: TObject);
    procedure SortSizeClick(Sender: TObject);
    procedure AddFileClick(Sender: TObject);
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
  Cities: array[0..5] of string = ('Brussels', 'Ghent', 'Antwerp', 'Leuven', 'Bruges', 'Namur');

procedure TForm1.FormCreate(Sender: TObject);
begin
  FLayout := TDemoLayout.Create(Self);
  CreateSettings;
  CreateContent;
  ApplySettings;
end;

procedure TForm1.CreateSettings;
const
  ViewNames: array[TTMSFNCListViewViewStyle] of string = ('Large icons', 'Small icons', 'List', 'Report');
var
  vs: TTMSFNCListViewViewStyle;
begin
  FSettings := FLayout.AddSettingsPanel(Self);

  FLayout.AddCaption(FSettings, 'View');
  for vs := Low(TTMSFNCListViewViewStyle) to High(TTMSFNCListViewViewStyle) do
    FViewRadios[vs] := FLayout.AddRadio(FSettings, ViewNames[vs], 'View', vs = lvvsReport, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Files');
  FGroupsCheck := FLayout.AddCheck(FSettings, 'Groups', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FChecksCheck := FLayout.AddCheck(FSettings, 'Check boxes', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FMultiCheck := FLayout.AddCheck(FSettings, 'Select several (Ctrl, Shift)', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FRenameCheck := FLayout.AddCheck(FSettings, 'Rename with F2 or a second click', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FGridCheck := FLayout.AddCheck(FSettings, 'Grid lines in the report', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FLayout.AddButton(FSettings, 'Sort by size, largest first', {$IFDEF WEBLIB}@{$ENDIF}SortSizeClick);
  FLayout.AddButton(FSettings, 'Add a file', {$IFDEF WEBLIB}@{$ENDIF}AddFileClick);

  FLayout.AddCaption(FSettings, 'Events');
  FStatus := FLayout.AddText(FSettings, 'Select, check or rename an item.', 100);
end;

procedure TForm1.CreateContent;
begin
  FContent := FLayout.AddContentPanel(Self);

  FLayout.AddCaption(FContent, 'Files', 8);
  FFiles := TTMSFNCListView.Create(Self);
  FFiles.Parent := FContent;
  FLayout.Place(FFiles, daTop, 300, 16, 0, 16, 16);
  FFiles.BeginUpdate;
  FFiles.Columns.Add('Name', 240);
  FFiles.Columns.Add('Type', 120);
  FFiles.Columns.Add('Size', 100).Alignment := gtaTrailing;
  FFiles.Columns.Add('Modified', 120);
  FFiles.Groups.Add('Folders');
  FFiles.Groups.Add('Documents');
  FFiles.Groups.Add('Images');
  FFiles.Items.Add('Projects', ['Folder', '', '02/11/2026'], 'Folder', 0);
  FFiles.Items.Add('Invoices', ['Folder', '', '28/10/2026'], 'Folder', 0);
  FFiles.Items.Add('Budget 2026.xlsx', ['Spreadsheet', '48 KB', '28/10/2026'], 'Document', 1);
  FFiles.Items.Add('Release notes.docx', ['Document', '212 KB', '05/11/2026'], 'Document', 1);
  FFiles.Items.Add('Contract draft.pdf', ['PDF', '1.4 MB', '30/10/2026'], 'Document', 1);
  FFiles.Items.Add('Readme.txt', ['Text', '2 KB', '06/11/2026'], 'Document', 1);
  FFiles.Items.Add('Logo.png', ['Image', '126 KB', '14/10/2026'], 'Image', 2);
  FFiles.Items.Add('Team photo.jpg', ['Image', '3.2 MB', '01/09/2026'], 'Image', 2);
  FFiles.Items.Add('Banner.svg', ['Image', '18 KB', '22/10/2026'], 'Image', 2);
  FFiles.Items[3].Checked := True;
  FFiles.Items[8].Enabled := False;
  FFiles.EndUpdate;
  FFiles.OnSelectionChanged := {$IFDEF WEBLIB}@{$ENDIF}FilesSelectionChanged;
  FFiles.OnItemCheckChanged := {$IFDEF WEBLIB}@{$ENDIF}FilesCheckChanged;
  FFiles.OnAfterEdit := {$IFDEF WEBLIB}@{$ENDIF}FilesAfterEdit;

  FLayout.AddCaption(FContent, 'Orders: a virtual list of 1,000,000 rows', 8);
  FOrders := TTMSFNCListView.Create(Self);
  FOrders.Parent := FContent;
  FLayout.Place(FOrders, daClient, 16, 0, 16, 0, 0);
  FOrders.Columns.Add('Order', 150);
  FOrders.Columns.Add('City', 130);
  FOrders.Columns.Add('Amount', 110).Alignment := gtaTrailing;
  FOrders.Columns.Add('Date', 120);
  FOrders.OnGetItemData := {$IFDEF WEBLIB}@{$ENDIF}OrdersData;
  FOrders.OnItemIndexChanged := {$IFDEF WEBLIB}@{$ENDIF}OrdersItemIndexChanged;
  FOrders.VirtualMode := True;
  FOrders.VirtualItemCount := 1000000;
  FOrders.ItemIndex := 499999;
end;

procedure TForm1.ApplySettings;
var
  vs: TTMSFNCListViewViewStyle;
begin
  FFiles.BeginUpdate;
  for vs := Low(TTMSFNCListViewViewStyle) to High(TTMSFNCListViewViewStyle) do
    if FViewRadios[vs].Checked then
      FFiles.ViewStyle := vs;
  FFiles.ShowGroups := FGroupsCheck.Checked;
  FFiles.CheckBoxes := FChecksCheck.Checked;
  FFiles.MultiSelect := FMultiCheck.Checked;
  FFiles.AllowRename := FRenameCheck.Checked;
  FFiles.Appearance.ShowGridLines := FGridCheck.Checked;
  FFiles.EndUpdate;
  FOrders.Appearance.ShowGridLines := FGridCheck.Checked;
end;

procedure TForm1.SettingChanged(Sender: TObject);
begin
  ApplySettings;
end;

procedure TForm1.FilesSelectionChanged(Sender: TObject);
var
  I, n: Integer;
  s: string;
begin
  n := 0;
  s := '';
  for I := 0 to FFiles.Items.Count - 1 do
    if FFiles.Items[I].Selected then
    begin
      Inc(n);
      if n <= 3 then
        s := s + FFiles.Items[I].Text + '<br>';
    end;
  if n > 3 then
    s := s + 'and ' + IntToStr(n - 3) + ' more';
  FStatus.Text := IntToStr(n) + ' selected<br>' + s;
end;

procedure TForm1.FilesCheckChanged(Sender: TObject; AIndex: Integer);
begin
  if FFiles.Items[AIndex].Checked then
    FStatus.Text := '<b>' + FFiles.Items[AIndex].Text + '</b> checked'
  else
    FStatus.Text := '<b>' + FFiles.Items[AIndex].Text + '</b> unchecked';
end;

procedure TForm1.FilesAfterEdit(Sender: TObject; AIndex: Integer; var AText: string; var AAllow: Boolean);
begin
  { an empty name is refused; the item keeps its old text }
  AAllow := Trim(AText) <> '';
  if AAllow then
    FStatus.Text := 'Renamed to <b>' + AText + '</b>'
  else
    FStatus.Text := 'An empty name is not accepted';
end;

procedure TForm1.OrdersData(Sender: TObject; AIndex: Integer; AItem: TTMSFNCListViewItem);
begin
  { the row is filled when it scrolls into view; nothing is stored for the million rows }
  AItem.Text := 'Order ' + IntToStr(100001 + AIndex);
  AItem.IconName := 'Document';
  AItem.SubItems.Add(Cities[AIndex mod Length(Cities)]);
  AItem.SubItems.Add(FormatFloat('#,##0.00', (Int64(AIndex) * 7919) mod 100000 / 100));
  AItem.SubItems.Add(IntToStr(1 + AIndex mod 28) + '/11/2026');
end;

procedure TForm1.OrdersItemIndexChanged(Sender: TObject);
begin
  if FOrders.ItemIndex >= 0 then
    FStatus.Text := 'Order <b>' + IntToStr(100001 + FOrders.ItemIndex) + '</b>, row ' + IntToStr(FOrders.ItemIndex + 1) +
      ' of ' + IntToStr(FOrders.VirtualItemCount);
end;

procedure TForm1.SortSizeClick(Sender: TObject);
begin
  FFiles.SortItems(2, lvsdDescending);
end;

procedure TForm1.AddFileClick(Sender: TObject);
begin
  FFiles.Items.Add('New document ' + IntToStr(FFiles.Items.Count + 1) + '.docx', ['Document', '1 KB', '09/11/2026'],
    'Document', 1);
end;

end.
