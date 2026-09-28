unit UDemo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  LCLTMSFNCPageControl, LCLTMSFNCTreeView, LCLTMSFNCImage, LCLTMSFNCGrid,
  LCLTMSFNCBitmapContainer, LCLTMSFNCRichEditorToolBar;

type

  { TForm1 }

  TForm1 = class(TForm)
    TMSFNCGrid1: TTMSFNCGrid;
    TMSFNCPageControl1: TTMSFNCPageControl;
    TMSFNCPageControl1Page0: TTMSFNCPageControlContainer;
    TMSFNCPageControl1Page1: TTMSFNCPageControlContainer;
    TMSFNCPageControl1Page2: TTMSFNCPageControlContainer;
    TMSFNCRichEditorFormatToolBar1: TTMSFNCRichEditorFormatToolBar;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

end.

