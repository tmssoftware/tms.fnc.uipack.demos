unit UCustomersFireDacSQLite;

interface

uses
  System.SysUtils, System.Math, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  Data.Bind.Controls, FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics,
  FMX.TMSFNCGraphicsTypes, System.Rtti, FMX.TMSFNCDataGridCell,
  FMX.TMSFNCDataGridData, FMX.TMSFNCDataGridBase, FMX.TMSFNCDataGridCore,
  FMX.TMSFNCDataGridRenderer, Data.Bind.Components, Data.Bind.DBScope, Data.DB,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCDataGridDatabaseAdapter,
  FMX.TMSFNCCustomControl, FMX.TMSFNCDataGrid, FMX.Layouts, Fmx.Bind.Navigator,
  FMX.Controls.Presentation, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCSegmentedControl, FMX.TMSFNCDataNavigator,
  FMX.TMSFNCHTMLText, FMX.TMSFNCPanel, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector;

type
  TForm130 = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TTMSFNCPanel;
    DemoTitle: TTMSFNCHTMLText;
    DemoDescription: TTMSFNCHTMLText;
    DemoThemeSelector: TTMSFNCThemeSelector;
    Panel1: TTMSFNCPanel;
    Button2: TTMSFNCButton;
    TMSFNCDataGrid1: TTMSFNCDataGrid;
    BindNavigator1: TBindNavigator;
    TMSFNCDataGridDatabaseAdapter1: TTMSFNCDataGridDatabaseAdapter;
    DataSource1: TDataSource;
    Button1: TTMSFNCButton;
    BindSourceDB1: TBindSourceDB;
    FDConnection1: TFDConnection;
    FDTable1: TFDTable;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FNavigator: TTMSFNCDataNavigator;
    FOptions: TTMSFNCPanel;
    FSortTarget: TTMSFNCSegmentedControl;
    FFilterTarget: TTMSFNCSegmentedControl;
    FCaseCheck: TTMSFNCCheckBox;
    FStatus: TTMSFNCHTMLText;
    function AddSegments(const ACaption: string; ALeft: Single): TTMSFNCSegmentedControl;
    procedure OptionsChanged(Sender: TObject);
    procedure ValidateCell(Sender: TObject; ACell: TTMSFNCDataGridCellCoord; AField: TField;
      var AValue: TTMSFNCDataGridCellValue; var AError: string);
    procedure PostError(Sender: TObject; AError: Exception; var AAction: TTMSFNCDataGridDatabaseAdapterPostErrorAction);
  public
    { Public declarations }
    procedure SetText;
  end;

var
  Form130: TForm130;

implementation

{$R *.fmx}

procedure TForm130.Button1Click(Sender: TObject);
begin
  FDTable1.Active := not FDTable1.Active;
  SetText;
end;

