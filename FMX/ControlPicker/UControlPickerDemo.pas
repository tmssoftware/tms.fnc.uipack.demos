unit UControlPickerDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.Layouts, FMX.ListBox, FMX.TMSFNCCustomScrollControl, FMX.TMSFNCListEditor,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TMSFNCTreeViewBase,
  FMX.TMSFNCTreeViewData, FMX.TMSFNCCustomTreeView, FMX.TMSFNCTreeView,
  FMX.TMSFNCCustomControl, FMX.TMSFNCCustomPicker, FMX.TMSFNCControlPicker;

type
  TButtonEx = class(TButton, ITMSFNCControlPickerBase)
  private
    FCount: Integer;
    function PickerGetContent: String;
  protected
    procedure Click; override;
  public
    constructor Create(AOwner: TComponent); override;
    property Count: Integer read FCount write FCount;
  end;

  TForm2 = class(TForm)
    TMSFNCControlPicker1: TTMSFNCControlPicker;
    TMSFNCTreeView1: TTMSFNCTreeView;
    Label1: TLabel;
    Label2: TLabel;
    TMSFNCControlPicker2: TTMSFNCControlPicker;
    Label3: TLabel;
    TMSFNCControlPicker3: TTMSFNCControlPicker;
    TMSFNCListEditor1: TTMSFNCListEditor;
    ListBox1: TListBox;
    TMSFNCControlPicker4: TTMSFNCControlPicker;
    Label4: TLabel;
    procedure TMSFNCControlPicker3SetContent(Sender: TObject; var AText: string;
      var AAllow: Boolean);
    procedure TMSFNCControlPicker3AdjustDropDownHeight(Sender: TObject;
      var ASize: Single; var AAllow: Boolean);
    procedure ListBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    b: TButtonEx;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation
uses
  FMX.TMSFNCCustomSelector;

{$R *.fmx}

procedure TForm2.FormCreate(Sender: TObject);
begin
  b := TButtonEx.Create(Self);
  b.Parent := self;

  TMSFNCControlPicker4.Control := b;
end;

procedure TForm2.ListBox1Click(Sender: TObject);
begin
  TMSFNCControlPicker3.CallItemClicked(ListBox1.ItemIndex);
end;

procedure TForm2.TMSFNCControlPicker3AdjustDropDownHeight(Sender: TObject;
  var ASize: Single; var AAllow: Boolean);
begin
  //Show 3 Items
  ASize := 4 * ListBox1.ItemHeight;
end;

procedure TForm2.TMSFNCControlPicker3SetContent(Sender: TObject; var AText: string; var AAllow: Boolean);
begin
  if ListBox1.ItemIndex >=0 then
    AText := ListBox1.Items[ListBox1.ItemIndex]
  else
    AText := ListBox1.Name;
end;

{ ButtonEx }

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

function TButtonEx.PickerGetContent: String;
begin
  Result := IntToStr(Count) + ' Clicks';
end;

end.
