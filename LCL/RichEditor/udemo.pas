unit udemo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, PrintersDlgs, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, LCLTMSFNCRichEditorToolBar, LCLTMSFNCRichEditor,
  LCLTMSFNCRichEditorBase, LCLTMSFNCRichEditorPDFIO, LCLTMSFNCRichEditorRuler,
  LCLTMSFNCRichEditorPrintIO;

type

  { TForm2 }

  TForm2 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    ListBox1: TListBox;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    PrintDialog1: TPrintDialog;
    TMSFNCRichEditor1: TTMSFNCRichEditor;
    TMSFNCRichEditorEditToolBar1: TTMSFNCRichEditorEditToolBar;
    TMSFNCRichEditorFormatToolBar1: TTMSFNCRichEditorFormatToolBar;
    TMSFNCRichEditorHorizontalRuler1: TTMSFNCRichEditorHorizontalRuler;
    TMSFNCRichEditorPDFIO1: TTMSFNCRichEditorPDFIO;
    TMSFNCRichEditorPrintIO1: TTMSFNCRichEditorPrintIO;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
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
  Form2: TForm2;

implementation

{$R *.lfm}

{ TForm2 }

procedure TForm2.ListBox1Click(Sender: TObject);
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

procedure TForm2.Button1Click(Sender: TObject);
begin
  TMSFNCRichEditorPDFIO1.Save('richeditorexport.pdf');
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  if PrintDialog1.Execute then
  begin
    TMSFNCRichEditorPrintIO1.Options.Header := 'TMS FNC RichEditor Print Export';
    TMSFNCRichEditorPrintIO1.Print;
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  TMSFNCRichEditorPDFIO1.Options.OpenInPDFReader := True;
  TMSFNCRichEditorPDFIO1.Options.Header := 'TMS FNC RichEditor PDF Export';
end;

procedure TForm2.SampleFile;
begin
  TMSFNCRichEditor1.LoadFromTextFile('.\bellogallico.txt');
end;

procedure TForm2.SampleIndent;
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

procedure TForm2.SampleBullet;
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

procedure TForm2.SampleAlignment;
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

procedure TForm2.SampleFormat;
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

procedure TForm2.SampleManyLines;
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

procedure TForm2.SampleImages;
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

procedure TForm2.SampleClear;
begin
  TMSFNCRichEditor1.Clear;
end;

end.

