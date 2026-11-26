unit UDemo;

interface

uses
  System.SysUtils, System.Classes, System.Types, System.IOUtils,
  {$IFDEF VCL}
  Winapi.Windows, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Graphics, Vcl.Imaging.pngimage, Vcl.Themes, Vcl.Styles,
  VCL.TMSFNCStyles, VCL.TMSFNCEdit, VCL.TMSFNCButton, VCL.TMSFNCCheckBox,
  VCL.TMSFNCComboBox, VCL.TMSFNCGrid, VCL.TMSFNCTreeView;
  {$ELSE}
  System.UITypes, FMX.Forms, FMX.Types, FMX.Controls, FMX.StdCtrls, FMX.Edit,
  FMX.ListBox, FMX.Graphics, FMX.Controls.Presentation,
  FMX.TMSFNCStyles, FMX.TMSFNCEdit, FMX.TMSFNCButton, FMX.TMSFNCCheckBox,
  FMX.TMSFNCComboBox, FMX.TMSFNCGrid, FMX.TMSFNCTreeView;
  {$ENDIF}

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    FPicker: TComboBox;
    FTitle, FDescription, FNativeTitle, FFNCTitle, FNote: TLabel;
    FEdit: TEdit;
    FButton: TButton;
    FCheck: TCheckBox;
    FCombo: TComboBox;
    FList: TListBox;
    FFNCEdit: TTMSFNCEdit;
    FFNCButton: TTMSFNCButton;
    FFNCCheck: TTMSFNCCheckBox;
    FFNCCombo: TTMSFNCComboBox;
    FGrid: TTMSFNCGrid;
    FTree: TTMSFNCTreeView;
    FTimer: TTimer;
    FStep: Integer;
    FCheckPPI: Integer;
    FOutput: string;
    {$IFDEF FMX}
    FBooks: array[0..2] of TStyleBook;
    {$ENDIF}
    procedure StyleChanged(Sender: TObject);
    procedure LayoutChanged(Sender: TObject);
    procedure CheckStep(Sender: TObject);
    procedure ApplicationException(Sender: TObject; E: Exception);
    procedure SaveImage(const AFileName: string);
    procedure Place(AControl: TControl; AX, AY, AWidth, AHeight: Integer);
    function AddLabel(const AText: string; ASize: Integer): TLabel;
  end;

var
  Form1: TForm1;

implementation

{$IFDEF VCL}
{$R *.dfm}
{$ELSE}
{$R *.fmx}
{$ENDIF}

function TForm1.AddLabel(const AText: string; ASize: Integer): TLabel;
begin
  Result := TLabel.Create(Self);
  Result.Parent := Self;
  {$IFDEF VCL}
  Result.Caption := AText;
  Result.AutoSize := False;
  Result.Font.Size := ASize;
  {$ELSE}
  Result.Text := AText;
  Result.TextSettings.Font.Size := ASize * 96 / 72;
  Result.StyledSettings := Result.StyledSettings - [TStyledSetting.Size];
  {$ENDIF}
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  I: Integer;
  {$IFDEF VCL}
  S: string;
  {$ENDIF}
  {$IFDEF FMX}
  Stream: TResourceStream;
  {$ENDIF}
