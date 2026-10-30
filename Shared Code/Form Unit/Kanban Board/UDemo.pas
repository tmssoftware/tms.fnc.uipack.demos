unit UDemo;

interface

{$IFDEF LCL}
{$mode objfpc}{$H+}{$modeswitch advancedrecords}
{$ENDIF}

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, UBL,
  VCL.TMSFNCCustomControl, VCL.TMSFNCKanbanBoard, VCL.TMSFNCKanbanBoardDatabaseAdapter,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes,
  VCL.TMSFNCCustomComponent, VCL.TMSFNCCustomScrollControl,
  VCL.TMSFNCBitmapContainer, VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector;
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics,
  WEBLib.Forms, WEBLib.Dialogs, WEBLib.StdCtrls, UBL,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCKanbanBoard, WEBLib.TMSFNCKanbanBoardDatabaseAdapter,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomComponent, WEBLib.TMSFNCCustomScrollControl, WEBLib.Controls,
  WEBLIB.TMSFNCBitmapContainer, Vcl.Controls, VCL.TMSFNCCustomComponent,
  VCL.TMSFNCBitmapContainer, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCTheme,
  WEBLib.TMSFNCThemeSelector;
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs, UBL,
  FMX.TMSFNCCustomControl, FMX.TMSFNCKanbanBoard, FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics,
  FMX.TMSFNCGraphicsTypes, FMX.TMSFNCKanbanBoardDatabaseAdapter,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCBitmapContainer, FMX.TMSFNCPanel, FMX.TMSFNCHTMLText,
  FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector;
  {$ENDIF}

  {$IFDEF LCL}
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, UBL, LCLTMSFNCBitmapContainer;
  {$ENDIF}

type
  {$IFDEF WEBLIB}
  TForm1 = class(TWebForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TTMSFNCPanel;
    DemoTitle: TTMSFNCHTMLText;
    DemoDescription: TTMSFNCHTMLText;
    DemoThemeSelector: TTMSFNCThemeSelector;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FKanbanBoardLogic: TKanbanBoardLogic;
  public
  end;
  {$ENDIF}
  {$IFNDEF WEBLIB}
  TForm1 = class(TForm)
    {$IFDEF LCL}
    { LCL has no theme manager: a native header }
    DemoHeader: TPanel;
    DemoTitle: TLabel;
    DemoDescription: TLabel;
    {$ELSE}
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TTMSFNCPanel;
    DemoTitle: TTMSFNCHTMLText;
    DemoDescription: TTMSFNCHTMLText;
    DemoThemeSelector: TTMSFNCThemeSelector;
    {$ENDIF}
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FKanbanBoardLogic: TKanbanBoardLogic;
  public
  end;
  {$ENDIF}

var
  Form1: TForm1;

implementation

{$IFDEF FMX}
{$R *.fmx}
{$ENDIF}
{$IFDEF VCL}
{$R *.dfm}
{$ENDIF}
{$IFDEF WEBLIB}
{$R *.dfm}
{$ENDIF}
{$IFDEF LCL}
{$R *.lfm}
{$ENDIF}

procedure TForm1.FormCreate(Sender: TObject);
begin
  FKanbanBoardLogic := TKanbanBoardLogic.Create;
  FKanbanBoardLogic.InitKanbanBoard(Self, TMSFNCBitmapContainer1);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FKanbanBoardLogic.Free;
end;

end.
