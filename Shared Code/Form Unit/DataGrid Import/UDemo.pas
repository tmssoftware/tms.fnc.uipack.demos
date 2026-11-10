unit UDemo;

{ TMS FNC UI Pack - DataGrid Import

  The import dialog brings a CSV, JSON, XML or tab separated text file into the grid: pick the file, see the
  preview with the detected delimiter, header row and column types, change a type and import. Sample files of
  every format lie next to the demo in Shared Code\Business Logic\DataGrid Import; the dialog starts there.
  The imported rows replace or follow the data already in the grid. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.IOUtils,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCDataGrid, VCL.TMSFNCDataGridImportDialog, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, System.IOUtils,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCDataGrid, FMX.TMSFNCDataGridImportDialog, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
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
    FFormatRadios: array[TTMSFNCDataGridImportFormat] of TTMSFNCRadioButton;
    FReplaceCheck: TTMSFNCCheckBox;
    FHeaderCheck: TTMSFNCCheckBox;
    FTypesCheck: TTMSFNCCheckBox;
    FStatus: TTMSFNCHTMLText;
    FGrid: TTMSFNCDataGrid;
    FDialog: TTMSFNCDataGridImportDialog;
    FSampleFolder: string;
    procedure CreateSettings;
    procedure CreateContent;
    procedure FillSample;
    procedure ImportClick(Sender: TObject);
    procedure ImportSampleClick(Sender: TObject);
    procedure ResetClick(Sender: TObject);
    procedure RunImport(const AFileName: string);
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

procedure TForm1.FormCreate(Sender: TObject);
begin
  FLayout := TDemoLayout.Create(Self);
  { the sample files of the demo, next to the shared code }
  FSampleFolder := TPath.GetFullPath(TPath.Combine(ExtractFilePath(ParamStr(0)),
    '..\..\..\..\Shared Code\Business Logic\DataGrid Import'));
  if not TDirectory.Exists(FSampleFolder) then
    FSampleFolder := TPath.GetFullPath(TPath.Combine(ExtractFilePath(ParamStr(0)),
      '..\..\Shared Code\Business Logic\DataGrid Import'));
  CreateSettings;
  CreateContent;
  FillSample;
end;

procedure TForm1.CreateSettings;
const
  FormatNames: array[TTMSFNCDataGridImportFormat] of string = ('Detect from the file', 'CSV', 'JSON', 'XML',
    'Tab separated text');
var
  f: TTMSFNCDataGridImportFormat;
begin
  FSettings := FLayout.AddSettingsPanel(Self, 280);

  FLayout.AddCaption(FSettings, 'Format');
  for f := Low(TTMSFNCDataGridImportFormat) to High(TTMSFNCDataGridImportFormat) do
    FFormatRadios[f] := FLayout.AddRadio(FSettings, FormatNames[f], 'Format', f = gifAuto, nil);

  FLayout.AddCaption(FSettings, 'Options');
  FReplaceCheck := FLayout.AddCheck(FSettings, 'Replace the data in the grid', True, nil);
  FHeaderCheck := FLayout.AddCheck(FSettings, 'First row holds the column names', True, nil);
  FTypesCheck := FLayout.AddCheck(FSettings, 'Column types can be changed in the dialog', True, nil);

  FLayout.AddCaption(FSettings, 'Import');
  FLayout.AddButton(FSettings, 'Choose a file...', ImportClick);
  FLayout.AddButton(FSettings, 'Sample products.csv', ImportSampleClick).Tag := 0;
  FLayout.AddButton(FSettings, 'Sample customers.json', ImportSampleClick).Tag := 1;
  FLayout.AddButton(FSettings, 'Sample employees.xml', ImportSampleClick).Tag := 2;
  FLayout.AddButton(FSettings, 'Sample sales.txt', ImportSampleClick).Tag := 3;
  FLayout.AddButton(FSettings, 'Back to the sample grid', ResetClick);

  FLayout.AddCaption(FSettings, 'Result');
  FStatus := FLayout.AddText(FSettings, '', 80);
end;

procedure TForm1.CreateContent;
begin
  FContent := FLayout.AddContentPanel(Self);
  FGrid := TTMSFNCDataGrid.Create(Self);
  FGrid.Parent := FContent;
  FLayout.Place(FGrid, daClient, 0, 0, 0, 0, 0);

  FDialog := TTMSFNCDataGridImportDialog.Create(Self);
  FDialog.DataGrid := FGrid;
  FDialog.Title := 'Import into the grid';
end;

procedure TForm1.FillSample;
var
  I: Integer;
begin
  { a small grid of orders to start from }
  FGrid.BeginUpdate;
  FGrid.Clear;
  FGrid.ColumnCount := 4;
  FGrid.RowCount := 6;
  FGrid.FixedRowCount := 1;
  FGrid.Cells[0, 0] := 'Order';
  FGrid.Cells[1, 0] := 'Customer';
  FGrid.Cells[2, 0] := 'Date';
  FGrid.Cells[3, 0] := 'Total';
  for I := 1 to 5 do
  begin
    FGrid.Cells[0, I] := 'ORD-' + IntToStr(1000 + I);
    FGrid.Cells[1, I] := 'Customer ' + IntToStr(I);
    FGrid.Cells[2, I] := DateToStr(EncodeDate(2026, 11, I));
    FGrid.Cells[3, I] := FormatFloat('0.00', 120 * I + 0.5);
  end;
  FGrid.EndUpdate;
  FStatus.Text := 'The sample grid. Import a file to replace it or to add rows.';
end;

procedure TForm1.RunImport(const AFileName: string);
var
  f: TTMSFNCDataGridImportFormat;
begin
  FDialog.FileName := AFileName;
  for f := Low(TTMSFNCDataGridImportFormat) to High(TTMSFNCDataGridImportFormat) do
    if FFormatRadios[f].Checked then
      FDialog.Format := f;
  FDialog.ReplaceData := FReplaceCheck.Checked;
  FDialog.HeaderRow := FHeaderCheck.Checked;
  FDialog.AllowColumnTypes := FTypesCheck.Checked;
  if FDialog.Execute then
    FStatus.Text := '<b>' + IntToStr(FDialog.ImportedRows) + ' rows</b> imported from ' + ExtractFileName(FDialog.FileName)
  else if FDialog.LastError <> '' then
    FStatus.Text := 'Import failed: ' + FDialog.LastError
  else
    FStatus.Text := 'Import cancelled';
end;

procedure TForm1.ImportClick(Sender: TObject);
begin
  { an empty file name: the dialog asks for the file }
  RunImport('');
end;

procedure TForm1.ImportSampleClick(Sender: TObject);
const
  Files: array[0..3] of string = ('products.csv', 'customers.json', 'employees.xml', 'sales.txt');
begin
  RunImport(TPath.Combine(FSampleFolder, Files[TTMSFNCButton(Sender).Tag]));
end;

procedure TForm1.ResetClick(Sender: TObject);
begin
  FillSample;
end;

end.
