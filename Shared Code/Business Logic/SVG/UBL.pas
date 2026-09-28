unit UBL;

interface

{$IFDEF LCL}
{$mode objfpc}{$H+}{$modeswitch advancedrecords}
{$ENDIF}

uses
  {$IFDEF VCL}
  Classes, SysUtils, Generics.Collections, VCL.Controls, Types, VCL.Forms, VCL.StdCtrls, UITypes, VCL.TMSFNCTypes, VCL.TMSFNCBitmapContainer,
  VCL.TMSFNCImage, VCL.TMSFNCBitmapPicker, VCL.TMSFNCBitmapSelector, VCL.TMSFNCGraphics, VCL.TMSFNCPanel, VCL.TMSFNCGraphicsTypes,
  VCL.TMSFNCCustomControl, VCL.TMSFNCRichEditor, VCL.TMSFNCRichEditorBase;
  {$ENDIF}

  {$IFDEF FMX}
  Classes, SysUtils, Generics.Collections, FMX.Types, Types, FMX.Forms, IOUtils, UITypes, FMX.TMSFNCTypes, FMX.TMSFNCBitmapContainer, FMX.TMSFNCImage,
  FMX.TMSFNCBitmapPicker, FMX.TMSFNCBitmapSelector, FMX.TMSFNCGraphics, FMX.TMSFNCPanel, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCRichEditor, FMX.TMSFNCRichEditorBase;
  {$ENDIF}

  {$IFDEF LCL}
  Classes, SysUtils, Graphics, Forms, Types, Controls, StdCtrls, LCLTMSFNCTypes, LCLTMSFNCBitmapContainer, LCLTMSFNCImage, LCLTMSFNCBitmapPicker,
  LCLTMSFNCBitmapSelector, LCLTMSFNCGraphics, LCLTMSFNCPanel, LCLTMSFNCGraphicsTypes, LCLTMSFNCCustomControl, LCLTMSFNCRichEditor, LCLTMSFNCRichEditorBase;
  {$ENDIF}

  {$IFDEF WEBLIB}
  Web, Classes, Contnrs, SysUtils, Types, WEBLib.Controls, WEBLib.Dialogs, WEBLib.Forms, WEBLib.TMSFNCTypes, WEBLib.TMSFNCBitmapContainer, WEBLib.TMSFNCImage,
  WEBLib.TMSFNCBitmapPicker, WEBLib.TMSFNCBitmapSelector, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCPanel, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.ExtCtrls;
  {$ENDIF}

type
  TSVGLogic = class
  private
    FForm: TCustomForm;
    b: TTMSFNCBitmapContainer;
    img1, img2: TTMSFNCImage;
    p1, p2: TTMSFNCBitmapPicker;
    pnl1, pnl2: TTMSFNCPanel;
    {$IFNDEF WEBLIB}
    re1, re2: TTMSFNCRichEditor;
    {$ENDIF}
    {$IFDEF WEBLIB}
    re1, re2: TWEBHTMLContainer;
    {$ENDIF}
  public
    destructor Destroy; override;
    procedure InitSVG(AForm: TCustomForm);
    {$IFNDEF WEBLIB}
    procedure SetRichText(ABitmap: TTMSFNCBitmap; ARichEditor: TTMSFNCRichEditor);
    {$ENDIF}
    procedure DoItemBeforeDrawContent(Sender: TObject; AGraphics: TTMSFNCGraphics; ARect: TRectF; AItemIndex: Integer; var ADefaultDraw: Boolean);
    procedure DoBitmapSelected(Sender: TObject; ABitmap: TTMSFNCBitmap);
    {$IFDEF WEBLIB}
    procedure DoImageCacheReady(Sender: TObject);
    {$ENDIF}
  end;

implementation

const
  IconNames: array[0..9] of string = ('Battery-50-Charging_24x24.scale-100',
    'Memory-Card-Save_24x24.scale-100', 'Monitor-Delete_24x24.scale-100', 'NAS_24x24.scale-100',
    'Network-Computer-Error_24x24.scale-100', 'Server-Previous_24x24.scale-100', 'Signal-Details_24x24.scale-100',
    'Toolbox-Warning_24x24.scale-100', 'Traffic-Light-Green_24x24.scale-100', 'Workgroup-Next_24x24.scale-100');

destructor TSVGLogic.Destroy;
begin
  inherited;
end;

