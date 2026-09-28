unit UTimelinePositionsDemo;

interface

uses
  System.SysUtils, System.Classes, JS, Web, WEBLib.Graphics, WEBLib.Controls,
  WEBLib.Forms, WEBLib.Dialogs, VCL.TMSFNCTypes, VCL.TMSFNCUtils,
  VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, Vcl.StdCtrls, WEBLib.StdCtrls,
  Vcl.Controls, WEBLib.ExtCtrls, VCL.TMSFNCCustomControl,
  VCL.TMSFNCCustomScrollControl, VCL.TMSFNCTimeline, Vcl.ExtCtrls;

type
  TForm1 = class(TWebForm)
    TMSFNCTimeline1: TTMSFNCTimeline;
    TMSFNCTimeline2: TTMSFNCTimeline;
    ScrollBox1: TWebScrollBox;
    Panel1: TPanel;
    Label1: TWebLabel;
    Label2: TWebLabel;
    BtnAnnoLeft: TWebButton;
    BtnAnnoMiddle: TWebButton;
    BtnAnnoRight: TWebButton;
    BtnAnnoLeading: TWebButton;
    BtnAnnoCenter: TWebButton;
    BtnAnnoTrailing: TWebButton;
    Label4: TWebLabel;
    BtnAnnoTxtHorLeading: TWebButton;
    BtnAnnoTxtHorCenter: TWebButton;
    BtnAnnoTxtHorTrailing: TWebButton;
    Label7: TWebLabel;
    Label8: TWebLabel;
    Label5: TWebLabel;
    BtnAnnoTxtVerLeading: TWebButton;
    BtnAnnoTxtVerCenter: TWebButton;
    BtnAnnoTxtVerTrailing: TWebButton;
    Panel2: TPanel;
    Label6: TWebLabel;
    Label9: TWebLabel;
    Label10: TWebLabel;
    Label11: TWebLabel;
    Label12: TWebLabel;
    Label13: TWebLabel;
    Label14: TWebLabel;
    BtnTlLeft: TWebButton;
    BtnTlMiddle: TWebButton;
    BtnTlRight: TWebButton;
    BtnDivLeft: TWebButton;
    BtnDivMiddle: TWebButton;
    BtnDivRight: TWebButton;
    BtnTxtLeading: TWebButton;
    BtnTxtCenter: TWebButton;
    BtnTxtTrailing: TWebButton;
    BtnTxtHor: TWebButton;
    BtnTxtUpDown: TWebButton;
    BtnTxtLeft: TWebButton;
    BtnTxtRight: TWebButton;
    Label3: TWebLabel;
    BtnAnnoTxtHor: TWebButton;
    BtnAnnoTxtUpDown: TWebButton;
    BtnAnnoTxtLeft: TWebButton;
    BtnAnnoTxtRight: TWebButton;
    procedure BtnTlLeftClick(Sender: TObject);
    procedure BtnTlMiddleClick(Sender: TObject);
    procedure BtnTlRightClick(Sender: TObject);
    procedure BtnDivLeftClick(Sender: TObject);
    procedure BtnDivMiddleClick(Sender: TObject);
    procedure BtnDivRightClick(Sender: TObject);
    procedure BtnTxtLeadingClick(Sender: TObject);
    procedure BtnTxtCenterClick(Sender: TObject);
    procedure BtnTxtTrailingClick(Sender: TObject);
    procedure BtnTxtUpDownClick(Sender: TObject);
    procedure BtnTxtLeftClick(Sender: TObject);
    procedure BtnTxtRightClick(Sender: TObject);
    procedure BtnAnnoLeftClick(Sender: TObject);
    procedure BtnAnnoMiddleClick(Sender: TObject);
    procedure BtnAnnoRightClick(Sender: TObject);
    procedure BtnAnnoLeadingClick(Sender: TObject);
    procedure BtnAnnoCenterClick(Sender: TObject);
    procedure BtnAnnoTrailingClick(Sender: TObject);
    procedure BtnAnnoTxtHorLeadingClick(Sender: TObject);
    procedure BtnAnnoTxtHorCenterClick(Sender: TObject);
    procedure BtnAnnoTxtHorTrailingClick(Sender: TObject);
    procedure BtnAnnoTxtVerLeadingClick(Sender: TObject);
    procedure BtnAnnoTxtVerCenterClick(Sender: TObject);
    procedure BtnAnnoTxtVerTrailingClick(Sender: TObject);
    procedure BtnAnnoTxtHorClick(Sender: TObject);
    procedure BtnAnnoTxtUpDownClick(Sender: TObject);
    procedure BtnAnnoTxtLeftClick(Sender: TObject);
    procedure BtnAnnoTxtRightClick(Sender: TObject);
    procedure BtnTxtHorClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.BtnAnnoCenterClick(Sender: TObject);
