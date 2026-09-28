unit UDemo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VCL.TMSFNCCustomControl,
  VCL.TMSFNCTreeViewBase, VCL.TMSFNCTreeViewData, VCL.TMSFNCCustomTreeView,
  VCL.TMSFNCTreeView, Vcl.StdCtrls, VCL.TMSFNCCustomComponent,
  VCL.TMSFNCBitmapContainer, Vcl.ExtCtrls, VCL.TMSFNCTypes, VCL.TMSFNCUtils,
  VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCDigitalTimePicker,
  VCL.TMSFNCAnalogTimePicker, VCL.TMSFNCStrokeKindPicker,
  VCL.TMSFNCStrokeKindSelector, VCL.TMSFNCCustomPicker,
  VCL.TMSFNCFillKindPicker, VCL.TMSFNCFillKindSelector, VCL.TMSFNCAnalogTimeSelector,
  VCL.TMSFNCCustomSelector, VCL.TMSFNCDigitalTimeSelector, VCL.TMSFNCPanel,
  VCL.TMSFNCColorSelector, VCL.TMSFNCColorPicker, VCL.TMSFNCColorWheel,
  VCL.TMSFNCHTMLText, VCL.TMSFNCFontDialog, VCL.TMSFNCDateTimePicker,
  VCL.TMSFNCCustomScrollControl, VCL.TMSFNCListEditor, VCL.TMSFNCControlPicker;

type
  TButtonEx = class(TButton, ITMSFNCControlPickerBase)
  private
    FCount: Integer;
    procedure PickerBeginUpdate;
    procedure PickerEndUpdate;
    function PickerGetContent: String;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Click; override;
    property Count: Integer read FCount write FCount;
  end;

  TForm130 = class(TForm)
    Label1: TLabel;
    TMSFNCControlPicker1: TTMSFNCControlPicker;
    TMSFNCTreeView1: TTMSFNCTreeView;
    Label2: TLabel;
    TMSFNCControlPicker2: TTMSFNCControlPicker;
    TMSFNCControlPicker3: TTMSFNCControlPicker;
    Label3: TLabel;
    TMSFNCControlPicker4: TTMSFNCControlPicker;
    Label4: TLabel;
    TMSFNCListEditor1: TTMSFNCListEditor;
    ListBox1: TListBox;
    procedure TMSFNCControlPicker3SetContent(Sender: TObject; var AText: string; var AAllow: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure TMSFNCControlPicker3AdjustDropDownHeight(Sender: TObject; var ASize: Single; var AAllow: Boolean);
    procedure ListBox1Click(Sender: TObject);
  private
    { Private declarations }
    b: TButtonEx;
  public
    { Public declarations }
  end;

var
  Form130: TForm130;

implementation

{$R *.dfm}


{ TForm130 }

procedure TForm130.FormCreate(Sender: TObject);
begin
  b := TButtonEx.Create(Self);
  b.Parent := Self;

  TMSFNCControlPicker4.Control := b;
end;

procedure TForm130.ListBox1Click(Sender: TObject);
begin
  TMSFNCControlPicker3.CallItemClicked(ListBox1.ItemIndex);
end;

procedure TForm130.TMSFNCControlPicker3AdjustDropDownHeight(Sender: TObject;
  var ASize: Single; var AAllow: Boolean);
begin
  ASize := ListBox1.ItemHeight * 4;
end;


procedure TForm130.TMSFNCControlPicker3SetContent(Sender: TObject;
  var AText: string; var AAllow: Boolean);
begin
  if ListBox1.HandleAllocated and (ListBox1.ItemIndex >= 0) then
    AText := ListBox1.Items[ListBox1.ItemIndex]
  else
    AText := ListBox1.Name;
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
  Text := 'Click this';
end;

procedure TButtonEx.PickerBeginUpdate;
begin
  //
end;

procedure TButtonEx.PickerEndUpdate;
begin
  //
end;

function TButtonEx.PickerGetContent: String;
begin
  Result := IntToStr(Count) + ' Clicks';
end;

end.
