unit UBL;

interface

{$IFDEF LCL}
{$mode objfpc}{$H+}{$modeswitch advancedrecords}
{$ENDIF}

uses
  {$IFDEF VCL}
  Classes, SysUtils, VCL.TMSFNCKanbanBoard, VCL.TMSFNCCustomControl, VCL.TMSFNCKanbanBoardDatabaseAdapter, VCL.TMSFNCBitmapContainer,
  Generics.Collections, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCUtils, VCL.Forms, Data.DB, DataSnap.DBClient, VCL.TMSFNCPanel, VCL.TMSFNCColorPicker,
  VCL.TMSFNCEdit, VCL.TMSFNCHTMLText, VCL.TMSFNCColorSelector, VCL.StdCtrls, VCL.TMSFNCTypes, UITypes;
  {$ENDIF}

  {$IFDEF FMX}
  Classes, SysUtils, FMX.TMSFNCKanbanBoard, FMX.TMSFNCCustomControl, FMX.TMSFNCKanbanBoardDatabaseAdapter, FMX.TMSFNCBitmapContainer,
  Generics.Collections, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCUtils, FMX.Forms, Data.DB, DataSnap.DBClient, FMX.TMSFNCPanel, FMX.TMSFNCColorPicker,
  FMX.TMSFNCEdit, FMX.Memo, FMX.TMSFNCHTMLText, FMX.TMSFNCColorSelector, FMX.TMSFNCTypes, UITypes;
  {$ENDIF}

  {$IFDEF LCL}
  Classes, SysUtils, LCLTMSFNCCustomControl, LCLTMSFNCKanbanBoard, LCLTMSFNCKanbanBoardDataBaseAdapter, LCLTMSFNCBitmapContainer,
  LCLTMSFNCGraphicsTypes, LCLTMSFNCUTils, DateUtils, Forms, LCLTMSFNCPanel, LCLTMSFNCColorPicker,
  LCLTMSFNCEdit, LCLTMSFNCHTMLText, LCLTMSFNCColorSelector, memds, db, Dialogs, Controls, StdCtrls, LCLTMSFNCTypes;
  {$ENDIF}

  {$IFDEF WEBLIB}
  Web, Classes, DateUtils, Contnrs, SysUtils, WEBLib.TMSFNCCustomComponent, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCBitmapContainer,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCGraphicsTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCCustomControl,
  WEBLib.TMSFNCKanbanBoard, WEBLib.TMSFNCKanbanBoardDataBaseAdapter, WEBLib.Forms, DB, WEBLib.CDS, WEBLib.TMSFNCPanel,
  WEBLib.TMSFNCColorPicker, WEBLib.TMSFNCEdit, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCColorSelector, WEBLib.StdCtrls,
  WEBLib.Controls, WEBLib.Dialogs;
  {$ENDIF}

type
  {$IFDEF LCL}
  TKanbanBoardDataSet = TMemDataSet;
  {$ENDIF}
  {$IFNDEF LCL}
  TKanbanBoardDataSet = TClientDataSet;
  {$ENDIF}

  TKanbanBoardLogic = class
  private
    FBlockUpdate: Boolean;
    cl: TTMSFNCGraphicsColor;
    FForm: TCustomForm;
    FKanbanBoard: TTMSFNCKanbanBoard;
    FKanbanBoardDatabaseAdapter: TTMSFNCKanbanBoardDatabaseAdapter;
    FDataSet: TKanbanBoardDataset;
    FDataSource: TDatasource;
    FTitle: TTMSFNCEdit;
    FText: TMemo;
    FColor: TTMSFNCColorPicker;
  protected
    procedure PopulateDataset;
    procedure DoCustomizeColumn(Sender: TObject; {%H-}AColumn: TTMSFNCKanbanBoardColumn; ATableView: TTMSFNCKanbanBoardTableView);
    procedure DoFieldsToItem(Sender: TObject; AFields: TFields; AItem: TTMSFNCKanbanBoardItem);
    procedure DoHeaderCompactButtonClicked(Sender: TObject);
    procedure DoSelectItem(Sender: TObject; {%H-}AColumn: TTMSFNCKanbanBoardColumn; AItem: TTMSFNCKanbanBoardItem);
    procedure TextChanged(Sender: TObject);
    procedure TitleChanged(Sender: TObject);
    procedure ColorSelected(Sender: TObject; AColor: TTMSFNCGraphicsColor);
    {$IFDEF FMX}
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
    {$ENDIF}
    {$IFNDEF FMX}
    procedure FormKeyDown(Sender: TObject; var {%H-}Key: Word; {%H-}Shift: TShiftState);
    {$ENDIF}
    procedure FormShow(Sender: TObject);
  public
    destructor Destroy; override;
    procedure InitKanbanBoard(AForm: TCustomForm; ABitmapContainer: TTMSFNCBitmapContainer);
    procedure ReloadKanbanBoard;
  end;