var
  I: Integer;
begin
  if Assigned(TMSFNCTimeline1) then
  begin
    for I := 0 to TMSFNCTimeline1.Indicators.Count - 1 do
    begin
      TMSFNCTimeline1.Indicators[I].Annotation.Appearance.Alignment := gtaCenter;
    end;
  end;
  if Assigned(TMSFNCTimeline2) then
  begin
    for I := 0 to TMSFNCTimeline2.Indicators.Count - 1 do
    begin
      TMSFNCTimeline2.Indicators[I].Annotation.Appearance.Alignment := gtaCenter;
    end;
  end;

  BtnAnnoLeading.Font.Style := [];
  BtnAnnoCenter.Font.Style := [TFontStyle.fsUnderline];
  BtnAnnoTrailing.Font.Style := [];
end;

procedure TForm1.BtnAnnoLeadingClick(Sender: TObject);
var
  I: Integer;
begin
  if Assigned(TMSFNCTimeline1) then
  begin
    for I := 0 to TMSFNCTimeline1.Indicators.Count - 1 do
    begin
      TMSFNCTimeline1.Indicators[I].Annotation.Appearance.Alignment := gtaLeading;
    end;
  end;
  if Assigned(TMSFNCTimeline2) then
  begin
    for I := 0 to TMSFNCTimeline2.Indicators.Count - 1 do
    begin
      TMSFNCTimeline2.Indicators[I].Annotation.Appearance.Alignment := gtaLeading;
    end;
  end;

  BtnAnnoLeading.Font.Style := [TFontStyle.fsUnderline];
  BtnAnnoCenter.Font.Style := [];
  BtnAnnoTrailing.Font.Style := [];
end;

procedure TForm1.BtnAnnoLeftClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to TMSFNCTimeline1.Indicators.Count - 1 do
  begin
    TMSFNCTimeline1.Indicators[I].Annotation.Position := tlapTopLeft;
  end;
  for I := 0 to TMSFNCTimeline2.Indicators.Count - 1 do
  begin
    TMSFNCTimeline2.Indicators[I].Annotation.Position := tlapTopLeft;
  end;

  BtnDivLeft.Font.Style := [TFontStyle.fsUnderline];
  BtnDivMiddle.Font.Style := [];
  BtnDivRight.Font.Style := [];
end;

procedure TForm1.BtnAnnoMiddleClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to TMSFNCTimeline1.Indicators.Count - 1 do
  begin
    TMSFNCTimeline1.Indicators[I].Annotation.Position := tlapMiddle;
  end;
  for I := 0 to TMSFNCTimeline2.Indicators.Count - 1 do
  begin
    TMSFNCTimeline2.Indicators[I].Annotation.Position := tlapMiddle;
  end;

  BtnDivLeft.Font.Style := [];
  BtnDivMiddle.Font.Style := [TFontStyle.fsUnderline];
  BtnDivRight.Font.Style := [];
end;

procedure TForm1.BtnAnnoRightClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to TMSFNCTimeline1.Indicators.Count - 1 do
  begin
    TMSFNCTimeline1.Indicators[I].Annotation.Position := tlapBottomRight;
  end;
  for I := 0 to TMSFNCTimeline2.Indicators.Count - 1 do
  begin
    TMSFNCTimeline2.Indicators[I].Annotation.Position := tlapBottomRight;
  end;

  BtnDivLeft.Font.Style := [];
  BtnDivMiddle.Font.Style := [];
  BtnDivRight.Font.Style := [TFontStyle.fsUnderline];
end;

procedure TForm1.BtnAnnoTrailingClick(Sender: TObject);
var
  I: Integer;
