unit UDemo;

{ TMS FNC UI Pack - Brand Studio

  A brand turns the colours, fonts and logo of a company into a light and a dark theme for every FNC control. Pick
  one of the sample brands (TTMSFNCBrand.PresetNames, LoadPreset) or open a .fncbrand file (LoadFromFile), let the
  brand follow light and dark of Windows or keep one mode (ThemeManager.BrandMode), colour the title bar with the
  brand (TitleBar tbBrand), import design tokens from CSS custom properties (ImportTokens) or edit the brand in the
  brand editor at run time (TTMSFNCBrandEditor; FMX and VCL, as the .fncbrand files). The brand board shows the logo and mark (TTMSFNCBrandLogo), the
  brand colours and a small app in the brand; Save writes the brand as a .fncbrand file. The sample brands get a
  logo, a dark logo and a mark here: SVG drawn from the brand colours and the application name, as data URIs. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCEdit, VCL.TMSFNCProgressBar,
  VCL.TMSFNCListBox, VCL.TMSFNCCustomTreeView, VCL.TMSFNCSegmentedControl, VCL.TMSFNCBrand, VCL.TMSFNCBrandLogo,
  VCL.TMSFNCBrandEditor, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCEdit, FMX.TMSFNCProgressBar,
  FMX.TMSFNCListBox, FMX.TMSFNCCustomTreeView, FMX.TMSFNCSegmentedControl, FMX.TMSFNCBrand, FMX.TMSFNCBrandLogo,
  FMX.TMSFNCBrandEditor, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCEdit, WEBLib.TMSFNCProgressBar, WEBLib.TMSFNCListBox,
  WEBLib.TMSFNCCustomTreeView, WEBLib.TMSFNCSegmentedControl, WEBLib.TMSFNCBrand, WEBLib.TMSFNCBrandLogo,
  WEBLib.TMSFNCTheme, WEBLib.TMSFNCThemeSelector,
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
    FBrands: TTMSFNCListBox;
    FMode: TTMSFNCSegmentedControl;
    FTitleCheck: TTMSFNCCheckBox;
    {$IFNDEF WEBLIB}
    FEditor: TTMSFNCBrandEditor;
    {$ENDIF}
    FLogo: TTMSFNCBrandLogo;
    FMark: TTMSFNCBrandLogo;
    FAppMark: TTMSFNCBrandLogo;
    FSwatches: array[0..4] of TTMSFNCHTMLText;
    FBrandView: TTMSFNCPanel;
    FNoBrandView: TTMSFNCPanel;
    FAppTitle: TTMSFNCHTMLText;
    FInfo: TTMSFNCHTMLText;
    FNoBrandInfo: TTMSFNCHTMLText;
    FStatus: TTMSFNCHTMLText;
    FUpdating: Boolean;
    procedure CreateSettings;
    procedure CreateContent;
    procedure CreateApp(AParent: TTMSFNCPanel);
    procedure SetBrand(ABrand: TTMSFNCBrand);
    function CurrentBrand: TTMSFNCBrand;
    procedure ShowBrand;
    procedure BrandSelected(Sender: TObject; AItem: TTMSFNCListBoxItem);
    procedure SettingChanged(Sender: TObject);
    procedure OpenClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure TokensClick(Sender: TObject);
    procedure EditClick(Sender: TObject);
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

const
  { design tokens as a web designer hands them over: CSS custom properties }
  SampleTokens =
    ':root {'#13#10 +
    '  --color-primary: #0F766E;'#13#10 +
    '  --color-secondary: #F59E0B;'#13#10 +
    '  --color-success: #15803D;'#13#10 +
    '  --color-warning: #B45309;'#13#10 +
    '  --color-error: #B91C1C;'#13#10 +
    '  --font-body: "Segoe UI", sans-serif;'#13#10 +
    '  --radius-control: 8px;'#13#10 +
    '}'#13#10;
  SwatchNames: array[0..4] of string = ('Primary', 'Secondary', 'Success', 'Warning', 'Error');

function HexOf(AColor: TTMSFNCGraphicsColor): string;
begin
  Result := UpperCase(TTMSFNCGraphics.ColorToHTML(AColor));
end;

{ a logo as an SVG data URI: the mark (a rounded square in the primary colour with the initial) and, for the logo, the
  application name next to it }
function SvgURI(const ASvg: string): string;
{$IFNDEF WEBLIB}
var
  s: TStringStream;
{$ENDIF}
begin
  {$IFDEF WEBLIB}
  asm
    Result = 'data:image/svg+xml;base64,' + window.btoa(unescape(encodeURIComponent(ASvg)));
  end;
  {$ELSE}
  s := TStringStream.Create(ASvg, TEncoding.UTF8);
  try
    Result := 'data:image/svg+xml;base64,' + TTMSFNCUtils.SaveStreamToBase64(s);
  finally
    s.Free;
  end;
  {$ENDIF}
end;

function MarkSvg(const AInitial, APrimary, ASecondary: string; AX: Integer): string;
begin
  Result := Format('<rect x="%d" y="0" width="64" height="64" rx="14" fill="%s"/>' +
    '<circle cx="%d" cy="14" r="7" fill="%s"/>' +
    '<text x="%d" y="44" font-family="Segoe UI" font-size="34" font-weight="bold" fill="#FFFFFF" ' +
    'text-anchor="middle">%s</text>', [AX, APrimary, AX + 50, ASecondary, AX + 30, AInitial]);
end;

procedure GiveLogos(ABrand: TTMSFNCBrand);
var
  app, ini, pri, sec: string;
begin
  app := ABrand.AppName;
  if app = '' then
    app := ABrand.Name;
  ini := UpperCase(Copy(app, 1, 1));
  pri := HexOf(ABrand.PrimaryColor);
  sec := HexOf(ABrand.SecondaryColor);
  ABrand.Mark := SvgURI('<svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 64 64">' +
    MarkSvg(ini, pri, sec, 0) + '</svg>');
  ABrand.Logo := SvgURI('<svg xmlns="http://www.w3.org/2000/svg" width="300" height="64" viewBox="0 0 300 64">' +
    MarkSvg(ini, pri, sec, 0) + '<text x="80" y="44" font-family="Segoe UI" font-size="34" font-weight="bold" ' +
    'fill="' + pri + '">' + app + '</text></svg>');
  ABrand.LogoDark := SvgURI('<svg xmlns="http://www.w3.org/2000/svg" width="300" height="64" viewBox="0 0 300 64">' +
    MarkSvg(ini, pri, sec, 0) + '<text x="80" y="44" font-family="Segoe UI" font-size="34" font-weight="bold" ' +
    'fill="#FFFFFF">' + app + '</text></svg>');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FLayout := TDemoLayout.Create(Self);
  {$IFDEF WEBLIB}
  DemoDescription.Text := 'Pick a sample brand, follow light and dark, import design tokens: the logo, the colours ' +
    'and a small app follow the brand';
  {$ENDIF}
  {$IFNDEF WEBLIB}
  FEditor := TTMSFNCBrandEditor.Create(Self);
  FEditor.ThemeManager := ThemeManager;
  {$ENDIF}
  CreateSettings;
  CreateContent;
  { the manager starts as the settings say (SettingChanged shows the brand) }
  SettingChanged(nil);
end;

procedure TForm1.CreateSettings;
var
  names: TStringList;
  I: Integer;
begin
  FSettings := FLayout.AddSettingsPanel(Self, 280);

  FLayout.AddCaption(FSettings, 'Brand', 8);
  FBrands := TTMSFNCListBox.Create(Self);
  FBrands.Parent := FSettings;
  FLayout.Place(FBrands, daTop, 170, 16, 0, 16, 0);
  FBrands.Header.Visible := False;
  FBrands.ItemsAppearance.Look := tnlFluent;
  FBrands.ItemsAppearance.HeightMode := lihmFixed;
  FBrands.ItemsAppearance.FixedHeight := 28;
  FBrands.Items.Add.Text := 'No brand';
  names := TTMSFNCBrand.PresetNames;
  try
    for I := 0 to names.Count - 1 do
      FBrands.Items.Add.Text := names[I];
  finally
    names.Free;
  end;
  FBrands.ItemIndex := 0;
  FBrands.OnItemSelected := {$IFDEF WEBLIB}@{$ENDIF}BrandSelected;

  FLayout.AddCaption(FSettings, 'Light and dark', 8);
  FMode := TTMSFNCSegmentedControl.Create(Self);
  FMode.Parent := FSettings;
  FLayout.Place(FMode, daTop, 32, 16, 0, 16, 4);
  FMode.Items.AddItem('As Windows');
  FMode.Items.AddItem('Light');
  FMode.Items.AddItem('Dark');
  FMode.ItemIndex := 0;
  FMode.OnChange := {$IFDEF WEBLIB}@{$ENDIF}SettingChanged;
  { a browser draws its own title bar }
  {$IFNDEF WEBLIB}
  FTitleCheck := FLayout.AddCheck(FSettings, 'Title bar in the brand colour', True, SettingChanged);
  {$ENDIF}

  FLayout.AddCaption(FSettings, 'Make it yours', 8);
  {$IFDEF WEBLIB}
  FLayout.AddButton(FSettings, 'Import CSS design tokens', @TokensClick).Default := True;
  {$ELSE}
  FLayout.AddButton(FSettings, 'Edit the brand...', EditClick).Default := True;
  FLayout.AddButton(FSettings, 'Import CSS design tokens', TokensClick);
  FLayout.AddButton(FSettings, 'Open a .fncbrand file...', OpenClick);
  FLayout.AddButton(FSettings, 'Save the brand as...', SaveClick);
  {$ENDIF}
end;

procedure TForm1.CreateContent;
var
  board, row, card: TTMSFNCPanel;
  I: Integer;
begin
  FContent := FLayout.AddContentPanel(Self);

  { the brand board: logo and mark, colours, facts; without a brand a short explanation in its place (one of two
    client panels is shown, so nothing changes order) }
  board := FLayout.AddPanel(FContent, daLeft, 330, 0, 0, 16, 0);
  FNoBrandView := FLayout.AddPanel(board, daClient, 0, 0, 0, 0, 0);
  FNoBrandView.Fill.Kind := gfkNone;
  FNoBrandView.Stroke.Kind := gskNone;
  FLayout.AddCaption(FNoBrandView, 'No brand', 12);
  FNoBrandInfo := FLayout.AddText(FNoBrandView, 'The application theme is in charge. Pick a brand on the left, open ' +
    'a .fncbrand file or import design tokens: the logo, the mark and the brand colours show here.', 100);
  FBrandView := FLayout.AddPanel(board, daClient, 0, 0, 0, 0, 0);
  FBrandView.Fill.Kind := gfkNone;
  FBrandView.Stroke.Kind := gskNone;
  board := FBrandView;
  FLayout.AddCaption(board, 'Logo', 12);
  FLogo := TTMSFNCBrandLogo.Create(Self);
  FLogo.Parent := board;
  FLayout.Place(FLogo, daTop, 56, 16, 4, 16, 4);
  FLogo.Kind := blkLogo;
  row := FLayout.AddPanel(board, daTop, 56, 16, 4, 16, 4);
  row.Fill.Kind := gfkNone;
  row.Stroke.Kind := gskNone;
  FMark := TTMSFNCBrandLogo.Create(Self);
  FMark.Parent := row;
  FLayout.Place(FMark, daLeft, 56, 0, 0, 12, 0);
  FMark.Kind := blkMark;
  FLayout.Place(FLayout.AddText(row, 'The mark, for small places: a tab, a tool bar, the icon of the app.', 0),
    daClient, 0, 0, 4, 0, 0);

  FLayout.AddCaption(board, 'Colours', 12);
  for I := 0 to High(FSwatches) do
  begin
    FSwatches[I] := TTMSFNCHTMLText.Create(Self);
    FSwatches[I].Parent := board;
    FLayout.Place(FSwatches[I], daTop, 30, 16, 2, 16, 2);
    { a swatch shows the brand colour itself, not a theme colour }
    FSwatches[I].ThemingEnabled := False;
    FSwatches[I].Fill.Kind := gfkSolid;
    FSwatches[I].VerticalTextAlign := gtaCenter;
  end;
  FInfo := FLayout.AddText(board, '', 80);

  { the app in the brand }
  card := FLayout.AddPanel(FContent, daClient, 0, 0, 0, 0, 0);
  CreateApp(card);

  FStatus := FLayout.AddText(FContent, '', 36);
  FLayout.Place(FStatus, daBottom, 36, 0, 8, 0, 0);
end;

procedure TForm1.CreateApp(AParent: TTMSFNCPanel);
var
  bar, row: TTMSFNCPanel;
  e: TTMSFNCEdit;
  b: TTMSFNCButton;
  pb: TTMSFNCProgressBar;
begin
  bar := FLayout.AddPanel(AParent, daTop, 52, 0, 0, 0, 8);
  FAppMark := TTMSFNCBrandLogo.Create(Self);
  FAppMark.Parent := bar;
  FLayout.Place(FAppMark, daLeft, 220, 12, 8, 0, 8);
  FAppMark.Kind := blkMarkAndAppName;
  FAppTitle := FLayout.AddText(bar, '<b>Table booking</b>', 0);
  FLayout.Place(FAppTitle, daClient, 0, 16, 8, 0, 8);
  FAppTitle.VerticalTextAlign := gtaCenter;
  FLayout.AddCaption(AParent, 'Book a table', 8);
  e := TTMSFNCEdit.Create(Self);
  e.Parent := AParent;
  FLayout.Place(e, daTop, 32, 16, 4, 16, 4);
  e.Text := 'Friday, 8 pm';
  e := TTMSFNCEdit.Create(Self);
  e.Parent := AParent;
  FLayout.Place(e, daTop, 32, 16, 4, 16, 4);
  {$IFDEF FMX}
  e.TextPrompt := 'Your name';
  {$ELSE}
  e.TextHint := 'Your name';
  {$ENDIF}
  FLayout.AddCheck(AParent, 'Window seat', True, nil);
  FLayout.AddCheck(AParent, 'Remind me the day before', False, nil);
  FLayout.AddText(AParent, 'Tables left tonight', 0);
  pb := TTMSFNCProgressBar.Create(Self);
  pb.Parent := AParent;
  FLayout.Place(pb, daTop, 20, 16, 4, 16, 4);
  pb.Value := 30;
  row := FLayout.AddPanel(AParent, daBottom, 36, 16, 8, 16, 12);
  row.Fill.Kind := gfkNone;
  row.Stroke.Kind := gskNone;
  b := FLayout.AddButton(row, 'Book', nil);
  FLayout.Place(b, daRight, 100, 8, 0, 0, 0);
  b.Default := True;
  b := FLayout.AddButton(row, 'Later', nil);
  FLayout.Place(b, daRight, 100, 8, 0, 0, 0);
end;

{ the brand of the theme manager as a TTMSFNCBrand the caller frees; nil without a brand }
function TForm1.CurrentBrand: TTMSFNCBrand;
begin
  Result := nil;
  if Assigned(ThemeManager.Brand) and not ThemeManager.Brand.IsEmpty then
  begin
    Result := TTMSFNCBrand.Create;
    Result.LoadFromJSON(ThemeManager.Brand.SaveToJSON);
  end;
end;

procedure TForm1.SetBrand(ABrand: TTMSFNCBrand);
begin
  ThemeManager.Brand := ABrand;
  ShowBrand;
end;

procedure TForm1.ShowBrand;
var
  b: TTMSFNCBrand;
  colors: array[0..4] of TTMSFNCGraphicsColor;
  I: Integer;
  has: Boolean;
begin
  b := CurrentBrand;
  try
    has := Assigned(b);
    FBrandView.Visible := has;
    FNoBrandView.Visible := not has;
    FAppMark.Visible := has;
    FAppTitle.Visible := not has;
    if not has then
    begin
      FStatus.Text := 'Theme <b>' + ThemeManager.Theme + '</b>, no brand.';
      Exit;
    end;
    colors[0] := b.PrimaryColor;
    colors[1] := b.SecondaryColor;
    colors[2] := b.SuccessColor;
    colors[3] := b.WarningColor;
    colors[4] := b.ErrorColor;
    for I := 0 to High(FSwatches) do
    begin
      FSwatches[I].Fill.Color := colors[I];
      { demo-colors: the text on a swatch is black or white, whichever reads on the brand colour }
      if TTMSFNCBrand.ContrastRatio(gcWhite, colors[I]) >= 4.5 then
        FSwatches[I].Font.Color := gcWhite
      else
        FSwatches[I].Font.Color := gcBlack;
      FSwatches[I].Text := '&nbsp;&nbsp;<b>' + SwatchNames[I] + '</b>&nbsp;&nbsp;' + HexOf(colors[I]);
    end;
    FInfo.Text := '<b>' + b.Name + '</b><br>Body font: ' + b.ResolveFont(False) + '<br>Themes: ' +
      b.ThemeName(tmLight) + ', ' + b.ThemeName(tmDark);
    FStatus.Text := 'The brand <b>' + b.Name + '</b> makes the themes ' + b.ThemeName(tmLight) + ' and ' +
      b.ThemeName(tmDark) + '; the header switch and the light / dark choice pick one of the two.';
  finally
    b.Free;
  end;
end;

procedure TForm1.BrandSelected(Sender: TObject; AItem: TTMSFNCListBoxItem);
var
  b: TTMSFNCBrand;
begin
  if FUpdating or not Assigned(AItem) then
    Exit;
  if FBrands.ItemIndex <= 0 then
  begin
    SetBrand(nil);
    Exit;
  end;
  b := TTMSFNCBrand.Create;
  try
    if b.LoadPreset(AItem.Text) then
    begin
      GiveLogos(b);
      SetBrand(b);
    end;
  finally
    b.Free;
  end;
end;

procedure TForm1.SettingChanged(Sender: TObject);
begin
  case FMode.ItemIndex of
    1: ThemeManager.BrandMode := bmLight;
    2: ThemeManager.BrandMode := bmDark;
  else
    ThemeManager.BrandMode := bmFollowSystem;
  end;
  {$IFNDEF WEBLIB}
  if FTitleCheck.Checked then
    ThemeManager.TitleBar := tbBrand
  else
    ThemeManager.TitleBar := tbSystem;
  {$ENDIF}
  ShowBrand;
end;

procedure TForm1.OpenClick(Sender: TObject);
{$IFNDEF WEBLIB}
var
  f: string;
  b: TTMSFNCBrand;
begin
  f := '';
  if not TTMSFNCUtils.SelectFile(f, '', 'Brand files (*.fncbrand)|*.fncbrand') or (f = '') then
    Exit;
  b := TTMSFNCBrand.Create;
  try
    b.LoadFromFile(f);
    SetBrand(b);
    FUpdating := True;
    FBrands.ItemIndex := -1;
    FUpdating := False;
  finally
    b.Free;
  end;
end;

procedure TForm1.SaveClick(Sender: TObject);
var
  f: string;
  b: TTMSFNCBrand;
begin
  b := CurrentBrand;
  if not Assigned(b) then
  begin
    FStatus.Text := 'There is no brand to save: pick one first.';
    Exit;
  end;
  try
    f := b.Name + '.fncbrand';
    if TTMSFNCUtils.SaveFile(f, 'Brand files (*.fncbrand)|*.fncbrand') and (f <> '') then
    begin
      b.SaveToFile(f);
      FStatus.Text := 'Saved as <b>' + f + '</b>: ThemeManager.BrandFile or LoadBrand loads it in your application.';
    end;
  finally
    b.Free;
  end;
end;

{$ELSE}
begin
end;

procedure TForm1.SaveClick(Sender: TObject);
begin
end;
{$ENDIF}

procedure TForm1.TokensClick(Sender: TObject);
var
  b: TTMSFNCBrand;
  report: TStringList;
  n: Integer;
begin
  b := CurrentBrand;
  if not Assigned(b) then
  begin
    b := TTMSFNCBrand.Create;
    b.Name := 'Tokens';
    b.AppName := 'Tokens';
  end;
  report := TStringList.Create;
  try
    n := b.ImportTokens(SampleTokens, report);
    { the logos of a sample brand follow the imported colours; the logos of an opened brand file stay }
    if (b.Logo = '') or (FBrands.ItemIndex >= 0) then
      GiveLogos(b);
    SetBrand(b);
    FStatus.Text := IntToStr(n) + ' tokens taken from the CSS sample (--color-primary, --color-secondary, ...): ' +
      'the brand colours and font follow them.';
  finally
    report.Free;
    b.Free;
  end;
end;

procedure TForm1.EditClick(Sender: TObject);
begin
  {$IFNDEF WEBLIB}
  FEditor.Execute;
  {$ENDIF}
  ShowBrand;
end;

end.
