unit UDemo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Types,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes,
  VCL.TMSFNCCustomPicker, VCL.TMSFNCDatePicker, VCL.TMSFNCCustomControl,
  VCL.TMSFNCCalendar, VCL.TMSFNCCustomComponent, VCL.TMSFNCBitmapContainer,
  VCL.TMSFNCPanel, VCL.TMSFNCColorPicker, Vcl.ComCtrls,
  VCL.TMSFNCSignatureCapture;

type
  TForm130 = class(TForm)
    TMSFNCSignatureCapture1: TTMSFNCSignatureCapture;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    TrackBar1: TTrackBar;
    Label2: TLabel;
    TMSFNCColorPicker1: TTMSFNCColorPicker;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TMSFNCColorPicker1ColorSelected(Sender: TObject; AColor: TColor);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form130: TForm130;

implementation

{$R *.dfm}


procedure TForm130.Button1Click(Sender: TObject);
begin
  TMSFNCSignatureCapture1.SaveToFile('.\' + Edit1.Text);
end;

procedure TForm130.Button2Click(Sender: TObject);
begin
  try
    TMSFNCSignatureCapture1.LoadFromFile('.\' + Edit2.Text);
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

procedure TForm130.Button3Click(Sender: TObject);
begin
  TMSFNCSignatureCapture1.SaveToImageFile('.\' + Edit3.Text);
end;

procedure TForm130.TMSFNCColorPicker1ColorSelected(Sender: TObject;
  AColor: TColor);
begin
  TMSFNCSignatureCapture1.Pen.Color := TMSFNCColorPicker1.SelectedColor;
end;

procedure TForm130.TrackBar1Change(Sender: TObject);
begin
  TMSFNCSignatureCapture1.Pen.Width := TrackBar1.Position;
end;

end.