begin
  if Assigned(TMSFNCTimeline1) then
  begin
    for I := 0 to TMSFNCTimeline1.Indicators.Count - 1 do
    begin
      TMSFNCTimeline1.Indicators[I].Annotation.Appearance.Alignment := gtaTrailing;
    end;
  end;
  if Assigned(TMSFNCTimeline2) then
  begin
    for I := 0 to TMSFNCTimeline2.Indicators.Count - 1 do
    begin
      TMSFNCTimeline2.Indicators[I].Annotation.Appearance.Alignment := gtaTrailing;
    end;
  end;

  BtnAnnoLeading.Font.Style := [];
  BtnAnnoCenter.Font.Style := [];
  BtnAnnoTrailing.Font.Style := [TFontStyle.fsUnderline];
end;

procedure TForm1.BtnAnnoTxtHorCenterClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to TMSFNCTimeline1.Indicators.Count - 1 do
  begin
    TMSFNCTimeline1.Indicators[I].Annotation.Appearance.TextHorizontalAlign := gtaCenter;
  end;
  for I := 0 to TMSFNCTimeline2.Indicators.Count - 1 do
  begin
    TMSFNCTimeline2.Indicators[I].Annotation.Appearance.TextHorizontalAlign := gtaCenter;
  end;

  for I := 0 to TMSFNCTimeline1.Sections.Count - 1 do
  begin
    TMSFNCTimeline1.Sections[I].Appearance.TextHorizontalAlign := gtaCenter;
  end;
  for I := 0 to TMSFNCTimeline2.Sections.Count - 1 do
  begin
    TMSFNCTimeline2.Sections[I].Appearance.TextHorizontalAlign := gtaCenter;
  end;

  BtnAnnoTxtHorLeading.Font.Style := [];
  BtnAnnoTxtHorCenter.Font.Style := [TFontStyle.fsUnderline];
  BtnAnnoTxtHorTrailing.Font.Style := [];
end;

procedure TForm1.BtnAnnoTxtHorClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to TMSFNCTimeline1.Indicators.Count - 1 do
  begin
    TMSFNCTimeline1.Indicators[I].Annotation.Appearance.TextOrientation := tltoHorizontal;
  end;
  for I := 0 to TMSFNCTimeline2.Indicators.Count - 1 do
  begin
    TMSFNCTimeline2.Indicators[I].Annotation.Appearance.TextOrientation := tltoHorizontal;
  end;

  for I := 0 to TMSFNCTimeline1.Sections.Count - 1 do
  begin
    TMSFNCTimeline1.Sections[I].Appearance.TextOrientation := tltoHorizontal;
  end;
  for I := 0 to TMSFNCTimeline2.Sections.Count - 1 do
  begin
    TMSFNCTimeline2.Sections[I].Appearance.TextOrientation := tltoHorizontal;
  end;

  BtnAnnoTxtHor.Font.Style := [TFontStyle.fsUnderline];
  BtnAnnoTxtUpDown.Font.Style := [];
  BtnAnnoTxtLeft.Font.Style := [];
  BtnAnnoTxtRight.Font.Style := [];
end;

procedure TForm1.BtnAnnoTxtHorLeadingClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to TMSFNCTimeline1.Indicators.Count - 1 do
  begin
    TMSFNCTimeline1.Indicators[I].Annotation.Appearance.TextHorizontalAlign := gtaLeading;
  end;
  for I := 0 to TMSFNCTimeline2.Indicators.Count - 1 do
  begin
    TMSFNCTimeline2.Indicators[I].Annotation.Appearance.TextHorizontalAlign := gtaLeading;
  end;

  for I := 0 to TMSFNCTimeline1.Sections.Count - 1 do
  begin
    TMSFNCTimeline1.Sections[I].Appearance.TextHorizontalAlign := gtaLeading;
  end;
  for I := 0 to TMSFNCTimeline2.Sections.Count - 1 do
  begin
    TMSFNCTimeline2.Sections[I].Appearance.TextHorizontalAlign := gtaLeading;
  end;

  BtnAnnoTxtHorLeading.Font.Style := [TFontStyle.fsUnderline];
  BtnAnnoTxtHorCenter.Font.Style := [];
  BtnAnnoTxtHorTrailing.Font.Style := [];
end;

