unit UDemo;

{ TMS FNC UI Pack - Label Maker

  A small shop prints its shipping labels. Every choice is a picker or a group control: the label size in a radio
  group (TTMSFNCRadioGroup), what is printed in a check group (TTMSFNCCheckGroup), the carrier and the handling
  marks in drop-down groups (TTMSFNCRadioGroupPicker, TTMSFNCCheckGroupPicker), the font (TTMSFNCFontNamePicker),
  the accent in the colours of the theme (TTMSFNCColorSelector and TTMSFNCColorPicker in Mode csmTheme), an icon
  (TTMSFNCBitmapSelector with theme icons) and the number of labels and the paper on a spinner (TTMSFNCSpinner).
  The label on the right follows every choice. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioGroup,
  VCL.TMSFNCCheckGroup, VCL.TMSFNCRadioGroupPicker, VCL.TMSFNCCheckGroupPicker, VCL.TMSFNCFontNamePicker,
  VCL.TMSFNCCustomSelector, VCL.TMSFNCColorSelector, VCL.TMSFNCColorPicker, VCL.TMSFNCBitmapSelector,
  VCL.TMSFNCSpinner, VCL.TMSFNCImage, VCL.TMSFNCThemeIcons, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioGroup,
  FMX.TMSFNCCheckGroup, FMX.TMSFNCRadioGroupPicker, FMX.TMSFNCCheckGroupPicker, FMX.TMSFNCFontNamePicker,
  FMX.TMSFNCCustomSelector, FMX.TMSFNCColorSelector, FMX.TMSFNCColorPicker, FMX.TMSFNCBitmapSelector,
  FMX.TMSFNCSpinner, FMX.TMSFNCImage, FMX.TMSFNCThemeIcons, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioGroup, WEBLib.TMSFNCCheckGroup, WEBLib.TMSFNCRadioGroupPicker,
  WEBLib.TMSFNCCheckGroupPicker, WEBLib.TMSFNCFontNamePicker, WEBLib.TMSFNCCustomSelector,
  WEBLib.TMSFNCColorSelector, WEBLib.TMSFNCColorPicker, WEBLib.TMSFNCBitmapSelector, WEBLib.TMSFNCSpinner,
  WEBLib.TMSFNCImage, WEBLib.TMSFNCThemeIcons, WEBLib.TMSFNCTheme, WEBLib.TMSFNCThemeSelector,
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
    FSize: TTMSFNCRadioGroup;
    FPrint: TTMSFNCCheckGroup;
    FCarrier: TTMSFNCRadioGroupPicker;
    FHandling: TTMSFNCCheckGroupPicker;
    FFont: TTMSFNCFontNamePicker;
    FAccent: TTMSFNCColorSelector;
    FAccentPicker: TTMSFNCColorPicker;
    FIcons: TTMSFNCBitmapSelector;
    FSpinner: TTMSFNCSpinner;
    FLabel: TTMSFNCHTMLText;
    FIcon: TTMSFNCImage;
    FSummary: TTMSFNCHTMLText;
    FAccentColor: TTMSFNCGraphicsColor;
    FFontName: string;
    procedure CreateSettings;
    procedure CreateContent;
    function AddRow(AParent: TTMSFNCPanel; const ACaption: string; AHeight: Integer): TTMSFNCPanel;
    procedure UpdateLabel;
    procedure Changed(Sender: TObject);
    procedure FontSelected(Sender: TObject; AFontName: string);
    procedure ColorSelected(Sender: TObject; AColor: TTMSFNCGraphicsColor);
    procedure IconSelected(Sender: TObject; AItemIndex: Integer);
    procedure SpinnerChanged(Sender: TObject; AColumn, ASelectedCustomIndex: Integer; ASelectedValue: Double;
      ARangeType: TTMSFNCSpinnerRangeType);
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
  IconNames: array[0..5] of string = ('Star', 'Flash', 'Shield', 'Warning', 'People', 'Calendar');
  SizeNames: array[0..2] of string = ('Small', 'Medium', 'Large');
  SizeWidths: array[0..2] of Integer = (280, 340, 400);
  PaperNames: array[0..2] of string = ('A4 sheet', 'Letter sheet', 'Label roll');

{ an item index for an array: the first item while nothing is selected }
function NotBelowZero(AIndex: Integer): Integer;
begin
  if AIndex < 0 then
    Result := 0
  else
    Result := AIndex;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FLayout := TDemoLayout.Create(Self);
  FFontName := 'Segoe UI';
  FAccentColor := gcNull;
  CreateSettings;
  CreateContent;
  UpdateLabel;
end;

function TForm1.AddRow(AParent: TTMSFNCPanel; const ACaption: string; AHeight: Integer): TTMSFNCPanel;
begin
  FLayout.AddCaption(AParent, ACaption, 8);
  Result := FLayout.AddPanel(AParent, daTop, AHeight, 16, 2, 16, 0);
  Result.Fill.Kind := gfkNone;
  Result.Stroke.Kind := gskNone;
end;

procedure TForm1.CreateSettings;
var
  row: TTMSFNCPanel;
begin
  FSettings := FLayout.AddSettingsPanel(Self, 300);

  row := AddRow(FSettings, 'Label size', 40);
  FSize := TTMSFNCRadioGroup.Create(Self);
  FSize.Parent := row;
  FLayout.Place(FSize, daClient, 0, 0, 0, 0, 0);
  FSize.Title.Text := '';
  FSize.Columns := 3;
  FSize.Items.Add('Small');
  FSize.Items.Add('Medium');
  FSize.Items.Add('Large');
  FSize.ItemIndex := 1;
  FSize.OnChange := {$IFDEF WEBLIB}@{$ENDIF}Changed;

  row := AddRow(FSettings, 'Print', 64);
  FPrint := TTMSFNCCheckGroup.Create(Self);
  FPrint.Parent := row;
  FLayout.Place(FPrint, daClient, 0, 0, 0, 0, 0);
  FPrint.Title.Text := '';
  FPrint.Columns := 2;
  FPrint.Items.Clear;
  FPrint.Items.Add('Border');
  FPrint.Items.Add('Return address');
  FPrint.Items.Add('Order number');
  FPrint.Items.Add('Phone number');
  FPrint.Checked[0] := True;
  FPrint.Checked[2] := True;
  FPrint.OnChange := {$IFDEF WEBLIB}@{$ENDIF}Changed;

  row := AddRow(FSettings, 'Carrier and handling', 32);
  FCarrier := TTMSFNCRadioGroupPicker.Create(Self);
  FCarrier.Parent := row;
  FLayout.Place(FCarrier, daLeft, 128, 0, 0, 8, 0);
  FCarrier.Items.Add('Post');
  FCarrier.Items.Add('Express');
  FCarrier.Items.Add('Courier');
  FCarrier.ItemIndex := 0;
  FCarrier.OnChange := {$IFDEF WEBLIB}@{$ENDIF}Changed;
  FHandling := TTMSFNCCheckGroupPicker.Create(Self);
  FHandling.Parent := row;
  FLayout.Place(FHandling, daClient, 0, 0, 0, 0, 0);
  FHandling.Items.Add('Fragile');
  FHandling.Items.Add('Keep dry');
  FHandling.Items.Add('This side up');
  FHandling.Items.Add('Perishable');
  FHandling.Checked[0] := True;
  FHandling.OnChange := {$IFDEF WEBLIB}@{$ENDIF}Changed;

  row := AddRow(FSettings, 'Font', 32);
  FFont := TTMSFNCFontNamePicker.Create(Self);
  FFont.Parent := row;
  FLayout.Place(FFont, daClient, 0, 0, 0, 0, 0);
  FFont.SelectedFontName := FFontName;
  FFont.OnFontNameSelected := {$IFDEF WEBLIB}@{$ENDIF}FontSelected;

  row := AddRow(FSettings, 'Accent: the colours of the theme', 64);
  FAccentPicker := TTMSFNCColorPicker.Create(Self);
  FAccentPicker.Parent := row;
  FLayout.Place(FAccentPicker, daRight, 64, 8, 16, 0, 16);
  FAccentPicker.Mode := csmTheme;
  FAccentPicker.OnColorSelected := {$IFDEF WEBLIB}@{$ENDIF}ColorSelected;
  FAccent := TTMSFNCColorSelector.Create(Self);
  FAccent.Parent := row;
  FLayout.Place(FAccent, daClient, 0, 0, 0, 0, 0);
  FAccent.Mode := csmTheme;
  FAccent.OnColorSelected := {$IFDEF WEBLIB}@{$ENDIF}ColorSelected;

  row := AddRow(FSettings, 'Copies and paper', 96);
  FSpinner := TTMSFNCSpinner.Create(Self);
  FSpinner.Parent := row;
  FLayout.Place(FSpinner, daClient, 0, 0, 0, 0, 0);
  FSpinner.BeginUpdate;
  try
    FSpinner.Columns.Clear;
    with FSpinner.Columns.Add do
    begin
      RangeType := rtNumber;
      RangeFrom := 1;
      RangeTo := 50;
      Step := 1;
      ValueFormat := '%g';
      SelectedValue := 10;
    end;
    with FSpinner.Columns.Add do
    begin
      RangeType := rtCustom;
      CustomItems.Add.Text := PaperNames[0];
      CustomItems.Add.Text := PaperNames[1];
      CustomItems.Add.Text := PaperNames[2];
      SelectedCustomIndex := 0;
    end;
  finally
    FSpinner.EndUpdate;
  end;
  FSpinner.OnSelectedValueChanged := {$IFDEF WEBLIB}@{$ENDIF}SpinnerChanged;
end;

procedure TForm1.CreateContent;
var
  I: Integer;
  it: TTMSFNCBitmapSelectorItem;
  row: TTMSFNCPanel;
begin
  FContent := FLayout.AddContentPanel(Self);

  FLayout.AddCaption(FContent, 'Icon', 0);
  row := FLayout.AddPanel(FContent, daTop, 52, 0, 4, 0, 8);
  row.Fill.Kind := gfkNone;
  row.Stroke.Kind := gskNone;
  FIcons := TTMSFNCBitmapSelector.Create(Self);
  FIcons.Parent := row;
  FLayout.Place(FIcons, daLeft, 6 * 52, 0, 0, 0, 0);
  FIcons.Rows := 1;
  FIcons.Columns := Length(IconNames);
  FIcons.Items.Clear;
  for I := 0 to High(IconNames) do
  begin
    it := FIcons.Items.Add;
    TTMSFNCThemeIcons.LoadInto(it.Bitmap, IconNames[I], 24, gcDarkgray);
  end;
  FIcons.SelectedItemIndex := 0;
  FIcons.OnItemSelected := {$IFDEF WEBLIB}@{$ENDIF}IconSelected;

  FLayout.AddCaption(FContent, 'Label', 8);
  { the label is paper: white with dark ink under every theme (demo-colors: content, as printed) }
  FLabel := TTMSFNCHTMLText.Create(Self);
  FLabel.Parent := FContent;
  FLayout.Place(FLabel, daTop, 230, 0, 4, 0, 8);
  FLabel.ThemingEnabled := False;
  FLabel.Fill.Kind := gfkSolid;
  FLabel.Fill.Color := gcWhite;
  FLabel.Font.Color := MakeGraphicsColor(34, 34, 34);
  FLabel.Font.Size := 13;
  FLabel.WordWrapping := True;
  FLabel.HorizontalTextAlign := gtaLeading;
  FLabel.VerticalTextAlign := gtaLeading;

  FIcon := TTMSFNCImage.Create(Self);
  FIcon.Parent := FLabel;
  FIcon.Width := FLayout.Size(40);
  FIcon.Height := FLayout.Size(40);
  FIcon.Stretch := True;

  FSummary := FLayout.AddText(FContent, '', 60);
end;

procedure TForm1.UpdateLabel;
var
  s, marks, acc: string;
  I, w: Integer;
  ink: TTMSFNCGraphicsColor;
begin
  if FAccentColor = gcNull then
    ink := MakeGraphicsColor(15, 108, 189)
  else
    ink := FAccentColor;
  acc := TTMSFNCGraphics.ColorToHTML(ink);
  marks := '';
  for I := 0 to FHandling.Items.Count - 1 do
    if FHandling.Checked[I] then
    begin
      if marks <> '' then
        marks := marks + ' &middot; ';
      marks := marks + UpperCase(FHandling.Items[I]);
    end;

  s := '<font face="' + FFontName + '"><font color="' + acc + '" size="11"><b>' +
    UpperCase(FCarrier.Items[NotBelowZero(FCarrier.ItemIndex)]) + '</b></font><br><br>' +
    '<b>Northwind Traders</b><br>Ms. Maria Anders<br>Obere Str. 57<br>12209 Berlin, Germany';
  if FPrint.Checked[3] then
    s := s + '<br>+49 30 0074321';
  if FPrint.Checked[2] then
    s := s + '<br><br><font color="' + acc + '">Order SO-10248</font>';
  if FPrint.Checked[1] then
    s := s + '<br><font size="9" color="#666666">Return: Label Maker Shop, Market Street 12, Ghent</font>';
  if marks <> '' then
    s := s + '<br><br><font color="' + acc + '"><b>' + marks + '</b></font>';
  s := s + '</font>';
  FLabel.Text := s;

  w := SizeWidths[NotBelowZero(FSize.ItemIndex)];
  FLabel.Width := FLayout.Size(w);
  {$IFDEF FMX}
  FLabel.Align := TAlignLayout.None;
  FLabel.Position.X := 0;
  {$ELSE}
  FLabel.Align := alNone;
  FLabel.Left := 0;
  {$ENDIF}
  if FPrint.Checked[0] then
  begin
    FLabel.Stroke.Kind := gskSolid;
    FLabel.Stroke.Color := ink;
    FLabel.Stroke.Width := 2;
  end
  else
    FLabel.Stroke.Kind := gskNone;

  if (FIcons.SelectedItemIndex >= 0) and (FIcons.SelectedItemIndex <= High(IconNames)) then
    TTMSFNCThemeIcons.LoadInto(FIcon.Bitmap, IconNames[FIcons.SelectedItemIndex], 40, ink);
  {$IFDEF FMX}
  FIcon.Position.X := FLabel.Width - FIcon.Width - 12;
  FIcon.Position.Y := 12;
  {$ELSE}
  FIcon.Left := FLabel.Width - FIcon.Width - FLayout.Size(12);
  FIcon.Top := FLayout.Size(12);
  {$ENDIF}

  FSummary.Text := Format('%s label, %g copies on %s, font %s.', [SizeNames[NotBelowZero(FSize.ItemIndex)],
    FSpinner.Columns[0].SelectedValue, PaperNames[NotBelowZero(FSpinner.Columns[1].SelectedCustomIndex)], FFontName]);
end;

procedure TForm1.Changed(Sender: TObject);
begin
  UpdateLabel;
end;

procedure TForm1.FontSelected(Sender: TObject; AFontName: string);
begin
  FFontName := AFontName;
  UpdateLabel;
end;

procedure TForm1.ColorSelected(Sender: TObject; AColor: TTMSFNCGraphicsColor);
begin
  FAccentColor := AColor;
  UpdateLabel;
end;

procedure TForm1.IconSelected(Sender: TObject; AItemIndex: Integer);
begin
  UpdateLabel;
end;

procedure TForm1.SpinnerChanged(Sender: TObject; AColumn, ASelectedCustomIndex: Integer; ASelectedValue: Double;
  ARangeType: TTMSFNCSpinnerRangeType);
begin
  UpdateLabel;
end;

end.
