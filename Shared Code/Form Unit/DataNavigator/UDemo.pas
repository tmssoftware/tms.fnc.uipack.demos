unit UDemo;

{ TMS FNC UI Pack - DataNavigator

  A data navigator and a data grid on one data source. The navigator's buttons follow the state of the dataset:
  First and Prior disable on the first record, Post and Cancel enable while a record is edited, Delete asks
  for a confirmation. Choose which buttons to show, their order and orientation; the grid gets its columns from
  the fields of the dataset and edits the current record in place. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCDataGrid, VCL.TMSFNCDataNavigator, VCL.TMSFNCSampleData, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCDataGrid, FMX.TMSFNCDataNavigator, FMX.TMSFNCSampleData, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs, DB, WEBLib.DB, WEBLib.CDS,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton, WEBLib.TMSFNCDataGrid, WEBLib.TMSFNCDataNavigator,
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
    FButtonChecks: array[TTMSFNCDataNavigatorButton] of TTMSFNCCheckBox;
    FHorizontalRadio: TTMSFNCRadioButton;
    FVerticalRadio: TTMSFNCRadioButton;
    FConfirmCheck: TTMSFNCCheckBox;
    FAppendCheck: TTMSFNCCheckBox;
    FStatus: TTMSFNCHTMLText;
    FOrders: TDemoDataSet;
    FSource: TDataSource;
    FNavigator: TTMSFNCDataNavigator;
    FGrid: TTMSFNCDataGrid;
    FNextNumber: Integer;
    procedure CreateData;
    procedure CreateSettings;
    procedure CreateContent;
    procedure ApplySettings;
    procedure SettingChanged(Sender: TObject);
    procedure NavigatorButtonClick(Sender: TObject; AButton: TTMSFNCDataNavigatorButton);
    procedure DataChange(Sender: TObject; Field: TField);
    procedure NewRecord(DataSet: TDataSet);
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
  orders: TArray<TTMSFNCSampleOrder>;
  I: Integer;
begin
  { the sample orders of the Core sample data unit in an in-memory dataset }
  FOrders := FLayout.NewDataSet;
  FOrders.FieldDefs.Add('Number', ftString, 10);
  FOrders.FieldDefs.Add('Date', ftDate);
  FOrders.FieldDefs.Add('Customer', ftString, 40);
  FOrders.FieldDefs.Add('Total', ftCurrency);
  FOrders.FieldDefs.Add('Status', ftString, 20);
  FOrders.FieldDefs.Add('Progress', ftInteger);
  FLayout.OpenDataSet(FOrders);
  orders := TTMSFNCSampleData.Orders;
  for I := 0 to High(orders) do
  begin
    FOrders.Append;
    FOrders.FieldByName('Number').AsString := orders[I].Number;
    FOrders.FieldByName('Date').AsDateTime := orders[I].Date;
    FOrders.FieldByName('Customer').AsString := orders[I].Customer;
    FOrders.FieldByName('Total').AsFloat := orders[I].Total;
    FOrders.FieldByName('Status').AsString := orders[I].Status;
    FOrders.FieldByName('Progress').AsInteger := orders[I].Progress;
    FOrders.Post;
  end;
  FNextNumber := Length(orders) + 1;
  FOrders.First;
  FOrders.OnNewRecord := {$IFDEF WEBLIB}@{$ENDIF}NewRecord;
  FSource := FLayout.NewSource(FOrders);
  FSource.OnDataChange := {$IFDEF WEBLIB}@{$ENDIF}DataChange;
end;

procedure TForm1.CreateSettings;
const
  ButtonNames: array[TTMSFNCDataNavigatorButton] of string = ('First', 'Prior', 'Next', 'Last', 'Insert', 'Delete',
    'Edit', 'Post', 'Cancel', 'Refresh');
var
  b: TTMSFNCDataNavigatorButton;
begin
  FSettings := FLayout.AddSettingsPanel(Self);

  FLayout.AddCaption(FSettings, 'Buttons');
  for b := Low(TTMSFNCDataNavigatorButton) to High(TTMSFNCDataNavigatorButton) do
    FButtonChecks[b] := FLayout.AddCheck(FSettings, ButtonNames[b], b <> dnbRefresh, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Options');
  FHorizontalRadio := FLayout.AddRadio(FSettings, 'Horizontal above the grid', 'Orientation', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FVerticalRadio := FLayout.AddRadio(FSettings, 'Vertical next to the grid', 'Orientation', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FConfirmCheck := FLayout.AddCheck(FSettings, 'Confirm before deleting', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FAppendCheck := FLayout.AddCheck(FSettings, 'Insert appends at the end', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Dataset');
  FStatus := FLayout.AddText(FSettings, '', 56);
end;

procedure TForm1.CreateContent;
begin
  FContent := FLayout.AddContentPanel(Self);

  FNavigator := TTMSFNCDataNavigator.Create(Self);
  FNavigator.Parent := FContent;
  FNavigator.DataSource := FSource;
  FNavigator.OnButtonClick := {$IFDEF WEBLIB}@{$ENDIF}NavigatorButtonClick;

  FGrid := TTMSFNCDataGrid.Create(Self);
  FGrid.Parent := FContent;
  FLayout.Place(FGrid, daClient, 0, 0, 0, 0, 0);
  FGrid.DataSource := FSource;
end;

procedure TForm1.ApplySettings;
var
  b: TTMSFNCDataNavigatorButton;
  vis: TTMSFNCDataNavigatorButtons;
begin
  vis := [];
  for b := Low(TTMSFNCDataNavigatorButton) to High(TTMSFNCDataNavigatorButton) do
    if FButtonChecks[b].Checked then
      Include(vis, b);
  FNavigator.BeginUpdate;
  FNavigator.VisibleButtons := vis;
  if FVerticalRadio.Checked then
  begin
    FNavigator.Orientation := dnoVertical;
    FLayout.Place(FNavigator, daLeft, 40, 0, 0, 8, 0);
  end
  else
  begin
    FNavigator.Orientation := dnoHorizontal;
    FLayout.Place(FNavigator, daTop, 36, 0, 0, 0, 8);
  end;
  FNavigator.ConfirmDelete := FConfirmCheck.Checked;
  if FAppendCheck.Checked then
    FNavigator.InsertMode := dnimAppend
  else
    FNavigator.InsertMode := dnimInsert;
  FNavigator.KeyboardShortcuts := True;
  FNavigator.EndUpdate;
end;

procedure TForm1.SettingChanged(Sender: TObject);
begin
  ApplySettings;
end;

procedure TForm1.NavigatorButtonClick(Sender: TObject; AButton: TTMSFNCDataNavigatorButton);
const
  Names: array[TTMSFNCDataNavigatorButton] of string = ('First', 'Prior', 'Next', 'Last', 'Insert', 'Delete',
    'Edit', 'Post', 'Cancel', 'Refresh');
begin
  FStatus.Text := '<b>' + Names[AButton] + '</b> clicked<br>' + FStatus.Text;
end;

procedure TForm1.DataChange(Sender: TObject; Field: TField);
var
  s: string;
begin
  if not Assigned(FStatus) then
    Exit;
  case FOrders.State of
    dsEdit: s := 'editing';
    dsInsert: s := 'inserting';
  else
    s := 'browsing';
  end;
  FStatus.Text := 'Record ' + IntToStr(FOrders.RecNo) + ' of ' + IntToStr(FOrders.RecordCount) + ', ' + s +
    '<br><b>' + FOrders.FieldByName('Number').AsString + '</b> ' + FOrders.FieldByName('Customer').AsString;
end;

procedure TForm1.NewRecord(DataSet: TDataSet);
begin
  { a new order gets its number and today's date; the rest is typed in the grid }
  DataSet.FieldByName('Number').AsString := TTMSFNCSampleData.FormatID(FNextNumber);
  DataSet.FieldByName('Date').AsDateTime := Date;
  DataSet.FieldByName('Status').AsString := 'New';
  DataSet.FieldByName('Progress').AsInteger := 0;
  Inc(FNextNumber);
end;

end.