begin
  FTitle := AddLabel('One style, every control', 20);
  FDescription := AddLabel('Choose a platform style. Native and FNC controls follow it together.', 10);
  FNativeTitle := AddLabel('Standard controls', 13);
  FFNCTitle := AddLabel('TMS FNC controls', 13);
  FNote := AddLabel('FNC controls use AdaptToStyle. Edit, select and explore the same workspace.', 10);

  FPicker := TComboBox.Create(Self);
  FPicker.Parent := Self;
  {$IFDEF VCL}
  FPicker.Style := Vcl.StdCtrls.csDropDownList;
  for S in TStyleManager.StyleNames do
    FPicker.Items.Add(S);
  FPicker.ItemIndex := FPicker.Items.IndexOf(TStyleManager.ActiveStyle.Name);
  {$ELSE}
  FPicker.Items.Add('Platform default');
  FPicker.Items.Add('Windows modern');
  FPicker.Items.Add('Windows modern dark');
  FPicker.Items.Add('Aqua graphite');
  for I := 0 to High(FBooks) do
  begin
    FBooks[I] := TStyleBook.Create(Self);
    Stream := TResourceStream.Create(HInstance, 'STYLE' + IntToStr(I), PChar(10));
    try
      FBooks[I].LoadFromStream(Stream);
    finally
      Stream.Free;
    end;
  end;
  FPicker.ItemIndex := 0;
  {$ENDIF}
  FPicker.OnChange := StyleChanged;

  FEdit := TEdit.Create(Self);
  FEdit.Parent := Self;
  FEdit.Text := 'Design workspace';
  FButton := TButton.Create(Self);
  FButton.Parent := Self;
  {$IFDEF VCL}
  FButton.Caption := 'Create workspace';
  {$ELSE}
  FButton.Text := 'Create workspace';
  {$ENDIF}
  FCheck := TCheckBox.Create(Self);
  FCheck.Parent := Self;
  {$IFDEF VCL}
  FCheck.Caption := 'Keep me updated';
  FCheck.Checked := True;
  {$ELSE}
  FCheck.Text := 'Keep me updated';
  FCheck.IsChecked := True;
  {$ENDIF}
  FCombo := TComboBox.Create(Self);
  FCombo.Parent := Self;
  {$IFDEF VCL}
  FCombo.Style := Vcl.StdCtrls.csDropDownList;
  {$ENDIF}
  FCombo.Items.Add('Design');
  FCombo.Items.Add('Development');
  FCombo.Items.Add('Delivery');
  FCombo.ItemIndex := 0;
  FList := TListBox.Create(Self);
  FList.Parent := Self;
  FList.Items.Add('Overview');
  FList.Items.Add('Design system');
  FList.Items.Add('Components');
  FList.Items.Add('Release checklist');
  FList.ItemIndex := 1;

  FFNCEdit := TTMSFNCEdit.Create(Self);
  FFNCEdit.Parent := Self;
  FFNCEdit.Text := FEdit.Text;
  FFNCButton := TTMSFNCButton.Create(Self);
  FFNCButton.Parent := Self;
  FFNCButton.Text := 'Create workspace';
  FFNCCheck := TTMSFNCCheckBox.Create(Self);
  FFNCCheck.Parent := Self;
  FFNCCheck.Text := 'Keep me updated';
  FFNCCheck.Checked := True;
  FFNCCombo := TTMSFNCComboBox.Create(Self);
  FFNCCombo.Parent := Self;
  FFNCCombo.Items.Assign(FCombo.Items);
  FFNCCombo.ItemIndex := 0;
  FGrid := TTMSFNCGrid.Create(Self);
  FGrid.Parent := Self;
  FGrid.ColumnCount := 3;
  FGrid.RowCount := 6;
  FGrid.FixedColumns := 0;
  FGrid.Cells[0, 0] := 'Milestone';
  FGrid.Cells[1, 0] := 'Owner';
  FGrid.Cells[2, 0] := 'Status';
  FGrid.Cells[0, 1] := 'Design system';
  FGrid.Cells[0, 2] := 'Components';
  FGrid.Cells[0, 3] := 'Accessibility';
  FGrid.Cells[0, 4] := 'Style review';
  FGrid.Cells[0, 5] := 'Release';
  for I := 1 to 5 do
  begin
    FGrid.Cells[1, I] := 'Team ' + IntToStr(I);
    FGrid.Cells[2, I] := 'In progress';
  end;
  FTree := TTMSFNCTreeView.Create(Self);
  FTree.Parent := Self;
  FTree.AddNode.Text[0] := 'Workspace';
  for I := 0 to FList.Items.Count - 1 do
    FTree.AddNode.Text[0] := FList.Items[I];

  // Native-based FNC edits and buttons inherit the platform style.

  FFNCCheck.AdaptToStyle := True;
  FFNCCombo.AdaptToStyle := True;
  FGrid.AdaptToStyle := True;
  FTree.AdaptToStyle := True;
  OnResize := LayoutChanged;
  OnShow := LayoutChanged;
  LayoutChanged(Self);

  if FindCmdLineSwitch('self-check') or FindCmdLineSwitch('-self-check') then
  begin
    FOutput := TPath.Combine(ExtractFilePath(ParamStr(0)), 'output');
    for I := 1 to ParamCount - 1 do
      if ParamStr(I) = '--output' then
        FOutput := ExpandFileName(ParamStr(I + 1));
    ForceDirectories(FOutput);
    Application.OnException := ApplicationException;
    {$IFDEF VCL}
    for I := 1 to ParamCount - 1 do
      if ParamStr(I) = '--ppi' then
        FCheckPPI := StrToInt(ParamStr(I + 1));
    {$ENDIF}
    FStep := -1;
    FTimer := TTimer.Create(Self);
    FTimer.Interval := 1200;
    FTimer.OnTimer := CheckStep;
    FTimer.Enabled := True;
  end;
end;

procedure TForm1.Place(AControl: TControl; AX, AY, AWidth, AHeight: Integer);
begin
  {$IFDEF VCL}
  AControl.SetBounds(MulDiv(AX, CurrentPPI, 96), MulDiv(AY, CurrentPPI, 96),
    MulDiv(AWidth, CurrentPPI, 96), MulDiv(AHeight, CurrentPPI, 96));
  {$ELSE}
  AControl.SetBounds(AX, AY, AWidth, AHeight);
  {$ENDIF}
end;

procedure TForm1.LayoutChanged(Sender: TObject);
var
  W, H, LeftWidth, RightX, RightWidth: Integer;
