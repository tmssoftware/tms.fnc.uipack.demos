unit UEditing;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.TMSFNCCustomControl,
  FMX.TMSFNCCustomScrollControl, FMX.TMSFNCDataGridData, FMX.TMSFNCCustomGrid,
  FMX.TMSFNCDataGrid, FMX.TMSFNCDataGridCell, FMX.TMSFNCTypes, FMX.TMSFNCUtils,
  FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCDataGridBase,
  FMX.TMSFNCDataGridCore, FMX.TMSFNCDataGridRenderer, FMX.ListBox,
  FMX.DateTimeCtrls, FMX.Colors, FMX.EditBox, FMX.SpinBox, Rtti;

type
  TForm130 = class(TForm)
    TMSFNCDataGrid1: TTMSFNCDataGrid;
    procedure FormCreate(Sender: TObject);
    procedure TMSFNCDataGrid1GetInplaceEditorProperties(Sender: TObject;
      ACell: TTMSFNCDataGridCellCoord;
      AInplaceEditor: TTMSFNCDataGridInplaceEditor;
      AInplaceEditorType: TTMSFNCDataGridInplaceEditorType);
    procedure TMSFNCDataGrid1CellAnchorClick(Sender: TObject; AColumn,
      ARow: Integer; AAnchor: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form130: TForm130;

implementation

{$R *.fmx}


procedure TForm130.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  TMSFNCDataGrid1.Options.IO.StartColumn := 1;
  TMSFNCDataGrid1.Options.IO.StartRow := 1;
  TMSFNCDataGrid1.LoadFromCSVData('cars.csv');
  TMSFNCDataGrid1.DefaultColumnWidth := 100;
  TMSFNCDataGrid1.DefaultRowHeight := 24;

  TMSFNCDataGrid1.Options.Keyboard.TabKeyDirectEdit := True;
  TMSFNCDataGrid1.Options.Keyboard.ArrowKeyDirectEdit := True;
  TMSFNCDataGrid1.Options.Keyboard.EnterKeyDirectEdit := True;

  TMSFNCDataGrid1.Cells[0, 0] := 'Default';
  TMSFNCDataGrid1.Cells[1, 0] := 'ComboBox';
  TMSFNCDataGrid1.Cells[2, 0] := 'Edit';
  TMSFNCDataGrid1.Cells[3, 0] := 'TrackBar';
  TMSFNCDataGrid1.Cells[4, 0] := 'DatePicker';
  TMSFNCDataGrid1.Cells[5, 0] := 'ColorPicker';
  TMSFNCDataGrid1.Cells[6, 0] := 'SpinBox';
  TMSFNCDataGrid1.Cells[7, 0] := 'HTML Editor';

  TMSFNCDataGrid1.Columns[1].AddSetting(gcsEditor);
  TMSFNCDataGrid1.Columns[1].AddSetting(gcsEditorItems);
  TMSFNCDataGrid1.Columns[1].Editor := getComboBox;
  TMSFNCDataGrid1.Columns[1].EditorItems.Add('Mercedes');
  TMSFNCDataGrid1.Columns[1].EditorItems.Add('Audi');
  TMSFNCDataGrid1.Columns[1].EditorItems.Add('Bugatti');
  TMSFNCDataGrid1.Columns[1].EditorItems.Add('Alfa Romeo');
  TMSFNCDataGrid1.Columns[1].EditorItems.Add('Jaguar');
  TMSFNCDataGrid1.Columns[1].EditorItems.Add('BMW');
  TMSFNCDataGrid1.Columns[3].AddSetting(gcsEditor);
  TMSFNCDataGrid1.Columns[3].Editor := getTrackBar;
  TMSFNCDataGrid1.Columns[4].AddSetting(gcsEditor);
  TMSFNCDataGrid1.Columns[4].Editor := getDatePicker;
  TMSFNCDataGrid1.Columns[4].AddSetting(gcsFormatting);
  TMSFNCDataGrid1.Columns[4].Formatting.&Type := gdftDateTime;
  TMSFNCDataGrid1.Columns[5].AddSetting(gcsEditor);
  TMSFNCDataGrid1.Columns[5].Editor := getColorPicker;
  TMSFNCDataGrid1.Columns[5].AddSetting(gcsEditorTarget);
  TMSFNCDataGrid1.Columns[5].EditorTarget := getFillColor;
  TMSFNCDataGrid1.Columns[6].AddSetting(gcsEditor);
  TMSFNCDataGrid1.Columns[6].Editor := getSpinBox;
  TMSFNCDataGrid1.Columns[7].AddSetting(gcsEditor);
  TMSFNCDataGrid1.Columns[7].Editor := getHTMLEditor;

  TMSFNCDataGrid1.AutoNumberColumn(0, 1);

  for I := 1 to TMSFNCDataGrid1.RowCount - 1 do
  begin
    TMSFNCDataGrid1.Cells[6, I] := Random(100);
    TMSFNCDataGrid1.Cells[4, I] := Int(Now - 100 + Random(200));
    TMSFNCDataGrid1.Cells[7, I] := '<b>This</b> is <i><a href="https://www.tmssoftware.com">HTML</a></i>';
    TMSFNCDataGrid1.Layouts[5, I].Fill.Kind := gfkSolid;
    TMSFNCDataGrid1.Layouts[5, I].Fill.Color := MakeGraphicsColor(Random(255), Random(255), Random(255));
  end;

  TMSFNCDataGrid1.DeleteColumn(8);
  TMSFNCDataGrid1.Options.Column.Stretching.Enabled := True;

  TMSFNCDataGrid1.SetFocus;
end;

procedure TForm130.TMSFNCDataGrid1CellAnchorClick(Sender: TObject; AColumn,
  ARow: Integer; AAnchor: string);
begin
  TTMSFNCUtils.OpenURL(AAnchor);
end;

procedure TForm130.TMSFNCDataGrid1GetInplaceEditorProperties(Sender: TObject;
  ACell: TTMSFNCDataGridCellCoord; AInplaceEditor: TTMSFNCDataGridInplaceEditor;
  AInplaceEditorType: TTMSFNCDataGridInplaceEditorType);
begin
  if AInplaceEditorType = getTrackBar then
    (AInplaceEditor as TTMSFNCDataGridTrackBar).Max := 3000;
end;

end.
