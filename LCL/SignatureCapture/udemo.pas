unit UDemo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, ComCtrls, LCLTMSFNCSignatureCapture, LCLTMSFNCColorPicker, LCLTMSFNCGraphicsTypes;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Panel1: TPanel;
    TMSFNCColorPicker1: TTMSFNCColorPicker;
    TMSFNCSignatureCapture1: TTMSFNCSignatureCapture;
    TrackBar1: TTrackBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure TMSFNCColorPicker1ColorSelected(Sender: TObject;
      AColor: TTMSFNCGraphicsColor);
    procedure TrackBar1Change(Sender: TObject);

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




procedure TForm1.Button1Click(Sender: TObject);
begin
  TMSFNCSignatureCapture1.SaveToFile('.\' + Edit1.Text);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  try
    TMSFNCSignatureCapture1.LoadFromFile('.\' + Edit2.Text);
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  TMSFNCSignatureCapture1.SaveToImageFile('.\' + Edit3.Text);
end;

procedure TForm1.TMSFNCColorPicker1ColorSelected(Sender: TObject;
  AColor: TTMSFNCGraphicsColor);
begin
  TMSFNCSignatureCapture1.Pen.Color := TMSFNCColorPicker1.SelectedColor;
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
  TMSFNCSignatureCapture1.Pen.Width := TrackBar1.Position;
end;

end.