begin
  if not Assigned(FTree) then
    Exit;
  {$IFDEF VCL}
  W := MulDiv(ClientWidth, 96, CurrentPPI);
  H := MulDiv(ClientHeight, 96, CurrentPPI);
  {$ELSE}
  W := ClientWidth;
  H := ClientHeight;
  {$ENDIF}
  LeftWidth := (W - 72) div 3;
  RightX := LeftWidth + 48;
  RightWidth := W - RightX - 24;
  Place(FTitle, 24, 16, W - 48, 40);
  Place(FDescription, 24, 64, W - 48, 24);
  Place(FPicker, 24, 104, W - 48, 32);
  Place(FNativeTitle, 24, 160, LeftWidth, 32);
  Place(FFNCTitle, RightX, 160, RightWidth, 32);
  Place(FEdit, 24, 208, LeftWidth, 32);
  Place(FButton, 24, 256, LeftWidth, 32);
  Place(FCheck, 24, 304, LeftWidth, 32);
  Place(FCombo, 24, 352, LeftWidth, 32);
  Place(FList, 24, 408, LeftWidth, H - 472);
  Place(FFNCEdit, RightX, 208, RightWidth, 32);
  Place(FFNCButton, RightX, 256, RightWidth, 32);
  Place(FFNCCheck, RightX, 304, RightWidth, 32);
  Place(FFNCCombo, RightX, 352, RightWidth, 32);
  Place(FTree, RightX, 408, RightWidth div 3, H - 472);
  Place(FGrid, RightX + RightWidth div 3 + 16, 408, RightWidth * 2 div 3 - 16, H - 472);
  for W := 0 to 2 do
    FGrid.ColumnWidths[W] := (FGrid.Width - 24) / 3;
  Place(FNote, 24, H - 48, LeftWidth + RightWidth + 24, 32);
end;

procedure TForm1.StyleChanged(Sender: TObject);
begin
  {$IFDEF VCL}
  TStyleManager.SetStyle(FPicker.Items[FPicker.ItemIndex]);
  {$ELSE}
  if FPicker.ItemIndex = 0 then
    StyleBook := nil
  else
    StyleBook := FBooks[FPicker.ItemIndex - 1];
  {$ENDIF}
end;

procedure TForm1.SaveImage(const AFileName: string);
var
  B: TBitmap;
  {$IFDEF VCL}
  P: TPngImage;
  DC: HDC;
  {$ENDIF}
begin
  {$IFDEF VCL}
  B := TBitmap.Create;
  try
    B.SetSize(ClientWidth, ClientHeight);
    RedrawWindow(Handle, nil, 0, RDW_INVALIDATE or RDW_ERASE or RDW_ALLCHILDREN or RDW_UPDATENOW);
    GdiFlush;
    DC := GetDC(Handle);
    try
      BitBlt(B.Canvas.Handle, 0, 0, ClientWidth, ClientHeight, DC, 0, 0, SRCCOPY);
    finally
      ReleaseDC(Handle, DC);
    end;
    P := TPngImage.Create;
    try
      P.Assign(B);
      P.SaveToFile(AFileName);
    finally
      P.Free;
    end;
  finally
    B.Free;
  end;
  {$ELSE}
  B := TBitmap.Create(ClientWidth, ClientHeight);
  try
    PaintTo(B.Canvas);
    B.SaveToFile(AFileName);
  finally
    B.Free;
  end;
  {$ENDIF}
end;

procedure TForm1.CheckStep(Sender: TObject);
var
  Name: string;
  C: Char;
begin
  FTimer.Enabled := False;
  {$IFDEF VCL}
  if (FStep = -1) and (FCheckPPI > 0) then
  begin
    ScaleForPPI(FCheckPPI);
    ClientWidth := MulDiv(1100, FCheckPPI, 96);
    ClientHeight := MulDiv(680, FCheckPPI, 96);
    LayoutChanged(Self);
  end;
  {$ENDIF}
  if FStep >= 0 then
  begin
    Name := FPicker.Items[FPicker.ItemIndex];
    for C in TPath.GetInvalidFileNameChars do
      Name := Name.Replace(C, '_');
    SaveImage(TPath.Combine(FOutput, Format('%.2d-%s.png', [FStep, Name])));
  end;
  Inc(FStep);
  if FStep = FPicker.Items.Count then
  begin
    TFile.WriteAllText(TPath.Combine(FOutput, 'success.txt'),
      IntToStr(FStep) + ' styles captured');
    Application.Terminate;
    Exit;
  end;
  FPicker.ItemIndex := FStep;
  StyleChanged(Self);
  FTimer.Enabled := True;
end;

procedure TForm1.ApplicationException(Sender: TObject; E: Exception);
begin
  if Assigned(FTimer) then
    FTimer.Enabled := False;
  TFile.WriteAllText(TPath.Combine(FOutput, 'error.txt'), E.ClassName + ': ' + E.Message);
  System.ExitCode := 1;
  Application.Terminate;
end;

end.



