unit frmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VCL.TMSFNCTypes, VCL.TMSFNCUtils,
  VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCWebBrowser,
  VCL.TMSFNCCustomWEBControl, VCL.TMSFNCMemo, VCL.TMSFNCToolBar,
  VCL.TMSFNCPageControl, VCL.TMSFNCCustomControl, VCL.TMSFNCTabSet,
  VCL.TMSFNCComboBox, VCL.TMSFNCCustomPicker, VCL.TMSFNCFontSizePicker,
  Vcl.StdCtrls;

type
  TForm2 = class(TForm)
    DemoPages: TTMSFNCPageControl;
    TMSFNCToolBar1: TTMSFNCToolBar;
    BasicMemo: TTMSFNCMemo;
    OpenFile: TTMSFNCToolBarButton;
    SaveFile: TTMSFNCToolBarButton;
    Search: TTMSFNCToolBarButton;
    OpenDialog1: TOpenDialog;
    FIndEdit: TEdit;
    Replace: TTMSFNCToolBarButton;
    ReplaceEdit: TEdit;
    TMSFNCToolBarFontNamePicker1: TTMSFNCToolBarFontNamePicker;
    TMSFNCFontSizePicker1: TTMSFNCFontSizePicker;
    ThemeComboBox: TTMSFNCComboBox;
    CodeCompletionMemo: TTMSFNCMemo;
    BreakpointsMemo: TTMSFNCMemo;
    TMSFNCToolBar2: TTMSFNCToolBar;
    StartDebug: TTMSFNCToolBarButton;
    StepPrevious: TTMSFNCToolBarButton;
    StepNext: TTMSFNCToolBarButton;
    SkipToBreakPoint: TTMSFNCToolBarButton;
    StopDebugging: TTMSFNCToolBarButton;
    DemoPagesPage3: TTMSFNCPageControlContainer;
    DemoPagesPage4: TTMSFNCPageControlContainer;
    DemoPagesPage5: TTMSFNCPageControlContainer;
    procedure OpenFileClick(Sender: TObject);
    procedure SaveFileClick(Sender: TObject);
    procedure SearchClick(Sender: TObject);
    procedure ReplaceClick(Sender: TObject);
    procedure TMSFNCToolBarFontNamePicker1FontNameSelected(Sender: TObject;
      AFontName: string);
    procedure ThemeComboBoxItemSelected(Sender: TObject; AText: string;
      AItemIndex: Integer);
    procedure FormCreate(Sender: TObject);
    procedure CodeCompletionMemoGetCodeCompletion(Sender: TObject; Token: string;
      CustomCompletionList: TTMSFNCMemoCodeCompletion;
      Position: TTMSFNCMemoCaretPosition);
    procedure BreakpointsMemoGutterClick(Sender: TObject; LineNumber: Integer);
    procedure BreakpointsMemoGutterRightClick(Sender: TObject; LineNumber: Integer);
    procedure StartDebugClick(Sender: TObject);
    procedure StepPreviousClick(Sender: TObject);
    procedure StepNextClick(Sender: TObject);
    procedure SkipToBreakPointClick(Sender: TObject);
    procedure StopDebuggingClick(Sender: TObject);
    procedure TMSFNCFontSizePicker1FontSizeSelected(Sender: TObject;
      AFontSize: Single);
  private
    { Private declarations }
    FActiveLine: Integer;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.FormCreate(Sender: TObject);
begin
  TMSFNCToolBarFontNamePicker1.SelectedFontName := BasicMemo.Font.Name;
  TMSFNCFontSizePicker1.SelectedFontSize := BasicMemo.Font.Size;
  StartDebug.Bitmaps.AddBitmapFromResource('PLAY');
  StopDebugging.Bitmaps.AddBitmapFromResource('STOP');
  StepNext.Bitmaps.AddBitmapFromResource('FORWARD');
  StepPrevious.Bitmaps.AddBitmapFromResource('BACK');
  SkipToBreakPoint.Bitmaps.AddBitmapFromResource('FASTFORWARD');
  OpenFile.Bitmaps.AddBitmapFromResource('OPEN');
  SaveFile.Bitmaps.AddBitmapFromResource('SAVE');
  Search.Bitmaps.AddBitmapFromResource('FIND');
  Replace.Bitmaps.AddBitmapFromResource('REPLACE');
end;

procedure TForm2.ThemeComboBoxItemSelected(Sender: TObject; AText: string;
  AItemIndex: Integer);