implementation

uses
  Math;

type
  TCustomFormOpen = class(TCustomForm);

procedure TKanbanBoardLogic.ColorSelected(Sender: TObject;
  AColor: TTMSFNCGraphicsColor);
var
  it: TTMSFNCKanbanBoardItem;
begin
  if FBlockUpdate then
    Exit;

  it := FKanbanBoard.SelectedItem;
  if Assigned(it) then
    it.Color := AColor;
end;

destructor TKanbanBoardLogic.Destroy;
begin
  inherited;
end;

procedure TKanbanBoardLogic.DoCustomizeColumn(Sender: TObject;
  AColumn: TTMSFNCKanbanBoardColumn; ATableView: TTMSFNCKanbanBoardTableView);
begin
  if Assigned(ATableView) then
  begin
    ATableView.TreeView.GroupsAppearance.BottomStroke.Color := cl;
    ATableView.TreeView.GroupsAppearance.TopStroke.Color := cl;
  end;
end;

procedure TKanbanBoardLogic.DoFieldsToItem(Sender: TObject; AFields: TFields;
  AItem: TTMSFNCKanbanBoardItem);
begin
  AItem.Expandable := True;
  AItem.UseDefaultAppearance := False;
  AItem.Color := AFields.FieldByName('Color').AsInteger;
  AItem.MarkColor := gcOrange;
  if AItem.Color = gcIndianred then
  begin
    AItem.TitleColor := gcWhite;
    AItem.TextColor := gcWhite;
  end;

  case AFields.FieldByName('Priority').AsInteger of
    1: AItem.MarkType := [kbmtLeft];
    2: AItem.MarkType := [kbmtTop];
    3: AItem.MarkType := [kbmtRight];
    4: AItem.MarkType := [kbmtBottom];
    5: AItem.MarkType := [kbmtLeft, kbmtTop, kbmtRight, kbmtBottom];
  end;

  if Odd(Random(10)) then
    AItem.MarkColor := gcBlue
  else
    AItem.MarkColor := gcRed;
end;

{$IFDEF FMX}
procedure TKanbanBoardLogic.FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
{$ENDIF}
{$IFNDEF FMX}
procedure TKanbanBoardLogic.FormKeyDown(Sender: TObject; var {%H-}Key: Word; {%H-}Shift: TShiftState);
{$ENDIF}
var
  it: TTMSFNCKanbanBoardItem;
