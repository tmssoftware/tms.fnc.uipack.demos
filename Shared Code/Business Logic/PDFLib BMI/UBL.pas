unit UBL;

interface

{$IFDEF LCL}
{$mode objfpc}{$H+}{$modeswitch advancedrecords}
{$ENDIF}

uses
  {$IFDEF VCL}
  Classes, SysUtils, Generics.Collections, Types, VCL.Forms, VCL.StdCtrls, UITypes, VCL.TMSFNCPDFLib, VCL.TMSFNCPDFGraphicsLib,
  VCL.TMSFNCGraphicsTypes, VCL.TMSFNCGraphicsPDFEngine, DateUtils, VCL.TMSFNCURLBitmapContainer, VCL.TMSFNCEdit,
  VCL.TMSFNCDataGrid, VCL.TMSFNCWidgetGauge, VCL.TMSFNCUtils, VCL.TMSFNCDataGridRenderer, VCL.TMSFNCDataGridCore, VCL.TMSFNCGraphics, VCL.TMSFNCDataGridCell, VCL.TMSFNCDataGridData, VCL.TMSFNCPDFIO;
  {$ENDIF}

  {$IFDEF FMX}
  Classes, SysUtils, Generics.Collections, Types, FMX.Forms, IOUtils, UITypes, FMX.TMSFNCPDFLib, FMX.TMSFNCPDFGraphicsLib, FMX.TMSFNCDataGrid,
  FMX.TMSFNCGraphicsTypes, FMX.TMSFNCGraphicsPDFEngine, DateUtils, FMX.TMSFNCURLBitmapContainer, FMX.StdCtrls, FMX.TMSFNCEdit,
  FMX.TMSFNCWidgetGauge, FMX.TMSFNCDataGridCore, FMX.TMSFNCUtils, FMX.TMSFNCDataGridRenderer, FMX.TMSFNCGraphics, FMX.TMSFNCDataGridCell, FMX.TMSFNCDataGridData, FMX.TMSFNCPDFIO;
  {$ENDIF}

  {$IFDEF LCL}
  Classes, SysUtils, Graphics, Forms, Types, Controls, StdCtrls, LCLTMSFNCTypes, LCLTMSFNCPDFLib, LCLTMSFNCPDFGraphicsLib,
  LCLTMSFNCGraphicsTypes, LCLTMSFNCGraphicsPDFEngine, DateUtils, LCLTMSFNCURLBitmapContainer, LCLTMSFNCEdit,
  LCLTMSFNCDataGrid, LCLTMSFNCWidgetGauge, LCLTMSFNCDataGridCore, LCLTMSFNCDataGridRenderer, LCLTMSFNCUtils, LCLTMSFNCGraphics, LCLTMSFNCDataGridCell, LCLTMSFNCDataGridData, LCLTMSFNCPDFIO;
  {$ENDIF}

  {$IFDEF WEBLIB}
  Web, Classes, Contnrs, SysUtils, Types, WEBLib.Dialogs, WEBLib.TMSFNCTypes, WEBLib.Graphics, WEBLib.Forms, WEBLib.StdCtrls, WEBLib.Controls, WEBLib.TMSFNCPDFLib, WEBLib.TMSFNCPDFGraphicsLib,
  WEBLib.TMSFNCGraphicsTypes, WEBLib.TMSFNCGraphicsPDFEngine, DateUtils, WEBLib.TMSFNCURLBitmapContainer, WEBLib.TMSFNCEdit,
  WEBLib.TMSFNCDataGrid, WEBLib.TMSFNCWidgetGauge, WEBLib.TMSFNCDataGridCore, WEBLib.TMSFNCDataGridRenderer, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCDataGridCell, WEBLib.TMSFNCDataGridData, WEBLib.TMSFNCPDFIO;
  {$ENDIF}

