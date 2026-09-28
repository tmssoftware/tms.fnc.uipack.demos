unit USLDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.TMSFNCCustomControl, FMX.TMSFNCSearchEdit, FMX.TMSFNCScrollControl,
  FMX.TMSFNCSearchList, FMX.Controls.Presentation, FMX.StdCtrls, System.UIConsts,
  FMX.TMSFNCCustomPicker, FMX.TMSFNCColorPicker, FMX.TMSFNCToolBar,
  FMX.TMSFNCTypes;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    TMSFNCSearchList1: TTMSFNCSearchList;
    TMSFNCSearchEdit1: TTMSFNCSearchEdit;
    GroupBox2: TGroupBox;
    TMSFNCSearchList2: TTMSFNCSearchList;
    TMSFNCSearchEdit2: TTMSFNCSearchEdit;
    Edit1: TEdit;
    Edit2: TEdit;
    ckSearchLimit: TCheckBox;
    Edit3: TEdit;
    ckDescr: TCheckBox;
    TMSFNCToolBarColorPicker1: TTMSFNCToolBarColorPicker;
    procedure FormCreate(Sender: TObject);
    procedure Edit1ChangeTracking(Sender: TObject);
    procedure Edit2ChangeTracking(Sender: TObject);
    procedure ckDescrChange(Sender: TObject);
    procedure ckSearchLimitChange(Sender: TObject);
    procedure TMSFNCToolBarColorPicker1ColorSelected(Sender: TObject;
      AColor: TAlphaColor);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure InitCarList;
    procedure InitDictionaryList;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.ckSearchLimitChange(Sender: TObject);
begin
  if ckSearchLimit.IsChecked then
    TMSFNCSearchList1.FilterCondition.MaxCategoryItems := StrToInt(Edit3.Text)
  else
    TMSFNCSearchList1.FilterCondition.MaxCategoryItems := 0;
end;

procedure TForm1.ckDescrChange(Sender: TObject);
begin
  if ckDescr.IsChecked then
    TMSFNCSearchList2.FilterCondition.FilterData := fdAll
  else
    TMSFNCSearchList2.FilterCondition.FilterData := fdText;
end;

procedure TForm1.Edit1ChangeTracking(Sender: TObject);
begin
  TMSFNCSearchList1.FilterCondition.Text := Edit1.Text;
  TMSFNCSearchList1.UpdateFilter;
end;

procedure TForm1.Edit2ChangeTracking(Sender: TObject);
begin
  TMSFNCSearchList2.FilterCondition.Text := Edit2.Text;
  TMSFNCSearchList2.UpdateFilter;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  InitCarList;
  InitDictionaryList;
end;

procedure TForm1.InitCarList;
var
  i,cat: integer;
  sli: TSearchListItem;
  sl,cols: TStringList;
