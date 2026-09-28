unit UDemo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, LCLTMSFNCTableView, LCLTMSFNCImage, LCLTMSFNCHTMLText,
  LCLTMSFNCBitmapContainer;

type

  { TForm1 }

  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    TMSFNCBitmapContainer2: TTMSFNCBitmapContainer;
    TMSFNCHTMLText1: TTMSFNCHTMLText;
    TMSFNCImage1: TTMSFNCImage;
    TMSFNCTableView1: TTMSFNCTableView;
    procedure FormCreate(Sender: TObject);
    procedure TMSFNCTableView1BeforeItemShowDetailControl(Sender: TObject;
      AItem: TTMSFNCTableViewItem; ADetailControl: TControl; var AAllow: Boolean
      );
    procedure TMSFNCTableView1ItemMoreOptionClick(Sender: TObject;
      AItem: TTMSFNCTableViewItem; AMoreOption: TTMSFNCTableViewMoreOption);
    procedure TMSFNCTableView1ItemSelectionChanged(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

uses
  Math, LCLTMSFNCGraphicsTypes;

procedure TForm1.FormCreate(Sender: TObject);
var
  I: Integer;
  it: TTMSFNCTableViewItem;
  t: string;
  mo: TTMSFNCTableViewMoreOption;
const
  Names: array[0..18] of string = (
  'Alfa Romeo',
  'Audi',
  'BMW',
  'Chevrolet',
  'Citroen',
  'Ferrari',
  'Fiat',
  'Ford',
  'Honda',
  'Hyundai',
  'Infiniti',
  'Jaguar',
  'Jeep',
  'Seat',
  'Skoda',
  'Subaru',
  'Toyota',
  'Volkswagen',
  'Volvo'
  );
  Descriptions: array[0..18] of string =
  (
  'Alfa Romeo Automobiles S.p.A. is an Italian car manufacturer'+', founded as A.L.F.A. ("Anonima Lombarda Fabbrica Automobili", "Anonymous Lombard Automobile Factory") on 24 June 1910, in Milan.[3] The brand is known for sporty vehicles and has been involved in car racing since 1911.',
  'Audi AG is a German automobile manufacturer that designs, engineers, produces, markets and distributes luxury vehicles. Audi '+'is a member of the Volkswagen Group and has its roots at Ingolstadt, Bavaria, Germany. Audi-branded vehicles are produced in nine production facilities worldwide.',
  'Bayerische Motoren Werke AG, usually known under its abbreviation BMW, is a German luxury vehicle, sports car, motorcycle, and '+'engine manufacturing company founded in 1916. It is one of the best-selling luxury automakers in the world.',
  'Chevrolet, colloquially referred to as Chevy and formally the Chevrolet Division of General Motors Company, is an American automobile division of the American manufacturer General Motors (GM). ',
  'Citroën is a major French automobile manufacturer, part of the PSA Peugeot Citroën'+' group since 1976, founded in 1919 by French industrialist André-Gustave Citroën (1878–1935). In 1934, the firm established its reputation for innovative technology with the "Traction Avant".',
  'Ferrari N.V. is an Italian sports car manufacturer based in Maranello. Founded by Enzo Ferrari in 1939 out of '+'Alfa Romeo''s race division as Auto Avio Costruzioni, the company built its first car in 1940. However the company''s inception as an auto manufacturer is usually recognized in 1947, when the first Ferrari-badged car was completed.',
  'Fiat Automobiles S.p.A. is the largest automobile manufacturer in Italy, a subsidiary of FCA Italy S.p.A., which is part of Fiat Chrysler Automobiles.',
  'The Ford Motor Company (commonly referred to simply as "Ford") is an American multinational automaker headquartered in Dearborn, Michigan, a suburb of Detroit. It was founded by Henry Ford and incorporated on June 16, 1903.',
  'Honda Motor Co., Ltd. is a Japanese public multinational conglomerate corporation primarily known as a manufacturer of automobiles, aircraft, motorcycles, and power equipment.',
  'The Hyundai Motor Company is a South Korean multinational automotive manufacturer headquartered in Seoul, South Korea.',
  'Infiniti is the luxury vehicle division of Japanese automaker Nissan. Infiniti officially started selling vehicles on November 8, 1989 in North America. The marketing network for Infiniti-branded vehicles now includes dealers in over 50 countries.',
  'Jaguar is the luxury vehicle brand of Jaguar Land Rover, a British multinational car manufacturer with its headquarters in Whitley, Coventry, England, owned by the Indian company Tata Motors since 2008.',
  'Jeep is a brand of American automobiles that is a division of FCA US LLC (formerly Chrysler Group, LLC), a wholly owned'+' subsidiary of Fiat Chrysler Automobiles. The former Chrysler Corporation acquired the Jeep brand, along with the remaining assets of its owner American Motors, in 1987.',
  'SEAT, S.A. is a Spanish automobile manufacturer with its head office in Martorell, Catalonia, Spain.[3] It was founded on May 9, 1950, by the Instituto Nacional de Industria (INI), a state-owned industrial holding company.',
  'Škoda Auto, more commonly known as Škoda, is a Czech automobile manufacturer founded in 1895 as Laurin & Klement. It is headquartered in Mladá Boleslav, Czech Republic.',
  'Subaru is the automobile manufacturing division of Japanese transportation conglomerate Subaru Corporation (formerly known as Fuji Heavy Industries (FHI)), the twenty-second largest automaker by production worldwide in 2012.',
  'Toyota Motor Corporation is a Japanese multinational automotive manufacturer headquartered in Toyota, Aichi,'+' Japan. In March 2014, Toyota''s corporate structure consisted of 338,875 employees worldwide and, as of October 2016, was the ninth-largest company in the world by revenue.',
  'Volkswagen, shortened to VW, is a German automaker founded on May 28, 1937 by the German Labour Front and headquartered in Wolfsburg. It is the flagship marque of the Volkswagen Group, the largest automaker by worldwide sales in 2016.',
  'The Volvo Group is a Swedish multinational manufacturing company headquartered in Gothenburg.'
  );

  function FindIndexForName(AName: string): Integer;
  var
    I: Integer;
  begin
    Result := -1;
    for I := 0 to Length(Names) - 1 do
    begin
      if Names[I] = AName then
      begin
        Result := I;
        Break;
      end;
    end;
  end;

  function GetDescriptionForIndex(AIndex: Integer): String;
  begin
    Result := '';
    if (AIndex >= 0) and (AIndex <= Length(Descriptions) - 1) then
      Result := Descriptions[AIndex];
  end;

begin
  TMSFNCTableView1.BeginUpdate;
  TMSFNCTableView1.BitmapContainer := TMSFNCBitmapContainer1;
  TMSFNCTableView1.Header.Text := 'Car List';
  TMSFNCTableView1.Header.Font.Size := 18;
  TMSFNCTableView1.Items.Clear;
  TMSFNCTableView1.CategoryType := tvctAlphaBetic;
  TMSFNCTableView1.ItemAppearance.Fill.Color := gcWhite;

  TMSFNCTableView1.ItemAppearance.HTMLTemplate := '<b><#NAME></b><br/><br/><font size="12" color="gcGray"><#DESCRIPTION></font>';

  for I := 0 to TMSFNCBitmapContainer1.ItemCount - 1 do
  begin
    it := TMSFNCTableView1.Items.Add;
    it.BitmapName := TMSFNCBitmapContainer1.Items[I].Name;
    t := it.BitmapName.Replace('.png', '');

    it.HTMLTemplateItems.Values['NAME'] := t;
    it.HTMLTemplateItems.Values['DESCRIPTION'] := GetDescriptionForIndex(FindIndexForName(t));
    it.VerticalTextAlign := gtaLeading;
    it.CheckType := tvictCheckBox;
    if I mod (Random(5) + 1) = 0 then
    begin
      it.Accessory := tviaBadge;
      it.AccessoryText := inttostr(RandomRange(4, 9));
    end;
    Randomize;
  end;

  TMSFNCTableView1.Items.Sort;

  mo := TMSFNCTableView1.MoreOptions.Add;
  mo.Text := 'Buy';
  mo.Color := gcLimegreen;
  mo.BorderColor := gcLimeGreen;
  mo := TMSFNCTableView1.MoreOptions.Add;
  mo.Text := 'Delete';
  mo.Color := gcRed;
  mo.BorderColor := gcRed;

  TMSFNCTableView1.Interaction.ShowEditButton := True;
  TMSFNCTableView1.Interaction.ShowFilterButton := True;

  TMSFNCTableView1.DefaultItem.DetailControl := Panel1;
  TMSFNCTableView1.EndUpdate;

  TMSFNCHTMLText1.Color := gcWhite;
  TMSFNCImage1.Color := gcWhite;
end;

procedure TForm1.TMSFNCTableView1BeforeItemShowDetailControl(Sender: TObject;
  AItem: TTMSFNCTableViewItem; ADetailControl: TControl; var AAllow: Boolean);
begin
  Label2.Caption := 'Name : ' + AItem.HTMLTemplateItems.Values['NAME'];
  TMSFNCHTMLText1.Text := AItem.HTMLTemplateItems.Values['DESCRIPTION'];
  TMSFNCImage1.Bitmaps.Clear;
  TMSFNCImage1.Bitmaps.Add.BitmapName := AItem.HTMLTemplateItems.Values['NAME'] + '.png';
end;

procedure TForm1.TMSFNCTableView1ItemMoreOptionClick(Sender: TObject;
  AItem: TTMSFNCTableViewItem; AMoreOption: TTMSFNCTableViewMoreOption);
begin
  case AMoreOption.Index of
    0: ShowMessage(AMoreOption.Text + ' clicked !');
    1: TMSFNCTableView1.RemoveItem(AItem);
  end;
end;

procedure TForm1.TMSFNCTableView1ItemSelectionChanged(Sender: TObject);
begin
  TMSFNCTableView1.Footer.Text := IntToStr(TMSFNCTableView1.SelectedItemCount) + ' Items Selected';
end;

end.

