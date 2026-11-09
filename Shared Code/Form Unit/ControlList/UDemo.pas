unit UDemo;

{ TMS FNC UI Pack - ControlList

  A control list repeats one template of controls for every item: the controls placed on the list are drawn once
  per item, and OnBeforeDrawItem fills them with the data of that item. The contacts list shows an avatar, a name,
  an e-mail address and a switch per row; the grid layout shows the same template as tiles. The item count is a
  number, not a collection, so a list of thousands of items costs nothing. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCControlList, VCL.TMSFNCAvatar, VCL.TMSFNCSwitch, VCL.TMSFNCSampleData, VCL.TMSFNCTheme,
  VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCControlList, FMX.TMSFNCAvatar, FMX.TMSFNCSwitch, FMX.TMSFNCSampleData, FMX.TMSFNCTheme,
  FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton, WEBLib.TMSFNCControlList, WEBLib.TMSFNCAvatar,
  WEBLib.TMSFNCSwitch, WEBLib.TMSFNCSampleData, WEBLib.TMSFNCTheme, WEBLib.TMSFNCThemeSelector,
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
    FListRadio: TTMSFNCRadioButton;
    FGridRadio: TTMSFNCRadioButton;
    FHoverCheck: TTMSFNCCheckBox;
    FSmoothCheck: TTMSFNCCheckBox;
    FBorderCheck: TTMSFNCCheckBox;
    FStatus: TTMSFNCHTMLText;
    FList: TTMSFNCControlList;
    FAvatar: TTMSFNCAvatar;
    FName: TTMSFNCHTMLText;
    FMail: TTMSFNCHTMLText;
    FSwitch: TTMSFNCSwitch;
    FNames: TArray<string>;
    FActive: array of Boolean;
    procedure CreateSettings;
    procedure CreateContent;
    procedure ApplySettings;
    procedure SettingChanged(Sender: TObject);
    procedure MoreClick(Sender: TObject);
    procedure ItemDraw(Sender: TObject; AGraphics: TTMSFNCGraphics; AIndex: Integer; ARect: TRectF; var AAllow: Boolean; var ADefaultDraw: Boolean);
    procedure ItemClick(Sender: TObject; AIndex: Integer; AControl: TControl);
    procedure ItemIndexChanged(Sender: TObject);
    function PersonName(AIndex: Integer): string;
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
var
  I: Integer;
begin
  FLayout := TDemoLayout.Create(Self);
  FNames := TTMSFNCSampleData.People;
  SetLength(FActive, 500);
  for I := 0 to High(FActive) do
    FActive[I] := I mod 3 <> 1;
  CreateSettings;
  CreateContent;
  ApplySettings;
end;

procedure TForm1.CreateSettings;
begin
  FSettings := FLayout.AddSettingsPanel(Self);

  FLayout.AddCaption(FSettings, 'Layout');
  FListRadio := FLayout.AddRadio(FSettings, 'List: one item per row', 'Layout', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FGridRadio := FLayout.AddRadio(FSettings, 'Grid: tiles that wrap', 'Layout', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Behaviour');
  FHoverCheck := FLayout.AddCheck(FSettings, 'Highlight the item under the mouse', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FSmoothCheck := FLayout.AddCheck(FSettings, 'Smooth scrolling', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FBorderCheck := FLayout.AddCheck(FSettings, 'Border and rounding per item', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FLayout.AddButton(FSettings, 'Add 500 items', {$IFDEF WEBLIB}@{$ENDIF}MoreClick);

  FLayout.AddCaption(FSettings, 'Selection');
  FStatus := FLayout.AddText(FSettings, 'Click an item; the switch toggles its active state.', 80);
end;

function TForm1.PersonName(AIndex: Integer): string;
begin
  Result := FNames[AIndex mod Length(FNames)];
  if AIndex >= Length(FNames) then
    Result := Result + ' ' + IntToStr(AIndex div Length(FNames) + 1);
end;

procedure TForm1.CreateContent;
begin
  FContent := FLayout.AddContentPanel(Self);

  FList := TTMSFNCControlList.Create(Self);
  FList.Parent := FContent;
  FLayout.Place(FList, daClient, 0, 0, 0, 0, 0);
  FList.ItemHeight := 60;
  FList.ItemWidth := 220;

  { the template: controls on the list, positioned inside one item }
  FAvatar := TTMSFNCAvatar.Create(Self);
  FAvatar.Parent := FList;
  FAvatar.Size := avzSmall;
  {$IFDEF FMX}
  FAvatar.Position.Point := PointF(14, 14);
  {$ELSE}
  FAvatar.Left := FLayout.Size(14);
  FAvatar.Top := FLayout.Size(14);
  {$ENDIF}
  FName := TTMSFNCHTMLText.Create(Self);
  FName.Parent := FList;
  FName.SetBounds(FLayout.Size(62), FLayout.Size(9), FLayout.Size(200), FLayout.Size(22));
  FName.Fill.Kind := gfkNone;
  FName.Stroke.Kind := gskNone;
  FName.HorizontalTextAlign := gtaLeading;
  FMail := TTMSFNCHTMLText.Create(Self);
  FMail.Parent := FList;
  FMail.SetBounds(FLayout.Size(62), FLayout.Size(30), FLayout.Size(200), FLayout.Size(20));
  FMail.Fill.Kind := gfkNone;
  FMail.Stroke.Kind := gskNone;
  FMail.HorizontalTextAlign := gtaLeading;
  FMail.TextRole := htrSecondary;
  FSwitch := TTMSFNCSwitch.Create(Self);
  FSwitch.Parent := FList;
  FSwitch.SetBounds(FLayout.Size(300), FLayout.Size(18), FLayout.Size(48), FLayout.Size(24));

  FList.OnBeforeDrawItem := {$IFDEF WEBLIB}@{$ENDIF}ItemDraw;
  FList.OnItemClick := {$IFDEF WEBLIB}@{$ENDIF}ItemClick;
  FList.OnItemIndexChanged := {$IFDEF WEBLIB}@{$ENDIF}ItemIndexChanged;
  FList.ItemCount := Length(FActive);
  FList.ItemIndex := 1;
end;

procedure TForm1.ApplySettings;
begin
  FList.BeginUpdate;
  if FGridRadio.Checked then
  begin
    FList.Layout := cllGrid;
    FList.ItemWidth := 360;
  end
  else
    FList.Layout := cllSingleColumn;
  FList.HoverEnabled := FHoverCheck.Checked;
  FList.SmoothScrolling := FSmoothCheck.Checked;
  if FBorderCheck.Checked then
  begin
    FList.Appearance.ItemStroke.Kind := gskSolid;
    FList.Appearance.ItemMargin := 4;
    FList.Appearance.ItemRounding := 8;
  end
  else
  begin
    FList.Appearance.ItemStroke.Kind := gskNone;
    FList.Appearance.ItemMargin := 0;
    FList.Appearance.ItemRounding := 0;
  end;
  FList.EndUpdate;
end;

procedure TForm1.SettingChanged(Sender: TObject);
begin
  ApplySettings;
end;

procedure TForm1.MoreClick(Sender: TObject);
var
  I, n: Integer;
begin
  n := Length(FActive);
  SetLength(FActive, n + 500);
  for I := n to High(FActive) do
    FActive[I] := I mod 3 <> 1;
  FList.ItemCount := Length(FActive);
  FStatus.Text := IntToStr(FList.ItemCount) + ' items';
end;

procedure TForm1.ItemDraw(Sender: TObject; AGraphics: TTMSFNCGraphics; AIndex: Integer; ARect: TRectF; var AAllow: Boolean; var ADefaultDraw: Boolean);
var
  n: string;
begin
  { the template controls take the values of the item about to be drawn }
  n := PersonName(AIndex);
  FAvatar.Text := n;
  FName.Text := '<b>' + n + '</b>';
  FMail.Text := LowerCase(StringReplace(n, ' ', '.', [rfReplaceAll])) + '@example.com';
  FSwitch.Checked := FActive[AIndex];
end;

procedure TForm1.ItemClick(Sender: TObject; AIndex: Integer; AControl: TControl);
begin
  if AControl = FSwitch then
  begin
    FActive[AIndex] := not FActive[AIndex];
    FList.Invalidate;
  end;
  if FActive[AIndex] then
    FStatus.Text := '<b>' + PersonName(AIndex) + '</b> is active'
  else
    FStatus.Text := '<b>' + PersonName(AIndex) + '</b> is inactive';
end;

procedure TForm1.ItemIndexChanged(Sender: TObject);
begin
  if FList.ItemIndex >= 0 then
    FStatus.Text := 'Item ' + IntToStr(FList.ItemIndex) + ': <b>' + PersonName(FList.ItemIndex) + '</b>';
end;

end.
