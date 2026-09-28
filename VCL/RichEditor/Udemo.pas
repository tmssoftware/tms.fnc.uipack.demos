unit Udemo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VCL.TMSFNCRichEditorToolBar,
  VCL.TMSFNCCustomControl, VCL.TMSFNCToolBar, Vcl.StdCtrls, Vcl.ExtCtrls,
  VCL.TMSFNCScrollControl, VCL.TMSFNCRichEditorBase, VCL.TMSFNCRichEditor,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCCustomComponent, VCL.TMSFNCPDFIO,
  VCL.TMSFNCRichEditorPDFIO, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes,
  VCL.TMSFNCRichEditorRuler, VCL.TMSFNCPrintIO, VCL.TMSFNCRichEditorPrintIO;

type
  TForm1 = class(TForm)
    TMSFNCRichEditor1: TTMSFNCRichEditor;
    Panel1: TPanel;
    Panel2: TPanel;
    ListBox1: TListBox;
    Label1: TLabel;
    TMSFNCRichEditorEditToolBar1: TTMSFNCRichEditorEditToolBar;
    TMSFNCRichEditorFormatToolBar1: TTMSFNCRichEditorFormatToolBar;
    TMSFNCRichEditorPDFIO1: TTMSFNCRichEditorPDFIO;
    Button1: TButton;
    Panel3: TPanel;
    TMSFNCRichEditorHorizontalRuler1: TTMSFNCRichEditorHorizontalRuler;
    Button2: TButton;
    TMSFNCRichEditorPrintIO1: TTMSFNCRichEditorPrintIO;
    PrintDialog1: TPrintDialog;
    procedure ListBox1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TMSFNCRichEditorPDFIO1GetFooter(Sender, AExportObject: TObject;
      APageIndex: Integer; var AFooter: string);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SampleFile;
    procedure SampleIndent;
    procedure SampleBullet;
    procedure SampleAlignment;
    procedure SampleFormat;
    procedure SampleManyLines;
    procedure SampleImages;
    procedure SampleClear;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  TMSFNCRichEditorPDFIO1.Save('richeditorexport.pdf');
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if PrintDialog1.Execute then
  begin
    TMSFNCRichEditorPrintIO1.Options.Header := 'TMS FNC RichEditor Print Export';
    TMSFNCRichEditorPrintIO1.Options.PageNumber := pnHeader;
    TMSFNCRichEditorPrintIO1.Print;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  TMSFNCRichEditorPDFIO1.Options.OpenInPDFReader := True;
  TMSFNCRichEditorPDFIO1.Options.Header := 'TMS FNC RichEditor PDF Export';

  TMSFNCRichEditorPrintIO1.RichEditor := TMSFNCRichEditor1;
end;

procedure TForm1.ListBox1Click(Sender: TObject);
begin
  TMSFNCRichEditor1.Clear;

  case ListBox1.ItemIndex of
  0: SampleFile;
  1: SampleIndent;
  2: SampleBullet;
  3: SampleAlignment;
  4: SampleFormat;
  5: SampleManyLines;
  6: SampleImages;
  7: SampleClear;
  end;

  if TMSFNCRichEditor1.Enabled then
    TMSFNCRichEditor1.SetFocus;
end;

procedure TForm1.SampleAlignment;
var
  s: string;
  i,l: integer;
begin
  s := 'Left justified line';
  i := 0;

  TMSFNCRichEditor1.AddText(s);
  TMSFNCRichEditor1.AddLineBreak;

  l := Length(s);
  TMSFNCRichEditor1.SelectText(0,i + l);

  i := i + l + 2;

  TMSFNCRichEditor1.SetSelectionAttribute(taLeftJustify);

  s := 'Centered line';

  TMSFNCRichEditor1.AddText(s);
  TMSFNCRichEditor1.AddLineBreak;

  l := length(s);

  TMSFNCRichEditor1.SelectText(i,i + l);

  TMSFNCRichEditor1.SetSelectionAttribute(taCenter);

  i := i + l + 2;

  s := 'Right justified line';

  l := length(s);

  TMSFNCRichEditor1.AddText(s);
  TMSFNCRichEditor1.AddLineBreak;

  TMSFNCRichEditor1.SelectText(i, i + l);

  TMSFNCRichEditor1.SetSelectionAttribute(taRightJustify);

  TMSFNCRichEditor1.ClearSelection;
  TMSFNCRichEditor1.ClearCaret;

end;