{$IFDEF WEBLIB}
procedure TSVGLogic.DoImageCacheReady(Sender: TObject);
begin
  img1.Invalidate;
  img2.Invalidate;
  p1.Invalidate;
  p2.Invalidate;
end;
{$ENDIF}

procedure TSVGLogic.DoBitmapSelected(Sender: TObject; ABitmap: TTMSFNCBitmap);
begin
  if Sender = p1 then
  begin
    img1.Bitmaps.Clear;
    img1.Bitmaps.AddBitmapName(IconNames[(Sender as TTMSFNCBitmapPicker).SelectedItemIndex]+'.png');
  end;

  if Sender = p2 then
  begin
    img2.Bitmaps.Clear;
    img2.Bitmaps.AddBitmapName(IconNames[(Sender as TTMSFNCBitmapPicker).SelectedItemIndex]+'.svg');
  end;
end;

procedure TSVGLogic.DoItemBeforeDrawContent(Sender: TObject;
  AGraphics: TTMSFNCGraphics; ARect: TRectF; AItemIndex: Integer;
  var ADefaultDraw: Boolean);
var
  n: string;
begin
  ADefaultDraw := False;
  n := (Sender as TTMSFNCBitmapPicker).Items[AItemIndex].BitmapName;
  InflateRectEx(ARect, -4, -4);
  AGraphics.DrawBitmap(ARect, (Sender as TTMSFNCBitmapPicker).BitmapContainer.FindBitmap(n), True, True);
end;

procedure TSVGLogic.InitSVG(AForm: TCustomForm);
var
  pth: string;
  I: Integer;
  bi: TTMSFNCBitmapSelectorItem;
  w, h: Integer;
