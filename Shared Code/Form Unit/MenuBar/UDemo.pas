unit UDemo;

{ TMS FNC UI Pack - MenuBar

  A menu bar for an editor: File, Edit, View and Help with drop-down menus, accelerator keys (Alt+F opens File),
  arrow keys to move between menus and items, Enter or Escape. The drop-downs are built in code from standard
  menu items: the themed FNC popup menu on FMX and VCL, a TMS WEB Core popup menu shown in the bar's own
  themed drop-down on WEB. Clicked items and events appear in the log. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCPopupMenu, VCL.TMSFNCMenuBar, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs, FMX.Menus,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCPopupMenu, FMX.TMSFNCMenuBar, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs, WEBLib.Menus,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton, WEBLib.TMSFNCMenuBar, WEBLib.TMSFNCTheme,
  WEBLib.TMSFNCThemeSelector,
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
    FMenuBar: TTMSFNCMenuBar;
    FDocument: TTMSFNCHTMLText;
    FLog: TTMSFNCHTMLText;
    FDefaultRadio: TTMSFNCRadioButton;
    FAltRadio: TTMSFNCRadioButton;
    FViewEnabledCheck: TTMSFNCCheckBox;
    FFocusCheck: TTMSFNCCheckBox;
    FWordWrapItem: TMenuItem;
    FWordWrap: Boolean;
    function NewMenu(const AItems: array of string): TTMSFNCMenuBarPopupMenu;
    procedure CreateSettings;
    procedure CreateContent;
    procedure ApplySettings;
    procedure SettingChanged(Sender: TObject);
    procedure MenuItemClick(Sender: TObject);
    procedure BarItemClick(Sender: TObject; AItem: TTMSFNCMenuBarItem);
    procedure Log(const AText: string);
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

  FLayout.AddCaption(FSettings, 'Accelerator keys');
  FDefaultRadio := FLayout.AddRadio(FSettings, 'Platform default', 'Accel', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FAltRadio := FLayout.AddRadio(FSettings, 'Alt + letter', 'Accel', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Items');
  FViewEnabledCheck := FLayout.AddCheck(FSettings, 'View menu enabled', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FFocusCheck := FLayout.AddCheck(FSettings, 'Show the keyboard focus', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FLayout.AddText(FSettings, 'Press Alt+F, then the arrow keys, Enter and Escape. A menu item with its own ' +
    'OnClick handles the click itself; the bar''s OnItemClick reports which top item was used.', 100);

  FLayout.AddCaption(FSettings, 'Log');
  FLog := FLayout.AddText(FSettings, '', 160);
end;

function TForm1.NewMenu(const AItems: array of string): TTMSFNCMenuBarPopupMenu;
var
  I: Integer;
  mi: TMenuItem;
begin
  { a '-' is a separator; a trailing '*' marks the item that stays checked }
  Result := TTMSFNCMenuBarPopupMenu.Create(Self);
  for I := 0 to High(AItems) do
  begin
    mi := TMenuItem.Create(Result);
    if AItems[I] = '-' then
      {$IFDEF FMX}mi.Text{$ELSE}mi.Caption{$ENDIF} := '-'
    else
    begin
      {$IFDEF FMX}mi.Text{$ELSE}mi.Caption{$ENDIF} := StringReplace(AItems[I], '*', '', []);
      mi.OnClick := {$IFDEF WEBLIB}@{$ENDIF}MenuItemClick;
      if Pos('*', AItems[I]) > 0 then
      begin
        {$IFDEF FMX}mi.IsChecked{$ELSE}mi.Checked{$ENDIF} := True;
        FWordWrapItem := mi;
      end;
    end;
    {$IFDEF FMX}
    Result.AddObject(mi);
    {$ELSE}
    Result.Items.Add(mi);
    {$ENDIF}
  end;
end;

procedure TForm1.CreateContent;
var
  it: TTMSFNCMenuBarItem;
begin
  FContent := FLayout.AddContentPanel(Self);
  FContent.Fill.Kind := gfkSolid;
  FContent.Stroke.Kind := gskSolid;

  FMenuBar := TTMSFNCMenuBar.Create(Self);
  FMenuBar.Parent := FContent;
  FLayout.Place(FMenuBar, daTop, 32, 1, 1, 1, 0);
  FMenuBar.Items.Clear;
  FMenuBar.Items.AddItem('&File', NewMenu(['&New', '&Open...', '&Save', 'Save &as...', '-', '&Print...', '-', 'E&xit']));
  FMenuBar.Items.AddItem('&Edit', NewMenu(['&Undo', '&Redo', '-', 'Cu&t', '&Copy', '&Paste', '-', 'Select &all']));
  it := FMenuBar.Items.AddItem('&View', NewMenu(['&Word wrap*', '&Line numbers', '-', 'Zoom &in', 'Zoom &out']));
  it.Hint := 'How the document is shown';
  FMenuBar.Items.AddItem('&Help', NewMenu(['&Documentation', '&Support', '-', '&About']));
  FMenuBar.OnItemClick := {$IFDEF WEBLIB}@{$ENDIF}BarItemClick;
  FWordWrap := True;

  FDocument := TTMSFNCHTMLText.Create(Self);
  FDocument.Parent := FContent;
  FLayout.Place(FDocument, daClient, 0, 16, 16, 16, 16);
  FDocument.Fill.Kind := gfkNone;
  FDocument.Stroke.Kind := gskNone;
  FDocument.HorizontalTextAlign := gtaLeading;
  FDocument.VerticalTextAlign := gtaLeading;
  FDocument.WordWrapping := True;
  FDocument.Text := '<b>Untitled document</b><br><br>The menu bar above belongs to this document. Its drop-downs ' +
    'follow the theme: switch to Dark in the header and open a menu. View > Word wrap toggles the wrapping of ' +
    'this text, the other items only report to the log on the left.';
end;

procedure TForm1.ApplySettings;
begin
  if FAltRadio.Checked then
    FMenuBar.AcceleratorKeys := mbakAlt
  else
    FMenuBar.AcceleratorKeys := mbakDefault;
  FMenuBar.Items[2].Enabled := FViewEnabledCheck.Checked;
  FMenuBar.Appearance.ShowFocus := FFocusCheck.Checked;
end;

procedure TForm1.SettingChanged(Sender: TObject);
begin
  ApplySettings;
end;

procedure TForm1.Log(const AText: string);
begin
  FLog.Text := AText + '<br>' + FLog.Text;
end;

procedure TForm1.MenuItemClick(Sender: TObject);
var
  mi: TMenuItem;
begin
  mi := TMenuItem(Sender);
  if mi = FWordWrapItem then
  begin
    FWordWrap := not FWordWrap;
    {$IFDEF FMX}mi.IsChecked{$ELSE}mi.Checked{$ENDIF} := FWordWrap;
    FDocument.WordWrapping := FWordWrap;
  end;
  Log('Item <b>' + StringReplace({$IFDEF FMX}mi.Text{$ELSE}mi.Caption{$ENDIF}, '&', '', [rfReplaceAll]) + '</b>');
end;

procedure TForm1.BarItemClick(Sender: TObject; AItem: TTMSFNCMenuBarItem);
begin
  Log('Menu ' + StringReplace(AItem.Text, '&', '', [rfReplaceAll]) + ' opened');
end;

end.
