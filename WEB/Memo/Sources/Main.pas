unit Main;

interface

uses
  System.SysUtils, System.Classes, JS, Web, WEBLib.Graphics, WEBLib.Controls,
  WEBLib.Forms, WEBLib.Dialogs, VCL.TMSFNCTypes, VCL.TMSFNCUtils,
  VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCTabSet, Vcl.Controls,
  VCL.TMSFNCCustomControl, VCL.TMSFNCWebBrowser, VCL.TMSFNCCustomWEBControl,
  VCL.TMSFNCMemo;

type
  TForm4 = class(TWebForm)
    TMSFNCMemo1: TTMSFNCMemo;
    TMSFNCTabSet1: TTMSFNCTabSet;
    procedure TMSFNCTabSet1ChangeTab(Sender: TObject; APreviousTabIndex,
      ACurrentTabIndex: Integer);
    procedure TMSFNCTabSet1InsertTab(Sender: TObject; ANewTabIndex: Integer);
    procedure TMSFNCTabSet1BeforeCloseTab(Sender: TObject; ATabIndex: Integer;
      var ACloseAction: TTMSFNCTabSetTabCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

procedure TForm4.TMSFNCTabSet1BeforeCloseTab(Sender: TObject;
  ATabIndex: Integer; var ACloseAction: TTMSFNCTabSetTabCloseAction);
begin
  TTMSFNCUtils.Log(TMSFNCMemo1.Sources.Count.ToString);
  TMSFNCMemo1.Sources.Delete(ATabIndex);
end;

procedure TForm4.TMSFNCTabSet1ChangeTab(Sender: TObject; APreviousTabIndex,
  ACurrentTabIndex: Integer);
begin
    TMSFNCMemo1.ActiveSource := ACurrentTabIndex;
end;

procedure TForm4.TMSFNCTabSet1InsertTab(Sender: TObject; ANewTabIndex: Integer);
var
  s: TTMSFNCMemoSource;
begin
  s := TMSFNCMemo1.Sources.Add;
  TMSFNCTabSet1.Tabs[ANewTabIndex].Text := s.Name;
end;

end.