begin
  case AITemIndex of
    0: BasicMemo.Theme := TTMSFNCMemoTheme.mtVisualStudio;
    1: BasicMemo.Theme := TTMSFNCMemoTheme.mtVisualStudioDark;
    2: BasicMemo.Theme := TTMSFNCMemoTheme.mtHighContrastDark;
  end;
end;

procedure TForm2.CodeCompletionMemoGetCodeCompletion(Sender: TObject; Token: string;
  CustomCompletionList: TTMSFNCMemoCodeCompletion;
  Position: TTMSFNCMemoCaretPosition);
begin
  CustomCompletionList.Add('console.log');
  CustomCompletionList.Add('IntToStr(');
  CustomCompletionList.Add('StrToInt(');
end;

procedure TForm2.BreakpointsMemoGutterClick(Sender: TObject; LineNumber: Integer);
begin
  BreakPointsMemo.BreakPoints[LineNumber] := not BreakPointsMemo.BreakPoints[LineNumber];
end;

procedure TForm2.BreakpointsMemoGutterRightClick(Sender: TObject;
  LineNumber: Integer);
begin
  BreakPointsMemo.BookMarks[LineNumber] := not BreakPointsMemo.BookMarks[LineNumber];
end;

procedure TForm2.OpenFileClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    BasicMemo.Lines.LoadFromFile(OpenDialog1.Files[0]);
end;

procedure TForm2.SaveFileClick(Sender: TObject);
begin
  if OpenDialog1.Files.Count > 0 then
    BasicMemo.Lines.SaveToFile(OpenDialog1.Files[0])
  else
  begin
    if OpenDialog1.Execute then
      BasicMemo.Lines.SaveToFile(OpenDialog1.Files[0]);
  end;
end;

procedure TForm2.SearchClick(Sender: TObject);
begin
  BasicMemo.Find(FindEdit.Text);
end;

procedure TForm2.ReplaceClick(Sender: TObject);
begin
  BasicMemo.ReplaceNext(FindEdit.Text, ReplaceEdit.Text);
end;

procedure TForm2.StartDebugClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to BreakPointsMemo.Lines.Count -1 do
  begin
    if BreakPointsMemo.BreakPoints[i] = true then
    begin
      FActiveLine := i;
      BreakPointsMemo.LineHighlight[i] := true;
      exit;
    end;
  end;

  TTMSFNCUtils.Message('no breakpoints found');
end;

procedure TForm2.StepPreviousClick(Sender: TObject);
begin
  BreakPointsMemo.LineHighlight[FActiveLine] := false;

  if FActiveLine = 0 then
    FActiveLine := BreakPointsMemo.Lines.Count -1
  else
    dec(FActiveLIne);
  BreakPointsMemo.LineHighlight[FActiveLine] := true;
end;

procedure TForm2.StepNextClick(Sender: TObject);
begin
  BreakPointsMemo.LineHighlight[FActiveLine] := false;

  if FActiveLine = BreakPointsMemo.Lines.Count -1 then
    FActiveLine := 0
  else
    inc(FActiveLIne);

  BreakPointsMemo.LineHighlight[FActiveLine] := true;
end;

procedure TForm2.SkipToBreakPointClick(Sender: TObject);
var
  i: Integer;
begin
  BreakPointsMemo.LineHighlight[FActiveLine] := false;
  inc(FActiveLine);
  for i := FActiveLine to BreakPointsMemo.Lines.Count -1 do
  begin
    if BreakPointsMemo.BreakPoints[i] = true then
    begin
      FActiveLine := i;
      BreakPointsMemo.LineHighlight[i] := true;
      Exit;
    end;
  end;

  i := TTMSFNCUtils.Message('no breakpoints found! Go to beginning of file?', TMsgDlgType.mtInformation, mbYesNo, 0 );

  if i = 6 then
  begin
    StartDebugClick(Self);
  end;

end;

procedure TForm2.StopDebuggingClick(Sender: TObject);
begin
  BreakPointsMemo.LineHighlight[FActiveLine] := false;
end;

procedure TForm2.TMSFNCFontSizePicker1FontSizeSelected(Sender: TObject;
  AFontSize: Single);
begin
  BasicMemo.Font.Size := Trunc(AFontSize);
end;

procedure TForm2.TMSFNCToolBarFontNamePicker1FontNameSelected(Sender: TObject;
  AFontName: string);
begin
  BasicMemo.Font.Name := AFontName;
end;

end.
