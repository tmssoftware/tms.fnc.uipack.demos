unit UControlPickerDemo;

interface

uses
  System.SysUtils, System.Types, System.Classes, System.DateUtils, JS, Web, WEBLib.Graphics, WEBLib.Controls,
  WEBLib.Forms, VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics,
  VCL.TMSFNCGraphicsTypes, VCL.TMSFNCPassLock, Vcl.StdCtrls, WEBLib.StdCtrls,
  VCL.TMSFNCCustomControl, VCL.TMSFNCSplitter, Vcl.Controls, WEBLib.ExtCtrls,
  VCL.TMSFNCImage, VCL.TMSFNCControlPicker, VCL.TMSFNCCustomScrollControl,
  VCL.TMSFNCListEditor, VCL.TMSFNCTreeViewBase, VCL.TMSFNCTreeViewData,
  VCL.TMSFNCCustomTreeView, VCL.TMSFNCTreeView, VCL.TMSFNCCustomPicker;

type
  TButtonEx = class(TWebButton, ITMSFNCControlPickerBase)
  private
    FCount: Integer;
    function PickerGetContent: String;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Click; override;
    property Count: Integer read FCount write FCount;
  end;

  TForm1 = class(TWebForm)
    WebLabel1: TWebLabel;
    TMSFNCControlPicker1: TTMSFNCControlPicker;
    WebLabel2: TWebLabel;
    TMSFNCControlPicker2: TTMSFNCControlPicker;
    WebLabel3: TWebLabel;
    TMSFNCControlPicker3: TTMSFNCControlPicker;
    WebLabel4: TWebLabel;
    TMSFNCControlPicker4: TTMSFNCControlPicker;
    TMSFNCTreeView1: TTMSFNCTreeView;
    TMSFNCListEditor1: TTMSFNCListEditor;
    WebListBox1: TWebListBox;
    procedure WebFormCreate(Sender: TObject);
    procedure TMSFNCControlPicker3AdjustDropDownHeight(Sender: TObject;
      var ASize: Single; var AAllow: Boolean);
    procedure TMSFNCControlPicker3SetContent(Sender: TObject; var AText: string;
      var AAllow: Boolean);
    procedure WebListBox1Click(Sender: TObject);
  private
    { Private declarations }
    b: TButtonEx;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
uses
  WEBLib.TMSFNCCustomSelector;

{$R *.dfm}
procedure TForm1.TMSFNCControlPicker3AdjustDropDownHeight(Sender: TObject;
  var ASize: Single; var AAllow: Boolean);
begin
  ASize := WebListBox1.ItemHeight * 4;
end;

procedure TForm1.TMSFNCControlPicker3SetContent(Sender: TObject;
  var AText: string; var AAllow: Boolean);
begin
  if WebListBox1.ItemIndex >= 0 then
    AText := WebListBox1.Items[WebListBox1.ItemIndex]
  else
    AText := WebListBox1.Name;
end;

procedure TForm1.WebFormCreate(Sender: TObject);
var
  lbl: TWebLabel;
begin
  FormContainer := 'appcontent';
  lbl := TLabel.Create(Self);
  lbl.ElementID := 'title';
  lbl.Caption := 'TMS FNC UI Pack';

  lbl := TLabel.Create(Self);
  lbl.ElementID := 'description';
  lbl.Caption := 'TMS FNC Control Picker';

  b := TButtonEx.Create(Self);
  b.Parent := Self;

  TMSFNCControlPicker4.Control := b;
  TMSFNCControlPicker1.Control := TMSFNCTreeView1;
end;

procedure TForm1.WebListBox1Click(Sender: TObject);
begin
  TMSFNCControlPicker3.CallItemClicked(WebListBox1.ItemIndex);
end;

{ TButtonEx }

procedure TButtonEx.Click;
begin
  inherited;
  Count := Count + 1;

  if Assigned(Parent) and (Parent is TTMSFNCCustomSelector) and Assigned(Parent.Owner) and (Parent.Owner is TTMSFNCControlPicker)then
  begin
    //Update ControlPicker if assigned as control
    (Parent.Owner as TTMSFNCControlPicker).UpdateDropDown;
  end;
end;

constructor TButtonEx.Create(AOwner: TComponent);
begin
  inherited;
  Count := 0;
  Caption := 'Click this';
end;

function TButtonEx.PickerGetContent: String;
begin
  Result := IntToStr(Count) + ' Clicks';
end;

end.