type
  TPDFLibBMILogic = class
  private
    {$IFDEF WEBLIB}
    FAni: TWaitMessage;
    {$ENDIF}
    FName, FWeight, FHeight: string;
    FWeightNum, FHeightNum: Single;
    FExportButton, FCalculateButton: TButton;
    FEditName, FEditWeight, FEditHeight: TTMSFNCEdit;
    FGauge: TTMSFNCWidgetGauge;
    FGrid: TTMSFNCDataGrid;
    FForm: TCustomForm;
    p: TTMSFNCGraphicsPDFIO;
    b: TTMSFNCURLBitmapContainer;
  protected
    procedure DoDownloadComplete(Sender: TObject; ItemIndex: Integer);
    procedure DoAfterDraw(Sender: TObject; APDFLib: TTMSFNCPDFLib);
    procedure DoCanCreateNewPage(Sender: TObject; const APDFLib: TTMSFNCPDFLib; const AExportObject: TTMSFNCPDFIOExportObject; var ACanCreate: Boolean);
    procedure DoExportClicked(Sender: TObject);
    procedure DoCalculateClicked(Sender: TObject);
    procedure DoFontCacheReady(Sender: TObject);
    procedure DoCellBeforeDraw(Sender: TObject; AGraphics: TTMSFNCGraphics; ACell: TTMSFNCDataGridCell; var ACanDraw: Boolean);
    procedure DoCellAfterDraw(Sender: TObject; AGraphics: TTMSFNCGraphics; ACell: TTMSFNCDataGridCell);
    procedure UpdateCells;
  public
    destructor Destroy; override;
    procedure InitPDFLibBMI(AForm: TCustomForm);
    procedure GeneratePDF;
  end;

implementation

uses
  Math;

destructor TPDFLibBMILogic.Destroy;
begin
  FreeAndNil(b);
  FreeAndNil(p);
  inherited;
end;

procedure TPDFLibBMILogic.DoAfterDraw(Sender: TObject;
  APDFLib: TTMSFNCPDFLib);
var
  r, tr, rorig: TRectF;
  s: string;
