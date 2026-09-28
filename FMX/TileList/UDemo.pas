unit UDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCCustomControl, FMX.TMSFNCCustomScrollControl, FMX.TMSFNCTileList,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TMSFNCCustomComponent,
  FMX.TMSFNCBitmapContainer, FMX.Objects;

type
  TForm2 = class(TForm)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    GroupBox2: TGroupBox;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    CheckBox3: TCheckBox;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    CheckBox4: TCheckBox;
    Rectangle1: TRectangle;
    TMSFNCTileList1: TTMSFNCTileList;
    procedure FormCreate(Sender: TObject);
    procedure TMSFNCTileList1ItemClick(Sender: TObject; AItemIndex: Integer);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure CheckBox3Change(Sender: TObject);
    procedure RadioButton2Change(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure RadioButton3Change(Sender: TObject);
    procedure RadioButton4Change(Sender: TObject);
    procedure CheckBox4Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

const
  TileElements: array  [0..13] of string = ('Account', 'Alarm', 'Browser', 'Calendar', 'Contacts',
    'Documents', 'Games', 'Map', 'Media', 'Messages', 'Notes', 'Search', 'Settings', 'Store');

procedure TForm2.CheckBox1Change(Sender: TObject);
begin
  if TMSFNCTileList1.NavigationMode <> tlnmScroll then
    TMSFNCTileList1.Header.Visible := CheckBox1.IsChecked;
end;

procedure TForm2.CheckBox2Change(Sender: TObject);
begin
  if TMSFNCTileList1.NavigationMode <> tlnmScroll then
    TMSFNCTileList1.Footer.Visible := CheckBox2.IsChecked;
end;

procedure TForm2.CheckBox3Change(Sender: TObject);
begin
  if CheckBox3.IsChecked then
    TMSFNCTileList1.ReorderMode := rmSwap
  else
    TMSFNCTileList1.ReorderMode := rmNone;
end;

procedure TForm2.CheckBox4Change(Sender: TObject);
begin
  TMSFNCTileList1.BeginUpdate;
  TMSFNCTileList1.Header.ArrowLeft.Visible := CheckBox4.IsChecked;
  TMSFNCTileList1.Header.ArrowRight.Visible := CheckBox4.IsChecked;
  TMSFNCTileList1.Footer.ArrowLeft.Visible := CheckBox4.IsChecked;
  TMSFNCTileList1.Footer.ArrowRight.Visible := CheckBox4.IsChecked;
  TMSFNCTileList1.EndUpdate;
end;

procedure TForm2.FormCreate(Sender: TObject);
var
  itm: TTMSFNCTileListItem;
  I: Integer;
begin
  TMSFNCTileList1.BeginUpdate;

  TMSFNCTileList1.Header.Fill.Color := gcDimgray;
  TMSFNCTileList1.Header.Stroke.Color := gcDimgray;
  TMSFNCTileList1.Header.ArrowLeft.Fill.Color := gcDimgray;
  TMSFNCTileList1.Header.ArrowLeft.DownFill.Color := gcDimgray;
  TMSFNCTileList1.Header.ArrowLeft.HoverFill.Color := gcDimgray;
  TMSFNCTileList1.Header.ArrowLeft.Stroke.Color := gcDimgray;
  TMSFNCTileList1.Header.ArrowLeft.DownStroke.Color := gcDimgray;
  TMSFNCTileList1.Header.ArrowLeft.HoverStroke.Color := gcDimgray;
  TMSFNCTileList1.Header.ArrowLeft.ArrowFill.Color := gcWhite;
  TMSFNCTileList1.Header.ArrowLeft.ArrowDownFill.Color := gcWhite;
  TMSFNCTileList1.Header.ArrowLeft.ArrowHoverFill.Color := gcWhite;
  TMSFNCTileList1.Header.ArrowLeft.Visible := False;
  TMSFNCTileList1.Header.ArrowRight.Assign(TMSFNCTileList1.Header.ArrowLeft);
  TMSFNCTileList1.Header.Bullets.Fill.Color := gcWhite;
  TMSFNCTileList1.Header.Bullets.Stroke.Color := gcWhite;
  TMSFNCTileList1.Header.Bullets.SelectedFill.Color := gcDeepskyblue;
  TMSFNCTileList1.Header.Bullets.SelectedStroke.Color := gcDeepskyblue;

  TMSFNCTileList1.Footer.Fill.Assign(TMSFNCTileList1.Header.Fill);
  TMSFNCTileList1.Footer.Stroke.Assign(TMSFNCTileList1.Header.Stroke);
  TMSFNCTileList1.Footer.ArrowRight.Assign(TMSFNCTileList1.Header.ArrowRight);
  TMSFNCTileList1.Footer.ArrowLeft.Assign(TMSFNCTileList1.Header.ArrowLeft);
  TMSFNCTileList1.Footer.Bullets.Assign(TMSFNCTileList1.Header.Bullets);

  TMSFNCTileList1.Header.Visible := False;

  //appearance
  TMSFNCTileList1.Appearance.Fill.Color := gcGray;
  TMSFNCTileList1.Appearance.Stroke.Color := gcGray;
  TMSFNCTileList1.Appearance.FillHover.Color := gcLightgray;
  TMSFNCTileList1.Appearance.StrokeHover.Color := gcLightGray;
  TMSFNCTileList1.Appearance.FillDown.Color := gcDeepskyblue;
  TMSFNCTileList1.Appearance.StrokeDown.Color := gcDeepskyblue;
  TMSFNCTileList1.Appearance.FillSelected.Color := gcDeepskyblue;
  TMSFNCTileList1.Appearance.StrokeSelected.Color := gcDeepskyblue;
  TMSFNCTileList1.Appearance.TitleFont.Color := gcWhite;
  TMSFNCTileList1.Appearance.DescriptionFont.Color := gcWhite;

  TMSFNCTileList1.Items.Clear;
  for I := 0 to 13 do
  begin
    itm := TMSFNCTileList1.Items.Add;
    itm.Title := ' ';
    itm.Description := TileElements[I];
    itm.ImagePosition := tipTop;
    itm.ImageHeight := 75;
    itm.ImageName := LowerCase(TileElements[I]) + '.svg';
    if (I = 3) or (I = 9) then
      itm.ColumnSpan := 2;
  end;

  TMSFNCTileList1.EndUpdate;
end;

procedure TForm2.RadioButton1Change(Sender: TObject);
begin
  TMSFNCTileList1.BeginUpdate;
  TMSFNCTileList1.NavigationMode := tlnmPage;
  TMSFNCTileList1.Header.Visible := CheckBox1.IsChecked;
  TMSFNCTileList1.Footer.Visible := CheckBox2.IsChecked;
  TMSFNCTileList1.EndUpdate;
end;

procedure TForm2.RadioButton2Change(Sender: TObject);
begin
  TMSFNCTileList1.BeginUpdate;
  TMSFNCTileList1.NavigationMode := tlnmScroll;
  TMSFNCTileList1.Header.Visible := False;
  TMSFNCTileList1.Footer.Visible := False;
  TMSFNCTileList1.EndUpdate;
end;

procedure TForm2.RadioButton3Change(Sender: TObject);
begin
  TMSFNCTileList1.Orientation := tloHorizontal;
end;

procedure TForm2.RadioButton4Change(Sender: TObject);
begin
  TMSFNCTileList1.Orientation := tloVertical;
end;

procedure TForm2.TMSFNCTileList1ItemClick(Sender: TObject; AItemIndex: Integer);
begin
  if not CheckBox3.IsChecked then
    ShowMessage('Item ' + IntToStr(AItemIndex) + ' clicked!');
end;

end.
