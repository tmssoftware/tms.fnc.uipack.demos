unit UTimelinePositionsDemo;

{ demo-colors: TMSFNCTimeline1, TMSFNCTimeline2 (the gradient timelines, sections and annotations are the subject) }

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VCL.TMSFNCTypes, VCL.TMSFNCUtils,
  VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes,
  VCL.TMSFNCCustomControl, VCL.TMSFNCCustomScrollControl, VCL.TMSFNCTimeline,
  VCL.TMSFNCHTMLText, VCL.TMSFNCPanel, VCL.TMSFNCComboBox, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector;

type
  TForm1 = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TTMSFNCPanel;
    DemoTitle: TTMSFNCHTMLText;
    DemoDescription: TTMSFNCHTMLText;
    DemoThemeSelector: TTMSFNCThemeSelector;
    TMSFNCTimeline1: TTMSFNCTimeline;
    TMSFNCTimeline2: TTMSFNCTimeline;
    TimelinePanel: TTMSFNCPanel;
    TimelineCaption: TTMSFNCHTMLText;
    AnnotationPanel: TTMSFNCPanel;
    AnnotationCaption: TTMSFNCHTMLText;
    TimelinePositionRow: TTMSFNCPanel;
    TimelinePositionLabel: TTMSFNCHTMLText;
    TimelinePositionCombo: TTMSFNCComboBox;
    DivisionPositionRow: TTMSFNCPanel;
    DivisionPositionLabel: TTMSFNCHTMLText;
    DivisionPositionCombo: TTMSFNCComboBox;
    DivisionTextRow: TTMSFNCPanel;
    DivisionTextLabel: TTMSFNCHTMLText;
    DivisionTextCombo: TTMSFNCComboBox;
    DivisionAngleRow: TTMSFNCPanel;
    DivisionAngleLabel: TTMSFNCHTMLText;
    DivisionAngleCombo: TTMSFNCComboBox;
    AnnotationPositionRow: TTMSFNCPanel;
    AnnotationPositionLabel: TTMSFNCHTMLText;
    AnnotationPositionCombo: TTMSFNCComboBox;
    AnnotationAlignRow: TTMSFNCPanel;
    AnnotationAlignLabel: TTMSFNCHTMLText;
    AnnotationAlignCombo: TTMSFNCComboBox;
    TextHorizontalRow: TTMSFNCPanel;
    TextHorizontalLabel: TTMSFNCHTMLText;
    TextHorizontalCombo: TTMSFNCComboBox;
    TextVerticalRow: TTMSFNCPanel;
    TextVerticalLabel: TTMSFNCHTMLText;
    TextVerticalCombo: TTMSFNCComboBox;
    TextAngleRow: TTMSFNCPanel;
    TextAngleLabel: TTMSFNCHTMLText;
    TextAngleCombo: TTMSFNCComboBox;
    procedure SettingChange(Sender: TObject);
  private
    procedure ApplySetting(ATimeline: TTMSFNCTimeline; ASetting: TObject);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function TextAlignOf(AIndex: Integer): TTMSFNCGraphicsTextAlign;
begin
  case AIndex of
    0: Result := gtaLeading;
    2: Result := gtaTrailing;
  else
    Result := gtaCenter;
  end;
end;

function PositionOf(AIndex: Integer): TTMSFNCTimelinePosition;
begin
  case AIndex of
    0: Result := tlpTopLeft;
    2: Result := tlpBottomRight;
  else
    Result := tlpMiddle;
  end;
end;

function AnnotationPositionOf(AIndex: Integer): TTMSFNCTimelineAnnotationPosition;
begin
  case AIndex of
    1: Result := tlapMiddle;
    2: Result := tlapBottomRight;
  else
    Result := tlapTopLeft;
  end;
end;

function OrientationOf(AIndex: Integer): TTMSFNCTimelineTextOrientation;
begin
  case AIndex of
    1: Result := tltoUpsideDown;
    2: Result := tltoLeft;
    3: Result := tltoRight;
  else
    Result := tltoHorizontal;
  end;
end;

procedure TForm1.ApplySetting(ATimeline: TTMSFNCTimeline; ASetting: TObject);
var
  I: Integer;
begin
  if ASetting = TimelinePositionCombo then
    ATimeline.Layout.Position := PositionOf(TimelinePositionCombo.ItemIndex)
  else if ASetting = DivisionPositionCombo then
    ATimeline.Division.Position := PositionOf(DivisionPositionCombo.ItemIndex)
  else if ASetting = DivisionTextCombo then
    ATimeline.Division.TextPosition := TextAlignOf(DivisionTextCombo.ItemIndex)
  else if ASetting = DivisionAngleCombo then
    ATimeline.Division.TextOrientation := OrientationOf(DivisionAngleCombo.ItemIndex)
  else
  begin
    for I := 0 to ATimeline.Indicators.Count - 1 do
    begin
      if ASetting = AnnotationPositionCombo then
        ATimeline.Indicators[I].Annotation.Position := AnnotationPositionOf(AnnotationPositionCombo.ItemIndex)
      else if ASetting = AnnotationAlignCombo then
        ATimeline.Indicators[I].Annotation.Appearance.Alignment := TextAlignOf(AnnotationAlignCombo.ItemIndex)
      else if ASetting = TextHorizontalCombo then
        ATimeline.Indicators[I].Annotation.Appearance.TextHorizontalAlign := TextAlignOf(TextHorizontalCombo.ItemIndex)
      else if ASetting = TextVerticalCombo then
        ATimeline.Indicators[I].Annotation.Appearance.TextVerticalAlign := TextAlignOf(TextVerticalCombo.ItemIndex)
      else if ASetting = TextAngleCombo then
        ATimeline.Indicators[I].Annotation.Appearance.TextOrientation := OrientationOf(TextAngleCombo.ItemIndex);
    end;

    for I := 0 to ATimeline.Sections.Count - 1 do
    begin
      if ASetting = TextHorizontalCombo then
        ATimeline.Sections[I].Appearance.TextHorizontalAlign := TextAlignOf(TextHorizontalCombo.ItemIndex)
      else if ASetting = TextVerticalCombo then
        ATimeline.Sections[I].Appearance.TextVerticalAlign := TextAlignOf(TextVerticalCombo.ItemIndex)
      else if ASetting = TextAngleCombo then
        ATimeline.Sections[I].Appearance.TextOrientation := OrientationOf(TextAngleCombo.ItemIndex);
    end;
  end;
end;

procedure TForm1.SettingChange(Sender: TObject);
begin
  if (csLoading in ComponentState) or not Assigned(TMSFNCTimeline1) or not Assigned(TMSFNCTimeline2) then
    Exit;

  ApplySetting(TMSFNCTimeline1, Sender);
  ApplySetting(TMSFNCTimeline2, Sender);
end;

end.
