unit UDemo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VCL.TMSFNCToolBar,
  VCL.TMSFNCCustomScrollControl, VCL.TMSFNCGridData, VCL.TMSFNCCustomGrid,
  VCL.TMSFNCGrid, VCL.TMSFNCPageControl, VCL.TMSFNCCustomControl,
  VCL.TMSFNCTabSet, VCL.TMSFNCRichEditorToolBar, Vcl.Imaging.pngimage,
  VCL.TMSFNCImage, VCL.TMSFNCTreeViewBase, VCL.TMSFNCTreeViewData,
  VCL.TMSFNCCustomTreeView, VCL.TMSFNCTreeView, VCL.TMSFNCCustomComponent,
  VCL.TMSFNCBitmapContainer, VCL.TMSFNCTypes, VCL.TMSFNCUtils,
  VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes;

type
  TForm5 = class(TForm)
    TMSFNCPageControl1: TTMSFNCPageControl;
    TMSFNCPageControl1Page0: TTMSFNCPageControlContainer;
    TMSFNCPageControl1Page1: TTMSFNCPageControlContainer;
    TMSFNCPageControl1Page2: TTMSFNCPageControlContainer;
    TMSFNCPageControl1Page3: TTMSFNCPageControlContainer;
    TMSFNCGrid1: TTMSFNCGrid;
    TMSFNCTreeView1: TTMSFNCTreeView;
    TMSFNCImage1: TTMSFNCImage;
    TMSFNCRichEditorFormatToolBar1: TTMSFNCRichEditorFormatToolBar;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}

procedure TForm5.FormCreate(Sender: TObject);
begin
  TMSFNCGrid1.LoadFromCSV('CARS.csv');
  TMSFNCRichEditorFormatToolBar1.FontNamePicker.SelectedFontName := 'Tahoma';
  TMSFNCRichEditorFormatToolBar1.FontSizePicker.SelectedFontSize := 12;
  Color := gcWhite;
end;

end.