begin
  {$IFDEF WEBLIB}
  APDFLib.Graphics.Font.Name := 'Roboto';
  APDFLib.Graphics.Font.Size := 10;
  {$ENDIF}
  APDFLib.BitmapContainer := b;
  APDFLib.Graphics.DrawImageWithName('TMS_LOGO_rgb_high.jpg', gcWhite, RectF(10, 10, 400, 100));
  APDFLib.Graphics.Stroke.Color := gcOrange;
  APDFLib.Graphics.Stroke.Width := 5;
  APDFLib.Graphics.Stroke.Kind := gskSolid;
  APDFLib.Graphics.DrawLine(PointF(0, 100), PointF(APDFLib.PageWidth, 100));
  APDFLib.Graphics.Font.Color := gcOrange;
  APDFLib.Graphics.DrawHTMLText('<b>'+'Name: '+'</b>' + FName, PointF(50, 120));
  APDFLib.Graphics.DrawHTMLText('<b>'+'Weight (kg): '+'</b>' + FWeight, PointF(50, 140));
  APDFLib.Graphics.DrawHTMLText('<b>'+'Height (cm): '+'</b>' + FHeight, PointF(50, 160));
  APDFLib.Graphics.Font.Color := gcBlack;

  APDFLib.Graphics.DrawHTMLText('<p align="right">BMI Report</p>', RectF(APDFLib.PageWidth - 500, 120, APDFLib.PageWidth - 50, 120));
  APDFLib.Graphics.DrawHTMLText('<p align="right">Date: ' + DateToStr(Now)+'</p>', RectF(APDFLib.PageWidth - 500, 140, APDFLib.PageWidth - 50, 140));

  APDFLib.Graphics.Fill.Color := MakeGraphicsColor(181, 235, 106);
  APDFLib.Graphics.Stroke.Kind := gskNone;
  r := RectF(FGauge.Width + 180, 180 + FGrid.Height + 20, FGauge.Width + 310, 180 + FGrid.Height + 45);
  rorig := r;
  APDFLib.Graphics.DrawRectangle(r);
  APDFLib.Graphics.Alignment := gtaCenter;
  tr := APDFLib.Graphics.DrawText('Normal BMI', r, True);
  APDFLib.Graphics.DrawText('Normal BMI', RectF(r.Left, r.Top + ((r.Bottom - r.Top) - (tr.Bottom - tr.Top)) / 2, r.Right, r.Top + ((r.Bottom - r.Top) - (tr.Bottom - tr.Top)) / 2 + (tr.Bottom - tr.Top)));

  r := RectF(r.Right + 20, r.Top, r.Right + 150, r.Bottom);
  APDFLib.Graphics.Fill.Color := MakeGraphicsColor(158, 214, 238);
  APDFLib.Graphics.DrawRectangle(r);
  tr := APDFLib.Graphics.DrawText('Mild Thinness', r, True);
  APDFLib.Graphics.DrawText('Mild Thinness', RectF(r.Left, r.Top + ((r.Bottom - r.Top) - (tr.Bottom - tr.Top)) / 2, r.Right, r.Top + ((r.Bottom - r.Top) - (tr.Bottom - tr.Top)) / 2 + (tr.Bottom - tr.Top)));

  r := RectF(r.Right + 20, r.Top, r.Right + 150, r.Bottom);
  APDFLib.Graphics.Fill.Color := MakeGraphicsColor(92, 150, 248);
  APDFLib.Graphics.DrawRectangle(r);
  APDFLib.Graphics.Font.Color := gcWhite;
  tr := APDFLib.Graphics.DrawText('Moderate Thinness', r, True);
  APDFLib.Graphics.DrawText('Moderate Thinness', RectF(r.Left, r.Top + ((r.Bottom - r.Top) - (tr.Bottom - tr.Top)) / 2, r.Right, r.Top + ((r.Bottom - r.Top) - (tr.Bottom - tr.Top)) / 2 + (tr.Bottom - tr.Top)));

  r := RectF(r.Right + 20, r.Top, r.Right + 150, r.Bottom);
  APDFLib.Graphics.Fill.Color := MakeGraphicsColor(72, 119, 198);
  APDFLib.Graphics.DrawRectangle(r);
  APDFLib.Graphics.Font.Color := gcWhite;
  tr := APDFLib.Graphics.DrawText('Severe Thinness', r, True);
  APDFLib.Graphics.DrawText('Severe Thinness', RectF(r.Left, r.Top + ((r.Bottom - r.Top) - (tr.Bottom - tr.Top)) / 2, r.Right, r.Top + ((r.Bottom - r.Top) - (tr.Bottom - tr.Top)) / 2 + (tr.Bottom - tr.Top)));

  r := RectF(rorig.Left, rorig.Bottom + 20, rorig.Right, r.Bottom + 45);
  APDFLib.Graphics.Fill.Color := MakeGraphicsColor(219, 51, 24);
  APDFLib.Graphics.DrawRectangle(r);
  APDFLib.Graphics.Font.Color := gcBlack;
  tr := APDFLib.Graphics.DrawText('Obese class III', r, True);
  APDFLib.Graphics.DrawText('Obese class III', RectF(r.Left, r.Top + ((r.Bottom - r.Top) - (tr.Bottom - tr.Top)) / 2, r.Right, r.Top + ((r.Bottom - r.Top) - (tr.Bottom - tr.Top)) / 2 + (tr.Bottom - tr.Top)));

  r := RectF(r.Right + 20, r.Top, r.Right + 150, r.Bottom);
  APDFLib.Graphics.Fill.Color := MakeGraphicsColor(224, 112, 38);
  APDFLib.Graphics.DrawRectangle(r);
  tr := APDFLib.Graphics.DrawText('Obese Class II', r, True);
  APDFLib.Graphics.DrawText('Obese Class II', RectF(r.Left, r.Top + ((r.Bottom - r.Top) - (tr.Bottom - tr.Top)) / 2, r.Right, r.Top + ((r.Bottom - r.Top) - (tr.Bottom - tr.Top)) / 2 + (tr.Bottom - tr.Top)));

  r := RectF(r.Right + 20, r.Top, r.Right + 150, r.Bottom);
  APDFLib.Graphics.Fill.Color := MakeGraphicsColor(223, 163, 111);
  APDFLib.Graphics.DrawRectangle(r);
  tr := APDFLib.Graphics.DrawText('Obese Class I', r, True);
  APDFLib.Graphics.DrawText('Obese Class I', RectF(r.Left, r.Top + ((r.Bottom - r.Top) - (tr.Bottom - tr.Top)) / 2, r.Right, r.Top + ((r.Bottom - r.Top) - (tr.Bottom - tr.Top)) / 2 + (tr.Bottom - tr.Top)));

  r := RectF(r.Right + 20, r.Top, r.Right + 150, r.Bottom);
  APDFLib.Graphics.Fill.Color := MakeGraphicsColor(222, 200, 156);
  APDFLib.Graphics.DrawRectangle(r);
  tr := APDFLib.Graphics.DrawText('Pre Obese', r, True);
  APDFLib.Graphics.DrawText('Pre Obese', RectF(r.Left, r.Top + ((r.Bottom - r.Top) - (tr.Bottom - tr.Top)) / 2, r.Right, r.Top + ((r.Bottom - r.Top) - (tr.Bottom - tr.Top)) / 2 + (tr.Bottom - tr.Top)));


  s := 'The <b>body mass index (BMI)</b> or <b>Quetelet index</b> is a value derived from the mass (weight) and height of a person. The BMI is defined as the body mass divided '+
  'by the square of the body height, and is universally expressed in units of kg/m2, resulting from mass in kilograms and height in metres.';
  s := s + '<br><br>The BMI may also be determined using a table or chart which displays BMI as a function of mass and height usi'+
  'ng contour lines or colours for different BMI categories, and which may use other units of measurement (converted to metr'+
  'ic units for the calculation).';
  APDFLib.Graphics.DrawHTMLText(s, RectF(100, 180 + FGauge.Height + 20, 400, 180 + FGauge.Height + 100));

  APDFLib.FooterMargins.Left := 0;
  APDFLib.FooterMargins.Top := 0;
  APDFLib.FooterMargins.Right := 0;
  APDFLib.FooterMargins.Bottom := 0;

  r := APDFLib.GetFooterRect;

  APDFLib.Graphics.Fill.Color := gcOrange;
  APDFLib.Graphics.DrawRectangle(r);
  APDFLib.Graphics.Font.Color := gcBlack;
  APDFLib.Graphics.Alignment := gtaCenter;
  APDFLib.Graphics.DrawText('Copyright ' + IntToStr(YearOf(Now)) + ' tmssoftware.com', RectF(r.Left, r.Top + 5, r.Right, r.Bottom));
