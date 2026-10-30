unit UDemo;

interface

uses
  System.SysUtils, System.Classes, WEBLib.Graphics, WEBLib.Forms, WEBLib.Dialogs,
  Vcl.StdCtrls, WEBLib.StdCtrls, Vcl.Controls, WEBLib.WebSocketClient, JS,
  WEBLib.Controls, WEBLib.ExtCtrls, VCL.TMSFNCListBox, VCL.TMSFNCTypes,
  VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes,
  VCL.TMSFNCCustomControl, VCL.TMSFNCCustomPicker, VCL.TMSFNCColorPicker, Types,
  VCL.TMSFNCTableView, VCL.TMSFNCChat, VCL.TMSFNCCustomScrollControl,
  VCL.TMSFNCTileList, VCL.TMSFNCCustomComponent, VCL.TMSFNCBitmapContainer,
  WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton,
  WEBLib.TMSFNCTheme, WEBLib.TMSFNCThemeSelector;

type
  TForm43 = class(TWebForm)
    WebLabel3: TWebLabel;
    WebLabel4: TWebLabel;
    ThemeManager: TTMSFNCThemeManager;
    SettingsPanel: TTMSFNCPanel;
    ThemeCaption: TTMSFNCHTMLText;
    DemoThemeSelector: TTMSFNCThemeSelector;
    NavCaption: TTMSFNCHTMLText;
    WebRadioButton1: TTMSFNCRadioButton;
    WebRadioButton2: TTMSFNCRadioButton;
    OrientCaption: TTMSFNCHTMLText;
    WebRadioButton3: TTMSFNCRadioButton;
    WebRadioButton4: TTMSFNCRadioButton;
    OptionsCaption: TTMSFNCHTMLText;
    WebCheckBox1: TTMSFNCCheckBox;
    WebCheckBox2: TTMSFNCCheckBox;
    WebCheckBox3: TTMSFNCCheckBox;
    WebCheckBox4: TTMSFNCCheckBox;
    TMSFNCTileList1: TTMSFNCTileList;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
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

  TMSFNCTileList1.Header.ArrowLeft.Visible := False;
  TMSFNCTileList1.Header.ArrowRight.Assign(TMSFNCTileList1.Header.ArrowLeft);

  TMSFNCTileList1.Footer.ArrowRight.Assign(TMSFNCTileList1.Header.ArrowRight);
  TMSFNCTileList1.Footer.ArrowLeft.Assign(TMSFNCTileList1.Header.ArrowLeft);

  TMSFNCTileList1.Header.Visible := False;


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
  if not WebRadioButton1.Checked then
    Exit;
  TMSFNCTileList1.BeginUpdate;
  TMSFNCTileList1.NavigationMode := tlnmPage;
  TMSFNCTileList1.Header.Visible := WebCheckBox1.Checked;
  TMSFNCTileList1.Footer.Visible := WebCheckBox2.Checked;
  TMSFNCTileList1.EndUpdate;
end;

procedure TForm43.WebRadioButton2Click(Sender: TObject);
begin
  if not WebRadioButton2.Checked then
    Exit;
  TMSFNCTileList1.BeginUpdate;
  TMSFNCTileList1.NavigationMode := tlnmScroll;
  TMSFNCTileList1.Header.Visible := False;
  TMSFNCTileList1.Footer.Visible := False;
  TMSFNCTileList1.EndUpdate;
end;

procedure TForm43.WebRadioButton3Click(Sender: TObject);
begin
  if not WebRadioButton3.Checked then
    Exit;
  TMSFNCTileList1.Orientation := tloHorizontal;
end;

procedure TForm43.WebRadioButton4Click(Sender: TObject);
begin
  if not WebRadioButton4.Checked then
    Exit;
  TMSFNCTileList1.Orientation := tloVertical;
end;

end.
