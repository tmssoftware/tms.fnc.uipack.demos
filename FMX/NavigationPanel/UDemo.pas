unit UDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCBitmapContainer,
  FMX.TMSFNCCustomScrollControl, FMX.TMSFNCDataGridData, FMX.TMSFNCCustomGrid,
  FMX.TMSFNCDataGrid, FMX.TMSFNCImage, FMX.TMSFNCTreeViewBase,
  FMX.TMSFNCTreeViewData, FMX.TMSFNCCustomTreeView, FMX.TMSFNCTreeView,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TMSFNCCustomControl,
  FMX.TMSFNCNavigationPanel, FMX.TMSFNCPanel, FMX.ListBox, FMX.TMSFNCColorPicker,
  FMX.TMSFNCCalendar, FMX.TMSFNCButton, FMX.TMSFNCTrackBar, FMX.TMSFNCColorSelector, FMX.TMSFNCTypes, FMX.TMSFNCUtils,
  FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, System.Rtti,
  FMX.TMSFNCDataGridCell, FMX.TMSFNCDataGridBase, FMX.TMSFNCDataGridCore,
  FMX.TMSFNCDataGridRenderer,
  FMX.TMSFNCHTMLText, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector;

type
  TForm1 = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TTMSFNCPanel;
    DemoTitle: TTMSFNCHTMLText;
    DemoDescription: TTMSFNCHTMLText;
    DemoThemeSelector: TTMSFNCThemeSelector;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    TMSFNCNavigationPanel1: TTMSFNCNavigationPanel;
    Panel1: TTMSFNCPanel;
    Panel2: TTMSFNCPanel;
    Panel3: TTMSFNCPanel;
    TMSFNCTreeView1: TTMSFNCTreeView;
    TMSFNCImage1: TTMSFNCImage;
    TMSFNCDataGrid1: TTMSFNCDataGrid;
    procedure FormCreate(Sender: TObject);
    procedure TMSFNCNavigationPanel1CompactItemClick(Sender: TObject;
      AItemIndex: Integer);
    procedure TMSFNCNavigationPanel1ItemClick(Sender: TObject;
      AItemIndex: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.FormCreate(Sender: TObject);
var
  pnl: TTMSFNCPanel;
  btn: TTMSFNCButton;
  tr: TTMSFNCTrackBar;
  co: TTMSFNCColorPicker;
  img: TTMSFNCImage;
  I: Integer;
  cal: TTMSFNCCalendar;
const
  pnls: array[0..2] of string = ('Grid', 'Treeview', 'Image');
begin
  TMSFNCDataGrid1.LoadFromCSVData('CARS.csv');
  for I := 0 to Length(pnls) -  1 do
  begin
    with TMSFNCNavigationPanel1.Panels.Add do
    begin
      Text := pnls[I];
      if I = 2 then
        Text := '<i><font color="gcRed" size="12">'+Text+'</font></i>';
      if I = 1 then
        Text := Text + ' <b><font color="gcGreen" size="12">(5 new items !)</font></b>';

      if I = 0 then
        Kind := pikButton;

      CompactText := pnls[I];
      Bitmaps.AddBitmapName(pnls[I]);
      if I = 1 then
        Badge := '5';
      with Container.Sections.Add do
      begin
        Text := 'Appearance';
        Size := 250;
        pnl := TTMSFNCPanel.Create(Self);
        pnl.Header.Visible := False;
        co := TTMSFNCColorPicker.Create(pnl);
        co.Mode := csmExtended;
        co.Parent := pnl;
        co.Position.X := 10;
        co.Position.Y := 10;
        co.SelectedColor := TMSFNCColorSelectorExtendedColorSet[18];
        img := TTMSFNCImage.Create(pnl);
        img.Parent := pnl;
        img.Position.X := 10;
        img.Position.Y := co.Position.Y + co.Height + 10;
        img.BitmapContainer := TMSFNCBitmapContainer1;
        img.Bitmaps.AddBitmapName(pnls[I]);
        img.Height := 75;
        img.Width := 75;
        cal := TTMSFNCCalendar.Create(pnl);
        cal.Parent := pnl;
        cal.Position.X := img.Position.X + img.Width + 10;
        cal.Position.Y := img.Position.Y;
        cal.Width := 160;
        cal.Height := 180;
        co.Width := cal.Width + 10 + img.Width;
        Control := pnl;
      end;
      with Container.Sections.Add do
      begin
        Text := 'Settings';
        pnl := TTMSFNCPanel.Create(Self);
        pnl.Header.Visible := False;
        btn := TTMSFNCButton.Create(pnl);
        btn.Parent := pnl;
        btn.Position.X := 10;
        btn.Position.Y := 10;
        btn.Width := 150;
        btn.Height := 30;
        btn.Text := 'Hello World !';
        tr := TTMSFNCTrackBar.Create(pnl);
        tr.Parent := pnl;
        tr.Position.X := btn.Position.X;
        tr.Position.Y := btn.Position.Y + btn.Height + 10;
        tr.Width := btn.Width;
        tr.Value := 50;
        Control := pnl;
      end;
    end;
  end;

  Panel1.Visible := True;
  TMSFNCNavigationPanel1.ActivePanelIndex := 0;
end;

procedure TForm1.TMSFNCNavigationPanel1CompactItemClick(Sender: TObject;
  AItemIndex: Integer);
begin
  TMSFNCNavigationPanel1.CompactMode := False;
end;

procedure TForm1.TMSFNCNavigationPanel1ItemClick(Sender: TObject;
  AItemIndex: Integer);
begin
  Panel1.Visible := AItemIndex = 0;
  Panel2.Visible := AItemIndex = 1;
  Panel3.Visible := AItemIndex = 2;
end;

end.
