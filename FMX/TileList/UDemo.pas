unit UDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCCustomControl, FMX.TMSFNCCustomScrollControl, FMX.TMSFNCTileList,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TMSFNCCustomComponent,
  FMX.TMSFNCBitmapContainer, FMX.Objects,
  FMX.TMSFNCCheckBox, FMX.TMSFNCHTMLText, FMX.TMSFNCPanel, FMX.TMSFNCRadioButton, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector;

type
  TForm2 = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TTMSFNCPanel;
    DemoTitle: TTMSFNCHTMLText;
    DemoDescription: TTMSFNCHTMLText;
    DemoThemeSelector: TTMSFNCThemeSelector;
    SettingsPanel: TTMSFNCPanel;
    NavCaption: TTMSFNCHTMLText;
    RadioButton1: TTMSFNCRadioButton;
    RadioButton2: TTMSFNCRadioButton;
    OrientCaption: TTMSFNCHTMLText;
    RadioButton3: TTMSFNCRadioButton;
    RadioButton4: TTMSFNCRadioButton;
    OptionsCaption: TTMSFNCHTMLText;
    CheckBox1: TTMSFNCCheckBox;
    CheckBox2: TTMSFNCCheckBox;
    CheckBox3: TTMSFNCCheckBox;
    CheckBox4: TTMSFNCCheckBox;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
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
    TMSFNCTileList1.Header.Visible := CheckBox1.Checked;
end;

procedure TForm2.CheckBox2Change(Sender: TObject);
begin
  if TMSFNCTileList1.NavigationMode <> tlnmScroll then
    TMSFNCTileList1.Footer.Visible := CheckBox2.Checked;
end;

procedure TForm2.CheckBox3Change(Sender: TObject);
begin
  if CheckBox3.Checked then
    TMSFNCTileList1.ReorderMode := rmSwap
  else
    TMSFNCTileList1.ReorderMode := rmNone;
end;

procedure TForm2.CheckBox4Change(Sender: TObject);
begin
  TMSFNCTileList1.BeginUpdate;
  TMSFNCTileList1.Header.ArrowLeft.Visible := CheckBox4.Checked;
  TMSFNCTileList1.Header.ArrowRight.Visible := CheckBox4.Checked;
  TMSFNCTileList1.Footer.ArrowLeft.Visible := CheckBox4.Checked;
  TMSFNCTileList1.Footer.ArrowRight.Visible := CheckBox4.Checked;
  TMSFNCTileList1.EndUpdate;
end;

procedure TForm2.FormCreate(Sender: TObject);
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

procedure TForm2.RadioButton1Change(Sender: TObject);
begin
  TMSFNCTileList1.BeginUpdate;
  TMSFNCTileList1.NavigationMode := tlnmPage;
  TMSFNCTileList1.Header.Visible := CheckBox1.Checked;
  TMSFNCTileList1.Footer.Visible := CheckBox2.Checked;
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
  if not CheckBox3.Checked then
    ShowMessage('Item ' + IntToStr(AItemIndex) + ' clicked!');
end;

end.
