unit UDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.StdCtrls, FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Controls.Presentation,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.Edit, FMX.TMSFNCCustomControl, FMX.TMSFNCSignatureCapture,
  FMX.TMSFNCCustomPicker, FMX.TMSFNCColorPicker;

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
    Label2: TLabel;
    TrackBar1: TTrackBar;
    TMSFNCColorPicker1: TTMSFNCColorPicker;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure TrackBar1Change(Sender: TObject);
    procedure TMSFNCColorPicker1ColorSelected(Sender: TObject; AColor: TAlphaColor);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form130: TForm130;

implementation

{$R *.fmx}

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
  AColor: TAlphaColor);
begin
  TMSFNCSignatureCapture1.Pen.Color := TMSFNCColorPicker1.SelectedColor;
end;

procedure TForm130.TrackBar1Change(Sender: TObject);
begin
  TMSFNCSignatureCapture1.Pen.Width := TrackBar1.Value;
end;

end.