procedure TForm1.SampleBullet;
begin
  TMSFNCRichEditor1.AddText('First bullet type:');
  TMSFNCRichEditor1.AddLineBreak;

  TMSFNCRichEditor1.AddText('Item 1');
  TMSFNCRichEditor1.AddLineBreak;
  TMSFNCRichEditor1.AddText('Item 2');
  TMSFNCRichEditor1.AddLineBreak;

  TMSFNCRichEditor1.SelectText(20,16);
  TMSFNCRichEditor1.SetSelectionBullets(btCircle);

  TMSFNCRichEditor1.AddLineBreak;
  TMSFNCRichEditor1.AddText('Second bullet type:');
  TMSFNCRichEditor1.AddLineBreak;

  TMSFNCRichEditor1.AddText('Item 1');
  TMSFNCRichEditor1.AddLineBreak;
  TMSFNCRichEditor1.AddText('Item 2');
  TMSFNCRichEditor1.AddLineBreak;

  TMSFNCRichEditor1.SelectText(60,16);
  TMSFNCRichEditor1.SetSelectionBullets(btStar);

  TMSFNCRichEditor1.ClearSelection;
  TMSFNCRichEditor1.ClearCaret;

end;

procedure TForm1.SampleClear;
begin
  TMSFNCRichEditor1.Clear;
end;

procedure TForm1.SampleFile;
begin
  TMSFNCRichEditor1.LoadFromTextFile('.\bellogallico.txt');
end;

procedure TForm1.SampleFormat;
begin
  TMSFNCRichEditor1.AddText('This is sample formatted text with bold, italic, underline, strikethrough');

  TMSFNCRichEditor1.SelectText(35,4);
  TMSFNCRichEditor1.SetSelectionBold(true);

  TMSFNCRichEditor1.SelectText(41,6);
  TMSFNCRichEditor1.SetSelectionItalic(true);

  TMSFNCRichEditor1.SelectText(49,9);
  TMSFNCRichEditor1.SetSelectionUnderline(true);

  TMSFNCRichEditor1.SelectText(60,13);
  TMSFNCRichEditor1.SetSelectionStrikeOut(true);

  TMSFNCRichEditor1.SelectText(15,9);
  TMSFNCRichEditor1.SetSelectionColor(clGreen);

  TMSFNCRichEditor1.SelectText(25,4);
  TMSFNCRichEditor1.SetSelectionColor(clRed);
  TMSFNCRichEditor1.SetSelectionBkColor(clYellow);

  TMSFNCRichEditor1.ClearSelection;
  TMSFNCRichEditor1.ClearCaret;

end;

procedure TForm1.SampleImages;
begin
  TMSFNCRichEditor1.AddText('Car (PNG)');
  TMSFNCRichEditor1.AddLineBreak;
  TMSFNCRichEditor1.AddImage('.\car.png');
  TMSFNCRichEditor1.AddLineBreak;

  TMSFNCRichEditor1.AddText('Grammophone (ICO)');
  TMSFNCRichEditor1.AddLineBreak;
  TMSFNCRichEditor1.AddImage('.\grammo.ico');
  TMSFNCRichEditor1.AddLineBreak;

  TMSFNCRichEditor1.AddText('Toothpaste (BMP)');
  TMSFNCRichEditor1.AddLineBreak;
  TMSFNCRichEditor1.AddImage('.\toothpaste.bmp');
  TMSFNCRichEditor1.AddLineBreak;

  TMSFNCRichEditor1.AddText('Beach (JPEG)');
  TMSFNCRichEditor1.AddLineBreak;
  TMSFNCRichEditor1.AddImage('.\beach.jpg');
  TMSFNCRichEditor1.AddLineBreak;

  TMSFNCRichEditor1.AddText('GIFImage (GIF)');
  TMSFNCRichEditor1.AddLineBreak;
  TMSFNCRichEditor1.AddImage('.\gifimage.gif');
  TMSFNCRichEditor1.AddLineBreak;

end;

procedure TForm1.SampleIndent;
begin
  TMSFNCRichEditor1.AddText('First indent');
  TMSFNCRichEditor1.AddLineBreak;
  TMSFNCRichEditor1.AddText('First indent');
  TMSFNCRichEditor1.AddLineBreak;

  TMSFNCRichEditor1.SelectText(0,24);
  TMSFNCRichEditor1.SetSelectionIndent(50);

  TMSFNCRichEditor1.AddText('Second larger indent');
  TMSFNCRichEditor1.SelectText(26,20);
  TMSFNCRichEditor1.SetSelectionIndent(150);

  TMSFNCRichEditor1.ClearSelection;
  TMSFNCRichEditor1.ClearCaret;

end;

procedure TForm1.SampleManyLines;
var
  i: integer;
begin
  TMSFNCRichEditor1.BeginUpdate;
  for i := 0 to 400 do
    begin
      TMSFNCRichEditor1.AddText('This is line nr. '+inttostr(i)+' in the rich text editor');
      TMSFNCRichEditor1.AddLineBreak;
    end;
  TMSFNCRichEditor1.EndUpdate;
end;

procedure TForm1.TMSFNCRichEditorPDFIO1GetFooter(Sender, AExportObject: TObject;
  APageIndex: Integer; var AFooter: string);
begin
  AFooter := 'Page ' + IntToStr(APageIndex);
end;

end.
