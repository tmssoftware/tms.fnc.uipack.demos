unit ucontrolpicker;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  LCLTMSFNCControlPicker, LCLTMSFNCTreeView, LCLTMSFNCListEditor;

type
   TButtonEx = class(TButton, ITMSFNCControlPickerBase)
  private
    FCount: Integer;
    function PickerGetContent: String;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Click; override;
    property Count: Integer read FCount write FCount;
  end;

  { TForm1 }

  TForm1 = class(TForm)
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
    procedure FormCreate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure TMSFNCControlPicker3AdjustDropDownHeight(Sender: TObject;
      var ASize: Single; var AAllow: Boolean);
    procedure TMSFNCControlPicker3SetContent(Sender: TObject;
      var AText: string; var AAllow: Boolean);
  private
    b: TButtonEx;
  public

  end;

var
  Form1: TForm1;

implementation
uses
  LCLTMSFNCCustomSelector;

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  b := TButtonEx.Create(Self);
  b.Parent := Self;

  TMSFNCControlPicker4.Control := b;
end;

procedure TForm1.ListBox1Click(Sender: TObject);
begin
  TMSFNCControlPicker3.CallItemClicked(ListBox1.ItemIndex);
end;

procedure TForm1.TMSFNCControlPicker3AdjustDropDownHeight(Sender: TObject;
  var ASize: Single; var AAllow: Boolean);
begin
  ASize := ListBox1.ItemHeight * 4;
end;

procedure TForm1.TMSFNCControlPicker3SetContent(Sender: TObject;
  var AText: string; var AAllow: Boolean);
begin
  if ListBox1.ItemIndex >= 0 then
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

function TButtonEx.PickerGetContent: String;
begin
  Result := IntToStr(Count) + ' Clicks';
end;

end.