end;

procedure TPDFLibBMILogic.DoCalculateClicked(Sender: TObject);
begin
  FName := FEditName.Text;
  FWeight := FEditWeight.Text;
  FHeight := FEditHeight.Text;

  FHeightNum := FEditHeight.FloatValue / 100;
  FWeightNum := FEditWeight.FloatValue;

  if FHeightNum > 0 then
    FGauge.Value := FWeightNum / (FHeightNum * FHeightNum)
  else
    FGauge.Value := 10;

  UpdateCells;
end;

procedure TPDFLibBMILogic.DoCanCreateNewPage(Sender: TObject; const APDFLib: TTMSFNCPDFLib; const AExportObject: TTMSFNCPDFIOExportObject;  var ACanCreate: Boolean);
begin
  ACanCreate := (APDFLib.GetPageCount = 0);
end;

procedure TPDFLibBMILogic.DoCellAfterDraw(Sender: TObject; AGraphics: TTMSFNCGraphics; ACell: TTMSFNCDataGridCell);
begin
  if (ACell.Column = 0) and (ACell.Row = 1) then
  begin
    {$IFDEF WEBLIB}
    AGraphics.Font.Name := 'Roboto';
    {$ENDIF}
    AGraphics.DrawText(ACell.TextRect, ACell.Text, ACell.Layout.WordWrapping, ACell.Layout.TextAlign, ACell.Layout.VerticalTextAlign, gttNone, -90, -1, -1);
  end;
end;

procedure TPDFLibBMILogic.DoCellBeforeDraw(Sender: TObject; AGraphics: TTMSFNCGraphics; ACell: TTMSFNCDataGridCell; var ACanDraw: Boolean);
begin
  if (ACell.Column = 0) and (ACell.Row = 1) then
    ACell.DrawElements := ACell.DrawElements - [gcdText];
end;

procedure TPDFLibBMILogic.DoExportClicked(Sender: TObject);

  {$IFDEF WEBLIB}
  procedure DoPrint;
  begin
    GeneratePDF();
    FAni.Hide;
  end;
  {$ENDIF}
begin
  {$IFDEF WEBLIB}
  FAni.Show;
  asm
    setTimeout(function() {DoPrint();}, 1000);
  end;
  {$ENDIF}
  {$IFNDEF WEBLIB}
  GeneratePDF;
  {$ENDIF}
