unit UDemoLayout;

{ Layout helpers shared by the demos that build their settings panel and content in code, the same code for FMX,
  VCL and WEB: controls aligned top or left with margins on the 8 px grid of the demo guidelines, section captions,
  secondary text, check boxes and buttons, and the in-memory datasets of the data demos. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, System.SysUtils, System.Classes, System.Types, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  VCL.TMSFNCTypes, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton,
  VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton;
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Classes, System.Types, System.UITypes, FMX.Types, FMX.Controls, FMX.Forms, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FMX.TMSFNCTypes, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton,
  FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton;
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, Types, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, DB, WEBLib.DB, WEBLib.CDS,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCGraphicsTypes, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton;
  {$ENDIF}

type
  {$IFDEF WEBLIB}
  TDemoDataSet = TWebClientDataSet;
  TDemoForm = TWebForm;
  TDemoParent = TControl;
  {$ENDIF}
  {$IFNDEF WEBLIB}
  TDemoDataSet = TFDMemTable;
  TDemoForm = TForm;
  {$IFDEF FMX}
  TDemoParent = TFmxObject;
  {$ELSE}
  TDemoParent = TWinControl;
  {$ENDIF}
  {$ENDIF}

  TDemoAlign = (daTop, daLeft, daRight, daBottom, daClient);

  TDemoLayout = class
  private
    FOwner: TDemoForm;
    FPlaceOrder: Integer;
  public
    constructor Create(AOwner: TDemoForm);
    { a size in pixels at 96 DPI for the form's DPI (VCL: the form is scaled when it loads, controls made in code
      are not); FMX and WEB work in device independent pixels }
    function Size(AValue: Integer): Integer;
    { aligns a control after the controls aligned before it, with margins }
    procedure Place(AControl: TControl; AAlign: TDemoAlign; ASize, ALeft, ATop, ARight, ABottom: Integer);
    { a section caption: 13 px semibold }
    function AddCaption(AParent: TDemoParent; const AText: string; ATop: Integer = 16): TTMSFNCHTMLText;
    { a block of secondary text that wraps }
    function AddText(AParent: TDemoParent; const AText: string; AHeight: Integer): TTMSFNCHTMLText;
    function AddCheck(AParent: TDemoParent; const AText: string; AChecked: Boolean; AOnChange: TNotifyEvent): TTMSFNCCheckBox;
    function AddRadio(AParent: TDemoParent; const AText, AGroup: string; AChecked: Boolean; AOnChange: TNotifyEvent): TTMSFNCRadioButton;
    function AddButton(AParent: TDemoParent; const AText: string; AOnClick: TNotifyEvent): TTMSFNCButton;
    { a plain panel without header, aligned with margins }
    function AddPanel(AParent: TDemoParent; AAlign: TDemoAlign; ASize, ALeft, ATop, ARight, ABottom: Integer): TTMSFNCPanel;
    { the settings panel on the left (260 wide) and the content area (Align Client, no fill or stroke) }
    function AddSettingsPanel(AParent: TDemoParent; AWidth: Integer = 260): TTMSFNCPanel;
    function AddContentPanel(AParent: TDemoParent): TTMSFNCPanel;
    { in-memory datasets: TFDMemTable on FMX and VCL, TWebClientDataSet on WEB }
    function NewDataSet: TDemoDataSet;
    procedure OpenDataSet(ADataSet: TDemoDataSet);
    function NewSource(ADataSet: TDataSet): TDataSource;
    property Owner: TDemoForm read FOwner;
  end;

implementation

constructor TDemoLayout.Create(AOwner: TDemoForm);
begin
  inherited Create;
  FOwner := AOwner;
end;

function TDemoLayout.Size(AValue: Integer): Integer;
begin
  {$IFDEF VCL}
  Result := MulDiv(AValue, FOwner.CurrentPPI, 96);
  {$ELSE}
  Result := AValue;
  {$ENDIF}
end;

procedure TDemoLayout.Place(AControl: TControl; AAlign: TDemoAlign; ASize, ALeft, ATop, ARight, ABottom: Integer);
begin
  { a position beyond every control aligned earlier (VCL and WEB order controls of the same alignment by their
    position less their margin, so the steps are larger than any margin) }
  Inc(FPlaceOrder);
  {$IFDEF FMX}
  AControl.Position.Y := 100000 + FPlaceOrder * 1000;
  AControl.Position.X := 100000 + FPlaceOrder * 1000;
  case AAlign of
    daTop: begin AControl.Align := TAlignLayout.Top; AControl.Height := ASize; end;
    daLeft: begin AControl.Align := TAlignLayout.Left; AControl.Width := ASize; end;
    daRight: begin AControl.Align := TAlignLayout.Right; AControl.Width := ASize; end;
    daBottom: begin AControl.Align := TAlignLayout.Bottom; AControl.Height := ASize; end;
    daClient: AControl.Align := TAlignLayout.Client;
  end;
  AControl.Margins.Rect := RectF(ALeft, ATop, ARight, ABottom);
  {$ELSE}
  AControl.Top := 100000 + FPlaceOrder * 1000;
  AControl.Left := 100000 + FPlaceOrder * 1000;
  case AAlign of
    daTop: begin AControl.Align := alTop; AControl.Height := Size(ASize); end;
    daLeft: begin AControl.Align := alLeft; AControl.Width := Size(ASize); end;
    daRight: begin AControl.Align := alRight; AControl.Width := Size(ASize); end;
    daBottom: begin AControl.Align := alBottom; AControl.Height := Size(ASize); end;
    daClient: AControl.Align := alClient;
  end;
  AControl.AlignWithMargins := True;
  AControl.Margins.Left := Size(ALeft);
  AControl.Margins.Top := Size(ATop);
  AControl.Margins.Right := Size(ARight);
  AControl.Margins.Bottom := Size(ABottom);
  {$ENDIF}
