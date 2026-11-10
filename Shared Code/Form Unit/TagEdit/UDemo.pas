unit UDemo;

{ TMS FNC UI Pack - TagEdit

  Tags as chips in an edit field: type a tag and press Enter or a comma, pick one from the suggestions that
  appear while typing, remove one with its cross or with Backspace. Uniform or automatic colours per tag, a
  maximum number of tags with a counter, a clear button, a single line that scrolls instead of wrapping, and
  OnValidateTag to refuse or correct what is typed. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCStackPanel, VCL.TMSFNCTagEdit, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCStackPanel, FMX.TMSFNCTagEdit, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton, WEBLib.TMSFNCStackPanel, WEBLib.TMSFNCTagEdit,
  WEBLib.TMSFNCTheme, WEBLib.TMSFNCThemeSelector,
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
    FUniformRadio: TTMSFNCRadioButton;
    FAutoRadio: TTMSFNCRadioButton;
    FWrapCheck: TTMSFNCCheckBox;
    FClearCheck: TTMSFNCCheckBox;
    FCounterCheck: TTMSFNCCheckBox;
    FDuplicatesCheck: TTMSFNCCheckBox;
    FLog: TTMSFNCHTMLText;
    FEdits: array of TTMSFNCTagEdit;
    FSkills: TTMSFNCTagEdit;
    FRecipients: TTMSFNCTagEdit;
    function AddTagEdit(AParent: TTMSFNCStackPanel; const ALabel: string; const ATags: array of string): TTMSFNCTagEdit;
    procedure CreateSettings;
    procedure CreateContent;
    procedure ApplySettings;
    procedure SettingChanged(Sender: TObject);
    procedure TagAdded(Sender: TObject; AItem: TTMSFNCTagEditItem);
    procedure TagRemoved(Sender: TObject; const AText: string);
    procedure TagClick(Sender: TObject; AItem: TTMSFNCTagEditItem);
    procedure RecipientValidate(Sender: TObject; var AText: string; var AAllow: Boolean);
    procedure ShowValuesClick(Sender: TObject);
    procedure Log(const AText: string);
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
begin
  FSettings := FLayout.AddSettingsPanel(Self);

  FLayout.AddCaption(FSettings, 'Colours');
  FUniformRadio := FLayout.AddRadio(FSettings, 'Uniform, from the theme', 'Colour', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FAutoRadio := FLayout.AddRadio(FSettings, 'Automatic per tag text', 'Colour', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Options');
  FWrapCheck := FLayout.AddCheck(FSettings, 'Wrap to new lines', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FClearCheck := FLayout.AddCheck(FSettings, 'Clear button', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FCounterCheck := FLayout.AddCheck(FSettings, 'Counter (skills: 6 at most)', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FDuplicatesCheck := FLayout.AddCheck(FSettings, 'Allow duplicates', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FLayout.AddButton(FSettings, 'Show the values', {$IFDEF WEBLIB}@{$ENDIF}ShowValuesClick);

  FLayout.AddCaption(FSettings, 'Events');
  FLog := FLayout.AddText(FSettings, 'Add, remove or click a tag.', 160);
end;

function TForm1.AddTagEdit(AParent: TTMSFNCStackPanel; const ALabel: string; const ATags: array of string): TTMSFNCTagEdit;
var
  I: Integer;
begin
  FLayout.AddCaption(AParent, ALabel, 8);
  Result := TTMSFNCTagEdit.Create(Self);
  Result.Parent := AParent;
  Result.Width := FLayout.Size(520);
  Result.Height := FLayout.Size(36);
  Result.BeginUpdate;
  for I := 0 to High(ATags) do
    Result.Tags.Add(ATags[I]);
  Result.EndUpdate;
  Result.OnTagAdded := {$IFDEF WEBLIB}@{$ENDIF}TagAdded;
  Result.OnTagRemoved := {$IFDEF WEBLIB}@{$ENDIF}TagRemoved;
  Result.OnTagClick := {$IFDEF WEBLIB}@{$ENDIF}TagClick;
  SetLength(FEdits, Length(FEdits) + 1);
  FEdits[High(FEdits)] := Result;
end;

procedure TForm1.CreateContent;
var
  stack: TTMSFNCStackPanel;
  te: TTMSFNCTagEdit;
begin
  FContent := FLayout.AddContentPanel(Self);

  stack := TTMSFNCStackPanel.Create(Self);
  stack.Parent := FContent;
  FLayout.Place(stack, daClient, 0, 0, 0, 0, 0);
  stack.Appearance.Stroke.Kind := gskNone;
  stack.Gap := 4;

  { suggestions appear while typing; six tags at most }
  FSkills := AddTagEdit(stack, 'Skills (type to see suggestions, Enter or comma adds)', ['Delphi', 'FireMonkey', 'VCL']);
  FSkills.Placeholder := 'Add a skill';
  FSkills.Suggestions.CommaText := 'Android,Azure,C++Builder,Delphi,FireMonkey,iOS,Linux,macOS,SQL,TypeScript,VCL,' +
    '"WEB Core",Windows';
  FSkills.MaxTags := 6;

  { every recipient must look like an address; OnValidateTag lower cases it }
  FRecipients := AddTagEdit(stack, 'Recipients (an address with @, lower cased)', ['anna@example.com', 'bart@example.com']);
  FRecipients.Placeholder := 'name@example.com';
  FRecipients.OnValidateTag := {$IFDEF WEBLIB}@{$ENDIF}RecipientValidate;

  { labels with their own colours }
  te := AddTagEdit(stack, 'Labels (own colours, first one not removable)', ['bug', 'feature', 'ui', 'backend', 'urgent', 'docs']);
  { demo-colors: label colours chosen by the application }
  te.Tags[0].Color := gcCrimson;
  te.Tags[1].Color := gcSeagreen;
  te.Tags[4].Color := gcDarkorange;
  te.Tags[0].Removable := False;

  te := AddTagEdit(stack, 'Read only', ['approved', 'archived', '2026']);
  te.ReadOnly := True;
end;

procedure TForm1.ApplySettings;
var
  I: Integer;
begin
  for I := 0 to High(FEdits) do
  begin
    FEdits[I].BeginUpdate;
    if FAutoRadio.Checked then
      FEdits[I].ColorMode := tecmAuto
    else
      FEdits[I].ColorMode := tecmUniform;
    FEdits[I].Wrap := FWrapCheck.Checked;
    FEdits[I].ShowClearButton := FClearCheck.Checked and not FEdits[I].ReadOnly;
    FEdits[I].AllowDuplicates := FDuplicatesCheck.Checked;
    FEdits[I].EndUpdate;
  end;
  FSkills.ShowCounter := FCounterCheck.Checked;
end;

procedure TForm1.SettingChanged(Sender: TObject);
begin
  ApplySettings;
end;

procedure TForm1.Log(const AText: string);
begin
  FLog.Text := AText + '<br>' + FLog.Text;
end;

procedure TForm1.TagAdded(Sender: TObject; AItem: TTMSFNCTagEditItem);
begin
  Log('Added <b>' + AItem.Text + '</b>');
end;

procedure TForm1.TagRemoved(Sender: TObject; const AText: string);
begin
  Log('Removed <b>' + AText + '</b>');
end;

procedure TForm1.TagClick(Sender: TObject; AItem: TTMSFNCTagEditItem);
begin
  Log('Clicked <b>' + AItem.Text + '</b>');
end;

procedure TForm1.RecipientValidate(Sender: TObject; var AText: string; var AAllow: Boolean);
begin
  AText := LowerCase(Trim(AText));
  AAllow := (Pos('@', AText) > 1) and (Pos('.', AText) > Pos('@', AText));
  if not AAllow then
    Log('Refused <b>' + AText + '</b>: not an address');
end;

procedure TForm1.ShowValuesClick(Sender: TObject);
begin
  { Text joins the tags with the first delimiter, as an application stores them }
  Log('Skills: ' + FSkills.Text + '<br>Recipients: ' + FRecipients.Text);
end;

end.
