unit UDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.TMSFNCCustomControl, FMX.TMSFNCTreeViewBase, FMX.TMSFNCTreeViewData,
  FMX.TMSFNCCustomTreeView, FMX.TMSFNCTreeView, FMX.StdCtrls, FMX.Types,
  FMX.Controls, FMX.Forms, FMX.TMSFNCBitmapContainer, FMX.TMSFNCCustomComponent,
  FMX.Controls.Presentation, FMX.TMSFNCTypes, FMX.TMSFNCUtils,
  FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes;

type
  TForm130 = class(TForm)
    Label1: TLabel;
    Panel1: TPanel;
    CheckBox1: TCheckBox;
    Label2: TLabel;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    TMSFNCTreeView1: TTMSFNCTreeView;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox3Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure CheckBox4Change(Sender: TObject);
    procedure CheckBox5Change(Sender: TObject);
    procedure CheckBox6Change(Sender: TObject);
    procedure TMSFNCTreeView1NodeCompare(Sender: TObject; Node1,
      Node2: TTMSFNCTreeViewNode; AColumn: Integer;
      var ACompareResult: Integer);
    procedure TMSFNCTreeView1AfterDrawNodeText(Sender: TObject;
      AGraphics: TTMSFNCGraphics; ARect: TRectF; AColumn: Integer;
      ANode: TTMSFNCTreeViewVirtualNode; AText: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form130: TForm130;

implementation

{$R *.fmx}

uses
  Math;

procedure TForm130.CheckBox1Change(Sender: TObject);
begin
  if CheckBox1.IsChecked then
    TMSFNCTreeView1.ExpandAll
  else
    TMSFNCTreeView1.CollapseAll;
end;

procedure TForm130.CheckBox2Change(Sender: TObject);
begin
  TMSFNCTreeView1.Columns[2].UseDefaultAppearance := not CheckBox2.IsChecked;
end;

procedure TForm130.CheckBox3Change(Sender: TObject);
begin
  TMSFNCTreeView1.Columns[1].Visible := CheckBox3.IsChecked;
  TMSFNCTreeView1.ColumnsAppearance.StretchAll := not TMSFNCTreeView1.Columns[1].Visible;
end;

procedure TForm130.CheckBox4Change(Sender: TObject);
begin
  if CheckBox4.IsChecked then
    TMSFNCTreeView1.Interaction.ClipboardMode := tcmFull
  else
    TMSFNCTreeView1.Interaction.ClipboardMode := tcmNone;
end;

procedure TForm130.CheckBox5Change(Sender: TObject);
var
  I: Integer;
begin
  if CheckBox5.IsChecked then
  begin
    for I := 0 to TMSFNCTreeView1.Columns.Count - 1 do
      TMSFNCTreeView1.Columns[I].Sorting := tcsRecursive;
  end
  else
  begin
    for I := 0 to TMSFNCTreeView1.Columns.Count - 1 do
      TMSFNCTreeView1.Columns[I].Sorting := tcsNone;
  end;
end;

procedure TForm130.CheckBox6Change(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to TMSFNCTreeView1.Columns.Count - 1 do
    TMSFNCTreeView1.Columns[I].Filtering.Enabled := CheckBox6.IsChecked;

  if CheckBox6.IsChecked then
    TMSFNCTreeView1.Columns[2].HorizontalTextAlign := gtaLeading
  else
    TMSFNCTreeView1.Columns[2].HorizontalTextAlign := gtaTrailing
end;

procedure TForm130.FormCreate(Sender: TObject);
var
  pn, n, subn: TTMSFNCTreeViewNode;
  c: TTMSFNCTreeViewColumn;
  I: Integer;
begin
  TMSFNCTreeView1.BeginUpdate;
  TMSFNCTreeView1.ClearNodeList;
  TMSFNCTreeView1.BitmapContainer := TMSFNCBitmapContainer1;
  TMSFNCTreeView1.ClearColumns;
  TMSFNCTreeView1.ClearNodes;

  TMSFNCTreeView1.NodesAppearance.HeightMode := tnhmVariable;
  TMSFNCTreeView1.NodesAppearance.SelectionArea := tsaFromText;
  TMSFNCTreeView1.ColumnsAppearance.Stretch := True;
  TMSFNCTreeView1.ColumnsAppearance.StretchAll := False;
  TMSFNCTreeView1.ColumnsAppearance.StretchColumn := 1;

  c := TMSFNCTreeView1.Columns.Add;
  c.Text := 'Item';
  c.Width := 120;

  c := TMSFNCTreeView1.Columns.Add;
  c.Text := 'Description';
  c.WordWrapping := True;
  c.Width := 275;

  c := TMSFNCTreeView1.Columns.Add;
  c.Text := 'Price';
  c.HorizontalTextAlign := gtaTrailing;
  c.Width := 60;
  c.Fill.Color := gcSlategray;
  c.Font.Color := gcWhite;
  c.TopFill.Color := gcSlateGray;
  c.TopFill.Kind := gfkSolid;
  c.TopFont.Color := gcWhite;
  c.TopFont.Size := 14;
  c.Font.Size := 14;

  c := TMSFNCTreeView1.Columns.Add;
  c.Text := 'Stock';
  c.Width := 150;

  c := TMSFNCTreeView1.Columns.Add;
  c.Text := 'Amount';
  c.EditorType := tcetEdit;
  c.Width := 100;

  c := TMSFNCTreeView1.Columns.Add;
  c.Text := 'Delivery method';
  c.EditorType := tcetComboBox;
  c.EditorItems.Add('Standard (5-10 business days)');
  c.EditorItems.Add('Pro (2-3 business days, + $5)');
  c.EditorItems.Add('Exclusive (1 business day, + $10)');
  c.Width := 200;

  pn := TMSFNCTreeView1.AddNode;
  pn.Text[0] := 'Cakes';
  pn.Extended := True;


  n := TMSFNCTreeView1.AddNode(pn);
  n.Text[0] := 'Decoration';
  n.DataBoolean := True;

  subn := TMSFNCTreeView1.AddNode(n);
  subn.CollapsedIconNames[0, False] := 'deco1.png';
  subn.ExpandedIconNames[0, False] := 'deco1.png';
  subn.Text[2] := Format('%m', [RandomRange(100, 1000) / RandomRange(1, 250)]);
  subn.Text[1] := 'A candle is wax with an <font color="#FF6700"><u>ignitable wick</ul></font> embedded that provides <ul><li>light<li>fragrance</ul> <br/>It can also be used to provide heat, or as a method of keeping time.';
  subn.Text[4] := IntToStr(RandomRange(5, 1000));
  subn.Text[5] := TMSFNCTreeView1.Columns[5].EditorItems[Random(TMSFNCTreeView1.Columns[5].EditorItems.Count)];

  subn := TMSFNCTreeView1.AddNode(n);
  subn.CollapsedIconNames[0, False] := 'balloon.png';
  subn.ExpandedIconNames[0, False] := 'balloon.png';
  subn.Text[2] := Format('%m', [RandomRange(100, 1000) / RandomRange(1, 250)]);
  subn.Text[1] := 'A balloon is a <font bgcolor"#67FF00">flexible</font> <font bgcolor"#67FF00">bag</font> that can be inflated with a gas, such as helium, hydrogen, nitrous oxide, oxygen, or air.';


  n := TMSFNCTreeView1.AddNode(pn);
  n.Text[0] := 'Types';
  n.DataBoolean := True;

  for I := 1 to 8 do
  begin
    Randomize;
    subn := TMSFNCTreeView1.AddNode(n);
    subn.CheckTypes[0] := tvntCheckBox;
    subn.Checked[0] := Boolean(Random(2));
    subn.CollapsedIconNames[0, False] := 'cake'+inttostr(I)+'.png';
    subn.ExpandedIconNames[0, False] := 'cake'+inttostr(I)+'.png';
    subn.Text[2] := Format('%m', [RandomRange(100, 1000) / RandomRange(1, 250)]);
    if Odd(I) then
    begin
      subn.Text[5] := TMSFNCTreeView1.Columns[5].EditorItems[Random(TMSFNCTreeView1.Columns[5].EditorItems.Count)];
      subn.Text[4] := IntToStr(RandomRange(5, 1000));
    end;

    case I of
      1: subn.Text[1] := 'Cake is a form of <font color="#FF0000"><i>sweet</i></font> dessert that is <font size="14" bgcolor="#FF6633" color="#FFFFFF" face="Verdana">typically</font> baked.';
      2: subn.Text[1] := 'In its oldest forms, cakes were modifications of breads but now cover a wide range of preparations.';
      3: subn.Text[1] := 'Typical cake <a href="https://en.wikipedia.org/wiki/Ingredient">ingredients</a> are flour, sugar, eggs, and butter or oil.';
      5: subn.Text[1] := 'Cake is often served as a <font bgcolor="#666666" color="#FFFFFF">celebratory</font> dish on ceremonial occasions, for example <i>weddings</i>, <u>anniversaries</u>, and birthdays.';
      7: subn.Text[1] := 'There are countless cake recipes; some are bread-like, some rich and elaborate, and many are centuries old.';
    end;
  end;

  pn := TMSFNCTreeView1.AddNode;
  pn.Text[0] := 'Biscuits';
  pn.Extended := True;

  for I := 1 to 1 do
  begin
    subn := TMSFNCTreeView1.AddNode(pn);
    subn.CollapsedIconNames[0, False] := 'biscuit'+inttostr(I)+'.png';
    subn.ExpandedIconNames[0, False] := 'biscuit'+inttostr(I)+'.png';
    subn.Text[2] := Format('%m', [RandomRange(100, 1000) / RandomRange(1, 250)]);
  end;

  pn := TMSFNCTreeView1.AddNode;
  pn.Text[0] := 'Pastries';
  pn.Extended := True;

  for I := 1 to 6 do
  begin
    subn := TMSFNCTreeView1.AddNode(pn);
    subn.CheckTypes[0] := tvntRadioButton;
    subn.CollapsedIconNames[0, False] := 'pastry'+inttostr(I)+'.png';
    subn.ExpandedIconNames[0, False] := 'pastry'+inttostr(I)+'.png';
    subn.Text[2] := Format('%m', [RandomRange(100, 1000) / RandomRange(1, 250)]);

    case I of
      1: subn.Text[1] := 'Pastry is a <font color="#EE3C54">major</font> type of bakers'' <b>confectionery</b>. It includes many of the various kinds of baked products made from ingredients such as flour, sugar, milk, butter, shortening, baking powder, and eggs.';
      2: subn.Text[1] := 'Small tarts and other sweet baked products are called pastries. Common pastry dishes include pies, tarts, quiches and pasties.';
      3: subn.Text[1] := 'Pastry can also refer to the pastry dough,[3] from which such baked products are made.';
      5: subn.Text[1] := 'Pastry is differentiated from bread by having a higher fat content, which contributes to a flaky or crumbly texture.';
    end;
  end;

  TMSFNCTreeView1.ExpandAll;
  TMSFNCTreeView1.EndUpdate;
  TMSFNCTreeView1.SetFocus;
end;

procedure TForm130.TMSFNCTreeView1AfterDrawNodeText(Sender: TObject;
  AGraphics: TTMSFNCGraphics; ARect: TRectF; AColumn: Integer;
  ANode: TTMSFNCTreeViewVirtualNode; AText: string);
var
  r, rs: TRectF;
  fs, fst: Integer;
  t: String;
begin
  if (AColumn = 3) and Assigned(ANode.Node) then
  begin
    t := ANode.Node.Text[AColumn + 1];
    if TryStrToInt(t, fs) then
    begin
      fst := 1000;
      fs := Max(0, Min(fst, fst - fs));
      r := ARect;
      r.Top :=  r.Top + (r.Height - 20) / 2;
      r.Height := 20;
      InflateRect(r, 0, -2);
      r.Width := r.Width - 2;
      r := RectF(Int(r.Left) + 0.5, Int(r.Top) + 0.5, Int(r.Right) - 0.5, Int(r.Bottom) - 0.5);
      rs := r;
      rs.Width := rs.Width * fs / fst;

      AGraphics.Stroke.Color := gcNull;
      AGraphics.Stroke.Kind := gskSolid;
      AGraphics.Fill.Color := gcWhite;
      AGraphics.DrawRectangle(r);
      AGraphics.Fill.Color := gcSteelblue;
      AGraphics.DrawRectangle(rs);
      AGraphics.Fill.Color := gcNull;
      if TMSFNCTreeView1.IsNodeSelected(ANode.Node) then
        AGraphics.Stroke.Color := gcWhite
      else
        AGraphics.Stroke.Color := gcDarkgray;
      AGraphics.DrawRectangle(r);
    end;
  end;
end;

procedure TForm130.TMSFNCTreeView1NodeCompare(Sender: TObject; Node1,
  Node2: TTMSFNCTreeViewNode; AColumn: Integer; var ACompareResult: Integer);
var
  i1, i2: Integer;
  v1, v2: Double;
  n1, n2: string;
begin
  if AColumn = 2 then
  begin
    v1 := 0;
    v2 := 0;
    n1 := StringReplace(Node1.Text[AColumn], FormatSettings.CurrencyString, '', [rfReplaceAll]);
    n2 := StringReplace(Node2.Text[AColumn], FormatSettings.CurrencyString, '', [rfReplaceAll]);

    TryStrToFloat(n1, v1);
    TryStrToFloat(n2, v2);
    ACompareResult := CompareValue(v1, v2);
    case TMSFNCTreeView1.SortMode of
      nsmDescending: ACompareResult := ACompareResult * -1;
    end;
  end
  else if AColumn = 3 then
  begin
    i1 := 0;
    i2 := 0;
    n1 := Node1.Text[AColumn];
    n2 := Node2.Text[AColumn];

    TryStrToInt(n1, i1);
    TryStrToInt(n2, i2);
    ACompareResult := CompareValue(i1, i2);
    case TMSFNCTreeView1.SortMode of
      nsmDescending: ACompareResult := ACompareResult * -1;
    end;
  end;
end;

end.
