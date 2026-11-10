unit UDemo;

{ TMS FNC UI Pack - Skeleton

  Placeholders shown while content loads: the text, circle, rectangle, card and list presets and a custom layout of
  shapes, animated with a shimmer or a pulse. The "Content" switch replaces the loading card by the loaded card, as
  an application does when its data arrives. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCStackPanel, VCL.TMSFNCCardPanel, VCL.TMSFNCSkeleton, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCStackPanel, FMX.TMSFNCCardPanel, FMX.TMSFNCSkeleton, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton, WEBLib.TMSFNCStackPanel, WEBLib.TMSFNCCardPanel,
  WEBLib.TMSFNCSkeleton, WEBLib.TMSFNCTheme, WEBLib.TMSFNCThemeSelector,
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
    FAnimationRadios: array[TTMSFNCSkeletonAnimation] of TTMSFNCRadioButton;
    FActiveCheck: TTMSFNCCheckBox;
    FMotionCheck: TTMSFNCCheckBox;
    FLoadedCheck: TTMSFNCCheckBox;
    FSkeletons: array of TTMSFNCSkeleton;
    FLoadingCard: TTMSFNCSkeleton;
    FLoadedCard: TTMSFNCCardPanel;
    function AddSkeleton(AParent: TDemoParent; APreset: TTMSFNCSkeletonPreset; AWidth, AHeight: Integer): TTMSFNCSkeleton;
    function AddRow(const ACaption: string; AHeight: Integer): TTMSFNCStackPanel;
    procedure CreateSettings;
    procedure CreateContent;
    procedure ApplySettings;
    procedure SettingChanged(Sender: TObject);
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
const
  AnimationNames: array[TTMSFNCSkeletonAnimation] of string = ('None', 'Shimmer', 'Pulse');
var
  an: TTMSFNCSkeletonAnimation;
begin
  FSettings := FLayout.AddSettingsPanel(Self);

  FLayout.AddCaption(FSettings, 'Animation');
  for an := Low(TTMSFNCSkeletonAnimation) to High(TTMSFNCSkeletonAnimation) do
    FAnimationRadios[an] := FLayout.AddRadio(FSettings, AnimationNames[an], 'Animation', an = skaShimmer, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FActiveCheck := FLayout.AddCheck(FSettings, 'Active', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FMotionCheck := FLayout.AddCheck(FSettings, 'Respect reduced motion', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FLayout.AddText(FSettings, 'With reduced motion on, the skeleton stays still when the operating system asks ' +
    'applications to limit animations.', 64);

  FLayout.AddCaption(FSettings, 'Loading card');
  FLoadedCheck := FLayout.AddCheck(FSettings, 'Content loaded', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FLayout.AddText(FSettings, 'The card skeleton has the size of the card it stands in for, so nothing moves when ' +
    'the content arrives.', 64);
end;

function TForm1.AddSkeleton(AParent: TDemoParent; APreset: TTMSFNCSkeletonPreset; AWidth, AHeight: Integer): TTMSFNCSkeleton;
begin
  Result := TTMSFNCSkeleton.Create(Self);
  Result.Parent := AParent;
  Result.Width := FLayout.Size(AWidth);
  Result.Height := FLayout.Size(AHeight);
  Result.Preset := APreset;
  SetLength(FSkeletons, Length(FSkeletons) + 1);
  FSkeletons[High(FSkeletons)] := Result;
end;

function TForm1.AddRow(const ACaption: string; AHeight: Integer): TTMSFNCStackPanel;
begin
  FLayout.AddCaption(FContent, ACaption, 8);
  Result := TTMSFNCStackPanel.Create(Self);
  Result.Parent := FContent;
  FLayout.Place(Result, daTop, AHeight, 16, 0, 16, 8);
  Result.Orientation := spoHorizontal;
  Result.Alignment := lpaStart;
  Result.Gap := 24;
  Result.ContentPadding.Rect := RectF(8, 8, 8, 8);
end;

procedure TForm1.CreateContent;
var
  row: TTMSFNCStackPanel;
  s: TTMSFNCSkeleton;
  t: TTMSFNCHTMLText;
begin
  FContent := FLayout.AddContentPanel(Self);

  { the shape presets }
  row := AddRow('Presets', 110);
  AddSkeleton(row, skpText, 260, 90).Lines := 4;
  AddSkeleton(row, skpCircle, 90, 90);
  AddSkeleton(row, skpRectangle, 200, 90);
  AddSkeleton(row, skpList, 320, 90);

  { a custom layout: an avatar, two lines of text and a button }
  row := AddRow('Custom shapes', 80);
  s := AddSkeleton(row, skpCustom, 320, 56);
  s.Items.AddShape(sskCircle, 0, 4, 48, 48);
  s.Items.AddShape(sskLine, 60, 10, 160, 12);
  s.Items.AddShape(sskLine, 60, 32, 100, 12);
  s.Items.AddShape(sskRectangle, 240, 12, 72, 32);

  { the loading card and the card it becomes }
  row := AddRow('A card while it loads', 240);
  FLoadingCard := AddSkeleton(row, skpCard, 300, 220);
  FLoadedCard := TTMSFNCCardPanel.Create(Self);
  FLoadedCard.Parent := row;
  FLoadedCard.Width := FLayout.Size(300);
  FLoadedCard.Height := FLayout.Size(220);
  FLoadedCard.Header.Text := 'Quarterly report';
  FLoadedCard.Header.Description := 'Finished a moment ago';
  FLoadedCard.Footer.Visible := True;
  FLoadedCard.Footer.Text := '12 pages, 2.4 MB';
  t := TTMSFNCHTMLText.Create(Self);
  t.Parent := FLoadedCard;
  FLayout.Place(t, daClient, 0, 0, 0, 0, 0);
  t.Fill.Kind := gfkNone;
  t.Stroke.Kind := gskNone;
  t.HorizontalTextAlign := gtaLeading;
  t.VerticalTextAlign := gtaLeading;
  t.WordWrapping := True;
  t.Text := 'Revenue grew 8% over the previous quarter. The three new regions contributed a third of the growth; ' +
    'support cases went down for the second quarter in a row.';
end;

procedure TForm1.ApplySettings;
var
  I: Integer;
  an: TTMSFNCSkeletonAnimation;
begin
  for I := 0 to High(FSkeletons) do
  begin
    FSkeletons[I].BeginUpdate;
    for an := Low(TTMSFNCSkeletonAnimation) to High(TTMSFNCSkeletonAnimation) do
      if FAnimationRadios[an].Checked then
        FSkeletons[I].Animation := an;
    FSkeletons[I].Active := FActiveCheck.Checked;
    FSkeletons[I].RespectReducedMotion := FMotionCheck.Checked;
    FSkeletons[I].EndUpdate;
  end;
  FLoadingCard.Visible := not FLoadedCheck.Checked;
  FLoadedCard.Visible := FLoadedCheck.Checked;
end;

procedure TForm1.SettingChanged(Sender: TObject);
begin
  ApplySettings;
end;

end.