begin
  FForm := AForm;
  {$IFDEF FMX}
  FForm.BorderStyle := TFmxFormBorderStyle.Single;
  {$ENDIF}
  {$IFDEF LCL}
  FForm.BorderStyle := bsSingle;
  {$ENDIF}
  {$IFDEF VCL}
  FForm.BorderStyle := bsSingle;
  {$ENDIF}

  w := 650;
  h := 750;

  FForm.Width := w;
  FForm.Height := h;


  b := TTMSFNCBitmapContainer.Create(FForm);
  {$IFDEF WEBLIB}
  asm
    var loc = window.location.href;
    var dir = loc.substring(0, loc.lastIndexOf('/'));
    pth = dir;
  end;

  {$ELSE}
  pth := '..\..\Shared Code\Resources\SVG\';
  {$ENDIF}
  for I := 0 to Length(IconNames) - 1 do
  begin
    b.AddFromFile(pth + '/' + IconNames[I] + '.svg', IconNames[I] + '.svg');
    b.AddFromFile(pth + '/' + IconNames[I] + '.png', IconNames[I] + '.png');
  end;

  pnl1 := TTMSFNCPanel.Create(FForm);
  pnl1.Parent := FForm;
  pnl1.BitmapContainer := b;
  pnl1.Width := w div 2;
  pnl1.Height := h - 30;
  pnl1.Header.Text := '<img src="'+ IconNames[6] +'.png"/> <font size="18">PNG</font>';
  pnl1.Header.Font.Color := gcSteelBlue;
  pnl1.Header.Fill.Color := gcWhitesmoke;
  pnl1.Header.Size := 40;

  pnl2 := TTMSFNCPanel.Create(FForm);
  pnl2.Parent := FForm;
  pnl2.BitmapContainer := b;
  pnl2.Width := pnl1.Width;
  pnl2.Left := pnl1.Width;
  pnl2.Height := pnl1.Height;
  pnl2.Header.Text := '<img src="'+ IconNames[6] +'.svg"/> <font size="18">SVG</font>';
  pnl2.Header.Font.Color := gcSteelBlue;
  pnl2.Header.Fill.Color := gcWhitesmoke;
  pnl2.Header.Size := 40;

  img1 := TTMSFNCImage.Create(pnl1);
  img1.ControlAlignment := caTop;
  img1.SetControlMargins(10, 10, 10, 10);
  img1.BitmapContainer := b;
  img1.Bitmaps.AddBitmapName(IconNames[0] + '.png');
  img1.Stretch := True;

  img2 := TTMSFNCImage.Create(pnl2);
  img2.ControlAlignment := caTop;
  img2.SetControlMargins(10, 10, 10, 10);
  img2.BitmapContainer := b;
  img2.Bitmaps.AddBitmapName(IconNames[0] + '.svg');
  img2.Stretch := True;

  p1 := TTMSFNCBitmapPicker.Create(pnl1);
  p1.ControlAlignment := caTop;
  p1.SetControlMargins(10, 0, 10, 10);
  p1.BitmapContainer := b;
  p1.DropDownWidth := 400;
  p1.DropDownHeight := 400;
  p1.Height := 50;
  p1.OnItemBeforeDrawContent := {$IFDEF LCL}@{$ENDIF}DoItemBeforeDrawContent;
  p1.CloseOnSelection := True;
  p1.OnBitmapSelected := {$IFDEF LCL}@{$ENDIF}DoBitmapSelected;

  p2 := TTMSFNCBitmapPicker.Create(pnl2);
  p2.BitmapContainer := b;
  p2.ControlAlignment := caTop;
  p2.SetControlMargins(10, 0, 10, 10);
  p2.DropDownWidth := 400;
  p2.DropDownHeight := 400;
  p2.Height := 50;
  p2.OnItemBeforeDrawContent := {$IFDEF LCL}@{$ENDIF}DoItemBeforeDrawContent;
  p2.CloseOnSelection := True;
  p2.OnBitmapSelected := {$IFDEF LCL}@{$ENDIF}DoBitmapSelected;

  {$IFNDEF WEBLIB}
  re1 := TTMSFNCRichEditor.Create(pnl1);
  re1.Parent := pnl1;
  {$ENDIF}
  {$IFDEF WEBLIB}
  re1 := TWEBHTMLContainer.Create(pnl1);
  re1.Parent := pnl1;
  {$ENDIF}

  {$IFDEF FMX}
  re1.Margins.Rect := RectF(10, 0, 10, 10);
  {$ENDIF}
  {$IFDEF VCL}
  re1.Margins.Left := 10;
  re1.Margins.Right := 10;
  re1.Margins.Bottom := 10;
  re1.AlignWithMargins := True;
  {$ENDIF}
  {$IFDEF WEBLIB}
  re1.Margins.Left := 10;
  re1.Margins.Right := 10;
  re1.Margins.Bottom := 10;
  re1.AlignWithMargins := True;
  {$ENDIF}
  {$IFDEF LCL}
  re1.BorderSpacing.Left := 10;
  re1.BorderSpacing.Right := 10;
  re1.BorderSpacing.Bottom := 10;
  {$ENDIF}

  {$IFNDEF WEBLIB}
  SetRichText(b.FindBitmap(IconNames[7]+'.png'), re1);
  {$ENDIF}
  {$IFDEF WEBLIB}
  re1.HTML.LoadFromFile('SVG.html');
  {$ENDIF}

  {$IFNDEF WEBLIB}
  re2 := TTMSFNCRichEditor.Create(pnl2);
  re2.Parent := pnl2;
  {$ENDIF}
  {$IFDEF WEBLIB}
  re2 := TWEBHTMLContainer.Create(pnl2);
  re2.Parent := pnl2;
  {$ENDIF}

  {$IFDEF FMX}
  re2.Margins.Rect := RectF(10, 0, 10, 10);
  {$ENDIF}
  {$IFDEF VCL}
  re2.Margins.Left := 10;
  re2.Margins.Right := 10;
  re2.Margins.Bottom := 10;
  re2.AlignWithMargins := True;
  {$ENDIF}
  {$IFDEF WEBLIB}
  re2.Margins.Left := 10;
  re2.Margins.Right := 10;
  re2.Margins.Bottom := 10;
  re2.AlignWithMargins := True;
  {$ENDIF}
  {$IFDEF LCL}
  re2.BorderSpacing.Left := 10;
  re2.BorderSpacing.Right := 10;
  re2.BorderSpacing.Bottom := 10;
  {$ENDIF}

  {$IFNDEF WEBLIB}
  SetRichText(b.FindBitmap(IconNames[7]+'.svg'), re2);
  {$ENDIF}
  {$IFDEF WEBLIB}
  re2.HTML.LoadFromFile('SVG.html');
  {$ENDIF}

  for I := 0 to Length(IconNames) - 1 do
  begin
    bi := p1.Items.Add;
    bi.BitmapName := IconNames[I] + '.png';

    bi := p2.Items.Add;
    bi.BitmapName := IconNames[I] + '.svg';
  end;

  {$IFDEF FMX}
  p1.Parent := pnl1;
  p2.Parent := pnl2;
  img1.Parent := pnl1;
  img2.Parent := pnl2;
  re1.Align := TAlignLayout.Client;
  re2.Align := TAlignLayout.Client;
  {$ELSE}
  img1.Parent := pnl1;
  img2.Parent := pnl2;
  p1.Parent := pnl1;
  p2.Parent := pnl2;
  re1.Align := alClient;
  re2.Align := alClient;
  {$ENDIF}

  p1.SelectedItemIndex := 0;
  p2.SelectedItemIndex := 0;

  {$IFDEF WEBLIB}
  Application.OnImageCacheReady := DoImageCacheReady;
  {$ENDIF}
