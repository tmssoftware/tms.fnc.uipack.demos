unit UDemo;

interface

uses
  System.SysUtils, System.Classes, WEBLib.Graphics, WEBLib.Forms, WEBLib.Dialogs,
  Vcl.StdCtrls, WEBLib.StdCtrls, Vcl.Controls, WEBLib.WebSocketClient, JS,
  WEBLib.Controls, WEBLib.ExtCtrls, VCL.TMSFNCListBox, VCL.TMSFNCTypes,
  VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes,
  VCL.TMSFNCCustomControl, VCL.TMSFNCCustomPicker, VCL.TMSFNCColorPicker, Types,
  VCL.TMSFNCTableView, VCL.TMSFNCChat, VCL.TMSFNCCustomScrollControl,
  VCL.TMSFNCTileList, VCL.TMSFNCCustomComponent, VCL.TMSFNCBitmapContainer;

type
  TForm43 = class(TWebForm)
    WebLabel3: TWebLabel;
    WebLabel4: TWebLabel;
    WebPanel1: TWebPanel;
    WebGroupBox1: TWebGroupBox;
    WebGroupBox2: TWebGroupBox;
    WebCheckBox1: TWebCheckBox;
    WebCheckBox2: TWebCheckBox;
    WebCheckBox3: TWebCheckBox;
    WebCheckBox4: TWebCheckBox;
    TMSFNCTileList1: TTMSFNCTileList;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    WebRadioButton1: TWebRadioButton;
    WebRadioButton2: TWebRadioButton;
    WebRadioButton3: TWebRadioButton;
    WebRadioButton4: TWebRadioButton;
    procedure WebCheckBox1Click(Sender: TObject);
    procedure WebCheckBox2Click(Sender: TObject);
    procedure WebCheckBox4Click(Sender: TObject);
    procedure WebCheckBox3Click(Sender: TObject);
    procedure WebFormCreate(Sender: TObject);
    procedure WebRadioButton1Click(Sender: TObject);
    procedure WebRadioButton2Click(Sender: TObject);
    procedure WebRadioButton3Click(Sender: TObject);
    procedure WebRadioButton4Click(Sender: TObject);
  private
  end;

var
  Form43: TForm43;

implementation

{$R *.dfm}

const
  TileElements: array  [0..13] of string = ('Account', 'Alarm', 'Browser', 'Calendar', 'Contacts',
    'Documents', 'Games', 'Map', 'Media', 'Messages', 'Notes', 'Search', 'Settings', 'Store');

procedure TForm43.WebCheckBox1Click(Sender: TObject);
begin
  if TMSFNCTileList1.NavigationMode <> tlnmScroll then
    TMSFNCTileList1.Header.Visible := WebCheckBox1.Checked;
end;

procedure TForm43.WebCheckBox2Click(Sender: TObject);
begin
  if TMSFNCTileList1.NavigationMode <> tlnmScroll then
    TMSFNCTileList1.Footer.Visible := WebCheckBox2.Checked;
end;

procedure TForm43.WebCheckBox3Click(Sender: TObject);
begin
  if WebCheckBox3.Checked then
    TMSFNCTileList1.ReorderMode := rmSwap
  else
    TMSFNCTileList1.ReorderMode := rmNone;
end;

procedure TForm43.WebCheckBox4Click(Sender: TObject);
begin
  TMSFNCTileList1.BeginUpdate;
  TMSFNCTileList1.Header.ArrowLeft.Visible := WebCheckBox4.Checked;
  TMSFNCTileList1.Header.ArrowRight.Visible := WebCheckBox4.Checked;
  TMSFNCTileList1.Footer.ArrowLeft.Visible := WebCheckBox4.Checked;
  TMSFNCTileList1.Footer.ArrowRight.Visible := WebCheckBox4.Checked;
  TMSFNCTileList1.EndUpdate;
end;

procedure TForm43.WebFormCreate(Sender: TObject);
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

procedure TForm43.WebRadioButton1Click(Sender: TObject);
begin
  TMSFNCTileList1.BeginUpdate;
  TMSFNCTileList1.NavigationMode := tlnmPage;
  TMSFNCTileList1.Header.Visible := WebCheckBox1.Checked;
  TMSFNCTileList1.Footer.Visible := WebCheckBox2.Checked;
  TMSFNCTileList1.EndUpdate;
end;

procedure TForm43.WebRadioButton2Click(Sender: TObject);
begin
  TMSFNCTileList1.BeginUpdate;
  TMSFNCTileList1.NavigationMode := tlnmScroll;
  TMSFNCTileList1.Header.Visible := False;
  TMSFNCTileList1.Footer.Visible := False;
  TMSFNCTileList1.EndUpdate;
end;

procedure TForm43.WebRadioButton3Click(Sender: TObject);
begin
  TMSFNCTileList1.Orientation := tloHorizontal;
end;

procedure TForm43.WebRadioButton4Click(Sender: TObject);
begin
  TMSFNCTileList1.Orientation := tloVertical;
end;

end.
