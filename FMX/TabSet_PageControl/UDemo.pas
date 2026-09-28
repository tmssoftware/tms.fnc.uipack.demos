unit UDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCBitmapContainer, FMX.TMSFNCToolBar,
  FMX.TMSFNCCustomScrollControl, FMX.TMSFNCDataGridData, FMX.TMSFNCCustomGrid,
  FMX.TMSFNCDataGrid, FMX.TMSFNCPageControl, FMX.TMSFNCCustomControl,
  FMX.TMSFNCTabSet, FMX.TMSFNCImage, FMX.TMSFNCTreeViewBase,
  FMX.TMSFNCTreeViewData, FMX.TMSFNCCustomTreeView, FMX.TMSFNCTreeView,
  FMX.TMSFNCRichEditorToolBar, FMX.TMSFNCTypes, FMX.TMSFNCUtils,
  FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, System.Rtti,
  FMX.TMSFNCDataGridCell, FMX.TMSFNCDataGridBase, FMX.TMSFNCDataGridCore,
  FMX.TMSFNCDataGridRenderer;

type
  TForm1 = class(TForm)
    TMSFNCPageControl1: TTMSFNCPageControl;
    TMSFNCPageControl1Page1: TTMSFNCPageControlContainer;
    TMSFNCPageControl1Page2: TTMSFNCPageControlContainer;
    TMSFNCPageControl1Page3: TTMSFNCPageControlContainer;
    TMSFNCPageControl1Page0: TTMSFNCPageControlContainer;
    TMSFNCDataGrid1: TTMSFNCDataGrid;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    TMSFNCTreeView1: TTMSFNCTreeView;
    TMSFNCImage1: TTMSFNCImage;
    TMSFNCRichEditorFormatToolBar1: TTMSFNCRichEditorFormatToolBar;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.FormCreate(Sender: TObject);
begin
  TMSFNCDataGrid1.LoadFromCSVData('CARS.csv');
  TMSFNCRichEditorFormatToolBar1.FontNamePicker.SelectedFontName := 'Tahoma';
  TMSFNCRichEditorFormatToolBar1.FontSizePicker.SelectedFontSize := 12;
  Fill.Color := gcWhite;
  Fill.Kind := TBrushKind.Solid;
end;

end.
