unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCMemoCustomLanguage,
  FMX.TMSFNCCustomControl, FMX.TMSFNCWebBrowser, FMX.TMSFNCCustomWEBControl,
  FMX.TMSFNCMemo, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.TMSFNCMemoCustomTheme;

type
  TForm1 = class(TForm)
    TMSFNCMemo1: TTMSFNCMemo;
    TMSFNCMemoCustomLanguage1: TTMSFNCMemoCustomLanguage;
    Button1: TButton;
    Button2: TButton;
    TMSFNCMemoCustomTheme1: TTMSFNCMemoCustomTheme;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ApplyLanguageSettings;
    procedure ApplyThemeSettings;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
begin
  ApplyLanguageSettings;
  TMSFNCMemo1.CustomLanguages.Add.Language := TMSFNCMemoCustomLanguage1;
  TMSFNCMemo1.Language := mlCustom;
  Button1.Enabled := False;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  ApplyThemeSettings;
  TMSFNCMemo1.CustomThemes.Add.Theme := TMSFNCMemoCustomTheme1;
  TMSFNCMemo1.Theme := mtCustom;
  Button2.Enabled := False;
end;

procedure TForm1.ApplyLanguageSettings;
var
  root, comment, str, whitespace: TTMSFNCMemoCustomLanguageTokenizerItem;
  r: TTMSFNCMemoCustomLanguageRule;
begin
  TMSFNCMemoCustomLanguage1.LanguageID := 'mylang';

  TMSFNCMemoCustomLanguage1.ExtraKeys.Add('keywords', ['abstract', 'continue',
    'for', 'new', 'switch', 'assert', 'goto', 'do', 'if', 'private', 'this',
    'break', 'protected', 'throw', 'else', 'public', 'enum', 'return', 'catch',
    'try', 'interface', 'static', 'class', 'finally', 'const', 'super', 'while',
    'true', 'false']);

  TMSFNCMemoCustomLanguage1.ExtraKeys.Add('typeKeywords', ['boolean', 'double',
    'byte', 'int', 'short', 'char', 'void', 'long', 'float']);

  TMSFNCMemoCustomLanguage1.ExtraKeys.Add('operators', ['=', '>', '<', '!', '~',
    '?', ':', '==', '<=', '>=', '!=', '&&', '||', '++', '--', '+', '-', '*',
    '/', '&', '|', '^', '%', '<<', '>>', '>>>', '+=', '-=', '*=', '/=', '&=',
    '|=', '^=', '%=', '<<=', '>>=', '>>>=']);

  TMSFNCMemoCustomLanguage1.ExtraKeys.Add('symbols', '[=><!~?:&|+\-*\/\^%]+');

  TMSFNCMemoCustomLanguage1.ExtraKeys.Add('escapes', '\\(?:[abfnrtv\\"'']|x[0-9A-Fa-f]{1,4}|u[0-9A-Fa-f]{4}|U[0-9A-Fa-f]{8})');

  root := TMSFNCMemoCustomLanguage1.Tokenizer.Add;
  root.Name := 'root';

  // identifiers and keywords
  r := root.Rules.Add;
  r.Regex := '[a-z_$][\w$]*';
  r.Action.Cases.Add('@typeKeywords', 'keyword');
  r.Action.Cases.Add('@keywords', 'keyword');
  r.Action.Cases.Add('@default', 'identifier');

  root.Rules.Add('[A-Z][\w\$]*', 'type.identifier');

  //whitespace
  root.Rules.Add.Include := '@whitespace';

  //delimiters and operators
  root.Rules.Add('[{}()\[\]]', '@brackets');
  root.Rules.Add('[<>](?!@symbols)', '@brackets');
  r := root.Rules.Add;
  r.Regex := '@symbols';
  r.Action.Cases.Add('@operators', 'operator');
  r.Action.Cases.Add('@default', '');

  //@annotations
  r := root.Rules.Add;
  r.Regex := '@\s*[a-zA-Z_\$][\w\$]*';
  r.Action.Token := 'annotation';
  r.Action.LogMessage := 'annotation token: $0';

  //numbers
  root.Rules.Add('\d*\.\d+([eE][\-+]?\d+)?', 'number.float');
  root.Rules.Add('0[xX][0-9a-fA-F]+', 'number.hex');
  root.Rules.Add('\d+', 'number');

  //delimiter
  root.Rules.Add('[;,.]', 'delimiter');

  //strings
  root.Rules.Add('"([^"\\]|\\.)*$', 'string.invalid');
  r := root.Rules.Add;
  r.Regex := '"';
  r.Action.Token := 'string.quote';
  r.Action.Bracket := lbkOpen;
  r.Action.Next := '@string';

  //characters
  root.Rules.Add('''[^\\'']''', 'string');
  r := root.Rules.Add;
  r.Regex := '('')(@escapes)('')';
  r.Action.Group.Add.Token := 'string';
  r.Action.Group.Add.Token := 'string.escape';
  r.Action.Group.Add.Token := 'string';
  root.Rules.Add('''', 'string.invalid');

  comment := TMSFNCMemoCustomLanguage1.Tokenizer.Add;
  comment.Name := 'comment';
  comment.Rules.Add('[^\/*]+', 'comment');
  comment.Rules.Add('\/\*', 'comment', '@push');
  comment.Rules.Add('\*\/', 'comment', '@pop');
  comment.Rules.Add('[\/*]', 'comment');

  str := TMSFNCMemoCustomLanguage1.Tokenizer.Add;
  str.Name := 'string';
  str.Rules.Add('[^\\"]+', 'string');
  str.Rules.Add('@escapes', 'string.escape');
  str.Rules.Add('\\.', 'string.invalid');
  r := str.Rules.Add;
  r.Regex := '"';
  r.Action.Token := 'string.quote';
  r.Action.Bracket := lbkClose;
  r.Action.Next := '@pop';

  whitespace := TMSFNCMemoCustomLanguage1.Tokenizer.Add;
  whitespace.Name := 'whitespace';
  whitespace.Rules.Add('[ \t\r\n]+', 'white');
  whitespace.Rules.Add('\/\*', 'comment', '@comment');
  whitespace.Rules.Add('\/\/.*$', 'comment');
end;

procedure TForm1.ApplyThemeSettings;
begin
  TMSFNCMemoCustomTheme1.ThemeName := 'mytheme';
  TMSFNCMemoCustomTheme1.Inherit := False;
  TMSFNCMemoCustomTheme1.Colors.EditorBackground := $2A211C;
  TMSFNCMemoCustomTheme1.Colors.EditorForeground := $F8F8F8;
  TMSFNCMemoCustomTheme1.Colors.EditorSelectionBackground := $83675A;
  TMSFNCMemoCustomTheme1.Colors.EditorLineNumberForeground := $E5C138;
  TMSFNCMemoCustomTheme1.Colors.EditorLineNumberActiveForeground := $229AE0;
  TMSFNCMemoCustomTheme1.Colors.EditorLineHighlightBackground := $4B3C34;
  TMSFNCMemoCustomTheme1.Rules.Add('comment', $229AE0);
  TMSFNCMemoCustomTheme1.Rules.Add('keyword', $DFAA06);
  TMSFNCMemoCustomTheme1.Rules.Add('operator', $DFAA06);
  TMSFNCMemoCustomTheme1.Rules.Add('annotation', $2E7C1F);
  TMSFNCMemoCustomTheme1.Rules.Add('number', $FF3A74);
  TMSFNCMemoCustomTheme1.Rules.Add('string', $55E434);
end;

end.