begin
  it := FKanbanBoard.SelectedItem;
  if Assigned(it) and Assigned(it.Column) and Assigned(it.Column.TableView) and Assigned(it.Column.TableView.TreeView){ and (it.Column.TableView.TreeView.Focused)} then
  begin
    case Key of
      KEY_DELETE:
      begin
        if (TTMSFNCUtils.Message('Do you want to delete the selected item?', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = mrYes) then
          it.Column.Items.Delete(it.Index);
      end;
      KEY_INSERT: FKanbanBoard.SelectedItem := it.Column.Items.Add;
    end;
  end;
end;

procedure TKanbanBoardLogic.FormShow(Sender: TObject);
begin
  ReloadKanbanBoard;
end;

procedure TKanbanBoardLogic.DoHeaderCompactButtonClicked(Sender: TObject);
var
  I: Integer;
  p: TTMSFNCPanel;
begin
  p := Sender as TTMSFNCPanel;
  {$IFDEF FMX}
  for I := 0 to p.ControlsCount - 1 do
  {$ENDIF}
  {$IFNDEF FMX}
  for I := 0 to p.ControlCount - 1 do
  {$ENDIF}
    p.Controls[I].Visible := (p.CompactState = pcsExpanded);
end;

procedure TKanbanBoardLogic.DoSelectItem(Sender: TObject;
  AColumn: TTMSFNCKanbanBoardColumn; AItem: TTMSFNCKanbanBoardItem);
begin
  if Assigned(AItem) then
  begin
    FBlockUpdate := True;
    FTitle.Text := AItem.Title;
    FText.Text := AItem.Text;
    FColor.SelectedColor := AItem.Color;
    FBlockUpdate := False;
  end;
end;

procedure TKanbanBoardLogic.InitKanbanBoard(AForm: TCustomForm; ABitmapContainer: TTMSFNCBitmapContainer);
var
  c: TTMSFNCKanbanBoardColumn;
  p: TTMSFNCPanel;
  l, lt: TTMSFNCHTMLText;
  h: TTMSFNCHTMLText;
begin
  FForm := AForm;

  p := TTMSFNCPanel.Create(FForm);
  p.Parent := FForm;
  p.ControlAlignment := caLeft;
  p.Width := p.ScalePaintValue(300);
  p.Header.Buttons := [pbCompact];
  p.Header.Text := 'Settings';

  h := TTMSFNCHTMLText.Create(p);
  h.Parent := p;
  h.AutoSize := True;
  h.Text := 'Supported interactions:<ul><li>Drag & Drop<li>Selection<li>Expand/Collapse<li>Sorting<li>Filtering<li>Delete / Insert key to delete / add items</ul>';
  h.ShowAcceleratorChar := False;
  h.HorizontalTextAlign := gtaLeading;
  h.Left := 5;
  h.Top := Round(p.Header.Size) + 5;
  h.Width := p.Width - 5;
  h.Height := h.ScalePaintValue(125);

  lt := TTMSFNCHTMLText.Create(p);
  lt.Parent := p;
  lt.AutoSize := True;
  lt.Text := 'Title:';
  lt.Left := 5;
  lt.Top := h.Top + h.Height + 10;

  FTitle := TTMSFNCEdit.Create(p);
  FTitle.Parent := p;
  {$IFDEF FMX}
  FTitle.Position.X := Max(lt.Left + lt.Width, 50) + 10;
  FTitle.Position.Y := lt.Top;
  FTitle.Width := p.Width - 10 - FTitle.Position.X;
  {$ENDIF}
  {$IFNDEF FMX}
  FTitle.Left := Max(lt.Left + lt.Width, 50) + 10;
  FTitle.Top := lt.Top;
  FTitle.Width := p.Width - 10 - FTitle.Left;
  {$ENDIF}

  l := TTMSFNCHTMLText.Create(p);
  l.Parent := p;
  l.AutoSize := True;
  l.Text := 'Text:';
  l.Left := 5;
  l.Top := lt.Top + lt.Height + 10;

  FText := TMemo.Create(p);
  FText.Parent := p;
  {$IFDEF FMX}
  FText.Position.X := Max(l.Left + l.Width, 50) + 10;
  FText.Position.Y := l.Top;
  FText.Width := p.Width - 10 - FText.Position.X;
  {$ENDIF}
  {$IFNDEF FMX}
  FText.Left := Max(l.Left + l.Width, 50) + 10;
  FText.Top := l.Top;
  FText.Width := p.Width - 10 - FText.Left;
  {$ENDIF}
  FText.Height := 150;
  FText.WordWrap := True;

  l := TTMSFNCHTMLText.Create(p);
  l.Parent := p;
  l.AutoSize := True;
  l.Text := 'Color:';
  l.Left := 5;
  {$IFDEF FMX}
  l.Top := FText.Position.Y + FText.Height + 10;
  {$ENDIF}
  {$IFNDEF FMX}
  l.Top := FText.Top + FText.Height + 10;
  {$ENDIF}

  FColor := TTMSFNCColorPicker.Create(p);
  FColor.Parent := p;
  FColor.Left := Max(l.Left + l.Width, 50) + 10;
  FColor.Top := l.Top;
  FColor.Width := p.Width - 10 - FColor.Left;
  FColor.Mode := csmExtended;

  FKanbanBoard := TTMSFNCKanbanBoard.Create(FForm);
  FKanbanBoard.BeginUpdate;

  cl := MakeGraphicsColor(240, 240, 240);

  FKanbanBoard.BitmapContainer := ABitmapContainer;
  FKanbanBoard.Parent := FForm;
  FKanbanBoard.ControlAlignment := caClient;
  FKanbanBoard.ColumnsAppearance.Margins.Left := FKanbanBoard.ScalePaintValue(50);
  FKanbanBoard.ColumnsAppearance.Margins.Top := FKanbanBoard.ScalePaintValue(50);
  FKanbanBoard.ColumnsAppearance.HeaderFill.Color := cl;
  FKanbanBoard.ColumnsAppearance.HeaderStroke.Color := cl;
  FKanbanBoard.ColumnsAppearance.FooterFill.Color := cl;
  FKanbanBoard.ColumnsAppearance.FooterStroke.Color := cl;
  FKanbanBoard.ColumnsAppearance.Fill.Color := cl;
  FKanbanBoard.ColumnsAppearance.Stroke.Color := cl;
  TTMSFNCUtils.SetFontSize(FKanbanBoard.ColumnsAppearance.HeaderFont, FKanbanBoard.ScalePaintValue(20));

  FKanbanBoard.ItemsAppearance.SelectedFill.Color := gcLightsteelblue;
  FKanbanBoard.ItemsAppearance.SelectedStroke.Color := cl;
  TTMSFNCUtils.SetFontSize(FKanbanBoard.ItemsAppearance.TitleFont, FKanbanBoard.ScalePaintValue(16));
  FKanbanBoard.ItemsAppearance.Fill.Color := gcWhite;
  FKanbanBoard.ItemsAppearance.Stroke.Color := cl;

  FKanbanBoard.Fill.Color := cl;
  FKanbanBoard.Stroke.Color := cl;

  FKanbanBoard.Interaction.DragDropMode := kbdmMove;

  FKanbanBoardDatabaseAdapter := TTMSFNCKanbanBoardDatabaseAdapter.Create(AForm);

  FKanbanBoardDatabaseAdapter.Parent := AForm;
  FKanbanBoardDatabaseAdapter.Visible := False;

  FDataSet := TKanbanBoardDataSet.Create(FForm);
  FDataSet.FieldDefs.Add('ID', ftInteger, 0, True);
  FDataSet.FieldDefs.Add('Title', ftString, 255, True);
  FDataSet.FieldDefs.Add('Description', ftString, 255, False);
  FDataSet.FieldDefs.Add('Priority', ftInteger, 0, False);
  FDataSet.FieldDefs.Add('Status', ftInteger, 0, False);
  FDataSet.FieldDefs.Add('Color', ftInteger, 0, False);
  {$IFNDEF WEBLIB}
  {$IFNDEF LCL}
  FDataSet.CreateDataSet;
  {$ENDIF}
  {$ENDIF}

  {$IFDEF WEBLIB}
  FDataSet.Open;
  {$ENDIF}

  {$IFDEF LCL}
  FDataSet.Open;
  {$ENDIF}

  FDataSource := TDataSource.Create(FForm);
  FDataSource.DataSet := FDataSet;

  PopulateDataset;

  FKanbanBoardDatabaseAdapter.KanbanBoard := FKanbanBoard;
  FKanbanBoardDatabaseAdapter.Item.DataSource := FDataSource;
  FKanbanBoardDatabaseAdapter.Item.Title := 'Title';
  FKanbanBoardDatabaseAdapter.Item.Text := 'Description';
  FKanbanBoardDatabaseAdapter.Item.DBKey := 'ID';
  FKanbanBoardDatabaseAdapter.Item.Column := 'Status';

  c := FKanbanBoard.Columns.Add;
  c.HeaderText := 'TO DO';
  c.Expandable := True;

  c := FKanbanBoard.Columns.Add;
  c.HeaderText := 'IN PROGRESS';
  c.Expandable := True;
  c.Sorting := kbsNormal;
  c.ShowFilterButton := True;
  c.Width := c.Width + FKanbanBoard.ScalePaintValue(50);

  c := FKanbanBoard.Columns.Add;
  c.HeaderText := 'DONE';

  {$IFDEF LCL}
  FKanbanBoard.OnSelectItem := @DoSelectItem;
  FKanbanBoard.OnCustomizeColumn := @DoCustomizeColumn;
  FKanbanBoardDatabaseAdapter.OnFieldsToItem := @DoFieldsToItem;
  FColor.OnColorSelected := @ColorSelected;
  p.OnHeaderCompactButtonClick := @DoHeaderCompactButtonClicked;
  FTitle.OnChange := @TitleChanged;
  FText.OnChange := @TextChanged;
  TCustomFormOpen(FForm).OnKeyDown := @FormKeyDown;
  TCustomFormOpen(FForm).OnShow := @FormShow;
  {$ENDIF}
  {$IFNDEF LCL}
  FKanbanBoard.OnSelectItem := DoSelectItem;
  FKanbanBoard.OnCustomizeColumn := DoCustomizeColumn;
  FKanbanBoardDatabaseAdapter.OnFieldsToItem := DoFieldsToItem;
  FColor.OnColorSelected := ColorSelected;
  p.OnHeaderCompactButtonClick := DoHeaderCompactButtonClicked;
  FTitle.OnChange := TitleChanged;
  FText.OnChange := TextChanged;
  TCustomFormOpen(FForm).OnKeyDown := FormKeyDown;
  TCustomFormOpen(FForm).OnShow := FormShow;
  {$IFNDEF FMX}
  {$IFNDEF WEBLIB}
  FForm.KeyPreview := True;
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}

  {$IFDEF WEBLIB}
  Application.OnImageCacheReady := FormShow;
  {$ENDIF}

  FKanbanBoardDatabaseAdapter.Active := True;
  FDataSet.Active := True;
  FKanbanBoard.EndUpdate;
