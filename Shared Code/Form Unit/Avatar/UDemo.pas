unit UDemo;

{ TMS FNC UI Pack - Avatar

  One TTMSFNCAvatar shows a person: a picture, or initials on a colour derived from the name, with a presence dot,
  a badge count or an active ring. With items it shows a group: the first MaxVisible members and a "+n" overflow
  avatar. The settings change every avatar on the page at once. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCPanel, VCL.TMSFNCHTMLText, VCL.TMSFNCButton, VCL.TMSFNCCheckBox, VCL.TMSFNCRadioButton,
  VCL.TMSFNCStackPanel, VCL.TMSFNCAvatar, VCL.TMSFNCSampleData, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCPanel, FMX.TMSFNCHTMLText, FMX.TMSFNCButton, FMX.TMSFNCCheckBox, FMX.TMSFNCRadioButton,
  FMX.TMSFNCStackPanel, FMX.TMSFNCAvatar, FMX.TMSFNCSampleData, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCPanel, WEBLib.TMSFNCHTMLText, WEBLib.TMSFNCButton,
  WEBLib.TMSFNCCheckBox, WEBLib.TMSFNCRadioButton, WEBLib.TMSFNCStackPanel, WEBLib.TMSFNCAvatar,
  WEBLib.TMSFNCSampleData, WEBLib.TMSFNCTheme, WEBLib.TMSFNCThemeSelector,
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
    FStatusCheck: TTMSFNCCheckBox;
    FSolidCheck: TTMSFNCCheckBox;
    FRingCheck: TTMSFNCCheckBox;
    FLiftCheck: TTMSFNCCheckBox;
    FShapeRadios: array[TTMSFNCAvatarShape] of TTMSFNCRadioButton;
    FAvatars: array of TTMSFNCAvatar;
    FGroup: TTMSFNCAvatar;
    FGroupText: TTMSFNCHTMLText;
    FNames: TArray<string>;
    FNextMember: Integer;
    function AddRow(const ACaption: string; AHeight: Integer): TTMSFNCStackPanel;
    function AddAvatar(AParent: TTMSFNCStackPanel; const AName: string; ASize: TTMSFNCAvatarSize): TTMSFNCAvatar;
    procedure CreateSettings;
    procedure CreateContent;
    procedure ApplySettings;
    procedure SettingChanged(Sender: TObject);
    procedure AddMemberClick(Sender: TObject);
    procedure RemoveMemberClick(Sender: TObject);
    procedure MoreVisibleClick(Sender: TObject);
    procedure FewerVisibleClick(Sender: TObject);
    procedure UpdateGroupText;
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
  FNames := TTMSFNCSampleData.People;
  CreateSettings;
  CreateContent;
  ApplySettings;
end;

procedure TForm1.CreateSettings;
var
  sh: TTMSFNCAvatarShape;
const
  ShapeNames: array[TTMSFNCAvatarShape] of string = ('Circle', 'Rounded square', 'Square');
begin
  FSettings := FLayout.AddSettingsPanel(Self);

  FLayout.AddCaption(FSettings, 'Appearance');
  FStatusCheck := FLayout.AddCheck(FSettings, 'Presence status', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FSolidCheck := FLayout.AddCheck(FSettings, 'Solid colours', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FRingCheck := FLayout.AddCheck(FSettings, 'Active ring', False, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FLiftCheck := FLayout.AddCheck(FSettings, 'Lift on hover', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Shape');
  for sh := Low(TTMSFNCAvatarShape) to High(TTMSFNCAvatarShape) do
    FShapeRadios[sh] := FLayout.AddRadio(FSettings, ShapeNames[sh], 'Shape', sh = avsCircle, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Group');
  FLayout.AddButton(FSettings, 'Add a member', {$IFDEF WEBLIB}@{$ENDIF}AddMemberClick);
  FLayout.AddButton(FSettings, 'Remove the last member', {$IFDEF WEBLIB}@{$ENDIF}RemoveMemberClick);
  FLayout.AddButton(FSettings, 'Show one more', {$IFDEF WEBLIB}@{$ENDIF}MoreVisibleClick);
  FLayout.AddButton(FSettings, 'Show one less', {$IFDEF WEBLIB}@{$ENDIF}FewerVisibleClick);
  FGroupText := FLayout.AddText(FSettings, '', 44);
end;

function TForm1.AddRow(const ACaption: string; AHeight: Integer): TTMSFNCStackPanel;
begin
  FLayout.AddCaption(FContent, ACaption, 8);
  Result := TTMSFNCStackPanel.Create(Self);
  Result.Parent := FContent;
  FLayout.Place(Result, daTop, AHeight, 16, 0, 16, 8);
  Result.Orientation := spoHorizontal;
  Result.Alignment := lpaCenter;
  Result.Gap := 24;
  Result.ContentPadding.Rect := RectF(8, 8, 8, 8);
end;

function TForm1.AddAvatar(AParent: TTMSFNCStackPanel; const AName: string; ASize: TTMSFNCAvatarSize): TTMSFNCAvatar;
begin
  Result := TTMSFNCAvatar.Create(Self);
  Result.Parent := AParent;
  Result.Size := ASize;
  Result.Text := AName;
  Result.Hint := AName;
  Result.ShowHint := True;
  SetLength(FAvatars, Length(FAvatars) + 1);
  FAvatars[High(FAvatars)] := Result;
end;

procedure TForm1.CreateContent;
const
  Sizes: array[0..5] of TTMSFNCAvatarSize = (avzExtraSmall, avzSmall, avzMedium, avzLarge, avzExtraLarge, avzHuge);
  States: array[0..5] of TTMSFNCAvatarStatus = (avstNone, avstOnline, avstAway, avstBusy, avstDoNotDisturb, avstOffline);
var
  row: TTMSFNCStackPanel;
  a: TTMSFNCAvatar;
  I: Integer;
begin
  FContent := FLayout.AddContentPanel(Self);

  { the six size presets, each with another presence state }
  row := AddRow('Sizes and presence', 104);
  for I := 0 to 5 do
  begin
    a := AddAvatar(row, FNames[I], Sizes[I]);
    a.Status := States[I];
    a.Tag := Ord(States[I]);
  end;

  { what a single avatar can carry }
  row := AddRow('Badges, pictures and placeholders', 96);
  a := AddAvatar(row, FNames[6], avzLarge);
  a.BadgeCount := 3;
  a := AddAvatar(row, FNames[7], avzLarge);
  a.BadgeCount := 120;
  a.Status := avstOnline;
  a.Tag := Ord(avstOnline);
  a := AddAvatar(row, 'Design team', avzLarge);
  a.MaxInitials := 1;
  a := AddAvatar(row, 'ops@example.com', avzLarge);
  a.Initials := 'OPS';
  a := AddAvatar(row, '', avzLarge);
  a.Hint := 'No name: the placeholder';
  { demo-colors: a fixed avatar colour instead of the one derived from the name }
  a := AddAvatar(row, FNames[8], avzLarge);
  a.ColorStyle := avcFixed;
  a.Color := gcSteelblue;
  a.Hint := FNames[8] + ' with a fixed colour';

  { a group: the first members and the overflow count }
  row := AddRow('Group', 80);
  FGroup := TTMSFNCAvatar.Create(Self);
  FGroup.Parent := row;
  FGroup.Size := avzMedium;
  for I := 0 to 5 do
    FGroup.Items.AddAvatar(FNames[I], States[(I + 1) mod 6]).Tag := Ord(States[(I + 1) mod 6]);
  FNextMember := 6;
  SetLength(FAvatars, Length(FAvatars) + 1);
  FAvatars[High(FAvatars)] := FGroup;
  UpdateGroupText;
end;

procedure TForm1.ApplySettings;
var
  I, J: Integer;
  a: TTMSFNCAvatar;
  sh: TTMSFNCAvatarShape;
begin
  for I := 0 to High(FAvatars) do
  begin
    a := FAvatars[I];
    a.BeginUpdate;
    { the presence state of every avatar and member is kept in its Tag while the setting hides it }
    if FStatusCheck.Checked then
      a.Status := TTMSFNCAvatarStatus(a.Tag)
    else
      a.Status := avstNone;
    for J := 0 to a.Items.Count - 1 do
      if FStatusCheck.Checked then
        a.Items[J].Status := TTMSFNCAvatarStatus(a.Items[J].Tag)
      else
        a.Items[J].Status := avstNone;
    if a.ColorStyle <> avcFixed then
    begin
      if FSolidCheck.Checked then
        a.ColorStyle := avcSolid
      else
        a.ColorStyle := avcTinted;
    end;
    a.ShowActiveRing := FRingCheck.Checked;
    a.HoverLift := FLiftCheck.Checked;
    for sh := Low(TTMSFNCAvatarShape) to High(TTMSFNCAvatarShape) do
      if FShapeRadios[sh].Checked then
        a.Shape := sh;
    a.EndUpdate;
  end;
end;

procedure TForm1.SettingChanged(Sender: TObject);
begin
  ApplySettings;
end;

procedure TForm1.UpdateGroupText;
begin
  FGroupText.Text := IntToStr(FGroup.Items.Count) + ' members, ' + IntToStr(FGroup.MaxVisible) +
    ' shown; the rest is the overflow count. Hover an avatar for its name.';
end;

procedure TForm1.AddMemberClick(Sender: TObject);
begin
  FGroup.Items.AddAvatar(FNames[FNextMember mod Length(FNames)]);
  Inc(FNextMember);
  UpdateGroupText;
end;

procedure TForm1.RemoveMemberClick(Sender: TObject);
begin
  if FGroup.Items.Count > 0 then
    FGroup.Items.Delete(FGroup.Items.Count - 1);
  UpdateGroupText;
end;

procedure TForm1.MoreVisibleClick(Sender: TObject);
begin
  FGroup.MaxVisible := FGroup.MaxVisible + 1;
  UpdateGroupText;
end;

procedure TForm1.FewerVisibleClick(Sender: TObject);
begin
  if FGroup.MaxVisible > 1 then
    FGroup.MaxVisible := FGroup.MaxVisible - 1;
  UpdateGroupText;
end;

end.
