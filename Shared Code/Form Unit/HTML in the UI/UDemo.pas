unit UDemo;

{ TMS FNC UI Pack - HTML in the UI

  The HTML engine of FNC Core 5.0 renders inside the UI controls: an HTML text with a style sheet, a table and
  a list, list box items with inline markup, badges and text roles, and grid cells with bold, colour and links.
  Colours written as theme:accent or var(--text-secondary) follow the theme: switch to Dark in the header and
  every piece of markup keeps its contrast. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCListBox, VCL.TMSFNCDataGrid, VCL.TMSFNCSampleData, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCListBox, FMX.TMSFNCDataGrid, FMX.TMSFNCSampleData, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton, WEBLib.TMSFNCListBox, WEBLib.TMSFNCDataGrid,
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
    FArticleRadio: TTMSFNCRadioButton;
    FTableRadio: TTMSFNCRadioButton;
    FListRadio: TTMSFNCRadioButton;
    FBadgesCheck: TTMSFNCCheckBox;
    FStatus: TTMSFNCHTMLText;
    FText: TTMSFNCHTMLText;
    FList: TTMSFNCListBox;
    FGrid: TTMSFNCDataGrid;
    procedure CreateSettings;
    procedure CreateContent;
    procedure FillList;
    procedure FillGrid;
    procedure ApplySettings;
    procedure SettingChanged(Sender: TObject);
    procedure AnchorClick(Sender: TObject; AAnchor: string);
    procedure CellAnchorClick(Sender: TObject; AColumn, ARow: Integer; AAnchor: string);
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
  Style = '<style>' +
    'h2 { font-size: 16px; margin: 0 0 6px 0; }' +
    'p { margin: 0 0 8px 0; line-height: 1.4; }' +
    '.note { color: var(--text-secondary); font-size: 12px; }' +
    '.accent { color: theme:accent; font-weight: bold; }' +
    'table { border-collapse: collapse; }' +
    'th { text-align: left; padding: 4px 10px 4px 0; border-bottom: 1px solid var(--border); }' +
    'td { padding: 4px 10px 4px 0; }' +
    '.ok { color: var(--success); } .warn { color: var(--warning); } .err { color: var(--error); }' +
    '</style>';

  Article = Style +
    '<h2>Release notes</h2>' +
    '<p>Version <span class="accent">8.0</span> renders HTML with CSS in every control: a <code>&lt;style&gt;</code> ' +
    'block, <code>style</code> attributes, selectors for classes and elements.</p>' +
    '<p>Colours can name the theme: <span style="color:theme:accent">theme:accent</span>, ' +
    '<span style="color:var(--text-secondary)">var(--text-secondary)</span>, ' +
    '<span class="ok">var(--success)</span>, <span class="warn">var(--warning)</span> and ' +
    '<span class="err">var(--error)</span> change with the theme.</p>' +
    '<p class="note">Links are drawn in the accent colour: <a href="docs">documentation</a>, ' +
    '<a href="support">support</a>.</p>';

  Table = Style +
    '<h2>Quarter at a glance</h2>' +
    '<table><tr><th>Region</th><th>Revenue</th><th>Change</th></tr>' +
    '<tr><td>Europe</td><td>142,900</td><td class="ok">+8.2%</td></tr>' +
    '<tr><td>Americas</td><td>121,800</td><td class="ok">+4.7%</td></tr>' +
    '<tr><td>Asia Pacific</td><td>83,600</td><td class="warn">-1.1%</td></tr>' +
    '<tr><td><b>Total</b></td><td><b>348,300</b></td><td class="ok"><b>+5.1%</b></td></tr></table>' +
    '<p class="note">A table with a header row, padding and a bottom border from the style sheet.</p>';

  List = Style +
    '<h2>Before the release</h2>' +
    '<ul><li>Run the <span class="accent">gate</span> on both compilers</li>' +
    '<li>Update the version history</li>' +
    '<li>Build the demos for FMX, VCL and WEB</li></ul>' +
    '<ol><li>Tag the release</li><li>Publish the packages</li><li>Announce it</li></ol>' +
    '<p class="note">Unordered and ordered lists with the theme''s text colour for the markers.</p>';

procedure TForm1.FormCreate(Sender: TObject);
begin
  FLayout := TDemoLayout.Create(Self);
  CreateSettings;
  CreateContent;
  ApplySettings;
end;

procedure TForm1.CreateSettings;
begin
  FSettings := FLayout.AddSettingsPanel(Self);

  FLayout.AddCaption(FSettings, 'HTML text');
  FArticleRadio := FLayout.AddRadio(FSettings, 'Article with styles and links', 'Sample', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FTableRadio := FLayout.AddRadio(FSettings, 'Table', 'Sample', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FListRadio := FLayout.AddRadio(FSettings, 'Lists', 'Sample', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'List box');
  FBadgesCheck := FLayout.AddCheck(FSettings, 'Badges with a status kind', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FLayout.AddText(FSettings, 'Every list box item is HTML; the badge and its kind (success, warning, ...) are ' +
    'item properties coloured by the theme.', 64);

  FLayout.AddCaption(FSettings, 'Last link');
  FStatus := FLayout.AddText(FSettings, 'Click a link in the text or in the grid.', 60);
end;

procedure TForm1.CreateContent;
var
  left: TTMSFNCPanel;
begin
  FContent := FLayout.AddContentPanel(Self);

  left := FLayout.AddPanel(FContent, daLeft, 420, 0, 0, 16, 0);
  left.Fill.Kind := gfkNone;
  left.Stroke.Kind := gskNone;
  FLayout.AddCaption(left, 'HTML text', 8);
  FText := TTMSFNCHTMLText.Create(Self);
  FText.Parent := left;
  FLayout.Place(FText, daTop, 260, 0, 0, 0, 16);
  FText.HorizontalTextAlign := gtaLeading;
  FText.VerticalTextAlign := gtaLeading;
  FText.WordWrapping := True;
  FText.OnAnchorClick := {$IFDEF WEBLIB}@{$ENDIF}AnchorClick;

  FLayout.AddCaption(left, 'List box items', 8);
  FList := TTMSFNCListBox.Create(Self);
  FList.Parent := left;
  FLayout.Place(FList, daClient, 0, 0, 0, 0, 0);
  FillList;

  FLayout.AddCaption(FContent, 'Grid cells', 8);
  FGrid := TTMSFNCDataGrid.Create(Self);
  FGrid.Parent := FContent;
  FLayout.Place(FGrid, daClient, 0, 0, 0, 0, 0);
  FGrid.OnCellAnchorClick := {$IFDEF WEBLIB}@{$ENDIF}CellAnchorClick;
  FillGrid;
end;

procedure TForm1.FillList;
var
  tasks: TArray<TTMSFNCSampleTask>;
  I: Integer;
  it: TTMSFNCListBoxItem;
begin
  tasks := TTMSFNCSampleData.Tasks;
  FList.BeginUpdate;
  FList.Items.Clear;
  for I := 0 to High(tasks) do
  begin
    it := FList.Items.Add;
    it.Text := '<b>' + tasks[I].Text + '</b><br><span style="color:var(--text-secondary)">Task ' +
      TTMSFNCSampleData.FormatID(I + 1) + '</span>';
    it.Badge := tasks[I].Badge;
    it.BadgeKind := tasks[I].Kind;
  end;
  FList.EndUpdate;
end;

procedure TForm1.FillGrid;
var
  orders: TArray<TTMSFNCSampleOrder>;
  I: Integer;
  cls: string;
begin
  orders := TTMSFNCSampleData.Orders;
  FGrid.BeginUpdate;
  FGrid.Clear;
  FGrid.ColumnCount := 4;
  FGrid.RowCount := Length(orders) + 1;
  FGrid.FixedRowCount := 1;
  FGrid.Cells[0, 0] := 'Order';
  FGrid.Cells[1, 0] := 'Customer';
  FGrid.Cells[2, 0] := 'Status';
  FGrid.Cells[3, 0] := 'Total';
  FGrid.ColumnWidths[1] := 220;
  FGrid.ColumnWidths[2] := 160;
  for I := 0 to High(orders) do
  begin
    { a link per order, a bold customer and a status in the theme's status colour }
    FGrid.Cells[0, I + 1] := '<a href="' + orders[I].Number + '">' + orders[I].Number + '</a>';
    FGrid.Cells[1, I + 1] := '<b>' + orders[I].Customer + '</b>';
    case orders[I].Kind of
      tskSuccess: cls := 'var(--success)';
      tskWarning: cls := 'var(--warning)';
      tskError: cls := 'var(--error)';
    else
      cls := 'var(--text-secondary)';
    end;
    FGrid.Cells[2, I + 1] := '<span style="color:' + cls + '">' + orders[I].Status + '</span>';
    FGrid.Cells[3, I + 1] := orders[I].TotalText;
  end;
  FGrid.EndUpdate;
end;

procedure TForm1.ApplySettings;
var
  I: Integer;
begin
  if FTableRadio.Checked then
    FText.Text := Table
  else if FListRadio.Checked then
    FText.Text := List
  else
    FText.Text := Article;
  FList.BeginUpdate;
  for I := 0 to FList.Items.Count - 1 do
    if FBadgesCheck.Checked then
      FList.Items[I].Badge := TTMSFNCSampleData.Tasks[I].Badge
    else
      FList.Items[I].Badge := '';
  FList.EndUpdate;
end;

procedure TForm1.SettingChanged(Sender: TObject);
begin
  ApplySettings;
end;

procedure TForm1.AnchorClick(Sender: TObject; AAnchor: string);
begin
  FStatus.Text := 'Link <b>' + AAnchor + '</b> clicked';
end;

procedure TForm1.CellAnchorClick(Sender: TObject; AColumn, ARow: Integer; AAnchor: string);
begin
  FStatus.Text := 'Order <b>' + AAnchor + '</b> in row ' + IntToStr(ARow);
end;

end.