end;

procedure TPDFLibBMILogic.DoDownloadComplete(Sender: TObject; ItemIndex: Integer);
begin
  FExportButton.Enabled := True;
end;

procedure TPDFLibBMILogic.DoFontCacheReady(Sender: TObject);
begin
  FExportButton.Enabled := True;
end;

procedure TPDFLibBMILogic.GeneratePDF;
var
  fn: string;
  o: TTMSFNCPDFIOExportObjectArray;
  r: TTMSFNCPDFIOExportRectArray;
  ms: TMemoryStream;
begin
  {$IFDEF ANDROID}
  fn := TPath.GetDocumentsPath + PathDelim + 'BMI.pdf';
  {$ENDIF}
  {$IFDEF MACOS}
  fn := TPath.GetDocumentsPath + PathDelim + 'BMI.pdf';
  {$ENDIF}
  {$IFDEF LINUX}
  fn := TPath.GetDocumentsPath + PathDelim + 'BMI.pdf';
  {$ENDIF}
  {$IFNDEF LINUX}
  {$IFNDEF ANDROID}
  {$IFNDEF MACOS}
  fn := 'BMI.pdf';
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}
  p.Options.Header := 'BMI Report for ' + FName;
  SetLength(o, 2);
  o[0] := FGauge;
  o[1] := FGrid;
  SetLength(r, 2);
  r[0] := RectF(50, 180, 50 + FGauge.Width, 180 + FGauge.Height);
  r[1] := RectF(50 + FGauge.Width + 50, 180, 50 + FGauge.Width + 50 + FGrid.Width, 180 + FGrid.Height);
  ms := TMemoryStream.Create;
  try
    p.Save(ms, o, r);
    ms.SaveToFile(fn);
    {$IFNDEF WEBLIB}
    TTMSFNCUtils.OpenFile(fn);
    {$ENDIF}
  finally
    ms.Free;
  end;
end;

procedure TPDFLibBMILogic.InitPDFLibBMI(AForm: TCustomForm);
var
{$IFDEF WEBLIB}
  pth: string;
{$ENDIF}
  lbl: TLabel;
  c: Integer;
  r: Integer;
  sc: TTMSFNCWidgetGaugeSection;
  I: Integer;
