unit UNonVisualDataExport;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.TMSFNCCustomControl, FMX.TMSFNCPDFIO,
  FMX.TMSFNCDataGridData, FMX.TMSFNCDataGridRenderer, FMX.TMSFNCDataGridExcelIO,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCDataGridPDFIO,
  FMX.TMSFNCButton, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCHTMLText, FMX.TMSFNCPanel, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector, FMX.TMSFNCTypes, FMX.TMSFNCUtils;

type
  TForm130 = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TTMSFNCPanel;
    DemoTitle: TTMSFNCHTMLText;
    DemoDescription: TTMSFNCHTMLText;
    DemoThemeSelector: TTMSFNCThemeSelector;
    TMSFNCDataGridPDFIO1: TTMSFNCDataGridPDFIO;
    Button1: TTMSFNCButton;
    Button2: TTMSFNCButton;
    Button3: TTMSFNCButton;
    Button4: TTMSFNCButton;
    TMSFNCDataGridExcelIO1: TTMSFNCDataGridExcelIO;
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    r: TTMSFNCDataGridRenderer;
  public
    { Public declarations }
  end;

var
  Form130: TForm130;

implementation

{$R *.fmx}


procedure TForm130.Button1Click(Sender: TObject);
begin
  //PDF
  TMSFNCDataGridPDFIO1.Renderer := r;
  TMSFNCDataGridPDFIO1.Options.Header := 'Train Data';
  TMSFNCDataGridPDFIO1.Options.Footer := '';
  TMSFNCDataGridPDFIO1.Options.OpenInPDFReader := True;
  TMSFNCDataGridPDFIO1.Save('Export.pdf');
end;

procedure TForm130.Button2Click(Sender: TObject);
begin
  //XLS
  TMSFNCDataGridExcelIO1.Renderer := r;
  TMSFNCDataGridExcelIO1.Options.ExportOverwrite := TOverwriteMode.omAlways;
  TMSFNCDataGridExcelIO1.Options.ExportShowInExcel := True;
  TMSFNCDataGridExcelIO1.DataGridStartCol := 0;
  TMSFNCDataGridExcelIO1.DataGridStartRow := 0;
  TMSFNCDataGridExcelIO1.XLSExport('Export.xls');
end;

procedure TForm130.Button3Click(Sender: TObject);
begin
  //HTML
  r.SaveToHTMLData('Export.html');
end;

procedure TForm130.Button4Click(Sender: TObject);
begin
  //CSV
  r.SaveToCSVData('Export.csv');
end;

procedure TForm130.FormCreate(Sender: TObject);
begin
  r := TTMSFNCDataGridRenderer.Create;
  r.LoadFromCSVData('train.csv');
  r.Options.IO.OpenAfterCreation := True;
  r.Options.IO.StartRow := 0;
  r.Options.IO.StartColumn := 0;
end;

procedure TForm130.FormDestroy(Sender: TObject);
begin
  r.Free;
end;

end.
