unit UDemo;

interface

uses
  System.SysUtils, System.Classes, JS, Web, WEBLib.Graphics, WEBLib.Controls,
  WEBLib.Forms, WEBLib.Dialogs, VCL.TMSFNCTypes, VCL.TMSFNCUtils,
  VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, Vcl.Controls, Vcl.StdCtrls,
  WEBLib.StdCtrls, Vcl.Imaging.jpeg, VCL.TMSFNCCustomControl, VCL.TMSFNCImage,
  WEBLib.TMSFNCHotSpotImage, VCL.TMSFNCHotSpotImage;

type
  TForm2 = class(TWebForm)
    TMSFNCHotSpotImage1: TTMSFNCHotSpotImage;
    WebLabel1: TWebLabel;
    WebButton1: TWebButton;
    WebLabel2: TWebLabel;
    WebButton2: TWebButton;
    WebLabel3: TWebLabel;
    WebMemo1: TWebMemo;
    procedure WebButton2Click(Sender: TObject);
    procedure WebButton1Click(Sender: TObject);
    procedure WebFormCreate(Sender: TObject);
    procedure TMSFNCHotSpotImage1SelectedHotSpotChange(Sender: TObject;
      AIndex: Integer; var Allow: Boolean);
    procedure TMSFNCHotSpotImage1SelectedHotSpotChanged(Sender: TObject;
      AIndex: Integer);
    procedure WebFormShow(Sender: TObject);
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


procedure TForm2.WebButton1Click(Sender: TObject);
var
  I: Integer;
begin
  Hints := not Hints;
  if Hints then
  begin
    WebButton1.Caption := 'Hint On';
    for I := 0 to TMSFNCHotSpotImage1.HotSpots.Count - 1 do
    begin
      TMSFNCHotSpotImage1.HotSpots[I].Appearance.HoverFill.Kind := gfkTexture;
    end;
  end
  else
  begin
    WebButton1.Caption := 'Hint Off';
    for I := 0 to TMSFNCHotSpotImage1.HotSpots.Count - 1 do
    begin
      TMSFNCHotSpotImage1.HotSpots[I].Appearance.HoverFill.Kind := gfkSolid;
      TMSFNCHotSpotImage1.HotSpots[I].Appearance.HoverFill.Color := gcLavender;
    end;
  end;
end;

procedure TForm2.WebButton2Click(Sender: TObject);
var
  I: Integer;
begin
  Start := not Start;
  if Start then
  begin
    WebButton2.Caption := 'Stop';
    for I := 0 to TMSFNCHotSpotImage1.HotSpots.Count - 1 do
    begin
      TMSFNCHotSpotImage1.HotSpots[I].Selected := False;
      TMSFNCHotSpotImage1.HotSpots[I].Appearance.SelectedFill.Kind := gfkSolid;
    end;
    TMSFNCHotSpotImage1.SelectedHotSpot := -1;

    if WebLabel1.Font.Color = gcSteelBlue then
      WebLabel1.Font.Color := gcOlivedrab
    else
      WebLabel1.Font.Color := gcSteelBlue;

    WebLabel1.Font.Style := [TFontStyle.fsBold];

    Reset;

    NextCapital;
  end
  else
  begin
    WebLabel1.Caption := 'Have a free look on how the different hover, down and selected states work.';
    WebButton2.Caption := 'Start';

    for I := 0 to TMSFNCHotSpotImage1.HotSpots.Count - 1 do
    begin
      TMSFNCHotSpotImage1.HotSpots[I].Appearance.SelectedFill.Kind := gfkTexture;
    end;
  end;

  TMSFNCHotSpotImage1.Invalidate;
end;

procedure TForm2.WebFormCreate(Sender: TObject);
var
  lbl: TWebLabel;
  I: Integer;
begin
  FormContainer := 'appcontent';
  lbl := TLabel.Create(Self);
  lbl.ElementID := 'title';
  lbl.Caption := 'TMS FNC UI Pack';

  lbl := TLabel.Create(Self);
  lbl.ElementID := 'description';
  lbl.Caption := 'TMSFNCHotSpotImage Demo';

  WebLabel1.Caption := 'Welcome click the start button to test your knowledge on Europe capitals';
  Hints := True;

  for I := 0 to TMSFNCHotSpotImage1.HotSpots.Count - 1 do
  begin
    TMSFNCHotSpotImage1.HotSpots[I].Appearance.SelectedFill.Kind := gfkTexture;
  end;
end;

procedure TForm2.WebFormShow(Sender: TObject);
begin
  TMSFNCHotSpotImage1.Invalidate;
end;

procedure TForm2.NextCapital;
begin
  if Length(cities) > 0 then
  begin
    Point := 1;
    idx := Random(Length(cities));

    WebLabel1.Caption := 'From which country is ' + cities[idx] + ' the capital';
  end
  else
  begin
    WebLabel1.Caption := 'Click start to begin';
    WebLabel2.Caption := 'Your final score is:';
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

  WebLabel2.Caption := '';
  TMSFNCHotSpotImage1.Invalidate;
  Point := 1;
  Idx:= 0;
  Score := 0;
  WebLabel3.Caption := score.ToString + '/10';
end;

procedure TForm2.TMSFNCHotSpotImage1SelectedHotSpotChange(Sender: TObject; AIndex: Integer; var Allow: Boolean);
begin
  if Start then
  begin
    if (AIndex >= 0) and not TMSFNCHotSpotImage1.HotSpots[AIndex].Selected then
      Allow := True
    else
      Allow := False;
  end;
end;

procedure TForm2.TMSFNCHotSpotImage1SelectedHotSpotChanged(Sender: TObject; AIndex: Integer);
var
  I: Integer;
begin
  if Start and (length(countries) > 0) then
  begin
    if TMSFNCHotSpotImage1.HotSpots[AIndex].Name = countries[idx] then
    begin
      WebLabel2.Font.Color := gcGreen;
      WebLabel2.Caption := cities[idx] + ' is the capital of ' + countries[idx] + ' ('+Point.ToString+')';
      Score := Score + Point;
      WebLabel3.Caption := score.ToString + '/10';

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

        WebLabel2.Font.Color := gcRed;
        WebLabel2.Caption := cities[idx] + ' is not the capital of ' + TMSFNCHotSpotImage1.HotSpots[AIndex].Name + ' but ' + countries[idx] + ' (Next question)';

        Delete(cities, idx, 1);
        Delete(countries, idx, 1);

        NextCapital;
      end
      else
      begin
        WebLabel2.Font.Color := gcOrange;
        WebLabel2.Caption := cities[idx] + ' is not the capital of ' + TMSFNCHotSpotImage1.HotSpots[AIndex].Name + ' ('+Point.ToString+')';
      end;
    end;
  end;
end;

end.