begin
  {$IFDEF WEBLIB}
  asm
    var loc = window.location.href;
    var dir = loc.substring(0, loc.lastIndexOf('/'));
    pth = dir;
  end;

  Application.OnFontCacheReady := DoFontCacheReady;
  AddFontToCache('https://download.tmssoftware.com/tmsweb/pdf/fonts/Roboto-Regular.ttf');
  AddFontToCache('https://download.tmssoftware.com/tmsweb/pdf/fonts/Roboto-Bold.ttf');
  AddFontToCache('https://download.tmssoftware.com/tmsweb/pdf/fonts/Roboto-BoldItalic.ttf');
  AddFontToCache('https://download.tmssoftware.com/tmsweb/pdf/fonts/Roboto-Italic.ttf');
  {$ENDIF}

  FForm := AForm;

  b := TTMSFNCURLBitmapContainer.Create(FForm);
  {$IFDEF WEBLIB}
  b.AddFromURL(pth + '/TMS_LOGO_rgb_high.jpg', 'TMS_LOGO_rgb_high.jpg');
  {$ELSE}
  b.AddFromURL('https://www.tmssoftware.com/site/img/TMS_LOGO_rgb_high.jpg', 'TMS_LOGO_rgb_high.jpg');
  b.OnDownloadComplete := {$IFDEF LCL}@{$ENDIF}DoDownloadComplete;
  {$ENDIF}

  p := TTMSFNCGraphicsPDFIO.Create(FForm);
  p.BitmapContainer := b;
  p.Options.PageSize := psA3;
  p.Options.Footer := '';
  p.Options.PageOrientation := poLandscape;
  p.Options.OpenInPDFReader := True;
  p.OnAfterDraw := {$IFDEF LCL}@{$ENDIF}DoAfterDraw;
  p.OnCanCreateNewPage := {$IFDEF LCL}@{$ENDIF}DoCanCreateNewPage;
  {$IFDEF WEBLIB}
  p.Options.DefaultFont.Name := 'Roboto';
  p.Options.HeaderFont.Name := 'Roboto';
  p.Options.FooterFont.Name := 'Roboto';
  p.Options.PageNumberFont.Name := 'Roboto';
  p.Options.FontFallBackList.Insert(0, 'Roboto');
  {$ENDIF}

  lbl := TLabel.Create(FForm);
  lbl.Parent := FForm;
  {$IFDEF FMX}
  lbl.Position.X := 10;
  lbl.Position.Y := 10;
  lbl.Text := 'Name:';
  {$ELSE}
  lbl.Left := 10;
  lbl.Top := 10;
  lbl.Caption := 'Name:';
  {$ENDIF}
  lbl.AutoSize := True;

  FEditName := TTMSFNCEdit.Create(FForm);
  FEditName.Parent := FForm;
  {$IFDEF FMX}
  FEditName.Position.X := 100;
  FEditName.Position.Y := 10;
  {$ELSE}
  FEditName.Left := 100;
  FEditName.Top := 10;
  {$ENDIF}
  FEditName.EditType := etString;

  lbl := TLabel.Create(FForm);
  lbl.Parent := FForm;
  {$IFDEF FMX}
  lbl.Position.X := 10;
  lbl.Position.Y := 40;
  lbl.Text := 'Weight (kg):';
  {$ELSE}
  lbl.Left := 10;
  lbl.Top := 40;
  lbl.Caption := 'Weight (kg):';
  {$ENDIF}
  lbl.AutoSize := True;

  FEditWeight := TTMSFNCEdit.Create(FForm);
  FEditWeight.Parent := FForm;
  {$IFDEF FMX}
  FEditWeight.Position.X := 100;
  FEditWeight.Position.Y := 40;
  {$ELSE}
  FEditWeight.Left := 100;
  FEditWeight.Top := 40;
  {$ENDIF}
  FEditWeight.EditType := etNumeric;

  lbl := TLabel.Create(FForm);
  lbl.Parent := FForm;
  {$IFDEF FMX}
  lbl.Position.X := 10;
  lbl.Position.Y := 70;
  lbl.Text := 'Height (cm):';
  {$ELSE}
  lbl.Left := 10;
  lbl.Top := 70;
  lbl.Caption := 'Height (cm):';
  {$ENDIF}
  lbl.AutoSize := True;

  FEditHeight := TTMSFNCEdit.Create(FForm);
  FEditHeight.Parent := FForm;
  {$IFDEF FMX}
  FEditHeight.Position.X := 100;
  FEditHeight.Position.Y := 70;
  {$ELSE}
  FEditHeight.Left := 100;
  FEditHeight.Top := 70;
  {$ENDIF}
  FEditHeight.EditType := etFloat;

  FCalculateButton := TButton.Create(FForm);
  FCalculateButton.Parent := FForm;
  {$IFDEF FMX}
  FCalculateButton.Position.X := 10;
  FCalculateButton.Position.Y := FEditHeight.Position.Y + FEditHeight.Height + 15;
  FCalculateButton.Text := 'Calculate';
  FCalculateButton.Width := FEditHeight.Position.X + FEditHeight.Width - 10;
  {$ELSE}
  FCalculateButton.Left := 10;
  FCalculateButton.Top := FEditHeight.Top + FEditHeight.Height + 15;
  FCalculateButton.Caption := 'Calculate';
  FCalculateButton.Width := FEditHeight.Left + FEditHeight.Width - 10;
  {$ENDIF}
  FCalculateButton.Height := 35;
  FCalculateButton.OnClick := {$IFDEF LCL}@{$ENDIF}DoCalculateClicked;
  FCalculateButton.Enabled := True;

  FExportButton := TButton.Create(FForm);
  FExportButton.Parent := FForm;
  {$IFDEF FMX}
  FExportButton.Position.X := 10;
  FExportButton.Position.Y := FCalculateButton.Position.Y + FCalculateButton.Height + 5;
  FExportButton.Text := 'Export To PDF';
  FExportButton.Width := FEditHeight.Position.X + FEditHeight.Width - 10;
  {$ELSE}
  FExportButton.Left := 10;
  FExportButton.Top := FCalculateButton.Top + FCalculateButton.Height + 5;
  FExportButton.Caption := 'Export To PDF';
  FExportButton.Width := FEditHeight.Left + FEditHeight.Width - 10;
  {$ENDIF}
  FExportButton.Height := 35;
  FExportButton.OnClick := {$IFDEF LCL}@{$ENDIF}DoExportClicked;
  FExportButton.Enabled := False;

  {$IFDEF WEBLIB}
  FAni := TWaitMessage.Create(FForm);
  FAni.Opacity := 0.75;
  FAni.Picture.LoadFromFile('https://download.tmssoftware.com/tmsweb/img/loader.gif');
  {$ENDIF}

  FGauge := TTMSFNCWidgetGauge.Create(FForm);
  FGauge.DisableBackground;
  FGauge.Border.Kind := gskNone;
  FGauge.Parent := FForm;
  FGauge.OuterCircle.Color := gcWhite;
  FGauge.InnerCircle.Color := gcWhite;
  FGauge.Digit.BackGroundColor := gcNull;
  FGauge.Digit.Color := gcDarkorange;
  FGauge.OuterRim.Color := gcDarkorange;
  FGauge.Arc.Threshold.Color := gcRed;
  FGauge.Arc.Threshold.StartValue := 25;
  FGauge.Arc.Threshold.EndValue := 47;
  FGauge.Arc.Threshold.Center := 36;
  FGauge.Arc.Threshold.Span := 20;
  FGauge.Arc.Threshold.ThresholdKind := tkValue;
  FGauge.Arc.Color := gcBisque;
  FGauge.Left := 10;
  FGauge.Top := 200;
  FGauge.MinimumValue := 10;
  FGauge.MaximumValue := 47;
  FGauge.BeginUpdate;
  sc := FGauge.Sections.Add;
  sc.Color := MakeGraphicsColor(158, 214, 238);
  sc.StartValue := 10;
  sc.EndValue := 18;
  sc := FGauge.Sections.Add;
  sc.StartValue := 18;
  sc.EndValue := 25;
  sc.Color := MakeGraphicsColor(181, 235, 106);
  sc := FGauge.Sections.Add;
  sc.StartValue := 25;
  sc.EndValue := 47;
  sc.Color := MakeGraphicsColor(223, 163, 111);
  FGauge.Value := 10;
  for I := 0 to FGauge.Sections.Count - 1 do
  begin
    FGauge.Sections[I].OuterMargin := 35;
    FGauge.Sections[I].InnerMargin := 50;
  end;

  FGauge.EndUpdate;

  FEditWeight.Text := '78';
  FEditHeight.Text := '182';
  FEditName.Text := 'John Doe';

  FName := FEditName.Text;
  FWeight := FEditWeight.Text;
  FHeight := FEditHeight.Text;

  FHeightNum := FEditHeight.FloatValue / 100;
  FWeightNum := FEditWeight.FloatValue;

  FGauge.Animation := False;

  if FHeightNum > 0 then
    FGauge.Value := FWeightNum / (FHeightNum * FHeightNum)
  else
    FGauge.Value := 10;

  FGauge.Animation := True;

  FGrid := TTMSFNCDataGrid.Create(FForm);
  FGrid.Parent := FForm;

  FGrid.BeginUpdate;
  FGrid.DefaultColumnWidth := 25;
  FGrid.DefaultRowHeight := 20;
  FGrid.RowCount := 23;
  FGrid.ColumnCount := 26;
  {$IFDEF FMX}
  FGrid.Position.X := FGauge.Position.X + FGauge.Width + 20;
  FGrid.Position.Y := 10;
  {$ELSE}
  FGrid.Left := FGauge.Left + FGauge.Width + 20;
  FGrid.Top := 10;
  {$ENDIF}

  FGrid.Width := Round((FGrid.ColumnCount - 1) * FGrid.DefaultColumnWidth + 40);
  FGrid.Height := Round((FGrid.RowCount - 1) * FGrid.DefaultRowHeight + 40);

  FGrid.CellAppearance.NormalLayout.Stroke.Kind := gskNone;
  FGrid.CellAppearance.FixedLayout.Stroke.Kind := gskNone;
  FGrid.CellAppearance.FixedLayout.Fill.Kind := gfkSolid;
  FGrid.CellAppearance.FixedLayout.Fill.Color := gcWhite;

  {$IFDEF WEBLIB}
  FGrid.CellAppearance.NormalLayout.Font.Name := 'Roboto';
  FGrid.CellAppearance.FixedLayout.Font.Name := 'Roboto';
  {$ENDIF}

  FGrid.OnBeforeDrawCell := {$IFDEF LCL}@{$ENDIF}DoCellBeforeDraw;
  FGrid.OnAfterDrawCell := {$IFDEF LCL}@{$ENDIF}DoCellAfterDraw;

  FGrid.Cells[1, 0] := 'Height, cm';
  FGrid.MergeCells(1, 0, FGrid.ColumnCount - 1, 1);
  FGrid.TextAligns[1, 0] := gtaCenter;
  FGrid.FontSizes[1, 0] := 16;

  FGrid.Cells[0, 1] := 'Weight, kg';
  FGrid.TextAngles[0, 1] :=  -90;
  FGrid.MergeCells(0, 1, 1, FGrid.RowCount - 1);
  FGrid.TextAligns[0, 1] := gtaCenter;
  FGrid.FontSizes[0, 1] := 16;

  FGrid.RowHeights[0] := 40;
  FGrid.ColumnWidths[0] := 40;

  for c := 2 to FGrid.ColumnCount - 1 do
  begin
    FGrid.Cells[c, 1] := IntToStr(145 + ((c - 2) * 2));
    FGrid.TextAligns[c, 1] := gtaCenter;
    FGrid.FontStyles[c, 1] := [TFontStyle.fsBold];
    FGrid.Colors[c, 1] := gcWhite;
  end;

  for r := 2 to FGrid.RowCount - 1 do
  begin
    FGrid.Cells[1, r] := IntToStr(40 + ((r - 2) * 3));
    FGrid.TextAligns[1, r] := gtaCenter;
    FGrid.FontStyles[1, r] := [TFontStyle.fsBold];
    FGrid.Colors[1, r] := gcWhite;
  end;

  UpdateCells;

  FGrid.Options.Selection.Mode := gsmNone;
  FGrid.EndUpdate;