end;

{$IFNDEF WEBLIB}
procedure TSVGLogic.SetRichText(ABitmap: TTMSFNCBitmap; ARichEditor: TTMSFNCRichEditor);
var
  str: String;
  rt: String;
  procedure SelectText(ASubText, AText: string);
  begin
    ARichEditor.SelectText(Pos(ASubText, AText) - 1, Length(ASubText));
  end;
begin
  str := 'Hi !'#13#10#13#10;
  str := str + 'This is the rich editor'#13#10;
  str := str + 'It has support for bold, italic, underline, strikethrough, subscript and superscript text'#13#10;
  str := str + 'Changing font size, font name, text color and background'#13#10#13#10;
  str := str + 'SVG Support !!, and much more'#13#10#13#10;
  str := str + 'Isn''t that nice !'#13#10;
  str := str + 'More information can be found on tmssoftware.com'#13#10;
  ARichEditor.AddMultiLineText(str);
  str := ARichEditor.Text;

  ARichEditor.SelectAll;
  ARichEditor.SetSelectionFontName('Courier New');
  ARichEditor.SetSelectionFontSize(12);

  rt := 'Hi !';
  SelectText(rt, str);
  ARichEditor.SetSelectionFontSize(20);

  rt := 'rich editor';
  SelectText(rt, str);
  ARichEditor.SetSelectionFontSize(16);

  rt := 'rich';
  SelectText(rt, str);
  ARichEditor.SetSelectionColor(gcRed);

  rt := 'editor';
  SelectText(rt, str);
  ARichEditor.SetSelectionColor(gcBlue);

  rt := 'bold';
  SelectText(rt, str);
  ARichEditor.SetSelectionBold(True);

  rt := 'italic';
  SelectText(rt, str);
  ARichEditor.SetSelectionItalic(True);

  rt := 'strikethrough';
  SelectText(rt, str);
  ARichEditor.SetSelectionStrikeOut(True);

  rt := 'subscript';
  SelectText(rt, str);
  ARichEditor.SetSelectionSubscript(True);
  ARichEditor.SetSelectionFontSize(12);

  rt := 'superscript';
  SelectText(rt, str);
  ARichEditor.SetSelectionSuperscript(True);
  ARichEditor.SetSelectionFontSize(12);

  rt := 'underline';
  SelectText(rt, str);
  ARichEditor.SetSelectionUnderline(True);

  rt := 'underline';
  SelectText(rt, str);
  ARichEditor.SetSelectionColor(gcLime);

  rt := 'text color';
  SelectText(rt, str);
  ARichEditor.SetSelectionColor(gcOrange);

  rt := 'background';
  SelectText(rt, str);
  ARichEditor.SetSelectionBkColor(gcSteelblue);
  ARichEditor.SetSelectionColor(gcWhite);

  rt := 'font name';
  SelectText(rt, str);
  ARichEditor.SetSelectionFontName('Bradley Hand ITC');

  rt := 'font size';
  SelectText(rt, str);
  ARichEditor.SetSelectionFontSize(28);

  rt := 'Isn''t that nice !';
  SelectText(rt, str);
  ARichEditor.SetSelectionFontSize(18);

  rt := 'tmssoftware.com';
  SelectText(rt, str);
  ARichEditor.SetSelectionHyperlink('http://www.tmssoftware.com/site/tmsfnccore.asp');

  rt := 'SVG Support !!, and much more';
  SelectText(rt, str);
  ARichEditor.InsertImage(ABitmap, 128, 128);

  ARichEditor.ClearSelection;
end;
{$ENDIF}

end.
