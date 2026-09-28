object Form1: TForm1
  Width = 518
  Height = 400
  Caption = 'Memo Language and Theme Demo'
  FormContainer = 'appcontent'
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
    Left = 8
    Top = 42
    Width = 500
    Height = 350
    ParentDoubleBuffered = False
    Anchors = [akLeft, akTop, akRight, akBottom]
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
  object Button1: TWebButton
    Left = 8
    Top = 8
    Width = 105
    Height = 22
    Caption = 'Add language'
    HeightPercent = 100.000000000000000000
    TabOrder = 2
    WidthPercent = 100.000000000000000000
    OnClick = Button1Click
  end
  object Button2: TWebButton
    Left = 121
    Top = 8
    Width = 96
    Height = 22
    Caption = 'Add theme'
    HeightPercent = 100.000000000000000000
    TabOrder = 3
    WidthPercent = 100.000000000000000000
    OnClick = Button2Click
  end
  object TMSFNCMemoCustomTheme1: TTMSFNCMemoCustomTheme
    Left = 400
    Top = 8
    Width = 26
    Height = 26
    Visible = True
    Rules = <>
  end
end
