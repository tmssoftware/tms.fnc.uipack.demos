unit UDemo;

{ TMS FNC UI Pack - ToolBar Family

  Tool bars in a dock panel above a rich editor: the ready-made font, paragraph, clipboard, insert and file
  tool bars that drive the editor by themselves, and a tool bar built in code with buttons, separators and the
  item, colour, font name, font size and bitmap pickers. A tool bar pop-up shows a floating row of buttons
  next to a control on request. Drag a tool bar by its grip to another place in the dock. The rich editor is
  not available on WEB: this demo is FMX and VCL. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCPopup, VCL.TMSFNCToolBar, VCL.TMSFNCToolBars, VCL.TMSFNCToolBarPopup, VCL.TMSFNCRichEditorBase,
  VCL.TMSFNCRichEditor, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCPopup, FMX.TMSFNCToolBar, FMX.TMSFNCToolBars, FMX.TMSFNCToolBarPopup, FMX.TMSFNCRichEditorBase,
  FMX.TMSFNCRichEditor, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
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
    FFontCheck: TTMSFNCCheckBox;
    FParagraphCheck: TTMSFNCCheckBox;
    FClipboardCheck: TTMSFNCCheckBox;
    FInsertCheck: TTMSFNCCheckBox;
    FFileCheck: TTMSFNCCheckBox;
    FTextCheck: TTMSFNCCheckBox;
    FStatus: TTMSFNCHTMLText;
    FDock: TTMSFNCDockPanel;
    FEditor: TTMSFNCRichEditor;
    FFontBar: TTMSFNCFontToolBar;
    FParagraphBar: TTMSFNCParagraphToolBar;
    FClipboardBar: TTMSFNCClipboardToolBar;
    FInsertBar: TTMSFNCInsertToolBar;
    FFileBar: TTMSFNCFileIOToolBar;
    FCustomBar: TTMSFNCToolBar;
    FZoomPicker: TTMSFNCToolBarItemPicker;
    FColorPicker: TTMSFNCToolBarColorPicker;
    FPopup: TTMSFNCToolBarPopup;
    FPopupTarget: TTMSFNCButton;
    procedure CreateSettings;
    procedure CreateContent;
    procedure ApplySettings;
    procedure SettingChanged(Sender: TObject);
    procedure ButtonClick(Sender: TObject);
    procedure ZoomChanged(Sender: TObject; AItemIndex: Integer);
    procedure ColorChanged(Sender: TObject; AColor: TTMSFNCGraphicsColor);
    procedure PopupTargetClick(Sender: TObject);
    procedure PopupButtonClick(Sender: TObject; AButton: TTMSFNCToolBarPopupButton);
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
  CreateSettings;
  CreateContent;
  ApplySettings;
end;

procedure TForm1.CreateSettings;
begin
  FSettings := FLayout.AddSettingsPanel(Self);

  FLayout.AddCaption(FSettings, 'Look');
  FClassicRadio := FLayout.AddRadio(FSettings, 'Classic', 'Look', False, SettingChanged);
  FFluentRadio := FLayout.AddRadio(FSettings, 'Fluent', 'Look', True, SettingChanged);

  FLayout.AddCaption(FSettings, 'Editor tool bars');
  FFontCheck := FLayout.AddCheck(FSettings, 'Font', True, SettingChanged);
  FParagraphCheck := FLayout.AddCheck(FSettings, 'Paragraph', True, SettingChanged);
  FClipboardCheck := FLayout.AddCheck(FSettings, 'Clipboard', True, SettingChanged);
  FInsertCheck := FLayout.AddCheck(FSettings, 'Insert', False, SettingChanged);
  FFileCheck := FLayout.AddCheck(FSettings, 'File', False, SettingChanged);

  FLayout.AddCaption(FSettings, 'Buttons');
  FTextCheck := FLayout.AddCheck(FSettings, 'Title of the View tool bar', False, SettingChanged);
  FLayout.AddText(FSettings, 'A tool bar that does not fit shows an overflow button; a dragged tool bar docks ' +
    'where it is dropped.', 64);

  FLayout.AddCaption(FSettings, 'Last action');
  FStatus := FLayout.AddText(FSettings, 'Select text in the editor and use a tool bar.', 60);
end;

procedure TForm1.CreateContent;
var
  b: TTMSFNCToolBarButton;
  fn: TTMSFNCToolBarFontNamePicker;
  fs: TTMSFNCToolBarFontSizePicker;
  bp: TTMSFNCToolBarBitmapPicker;
  pb: TTMSFNCToolBarPopupButton;
  bar: TTMSFNCPanel;
begin
  FContent := FLayout.AddContentPanel(Self);

  { the editor the tool bars work on }
  FEditor := TTMSFNCRichEditor.Create(Self);
  FEditor.Parent := FContent;
  FLayout.Place(FEditor, daClient, 0, 0, 8, 0, 0);
  FEditor.Text := 'The tool bars above belong to this editor. Select a word and make it bold, change its font ' +
    'or colour, align the paragraph or paste from the clipboard: each tool bar reflects the selection.' +
    #13#10#13#10 + 'The last tool bar is built in code: a zoom picker, a highlight colour and a bitmap picker ' +
    'report to the status on the left.';

  { the dock: tool bars dragged by their grip rearrange inside it }
  FDock := TTMSFNCDockPanel.Create(Self);
  FDock.Parent := FContent;
  FLayout.Place(FDock, daTop, 44, 0, 0, 0, 0);
  FFontBar := TTMSFNCFontToolBar.Create(Self);
  FFontBar.Parent := FDock;
  FFontBar.Control := FEditor;
  FParagraphBar := TTMSFNCParagraphToolBar.Create(Self);
  FParagraphBar.Parent := FDock;
  FParagraphBar.Control := FEditor;
  FClipboardBar := TTMSFNCClipboardToolBar.Create(Self);
  FClipboardBar.Parent := FDock;
  FClipboardBar.Control := FEditor;
  FInsertBar := TTMSFNCInsertToolBar.Create(Self);
  FInsertBar.Parent := FDock;
  FInsertBar.Control := FEditor;
  FFileBar := TTMSFNCFileIOToolBar.Create(Self);
  FFileBar.Parent := FDock;
  FFileBar.Control := FEditor;

  { a tool bar built in code: buttons, separators and every picker }
  FCustomBar := TTMSFNCToolBar.Create(Self);
  FCustomBar.Parent := FDock;
  b := FCustomBar.AddButton(-1, -1, '', '', 'Zoom in');
  b.OnClick := ButtonClick;
  b := FCustomBar.AddButton(-1, -1, '', '', 'Zoom out');
  b.OnClick := ButtonClick;
  FCustomBar.AddSeparator;
  FZoomPicker := FCustomBar.AddItemPicker;
  FZoomPicker.Items.CommaText := '50%,75%,100%,125%,150%,200%';
  FZoomPicker.SelectedItemIndex := 2;
  FZoomPicker.OnItemSelected := ZoomChanged;
  FCustomBar.AddSeparator;
  fn := FCustomBar.AddFontNamePicker;
  fn.SelectedFontName := 'Segoe UI';
  fs := FCustomBar.AddFontSizePicker;
  fs.SelectedFontSize := 11;
  FCustomBar.AddSeparator;
  FColorPicker := FCustomBar.AddColorPicker;
  FColorPicker.Text := 'Highlight';
  FColorPicker.OnColorSelected := ColorChanged;
  bp := FCustomBar.AddBitmapPicker;
  bp.Text := 'Picture';

  { a pop-up tool bar next to a button }
  bar := FLayout.AddPanel(FContent, daBottom, 48, 0, 8, 0, 0);
  bar.Fill.Kind := gfkNone;
  bar.Stroke.Kind := gskNone;
  FPopupTarget := TTMSFNCButton.Create(Self);
  FPopupTarget.Parent := bar;
  FLayout.Place(FPopupTarget, daLeft, 200, 0, 8, 8, 8);
  FPopupTarget.Text := 'Show the pop-up tool bar';
  FPopupTarget.OnClick := PopupTargetClick;
  FPopup := TTMSFNCToolBarPopup.Create(Self);
  FPopup.PlacementControl := FPopupTarget;
  FPopup.Placement := ppTop;
  pb := FPopup.Buttons.Add;
  pb.Button.Text := 'Reply';
  pb := FPopup.Buttons.Add;
  pb.Button.Text := 'Forward';
  pb := FPopup.Buttons.Add;
  pb.Button.Text := 'Archive';
  pb := FPopup.Buttons.Add;
  pb.Button.Text := 'Delete';
  FPopup.OnButtonClick := PopupButtonClick;
end;

procedure TForm1.ApplySettings;
var
  lk: TTMSFNCToolBarLook;
begin
  if FFluentRadio.Checked then
    lk := tlbFluent
  else
    lk := tlbClassic;
  FDock.BeginUpdate;
  FFontBar.Look := lk;
  FParagraphBar.Look := lk;
  FClipboardBar.Look := lk;
  FInsertBar.Look := lk;
  FFileBar.Look := lk;
  FCustomBar.Look := lk;
  if FTextCheck.Checked then
    FCustomBar.Text := 'View'
  else
    FCustomBar.Text := '';
  FFontBar.Visible := FFontCheck.Checked;
  FParagraphBar.Visible := FParagraphCheck.Checked;
  FClipboardBar.Visible := FClipboardCheck.Checked;
  FInsertBar.Visible := FInsertCheck.Checked;
  FFileBar.Visible := FFileCheck.Checked;
  FDock.EndUpdate;
end;

procedure TForm1.SettingChanged(Sender: TObject);
begin
  ApplySettings;
end;

procedure TForm1.ButtonClick(Sender: TObject);
begin
  FStatus.Text := 'Button <b>' + TTMSFNCToolBarButton(Sender).Text + '</b> clicked.';
end;

procedure TForm1.ZoomChanged(Sender: TObject; AItemIndex: Integer);
begin
  if AItemIndex >= 0 then
    FStatus.Text := 'Zoom <b>' + FZoomPicker.Items[AItemIndex] + '</b> picked.';
end;

procedure TForm1.ColorChanged(Sender: TObject; AColor: TTMSFNCGraphicsColor);
begin
  FStatus.Text := 'Highlight colour <b>' + TTMSFNCGraphics.ColorToHTML(AColor) + '</b> picked.';
end;

procedure TForm1.PopupTargetClick(Sender: TObject);
begin
  FPopup.Activate;
end;

procedure TForm1.PopupButtonClick(Sender: TObject; AButton: TTMSFNCToolBarPopupButton);
begin
  FStatus.Text := 'Pop-up button <b>' + AButton.Button.Text + '</b> clicked.';
end;

end.
