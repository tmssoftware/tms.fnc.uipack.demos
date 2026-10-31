object Form1: TForm1
  Width = 1100
  Height = 720
  Caption = 'TMS FNC UI Pack - PassLock'
  OnCreate = WebFormCreate
  OnShow = WebFormShow
  object DemoHeader: TTMSFNCPanel
    Left = 0
    Top = 0
    Width = 1100
    Height = 72
    Align = alTop
    TabOrder = 0
    Fill.Kind = gfkNone
    Stroke.Kind = gskNone
    Header.Visible = False
    object DemoThemeSelector: TTMSFNCThemeSelector
      AlignWithMargins = True
      Left = 916
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
      Width = 876
      Height = 30
      Anchors = [akLeft, akTop, akRight]
      Font.Height = -20
      Font.Name = 'Segoe UI Semibold'
      TabOrder = 1
      HorizontalTextAlign = gtaLeading
      Trimming = gttCharacter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Text = 'PassLock'
    end
    object DemoDescription: TTMSFNCHTMLText
      Left = 24
      Top = 42
      Width = 876
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      TextRole = htrSecondary
      HorizontalTextAlign = gtaLeading
      Trimming = gttCharacter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Text = 'Enter the code 1456, or try the options'
    end
  end
  object WebPanel3: TTMSFNCPanel
    Align = alLeft
    AlignWithMargins = True
    Margins.Left = 16
    Margins.Top = 0
    Margins.Right = 8
    Margins.Bottom = 16
    Width = 272
    Header.Visible = False
    object PLSecKeypad: TTMSFNCHTMLText
      Anchors = [akLeft, akTop, akRight]
      Left = 16
      Top = 12
      Width = 240
      Height = 24
      Font.Height = -17
      Font.Name = 'Segoe UI Semibold'
      Text = 'Keypad lock'
      HorizontalTextAlign = gtaLeading
      VerticalTextAlign = gtaCenter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object WebLabel6: TTMSFNCHTMLText
      Left = 16
      Top = 44
      Width = 112
      Height = 24
      Text = 'Password:'
      HorizontalTextAlign = gtaLeading
      VerticalTextAlign = gtaCenter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object LblpwVal: TTMSFNCHTMLText
      Anchors = [akLeft, akTop, akRight]
      Left = 128
      Top = 44
      Width = 128
      Height = 24
      HorizontalTextAlign = gtaTrailing
      VerticalTextAlign = gtaCenter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object WebLabel5: TTMSFNCHTMLText
      Left = 16
      Top = 72
      Width = 112
      Height = 24
      Text = 'Password entry:'
      HorizontalTextAlign = gtaLeading
      VerticalTextAlign = gtaCenter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object LblpwEntr: TTMSFNCHTMLText
      Anchors = [akLeft, akTop, akRight]
      Left = 128
      Top = 72
      Width = 128
      Height = 24
      HorizontalTextAlign = gtaTrailing
      VerticalTextAlign = gtaCenter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object PLStatusCaption: TTMSFNCHTMLText
      Left = 16
      Top = 100
      Width = 112
      Height = 24
      Text = 'Status:'
      HorizontalTextAlign = gtaLeading
      VerticalTextAlign = gtaCenter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object LblLearnMode: TTMSFNCHTMLText
      Anchors = [akLeft, akTop, akRight]
      Left = 128
      Top = 100
      Width = 128
      Height = 24
      HorizontalTextAlign = gtaTrailing
      VerticalTextAlign = gtaCenter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object WebCheckBox1: TTMSFNCCheckBox
      Anchors = [akLeft, akTop, akRight]
      Left = 16
      Top = 140
      Width = 240
      Height = 24
      Text = 'Show entry'
      Checked = True
      OnClick = WebCheckBox1Click
    end
    object WebCheckBox2: TTMSFNCCheckBox
      Anchors = [akLeft, akTop, akRight]
      Left = 16
      Top = 172
      Width = 240
      Height = 24
      Text = 'Show password length'
      Checked = True
      OnClick = WebCheckBox2Click
    end
    object WebCheckBox3: TTMSFNCCheckBox
      Anchors = [akLeft, akTop, akRight]
      Left = 16
      Top = 204
      Width = 240
      Height = 24
      Text = 'Show OK button'
      OnClick = WebCheckBox3Click
    end
    object WebCheckBox4: TTMSFNCCheckBox
      Anchors = [akLeft, akTop, akRight]
      Left = 16
      Top = 236
      Width = 240
      Height = 24
      Text = 'Show clear entry button'
      OnClick = WebCheckBox4Click
    end
    object WebCheckBox5: TTMSFNCCheckBox
      Anchors = [akLeft, akTop, akRight]
      Left = 16
      Top = 268
      Width = 240
      Height = 24
      Text = 'Enable key input'
      Checked = True
      OnClick = WebCheckBox5Click
    end
    object WebCheckBox6: TTMSFNCCheckBox
      Anchors = [akLeft, akTop, akRight]
      Left = 16
      Top = 300
      Width = 240
      Height = 24
      Text = 'Learn mode'
      OnClick = WebCheckBox6Click
    end
    object WebButton2: TTMSFNCButton
      Anchors = [akLeft, akTop, akRight]
      Left = 16
      Top = 344
      Width = 240
      Height = 32
      Text = 'Clear entry'
      OnClick = WebButton2Click
    end
    object PLSecPattern: TTMSFNCHTMLText
      Anchors = [akLeft, akTop, akRight]
      Left = 16
      Top = 396
      Width = 240
      Height = 24
      Font.Height = -17
      Font.Name = 'Segoe UI Semibold'
      Text = 'Pattern lock'
      HorizontalTextAlign = gtaLeading
      VerticalTextAlign = gtaCenter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object PLPatternHint: TTMSFNCHTMLText
      Anchors = [akLeft, akTop, akRight]
      Left = 16
      Top = 428
      Width = 240
      Height = 80
      Text = 'The pattern lock below covers a page of the application. Unlock it with the pattern of 1458, then press Show Lock Pattern to lock it again.'
      HorizontalTextAlign = gtaLeading
      VerticalTextAlign = gtaLeading
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      WordWrapping = True
      TextRole = htrSecondary
    end
    object WebButton1: TTMSFNCButton
      Anchors = [akLeft, akTop, akRight]
      Left = 16
      Top = 516
      Width = 240
      Height = 32
      Text = 'Show Lock Pattern'
      OnClick = WebButton1Click
    end
  end
  object ContentPanel: TTMSFNCPanel
    Align = alClient
    AlignWithMargins = True
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 16
    Margins.Bottom = 16
    Width = 788
    Height = 632
    Header.Visible = False
    Fill.Kind = gfkNone
    Stroke.Kind = gskNone
    object WebPanel1: TTMSFNCPanel
      Align = alTop
      Width = 788
      Height = 330
      Header.Visible = False
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      object TMSFNCPassLock2: TTMSFNCPassLock
        Align = alClient
        Width = 788
        Height = 330
        Fill.Kind = gfkNone
        PasswordValue = '1456'
        ButtonAppearance.MaxSize = 50.000000000000000000
        ButtonAppearance.PatternLine.Width = 6.000000000000000000
        ButtonAppearance.Spacing = 6.000000000000000000
        EntryAppearance.MaxSize = 10.000000000000000000
        EntryAppearance.Spacing = 6.000000000000000000
        Stroke.Kind = gskNone
        OnBeforeDrawEntry = TMSFNCPassLock2BeforeDrawEntry
        OnPasswordCheck = TMSFNCPassLock2PasswordCheck
        OnLearnPassword = TMSFNCPassLock2LearnPassword
        OnConfirmPassword = TMSFNCPassLock2ConfirmPassword
        OnPasswordEntryChanged = TMSFNCPassLock2PasswordEntryChanged
      end
      object TMSFNCImage1: TTMSFNCImage
        Anchors = [akLeft, akTop, akRight]
        Left = 180
        Top = 14
        Width = 428
        Height = 10
        Fill.Kind = gfkNone
        Bitmaps = <>
        Stroke.Kind = gskNone
      end
    end
    object TMSFNCSplitter1: TTMSFNCSplitter
      Align = alTop
      Height = 10
      MinSize = 20.000000000000000000
    end
    object WebPanel2: TTMSFNCPanel
      Align = alClient
      Header.Visible = False
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      object WebPanel4: TTMSFNCPanel
        Align = alLeft
        Width = 200
        Header.Visible = False
        object WebLabel1: TTMSFNCHTMLText
          Left = 16
          Top = 16
          Width = 168
          Height = 24
          Text = 'Top Left'
          HorizontalTextAlign = gtaLeading
          VerticalTextAlign = gtaCenter
          Fill.Kind = gfkNone
          Stroke.Kind = gskNone
        end
        object WebLabel2: TTMSFNCHTMLText
          Left = 16
          Top = 48
          Width = 168
          Height = 24
          Text = 'One Down'
          HorizontalTextAlign = gtaLeading
          VerticalTextAlign = gtaCenter
          Fill.Kind = gfkNone
          Stroke.Kind = gskNone
        end
        object WebLabel3: TTMSFNCHTMLText
          Left = 16
          Top = 80
          Width = 168
          Height = 24
          Text = 'One Right'
          HorizontalTextAlign = gtaLeading
          VerticalTextAlign = gtaCenter
          Fill.Kind = gfkNone
          Stroke.Kind = gskNone
        end
        object WebLabel4: TTMSFNCHTMLText
          Left = 16
          Top = 112
          Width = 168
          Height = 24
          Text = 'Another one Down'
          HorizontalTextAlign = gtaLeading
          VerticalTextAlign = gtaCenter
          Fill.Kind = gfkNone
          Stroke.Kind = gskNone
        end
      end
      object TMSFNCPassLock1: TTMSFNCPassLock
        Align = alClient
        Fill.Kind = gfkNone
        PasswordValue = '1458'
        ButtonAppearance.MaxSize = 50.000000000000000000
        ButtonAppearance.PatternLine.Width = 6.000000000000000000
        ButtonAppearance.Spacing = 6.000000000000000000
        EntryAppearance.MaxSize = 10.000000000000000000
        EntryAppearance.Spacing = 6.000000000000000000
        Options.LockType = pltPattern
        Stroke.Kind = gskNone
        OnPasswordCheck = TMSFNCPassLock1PasswordCheck
      end
    end
  end
  object ThemeManager: TTMSFNCThemeManager
    Theme = 'Fluent Light'
    Left = 24
    Top = 24
  end
end
