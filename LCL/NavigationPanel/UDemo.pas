unit UDemo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  LCLTMSFNCNavigationPanel, LCLTMSFNCPanel, LCLTMSFNCImage, LCLTMSFNCTreeView,
  LCLTMSFNCGrid, StdCtrls, ComCtrls, LCLTMSFNCColorPicker,
  LCLTMSFNCColorSelector, LCLTMSFNCBitmapContainer, Calendar;

type

  { TForm1 }

  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    TMSFNCGrid1: TTMSFNCGrid;
    TMSFNCImage1: TTMSFNCImage;
    TMSFNCNavigationPanel1: TTMSFNCNavigationPanel;
    TMSFNCTreeView1: TTMSFNCTreeView;
    procedure FormCreate(Sender: TObject);
    procedure TMSFNCNavigationPanel1ItemClick(Sender: TObject;
      AItemIndex: Integer);
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
  LCLTMSFNCGraphicsTypes, LCLTMSFNCGraphics;

procedure TForm1.FormCreate(Sender: TObject);
var
  pnl: TTMSFNCPanel;
  btn: TButton;
  tr: TTrackBar;
  co: TTMSFNCColorPicker;
  img: TTMSFNCImage;
  I: Integer;
  cal: TCalendar;
const
  pnls: array[0..2] of string = ('Grid', 'Treeview', 'Image');
begin
  TMSFNCGrid1.LoadFromCSV('CARS.csv');
  Color := gcWhite;
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
        co.Left := 10;
        co.Top := 10;
        co.SelectedColor := TMSFNCColorSelectorExtendedColorSet[18];
        img := TTMSFNCImage.Create(pnl);
        img.Parent := pnl;
        img.Left := 10;
        img.Top := co.Top + co.Height + 10;
        img.BitmapContainer := TMSFNCBitmapContainer1;
        img.Bitmaps.AddBitmapName(pnls[I]);
        img.Height := 75;
        img.Width := 75;
        cal := TCalendar.Create(pnl);
        cal.Parent := pnl;
        cal.Left := img.Left + img.Width + 10;
        cal.Top := img.Top;
        cal.Width := 150;
        cal.Height := 150;
        co.Width := cal.Width + 10 + img.Width;
        Control := pnl;
      end;
      with Container.Sections.Add do
      begin
        Text := 'Settings';
        pnl := TTMSFNCPanel.Create(Self);
        pnl.Header.Visible := False;
        btn := TButton.Create(pnl);
        btn.Parent := pnl;
        btn.Left := 10;
        btn.Top := 10;
        btn.Width := 150;
        btn.Height := 30;
        btn.Caption := 'Hello World !';
        tr := TTrackBar.Create(pnl);
        tr.Parent := pnl;
        tr.Left := btn.Left;
        tr.Top := btn.Top + btn.Height + 10;
        tr.Width := btn.Width;
        tr.Position := 50;
        Control := pnl;
      end;
    end;
  end;

  Panel1.Visible := True;
  TMSFNCNavigationPanel1.ActivePanelIndex := 0;
end;

procedure TForm1.TMSFNCNavigationPanel1ItemClick(Sender: TObject;
  AItemIndex: Integer);
begin
  Panel1.Visible := AItemIndex = 0;
  Panel2.Visible := AItemIndex = 1;
  Panel3.Visible := AItemIndex = 2;
end;

end.

