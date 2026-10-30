unit UDemo;

{ demo-colors: the answer feedback colours (Label2.Font.Color) and the hot spot colours for right (SelectedFill, Reset) and wrong answers (gcTomato) are the subject }

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VCL.TMSFNCTypes, VCL.TMSFNCUtils,
  VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCProgressBar,
  VCL.TMSFNCCustomControl, VCL.TMSFNCPanel, Vcl.StdCtrls, System.Threading,
  VCL.TMSFNCWaitingIndicator, Vcl.Imaging.jpeg, VCL.TMSFNCImage,
  VCL.TMSFNCHotSpotImage,
  VCL.TMSFNCButton, VCL.TMSFNCHTMLText, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector;

type
  TForm2 = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TTMSFNCPanel;
    DemoTitle: TTMSFNCHTMLText;
    DemoDescription: TTMSFNCHTMLText;
    DemoThemeSelector: TTMSFNCThemeSelector;
    SettingsPanel: TTMSFNCPanel;
    QuizCaption: TTMSFNCHTMLText;
    Button2: TTMSFNCButton;
    Button1: TTMSFNCButton;
    ScoreCaption: TTMSFNCHTMLText;
    Label3: TTMSFNCHTMLText;
    QuestionCaption: TTMSFNCHTMLText;
    Label1: TTMSFNCHTMLText;
    AnswerCaption: TTMSFNCHTMLText;
    Label2: TTMSFNCHTMLText;
    HelpCaption: TTMSFNCHTMLText;
    HelpText: TTMSFNCHTMLText;
    TMSFNCHotSpotImage1: TTMSFNCHotSpotImage;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure TMSFNCHotSpotImage1SelectedHotSpotChange(Sender: TObject;
      AIndex: Integer; var Allow: Boolean);
    procedure TMSFNCHotSpotImage1SelectedHotSpotChanged(Sender: TObject;
      AIndex: Integer);
  private
    Idx: integer;
    Score, Point: Single;
    Hints, Start: Boolean;
    { Private declarations }
  public
    { Public declarations }
    cities: array of string;
    countries: array of string;
    procedure Reset;
    procedure NextCapital;
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}


procedure TForm2.Button1Click(Sender: TObject);
var
  I: Integer;
begin
  if Start then
  begin
    Hints := not Hints;
    if Hints then
    begin
      Button1.Text := 'Hint On';
      for I := 0 to TMSFNCHotSpotImage1.HotSpots.Count - 1 do
      begin
        TMSFNCHotSpotImage1.HotSpots[I].Appearance.HoverFill.Kind := gfkTexture;
      end;
    end
    else
    begin
      Button1.Text := 'Hint Off';
      for I := 0 to TMSFNCHotSpotImage1.HotSpots.Count - 1 do
      begin
        TMSFNCHotSpotImage1.HotSpots[I].Appearance.HoverFill.Kind := gfkSolid;
        TMSFNCHotSpotImage1.HotSpots[I].Appearance.HoverFill.Color := gcLavender;
      end;
    end;
  end;
end;

procedure TForm2.Button2Click(Sender: TObject);
var
  I: Integer;
begin
  Start := not Start;
  if Start then
  begin
    Button2.Text := 'Stop';

    for I := 0 to TMSFNCHotSpotImage1.HotSpots.Count - 1 do
    begin
      TMSFNCHotSpotImage1.HotSpots[I].Selected := False;
      TMSFNCHotSpotImage1.HotSpots[I].Appearance.SelectedFill.Kind := gfkSolid;
    end;
    TMSFNCHotSpotImage1.SelectedHotSpot := -1;

    Label1.Font.Style := [TFontStyle.fsBold];


    Reset;

    NextCapital;
  end
  else
  begin
    Button2.Text := 'Start';

    for I := 0 to TMSFNCHotSpotImage1.HotSpots.Count - 1 do
    begin
      TMSFNCHotSpotImage1.HotSpots[I].Selected := False;
      TMSFNCHotSpotImage1.HotSpots[I].Appearance.SelectedFill.Kind := gfkTexture;
    end;
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  Label1.Text := 'Welcome click the start button to test your knowledge on Europe capitals';
  Hints := True;

  for I := 0 to TMSFNCHotSpotImage1.HotSpots.Count - 1 do
  begin
    TMSFNCHotSpotImage1.HotSpots[I].Appearance.SelectedFill.Kind := gfkTexture;
  end;
