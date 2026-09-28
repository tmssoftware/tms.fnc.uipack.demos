unit UDemo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, LCLTMSFNCListBox,
  LCLTMSFNCBitmapContainer;

type

  { TForm1 }

  TForm1 = class(TForm)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    Label1: TLabel;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    TMSFNCListBox1: TTMSFNCListBox;
    TMSFNCListBox2: TTMSFNCListBox;
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure CheckBox3Change(Sender: TObject);
    procedure CheckBox4Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses
  LCLTMSFNCGraphicsTypes, LCLTMSFNCGraphics;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var
  it: TTMSFNCListBoxItem;
  I: Integer;
begin
  TMSFNCListBox1.ItemsAppearance.HeightMode := lihmVariable;
  TMSFNCListBox2.ItemsAppearance.HeightMode := lihmVariable;
  TMSFNCListBox1.Header.Text := 'Birthday shopping list';
  TMSFNCListBox1.Header.Visible := True;
  TMSFNCListBox1.Header.HorizontalTextAlign := gtaLeading;
  TMSFNCListBox1.Header.Fill.Color := gcLightgoldenrodyellow;
  TMSFNCListBox1.Header.Size := 40;
  TMSFNCListBox1.Header.Font.Size := 14;
  TMSFNCListBox1.Header.Font.Color := gcBlack;

  TMSFNCListBox1.Interaction.DragDropMode := ldmMove;
  TMSFNCListBox2.Interaction.DragDropMode := ldmMove;
  TMSFNCListBox1.BitmapContainer := TMSFNCBitmapContainer1;
  TMSFNCListBox2.BitmapContainer := TMSFNCBitmapContainer1;
  TMSFNCListBox1.BeginUpdate;
  TMSFNCListBox1.Items.Clear;
  for I := 0 to TMSFNCBitmapContainer1.ItemCount - 1 do
  begin
    it := TMSFNCListBox1.Items.Add;
    it.BitmapName := TMSFNCBitmapContainer1.BitmapNames[I];
    it.Text := it.BitmapName;
  end;
  TMSFNCListBox1.EndUpdate;

end;

procedure TForm1.CheckBox3Change(Sender: TObject);
begin
  if CheckBox3.Checked then
    TMSFNCListBox1.Interaction.Filtering.Enabled := True
  else
  begin
    TMSFNCListBox1.Interaction.Filtering.Enabled := False;
    TMSFNCListBox1.RemoveFilters;
  end;
end;

procedure TForm1.CheckBox4Change(Sender: TObject);
begin
  TMSFNCListBox1.Interaction.Lookup.Enabled := CheckBox4.Checked;
end;

procedure TForm1.CheckBox2Change(Sender: TObject);
begin
  if CheckBox2.Checked then
    TMSFNCListBox1.Interaction.Sorting := lcsNormal
  else
  begin
    TMSFNCListBox1.Interaction.Sorting := lcsNone;
    TMSFNCListBox1.ClearSorting;
  end;
end;

procedure TForm1.CheckBox1Change(Sender: TObject);
begin
  TMSFNCListBox1.Header.Visible := CheckBox1.Checked;
end;

end.

