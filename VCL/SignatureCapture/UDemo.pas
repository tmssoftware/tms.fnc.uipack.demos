unit UDemo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Types,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes,
  VCL.TMSFNCCustomPicker, VCL.TMSFNCDatePicker, VCL.TMSFNCCustomControl,
  VCL.TMSFNCCalendar, VCL.TMSFNCCustomComponent, VCL.TMSFNCBitmapContainer,
  VCL.TMSFNCPanel, VCL.TMSFNCColorPicker, Vcl.ComCtrls,
  VCL.TMSFNCSignatureCapture,
  VCL.TMSFNCButton, VCL.TMSFNCEdit, VCL.TMSFNCHTMLText, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  VCL.TMSFNCTrackBar;

type
  TForm130 = class(TForm)
    SigSecPen: TTMSFNCHTMLText;
    SigSecFiles: TTMSFNCHTMLText;
    SigPenColorCaption: TTMSFNCHTMLText;
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TTMSFNCPanel;
    DemoTitle: TTMSFNCHTMLText;
    DemoDescription: TTMSFNCHTMLText;
    DemoThemeSelector: TTMSFNCThemeSelector;
    TMSFNCSignatureCapture1: TTMSFNCSignatureCapture;
    Panel1: TTMSFNCPanel;
    Button1: TTMSFNCButton;
    Button2: TTMSFNCButton;
    Button3: TTMSFNCButton;
    Edit1: TTMSFNCEdit;
    Edit2: TTMSFNCEdit;
    Edit3: TTMSFNCEdit;
    Label1: TTMSFNCHTMLText;
    TrackBar1: TTMSFNCTrackBar;
    Label2: TTMSFNCHTMLText;
    TMSFNCColorPicker1: TTMSFNCColorPicker;
    Label3: TTMSFNCHTMLText;
    Label4: TTMSFNCHTMLText;
    Label5: TTMSFNCHTMLText;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure TrackBar1ValueChanged(Sender: TObject; AValue: Single);
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

{ demo-colors: TMSFNCColorPicker1 (the pen colour palette) }


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

procedure TForm130.TrackBar1ValueChanged(Sender: TObject; AValue: Single);
begin
  TMSFNCSignatureCapture1.Pen.Width := AValue;
end;

end.
