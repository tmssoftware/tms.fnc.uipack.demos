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
  VCL.TMSFNCBitmapContainer;
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics,
  WEBLib.Forms, WEBLib.Dialogs, WEBLib.StdCtrls, UBL,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCKanbanBoard, WEBLib.TMSFNCKanbanBoardDatabaseAdapter,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomComponent, WEBLib.TMSFNCCustomScrollControl, WEBLib.Controls,
  WEBLIB.TMSFNCBitmapContainer, Vcl.Controls, VCL.TMSFNCCustomComponent,
  VCL.TMSFNCBitmapContainer;
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs, UBL,
  FMX.TMSFNCCustomControl, FMX.TMSFNCKanbanBoard, FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics,
  FMX.TMSFNCGraphicsTypes, FMX.TMSFNCKanbanBoardDatabaseAdapter,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCBitmapContainer;
  {$ENDIF}

  {$IFDEF LCL}
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, UBL, LCLTMSFNCBitmapContainer;
  {$ENDIF}

type
  {$IFDEF WEBLIB}
  TForm1 = class(TWebForm)
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