procedure TForm1.BtnAnnoTxtHorTrailingClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to TMSFNCTimeline1.Indicators.Count - 1 do
  begin
    TMSFNCTimeline1.Indicators[I].Annotation.Appearance.TextHorizontalAlign := gtaTrailing;
  end;
  for I := 0 to TMSFNCTimeline2.Indicators.Count - 1 do
  begin
    TMSFNCTimeline2.Indicators[I].Annotation.Appearance.TextHorizontalAlign := gtaTrailing;
  end;

  for I := 0 to TMSFNCTimeline1.Sections.Count - 1 do
  begin
    TMSFNCTimeline1.Sections[I].Appearance.TextHorizontalAlign := gtaTrailing;
  end;
  for I := 0 to TMSFNCTimeline2.Sections.Count - 1 do
  begin
    TMSFNCTimeline2.Sections[I].Appearance.TextHorizontalAlign := gtaTrailing;
  end;

  BtnAnnoTxtHorLeading.Font.Style := [];
  BtnAnnoTxtHorCenter.Font.Style := [];
  BtnAnnoTxtHorTrailing.Font.Style := [TFontStyle.fsUnderline];
end;

procedure TForm1.BtnAnnoTxtLeftClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to TMSFNCTimeline1.Indicators.Count - 1 do
  begin
    TMSFNCTimeline1.Indicators[I].Annotation.Appearance.TextOrientation := tltoLeft;
  end;
  for I := 0 to TMSFNCTimeline2.Indicators.Count - 1 do
  begin
    TMSFNCTimeline2.Indicators[I].Annotation.Appearance.TextOrientation := tltoLeft;
  end;

  for I := 0 to TMSFNCTimeline1.Sections.Count - 1 do
  begin
    TMSFNCTimeline1.Sections[I].Appearance.TextOrientation := tltoLeft;
  end;
  for I := 0 to TMSFNCTimeline2.Sections.Count - 1 do
  begin
    TMSFNCTimeline2.Sections[I].Appearance.TextOrientation := tltoLeft;
  end;

  BtnAnnoTxtHor.Font.Style := [];
  BtnAnnoTxtUpDown.Font.Style := [];
  BtnAnnoTxtLeft.Font.Style := [TFontStyle.fsUnderline];
  BtnAnnoTxtRight.Font.Style := [];
end;

procedure TForm1.BtnAnnoTxtRightClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to TMSFNCTimeline1.Indicators.Count - 1 do
  begin
    TMSFNCTimeline1.Indicators[I].Annotation.Appearance.TextOrientation := tltoRight;
  end;
  for I := 0 to TMSFNCTimeline2.Indicators.Count - 1 do
  begin
    TMSFNCTimeline2.Indicators[I].Annotation.Appearance.TextOrientation := tltoRight;
  end;

  for I := 0 to TMSFNCTimeline1.Sections.Count - 1 do
  begin
    TMSFNCTimeline1.Sections[I].Appearance.TextOrientation := tltoRight;
  end;
  for I := 0 to TMSFNCTimeline2.Sections.Count - 1 do
  begin
    TMSFNCTimeline2.Sections[I].Appearance.TextOrientation := tltoRight;
  end;

  BtnAnnoTxtHor.Font.Style := [];
  BtnAnnoTxtUpDown.Font.Style := [];
  BtnAnnoTxtLeft.Font.Style := [];
  BtnAnnoTxtRight.Font.Style := [TFontStyle.fsUnderline];
end;

procedure TForm1.BtnAnnoTxtUpDownClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to TMSFNCTimeline1.Indicators.Count - 1 do
  begin
    TMSFNCTimeline1.Indicators[I].Annotation.Appearance.TextOrientation := tltoUpsideDown;
  end;
  for I := 0 to TMSFNCTimeline2.Indicators.Count - 1 do
  begin
    TMSFNCTimeline2.Indicators[I].Annotation.Appearance.TextOrientation := tltoUpsideDown;
  end;

  for I := 0 to TMSFNCTimeline1.Sections.Count - 1 do
  begin
    TMSFNCTimeline1.Sections[I].Appearance.TextOrientation := tltoUpsideDown;
  end;
  for I := 0 to TMSFNCTimeline2.Sections.Count - 1 do
  begin
    TMSFNCTimeline2.Sections[I].Appearance.TextOrientation := tltoUpsideDown;
  end;

  BtnAnnoTxtHor.Font.Style := [];
  BtnAnnoTxtUpDown.Font.Style := [TFontStyle.fsUnderline];
  BtnAnnoTxtLeft.Font.Style := [];
  BtnAnnoTxtRight.Font.Style := [];
