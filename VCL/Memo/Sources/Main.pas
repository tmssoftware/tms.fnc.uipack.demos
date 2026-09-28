unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VCL.TMSFNCTypes, VCL.TMSFNCUtils,
  VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCToolBar,
  VCL.TMSFNCWebBrowser, VCL.TMSFNCCustomWEBControl, VCL.TMSFNCMemo,
  VCL.TMSFNCCustomControl, VCL.TMSFNCTabSet;

type
  TForm1 = class(TForm)
    TMSFNCTabSet1: TTMSFNCTabSet;
    TMSFNCMemo1: TTMSFNCMemo;
    TMSFNCToolBar1: TTMSFNCToolBar;
    TMSFNCToolBarButton1: TTMSFNCToolBarButton;
    TMSFNCToolBarButton2: TTMSFNCToolBarButton;
    OpenDialog1: TOpenDialog;
    procedure TMSFNCTabSet1CloseTab(Sender: TObject; ATabIndex: Integer;
      ACloseAction: TTMSFNCTabSetTabCloseAction);
    procedure TMSFNCTabSet1ChangeTab(Sender: TObject; APreviousTabIndex,
      ACurrentTabIndex: Integer);
    procedure TMSFNCTabSet1InsertTab(Sender: TObject; ANewTabIndex: Integer);
    procedure TMSFNCToolBarButton1Click(Sender: TObject);
    procedure TMSFNCToolBarButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.TMSFNCTabSet1ChangeTab(Sender: TObject; APreviousTabIndex,
  ACurrentTabIndex: Integer);
begin
 TMSFNCMemo1.ActiveSource := ACurrentTabIndex;
end;

procedure TForm1.TMSFNCTabSet1CloseTab(Sender: TObject; ATabIndex: Integer;
  ACloseAction: TTMSFNCTabSetTabCloseAction);
begin
  TMSFNCMemo1.Sources.Delete(ATabIndex);
end;

procedure TForm1.TMSFNCTabSet1InsertTab(Sender: TObject; ANewTabIndex: Integer);
var
  s: TTMSFNCMemoSource;
begin
  s := TMSFNCMemo1.Sources.Add;
  TMSFNCTabSet1.Tabs[ANewTabIndex].Text := s.Name;
end;

procedure TForm1.TMSFNCToolBarButton1Click(Sender: TObject);
var
  s: TTMSFNCMemoSource;
  ext: string;
begin
  if OpenDIalog1.Execute then
  begin
    s := TMSFNCMemo1.AddSourceFromFile(OpenDialog1.Files[0]);
    TMSFNCTabSet1.AddTab(s.Name);
    TMSFNCMemo1.LoadFromFile(OpenDialog1.Files[0]);
  end;
end;

procedure TForm1.TMSFNCToolBarButton2Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    TMSFNCMemo1.Lines.SaveToFile(OpenDialog1.Files[0]);
end;

end.
