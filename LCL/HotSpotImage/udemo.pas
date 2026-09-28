unit uDemo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  LCLTMSFNCHotSpotImage, LCLTMSFNCGraphicsTypes;

type

  { TForm1 }

  TForm1 = class(TForm)
    Label1: TLabel;
    TMSFNCHotSpotImage1: TTMSFNCHotSpotImage;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure TMSFNCHotSpotImage1SelectedHotSpotChange(Sender: TObject;
      AIndex: Integer; var Allow: Boolean);
    procedure TMSFNCHotSpotImage1SelectedHotSpotChanged(Sender: TObject;
      AIndex: Integer);
    procedure DeleteItem;
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
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }


procedure TForm1.Button1Click(Sender: TObject);
var
  I: Integer;
begin
  if Start then
  begin
    Hints := not Hints;
    if Hints then
    begin
      Button1.Caption := 'Hint On';
      for I := 0 to TMSFNCHotSpotImage1.HotSpots.Count - 1 do
      begin
        TMSFNCHotSpotImage1.HotSpots[I].Appearance.HoverFill.Kind := gfkTexture;
      end;
    end
    else
    begin
      Button1.Caption := 'Hint Off';
      for I := 0 to TMSFNCHotSpotImage1.HotSpots.Count - 1 do
      begin
        TMSFNCHotSpotImage1.HotSpots[I].Appearance.HoverFill.Kind := gfkSolid;
        TMSFNCHotSpotImage1.HotSpots[I].Appearance.HoverFill.Color := gcLavender;
      end;
    end;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  I: integer;
begin
  Start := not Start;
  if Start then
  begin
    Button2.Caption := 'Stop';
    for I := 0 to TMSFNCHotSpotImage1.HotSpots.Count - 1 do
    begin
      TMSFNCHotSpotImage1.HotSpots[I].Selected := False;
      TMSFNCHotSpotImage1.HotSpots[I].Appearance.SelectedFill.Kind := gfkSolid;
    end;
    TMSFNCHotSpotImage1.SelectedHotSpot := -1;

    if Label1.Font.Color = gcSteelBlue then
      Label1.Font.Color := gcOlivedrab
    else
      Label1.Font.Color := gcSteelBlue;

    Label1.Font.Style := [TFontStyle.fsBold];

    Reset;

    NextCapital;
  end
  else
  begin
    Label1.Caption := 'Check freely how the different hover, down and select states work.';
    Button2.Caption := 'Start';
    for I := 0 to TMSFNCHotSpotImage1.HotSpots.Count - 1 do
    begin
      TMSFNCHotSpotImage1.HotSpots[I].Appearance.SelectedFill.Kind := gfkTexture;
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  Label1.Caption := 'Welcome click the start button to test your knowledge on Europe capitals';
  Hints := True;
  for I := 0 to TMSFNCHotSpotImage1.HotSpots.Count - 1 do
  begin
    TMSFNCHotSpotImage1.HotSpots[I].Appearance.SelectedFill.Kind := gfkTexture;
  end;
end;

procedure TForm1.NextCapital;
begin
  if Length(cities) > 0 then
  begin
    Point := 1;
    idx := Random(Length(cities));

    Label1.Caption := 'From which country is ' + cities[idx] + ' the capital';
  end
  else
  begin
    Label1.Caption := 'Click start to begin';
    Label2.Caption := 'Your final score is:';
  end;
end;

procedure TForm1.Reset;
var
  I: integer;
begin
  SetLength(cities, 10);
  cities[0] := 'Brussels';
  cities[1] := 'Paris';
  cities[2] := 'Madrid';
  cities[3] := 'Talinn';
  cities[4] := 'Reykjavik';
  cities[5] := 'Budapest';
  cities[6] := 'Berlin';
  cities[7] := 'Dublin';
  cities[8] := 'Rome';
  cities[9] := 'Helsinki';
  SetLength(countries, 10);
  countries[0] := 'Belgium';
  countries[1] := 'France';
  countries[2] := 'Spain';
  countries[3] := 'Estonia';
  countries[4] := 'Iceland';
  countries[5] := 'Hungary';
  countries[6] := 'Germany';
  countries[7] := 'Ireland';
  countries[8] := 'Italy';
  countries[9] := 'Finland';

  for I := 0 to TMSFNCHotSpotImage1.HotSpots.Count - 1 do
  begin
    TMSFNCHotSpotImage1.HotSpots[I].Selected := False;
    TMSFNCHotSpotImage1.HotSpots[I].Appearance.SelectedFill.Color := $0000CC99;
  end;

  Label2.Caption := '';
  TMSFNCHotSpotImage1.Invalidate;
  Point := 1;
  Idx:= 0;
  Score := 0;
  Label3.Caption := score.ToString + '/10';
end;

procedure TForm1.TMSFNCHotSpotImage1SelectedHotSpotChange(Sender: TObject;
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

procedure TForm1.DeleteItem;
var
  tempArr: array of string;
  I, arrIdx: Integer;
begin
  SetLength(tempArr, Length(cities) - 1);
  arrIdx := 0;
  for I := 0 to Length(cities) - 1 do
  begin
  if I <> idx then
  begin
      tempArr[arrIdx] := cities[I];
      Inc(arrIdx);
    end;
  end;

  cities := tempArr;

  SetLength(tempArr, Length(countries) - 1);
  arrIdx := 0;
  for I := 0 to Length(countries) - 1 do
  begin
    if I <> idx then
    begin
      tempArr[arrIdx] := countries[I];
      Inc(arrIdx);
    end;
  end;

  countries := tempArr;
end;

procedure TForm1.TMSFNCHotSpotImage1SelectedHotSpotChanged(Sender: TObject;
  AIndex: Integer);
var
  I: Integer;
begin
  if Start and (length(countries) > 0) then
  begin
    if TMSFNCHotSpotImage1.HotSpots[AIndex].Name = countries[idx] then
    begin
      Label2.Font.Color := gcGreen;
      Label2.Caption := cities[idx] + ' is the capital of ' + countries[idx] + ' ('+Point.ToString+')';
      Score := Score + Point;
      Label3.Caption := score.ToString + '/10';

      DeleteItem;

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
        Label2.Caption := cities[idx] + ' is not the capital of ' + TMSFNCHotSpotImage1.HotSpots[AIndex].Name + ' but ' + countries[idx] + ' (Next question)';

        DeleteItem;

        NextCapital;
      end
      else
      begin
        Label2.Font.Color := gcOrange;
        Label2.Caption := cities[idx] + ' is not the capital of ' + TMSFNCHotSpotImage1.HotSpots[AIndex].Name + ' ('+Point.ToString+')';
      end;
    end;
  end;
end;

end.