begin
  sl := TStringList.Create;
  cols := TStringList.Create;
  cols.Delimiter := ',';
  cols.StrictDelimiter := true;

  sl.LoadFromFile('.\..\..\carlist.txt');

  TMSFNCSearchList2.ItemHeight := 70;
  TMSFNCSearchList2.Categories.Clear;
  TMSFNCSearchList2.Categories.Add('Aston Martin',0);
  TMSFNCSearchList2.Categories.Add('Audi',1);
  TMSFNCSearchList2.Categories.Add('BMW',2);
  TMSFNCSearchList2.Categories.Add('Ferarri',3);
  TMSFNCSearchList2.Categories.Add('McLaren',4);
  TMSFNCSearchList2.Categories.Add('Mercedes',5);
  TMSFNCSearchList2.Categories.Add('Porsche',6);

  TMSFNCSearchList2.Columns.Clear;
  TMSFNCSearchList2.Columns.Add;
  TMSFNCSearchList2.Columns.Add;
  TMSFNCSearchList2.Columns[1].ControlFont := true;
  TMSFNCSearchList2.Appearance.DescriptionControlFont := false;
  TMSFNCSearchList2.Appearance.DescriptionFont.Color := clGray;
  TMSFNCSearchList2.Appearance.DescriptionFont.Style := [TFontStyle.fsItalic];
  TMSFNCSearchList2.FilterCondition.Categories := true;
  TMSFNCSearchList2.FilterCondition.CategoryItems := true;
  TMSFNCSearchList2.FilterCondition.Column := 1;

  TMSFNCSearchList2.BeginUpdate;

  cat := -1;

  for i := 0 to sl.Count - 1 do
  begin
    cols.CommaText := sl.Strings[i];

    if StrToInt(cols[3]) <> cat then
    begin
      cat := StrToInt(cols[3]);
      sli := TMSFNCSearchList2.Items.Add;
      sli.ItemType := itCategory;
      sli.CategoryID := cat;
      sli.Captions[0] := TMSFNCSearchList2.Categories[cat].Caption;
    end;

    sli := TMSFNCSearchList2.Items.Add;

    sli.Captions[1] := cols[0];
    sli.Descriptions[1] := cols[1];
    sli.CategoryID := StrToInt(cols[3]);

    sli.Columns[0].Picture.LoadFromFile('.\..\..\'+cols[2]);
  end;

  TMSFNCSearchList2.Items.Sort(1, sdUp, false);


  TMSFNCSearchList2.UpdateFilter;

  TMSFNCSearchList2.Appearance.HighlightFontStyle := [TFontStyle.fsBold];

  TMSFNCSearchList2.EndUpdate;

  TMSFNCSearchEdit2.FilterCondition.Column := 1;
  TMSFNCSearchEdit2.Columns.Assign(TMSFNCSearchList2.Columns);
  TMSFNCSearchEdit2.Categories.Assign(TMSFNCSearchList2.Categories);
  TMSFNCSearchEdit2.Items.Assign(TMSFNCSearchList2.Items);
  TMSFNCSearchEdit2.ItemHeight := 70;
end;

procedure TForm1.InitDictionaryList;
var
  i: integer;
  sli: TSearchListItem;
  sl: TStringList;
  prevc: char;
  s: string;
  catid: integer;
begin
  sl := TStringList.Create;
  sl.LoadFromFile('.\..\..\dictionary.txt');

  TMSFNCSearchList1.BeginUpdate;

  prevc := #0;
  catid := 0;

  for i := 0 to sl.Count - 1 do
  begin
    s := sl.Strings[i];

    if s[1] <> prevc then
    begin
      inc(catid);
      prevc := s[1];
      sli := TMSFNCSearchList1.Items.Add(Uppercase(prevc));
      sli.ItemType := itCategory;
      sli.CategoryID := catid;
    end;

    sli := TMSFNCSearchList1.Items.Add(sl.Strings[i]);
    sli.CategoryID := catid;
    sli.ImageIndexes[1] := Random(5);
  end;

  TMSFNCSearchList1.EndUpdate;

  sl.Free;

  TMSFNCSearchList1.FilterCondition.FilterType := mStartWord;
  TMSFNCSearchList1.FilterCondition.Column := 0;
  TMSFNCSearchList1.FilterCondition.AutoSelect := true;
  TMSFNCSearchList1.FilterCondition.CategoryItems := true;
  //TMSFNCSearchList1.FilterCondition.MaxCategoryItems := 10;
  TMSFNCSearchList1.FilterCondition.CaseSensitive := false;
  TMSFNCSearchList1.FilterCondition.Categories := true;

  TMSFNCSearchList1.Appearance.Banding := true;
  TMSFNCSearchList1.Appearance.HighlightColor := clNone;
  TMSFNCSearchList1.Appearance.HighlightTextColor := claGreen;
  TMSFNCSearchList1.Appearance.HighlightFontStyle := [TFontStyle.fsBold];
  TMSFNCSearchList1.Appearance.FilterCount := fcShow;
  TMSFNCSearchList1.Appearance.FilterCountFont.Size := 7;

  TMSFNCSearchList1.UpdateFilter;

  TMSFNCSearchEdit1.FilterCondition.Assign(TMSFNCSearchList1.FilterCondition);
  TMSFNCSearchEdit1.Appearance.Assign(TMSFNCSearchList1.Appearance);

  TMSFNCSearchEdit1.Items.Assign(TMSFNCSearchList1.Items);

end;

procedure TForm1.TMSFNCToolBarColorPicker1ColorSelected(Sender: TObject;
  AColor: TAlphaColor);
begin
  TMSFNCSearchList2.Appearance.HighlightTextColor := AColor;
  TMSFNCSearchEdit2.Appearance.HighlightTextColor := AColor;
end;

end.
