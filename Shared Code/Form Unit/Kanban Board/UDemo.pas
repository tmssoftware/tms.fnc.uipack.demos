unit UDemo;

{ TMS FNC UI Pack - Kanban Board

  The sprint board of a small product team. Five columns from the backlog to done, with a work-in-progress limit
  on the columns where work happens (the board refuses a card above the limit while the limit is on), swimlanes
  for expedite and planned work, a column count in every header and the story points in every footer. A card
  shows its tag, owner, points and due date in HTML with theme colours and its priority as a status kind; an
  overdue date turns red. Type in the filter box to filter every column, drag cards between columns and lanes,
  double-click or press F2 to rename a card, and edit the selected card in the details pane. Delete removes a
  card with an undo toast. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.DateUtils, System.Math,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCKanbanBoard, VCL.TMSFNCEdit, VCL.TMSFNCComboBox, VCL.TMSFNCSegmentedControl, VCL.TMSFNCNumberBox,
  VCL.TMSFNCDatePicker, VCL.TMSFNCProgressBar, VCL.TMSFNCToast, VCL.TMSFNCAvatar, VCL.TMSFNCTheme,
  VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, System.DateUtils, System.Math,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCKanbanBoard, FMX.TMSFNCEdit, FMX.TMSFNCComboBox, FMX.TMSFNCSegmentedControl, FMX.TMSFNCNumberBox,
  FMX.TMSFNCDatePicker, FMX.TMSFNCProgressBar, FMX.TMSFNCToast, FMX.TMSFNCAvatar, FMX.TMSFNCTheme,
  FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, DateUtils, Math, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton, WEBLib.TMSFNCKanbanBoard, WEBLib.TMSFNCEdit,
  WEBLib.TMSFNCComboBox, WEBLib.TMSFNCSegmentedControl, WEBLib.TMSFNCNumberBox, WEBLib.TMSFNCDatePicker,
  WEBLib.TMSFNCProgressBar, WEBLib.TMSFNCToast, WEBLib.TMSFNCAvatar, WEBLib.TMSFNCTheme,
  WEBLib.TMSFNCThemeSelector,
  {$ENDIF}
  UDemoLayout;

type
  TCard = record
    Title: string;
    Notes: string;
    Tag: string;
    Owner: Integer;
    Points: Integer;
    Due: Integer;
    Priority: Integer;
    Column: Integer;
    Lane: Integer;
  end;

  TForm1 = class(TDemoForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TTMSFNCPanel;
    DemoTitle: TTMSFNCHTMLText;
    DemoDescription: TTMSFNCHTMLText;
    DemoThemeSelector: TTMSFNCThemeSelector;
    procedure FormCreate(Sender: TObject);
  private
    FLayout: TDemoLayout;
    FCards: array of TCard;
    FToolBar: TTMSFNCPanel;
    FSprint: TTMSFNCHTMLText;
    FProgress: TTMSFNCProgressBar;
    FFilter: TTMSFNCEdit;
    FLanesCheck: TTMSFNCCheckBox;
    FLimitCheck: TTMSFNCCheckBox;
    FBoard: TTMSFNCKanbanBoard;
    FDetails: TTMSFNCPanel;
    FEmpty: TTMSFNCHTMLText;
    FTitleEdit: TTMSFNCEdit;
    FOwnerCombo: TTMSFNCComboBox;
    FPriority: TTMSFNCSegmentedControl;
    FPoints: TTMSFNCNumberBox;
    FDue: TTMSFNCDatePicker;
    FNotes: TTMSFNCHTMLText;
    FMoveButton: TTMSFNCButton;
    FDeleteButton: TTMSFNCButton;
    FDetailControls: array of TControl;
    FToast: TTMSFNCToast;
    FDeleted: TCard;
    FDeletedIndex: Integer;
    FUpdating: Boolean;
    procedure CreateCards;
    procedure CreateToolBar;
    procedure CreateDetails;
    procedure CreateBoard;
    procedure AddLanes;
    procedure FillBoard;
    function AddCardItem(AIndex: Integer): TTMSFNCKanbanBoardItem;
    procedure UpdateCardItem(AItem: TTMSFNCKanbanBoardItem);
    function CardOf(AItem: TTMSFNCKanbanBoardItem): Integer;
    function CardText(AIndex: Integer): string;
    procedure UpdateTotals;
    procedure ShowCard(AItem: TTMSFNCKanbanBoardItem);
    procedure ApplyFilter;
    procedure DeleteCard(AItem: TTMSFNCKanbanBoardItem);
    procedure BoardSelectItem(Sender: TObject; AColumn: TTMSFNCKanbanBoardColumn; AItem: TTMSFNCKanbanBoardItem);
    procedure BoardAfterDrop(Sender: TObject; AFromColumn, AToColumn: TTMSFNCKanbanBoardColumn;
      AFromItem, AToItem: TTMSFNCKanbanBoardItem);
    procedure BoardUpdateItemText(Sender: TObject; AColumn: TTMSFNCKanbanBoardColumn; AItem: TTMSFNCKanbanBoardItem;
      AText: string);
    {$IFDEF FMX}
    procedure BoardKeyDown(Sender: TObject; var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
    {$ELSE}
    procedure BoardKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    {$ENDIF}
    procedure FilterChanged(Sender: TObject);
    procedure LanesChanged(Sender: TObject);
    procedure LimitChanged(Sender: TObject);
    procedure NewCardClick(Sender: TObject);
    procedure TitleChanged(Sender: TObject);
    procedure OwnerSelected(Sender: TObject; AText: string; AItemIndex: Integer);
    procedure PriorityChanged(Sender: TObject);
    procedure PointsChanged(Sender: TObject);
    procedure DueSelected(Sender: TObject; ADate: TDate);
    procedure MoveClick(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure ToastAction(Sender: TObject; AItem: TTMSFNCToastItem);
  public
  end;

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

const
  ColumnNames: array[0..4] of string = ('Backlog', 'To do', 'In progress', 'Review', 'Done');
  ColumnLimits: array[0..4] of Integer = (0, 6, 3, 2, 0);
  LaneNames: array[0..1] of string = ('Expedite', 'Planned');
  Owners: array[0..4] of string = ('Ana Ruiz', 'Ben Okafor', 'Chen Wei', 'Dana Kim', 'Erik Lund');
  Priorities: array[0..3] of string = ('Low', 'Normal', 'High', 'Blocker');
  ColumnDone = 4;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FLayout := TDemoLayout.Create(Self);
  FDeletedIndex := -1;
  CreateCards;
  CreateToolBar;
  CreateDetails;
  CreateBoard;
  FillBoard;
  ShowCard(nil);
end;

procedure TForm1.CreateCards;

  procedure Add(const ATitle, ANotes, ATag: string; AOwner, APoints, ADue, APriority, AColumn, ALane: Integer);
  var
    c: TCard;
  begin
    c.Title := ATitle;
    c.Notes := ANotes;
    c.Tag := ATag;
    c.Owner := AOwner;
    c.Points := APoints;
    c.Due := ADue;
    c.Priority := APriority;
    c.Column := AColumn;
    c.Lane := ALane;
    SetLength(FCards, Length(FCards) + 1);
    FCards[High(FCards)] := c;
  end;

begin
  Add('Refunds fail for split payments', 'Customers who paid with two cards get the refund on the first card only.',
    'payments', 2, 5, -1, 3, 2, 0);
  Add('Card reader drops the connection', 'Seen on the counter terminals after the firmware update.', 'devices', 4,
    3, 1, 2, 1, 0);
  Add('Receipt e-mail in Dutch', 'Use the shop language of the order, fall back to English.', 'i18n', 0, 2, 6, 1, 0,
    1);
  Add('Monthly statement as PDF', 'One page per month, totals per payment method, the shop logo on top.', 'reports',
    1, 8, 12, 1, 0, 1);
  Add('Dark mode for the checkout page', 'Follow the system setting; keep the brand colour for the pay button.',
    'ui', 3, 3, 0, 0, 0, 1);
  Add('Rate limit the public API', '100 requests per minute per key, a clear error when it is reached.', 'api', 2, 5,
    9, 1, 1, 1);
  Add('Export orders to CSV', 'The columns of the order list, in the order the user sorted them.', 'reports', 1, 2,
    4, 0, 1, 1);
  Add('Saved cards for returning customers', 'Tokenised by the provider; nothing stored on our side.', 'payments', 0,
    8, 15, 2, 1, 1);
  Add('Search orders by customer e-mail', 'Partial matches, case-insensitive.', 'api', 4, 3, 3, 1, 2, 1);
  Add('Accessible labels in the checkout', 'Every field and button has a name for screen readers.', 'ui', 3, 2, 2, 2,
    2, 1);
  Add('Tip amount on the terminal', 'Three presets and a custom amount.', 'devices', 4, 5, -3, 2, 3, 0);
  Add('Webhooks retry with back-off', '1, 5, 30 minutes, then a failure mail to the shop.', 'api', 2, 3, 2, 1, 3, 1);
  Add('Currency on the invoice line', 'Show the currency code next to every amount.', 'reports', 1, 1, -6, 0, 4, 1);
  Add('Upgrade the payment SDK', 'Version 12, with the new 3-D Secure flow.', 'payments', 0, 5, -2, 2, 4, 1);
  Add('Login with a passkey', 'For the shop back office, next to the password.', 'security', 3, 8, -8, 1, 4, 1);
  Add('Sign-out on every device', 'One button in the profile page.', 'security', 3, 2, 20, 0, 0, 1);
end;

procedure TForm1.CreateToolBar;
var
  b: TTMSFNCButton;
begin
  FToolBar := FLayout.AddPanel(Self, daTop, 56, 16, 0, 16, 8);

  FSprint := TTMSFNCHTMLText.Create(Self);
  FSprint.Parent := FToolBar;
  FLayout.Place(FSprint, daLeft, 260, 12, 6, 8, 6);
  FSprint.HorizontalTextAlign := gtaLeading;
  FSprint.VerticalTextAlign := gtaCenter;
  FSprint.Fill.Kind := gfkNone;
  FSprint.Stroke.Kind := gskNone;

  FProgress := TTMSFNCProgressBar.Create(Self);
  FProgress.Parent := FToolBar;
  FLayout.Place(FProgress, daLeft, 160, 0, 22, 16, 22);

  { right to left: the last control placed on the right is the rightmost }
  FFilter := TTMSFNCEdit.Create(Self);
  FFilter.Parent := FToolBar;
  FLayout.Place(FFilter, daRight, 220, 8, 12, 16, 12);
  {$IFDEF FMX}
  FFilter.TextPrompt := 'Filter cards';
  FFilter.ClearButton := True;
  {$ELSE}
  FFilter.TextHint := 'Filter cards';
  {$IFNDEF WEBLIB}
  FFilter.ClearButton := True;
  {$ENDIF}
  {$ENDIF}
  FLanesCheck := FLayout.AddCheck(FToolBar, 'Swimlanes', True, {$IFDEF WEBLIB}@{$ENDIF}LanesChanged);
  FLayout.Place(FLanesCheck, daRight, 110, 8, 12, 8, 12);
  FLimitCheck := FLayout.AddCheck(FToolBar, 'Limit work in progress', True, {$IFDEF WEBLIB}@{$ENDIF}LimitChanged);
  FLayout.Place(FLimitCheck, daRight, 190, 8, 12, 8, 12);
  b := FLayout.AddButton(FToolBar, 'New card', {$IFDEF WEBLIB}@{$ENDIF}NewCardClick);
  FLayout.Place(b, daRight, 110, 8, 12, 12, 12);
  b.Default := True;

  FFilter.OnChange := {$IFDEF WEBLIB}@{$ENDIF}FilterChanged;
end;

procedure TForm1.CreateDetails;
var
  I: Integer;
  row: TTMSFNCPanel;

  procedure Remember(AControl: TControl);
  begin
    SetLength(FDetailControls, Length(FDetailControls) + 1);
    FDetailControls[High(FDetailControls)] := AControl;
  end;

  procedure Field(AControl: TControl; AHeight: Integer);
  begin
    AControl.Parent := FDetails;
    FLayout.Place(AControl, daTop, AHeight, 16, 0, 16, 0);
    Remember(AControl);
  end;

begin
  FDetails := FLayout.AddPanel(Self, daRight, 300, 0, 0, 16, 16);
  FLayout.AddCaption(FDetails, 'Card');
  FEmpty := FLayout.AddText(FDetails, 'Select a card to see and change its details here.', 40);

  Remember(FLayout.AddCaption(FDetails, 'Title', 8));
  FTitleEdit := TTMSFNCEdit.Create(Self);
  Field(FTitleEdit, 32);
  FTitleEdit.OnChange := {$IFDEF WEBLIB}@{$ENDIF}TitleChanged;

  Remember(FLayout.AddCaption(FDetails, 'Owner', 12));
  FOwnerCombo := TTMSFNCComboBox.Create(Self);
  Field(FOwnerCombo, 32);
  FOwnerCombo.Style := csDropDownList;
  for I := Low(Owners) to High(Owners) do
    FOwnerCombo.Items.Add(Owners[I]);
  FOwnerCombo.OnItemSelected := {$IFDEF WEBLIB}@{$ENDIF}OwnerSelected;

  Remember(FLayout.AddCaption(FDetails, 'Priority', 12));
  FPriority := TTMSFNCSegmentedControl.Create(Self);
  Field(FPriority, 32);
  for I := Low(Priorities) to High(Priorities) do
    FPriority.Items.AddItem(Priorities[I]);
  FPriority.OnChange := {$IFDEF WEBLIB}@{$ENDIF}PriorityChanged;

  Remember(FLayout.AddCaption(FDetails, 'Story points and due date', 12));
  row := FLayout.AddPanel(FDetails, daTop, 32, 16, 0, 16, 0);
  row.Fill.Kind := gfkNone;
  row.Stroke.Kind := gskNone;
  Remember(row);
  FPoints := TTMSFNCNumberBox.Create(Self);
  FPoints.Parent := row;
  FLayout.Place(FPoints, daLeft, 80, 0, 0, 8, 0);
  FPoints.Decimals := 0;
  FPoints.MinValue := 0;
  FPoints.MaxValue := 21;
  FPoints.OnChange := {$IFDEF WEBLIB}@{$ENDIF}PointsChanged;
  FDue := TTMSFNCDatePicker.Create(Self);
  FDue.Parent := row;
  FLayout.Place(FDue, daClient, 0, 0, 0, 0, 0);
  FDue.OnDateSelected := {$IFDEF WEBLIB}@{$ENDIF}DueSelected;

  Remember(FLayout.AddCaption(FDetails, 'Notes', 12));
  FNotes := FLayout.AddText(FDetails, '', 40);
  Remember(FNotes);

  row := FLayout.AddPanel(FDetails, daTop, 32, 16, 16, 16, 0);
  row.Fill.Kind := gfkNone;
  row.Stroke.Kind := gskNone;
  Remember(row);
  FMoveButton := FLayout.AddButton(row, 'Move to next column', {$IFDEF WEBLIB}@{$ENDIF}MoveClick);
  FLayout.Place(FMoveButton, daClient, 0, 0, 0, 8, 0);
  FDeleteButton := FLayout.AddButton(row, 'Delete', {$IFDEF WEBLIB}@{$ENDIF}DeleteClick);
  FLayout.Place(FDeleteButton, daRight, 80, 0, 0, 0, 0);

  FToast := TTMSFNCToast.Create(Self);
  FToast.Position := tpsBottomRight;
  FToast.OnActionClick := {$IFDEF WEBLIB}@{$ENDIF}ToastAction;
end;

procedure TForm1.CreateBoard;
var
  I: Integer;
  c: TTMSFNCKanbanBoardColumn;
begin
  FBoard := TTMSFNCKanbanBoard.Create(Self);
  FBoard.Parent := Self;
  FLayout.Place(FBoard, daClient, 0, 16, 0, 16, 16);
  FToast.Host := FBoard;

  FBoard.BeginUpdate;
  try
    FBoard.Interaction.DragDropMode := kbdmMove;
    FBoard.Interaction.EnforceWIPLimit := True;
    FBoard.Interaction.MouseEditMode := kbemDoubleClick;
    FBoard.Columns.Clear;
    for I := Low(ColumnNames) to High(ColumnNames) do
    begin
      c := FBoard.Columns.Add;
      c.HeaderText := ColumnNames[I];
      c.WIPLimit := ColumnLimits[I];
      c.FooterVisible := True;
      c.Width := 230;
      c.Expandable := I = ColumnDone;
    end;
    AddLanes;
  finally
    FBoard.EndUpdate;
  end;

  FBoard.OnSelectItem := {$IFDEF WEBLIB}@{$ENDIF}BoardSelectItem;
  FBoard.OnAfterDropItem := {$IFDEF WEBLIB}@{$ENDIF}BoardAfterDrop;
  FBoard.OnUpdateItemText := {$IFDEF WEBLIB}@{$ENDIF}BoardUpdateItemText;
  FBoard.OnKeyDown := {$IFDEF WEBLIB}@{$ENDIF}BoardKeyDown;
end;

procedure TForm1.AddLanes;
var
  I: Integer;
begin
  for I := Low(LaneNames) to High(LaneNames) do
    FBoard.Lanes.Add.Text := LaneNames[I];
end;

procedure TForm1.FillBoard;
var
  I: Integer;
begin
  FBoard.BeginUpdate;
  try
    for I := 0 to FBoard.Columns.Count - 1 do
      FBoard.Columns[I].Items.Clear;
    for I := 0 to High(FCards) do
      if FCards[I].Column >= 0 then
        AddCardItem(I);
  finally
    FBoard.EndUpdate;
  end;
  ApplyFilter;
  UpdateTotals;
end;

{ the card's index is kept in Tag, which a drop carries over to the new item }
function TForm1.AddCardItem(AIndex: Integer): TTMSFNCKanbanBoardItem;
begin
  Result := FBoard.Columns[FCards[AIndex].Column].Items.Add;
  Result.Tag := AIndex + 1;
  UpdateCardItem(Result);
end;

function TForm1.CardOf(AItem: TTMSFNCKanbanBoardItem): Integer;
begin
  if Assigned(AItem) then
    Result := AItem.Tag - 1
  else
    Result := -1;
end;

function TForm1.CardText(AIndex: Integer): string;
var
  c: TCard;
  due: TDateTime;
  s: string;
begin
  c := FCards[AIndex];
  Result := '<font color="var(--accent)">#' + c.Tag + '</font>&nbsp;&nbsp;<font color="var(--text-secondary)">' +
    TTMSFNCAvatar.InitialsOf(Owners[c.Owner]) + ' &middot; ' + IntToStr(c.Points) + '&nbsp;pts</font>';
  if c.Due <> 0 then
  begin
    due := IncDay(Date, c.Due);
    s := StringReplace(FormatDateTime('mmm d', due), ' ', '&nbsp;', []);
    if (c.Due < 0) and (c.Column <> ColumnDone) then
      Result := Result + '&nbsp;&nbsp;<font color="var(--error)">overdue&nbsp;' + s + '</font>'
    else
      Result := Result + '&nbsp;&nbsp;<font color="var(--text-secondary)">due&nbsp;' + s + '</font>';
  end;
end;

procedure TForm1.UpdateCardItem(AItem: TTMSFNCKanbanBoardItem);
const
  Kinds: array[0..3] of TTMSFNCStatusKind = (tskNeutral, tskNone, tskWarning, tskError);
var
  I: Integer;
begin
  I := CardOf(AItem);
  if I < 0 then
    Exit;
  AItem.Title := FCards[I].Title;
  AItem.Text := CardText(I);
  AItem.Kind := Kinds[FCards[I].Priority];
  if FLanesCheck.Checked then
    AItem.Lane := FCards[I].Lane
  else
    AItem.Lane := -1;
end;

procedure TForm1.UpdateTotals;
var
  I, J, k, pts, done, total: Integer;
  col: TTMSFNCKanbanBoardColumn;
begin
  done := 0;
  total := 0;
  for I := 0 to FBoard.Columns.Count - 1 do
  begin
    col := FBoard.Columns[I];
    pts := 0;
    for J := 0 to col.Items.Count - 1 do
    begin
      k := CardOf(col.Items[J]);
      if k >= 0 then
      begin
        FCards[k].Column := I;
        Inc(pts, FCards[k].Points);
      end;
    end;
    col.FooterText := IntToStr(pts) + ' points';
    { a column with a limit shows count/limit by itself }
    if col.WIPLimit > 0 then
      col.HeaderText := ColumnNames[I]
    else
      col.HeaderText := ColumnNames[I] + '  ' + IntToStr(col.Items.Count);
    Inc(total, pts);
    if I = ColumnDone then
      done := pts;
  end;
  FSprint.Text := '<b>Sprint 14 &middot; Harbor payments</b><br><font color="var(--text-secondary)">' +
    IntToStr(done) + ' of ' + IntToStr(total) + ' points done</font>';
  FProgress.Maximum := Max(1, total);
  FProgress.Value := done;
end;

procedure TForm1.ApplyFilter;
var
  I, J, k: Integer;
  f: string;
  it: TTMSFNCKanbanBoardItem;
begin
  f := LowerCase(Trim(FFilter.Text));
  FBoard.BeginUpdate;
  try
    for I := 0 to FBoard.Columns.Count - 1 do
      for J := 0 to FBoard.Columns[I].Items.Count - 1 do
      begin
        it := FBoard.Columns[I].Items[J];
        k := CardOf(it);
        it.Visible := (f = '') or ((k >= 0) and ((Pos(f, LowerCase(FCards[k].Title)) > 0) or
          (Pos(f, LowerCase(FCards[k].Tag)) > 0) or (Pos(f, LowerCase(Owners[FCards[k].Owner])) > 0)));
      end;
  finally
    FBoard.EndUpdate;
  end;
end;

procedure TForm1.ShowCard(AItem: TTMSFNCKanbanBoardItem);
var
  I, k: Integer;
begin
  k := CardOf(AItem);
  FEmpty.Visible := k < 0;
  for I := 0 to High(FDetailControls) do
    FDetailControls[I].Visible := k >= 0;
  if k < 0 then
    Exit;

  FUpdating := True;
  try
    FTitleEdit.Text := FCards[k].Title;
    FOwnerCombo.ItemIndex := FCards[k].Owner;
    FPriority.ItemIndex := FCards[k].Priority;
    FPoints.Value := FCards[k].Points;
    if FCards[k].Due <> 0 then
      FDue.SelectedDate := IncDay(Date, FCards[k].Due)
    else
      FDue.SelectedDate := Date;
    FNotes.Text := FCards[k].Notes;
    FMoveButton.Enabled := FCards[k].Column < ColumnDone;
  finally
    FUpdating := False;
  end;
end;

procedure TForm1.DeleteCard(AItem: TTMSFNCKanbanBoardItem);
var
  k: Integer;
begin
  k := CardOf(AItem);
  if k < 0 then
    Exit;
  FDeleted := FCards[k];
  FDeletedIndex := k;
  FCards[k].Column := -1;
  AItem.Column.Items.Delete(AItem.Index);
  ShowCard(nil);
  UpdateTotals;
  FToast.ShowAction('Card deleted', '"' + FDeleted.Title + '" was removed from the board.', 'Undo', toastInfo);
end;

procedure TForm1.BoardSelectItem(Sender: TObject; AColumn: TTMSFNCKanbanBoardColumn; AItem: TTMSFNCKanbanBoardItem);
begin
  ShowCard(AItem);
end;

procedure TForm1.BoardAfterDrop(Sender: TObject; AFromColumn, AToColumn: TTMSFNCKanbanBoardColumn;
  AFromItem, AToItem: TTMSFNCKanbanBoardItem);
var
  k: Integer;
begin
  UpdateTotals;
  k := CardOf(AToItem);
  if k >= 0 then
  begin
    if FLanesCheck.Checked then
      FCards[k].Lane := Max(0, AToItem.Lane);
    { the date colour depends on the column: a done card is never overdue }
    AToItem.Text := CardText(k);
  end;
  ShowCard(AToItem);
end;

procedure TForm1.BoardUpdateItemText(Sender: TObject; AColumn: TTMSFNCKanbanBoardColumn;
  AItem: TTMSFNCKanbanBoardItem; AText: string);
var
  k: Integer;
begin
  k := CardOf(AItem);
  if k < 0 then
    Exit;
  FCards[k].Title := AItem.Title;
  ShowCard(AItem);
end;

{$IFDEF FMX}
procedure TForm1.BoardKeyDown(Sender: TObject; var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
{$ELSE}
procedure TForm1.BoardKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
{$ENDIF}
begin
  if Key = KEY_DELETE then
  begin
    DeleteCard(FBoard.SelectedItem);
    Key := 0;
  end
  else if Key = KEY_INSERT then
  begin
    NewCardClick(Self);
    Key := 0;
  end;
end;

procedure TForm1.FilterChanged(Sender: TObject);
begin
  ApplyFilter;
end;

procedure TForm1.LanesChanged(Sender: TObject);
var
  I, J: Integer;
begin
  FBoard.BeginUpdate;
  try
    for I := 0 to FBoard.Columns.Count - 1 do
      for J := 0 to FBoard.Columns[I].Items.Count - 1 do
        UpdateCardItem(FBoard.Columns[I].Items[J]);
    FBoard.Lanes.Clear;
    if FLanesCheck.Checked then
      AddLanes;
  finally
    FBoard.EndUpdate;
  end;
end;

procedure TForm1.LimitChanged(Sender: TObject);
var
  I: Integer;
begin
  FBoard.Interaction.EnforceWIPLimit := FLimitCheck.Checked;
  for I := 0 to FBoard.Columns.Count - 1 do
    if FLimitCheck.Checked then
      FBoard.Columns[I].WIPLimit := ColumnLimits[I]
    else
      FBoard.Columns[I].WIPLimit := 0;
  UpdateTotals;
end;

procedure TForm1.NewCardClick(Sender: TObject);
var
  c: TCard;
  it: TTMSFNCKanbanBoardItem;
begin
  c.Title := 'New card';
  c.Notes := 'Describe the work, then drag the card to To do.';
  c.Tag := 'triage';
  c.Owner := 0;
  c.Points := 1;
  c.Due := 0;
  c.Priority := 1;
  c.Column := 0;
  c.Lane := 1;
  SetLength(FCards, Length(FCards) + 1);
  FCards[High(FCards)] := c;
  it := AddCardItem(High(FCards));
  FFilter.Text := '';
  ApplyFilter;
  UpdateTotals;
  FBoard.SelectedItem := it;
  ShowCard(it);
  FTitleEdit.SetFocus;
end;

procedure TForm1.TitleChanged(Sender: TObject);
var
  k: Integer;
begin
  k := CardOf(FBoard.SelectedItem);
  if FUpdating or (k < 0) or (Trim(FTitleEdit.Text) = '') then
    Exit;
  FCards[k].Title := FTitleEdit.Text;
  FBoard.SelectedItem.Title := FCards[k].Title;
end;

procedure TForm1.OwnerSelected(Sender: TObject; AText: string; AItemIndex: Integer);
var
  k: Integer;
begin
  k := CardOf(FBoard.SelectedItem);
  if FUpdating or (k < 0) or (AItemIndex < 0) then
    Exit;
  FCards[k].Owner := AItemIndex;
  UpdateCardItem(FBoard.SelectedItem);
end;

procedure TForm1.PriorityChanged(Sender: TObject);
var
  k: Integer;
begin
  k := CardOf(FBoard.SelectedItem);
  if FUpdating or (k < 0) or (FPriority.ItemIndex < 0) then
    Exit;
  FCards[k].Priority := FPriority.ItemIndex;
  UpdateCardItem(FBoard.SelectedItem);
end;

procedure TForm1.PointsChanged(Sender: TObject);
var
  k: Integer;
begin
  k := CardOf(FBoard.SelectedItem);
  if FUpdating or (k < 0) then
    Exit;
  FCards[k].Points := Round(FPoints.Value);
  UpdateCardItem(FBoard.SelectedItem);
  UpdateTotals;
end;

procedure TForm1.DueSelected(Sender: TObject; ADate: TDate);
var
  k: Integer;
begin
  k := CardOf(FBoard.SelectedItem);
  if FUpdating or (k < 0) then
    Exit;
  FCards[k].Due := DaysBetween(Date, ADate);
  if ADate < Date then
    FCards[k].Due := -FCards[k].Due;
  UpdateCardItem(FBoard.SelectedItem);
end;

procedure TForm1.MoveClick(Sender: TObject);
var
  it, nw: TTMSFNCKanbanBoardItem;
  col: Integer;
begin
  it := FBoard.SelectedItem;
  if not Assigned(it) or (it.Column.Index >= ColumnDone) then
    Exit;
  col := it.Column.Index + 1;
  if FLimitCheck.Checked and (ColumnLimits[col] > 0) and (FBoard.Columns[col].Items.Count >= ColumnLimits[col]) then
  begin
    FToast.ShowWarning('Column is full', ColumnNames[col] + ' holds at most ' + IntToStr(ColumnLimits[col]) +
      ' cards. Finish one first.');
    Exit;
  end;
  nw := FBoard.Columns[col].Items.Add;
  nw.Assign(it);
  it.Column.Items.Delete(it.Index);
  UpdateTotals;
  nw.Text := CardText(CardOf(nw));
  FBoard.SelectedItem := nw;
  ShowCard(nw);
end;

procedure TForm1.DeleteClick(Sender: TObject);
begin
  DeleteCard(FBoard.SelectedItem);
end;

procedure TForm1.ToastAction(Sender: TObject; AItem: TTMSFNCToastItem);
var
  it: TTMSFNCKanbanBoardItem;
begin
  if FDeletedIndex < 0 then
    Exit;
  FCards[FDeletedIndex] := FDeleted;
  it := AddCardItem(FDeletedIndex);
  FDeletedIndex := -1;
  ApplyFilter;
  UpdateTotals;
  FBoard.SelectedItem := it;
  ShowCard(it);
end;

end.