end;

procedure TKanbanBoardLogic.PopulateDataset;
var
  idx: Integer;

  procedure AddRecord(var AIndex: Integer; ATitle, ADescription: String; APriority, AStatus, AColor: TTMSFNCGraphicsColor);
  begin
    FDataSet.Append;
    FDataSet.FieldByName('ID').AsInteger := idx;
    FDataSet.FieldByName('Title').AsString := ATitle;
    FDataSet.FieldByName('Description').AsString := ADescription;
    FDataSet.FieldByName('Priority').AsInteger := APriority;
    FDataSet.FieldByName('Status').AsInteger := AStatus;
    FDataSet.FieldByName('Color').AsInteger := AColor;
    FDataSet.Post;
    Inc(AIndex);
  end;

begin
  FDataSet.DisableControls;
  try
    idx := 0;

    AddRecord(idx, 'TMS FNC Kanban Release', '<font color="gcGray">Finish documentation</font><br/><br/><img src="button_duplicate.png"/>', 0, 0, gcWhite);
    AddRecord(idx, 'TMS FNC Kanban Release', '<img src="button_duplicate.png"/>', 0, 2, gcWhite);
    AddRecord(idx, 'ADD NEW', '<font color="gcWhite">New FNC Component</font>', 0, 1, MakeGraphicsColor(153, 204, 0));
    AddRecord(idx, 'FIX', 'Fix issue in FNC Core', 1, 0, gcWhite);
    AddRecord(idx, 'FNC', 'Interface Support<br/><img src="button_high-priority.png"/>', 3, 1, MakeGraphicsColor(0, 204, 255));
    AddRecord(idx, 'FNC', 'Convert Calendar and Date-Picker to FMX, VCL and WEB<br/><img src="button_high-priority.png"/>', 0, 1, gcWhite);
    AddRecord(idx, 'JQWidgets', 'Create a JQWidgets grid demo with CSS styling', 0, 0, MakeGraphicsColor(255, 102, 0));
    AddRecord(idx, 'Documentation', 'Finish documentation for TMS WEB Core<br/><img src="button_low-priority.png"/>', 4, 1, MakeGraphicsColor(255, 204, 0));
    AddRecord(idx, 'Landing page', 'Add new blog post to WEB landing page', 4, 0, gcWhite);
    AddRecord(idx, 'Landing page', 'Add new image to WEB landing page, image is attached below.<br/><br/><img src="flowers.png" width="200"/>', 0, 2, gcWhite);

    FDataSet.First;
  finally
    FDataSet.EnableControls;
  end;
end;

procedure TKanbanBoardLogic.ReloadKanbanBoard;
begin
  FKanbanBoard.BeginUpdate;
  FKanbanBoard.EndUpdate;
end;

procedure TKanbanBoardLogic.TextChanged(Sender: TObject);
var
  it: TTMSFNCKanbanBoardItem;
begin
  if FBlockUpdate then
    Exit;

  it := FKanbanBoard.SelectedItem;
  if Assigned(it) then
    it.Text := FText.Text;
end;

procedure TKanbanBoardLogic.TitleChanged(Sender: TObject);
var
  it: TTMSFNCKanbanBoardItem;
begin
  if FBlockUpdate then
    Exit;

  it := FKanbanBoard.SelectedItem;
  if Assigned(it) then
    it.Title := FTitle.Text;
end;

end.
