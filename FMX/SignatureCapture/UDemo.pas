unit UDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.StdCtrls, FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Controls.Presentation,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.Edit, FMX.TMSFNCCustomControl, FMX.TMSFNCSignatureCapture,
  FMX.TMSFNCCustomPicker, FMX.TMSFNCColorPicker,
  FMX.TMSFNCButton, FMX.TMSFNCEdit, FMX.TMSFNCHTMLText, FMX.TMSFNCPanel, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
  FMX.TMSFNCTrackBar;

type
  TForm130 = class(TForm)
    SigSecPen: TTMSFNCHTMLText;
    SigSecFiles: TTMSFNCHTMLText;
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
    Label2: TTMSFNCHTMLText;
    TrackBar1: TTMSFNCTrackBar;
    TMSFNCColorPicker1: TTMSFNCColorPicker;
    Label3: TTMSFNCHTMLText;
    Label4: TTMSFNCHTMLText;
    Label5: TTMSFNCHTMLText;
    Label6: TTMSFNCHTMLText;
    procedure TrackBar1ValueChanged(Sender: TObject; AValue: Single);
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

{ demo-colors: TMSFNCColorPicker1 (the pen colour palette), TMSFNCSignatureCapture1.Pen.Color (the teal pen is the demo's starting colour, in sync with the picker) }

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

procedure TForm130.TrackBar1ValueChanged(Sender: TObject; AValue: Single);
begin
  TMSFNCSignatureCapture1.Pen.Width := AValue;
end;

end.