end;

function TDemoLayout.AddCaption(AParent: TDemoParent; const AText: string; ATop: Integer): TTMSFNCHTMLText;
begin
  Result := TTMSFNCHTMLText.Create(FOwner);
  Result.Parent := AParent;
  Place(Result, daTop, 24, 16, ATop, 16, 4);
  Result.Text := AText;
  Result.HorizontalTextAlign := gtaLeading;
  Result.Fill.Kind := gfkNone;
  Result.Stroke.Kind := gskNone;
  {$IFDEF FMX}
  Result.Font.Size := 13;
  Result.Font.Style := [TFontStyle.fsBold];
  {$ELSE}
  Result.Font.Height := -Size(13);
  Result.Font.Style := [fsBold];
  {$ENDIF}
end;

function TDemoLayout.AddText(AParent: TDemoParent; const AText: string; AHeight: Integer): TTMSFNCHTMLText;
begin
  Result := TTMSFNCHTMLText.Create(FOwner);
  Result.Parent := AParent;
  Place(Result, daTop, AHeight, 16, 4, 16, 4);
  Result.Text := AText;
  Result.TextRole := htrSecondary;
  Result.HorizontalTextAlign := gtaLeading;
  Result.VerticalTextAlign := gtaLeading;
  Result.WordWrapping := True;
  Result.Fill.Kind := gfkNone;
  Result.Stroke.Kind := gskNone;
end;

function TDemoLayout.AddCheck(AParent: TDemoParent; const AText: string; AChecked: Boolean; AOnChange: TNotifyEvent): TTMSFNCCheckBox;
begin
  Result := TTMSFNCCheckBox.Create(FOwner);
  Result.Parent := AParent;
  Place(Result, daTop, 32, 16, 0, 16, 0);
  Result.Text := AText;
  Result.Checked := AChecked;
  Result.OnChange := AOnChange;
end;

function TDemoLayout.AddRadio(AParent: TDemoParent; const AText, AGroup: string; AChecked: Boolean; AOnChange: TNotifyEvent): TTMSFNCRadioButton;
begin
  Result := TTMSFNCRadioButton.Create(FOwner);
  Result.Parent := AParent;
  Place(Result, daTop, 32, 16, 0, 16, 0);
  Result.Text := AText;
  Result.GroupName := AGroup;
  Result.Checked := AChecked;
  Result.OnChange := AOnChange;
end;

function TDemoLayout.AddButton(AParent: TDemoParent; const AText: string; AOnClick: TNotifyEvent): TTMSFNCButton;
begin
  Result := TTMSFNCButton.Create(FOwner);
  Result.Parent := AParent;
  Place(Result, daTop, 32, 16, 8, 16, 0);
  Result.Text := AText;
  Result.OnClick := AOnClick;
end;

function TDemoLayout.AddPanel(AParent: TDemoParent; AAlign: TDemoAlign; ASize, ALeft, ATop, ARight, ABottom: Integer): TTMSFNCPanel;
begin
  Result := TTMSFNCPanel.Create(FOwner);
  Result.Parent := AParent;
  Place(Result, AAlign, ASize, ALeft, ATop, ARight, ABottom);
  Result.Header.Visible := False;
end;

function TDemoLayout.AddSettingsPanel(AParent: TDemoParent; AWidth: Integer): TTMSFNCPanel;
begin
  Result := AddPanel(AParent, daLeft, AWidth, 16, 0, 0, 16);
end;

function TDemoLayout.AddContentPanel(AParent: TDemoParent): TTMSFNCPanel;
begin
  Result := AddPanel(AParent, daClient, 0, 16, 0, 16, 16);
  Result.Fill.Kind := gfkNone;
  Result.Stroke.Kind := gskNone;
end;

function TDemoLayout.NewDataSet: TDemoDataSet;
begin
  Result := TDemoDataSet.Create(FOwner);
end;

procedure TDemoLayout.OpenDataSet(ADataSet: TDemoDataSet);
begin
  { an empty in-memory dataset with the field definitions (WEB: opening it creates it) }
  {$IFDEF WEBLIB}
  ADataSet.Active := True;
  {$ELSE}
  ADataSet.CreateDataSet;
  ADataSet.LogChanges := False;
  {$ENDIF}
end;

function TDemoLayout.NewSource(ADataSet: TDataSet): TDataSource;
begin
  {$IFDEF WEBLIB}
  Result := TWebDataSource.Create(FOwner);
  {$ELSE}
  Result := TDataSource.Create(FOwner);
  {$ENDIF}
  Result.DataSet := ADataSet;
end;

end.
