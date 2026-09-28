object Form1: TForm1
  Width = 1107
  Height = 631
  Caption = 'TV Guide FNC Planner Demo'
  OnCreate = WebFormCreate
  OnShow = WebFormShow
  object WebPanel1: TWebPanel
    Left = 0
    Top = 0
    Width = 1107
    Height = 377
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
    Align = alTop
    BorderColor = clSilver
    BorderStyle = bsSingle
    ExplicitWidth = 1010
    DesignSize = (
      1107
      377)
    object WebPanel3: TWebPanel
      Left = 0
      Top = 0
      Width = 289
      Height = 377
      HeightPercent = 100.000000000000000000
      WidthPercent = 100.000000000000000000
      Align = alLeft
      BorderColor = clSilver
      BorderStyle = bsSingle
      object WebLabel5: TWebLabel
        Left = 40
        Top = 64
        Width = 79
        Height = 13
        Caption = 'Password Entry:'
        HeightPercent = 100.000000000000000000
        WidthPercent = 100.000000000000000000
      end
      object WebLabel6: TWebLabel
        Left = 40
        Top = 32
        Width = 50
        Height = 13
        Caption = 'Password:'
        HeightPercent = 100.000000000000000000
        WidthPercent = 100.000000000000000000
      end
      object LblpwVal: TWebLabel
        Left = 144
        Top = 32
        Width = 122
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        HeightPercent = 100.000000000000000000
        WidthPercent = 100.000000000000000000
      end
      object LblpwEntr: TWebLabel
        Left = 144
        Top = 64
        Width = 122
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        HeightPercent = 100.000000000000000000
        WidthPercent = 100.000000000000000000
      end
      object LblLearnMode: TWebLabel
        Left = 56
        Top = 272
        Width = 210
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        HeightPercent = 100.000000000000000000
        WidthPercent = 100.000000000000000000
      end
      object WebCheckBox1: TWebCheckBox
        Left = 40
        Top = 96
        Width = 201
        Height = 22
        Caption = 'Show Entry'
        Checked = True
        ChildOrder = 2
        Color = clNone
        HeightPercent = 100.000000000000000000
        State = cbChecked
        WidthPercent = 100.000000000000000000
        OnClick = WebCheckBox1Click
      end
      object WebCheckBox2: TWebCheckBox
        Left = 40
        Top = 124
        Width = 201
        Height = 22
        Caption = 'Show Password Length'
        Checked = True
        ChildOrder = 2
        Color = clNone
        HeightPercent = 100.000000000000000000
        State = cbChecked
        WidthPercent = 100.000000000000000000
        OnClick = WebCheckBox2Click
      end
      object WebCheckBox3: TWebCheckBox
        Left = 40
        Top = 152
        Width = 201
        Height = 22
        Caption = 'Show Ok Button'
        ChildOrder = 2
        Color = clNone
        HeightPercent = 100.000000000000000000
        State = cbUnchecked
        WidthPercent = 100.000000000000000000
        OnClick = WebCheckBox3Click
      end
      object WebCheckBox4: TWebCheckBox
        Left = 40
        Top = 180
        Width = 201
        Height = 22
        Caption = 'Show Clear Entry Button'
        ChildOrder = 2
        Color = clNone
        HeightPercent = 100.000000000000000000
        State = cbUnchecked
        WidthPercent = 100.000000000000000000
        OnClick = WebCheckBox4Click
      end
      object WebCheckBox5: TWebCheckBox
        Left = 40
        Top = 208
        Width = 201
        Height = 22
        Caption = 'Enable Key Input'
        Checked = True
        ChildOrder = 2
        Color = clNone
        HeightPercent = 100.000000000000000000
        State = cbChecked
        WidthPercent = 100.000000000000000000
        OnClick = WebCheckBox5Click
      end
      object WebButton2: TWebButton
        Left = 40
        Top = 312
        Width = 121
        Height = 25
        Caption = 'Clear Password Entry'
        ChildOrder = 7
        HeightPercent = 100.000000000000000000
        WidthPercent = 100.000000000000000000
        OnClick = WebButton2Click
      end
      object WebCheckBox6: TWebCheckBox
        Left = 40
        Top = 244
        Width = 201
        Height = 22
        Caption = 'Learn Mode'
        ChildOrder = 2
        Color = clNone
        HeightPercent = 100.000000000000000000
        State = cbUnchecked
        WidthPercent = 100.000000000000000000
        OnClick = WebCheckBox6Click
      end
    end
    object TMSFNCPassLock2: TTMSFNCPassLock
      Left = 289
      Top = 0
      Width = 818
      Height = 377
      Align = alClient
      ParentDoubleBuffered = False
      Color = clBtnFace
      DoubleBuffered = True
      TabOrder = 1
      Fill.Kind = gfkNone
      PasswordValue = '1456'
      ButtonAppearance.DownFill.Color = 16297243
      ButtonAppearance.DownFont.Charset = DEFAULT_CHARSET
      ButtonAppearance.DownFont.Color = clWhite
      ButtonAppearance.DownFont.Height = -11
      ButtonAppearance.DownFont.Name = 'Tahoma'
      ButtonAppearance.DownFont.Style = []
      ButtonAppearance.DownStroke.Color = clGray
      ButtonAppearance.HoverFill.Color = 13419707
      ButtonAppearance.HoverFont.Charset = DEFAULT_CHARSET
      ButtonAppearance.HoverFont.Color = clWindowText
      ButtonAppearance.HoverFont.Height = -11
      ButtonAppearance.HoverFont.Name = 'Tahoma'
      ButtonAppearance.HoverFont.Style = []
      ButtonAppearance.HoverStroke.Color = 10061943
      ButtonAppearance.Font.Charset = DEFAULT_CHARSET
      ButtonAppearance.Font.Color = clWindowText
      ButtonAppearance.Font.Height = -11
      ButtonAppearance.Font.Name = 'Tahoma'
      ButtonAppearance.Font.Style = []
      ButtonAppearance.MaxSize = 50.000000000000000000
      ButtonAppearance.PatternLine.Color = clGray
      ButtonAppearance.PatternLine.Width = 6.000000000000000000
      ButtonAppearance.Stroke.Color = 11119017
      ButtonAppearance.Spacing = 6.000000000000000000
      EntryAppearance.DownFill.Color = 16297243
      EntryAppearance.DownStroke.Color = clGray
      EntryAppearance.MaxSize = 10.000000000000000000
      EntryAppearance.Spacing = 6.000000000000000000
      EntryAppearance.Stroke.Color = 11119017
      Stroke.Kind = gskNone
      OnBeforeDrawEntry = TMSFNCPassLock2BeforeDrawEntry
      OnPasswordCheck = TMSFNCPassLock2PasswordCheck
      OnLearnPassword = TMSFNCPassLock2LearnPassword
      OnConfirmPassword = TMSFNCPassLock2ConfirmPassword
      OnPasswordEntryChanged = TMSFNCPassLock2PasswordEntryChanged
      ExplicitLeft = 456
      ExplicitTop = 56
      ExplicitWidth = 200
      ExplicitHeight = 270
    end
    object TMSFNCImage1: TTMSFNCImage
      Left = 528
      Top = 32
      Width = 337
      Height = 10
      ParentDoubleBuffered = False
      Anchors = [akLeft, akTop, akRight]
      Color = 13882323
      DoubleBuffered = True
      TabOrder = 2
      Bitmaps = <>
      Fill.Color = 13882323
      Stroke.Kind = gskNone
    end
  end
  object TMSFNCSplitter1: TTMSFNCSplitter
    Left = 0
    Top = 377
    Width = 1107
    Height = 10
    Cursor = crVSplit
    Align = alTop
    ParentDoubleBuffered = False
    DoubleBuffered = True
    TabOrder = 1
    Appearance.IndicatorDownFill.Color = 16297243
    Appearance.IndicatorDownStroke.Color = clGray
    Appearance.IndicatorHoverStroke.Color = clGray
    Appearance.IndicatorStroke.Color = clGray
    Appearance.SplitterDownFill.Color = 13156536
    Appearance.SplitterDownStroke.Color = 9470064
    Appearance.SplitterFill.Color = 15329769
    Appearance.SplitterHoverFill.Color = 13419707
    Appearance.SplitterHoverStroke.Color = 10061943
    Appearance.SplitterStroke.Color = 11119017
    MinSize = 20.000000000000000000
    ExplicitTop = 60
    ExplicitWidth = 10
  end
  object WebPanel2: TWebPanel
    Left = 0
    Top = 387
    Width = 1107
    Height = 244
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
    Align = alClient
    BorderColor = clSilver
    BorderStyle = bsSingle
    ChildOrder = 2
    ExplicitLeft = 8
    ExplicitTop = 148
    ExplicitWidth = 1010
    ExplicitHeight = 60
    DesignSize = (
      1107
      244)
    object WebPanel4: TWebPanel
      Left = 0
      Top = 0
      Width = 289
      Height = 244
      HeightPercent = 100.000000000000000000
      WidthPercent = 100.000000000000000000
      Align = alLeft
      BorderColor = clSilver
      BorderStyle = bsSingle
      ExplicitHeight = 319
      object WebLabel1: TWebLabel
        Left = 32
        Top = 24
        Width = 40
        Height = 13
        Caption = 'Top Left'
        HeightPercent = 100.000000000000000000
        WidthPercent = 100.000000000000000000
      end
      object WebLabel2: TWebLabel
        Left = 32
        Top = 56
        Width = 50
        Height = 13
        Caption = 'One Down'
        HeightPercent = 100.000000000000000000
        WidthPercent = 100.000000000000000000
      end
      object WebLabel3: TWebLabel
        Left = 32
        Top = 88
        Width = 48
        Height = 13
        Caption = 'One Right'
        HeightPercent = 100.000000000000000000
        WidthPercent = 100.000000000000000000
      end
      object WebLabel4: TWebLabel
        Left = 32
        Top = 120
        Width = 90
        Height = 13
        Caption = 'Another one Down'
        HeightPercent = 100.000000000000000000
        WidthPercent = 100.000000000000000000
      end
    end
    object WebButton1: TWebButton
      Left = 622
      Top = 105
      Width = 153
      Height = 40
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Show Pattern Lock'
      ChildOrder = 1
      HeightPercent = 100.000000000000000000
      WidthPercent = 100.000000000000000000
      OnClick = WebButton1Click
    end
    object TMSFNCPassLock1: TTMSFNCPassLock
      Left = 289
      Top = 0
      Width = 818
      Height = 244
      Align = alClient
      ParentDoubleBuffered = False
      Color = clBtnFace
      DoubleBuffered = True
      TabOrder = 2
      Fill.Kind = gfkNone
      PasswordValue = '1458'
      ButtonAppearance.DownFill.Color = 16297243
      ButtonAppearance.DownFont.Charset = DEFAULT_CHARSET
      ButtonAppearance.DownFont.Color = clWhite
      ButtonAppearance.DownFont.Height = -11
      ButtonAppearance.DownFont.Name = 'Tahoma'
      ButtonAppearance.DownFont.Style = []
      ButtonAppearance.DownStroke.Color = clGray
      ButtonAppearance.HoverFill.Color = 13419707
      ButtonAppearance.HoverFont.Charset = DEFAULT_CHARSET
      ButtonAppearance.HoverFont.Color = clWindowText
      ButtonAppearance.HoverFont.Height = -11
      ButtonAppearance.HoverFont.Name = 'Tahoma'
      ButtonAppearance.HoverFont.Style = []
      ButtonAppearance.HoverStroke.Color = 10061943
      ButtonAppearance.Font.Charset = DEFAULT_CHARSET
      ButtonAppearance.Font.Color = clWindowText
      ButtonAppearance.Font.Height = -11
      ButtonAppearance.Font.Name = 'Tahoma'
      ButtonAppearance.Font.Style = []
      ButtonAppearance.MaxSize = 50.000000000000000000
      ButtonAppearance.PatternLine.Color = clGray
      ButtonAppearance.PatternLine.Width = 6.000000000000000000
      ButtonAppearance.Stroke.Color = 11119017
      ButtonAppearance.Spacing = 6.000000000000000000
      EntryAppearance.DownFill.Color = 16297243
      EntryAppearance.DownStroke.Color = clGray
      EntryAppearance.MaxSize = 10.000000000000000000
      EntryAppearance.Spacing = 6.000000000000000000
      EntryAppearance.Stroke.Color = 11119017
      Options.LockType = pltPattern
      Stroke.Kind = gskNone
      OnPasswordCheck = TMSFNCPassLock1PasswordCheck
      ExplicitWidth = 721
      ExplicitHeight = 319
    end
  end
end
