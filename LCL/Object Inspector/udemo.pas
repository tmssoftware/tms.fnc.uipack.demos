unit UDemo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, LCLTMSFNCObjectInspector,
  LCLTMSFNCBitmapContainer, LCLTMSFNCImage, LCLTMSFNCPlanner, LCLTMSFNCTreeView;

type

  { TForm1 }

  TForm1 = class(TForm)
    ComboBox1: TComboBox;
    Panel1: TPanel;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    TMSFNCObjectInspector1: TTMSFNCObjectInspector;
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
    FActiveControl: TControl;
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
    if Assigned(FActiveControl) then
    FActiveControl.Free;

  case ComboBox1.ItemIndex of
    0:
    begin
      FActiveControl := TButton.Create(Panel1);
      (FActiveControl as TButton).Caption := 'Hello World';
    end;
    1:
    begin
      FActiveControl := TLabel.Create(Panel1);
      (FActiveControl as TLabel).Caption := 'Hello World';
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
    FActiveControl.Left := (Panel1.Width - FActiveControl.Width) div 2;
    FActiveControl.Top := (Panel1.Height - FActiveControl.Height) div 2;
    TMSFNCObjectInspector1.&Object := FActiveControl;
  end
  else
    TMSFNCObjectInspector1.&Object := nil;
end;

procedure TForm1.FormCreate(Sender: TObject);
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

