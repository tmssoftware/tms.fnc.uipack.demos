unit frmMain;

interface

uses
  System.SysUtils, System.Classes, JS, Web, WEBLib.Graphics, WEBLib.Controls,
  WEBLib.Forms, WEBLib.Dialogs, WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils,
  WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes, Vcl.StdCtrls, WEBLib.StdCtrls,
  WEBLib.TMSFNCToolBar, WEBLib.WebCtrls, WEBLib.TMSFNCWebBrowser,
  WEBLib.TMSFNCCustomWEBControl, WEBLib.TMSFNCMemo, WEBLib.TMSFNCPageControl,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCTabSet, WEBLib.TMSFNCComboBox,
  WEBLib.TMSFNCFontSizePicker, WEBLib.TMSFNCCustomPicker, WEBLib.TMSFNCFontNamePicker, WEBLib.TMSFNCCustomTreeview,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes,
  VCL.TMSFNCComboBox, VCL.TMSFNCCustomPicker, VCL.TMSFNCFontSizePicker,
  VCL.TMSFNCToolBar, VCL.TMSFNCWebBrowser, VCL.TMSFNCCustomWEBControl,
  VCL.TMSFNCMemo, VCL.TMSFNCPageControl, Vcl.Controls, VCL.TMSFNCCustomControl,
  VCL.TMSFNCTabSet;

type
  TForm1 = class(TWebForm)
    procedure WebFormCreate(Sender: TObject);
    DemoPages: TTMSFNCPageControl;
    TMSFNCToolBar1: TTMSFNCToolBar;
    BasicMemo: TTMSFNCMemo;
    Search: TTMSFNCToolBarButton;
    FIndEdit: TWebEdit;
    Replace: TTMSFNCToolBarButton;
    ReplaceEdit: TWebEdit;
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
    procedure SearchClick(Sender: TObject);
    procedure ReplaceClick(Sender: TObject);
    procedure TMSFNCToolBarFontNamePicker1FontNameSelected(Sender: TObject;
      AFontName: string);
    procedure ThemeComboBoxItemSelected(Sender: TObject; AText: string;
      AItemIndex: Integer);
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
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.ThemeComboBoxItemSelected(Sender: TObject; AText: string;
  AItemIndex: Integer);
begin
  case AITemIndex of
    0: BasicMemo.Theme := TTMSFNCMemoTheme.mtVisualStudio;
    1: BasicMemo.Theme := TTMSFNCMemoTheme.mtVisualStudioDark;
    2: BasicMemo.Theme := TTMSFNCMemoTheme.mtHighContrastDark;
  end;
end;

procedure TForm1.BreakpointsMemoGutterClick(Sender: TObject; LineNumber: Integer);
begin
  BreakPointsMemo.BreakPoints[LineNumber] := not BreakPointsMemo.BreakPoints[LineNumber];
end;

procedure TForm1.BreakpointsMemoGutterRightClick(Sender: TObject;
  LineNumber: Integer);
begin
  BreakPointsMemo.BookMarks[LineNumber] := not BreakPointsMemo.BookMarks[LineNumber];
end;

procedure TForm1.CodeCompletionMemoGetCodeCompletion(Sender: TObject;
  Token: string; CustomCompletionList: TTMSFNCMemoCodeCompletion;
  Position: TTMSFNCMemoCaretPosition);
begin
  CustomCompletionList.Add('console.log');
  CustomCompletionList.Add('IntToStr(');
  CustomCompletionList.Add('StrToInt(');
end;

procedure TForm1.SearchClick(Sender: TObject);
begin
  BasicMemo.Find(FindEdit.Text);
end;

procedure TForm1.ReplaceClick(Sender: TObject);
begin
  BasicMemo.Replace(FindEdit.Text, ReplaceEdit.Text);
end;

procedure TForm1.StartDebugClick(Sender: TObject);
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

procedure TForm1.StepPreviousClick(Sender: TObject);
begin
  BreakPointsMemo.LineHighlight[FActiveLine] := false;

  if FActiveLine = 0 then
    FActiveLine := BreakPointsMemo.Lines.Count -1
  else
    dec(FActiveLIne);
  BreakPointsMemo.LineHighlight[FActiveLine] := true;
end;

procedure TForm1.StepNextClick(Sender: TObject);
begin
  BreakPointsMemo.LineHighlight[FActiveLine] := false;

  if FActiveLine = BreakPointsMemo.Lines.Count -1 then
    FActiveLine := 0
  else
    inc(FActiveLIne);

  BreakPointsMemo.LineHighlight[FActiveLine] := true;
end;

procedure TForm1.SkipToBreakPointClick(Sender: TObject);
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

  i := TTMSFNCUtils.Message('no breakpoints found! Go to beginning of file?', TMsgDlgType.mtInformation, [mbYes, mbNo], 0 );

  if i = 6 then
  begin
    StartDebugClick(Self);
  end;

end;

procedure TForm1.StopDebuggingClick(Sender: TObject);
begin
  BreakPointsMemo.LineHighlight[FActiveLine] := false;
end;

procedure TForm1.TMSFNCFontSizePicker1FontSizeSelected(Sender: TObject;
  AFontSize: Single);
begin
  BasicMemo.Font.Size := Trunc(AFontSize);
end;

procedure TForm1.TMSFNCToolBarFontNamePicker1FontNameSelected(Sender: TObject;
  AFontName: string);
begin
  BasicMemo.Font.Name := AFontName;
end;

procedure TForm1.WebFormCreate(Sender: TObject);
begin
  TMSFNCToolBarFontNamePicker1.SelectedFontName := BasicMemo.Font.Name;
  TMSFNCFontSizePicker1.SelectedFontSize := BasicMemo.Font.Size;
end;

end.
