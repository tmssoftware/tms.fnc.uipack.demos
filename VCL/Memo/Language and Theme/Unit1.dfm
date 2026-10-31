object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'TMS FNC UI Pack - Memo languages and themes'
  ClientHeight = 640
  ClientWidth = 900
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  DesignSize = (
    518
    400)
  TextHeight = 15
  object DemoHeader: TTMSFNCPanel
    Left = 0
    Top = 0
    Width = 518
    Height = 72
    Align = alTop
    TabOrder = 0
    Fill.Kind = gfkNone
    Stroke.Kind = gskNone
    Header.Visible = False
    object DemoThemeSelector: TTMSFNCThemeSelector
      AlignWithMargins = True
      Left = 334
      Top = 18
      Width = 160
      Height = 36
      Margins.Left = 0
      Margins.Top = 18
      Margins.Right = 24
      Margins.Bottom = 18
      Align = alRight
      TabOrder = 0
      ThemeManager = ThemeManager
      Themes.Strings = (
        'Fluent Light=Light'
        'Fluent Dark=Dark')
    end
    object DemoTitle: TTMSFNCHTMLText
      Left = 24
      Top = 12
      Width = 294
      Height = 30
      Anchors = [akLeft, akTop, akRight]
      Font.Height = -20
      Font.Name = 'Segoe UI Semibold'
      TabOrder = 1
      HorizontalTextAlign = gtaLeading
      Trimming = gttCharacter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Text = 'Languages and themes'
    end
    object DemoDescription: TTMSFNCHTMLText
      Left = 24
      Top = 42
      Width = 294
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      TextRole = htrSecondary
      HorizontalTextAlign = gtaLeading
      Trimming = gttCharacter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Text = 'Add a custom language or a custom colour theme to the code editor'
    end
  end
  object TMSFNCMemo1: TTMSFNCMemo
    Left = 292
    Top = 72
    Width = 592
    Height = 552
    ParentDoubleBuffered = False
    DoubleBuffered = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Consolas'
    Font.Style = []
    TabOrder = 0
    Lines.Strings = (
      '// Type source code in your language here...'
      'class MyClass {'
      '  @attribute'
      '  void main() {'
      '    Console.writeln( "Hello Monarch world\n");'
      '  }'
      '}')
    Options.RenderLineHighlight = hlAll
    Options.RenderLineHighlightOnlyWhenFocus = True
    Options.WordWrap = wwtOff
    Options.WordWrapColumn = 80
    Options.BracketPairColorization = False
    CompletionList = <>
    CustomLanguages = <>
    CustomThemes = <>
    LanguageFileExtensionsMap = <
      item
        Language = mlBat
        Extension = '.bat'
      end
      item
        Language = mlCsharp
        Extension = '.cs'
      end
      item
        Language = mlCSS
        Extension = '.css'
      end
      item
        Language = mlHtml
        Extension = '.html'
      end
      item
        Language = mlJavascript
        Extension = '.js'
      end
      item
        Language = mlJSON
        Extension = '.json'
      end
      item
        Extension = '.pas'
      end
      item
        Extension = '.dpr'
      end
      item
        Extension = '.dfm'
      end
      item
        Extension = '.fmx'
      end
      item
        Extension = '.inc'
      end
      item
        Extension = '.dproj'
      end
      item
        Language = mlPlainText
        Extension = '.txt'
      end
      item
        Language = mlTypeScript
        Extension = '.ts'
      end
      item
        Language = mlXml
        Extension = '.xml'
      end>
    ActiveSource = -1
    Sources = <>
    AlignWithMargins = True
    Align = alClient
    Margins.Left = 16
    Margins.Top = 0
    Margins.Right = 16
    Margins.Bottom = 16
  end
  object TMSFNCMemoCustomLanguage1: TTMSFNCMemoCustomLanguage
    Left = 280
    Top = 80
    Width = 26
    Height = 26
    Visible = True
    Brackets = <>
    Tokenizer = <>
    ExtraKeys = <>
  end
  object SettingsPanel: TTMSFNCPanel
    AlignWithMargins = True
    Left = 16
    Top = 72
    Width = 260
    Height = 400
    Margins.Left = 16
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 16
    Align = alLeft
    TabOrder = 1
    Header.Visible = False
    object Button1: TTMSFNCButton
      Left = 16
      Top = 16
      Width = 228
      Height = 32
      Text = 'Add language'
      TabOrder = 2
      OnClick = Button1Click
    end
    object Button2: TTMSFNCButton
      Left = 16
      Top = 56
      Width = 228
      Height = 32
      Text = 'Add theme'
      TabOrder = 3
      OnClick = Button2Click
    end
  end
  object TMSFNCMemoCustomTheme1: TTMSFNCMemoCustomTheme
    Left = 400
    Top = 80
    Width = 26
    Height = 26
    Visible = True
    Rules = <>
  end
  object ThemeManager: TTMSFNCThemeManager
    Theme = 'Fluent Light'
    Left = 24
    Top = 24
  end
end
