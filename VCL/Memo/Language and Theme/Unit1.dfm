object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Memo Language and Theme Demo'
  ClientHeight = 400
  ClientWidth = 518
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
    ExplicitWidth = 494
    ExplicitHeight = 333
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
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 105
    Height = 22
    Caption = 'Add language'
    TabOrder = 2
    WordWrap = True
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 121
    Top = 8
    Width = 96
    Height = 22
    Caption = 'Add theme'
    TabOrder = 3
    WordWrap = True
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