end;

procedure TPDFLibBMILogic.UpdateCells;
var
  c, cx, r, rx: Integer;
  w, h, v: Single;
  iv: Integer;
begin
  FGrid.BeginUpdate;
  cx := -1;
  rx := -1;
  for c := 2 to FGrid.ColumnCount - 1 do
  begin
    h := FGrid.Floats[c, 1] / 100;
    if FHeightNum >= h then
      cx := c;

    for r := 2 to FGrid.RowCount - 1 do
    begin
      w := FGrid.Floats[1, r];
      v := w / (h * h);
      iv := Floor(v);
      FGrid.Cells[c, r] := IntToStr(iv);
      FGrid.TextAligns[c, r] := gtaCenter;
      FGrid.FontColors[c, r] := gcBlack;
      if v < 16 then
      begin
        FGrid.Colors[c, r] := MakeGraphicsColor(72,119,198);
        FGrid.FontColors[c, r] := gcWhite;
      end
      else if v < 17 then
      begin
        FGrid.Colors[c, r] := MakeGraphicsColor(92,150
        ,248);
        FGrid.FontColors[c, r] := gcWhite;
      end
      else if v < 18.5 then
        FGrid.Colors[c, r] := MakeGraphicsColor(158,214,238)
      else if v < 25 then
        FGrid.Colors[c, r] := MakeGraphicsColor(181,235,106)
      else if v < 30 then
        FGrid.Colors[c, r] := MakeGraphicsColor(222,200,156)
      else if v < 35 then
        FGrid.Colors[c, r] := MakeGraphicsColor(223,163,111)
      else if v < 40 then
        FGrid.Colors[c, r] := MakeGraphicsColor(224,112,38)
      else
        FGrid.Colors[c, r] := MakeGraphicsColor(219,51,24);

      if FWeightNum >= w then
        rx := r;
    end;
  end;

  if (cx <> -1) and (rx <> -1) then
  begin
    FGrid.Colors[cx, rx] := gcWhite;
    FGrid.FontColors[cx, rx] := gcRed;
  end;

  FGrid.EndUpdate;
end;

end.