end;

procedure TForm1.BtnAnnoTxtVerCenterClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to TMSFNCTimeline1.Indicators.Count - 1 do
  begin
    TMSFNCTimeline1.Indicators[I].Annotation.Appearance.TextVerticalAlign := gtaCenter;
  end;
  for I := 0 to TMSFNCTimeline2.Indicators.Count - 1 do
  begin
    TMSFNCTimeline2.Indicators[I].Annotation.Appearance.TextVerticalAlign := gtaCenter;
  end;

  for I := 0 to TMSFNCTimeline1.Sections.Count - 1 do
  begin
    TMSFNCTimeline1.Sections[I].Appearance.TextVerticalAlign := gtaCenter;
  end;
  for I := 0 to TMSFNCTimeline2.Sections.Count - 1 do
  begin
    TMSFNCTimeline2.Sections[I].Appearance.TextVerticalAlign := gtaCenter;
  end;
end;

procedure TForm1.BtnAnnoTxtVerLeadingClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to TMSFNCTimeline1.Indicators.Count - 1 do
  begin
    TMSFNCTimeline1.Indicators[I].Annotation.Appearance.TextVerticalAlign := gtaLeading;
  end;
  for I := 0 to TMSFNCTimeline2.Indicators.Count - 1 do
  begin
    TMSFNCTimeline2.Indicators[I].Annotation.Appearance.TextVerticalAlign := gtaLeading;
  end;

  for I := 0 to TMSFNCTimeline1.Sections.Count - 1 do
  begin
    TMSFNCTimeline1.Sections[I].Appearance.TextVerticalAlign := gtaLeading;
  end;
  for I := 0 to TMSFNCTimeline2.Sections.Count - 1 do
  begin
    TMSFNCTimeline2.Sections[I].Appearance.TextVerticalAlign := gtaLeading;
  end;
end;

procedure TForm1.BtnAnnoTxtVerTrailingClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to TMSFNCTimeline1.Indicators.Count - 1 do
  begin
    TMSFNCTimeline1.Indicators[I].Annotation.Appearance.TextVerticalAlign := gtaTrailing;
  end;
  for I := 0 to TMSFNCTimeline2.Indicators.Count - 1 do
  begin
    TMSFNCTimeline2.Indicators[I].Annotation.Appearance.TextVerticalAlign := gtaTrailing;
  end;

  for I := 0 to TMSFNCTimeline1.Sections.Count - 1 do
  begin
    TMSFNCTimeline1.Sections[I].Appearance.TextVerticalAlign := gtaTrailing;
  end;
  for I := 0 to TMSFNCTimeline2.Sections.Count - 1 do
  begin
    TMSFNCTimeline2.Sections[I].Appearance.TextVerticalAlign := gtaTrailing;
  end;

  BtnAnnoTxtVerLeading.Font.Style := [];
  BtnAnnoTxtVerCenter.Font.Style := [];
  BtnAnnoTxtVerTrailing.Font.Style := [TFontStyle.fsUnderline];
end;

procedure TForm1.BtnDivLeftClick(Sender: TObject);
begin
  TMSFNCTimeline1.Division.Position := tlpTopLeft;
  TMSFNCTimeline2.Division.Position := tlpTopLeft;

  BtnDivLeft.Font.Style := [TFontStyle.fsUnderline];
  BtnDivMiddle.Font.Style := [];
  BtnDivRight.Font.Style := [];
end;

procedure TForm1.BtnDivMiddleClick(Sender: TObject);
begin
  TMSFNCTimeline1.Division.Position := tlpMiddle;
  TMSFNCTimeline2.Division.Position := tlpMiddle;

  BtnDivLeft.Font.Style := [];
  BtnDivMiddle.Font.Style := [TFontStyle.fsUnderline];
  BtnDivRight.Font.Style := [];
end;

procedure TForm1.BtnDivRightClick(Sender: TObject);
begin
  TMSFNCTimeline1.Division.Position := tlpBottomRight;
  TMSFNCTimeline2.Division.Position := tlpBottomRight;

  BtnDivLeft.Font.Style := [];
  BtnDivMiddle.Font.Style := [];
  BtnDivRight.Font.Style := [TFontStyle.fsUnderline];
end;

