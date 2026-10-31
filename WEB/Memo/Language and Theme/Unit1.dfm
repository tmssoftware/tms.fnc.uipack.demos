object Form1: TForm1
  Width = 900
  Height = 640
  Caption = 'TMS FNC UI Pack - Memo languages and themes'
  FormContainer = 'appcontent'
  object DemoBar: TTMSFNCPanel
    AlignWithMargins = True
    Left = 10
    Top = 10
    Width = 498
    Height = 48
    Margins.Left = 16
    Margins.Top = 16
    Margins.Right = 16
    Margins.Bottom = 12
    Align = alTop
    TabOrder = 0
    Header.Visible = False
    object DemoThemeSelector: TTMSFNCThemeSelector
      AlignWithMargins = True
      Left = 306
      Top = 6
      Width = 160
      Height = 36
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 16
      Margins.Bottom = 6
      Align = alRight
      TabOrder = 0
      ThemeManager = ThemeManager
      Themes.Strings = (
        'Fluent Light=Light'
        'Fluent Dark=Dark')
    end
  end
  object lblTitle: TWebLabel
    Left = 8
    Top = 8
    Width = 371
    Height = 25
    Caption = 'TTMSFNCMemo Custom Language and Theme'
    ElementID = 'title'
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
  end
  object lblDescription: TWebLabel
    Left = 8
    Top = 38
    Width = 619
    Height = 25
    Caption = 
      'This demo shows adding a custom language and theme to a TTMSFNCM' +
      'emo.'
    ElementID = 'description'
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
  end
  object TMSFNCMemo1: TTMSFNCMemo
    Left = 292
    Top = 74
    Width = 592
    Height = 550
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
    AlignWithMargins = True
    Align = alClient
    Margins.Left = 16
    Margins.Top = 0
    Margins.Right = 16
    Margins.Bottom = 16
    Sources = <>
  end
  object TMSFNCMemoCustomLanguage1: TTMSFNCMemoCustomLanguage
    Left = 280
    Top = 8
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
    Height = 100
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
    Top = 8
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
