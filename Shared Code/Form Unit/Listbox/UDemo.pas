unit UDemo;

{ TMS FNC UI Pack - Listbox

  A small mail client made of list boxes. The folder list shows tinted theme icons, a Fluent pill selection and an
  unread count as a badge per folder (accent for the inbox, warning for spam). The message list shows sender,
  subject and snippet as HTML in rows of variable height with a badge for the first label; type a letter to jump
  to a sender (lookup), filter with the search box, sort with the segmented control and drag a message onto a
  folder to move it. The reading pane shows the selected message, and its labels are a checked list box: checking
  a label tags the message. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Math,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCCustomTreeView, VCL.TMSFNCListBox, VCL.TMSFNCCheckedListBox, VCL.TMSFNCEdit,
  VCL.TMSFNCSegmentedControl, VCL.TMSFNCThemeIcons, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, System.Math,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCCustomTreeView, FMX.TMSFNCListBox, FMX.TMSFNCCheckedListBox, FMX.TMSFNCEdit,
  FMX.TMSFNCSegmentedControl, FMX.TMSFNCThemeIcons, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, Math, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton, WEBLib.TMSFNCCustomTreeView, WEBLib.TMSFNCListBox,
  WEBLib.TMSFNCCheckedListBox, WEBLib.TMSFNCEdit, WEBLib.TMSFNCSegmentedControl, WEBLib.TMSFNCThemeIcons,
  WEBLib.TMSFNCTheme, WEBLib.TMSFNCThemeSelector,
  {$ENDIF}
  UDemoLayout;

type
  TMessage = record
    Folder: Integer;
    Sender: string;
    Subject: string;
    Body: string;
    Time: string;
    Order: Integer;
    Unread: Boolean;
    Labels: Integer;
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
    FMessages: array of TMessage;
    FFolders: TTMSFNCListBox;
    FList: TTMSFNCListBox;
    FSearch: TTMSFNCEdit;
    FSort: TTMSFNCSegmentedControl;
    FReader: TTMSFNCPanel;
    FReadSubject: TTMSFNCHTMLText;
    FReadBody: TTMSFNCHTMLText;
    FLabels: TTMSFNCCheckedListBox;
    FUpdating: Boolean;
    procedure CreateMessages;
    procedure CreateFolders;
    procedure CreateMessageList;
    procedure CreateReader;
    procedure FillFolders;
    procedure FillMessages;
    procedure ShowMessageAt(AIndex: Integer);
    function CurrentFolder: Integer;
    function MessageOf(AItem: TTMSFNCListBoxItem): Integer;
    function UnreadCount(AFolder: Integer): Integer;
    procedure FolderSelected(Sender: TObject; AItem: TTMSFNCListBoxItem);
    procedure MessageSelected(Sender: TObject; AItem: TTMSFNCListBoxItem);
    procedure FolderBeforeDrop(Sender: TObject; AFromItem, AToItem: TTMSFNCListBoxItem; var ACanDrop: Boolean);
    procedure ListBeforeDrop(Sender: TObject; AFromItem, AToItem: TTMSFNCListBoxItem; var ACanDrop: Boolean);
    procedure LabelCheckChanged(Sender: TObject; AItem: TTMSFNCCheckedListBoxItem);
    procedure SearchChanged(Sender: TObject);
    procedure SortChanged(Sender: TObject);
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
  FolderNames: array[0..5] of string = ('Inbox', 'Flagged', 'Drafts', 'Sent', 'Archive', 'Spam');
  FolderIcons: array[0..5] of string = ('Document', 'StarFilled', 'Edit', 'Send', 'Folder', 'Warning');
  LabelNames: array[0..3] of string = ('Work', 'Travel', 'Invoices', 'Family');
  FolderSpam = 5;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FLayout := TDemoLayout.Create(Self);
  CreateMessages;
  CreateFolders;
  CreateReader;
  CreateMessageList;
  FillFolders;
  FFolders.ItemIndex := 0;
  FillMessages;
end;

procedure TForm1.CreateMessages;

  procedure Add(AFolder: Integer; const ASender, ASubject, ABody, ATime: string; AUnread: Boolean; ALabels: Integer);
  var
    m: TMessage;
  begin
    m.Folder := AFolder;
    m.Sender := ASender;
    m.Subject := ASubject;
    m.Body := ABody;
    m.Time := ATime;
    m.Order := Length(FMessages);
    m.Unread := AUnread;
    m.Labels := ALabels;
    SetLength(FMessages, Length(FMessages) + 1);
    FMessages[High(FMessages)] := m;
  end;

begin
  Add(0, 'Ana Ruiz', 'Release notes for 8.0', 'The draft is in the shared folder. Can you check the list of new ' +
    'controls before Friday?', '09:42', True, 1);
  Add(0, 'Harbor Air', 'Your flight to Lisbon', 'Booking HX-2291 is confirmed: Thursday 14:05, seat 12C. Check-in ' +
    'opens 24 hours before departure.', '08:15', True, 2);
  Add(0, 'Ben Okafor', 'Lunch on Thursday?', 'The new place next to the station has a terrace. 12:30?', '07:58',
    False, 0);
  Add(0, 'Northwind Power', 'Invoice October', 'Your invoice of 84.20 EUR is ready. It is paid by direct debit ' +
    'on the 28th.', 'Yesterday', True, 4);
  Add(0, 'Chen Wei', 'Theme colours for the dashboard', 'I tried the dark theme with the accent of the brand; ' +
    'screenshots attached.', 'Yesterday', False, 1);
  Add(0, 'Mum', 'Sunday', 'Dinner at six, bring the photos of the trip!', 'Mon', False, 8);
  Add(0, 'Dana Kim', 'Review: master-detail', 'Two small things in the detail toolbar, otherwise good to merge.',
    'Mon', True, 1);
  Add(0, 'City Library', 'Books due next week', 'Three books are due on the 18th. Renew them online.', 'Sun',
    False, 0);
  Add(1, 'Erik Lund', 'Contract renewal', 'Please sign before the end of the month.', 'Fri', False, 1 + 4);
  Add(1, 'Harbor Air', 'Boarding pass', 'Your boarding pass for HX-2291 is attached.', 'Thu', False, 2);
  Add(2, 'Me', 'Holiday request', 'I would like to take the week of the 22nd off.', 'Wed', False, 1);
  Add(3, 'Me', 'Re: Theme colours', 'Looks good, keep the contrast of the badges.', 'Tue', False, 1);
  Add(3, 'Me', 'Photos', 'Here are the photos of the trip.', 'Mon', False, 8);
  Add(4, 'Northwind Power', 'Invoice September', 'Your invoice of 79.10 EUR is ready.', 'Sep 28', False, 4);
  Add(4, 'Ana Ruiz', 'Kick-off 8.0', 'Agenda for the kick-off meeting.', 'Sep 2', False, 1);
  Add(FolderSpam, 'Prize Desk', 'You have won!', 'Click here to claim your prize.', 'Tue', True, 0);
  Add(FolderSpam, 'Account Team', 'Verify your password', 'Your mailbox is almost full.', 'Mon', True, 0);
end;

procedure TForm1.CreateFolders;
begin
  FFolders := TTMSFNCListBox.Create(Self);
  FFolders.Parent := Self;
  FLayout.Place(FFolders, daLeft, 200, 16, 0, 0, 16);
  FFolders.Header.Text := 'Mail';
  FFolders.Header.HorizontalTextAlign := gtaLeading;
  FFolders.ItemsAppearance.Look := tnlFluent;
  FFolders.ItemsAppearance.TintBitmaps := True;
  FFolders.Interaction.DragDropMode := ldmMove;
  FFolders.OnItemSelected := {$IFDEF WEBLIB}@{$ENDIF}FolderSelected;
  FFolders.OnBeforeDropItem := {$IFDEF WEBLIB}@{$ENDIF}FolderBeforeDrop;
end;

procedure TForm1.CreateMessageList;
var
  bar: TTMSFNCPanel;
begin
  bar := FLayout.AddPanel(Self, daTop, 40, 16, 0, 16, 8);
  bar.Fill.Kind := gfkNone;
  bar.Stroke.Kind := gskNone;
  FSearch := TTMSFNCEdit.Create(Self);
  FSearch.Parent := bar;
  FLayout.Place(FSearch, daClient, 0, 0, 4, 12, 4);
  {$IFDEF FMX}
  FSearch.TextPrompt := 'Search sender, subject or text';
  {$ELSE}
  FSearch.TextHint := 'Search sender, subject or text';
  {$ENDIF}
  FSearch.OnChange := {$IFDEF WEBLIB}@{$ENDIF}SearchChanged;
  FSort := TTMSFNCSegmentedControl.Create(Self);
  FSort.Parent := bar;
  FLayout.Place(FSort, daRight, 240, 0, 4, 0, 4);
  FSort.Items.AddItem('Newest');
  FSort.Items.AddItem('Sender');
  FSort.Items.AddItem('Subject');
  FSort.ItemIndex := 0;
  FSort.OnChange := {$IFDEF WEBLIB}@{$ENDIF}SortChanged;

  FList := TTMSFNCListBox.Create(Self);
  FList.Parent := Self;
  FLayout.Place(FList, daClient, 0, 16, 0, 16, 16);
  FList.Header.HorizontalTextAlign := gtaLeading;
  FList.ItemsAppearance.Look := tnlFluent;
  FList.ItemsAppearance.HeightMode := lihmVariable;
  FList.Interaction.Lookup.Enabled := True;
  FList.Interaction.DragDropMode := ldmMove;
  FList.OnItemSelected := {$IFDEF WEBLIB}@{$ENDIF}MessageSelected;
  FList.OnBeforeDropItem := {$IFDEF WEBLIB}@{$ENDIF}ListBeforeDrop;
end;

procedure TForm1.CreateReader;
var
  I: Integer;
begin
  FReader := FLayout.AddPanel(Self, daRight, 340, 0, 0, 16, 16);
  FReadSubject := FLayout.AddCaption(FReader, '', 16);
  FReadSubject.Height := FLayout.Size(48);
  FReadSubject.WordWrapping := True;
  {$IFDEF FMX}
  FReadSubject.Font.Size := 16;
  {$ELSE}
  FReadSubject.Font.Height := -FLayout.Size(16);
  {$ENDIF}
  FReadBody := FLayout.AddText(FReader, '', 120);
  FLayout.AddCaption(FReader, 'Labels', 16);
  FLabels := TTMSFNCCheckedListBox.Create(Self);
  FLabels.Parent := FReader;
  FLayout.Place(FLabels, daTop, 4 * 34 + 2, 16, 0, 16, 0);
  FLabels.Header.Visible := False;
  for I := Low(LabelNames) to High(LabelNames) do
    FLabels.Items.Add.Text := LabelNames[I];
  FLabels.OnItemCheckChanged := {$IFDEF WEBLIB}@{$ENDIF}LabelCheckChanged;
  FLayout.AddText(FReader, 'Check a label to tag the message: the first label shows as a badge in the list.', 40);
end;

function TForm1.UnreadCount(AFolder: Integer): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to High(FMessages) do
    if (FMessages[I].Folder = AFolder) and FMessages[I].Unread then
      Inc(Result);
end;

procedure TForm1.FillFolders;
var
  I, n, sel: Integer;
  it: TTMSFNCListBoxItem;
begin
  sel := Max(0, FFolders.ItemIndex);
  FUpdating := True;
  FFolders.BeginUpdate;
  try
    FFolders.Items.Clear;
    for I := Low(FolderNames) to High(FolderNames) do
    begin
      it := FFolders.Items.Add;
      it.Text := FolderNames[I];
      it.DataInteger := I;
      TTMSFNCThemeIcons.LoadInto(it.Bitmap, FolderIcons[I], 20, gcBlack);
      n := UnreadCount(I);
      if n > 0 then
        it.Badge := IntToStr(n);
      if I = 0 then
        it.BadgeKind := tskAccent
      else if I = FolderSpam then
        it.BadgeKind := tskWarning;
    end;
  finally
    FFolders.EndUpdate;
    FUpdating := False;
  end;
  FFolders.ItemIndex := sel;
end;

function TForm1.CurrentFolder: Integer;
begin
  Result := Max(0, FFolders.ItemIndex);
end;

function TForm1.MessageOf(AItem: TTMSFNCListBoxItem): Integer;
begin
  if Assigned(AItem) then
    Result := AItem.DataInteger
  else
    Result := -1;
end;

procedure TForm1.FillMessages;
var
  idx: array of Integer;
  I, J, t, n: Integer;
  f, s: string;
  m: TMessage;
  it: TTMSFNCListBoxItem;

  function Before(A, B: Integer): Boolean;
  begin
    case FSort.ItemIndex of
      1: Result := CompareText(FMessages[A].Sender, FMessages[B].Sender) < 0;
      2: Result := CompareText(FMessages[A].Subject, FMessages[B].Subject) < 0;
    else
      Result := FMessages[A].Order < FMessages[B].Order;
    end;
  end;

begin
  f := LowerCase(Trim(FSearch.Text));
  SetLength(idx, 0);
  for I := 0 to High(FMessages) do
  begin
    m := FMessages[I];
    if m.Folder <> CurrentFolder then
      Continue;
    if (f <> '') and (Pos(f, LowerCase(m.Sender + ' ' + m.Subject + ' ' + m.Body)) = 0) then
      Continue;
    SetLength(idx, Length(idx) + 1);
    idx[High(idx)] := I;
  end;
  for I := 1 to High(idx) do
  begin
    t := idx[I];
    J := I - 1;
    while (J >= 0) and Before(t, idx[J]) do
    begin
      idx[J + 1] := idx[J];
      Dec(J);
    end;
    idx[J + 1] := t;
  end;

  FUpdating := True;
  FList.BeginUpdate;
  try
    FList.Items.Clear;
    n := 0;
    for I := 0 to High(idx) do
    begin
      m := FMessages[idx[I]];
      it := FList.Items.Add;
      it.DataInteger := idx[I];
      it.DataString := 'message';
      if m.Unread then
        s := '<b>' + m.Sender + '</b>'
      else
        s := m.Sender;
      it.Text := s + '&nbsp;&nbsp;<font color="var(--text-secondary)">' + m.Time + '</font><br>' + m.Subject +
        '<br><font color="var(--text-secondary)">' + Copy(m.Body, 1, 60) + '...</font>';
      for J := Low(LabelNames) to High(LabelNames) do
        if m.Labels and (1 shl J) <> 0 then
        begin
          it.Badge := LabelNames[J];
          Break;
        end;
      if m.Unread then
        Inc(n);
    end;
    FList.Header.Text := FolderNames[CurrentFolder] + '&nbsp;&nbsp;<font color="var(--text-secondary)">' +
      IntToStr(Length(idx)) + ' messages, ' + IntToStr(n) + ' unread</font>';
  finally
    FList.EndUpdate;
    FUpdating := False;
  end;
  if FList.Items.Count > 0 then
  begin
    FList.ItemIndex := 0;
    ShowMessageAt(MessageOf(FList.Items[0]));
  end
  else
    ShowMessageAt(-1);
end;

procedure TForm1.ShowMessageAt(AIndex: Integer);
var
  I: Integer;
begin
  FUpdating := True;
  try
    for I := 0 to FLabels.Items.Count - 1 do
      FLabels.Checked[I] := (AIndex >= 0) and (FMessages[AIndex].Labels and (1 shl I) <> 0);
  finally
    FUpdating := False;
  end;
  FLabels.Enabled := AIndex >= 0;
  if AIndex < 0 then
  begin
    FReadSubject.Text := 'No message';
    FReadBody.Text := 'This folder has no messages that match.';
    Exit;
  end;
  FReadSubject.Text := FMessages[AIndex].Subject;
  FReadBody.Text := '<b>' + FMessages[AIndex].Sender + '</b>&nbsp;&nbsp;' + FMessages[AIndex].Time + '<br><br>' +
    '<font color="var(--text)">' + FMessages[AIndex].Body + '</font>';
end;

procedure TForm1.FolderSelected(Sender: TObject; AItem: TTMSFNCListBoxItem);
begin
  if not FUpdating then
    FillMessages;
end;

procedure TForm1.MessageSelected(Sender: TObject; AItem: TTMSFNCListBoxItem);
var
  k: Integer;
begin
  if FUpdating then
    Exit;
  k := MessageOf(AItem);
  ShowMessageAt(k);
  if (k >= 0) and FMessages[k].Unread then
  begin
    { reading a message marks it read: the sender is no longer bold and the folder badge counts one less }
    FMessages[k].Unread := False;
    AItem.Text := StringReplace(StringReplace(AItem.Text, '<b>', '', []), '</b>', '', []);
    FillFolders;
  end;
end;

{ a message dropped onto a folder moves there; the folder list itself keeps its items }
procedure TForm1.FolderBeforeDrop(Sender: TObject; AFromItem, AToItem: TTMSFNCListBoxItem; var ACanDrop: Boolean);
var
  k: Integer;
begin
  ACanDrop := False;
  if not Assigned(AFromItem) or not Assigned(AToItem) or (AFromItem.DataString <> 'message') then
    Exit;
  k := MessageOf(AFromItem);
  if (k < 0) or (AToItem.DataInteger = FMessages[k].Folder) then
    Exit;
  FMessages[k].Folder := AToItem.DataInteger;
  FillFolders;
  FillMessages;
end;

{ the message list is sorted by the segmented control: no reordering by drag inside it }
procedure TForm1.ListBeforeDrop(Sender: TObject; AFromItem, AToItem: TTMSFNCListBoxItem; var ACanDrop: Boolean);
begin
  ACanDrop := False;
end;

procedure TForm1.LabelCheckChanged(Sender: TObject; AItem: TTMSFNCCheckedListBoxItem);
var
  k, I, sel: Integer;
begin
  k := MessageOf(FList.SelectedItem);
  if FUpdating or (k < 0) then
    Exit;
  FMessages[k].Labels := 0;
  for I := 0 to FLabels.Items.Count - 1 do
    if FLabels.Checked[I] then
      FMessages[k].Labels := FMessages[k].Labels or (1 shl I);
  sel := FList.ItemIndex;
  FList.SelectedItem.Badge := '';
  for I := 0 to FLabels.Items.Count - 1 do
    if FLabels.Checked[I] then
    begin
      FList.SelectedItem.Badge := LabelNames[I];
      Break;
    end;
  FList.ItemIndex := sel;
end;

procedure TForm1.SearchChanged(Sender: TObject);
begin
  FillMessages;
end;

procedure TForm1.SortChanged(Sender: TObject);
begin
  FillMessages;
end;

end.
