unit Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCWebBrowser, FMX.TMSFNCCustomWEBControl, FMX.TMSFNCMemo,
  FMX.TMSFNCCustomControl, FMX.TMSFNCTabSet, FMX.TMSFNCToolBar;

type
  TForm3 = class(TForm)
    TMSFNCTabSet1: TTMSFNCTabSet;
    TMSFNCMemo1: TTMSFNCMemo;
    TMSFNCToolBar1: TTMSFNCToolBar;
    TMSFNCToolBarButton1: TTMSFNCToolBarButton;
    TMSFNCToolBarButton2: TTMSFNCToolBarButton;
    OpenDialog1: TOpenDialog;

    procedure TMSFNCTabSet1InsertTab(Sender: TObject; ANewTabIndex: Integer);
    procedure TMSFNCTabSet1ChangeTab(Sender: TObject; APreviousTabIndex,
      ACurrentTabIndex: Integer);
    procedure TMSFNCToolBarButton1Click(Sender: TObject);
    procedure TMSFNCToolBarButton2Click(Sender: TObject);
    procedure TMSFNCTabSet1BeforeCloseTab(Sender: TObject; ATabIndex: Integer;
      var ACloseAction: TTMSFNCTabSetTabCloseAction);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.fmx}

procedure TForm3.TMSFNCTabSet1BeforeCloseTab(Sender: TObject;
  ATabIndex: Integer; var ACloseAction: TTMSFNCTabSetTabCloseAction);
begin
  TMSFNCMemo1.Sources.Delete(ATabIndex);
end;

procedure TForm3.TMSFNCTabSet1ChangeTab(Sender: TObject; APreviousTabIndex,
  ACurrentTabIndex: Integer);
begin
  TMSFNCMemo1.ActiveSource := ACurrentTabIndex;
end;

procedure TForm3.TMSFNCTabSet1InsertTab(Sender: TObject; ANewTabIndex: Integer);
var
  s: TTMSFNCMemoSource;
begin
  s := TMSFNCMemo1.Sources.Add;
  TMSFNCTabSet1.Tabs[ANewTabIndex].Text := s.Name;
end;

procedure TForm3.TMSFNCToolBarButton1Click(Sender: TObject);
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

procedure TForm3.TMSFNCToolBarButton2Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    TMSFNCMemo1.Lines.SaveToFile(OpenDialog1.Files[0]);
end;

end.
