unit UDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.TMSFNCCustomControl, FMX.TMSFNCListBox,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCBitmapContainer, FMX.TMSFNCTypes,
  FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCCheckBox, FMX.TMSFNCHTMLText, FMX.TMSFNCPanel, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector;

type
  TForm130 = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TTMSFNCPanel;
    DemoTitle: TTMSFNCHTMLText;
    DemoDescription: TTMSFNCHTMLText;
    DemoThemeSelector: TTMSFNCThemeSelector;
    LookupHint: TTMSFNCHTMLText;
    SettingsCaption: TTMSFNCHTMLText;
    SettingsPanel: TTMSFNCPanel;
    TMSFNCListBox1: TTMSFNCListBox;
    TMSFNCListBox2: TTMSFNCListBox;
    Label1: TTMSFNCHTMLText;
    CheckBox1: TTMSFNCCheckBox;
    CheckBox2: TTMSFNCCheckBox;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    CheckBox3: TTMSFNCCheckBox;
    CheckBox4: TTMSFNCCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox3Change(Sender: TObject);
    procedure CheckBox4Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form130: TForm130;

implementation

{$R *.fmx}

procedure TForm130.CheckBox1Change(Sender: TObject);
begin
  TMSFNCListBox1.Header.Visible := CheckBox1.Checked;
end;

procedure TForm130.CheckBox2Change(Sender: TObject);
begin
  if CheckBox2.Checked then
    TMSFNCListBox1.Interaction.Sorting := lcsNormal
  else
  begin
    TMSFNCListBox1.Interaction.Sorting := lcsNone;
    TMSFNCListBox1.ClearSorting;
  end;
end;

procedure TForm130.CheckBox3Change(Sender: TObject);
begin
  if CheckBox3.Checked then
    TMSFNCListBox1.Interaction.Filtering.Enabled := True
  else
  begin
    TMSFNCListBox1.Interaction.Filtering.Enabled := False;
    TMSFNCListBox1.RemoveFilters;
  end;
end;

procedure TForm130.CheckBox4Change(Sender: TObject);
begin
  TMSFNCListBox1.Interaction.Lookup.Enabled := CheckBox4.Checked;
end;

procedure TForm130.FormCreate(Sender: TObject);
var
  it: TTMSFNCListBoxItem;
  I: Integer;
begin
  TMSFNCListBox1.ItemsAppearance.HeightMode := lihmVariable;
  TMSFNCListBox2.ItemsAppearance.HeightMode := lihmVariable;
  TMSFNCListBox1.Header.Text := 'Birthday shopping list';
  TMSFNCListBox1.Header.Visible := True;
  TMSFNCListBox1.Header.HorizontalTextAlign := gtaLeading;
  TMSFNCListBox1.Header.Size := 40;
  TMSFNCListBox1.Header.Font.Size := 14;

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

end.
