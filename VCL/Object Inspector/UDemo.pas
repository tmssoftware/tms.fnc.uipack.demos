unit UDemo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VCL.TMSFNCCustomControl,
  VCL.TMSFNCListBox, VCL.TMSFNCCustomComponent, VCL.TMSFNCBitmapContainer,
  Vcl.StdCtrls, VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics,
  VCL.TMSFNCGraphicsTypes, Vcl.ExtCtrls, VCL.TMSFNCTreeViewBase,
  VCL.TMSFNCTreeViewData, VCL.TMSFNCCustomTreeView, VCL.TMSFNCTreeView,
  VCL.TMSFNCObjectInspector, VCL.TMSFNCImage, VCL.TMSFNCPlanner,
  VCL.TMSFNCComboBox, VCL.TMSFNCButton, VCL.TMSFNCHTMLText, VCL.TMSFNCPanel, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector;

type
  TForm130 = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TTMSFNCPanel;
    DemoTitle: TTMSFNCHTMLText;
    DemoDescription: TTMSFNCHTMLText;
    DemoThemeSelector: TTMSFNCThemeSelector;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    TMSFNCObjectInspector1: TTMSFNCObjectInspector;
    Panel1: TTMSFNCPanel;
    ComboBox1: TTMSFNCComboBox;
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FActiveControl: TControl;
  public
    { Public declarations }
  end;

var
  Form130: TForm130;

implementation

{$R *.dfm}

procedure TForm130.ComboBox1Change(Sender: TObject);
begin
  if Assigned(FActiveControl) then
    FActiveControl.Free;

  case ComboBox1.ItemIndex of
    0:
    begin
      FActiveControl := TTMSFNCButton.Create(Panel1);
      (FActiveControl as TTMSFNCButton).Text := 'Hello World';
      FActiveControl.Width := 120;
      FActiveControl.Height := 32;
    end;
    1:
    begin
      FActiveControl := TTMSFNCHTMLText.Create(Panel1);
      (FActiveControl as TTMSFNCHTMLText).Text := 'Hello World';
      FActiveControl.Width := 120;
      FActiveControl.Height := 32;
    end;
    2:
    begin
      FActiveControl := TTMSFNCListBox.Create(Self);
      (FActiveControl as TTMSFNCListBox).Items.Add('BMW');
      (FActiveControl as TTMSFNCListBox).Items.Add('Audi');
      (FActiveControl as TTMSFNCListBox).Items.Add('Mercedes');
    end;
    3:
    begin
      FActiveControl := TTMSFNCImage.Create(Panel1);
      (FActiveControl as TTMSFNCImage).Bitmap.Assign(TMSFNCBitmapContainer1.RandomBitmap);
    end;
    4:
    begin
      FActiveControl := TTMSFNCTreeView.Create(Panel1);
      (FActiveControl as TTMSFNCTreeView).InitSample;
    end;
    5:
    begin
      FActiveControl := TTMSFNCPlanner.Create(Panel1);
      (FActiveControl as TTMSFNCPlanner).InitSample;
    end;
  end;

  if Assigned(FActiveControl) then
  begin
    FActiveControl.Parent := Panel1;
    FActiveControl.Left := (Panel1.Width - FActiveControl.Width) div 2;
    FActiveControl.Top := (Panel1.Height - FActiveControl.Height) div 2;
    TMSFNCObjectInspector1.&Object := FActiveControl;
  end
  else
    TMSFNCObjectInspector1.&Object := nil;
end;

procedure TForm130.FormCreate(Sender: TObject);
begin
  FActiveControl := TTMSFNCTreeView.Create(Self);
 (FActiveControl as TTMSFNCTreeView).InitSample;
  FActiveControl.Parent := Panel1;
  FActiveControl.Left := (Panel1.Width - FActiveControl.Width) div 2;
  FActiveControl.Top := (Panel1.Height - FActiveControl.Height) div 2;
  TMSFNCObjectInspector1.&Object := FActiveControl;
  ComboBox1.ItemIndex := 4;
end;

end.
