unit UDemo;

{ TMS FNC UI Pack - Brand Studio

  A brand turns the colours, fonts and logo of a company into a light and a dark theme for every FNC control. Pick
  one of the sample brands (TTMSFNCBrand.PresetNames, LoadPreset) or open a .fncbrand file (LoadFromFile), let the
  brand follow light and dark of Windows or keep one mode (ThemeManager.BrandMode), colour the title bar with the
  brand (TitleBar tbBrand), import design tokens from CSS custom properties (ImportTokens) or edit the brand in the
  brand editor at run time (TTMSFNCBrandEditor). The brand board shows the logo and mark (TTMSFNCBrandLogo), the
  brand colours and a small app in the brand; Save writes the brand as a .fncbrand file. }

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
    FEditor: TTMSFNCBrandEditor;
    FLogo: TTMSFNCBrandLogo;
    FMark: TTMSFNCBrandLogo;
    FAppMark: TTMSFNCBrandLogo;
    FSwatches: array[0..4] of TTMSFNCHTMLText;
    FInfo: TTMSFNCHTMLText;
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
var
  r, g, b: Integer;
begin
  {$IFDEF FMX}
  r := (AColor shr 16) and $FF;
  g := (AColor shr 8) and $FF;
  b := AColor and $FF;
  {$ELSE}
  r := AColor and $FF;
  g := (AColor shr 8) and $FF;
  b := (AColor shr 16) and $FF;
  {$ENDIF}
  Result := Format('#%.2X%.2X%.2X', [r, g, b]);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FLayout := TDemoLayout.Create(Self);
  FEditor := TTMSFNCBrandEditor.Create(Self);
  FEditor.ThemeManager := ThemeManager;
  CreateSettings;
  CreateContent;
  ShowBrand;
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
  FBrands.OnItemSelected := BrandSelected;

  FLayout.AddCaption(FSettings, 'Light and dark', 8);
  FMode := TTMSFNCSegmentedControl.Create(Self);
  FMode.Parent := FSettings;
  FLayout.Place(FMode, daTop, 32, 16, 0, 16, 4);
  FMode.Items.AddItem('As Windows');
  FMode.Items.AddItem('Light');
  FMode.Items.AddItem('Dark');
  FMode.ItemIndex := 0;
  FMode.OnChange := SettingChanged;
  FTitleCheck := FLayout.AddCheck(FSettings, 'Title bar in the brand colour', True, SettingChanged);

  FLayout.AddCaption(FSettings, 'Make it yours', 8);
  FLayout.AddButton(FSettings, 'Edit the brand...', EditClick).Default := True;
  FLayout.AddButton(FSettings, 'Import CSS design tokens', TokensClick);
  FLayout.AddButton(FSettings, 'Open a .fncbrand file...', OpenClick);
  FLayout.AddButton(FSettings, 'Save the brand as...', SaveClick);
end;

procedure TForm1.CreateContent;
var
  board, row, card: TTMSFNCPanel;
  I: Integer;
begin
  FContent := FLayout.AddContentPanel(Self);

  { the brand board: logo and mark, colours, facts }
  board := FLayout.AddPanel(FContent, daLeft, 330, 0, 0, 16, 0);
  FLayout.AddCaption(board, 'Logo', 12);
  FLogo := TTMSFNCBrandLogo.Create(Self);
  FLogo.Parent := board;
  FLayout.Place(FLogo, daTop, 72, 16, 4, 16, 4);
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
    FLogo.Visible := has;
    FMark.Visible := has;
    FAppMark.Visible := has;
    for I := 0 to High(FSwatches) do
      FSwatches[I].Visible := has;
    if not has then
    begin
      FInfo.Text := 'No brand: the application theme is in charge. Pick a brand on the left, open a .fncbrand ' +
        'file or import design tokens.';
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
      SetBrand(b);
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
  if FTitleCheck.Checked then
    ThemeManager.TitleBar := tbBrand
  else
    ThemeManager.TitleBar := tbSystem;
  ShowBrand;
end;

procedure TForm1.OpenClick(Sender: TObject);
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
  end;
  report := TStringList.Create;
  try
    n := b.ImportTokens(SampleTokens, report);
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
  FEditor.Execute;
  ShowBrand;
end;

end.
