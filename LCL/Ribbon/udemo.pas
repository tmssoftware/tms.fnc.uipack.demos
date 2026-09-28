unit UDemo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  LCLTMSFNCRibbon, LCLTMSFNCRichEditor, LCLTMSFNCStatusBar,
  LCLTMSFNCBitmapContainer;

type
  { TForm1 }

  TForm1 = class(TTMSFNCRibbonForm)
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    TMSFNCRibbon1: TTMSFNCRibbon;
    TMSFNCRibbon1BottomContainer: TTMSFNCRibbonBottomContainer;
    TMSFNCRibbon1Caption: TTMSFNCRibbonCaption;
    TMSFNCRibbon1Icon: TTMSFNCRibbonIcon;
    TMSFNCRibbon1PageControl: TTMSFNCRibbonPageControl;
    TMSFNCRibbon1PageControlContainer: TTMSFNCRibbonContainer;
    TMSFNCRibbon1PageControlFileButton: TTMSFNCRibbonFileButton;
    TMSFNCRibbon1PageControlPage0: TTMSFNCRibbonPageControlContainer;
    TMSFNCRibbon1PageControlPage1: TTMSFNCRibbonPageControlContainer;
    TMSFNCRibbon1PageControlPage2: TTMSFNCRibbonPageControlContainer;
    TMSFNCRibbon1QAT: TTMSFNCRibbonQAT;
    TMSFNCRibbon1SystemMenu: TTMSFNCRibbonSystemMenu;
    TMSFNCRibbon1SystemMenuCloseButton: TTMSFNCRibbonSystemMenuToolBarButton;
    TMSFNCRibbon1SystemMenuHelpButton: TTMSFNCRibbonSystemMenuToolBarButton;
    TMSFNCRibbon1SystemMenuMaximizeButton: TTMSFNCRibbonSystemMenuToolBarButton;
    TMSFNCRibbon1SystemMenuMinimizeButton: TTMSFNCRibbonSystemMenuToolBarButton;
    TMSFNCRibbon1Wrapper: TTMSFNCRibbonToolBarWrapper;
    TMSFNCRichEditor1: TTMSFNCRichEditor;
    TMSFNCStatusBar1: TTMSFNCStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure TMSFNCRichEditor1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TMSFNCRichEditor1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TMSFNCRichEditor1SelectionChanged(Sender: TObject);
  private
    { Private declarations }
    rb: TTMSFNCRibbon;
    re: TTMSFNCRichEditor;
    tbo: TTMSFNCRibbonToolBar;
    po: TTMSFNCRibbonToolBarButton;
    sb: TTMSFNCStatusBar;
    txtarr: TStringList;
    function WordCount(AText: string): Integer;
  public
    { Public declarations }
    procedure DoItemSelected(Sender: TObject; AItemIndex: Integer);
    procedure DoFileButtonClick(Sender: TObject);
    procedure DoButtonClick(Sender: TObject);
    procedure DoMoreCommandsClick(Sender: TObject);
    procedure DoBoldClick(Sender: TObject);
    procedure DoUndoClick(Sender: TObject);
    procedure DoRedoClick(Sender: TObject);
    procedure DoItalicClick(Sender: TObject);
    procedure DoUnderlineClick(Sender: TObject);
    procedure DoFontNameSelected(Sender: TObject; AFontName: string);
    procedure DoFontNameClick(Sender: TObject);
    procedure DoFontSizeSelected(Sender: TObject; AFontSize: Single);
    procedure DoFontSizeClick(Sender: TObject);
    procedure DoAlignLeftClick(Sender: TObject);
    procedure DoAlignCenterClick(Sender: TObject);
    procedure DoAlignRightClick(Sender: TObject);
    procedure DoCopyClick(Sender: TObject);
    procedure DoCutClick(Sender: TObject);
    procedure DoPasteClick(Sender: TObject);
    procedure DoAppliedTheme(Sender: TObject; AObject: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses
  LCLTMSFNCUtils, LCLTMSFNCGraphicsTypes,
  LCLTMSFNCToolBar, LCLTMSFNCCustomControl,
  LCLTMSFNCScrollControl;

procedure TForm1.DoAlignCenterClick(Sender: TObject);
begin
  re.SetSelectionAttribute(TAlignment.taCenter);
end;

procedure TForm1.DoAlignLeftClick(Sender: TObject);
begin
  re.SetSelectionAttribute(TAlignment.taLeftJustify);
end;

procedure TForm1.DoAlignRightClick(Sender: TObject);
begin
  re.SetSelectionAttribute(TAlignment.taRightJustify);
end;

procedure TForm1.DoAppliedTheme(Sender: TObject; AObject: TObject);
begin
  if Assigned(tbo) then
    tbo.SetTheme(rb.Theme, rb.CustomThemeColor);
end;

procedure TForm1.DoBoldClick(Sender: TObject);
begin
  re.SetSelectionBold(True);
end;

procedure TForm1.DoButtonClick(Sender: TObject);
begin
  if Sender is TTMSFNCRibbonToolBarButton then
    TTMSFNCUtils.Message((Sender as TTMSFNCRibbonToolBarButton).Text + ' Clicked !');
end;

procedure TForm1.DoCopyClick(Sender: TObject);
begin
  re.CopyToClipboard;
end;

procedure TForm1.DoCutClick(Sender: TObject);
begin
  re.CutToClipboard;
end;

procedure TForm1.DoFileButtonClick(Sender: TObject);
begin
  TTMSFNCUtils.Message('File Button Clicked !');
end;

procedure TForm1.DoFontNameClick(Sender: TObject);
begin
  re.SetSelectionFontName((Sender as TTMSFNCRibbonToolBarFontNamePicker).SelectedFontName);
end;

procedure TForm1.DoFontNameSelected(Sender: TObject; AFontName: string);
begin
  re.SetSelectionFontName(AFontName);
end;

procedure TForm1.DoFontSizeClick(Sender: TObject);
begin
  re.SetSelectionFontSize(Round((Sender as TTMSFNCRibbonToolBarFontSizePicker).SelectedFontSize));
end;

procedure TForm1.DoFontSizeSelected(Sender: TObject; AFontSize: Single);
begin
  re.SetSelectionFontSize(Round(AFontSize));
end;

procedure TForm1.DoItalicClick(Sender: TObject);
begin
  re.SetSelectionItalic(True);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  s: string;
  tb: TTMSFNCRibbonToolBar;
  btn: TTMSFNCRibbonToolBarButton;
  fnp: TTMSFNCRibbonToolBarFontNamePicker;
  fsp: TTMSFNCRibbonToolBarFontSizePicker;
  ip: TTMSFNCRibbonToolBarItemPicker;
  g: TTMSFNCRibbonGroup;
begin
  s := 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s'+
  'standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a typ'+
  'e specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essen'+
  'tially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, a'+
  'nd more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.';

  rb := TMSFNCRibbon1;
  rb.Parent := Self;
  rb.Rebuild;
  rb.PageControl.Collapsable := True;
  rb.PageControl.Pages.Clear;
  rb.PageControl.AddPage('Home').ShortCutHint := 'H';
  rb.PageControl.AddPage('Insert').ShortCutHint := 'I';
  rb.PageControl.AddPage('Export').ShortCutHint := 'E';

  tb := rb.PageControl.PageContainers[0].AddToolBar('Clipboard');
  tb.ShortCutHint := 'C';
  TTMSFNCUtils.SetFontSize(tb.Font, 11);
  tb.OnAppliedTheme := @DoAppliedTheme;

  btn := tb.AddButton;
  btn.Text := 'Paste';
  btn.Layout := bblLarge;
  btn.MinimumLayout := bblLarge;
  btn.DropDownKind := ddkDropDownButton;
  btn.DropDownPosition := ddpBottom;
  btn.BitmapContainer := TMSFNCBitmapContainer1;
  btn.Bitmaps.AddBitmapName('Paste.png');
  btn.LargeLayoutBitmaps.AddBitmapName('Paste_LARGE.png');
  btn.OnClick := @DoPasteClick;
  btn.AutoBitmapSize := True;
  btn.LargeLayoutAutoBitmapSize := False;
  btn.ShortCutHint := 'CP';

  tbo := TTMSFNCRibbonToolBar.Create(Self);
  TTMSFNCUtils.SetFontSize(tbo.Font, 11);
  tbo.Text := 'Paste Options';
  tbo.OptionsMenu.ShowButton := False;
  tbo.Appearance.DragGrip := False;
  tbo.SetControlMargins(1, 1, 1, 1);
  tbo.AutoSize := False;
  tbo.AutoAlign := False;
  tbo.Width := 115;
  tbo.Height := 85;
  btn.DropDownControl := tbo;
  po := btn;

  btn := tbo.AddButton;
  btn.BitmapContainer := TMSFNCBitmapContainer1;
  btn.ControlAlignment := caTop;
  btn.Text := 'Paste Normal';
  btn.HorizontalTextAlign := gtaLeading;
  btn.Height := 25;
  btn.SetControlMargins(3, 3, 3, 3);
  btn.Bitmaps.AddBitmapName('Paste.png');
  btn.OnClick := @DoPasteClick;

  btn := tbo.AddButton;
  btn.BitmapContainer := TMSFNCBitmapContainer1;
  btn.ControlAlignment := caTop;
  btn.Text := 'Paste Special';
  btn.HorizontalTextAlign := gtaLeading;
  btn.Height := 25;
  btn.SetControlMargins(3, 3, 3, 3);
  btn.Bitmaps.AddBitmapName('Paste.png');
  btn.OnClick := @DoPasteClick;

  btn := tb.AddButton;
  btn.Text := 'Cut';
  btn.Layout := bblLabel;
  btn.MaximumLayout := bblLabel;
  btn.BitmapContainer := TMSFNCBitmapContainer1;
  btn.Bitmaps.AddBitmapName('Cut.png');
  btn.LargeLayoutBitmaps.AddBitmapName('Cut_LARGE.png');
  btn.OnClick := @DoCutClick;
  btn.AutoBitmapSize := True;
  btn.LargeLayoutAutoBitmapSize := True;
  btn.ShortCutHint := 'C1';

  btn := tb.AddButton;
  btn.Text := 'Copy';
  btn.Layout := bblLabel;
  btn.MaximumLayout := bblLabel;
  btn.BitmapContainer := TMSFNCBitmapContainer1;
  btn.Bitmaps.AddBitmapName('Copy.png');
  btn.LargeLayoutBitmaps.AddBitmapName('Copy_LARGE.png');
  btn.OnClick := @DoCopyClick;
  btn.AutoBitmapSize := True;
  btn.LargeLayoutAutoBitmapSize := True;
  btn.ShortCutHint := 'C2';

  btn := tb.AddButton;
  btn.Text := 'Paste';
  btn.Layout := bblLabel;
  btn.MaximumLayout := bblLabel;
  btn.BitmapContainer := TMSFNCBitmapContainer1;
  btn.Bitmaps.AddBitmapName('Paste.png');
  btn.LargeLayoutBitmaps.AddBitmapName('Paste_LARGE.png');
  btn.OnClick := @DoPasteClick;
  btn.AutoBitmapSize := True;
  btn.LargeLayoutAutoBitmapSize := True;
  btn.ShortCutHint := 'C3';

  tb := rb.PageControl.PageContainers[0].AddToolBar('Alignment');
  tb.ShortCutHint := 'A';
  TTMSFNCUtils.SetFontSize(tb.Font, 11);

  btn := tb.AddButton;
  btn.Text := 'Align Left';
  btn.Layout := bblLabel;
  btn.MaximumLayout := bblLabel;
  btn.BitmapContainer := TMSFNCBitmapContainer1;
  btn.Bitmaps.AddBitmapName('Align-Left.png');
  btn.LargeLayoutBitmaps.AddBitmapName('Align-Left_LARGE.png');
  btn.OnClick := @DoAlignLeftClick;
  btn.AutoBitmapSize := True;
  btn.LargeLayoutAutoBitmapSize := True;
  btn.ShortCutHint := 'AL';

  btn := tb.AddButton;
  btn.Text := 'Align Center';
  btn.Layout := bblLabel;
  btn.MaximumLayout := bblLabel;
  btn.BitmapContainer := TMSFNCBitmapContainer1;
  btn.Bitmaps.AddBitmapName('Align-Center.png');
  btn.LargeLayoutBitmaps.AddBitmapName('Align-Center_LARGE.png');
  btn.OnClick := @DoAlignCenterClick;
  btn.AutoBitmapSize := True;
  btn.LargeLayoutAutoBitmapSize := True;
  btn.ShortCutHint := 'AC';

  btn := tb.AddButton;
  btn.Text := 'Align Right';
  btn.Layout := bblLabel;
  btn.MaximumLayout := bblLabel;
  btn.BitmapContainer := TMSFNCBitmapContainer1;
  btn.Bitmaps.AddBitmapName('Align-Right.png');
  btn.LargeLayoutBitmaps.AddBitmapName('Align-Right_LARGE.png');
  btn.OnClick := @DoAlignRightClick;
  btn.AutoBitmapSize := True;
  btn.LargeLayoutAutoBitmapSize := True;
  btn.ShortCutHint := 'AR';

  tb := rb.PageControl.PageContainers[0].AddToolBar('Font');
  tb.ShortCutHint := 'F';
  TTMSFNCUtils.SetFontSize(tb.Font, 11);

  fnp := tb.AddFontNamePicker;
  fnp.OnFontNameSelected := @DoFontNameSelected;
  fnp.OnClick := @DoFontNameClick;
  fnp.SelectedItemIndex := 0;
  fnp.Width := fnp.Width + 20;

  fsp := tb.AddFontSizePicker;
  fsp.OnFontSizeSelected := @DoFontSizeSelected;
  fsp.OnClick := @DoFontSizeClick;
  fsp.SelectedItemIndex := 0;
  fsp.Width := 40;
  fsp.DropDownWidth := 50;
  fsp.LastElement := True;

  btn := tb.AddButton;
  btn.BitmapContainer := TMSFNCBitmapContainer1;
  btn.Bitmaps.AddBitmapName('Bold.png');
  btn.Width := 30;
  btn.Height := 30;
  btn.OnClick := @DoBoldClick;
  btn.ShortCutHint := 'B';

  btn := tb.AddButton;
  btn.BitmapContainer := TMSFNCBitmapContainer1;
  btn.Bitmaps.AddBitmapName('Italic.png');
  btn.Width := 30;
  btn.Height := 30;
  btn.OnClick := @DoItalicClick;
  btn.ShortCutHint := 'I';

  btn := tb.AddButton;
  btn.BitmapContainer := TMSFNCBitmapContainer1;
  btn.Bitmaps.AddBitmapName('Underline.png');
  btn.Width := 30;
  btn.Height := 30;
  btn.OnClick := @DoUnderlineClick;
  btn.ShortCutHint := 'U';

  tb := rb.PageControl.PageContainers[0].AddToolBar('State');
  tb.ShortCutHint := 'S';
  TTMSFNCUtils.SetFontSize(tb.Font, 11);

  btn := tb.AddButton;
  btn.Text := 'Undo';
  btn.Layout := bblLarge;
  btn.BitmapContainer := TMSFNCBitmapContainer1;
  btn.Bitmaps.AddBitmapName('Undo.png');
  btn.LargeLayoutBitmaps.AddBitmapName('Undo_LARGE.png');
  btn.OnClick := @DoUndoClick;
  btn.AutoBitmapSize := True;
  btn.LargeLayoutAutoBitmapSize := True;
  btn.ShortCutHint := 'UD';

  btn := tb.AddButton;
  btn.Text := 'Redo';
  btn.Layout := bblLarge;
  btn.BitmapContainer := TMSFNCBitmapContainer1;
  btn.Bitmaps.AddBitmapName('Redo.png');
  btn.LargeLayoutBitmaps.AddBitmapName('Redo_LARGE.png');
  btn.OnClick := @DoRedoClick;
  btn.AutoBitmapSize := True;
  btn.LargeLayoutAutoBitmapSize := True;
  btn.ShortCutHint := 'RD';

  tb := rb.PageControl.PageContainers[0].AddToolBar('Insert');
  tb.ShortCutHint := 'I';
  TTMSFNCUtils.SetFontSize(tb.Font, 11);

  btn := tb.AddButton;
  btn.Text := 'Image';
  btn.Layout := bblLarge;
  btn.BitmapContainer := TMSFNCBitmapContainer1;
  btn.Bitmaps.AddBitmapName('Image.png');
  btn.LargeLayoutBitmaps.AddBitmapName('Image_LARGE.png');
  btn.OnClick := @DoButtonClick;
  btn.AutoBitmapSize := True;
  btn.LargeLayoutAutoBitmapSize := True;
  btn.ShortCutHint := 'I';

  btn := tb.AddButton;
  btn.Text := 'Link';
  btn.Layout := bblLarge;
  btn.BitmapContainer := TMSFNCBitmapContainer1;
  btn.Bitmaps.AddBitmapName('Internet Link.png');
  btn.LargeLayoutBitmaps.AddBitmapName('Internet Link_LARGE.png');
  btn.OnClick := @DoButtonClick;
  btn.AutoBitmapSize := True;
  btn.LargeLayoutAutoBitmapSize := True;
  btn.ShortCutHint := 'I';


  rb.PageControl.FileButton.OnClick := @DoFileButtonClick;

  rb.QAT.OnOptionsMenuMoreCommands := @DoMoreCommandsClick;

  ip := rb.QAT.AddItemPicker;
  ip.Items.Add('Light Blue');
  ip.Items.Add('Blue');
  ip.Items.Add('Crimson');
  ip.Items.Add('Green');
  ip.Items.Add('Sea Green');
  ip.Items.Add('Orange');
  ip.Items.Add('Purple');
  ip.Items.Add('Dark Gray');
  ip.Items.Add('Black');
  ip.Items.Add('White');
  ip.Items.Add('Custom');

  ip.OnItemSelected := @DoItemSelected;
  ip.SelectedItemIndex := 0;
  ip.DropDownKind := ddkDropDown;

  re := TMSFNCRichEditor1;
  re.Parent := Self;
  re.Align := alClient;
  re.BorderStyle := bsNone;
  re.AddText('Lorem Ipsum');
  re.SelectAll;
  re.SetSelectionFontSize(20);
  re.ClearSelection;
  re.AddLineBreak;
  re.AddLineBreak;
  re.AddText(s);
  re.AddLineBreak;
  re.AddLineBreak;
  re.AddText(s);

  rb.QATMode := rqmBelowRibbon;

  g := rb.Groups.Add;
  g.Text := 'Tools';
  g.StartPageIndex := 1;
  g.EndPageIndex := 2;

  rb.ApplyTheme;

  sb := TMSFNCStatusBar1;
  sb.Parent := Self;
  sb.Panels.Items[0].Text := '<b>Selected text:</b>';
  sb.Panels.Items[1].Style := spsImage;
  sb.Panels.Items[1].ImageIndex := 42;
  sb.Panels.Items[1].Text := 'Word count: ' + IntToStr(WordCount(re.Text));
  sb.Panels.Items[2].Style := spsTime;
  sb.Panels.Items[2].Alignment := taRightJustify;

  BorderIcons := [TBorderIcon.biMaximize, TBorderIcon.biMinimize, TBorderIcon.biSystemMenu];
end;

procedure TForm1.TMSFNCRichEditor1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  sb.Panels.Items[1].Text := 'Word count: ' + IntToStr(WordCount(re.Text));
end;

procedure TForm1.TMSFNCRichEditor1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  sb.Panels.Items[0].Text := '<b>Selected text: </b>' + re.SelectedText;
end;

procedure TForm1.TMSFNCRichEditor1SelectionChanged(Sender: TObject);
begin
  sb.Panels.Items[0].Text := '<b>Selected text: </b>' + re.SelectedText;
end;

function TForm1.WordCount(AText: string): Integer;
begin
  txtarr := TStringList.Create;
  try
    txtarr.Delimiter := ' ';
    txtarr.DelimitedText := AText;
    Result := txtarr.Count;
  finally
    txtarr.Free;
  end;
end;

procedure TForm1.DoItemSelected(Sender: TObject; AItemIndex: Integer);
begin
  rb.Theme := TTMSFNCRibbonTheme(AItemIndex);
end;

procedure TForm1.DoMoreCommandsClick(Sender: TObject);
begin
  TTMSFNCUtils.Message('More Commands Clicked !');
end;

procedure TForm1.DoPasteClick(Sender: TObject);
begin
  re.PasteFromClipboard;
  if Assigned(po) then
    po.CloseDropDown;
end;

procedure TForm1.DoRedoClick(Sender: TObject);
begin
  re.Redo;
end;

procedure TForm1.DoUnderlineClick(Sender: TObject);
begin
  re.SetSelectionUnderline(True);
end;

procedure TForm1.DoUndoClick(Sender: TObject);
begin
  re.Undo;
end;

end.

