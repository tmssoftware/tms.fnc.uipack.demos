unit UTimelineSettings;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.TMSFNCTimeline, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCCustomControl,
  FMX.TMSFNCCustomScrollControl;

type
  TForm3 = class(TForm)
    PanelSettings: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    DivPosLeft: TButton;
    DivPosRight: TButton;
    DivPosMiddle: TButton;
    Label3: TLabel;
    Label4: TLabel;
    BtnTextLeading: TButton;
    BtnTextTrailing: TButton;
    BtnTextCenter: TButton;
    Label5: TLabel;
    BtnTextHor: TButton;
    BtnTextUpDown: TButton;
    BtnTextLeft: TButton;
    BtnTextRight: TButton;
    ScrollBox1: TScrollBox;
    Label6: TLabel;
    Label7: TLabel;
    BtnTLLeft: TButton;
    BtnTLCenter: TButton;
    BtnTLRight: TButton;
    Panel1: TPanel;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Label13: TLabel;
    Label14: TLabel;
    Label8: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label9: TLabel;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    TMSFNCTimeline1: TTMSFNCTimeline;
    TMSFNCTimeline2: TTMSFNCTimeline;
    procedure DivPosLeftClick(Sender: TObject);
    procedure BtnTLLeftClick(Sender: TObject);
    procedure BtnTLCenterClick(Sender: TObject);
    procedure BtnTLRightClick(Sender: TObject);
    procedure DivPosMiddleClick(Sender: TObject);
    procedure DivPosRightClick(Sender: TObject);
    procedure BtnTextLeadingClick(Sender: TObject);
    procedure BtnTextCenterClick(Sender: TObject);
    procedure BtnTextTrailingClick(Sender: TObject);
    procedure BtnTextHorClick(Sender: TObject);
    procedure BtnTextUpDownClick(Sender: TObject);
    procedure BtnTextLeftClick(Sender: TObject);
    procedure BtnTextRightClick(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses
  DateUtils;

{$R *.fmx}

procedure TForm3.BtnTextCenterClick(Sender: TObject);
begin
  TMSFNCTimeline1.Division.TextPosition := gtaCenter;
  TMSFNCTimeline2.Division.TextPosition := gtaCenter;

  BtnTextLeading.FontColor := gcBlack;
  BtnTextCenter.FontColor := $FFE7717D;
  BtnTextTrailing.FontColor := gcBlack;

  BtnTextLeading.StaysPressed := False;
  BtnTextCenter.StaysPressed := True;
  BtnTextTrailing.StaysPressed := False;
end;

procedure TForm3.BtnTextHorClick(Sender: TObject);
begin
  TMSFNCTimeline1.Division.TextOrientation := tltoHorizontal;
  TMSFNCTimeline2.Division.TextOrientation := tltoHorizontal;

  BtnTextHor.FontColor := $FFE7717D;
  BtnTextUpDown.FontColor := gcBlack;
  BtnTextLeft.FontColor := gcBlack;
  BtnTextRight.FontColor := gcBlack;

  BtnTextHor.StaysPressed := True;
  BtnTextUpDown.StaysPressed := False;
  BtnTextLeft.StaysPressed := False;
  BtnTextRight.StaysPressed := False;
end;

procedure TForm3.BtnTextLeadingClick(Sender: TObject);
begin
  TMSFNCTimeline1.Division.TextPosition := gtaLeading;
  TMSFNCTimeline2.Division.TextPosition := gtaLeading;

  BtnTextLeading.FontColor := $FFE7717D;
  BtnTextCenter.FontColor := gcBlack;
  BtnTextTrailing.FontColor := gcBlack;

  BtnTextLeading.StaysPressed := True;
  BtnTextCenter.StaysPressed := False;
  BtnTextTrailing.StaysPressed := False;
end;

procedure TForm3.BtnTextLeftClick(Sender: TObject);
begin
  TMSFNCTimeline1.Division.TextOrientation := tltoLeft;
  TMSFNCTimeline2.Division.TextOrientation := tltoLeft;

  BtnTextHor.FontColor := gcBlack;
  BtnTextUpDown.FontColor := gcBlack;
  BtnTextLeft.FontColor := $FFE7717D;
  BtnTextRight.FontColor := gcBlack;

  BtnTextHor.StaysPressed := False;
  BtnTextUpDown.StaysPressed := False;
  BtnTextLeft.StaysPressed := True;
  BtnTextRight.StaysPressed := False;
end;

procedure TForm3.BtnTextRightClick(Sender: TObject);
begin
  TMSFNCTimeline1.Division.TextOrientation := tltoRight;
  TMSFNCTimeline2.Division.TextOrientation := tltoRight;

  BtnTextHor.FontColor := gcBlack;
  BtnTextUpDown.FontColor := gcBlack;
  BtnTextLeft.FontColor := gcBlack;
  BtnTextRight.FontColor := $FFE7717D;

  BtnTextHor.StaysPressed := False;
  BtnTextUpDown.StaysPressed := False;
  BtnTextLeft.StaysPressed := False;
  BtnTextRight.StaysPressed := True;
end;

procedure TForm3.BtnTextTrailingClick(Sender: TObject);
begin
  TMSFNCTimeline1.Division.TextPosition := gtaTrailing;
  TMSFNCTimeline2.Division.TextPosition := gtaTrailing;

  BtnTextLeading.FontColor := gcBlack;
  BtnTextCenter.FontColor := gcBlack;
  BtnTextTrailing.FontColor := $FFE7717D;

  BtnTextLeading.StaysPressed := False;
  BtnTextCenter.StaysPressed := False;
  BtnTextTrailing.StaysPressed := True;
end;

procedure TForm3.BtnTextUpDownClick(Sender: TObject);
begin
  TMSFNCTimeline1.Division.TextOrientation := tltoUpsideDown;
  TMSFNCTimeline2.Division.TextOrientation := tltoUpsideDown;

  BtnTextHor.FontColor := gcBlack;
  BtnTextUpDown.FontColor := $FFE7717D;
  BtnTextLeft.FontColor := gcBlack;
  BtnTextRight.FontColor := gcBlack;

  BtnTextHor.StaysPressed := False;
  BtnTextUpDown.StaysPressed := True;
  BtnTextLeft.StaysPressed := False;
  BtnTextRight.StaysPressed := False;
end;

procedure TForm3.BtnTLCenterClick(Sender: TObject);
begin
  TMSFNCTimeline1.Layout.Position := tlpMiddle;
  TMSFNCTimeline2.Layout.Position := tlpMiddle;

  BtnTLLeft.FontColor := gcBlack;
  BtnTLCenter.FontColor := $FFE7717D;
  BtnTLRight.FontColor := gcBlack;

  BtnTLLeft.StaysPressed := False;
  BtnTLCenter.StaysPressed := True;
  BtnTLRight.StaysPressed := False;
end;

procedure TForm3.BtnTLLeftClick(Sender: TObject);
begin
  TMSFNCTimeline1.Layout.Position := tlpTopLeft;
  TMSFNCTimeline2.Layout.Position := tlpTopLeft;

  BtnTLLeft.FontColor := $FFE7717D;
  BtnTLCenter.FontColor := gcBlack;
  BtnTLRight.FontColor := gcBlack;

  BtnTLLeft.StaysPressed := True;
  BtnTLCenter.StaysPressed := False;
  BtnTLRight.StaysPressed := False;
end;

procedure TForm3.BtnTLRightClick(Sender: TObject);
begin
  TMSFNCTimeline1.Layout.Position := tlpBottomRight;
  TMSFNCTimeline2.Layout.Position := tlpBottomRight;

  BtnTLLeft.FontColor := gcBlack;
  BtnTLCenter.FontColor := gcBlack;
  BtnTLRight.FontColor := $FFE7717D;


  BtnTLLeft.StaysPressed := False;
  BtnTLCenter.StaysPressed := False;
  BtnTLRight.StaysPressed := True;
end;

procedure TForm3.Button10Click(Sender: TObject);
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

  Button5.FontColor := gcBlack;
  Button10.FontColor := $FFE7717D;
  Button7.FontColor := gcBlack;
  Button8.FontColor := gcBlack;

  Button5.StaysPressed := False;
  Button10.StaysPressed := True;
  Button7.StaysPressed := False;
  Button8.StaysPressed := False;
end;

procedure TForm3.Button11Click(Sender: TObject);
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

  Button11.FontColor := $FFE7717D;
  Button12.FontColor := gcBlack;
  Button13.FontColor := gcBlack;

  Button11.StaysPressed := True;
  Button12.StaysPressed := False;
  Button13.StaysPressed := False;
end;

procedure TForm3.Button12Click(Sender: TObject);
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

  Button11.FontColor := gcBlack;
  Button12.FontColor := $FFE7717D;
  Button13.FontColor := gcBlack;

  Button11.StaysPressed := False;
  Button12.StaysPressed := True;
  Button13.StaysPressed := False;
end;

procedure TForm3.Button13Click(Sender: TObject);
var
  I: Integer;
begin
  if Assigned(TMSFNCTimeline1) then
  begin
    for I := 0 to TMSFNCTimeline1.Indicators.Count - 1 do
    begin
      TMSFNCTimeline1.Indicators[I].Annotation.Position := tlapBottomRight;
    end;
  end;
  if Assigned(TMSFNCTimeline2) then
  begin
  for I := 0 to TMSFNCTimeline2.Indicators.Count - 1 do
    begin
      TMSFNCTimeline2.Indicators[I].Annotation.Position := tlapBottomRight;
    end;
  end;

  Button11.FontColor := gcBlack;
  Button12.FontColor := gcBlack;
  Button13.FontColor := $FFE7717D;

  Button11.StaysPressed := False;
  Button12.StaysPressed := False;
  Button13.StaysPressed := True;
end;

procedure TForm3.Button14Click(Sender: TObject);
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

  Button14.FontColor := $FFE7717D;
  Button15.FontColor := gcBlack;
  Button16.FontColor := gcBlack;

  Button14.StaysPressed := True;
  Button15.StaysPressed := False;
  Button16.StaysPressed := False;
end;

procedure TForm3.Button15Click(Sender: TObject);
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

  Button14.FontColor := gcBlack;
  Button15.FontColor := $FFE7717D;
  Button16.FontColor := gcBlack;

  Button14.StaysPressed := False;
  Button15.StaysPressed := True;
  Button16.StaysPressed := False;
end;

procedure TForm3.Button16Click(Sender: TObject);
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

  Button14.FontColor := gcBlack;
  Button15.FontColor := gcBlack;
  Button16.FontColor := $FFE7717D;

  Button14.StaysPressed := False;
  Button15.StaysPressed := False;
  Button16.StaysPressed := True;
end;

procedure TForm3.Button1Click(Sender: TObject);
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

  Button11.FontColor := $FFE7717D;
  Button12.FontColor := gcBlack;
  Button13.FontColor := gcBlack;

  Button11.StaysPressed := True;
  Button12.StaysPressed := False;
  Button13.StaysPressed := False;
end;

procedure TForm3.Button2Click(Sender: TObject);
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

  Button1.FontColor := gcBlack;
  Button2.FontColor := $FFE7717D;
  Button3.FontColor := gcBlack;

  Button1.StaysPressed := False;
  Button2.StaysPressed := True;
  Button3.StaysPressed := False;
end;

procedure TForm3.Button3Click(Sender: TObject);
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

  Button1.FontColor := gcBlack;
  Button2.FontColor := gcBlack;
  Button3.FontColor := $FFE7717D;

  Button1.StaysPressed := False;
  Button2.StaysPressed := False;
  Button3.StaysPressed := True;
end;

procedure TForm3.Button4Click(Sender: TObject);
var
  I: Integer;
begin
  if Assigned(TMSFNCTimeline1) then
  begin
    for I := 0 to TMSFNCTimeline1.Indicators.Count - 1 do
    begin
      TMSFNCTimeline1.Indicators[I].Annotation.Appearance.TextHorizontalAlign := gtaCenter;
    end;
    for I := 0 to TMSFNCTimeline1.Sections.Count - 1 do
    begin
      TMSFNCTimeline1.Sections[I].Appearance.TextHorizontalAlign := gtaCenter;
    end;
  end;

  if Assigned(TMSFNCTimeline2) then
  begin
    for I := 0 to TMSFNCTimeline2.Indicators.Count - 1 do
    begin
      TMSFNCTimeline2.Indicators[I].Annotation.Appearance.TextHorizontalAlign := gtaCenter;
    end;
    for I := 0 to TMSFNCTimeline2.Sections.Count - 1 do
    begin
      TMSFNCTimeline2.Sections[I].Appearance.TextHorizontalAlign := gtaCenter;
    end;
  end;

  Button6.FontColor := gcBlack;
  Button4.FontColor := $FFE7717D;
  Button9.FontColor := gcBlack;

  Button6.StaysPressed := False;
  Button4.StaysPressed := True;
  Button9.StaysPressed := False;
end;

procedure TForm3.Button5Click(Sender: TObject);
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

  Button5.FontColor := $FFE7717D;
  Button10.FontColor := gcBlack;
  Button7.FontColor := gcBlack;
  Button8.FontColor := gcBlack;

  Button5.StaysPressed := True;
  Button10.StaysPressed := False;
  Button7.StaysPressed := False;
  Button8.StaysPressed := False;
end;

procedure TForm3.Button6Click(Sender: TObject);
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

  Button6.FontColor := $FFE7717D;
  Button4.FontColor := gcBlack;
  Button9.FontColor := gcBlack;

  Button6.StaysPressed := True;
  Button4.StaysPressed := False;
  Button9.StaysPressed := False;
end;

procedure TForm3.Button7Click(Sender: TObject);
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

  Button5.FontColor := gcBlack;
  Button10.FontColor := gcBlack;
  Button7.FontColor := $FFE7717D;
  Button8.FontColor := gcBlack;

  Button5.StaysPressed := False;
  Button10.StaysPressed := False;
  Button7.StaysPressed := True;
  Button8.StaysPressed := False;
end;

procedure TForm3.Button8Click(Sender: TObject);
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

  Button5.FontColor := gcBlack;
  Button10.FontColor := gcBlack;
  Button7.FontColor := gcBlack;
  Button8.FontColor := $FFE7717D;

  Button5.StaysPressed := False;
  Button10.StaysPressed := False;
  Button7.StaysPressed := False;
  Button8.StaysPressed := True;
end;

procedure TForm3.Button9Click(Sender: TObject);
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

  Button6.FontColor := gcBlack;
  Button4.FontColor := gcBlack;
  Button9.FontColor := $FFE7717D;

  Button6.StaysPressed := False;
  Button4.StaysPressed := False;
  Button9.StaysPressed := True;
end;

procedure TForm3.DivPosLeftClick(Sender: TObject);
begin
  TMSFNCTimeline1.Division.Position := tlpTopLeft;
  TMSFNCTimeline2.Division.Position := tlpTopLeft;

  DivPosLeft.FontColor := $FFE7717D;
  DivPosMiddle.FontColor := gcBlack;
  DivPosRight.FontColor := gcBlack;

  DivPosLeft.StaysPressed := True;
  DivPosMiddle.StaysPressed := False;
  DivPosRight.StaysPressed := False;
end;


procedure TForm3.DivPosMiddleClick(Sender: TObject);
begin
  TMSFNCTimeline1.Division.Position := tlpMiddle;
  TMSFNCTimeline2.Division.Position := tlpMiddle;

  DivPosLeft.FontColor := gcBlack;
  DivPosMiddle.FontColor := $FFE7717D;
  DivPosRight.FontColor := gcBlack;

  DivPosLeft.StaysPressed := False;
  DivPosMiddle.StaysPressed := True;
  DivPosRight.StaysPressed := False;
end;

procedure TForm3.DivPosRightClick(Sender: TObject);
begin
  TMSFNCTimeline1.Division.Position := tlpBottomRight;
  TMSFNCTimeline2.Division.Position := tlpBottomRight;

  DivPosLeft.FontColor := gcBlack;
  DivPosMiddle.FontColor := gcBlack;
  DivPosRight.FontColor := $FFE7717D;

  DivPosLeft.StaysPressed := False;
  DivPosMiddle.StaysPressed := False;
  DivPosRight.StaysPressed := True;
end;

end.