procedure TForm130.FormCreate(Sender: TObject);
begin
  SetText;
  TMSFNCDataGrid1.ScrollMode := gsmCellScrolling;
  { the FNC data navigator in place of the LiveBindings one, and the adapter's options in a second bar }
  BindNavigator1.Visible := False;
  Button2.Visible := False;
  FNavigator := TTMSFNCDataNavigator.Create(Self);
  FNavigator.Parent := Panel1;
  FNavigator.Align := TAlignLayout.Left;
  FNavigator.Margins.Assign(BindNavigator1.Margins);
  FNavigator.Width := 300;
  FNavigator.DataSource := DataSource1;

  FOptions := TTMSFNCPanel.Create(Self);
  FOptions.Parent := Self;
  FOptions.Align := TAlignLayout.Top;
  FOptions.Margins.Assign(Panel1.Margins);
  FOptions.Position.Y := Panel1.Position.Y + Panel1.Height + 1;
  FOptions.Height := 56;
  FSortTarget := AddSegments('Sort in', 12);
  FFilterTarget := AddSegments('Filter in', 300);
  FCaseCheck := TTMSFNCCheckBox.Create(Self);
  FCaseCheck.Parent := FOptions;
  FCaseCheck.SetBounds(600, 12, 200, 32);
  FCaseCheck.Text := 'Filter ignores case';
  FCaseCheck.OnChange := OptionsChanged;
  FStatus := TTMSFNCHTMLText.Create(Self);
  FStatus.Parent := FOptions;
  FStatus.Align := TAlignLayout.Client;
  FStatus.Margins.Rect := RectF(824, 8, 12, 8);
  FStatus.HorizontalTextAlign := gtaLeading;
  FStatus.TextRole := htrSecondary;
  FStatus.WordWrapping := True;
  FStatus.Text := 'Edit a company name or phone number: an empty name or letters in a phone number are refused.';

  TMSFNCDataGrid1.Options.Filtering.Enabled := True;
  TMSFNCDataGridDatabaseAdapter1.KeyFields := 'CustomerID';
  TMSFNCDataGridDatabaseAdapter1.OnValidateCell := ValidateCell;
  TMSFNCDataGridDatabaseAdapter1.OnPostError := PostError;
  FDConnection1.Connected := True;
end;

procedure TForm130.SetText;
begin
  if FDTable1.Active then
    Button1.Text := 'Deactivate'
  else
    Button1.Text := 'Activate';
end;


{ a caption and Auto | Dataset | Grid: where the adapter sorts or filters }
function TForm130.AddSegments(const ACaption: string; ALeft: Single): TTMSFNCSegmentedControl;
var
  l: TTMSFNCHTMLText;
begin
  l := TTMSFNCHTMLText.Create(Self);
  l.Parent := FOptions;
  l.Text := ACaption;
  l.VerticalTextAlign := gtaCenter;
  Result := TTMSFNCSegmentedControl.Create(Self);
  Result.Parent := FOptions;
  Result.SetBounds(ALeft + 64, 12, 216, 32);
  l.SetBounds(ALeft, 12, 60, 32);
  Result.Items.AddItem('Auto');
  Result.Items.AddItem('Dataset');
  Result.Items.AddItem('Grid');
  Result.ItemIndex := 0;
  Result.OnChange := OptionsChanged;
end;

procedure TForm130.OptionsChanged(Sender: TObject);
const
  Modes: array[0..2] of TTMSFNCDataGridDatabaseAdapterOperationMode = (aomAuto, aomDataSet, aomGrid);
begin
  TMSFNCDataGridDatabaseAdapter1.SortTarget := Modes[Max(0, FSortTarget.ItemIndex)];
  TMSFNCDataGridDatabaseAdapter1.FilterTarget := Modes[Max(0, FFilterTarget.ItemIndex)];
  if FCaseCheck.Checked then
    TMSFNCDataGridDatabaseAdapter1.FilterOptions := [afoCaseInsensitive]
  else
    TMSFNCDataGridDatabaseAdapter1.FilterOptions := [];
end;

procedure TForm130.ValidateCell(Sender: TObject; ACell: TTMSFNCDataGridCellCoord; AField: TField;
  var AValue: TTMSFNCDataGridCellValue; var AError: string);
var
  s: string;
  c: Char;
begin
  s := Trim(AValue.AsString);
  if SameText(AField.FieldName, 'CompanyName') and (s = '') then
    AError := 'A customer needs a company name.'
  else if SameText(AField.FieldName, 'Phone') then
    for c in s do
      if not CharInSet(c, ['0'..'9', ' ', '(', ')', '+', '-', '.']) then
      begin
        AError := 'A phone number holds digits, spaces and ( ) + - . only.';
        Break;
      end;
  if AError <> '' then
    FStatus.Text := '<font color="var(--error)">' + AError + '</font>'
  else
    FStatus.Text := 'Saved ' + AField.FieldName + ' of ' + TMSFNCDataGridDatabaseAdapter1.DataSource.DataSet.FieldByName('CompanyName').AsString + '.';
end;

procedure TForm130.PostError(Sender: TObject; AError: Exception; var AAction: TTMSFNCDataGridDatabaseAdapterPostErrorAction);
begin
  FStatus.Text := '<font color="var(--error)">The record was not saved: ' + AError.Message + '</font>';
  AAction := dpeKeepEditing;
end;

end.
