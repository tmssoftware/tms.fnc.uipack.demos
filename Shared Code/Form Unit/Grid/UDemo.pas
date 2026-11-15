unit UDemo;

{ TMS FNC UI Pack - Grid

  The classic TTMSFNCGrid under a theme: the Fluent look, sorting on a header click, a filter drop-down in the
  header row, in-place editing with the tool bar pop-up above the active cell, the database adapter that binds
  the grid to a dataset, and the PDF and print components. The PDF and the print-out of a dark theme come out
  light unless "Export as on screen" is set. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCGridOptions, VCL.TMSFNCGridData, VCL.TMSFNCCustomGrid, VCL.TMSFNCGrid, VCL.TMSFNCGridDatabaseAdapter,
  VCL.TMSFNCGridPDFIO, VCL.TMSFNCGridPrintIO, VCL.TMSFNCGridToolBarPopup, VCL.TMSFNCSampleData, VCL.TMSFNCTheme,
  VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCGridOptions, FMX.TMSFNCGridData, FMX.TMSFNCCustomGrid, FMX.TMSFNCGrid, FMX.TMSFNCGridDatabaseAdapter,
  FMX.TMSFNCGridPDFIO, FMX.TMSFNCGridPrintIO, FMX.TMSFNCGridToolBarPopup, FMX.TMSFNCSampleData, FMX.TMSFNCTheme,
  FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs, DB, WEBLib.DB, WEBLib.CDS,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton, WEBLib.TMSFNCGridOptions, WEBLib.TMSFNCGridData,
  WEBLib.TMSFNCCustomGrid, WEBLib.TMSFNCGrid, WEBLib.TMSFNCGridDatabaseAdapter, WEBLib.TMSFNCGridPDFIO,
  WEBLib.TMSFNCGridPrintIO, WEBLib.TMSFNCSampleData, WEBLib.TMSFNCTheme, WEBLib.TMSFNCThemeSelector,
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
    FClassicRadio: TTMSFNCRadioButton;
    FFluentRadio: TTMSFNCRadioButton;
    FSortCheck: TTMSFNCCheckBox;
    FFilterCheck: TTMSFNCCheckBox;
    FEditCheck: TTMSFNCCheckBox;
    FBoundCheck: TTMSFNCCheckBox;
    FOnScreenCheck: TTMSFNCCheckBox;
    FStatus: TTMSFNCHTMLText;
    FGrid: TTMSFNCGrid;
    FOrders: TDemoDataSet;
    FSource: TDataSource;
    FAdapter: TTMSFNCGridDatabaseAdapter;
    FPDF: TTMSFNCGridPDFIO;
    FPrint: TTMSFNCGridPrintIO;
    FBusy: Boolean;
    {$IFNDEF WEBLIB}
    FPopup: TTMSFNCGridToolBarPopup;
    {$ENDIF}
    procedure CreateData;
    procedure CreateSettings;
    procedure CreateContent;
    procedure FillCells;
    procedure SizeColumns;
    procedure ApplySettings;
    procedure SettingChanged(Sender: TObject);
    procedure PDFClick(Sender: TObject);
    procedure PrintClick(Sender: TObject);
    procedure CellChanged(Sender: TObject; ACol, ARow: Integer; CellEditor: TTMSFNCGridEditor);
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
end;

procedure TForm1.CreateData;
var
  orders: TArray<TTMSFNCSampleOrder>;
  I: Integer;
begin
  { the sample orders in an in-memory dataset for the adapter }
  FOrders := FLayout.NewDataSet;
  FOrders.FieldDefs.Add('Number', ftString, 10);
  FOrders.FieldDefs.Add('Date', ftDate);
  FOrders.FieldDefs.Add('Customer', ftString, 40);
  FOrders.FieldDefs.Add('Total', ftFloat);
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
  FOrders.First;
  FSource := FLayout.NewSource(FOrders);
end;

procedure TForm1.CreateSettings;
begin
  FSettings := FLayout.AddSettingsPanel(Self);

  FLayout.AddCaption(FSettings, 'Look');
  FClassicRadio := FLayout.AddRadio(FSettings, 'Classic', 'Look', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FFluentRadio := FLayout.AddRadio(FSettings, 'Fluent', 'Look', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Interaction');
  FSortCheck := FLayout.AddCheck(FSettings, 'Sort on a header click', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FFilterCheck := FLayout.AddCheck(FSettings, 'Filter drop-down in the header', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FEditCheck := FLayout.AddCheck(FSettings, 'Edit cells (format pop-up above the cell)', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Data');
  FBoundCheck := FLayout.AddCheck(FSettings, 'Bind to the orders dataset (adapter)', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FLayout.AddText(FSettings, 'Bound, the adapter makes a column per field and writes edits back.', 44);

  FLayout.AddCaption(FSettings, 'Export');
  FOnScreenCheck := FLayout.AddCheck(FSettings, 'Export as on screen (dark stays dark)', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FLayout.AddButton(FSettings, 'Save as PDF', {$IFDEF WEBLIB}@{$ENDIF}PDFClick);
  FLayout.AddButton(FSettings, 'Print', {$IFDEF WEBLIB}@{$ENDIF}PrintClick);
end;

procedure TForm1.CreateContent;
begin
  FContent := FLayout.AddContentPanel(Self);
  { what the last action did, under the grid }
  FStatus := FLayout.AddText(FContent, '', 36);
  FLayout.Place(FStatus, daBottom, 36, 0, 8, 0, 0);

  FGrid := TTMSFNCGrid.Create(Self);
  FGrid.Parent := FContent;
  FLayout.Place(FGrid, daClient, 0, 0, 0, 0, 0);
  FGrid.Options.Filtering.Rows := frAll;
  FGrid.Options.Filtering.DropDownFixedRow := 0;
  FGrid.Options.Sorting.Row := 0;
  FGrid.OnCellEditDone := {$IFDEF WEBLIB}@{$ENDIF}CellChanged;
  { the customer column takes the width the other columns leave }
  FGrid.Options.ColumnSize.Stretch := True;
  FGrid.Options.ColumnSize.StretchColumn := 2;

  { the database adapter: created once, switched on and off by the check box }
  FAdapter := TTMSFNCGridDatabaseAdapter.Create(Self);
  FAdapter.Grid := FGrid;
  FAdapter.DataSource := FSource;

  { the export components take the grid as their source }
  FPDF := TTMSFNCGridPDFIO.Create(Self);
  FPDF.Grid := FGrid;
  FPDF.Options.Header := 'Orders';
  FPrint := TTMSFNCGridPrintIO.Create(Self);
  FPrint.Grid := FGrid;
  FPrint.Options.Header := 'Orders';

  {$IFNDEF WEBLIB}
  { the format pop-up appears above the active cell while editing }
  FPopup := TTMSFNCGridToolBarPopup.Create(Self);
  FPopup.Grid := FGrid;
  {$ENDIF}
  FillCells;
end;

procedure TForm1.FillCells;
var
  orders: TArray<TTMSFNCSampleOrder>;
  I: Integer;
begin
  orders := TTMSFNCSampleData.Orders;
  FGrid.BeginUpdate;
  FGrid.Clear;
  FGrid.FixedRows := 1;
  FGrid.FixedColumns := 1;
  FGrid.ColumnCount := 6;
  FGrid.RowCount := Length(orders) + 1;
  FGrid.Cells[0, 0] := 'Order';
  FGrid.Cells[1, 0] := 'Date';
  FGrid.Cells[2, 0] := 'Customer';
  FGrid.Cells[3, 0] := 'Total';
  FGrid.Cells[4, 0] := 'Status';
  FGrid.Cells[5, 0] := 'Progress';
  for I := 0 to High(orders) do
  begin
    FGrid.Cells[0, I + 1] := orders[I].Number;
    FGrid.Cells[1, I + 1] := DateToStr(orders[I].Date);
    FGrid.Cells[2, I + 1] := orders[I].Customer;
    FGrid.Floats[3, I + 1] := orders[I].Total;
    FGrid.Cells[4, I + 1] := orders[I].Status;
    FGrid.Ints[5, I + 1] := orders[I].Progress;
  end;
  SizeColumns;
  FGrid.EndUpdate;
end;

procedure TForm1.SizeColumns;
begin
  { order, date, customer (stretched), total, status, progress: the same for the cells filled in code and for the
    fields of the adapter. VCL: widths in pixels of the form (the grid scales them only when the DPI changes later) }
  if FGrid.ColumnCount < 6 then
    Exit;
  FGrid.ColumnWidths[0] := FLayout.Size(90);
  FGrid.ColumnWidths[1] := FLayout.Size(110);
  FGrid.ColumnWidths[2] := FLayout.Size(220);
  FGrid.ColumnWidths[3] := FLayout.Size(100);
  FGrid.ColumnWidths[4] := FLayout.Size(110);
  FGrid.ColumnWidths[5] := FLayout.Size(90);
end;

procedure TForm1.ApplySettings;
begin
  FGrid.BeginUpdate;
  if FFluentRadio.Checked then
    FGrid.Look := glFluent
  else
    FGrid.Look := glClassic;
  if FSortCheck.Checked then
    FGrid.Options.Sorting.Mode := gsmNormal
  else
    FGrid.Options.Sorting.Mode := gsmNone;
  FGrid.Options.Filtering.DropDown := FFilterCheck.Checked;
  FGrid.Options.Editing.Enabled := FEditCheck.Checked;
  if FBoundCheck.Checked <> FAdapter.Active then
  begin
    { the fields take every column: the fixed column of the cells filled in code kept its order numbers next to
      the Number field (two order columns) }
    if FBoundCheck.Checked then
    begin
      FGrid.Clear;
      FGrid.FixedColumns := 0;
    end;
    FAdapter.Active := FBoundCheck.Checked;
    if FAdapter.Active then
      SizeColumns
    else
      FillCells;
  end;
  FGrid.EndUpdate;
  FPDF.Options.ExportAsOnScreen := FOnScreenCheck.Checked;
  FPrint.Options.ExportAsOnScreen := FOnScreenCheck.Checked;
  if FBoundCheck.Checked then
    FStatus.Text := 'Bound: ' + IntToStr(FOrders.RecordCount) + ' records through the adapter.'
  else
    FStatus.Text := 'Unbound: ' + IntToStr(FGrid.RowCount - 1) + ' rows filled in code.';
end;

procedure TForm1.SettingChanged(Sender: TObject);
begin
  ApplySettings;
end;

procedure TForm1.PDFClick(Sender: TObject);
var
  f: string;
begin
  {$IFDEF WEBLIB}
  f := 'orders.pdf';
  {$ELSE}
  f := TTMSFNCUtils.GetDocumentsPath + PathDelim + 'TMS FNC Grid.pdf';
  {$ENDIF}
  { a second click while the file is written, or a PDF still open in a viewer, is not an error for the user }
  if FBusy then
    Exit;
  FBusy := True;
  try
    try
      FPDF.Save(f);
      FStatus.Text := 'Saved <b>' + f + '</b>.';
    except
      on E: Exception do
        FStatus.Text := 'Could not save <b>' + f + '</b>: ' + E.Message;
    end;
  finally
    FBusy := False;
  end;
end;

procedure TForm1.PrintClick(Sender: TObject);
begin
  if FBusy then
    Exit;
  FBusy := True;
  try
    FPrint.Print;
    FStatus.Text := 'Sent to the printer.';
  finally
    FBusy := False;
  end;
end;

procedure TForm1.CellChanged(Sender: TObject; ACol, ARow: Integer; CellEditor: TTMSFNCGridEditor);
begin
  FStatus.Text := 'Cell ' + IntToStr(ACol) + ',' + IntToStr(ARow) + ' is now <b>' + FGrid.Cells[ACol, ARow] + '</b>.';
end;

end.
