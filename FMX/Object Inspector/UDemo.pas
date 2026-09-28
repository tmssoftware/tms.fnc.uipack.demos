unit UDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.TMSFNCCustomComponent,
  FMX.TMSFNCBitmapContainer, FMX.TMSFNCTypes, FMX.TMSFNCUtils,
  FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCTreeViewBase, FMX.TMSFNCTreeViewData, FMX.TMSFNCCustomTreeView,
  FMX.TMSFNCTreeView, FMX.TMSFNCObjectInspector, FMX.ListBox, FMX.TMSFNCPlanner, FMX.TMSFNCImage;

type
  TForm130 = class(TForm)
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    TMSFNCObjectInspector1: TTMSFNCObjectInspector;
    Panel1: TPanel;
    ComboBox1: TComboBox;
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

{$R *.fmx}

procedure TForm130.ComboBox1Change(Sender: TObject);
begin
  if Assigned(FActiveControl) then
    FActiveControl.Free;

  case ComboBox1.ItemIndex of
    0:
    begin
      FActiveControl := TButton.Create(Panel1);
      (FActiveControl as TButton).Text := 'Hello World';
    end;
    1:
    begin
      FActiveControl := TLabel.Create(Panel1);
      (FActiveControl as TLabel).Text := 'Hello World';
    end;
    2:
    begin
      FActiveControl := TListBox.Create(Self);
      (FActiveControl as TListBox).Items.Add('BMW');
      (FActiveControl as TListBox).Items.Add('Audi');
      (FActiveControl as TListBox).Items.Add('Mercedes');
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
    FActiveControl.Position.X := (Panel1.Width - FActiveControl.Width) / 2;
    FActiveControl.Position.Y := (Panel1.Height - FActiveControl.Height) / 2;
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
  FActiveControl.Position.X := (Panel1.Width - FActiveControl.Width) / 2;
  FActiveControl.Position.Y := (Panel1.Height - FActiveControl.Height) / 2;
  TMSFNCObjectInspector1.&Object := FActiveControl;
  ComboBox1.ItemIndex := 4;
end;

end.
