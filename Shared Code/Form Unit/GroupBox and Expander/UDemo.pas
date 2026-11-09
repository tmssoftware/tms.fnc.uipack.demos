unit UDemo;

{ TMS FNC UI Pack - GroupBox and Expander

  Settings grouped in group boxes: the card style with a caption and a description, the classic frame and a
  plain header. A caption check box switches a whole group on or off and disables its content. Collapsible
  groups fold their content away; groups with the same GroupName form an accordion where opening one closes
  the others. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCGroupBox, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCGroupBox, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton, WEBLib.TMSFNCGroupBox, WEBLib.TMSFNCTheme,
  WEBLib.TMSFNCThemeSelector,
  {$ENDIF}
  UDemoLayout;

type
  TForm1 = class(TDemoForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TTMSFNCPanel;
    DemoTitle: TTMSFNCHTMLText;
    DemoDescription: TTMSFNCHTMLText;
    DemoThemeSelector: TTMSFNCThemeSelector;
    procedure FormCreate(Sender: TObject);
  private
    FLayout: TDemoLayout;
    FSettings: TTMSFNCPanel;
    FContent: TTMSFNCPanel;
    FStyleRadios: array[TTMSFNCGroupBoxStyle] of TTMSFNCRadioButton;
    FLeftChevronCheck: TTMSFNCCheckBox;
    FAnimateCheck: TTMSFNCCheckBox;
    FAccordionCheck: TTMSFNCCheckBox;
    FDisableCheck: TTMSFNCCheckBox;
    FStatus: TTMSFNCHTMLText;
    FGroups: array of TTMSFNCGroupBox;
    FAccordion: array[0..2] of TTMSFNCGroupBox;
    function AddGroup(AParent: TDemoParent; const ACaption, ADescription: string; AHeight: Integer): TTMSFNCGroupBox;
    procedure FillGroup(AGroup: TTMSFNCGroupBox; const AOptions: array of string);
    procedure CreateSettings;
    procedure CreateContent;
    procedure ApplySettings;
    procedure SettingChanged(Sender: TObject);
    procedure GroupCheckChanged(Sender: TObject);
    procedure GroupToggled(Sender: TObject);
    procedure OptionChanged(Sender: TObject);
    procedure ExpandAllClick(Sender: TObject);
    procedure CollapseAllClick(Sender: TObject);
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

procedure TForm1.FormCreate(Sender: TObject);
begin
  FLayout := TDemoLayout.Create(Self);
  CreateSettings;
  CreateContent;
  ApplySettings;
end;

procedure TForm1.CreateSettings;
const
  StyleNames: array[TTMSFNCGroupBoxStyle] of string = ('Card', 'Frame', 'Header only');
var
  st: TTMSFNCGroupBoxStyle;
begin
  FSettings := FLayout.AddSettingsPanel(Self);

  FLayout.AddCaption(FSettings, 'Style');
  for st := Low(TTMSFNCGroupBoxStyle) to High(TTMSFNCGroupBoxStyle) do
    FStyleRadios[st] := FLayout.AddRadio(FSettings, StyleNames[st], 'Style', st = gbsCard, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Check box');
  FDisableCheck := FLayout.AddCheck(FSettings, 'Unchecked disables the content', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Expander');
  FAccordionCheck := FLayout.AddCheck(FSettings, 'Accordion: one group open at a time', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FLeftChevronCheck := FLayout.AddCheck(FSettings, 'Chevron on the left', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FAnimateCheck := FLayout.AddCheck(FSettings, 'Animate', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FLayout.AddButton(FSettings, 'Expand all', {$IFDEF WEBLIB}@{$ENDIF}ExpandAllClick);
  FLayout.AddButton(FSettings, 'Collapse all', {$IFDEF WEBLIB}@{$ENDIF}CollapseAllClick);

  FLayout.AddCaption(FSettings, 'State');
  FStatus := FLayout.AddText(FSettings, 'Click a header or a caption check box.', 100);
end;

function TForm1.AddGroup(AParent: TDemoParent; const ACaption, ADescription: string; AHeight: Integer): TTMSFNCGroupBox;
begin
  Result := TTMSFNCGroupBox.Create(Self);
  Result.Parent := AParent;
  FLayout.Place(Result, daTop, AHeight, 0, 0, 0, 12);
  Result.Caption := ACaption;
  Result.Description := ADescription;
  Result.OnCheckChanged := {$IFDEF WEBLIB}@{$ENDIF}GroupCheckChanged;
  Result.OnAfterCollapse := {$IFDEF WEBLIB}@{$ENDIF}GroupToggled;
  Result.OnAfterExpand := {$IFDEF WEBLIB}@{$ENDIF}GroupToggled;
  SetLength(FGroups, Length(FGroups) + 1);
  FGroups[High(FGroups)] := Result;
end;

procedure TForm1.FillGroup(AGroup: TTMSFNCGroupBox; const AOptions: array of string);
var
  I: Integer;
begin
  for I := 0 to High(AOptions) do
    FLayout.AddCheck(AGroup, AOptions[I], I mod 2 = 0, {$IFDEF WEBLIB}@{$ENDIF}OptionChanged);
end;

procedure TForm1.CreateContent;
var
  left, right: TTMSFNCPanel;
  g: TTMSFNCGroupBox;
  I: Integer;
const
  Sections: array[0..2] of string = ('Account', 'Privacy', 'Advanced');
  Details: array[0..2] of string = ('Name, e-mail and password', 'What others can see', 'For experienced users');
begin
  FContent := FLayout.AddContentPanel(Self);

  { the left column: group boxes with a caption check box }
  left := FLayout.AddPanel(FContent, daLeft, 360, 0, 0, 16, 0);
  left.Fill.Kind := gfkNone;
  left.Stroke.Kind := gskNone;
  FLayout.AddCaption(left, 'Group boxes', 8);
  g := AddGroup(left, 'Notifications', 'How you want to be told about activity', 180);
  g.ShowCheckBox := True;
  FillGroup(g, ['Mail on every comment', 'Daily summary', 'Mentions only']);
  g := AddGroup(left, 'Synchronisation', 'Keep this device up to date', 148);
  g.ShowCheckBox := True;
  g.Checked := False;
  FillGroup(g, ['Photos', 'Documents']);
  g := AddGroup(left, 'Appearance', '', 112);
  FillGroup(g, ['Compact rows', 'Show icons']);

  { the right column: an accordion of collapsible groups }
  right := FLayout.AddPanel(FContent, daClient, 0, 0, 0, 0, 0);
  right.Fill.Kind := gfkNone;
  right.Stroke.Kind := gskNone;
  FLayout.AddCaption(right, 'Expanders', 8);
  for I := 0 to 2 do
  begin
    FAccordion[I] := AddGroup(right, Sections[I], Details[I], 150);
    FAccordion[I].Collapsible := True;
    FAccordion[I].Collapsed := I > 0;
    FillGroup(FAccordion[I], ['Option one of ' + Sections[I], 'Option two', 'Option three']);
  end;
end;

procedure TForm1.ApplySettings;
var
  I: Integer;
  st: TTMSFNCGroupBoxStyle;
begin
  for I := 0 to High(FGroups) do
  begin
    FGroups[I].BeginUpdate;
    for st := Low(TTMSFNCGroupBoxStyle) to High(TTMSFNCGroupBoxStyle) do
      if FStyleRadios[st].Checked then
        FGroups[I].Style := st;
    FGroups[I].CheckBoxDisablesContent := FDisableCheck.Checked;
    FGroups[I].Animate := FAnimateCheck.Checked;
    if FLeftChevronCheck.Checked then
      FGroups[I].ChevronPosition := gbcpLeft
    else
      FGroups[I].ChevronPosition := gbcpRight;
    FGroups[I].EndUpdate;
  end;
  for I := 0 to 2 do
    if FAccordionCheck.Checked then
      FAccordion[I].GroupName := 'Settings'
    else
      FAccordion[I].GroupName := '';
end;

procedure TForm1.SettingChanged(Sender: TObject);
begin
  ApplySettings;
end;

procedure TForm1.GroupCheckChanged(Sender: TObject);
var
  g: TTMSFNCGroupBox;
begin
  g := TTMSFNCGroupBox(Sender);
  if g.Checked then
    FStatus.Text := '<b>' + g.Caption + '</b> switched on'
  else
    FStatus.Text := '<b>' + g.Caption + '</b> switched off';
end;

procedure TForm1.GroupToggled(Sender: TObject);
var
  g: TTMSFNCGroupBox;
begin
  g := TTMSFNCGroupBox(Sender);
  if g.Collapsed then
    FStatus.Text := '<b>' + g.Caption + '</b> collapsed'
  else
    FStatus.Text := '<b>' + g.Caption + '</b> expanded';
end;

procedure TForm1.OptionChanged(Sender: TObject);
begin
  FStatus.Text := '<b>' + TTMSFNCCheckBox(Sender).Text + '</b> changed';
end;

procedure TForm1.ExpandAllClick(Sender: TObject);
var
  I: Integer;
begin
  { an accordion keeps one group open: switch it off to open every group }
  FAccordionCheck.Checked := False;
  for I := 0 to 2 do
    FAccordion[I].Expand(FAnimateCheck.Checked);
end;

procedure TForm1.CollapseAllClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to 2 do
    FAccordion[I].Collapse(FAnimateCheck.Checked);
end;

end.