procedure TForm1.BtnTlLeftClick(Sender: TObject);
begin
  TMSFNCTimeline1.Layout.Position := tlpTopLeft;
  TMSFNCTimeline2.Layout.Position := tlpTopLeft;

  BtnTlLeft.Font.Style := [TFontStyle.fsUnderline];
  BtnTlMiddle.Font.Style := [];
  BtnTlRight.Font.Style := [];
end;

procedure TForm1.BtnTlMiddleClick(Sender: TObject);
begin
  TMSFNCTimeline1.Layout.Position := tlpMiddle;
  TMSFNCTimeline2.Layout.Position := tlpMiddle;

  BtnTlLeft.Font.Style := [];
  BtnTlMiddle.Font.Style := [TFontStyle.fsUnderline];
  BtnTlRight.Font.Style := [];
end;

procedure TForm1.BtnTlRightClick(Sender: TObject);
begin
  TMSFNCTimeline1.Layout.Position := tlpBottomRight;
  TMSFNCTimeline2.Layout.Position := tlpBottomRight;

  BtnTlLeft.Font.Style := [];
  BtnTlMiddle.Font.Style := [];
  BtnTlRight.Font.Style := [TFontStyle.fsUnderline];
end;

procedure TForm1.BtnTxtCenterClick(Sender: TObject);
begin
  TMSFNCTimeline1.Division.TextPosition := gtaCenter;
  TMSFNCTimeline2.Division.TextPosition := gtaCenter;

  BtnTxtLeading.Font.Style := [];
  BtnTxtCenter.Font.Style := [TFontStyle.fsUnderline];
  BtnTxtTrailing.Font.Style := [];
end;

procedure TForm1.BtnTxtHorClick(Sender: TObject);
begin
  TMSFNCTimeline1.Division.TextOrientation := tltoHorizontal;
  TMSFNCTimeline2.Division.TextOrientation := tltoHorizontal;

  BtnTxtHor.Font.Style := [TFontStyle.fsUnderline];
  BtnTxtUpDown.Font.Style := [];
  BtnTxtLeft.Font.Style := [];
  BtnTxtRight.Font.Style := [];
end;

procedure TForm1.BtnTxtLeadingClick(Sender: TObject);
begin
  TMSFNCTimeline1.Division.TextPosition := gtaLeading;
  TMSFNCTimeline2.Division.TextPosition := gtaLeading;

  BtnTxtLeading.Font.Style := [TFontStyle.fsUnderline];
  BtnTxtCenter.Font.Style := [];
  BtnTxtTrailing.Font.Style := [];
end;

procedure TForm1.BtnTxtLeftClick(Sender: TObject);
begin
  TMSFNCTimeline1.Division.TextOrientation := tltoLeft;
  TMSFNCTimeline2.Division.TextOrientation := tltoLeft;

  BtnTxtHor.Font.Style := [];
  BtnTxtUpDown.Font.Style := [];
  BtnTxtLeft.Font.Style := [TFontStyle.fsUnderline];
  BtnTxtRight.Font.Style := [];
end;

procedure TForm1.BtnTxtRightClick(Sender: TObject);
begin
  TMSFNCTimeline1.Division.TextOrientation := tltoRight;
  TMSFNCTimeline2.Division.TextOrientation := tltoRight;

  BtnTxtHor.Font.Style := [];
  BtnTxtUpDown.Font.Style := [];
  BtnTxtLeft.Font.Style := [];
  BtnTxtRight.Font.Style := [TFontStyle.fsUnderline];
end;

procedure TForm1.BtnTxtTrailingClick(Sender: TObject);
begin
  TMSFNCTimeline1.Division.TextPosition := gtaTrailing;
  TMSFNCTimeline2.Division.TextPosition := gtaTrailing;

  BtnTxtLeading.Font.Style := [];
  BtnTxtCenter.Font.Style := [];
  BtnTxtTrailing.Font.Style := [TFontStyle.fsUnderline];
end;

procedure TForm1.BtnTxtUpDownClick(Sender: TObject);
begin
  TMSFNCTimeline1.Division.TextOrientation := tltoUpsideDown;
  TMSFNCTimeline2.Division.TextOrientation := tltoUpsideDown;

  BtnTxtHor.Font.Style := [];
  BtnTxtUpDown.Font.Style := [TFontStyle.fsUnderline];
  BtnTxtLeft.Font.Style := [];
  BtnTxtRight.Font.Style := [];
end;

end.
