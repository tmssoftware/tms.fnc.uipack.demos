unit UNonVisualDataExport;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  VCL.Controls, VCL.Forms, JS, Web, WEBLib.Graphics, WEBLib.Forms, VCL.Graphics, VCL.Dialogs, VCL.StdCtrls,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPDFIO,
  WEBLib.TMSFNCDataGridData, WEBLib.TMSFNCDataGridRenderer,
  WEBLib.TMSFNCCustomComponent, WEBLib.TMSFNCDataGridPDFIO, WEBLib.StdCtrls,
  VCL.TMSFNCCustomComponent, VCL.TMSFNCPDFIO, VCL.TMSFNCDataGridPDFIO;

type
  TForm130 = class(TWebForm)
    lblTitle: TWebLabel;
    lblDescription: TWebLabel;
    TMSFNCDataGridPDFIO1: TTMSFNCDataGridPDFIO;
    Button1: TWebButton;
    Button3: TWebButton;
    Button4: TWebButton;
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    r: TTMSFNCDataGridRenderer;
  public
    { Public declarations }
    procedure DoFontCacheReady(Sender: TObject);
  end;

var
  Form130: TForm130;

implementation

{$R *.dfm}

uses
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCPDFLib;

procedure TForm130.Button1Click(Sender: TObject);
begin
  //PDF
  TMSFNCDataGridPDFIO1.Renderer := r;

  TMSFNCDataGridPDFIO1.Options.DefaultFont.Name := 'Roboto';
  TMSFNCDataGridPDFIO1.Options.HeaderFont.Name := 'Roboto';
  TMSFNCDataGridPDFIO1.Options.FooterFont.Name := 'Roboto';
  TMSFNCDataGridPDFIO1.Options.PageNumberFont.Name := 'Roboto';
  TMSFNCDataGridPDFIO1.Options.FontFallBackList.Insert(0, 'Roboto');

  TMSFNCDataGridPDFIO1.Options.Header := 'Train Data';
  TMSFNCDataGridPDFIO1.Options.Footer := '';
  TMSFNCDataGridPDFIO1.Options.OpenInPDFReader := True;
  TMSFNCDataGridPDFIO1.Save('Export.pdf');
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

procedure TForm130.DoFontCacheReady(Sender: TObject);
begin
  Button1.Enabled := True;
end;

procedure TForm130.FormCreate(Sender: TObject);
begin
  Application.OnFontCacheReady := DoFontCacheReady;
  AddFontToCache('https://download.tmssoftware.com/tmsweb/pdf/fonts/Roboto-Regular.ttf');
  AddFontToCache('https://download.tmssoftware.com/tmsweb/pdf/fonts/Roboto-Bold.ttf');
  AddFontToCache('https://download.tmssoftware.com/tmsweb/pdf/fonts/Roboto-BoldItalic.ttf');
  AddFontToCache('https://download.tmssoftware.com/tmsweb/pdf/fonts/Roboto-Italic.ttf');

  r := TTMSFNCDataGridRenderer.Create;
  r.GlobalFont.Name := 'Roboto';
  r.LoadFromCSVData('train.csv', TEncoding.UTF8);
  r.Options.IO.OpenAfterCreation := True;
  r.Options.IO.StartRow := 0;
  r.Options.IO.StartColumn := 0;
end;

procedure TForm130.FormDestroy(Sender: TObject);
begin
  r.Free;
end;

end.