end;

procedure TForm2.NextCapital;
begin
  if Length(cities) > 0 then
  begin
    Point := 1;
    idx := Random(Length(cities));

    Label1.Text := 'From which country is ' + cities[idx] + ' the capital';
  end
  else
  begin
    Label1.Text := 'Click start to begin';
    Label2.Text := 'Your final score is:';
  end;
end;

procedure TForm2.Reset;
var
  I: integer;
begin
  cities := ['Brussels','Paris','Madrid','Talinn','Reykjavik', 'Budapest', 'Berlin', 'Dublin', 'Rome', 'Helsinki'];
  countries := ['Belgium', 'France', 'Spain', 'Estonia','Iceland','Hungary','Germany','Ireland','Italy','Finland'];

  for I := 0 to TMSFNCHotSpotImage1.HotSpots.Count - 1 do
  begin
    TMSFNCHotSpotImage1.HotSpots[I].Selected := False;
    TMSFNCHotSpotImage1.HotSpots[I].Appearance.SelectedFill.Color := $0000CC99;
  end;

  Label2.Text := '';
  TMSFNCHotSpotImage1.Invalidate;
  Point := 1;
  Idx:= 0;
  Score := 0;
  Label3.Text := score.ToString + '/10';
end;

procedure TForm2.TMSFNCHotSpotImage1SelectedHotSpotChange(Sender: TObject;
  AIndex: Integer; var Allow: Boolean);
begin
  if Start then
  begin
    if (AIndex >= 0) and not TMSFNCHotSpotImage1.HotSpots[AIndex].Selected then
      Allow := True
    else
      Allow := False;
  end;
end;

procedure TForm2.TMSFNCHotSpotImage1SelectedHotSpotChanged(Sender: TObject;
  AIndex: Integer);
var
  I: Integer;
begin
  if Start and (length(countries) > 0) then
  begin
    if TMSFNCHotSpotImage1.HotSpots[AIndex].Name = countries[idx] then
    begin
      Label2.Font.Color := gcGreen;
      Label2.Text := cities[idx] + ' is the capital of ' + countries[idx] + ' ('+Point.ToString+')';
      Score := Score + Point;
      Label3.Text := score.ToString + '/10';

      Delete(cities, idx, 1);
      Delete(countries, idx, 1);
      NextCapital;
    end
    else
    begin
      TMSFNCHotSpotImage1.HotSpots[AIndex].Selected := False;
      Point := Point - 0.5;

      if Point = 0 then
      begin
        for I := 0 to TMSFNCHotSpotImage1.HotSpots.Count - 1 do
        begin
          if TMSFNCHotSpotImage1.HotSpots[I].Name = countries[idx] then
          begin
            TMSFNCHotSpotImage1.HotSpots[I].Appearance.SelectedFill.Color := gcTomato;
            TMSFNCHotSpotImage1.HotSpots[I].Selected := True;
          end;
        end;

        Label2.Font.Color := gcRed;
        Label2.Text := cities[idx] + ' is not the capital of ' + TMSFNCHotSpotImage1.HotSpots[AIndex].Name + ' but ' + countries[idx] + ' (Next question)';

        Delete(cities, idx, 1);
        Delete(countries, idx, 1);

        NextCapital;
      end
      else
      begin
        Label2.Font.Color := gcOrange;
        Label2.Text := cities[idx] + ' is not the capital of ' + TMSFNCHotSpotImage1.HotSpots[AIndex].Name + ' ('+Point.ToString+')';
      end;
    end;
  end;
end;

end.
