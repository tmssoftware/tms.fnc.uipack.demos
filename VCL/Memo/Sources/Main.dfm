object Form1: TForm1
  Left = 0
  Top = 0
  ActiveControl = TMSFNCTabSet1
  Caption = 'TMS FNC UI Pack - Memo sources'
  ClientHeight = 700
  ClientWidth = 900
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  PixelsPerInch = 96
  TextHeight = 15
  object DemoHeader: TTMSFNCPanel
    Left = 0
    Top = 0
    Width = 938
    Height = 72
    Align = alTop
    TabOrder = 0
    Fill.Kind = gfkNone
    Stroke.Kind = gskNone
    Header.Visible = False
    object DemoThemeSelector: TTMSFNCThemeSelector
      AlignWithMargins = True
      Left = 754
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
      Width = 714
      Height = 30
      Anchors = [akLeft, akTop, akRight]
      Font.Height = -20
      Font.Name = 'Segoe UI Semibold'
      TabOrder = 1
      HorizontalTextAlign = gtaLeading
      Trimming = gttCharacter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Text = 'Source files'
    end
    object DemoDescription: TTMSFNCHTMLText
      Left = 24
      Top = 42
      Width = 714
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      TextRole = htrSecondary
      HorizontalTextAlign = gtaLeading
      Trimming = gttCharacter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Text = 'Open source files in tabs, load a file and save it back'
    end
  end
  object TMSFNCTabSet1: TTMSFNCTabSet
    Left = 0
    Top = 0
    Width = 625
    Height = 30
    Margins.Left = 16
    Margins.Top = 0
    Margins.Right = 16
    Margins.Bottom = 0
    Align = alTop
    ParentDoubleBuffered = False
    DoubleBuffered = True
    TabOrder = 0
    ActiveTabIndex = 1
    TabAppearance.Font.Charset = DEFAULT_CHARSET
    TabAppearance.Font.Height = -11
    TabAppearance.Font.Name = 'Segoe UI'
    TabAppearance.Font.Style = []
    TabAppearance.Fill.Color = 16578806
    TabAppearance.DownFill.Color = 15776936
    TabAppearance.DownStroke.Color = 15702829
    TabAppearance.HoverFill.Color = 16380654
    TabAppearance.HoverStroke.Color = 15702829
    TabAppearance.TextSpacing = 0.000000000000000000
    TabAppearance.ShapeOverlap = 18.000000000000000000
    TabAppearance.ShapeSlope = 16.500000000000000000
    TabAppearance.ShapeRounding = 7.500000000000000000
    TabAppearance.TextColor = 8026746
    TabAppearance.ActiveTextColor = 4539717
    TabAppearance.HoverTextColor = 8026746
    TabAppearance.DownTextColor = 4539717
    TabAppearance.ShowFocus = False
    TabAppearance.ProgressCircularSize = 22.500000000000000000
    TabAppearance.InsertSize = 30.000000000000000000
    TabAppearance.CloseSize = 21.000000000000000000
    TabAppearance.CloseStroke.Width = 2.000000000000000000
    TabAppearance.CloseDownStroke.Width = 2.000000000000000000
    TabAppearance.CloseHoverStroke.Width = 2.000000000000000000
    TabAppearance.BadgeFont.Charset = DEFAULT_CHARSET
    TabAppearance.BadgeFont.Color = 139
    TabAppearance.BadgeFont.Height = -11
    TabAppearance.BadgeFont.Name = 'Segoe UI'
    TabAppearance.BadgeFont.Style = [fsBold]
    ButtonAppearance.Rounding = 7.500000000000000000
    ButtonAppearance.Size = 30.000000000000000000
    ButtonAppearance.CloseIcon.Data = {
      0D544164765356474269746D6170EF0000003C7376672077696474683D223234
      707822206865696768743D2232347078222076696577426F783D223020302032
      342032342220786D6C6E733D22687474703A2F2F7777772E77332E6F72672F32
      3030302F737667222066696C6C3D226E6F6E65223E3C70617468207374726F6B
      653D2263757272656E74436F6C6F7222207374726F6B652D6C696E656361703D
      22726F756E6422207374726F6B652D6C696E656A6F696E3D22726F756E642220
      7374726F6B652D77696474683D22322220643D224D3132203132203720376D35
      2035203520356D2D352D3520352D356D2D3520352D352035222F3E3C2F737667
      3E}
    ButtonAppearance.InsertIcon.Data = {
      0D544164765356474269746D6170DF0200003C3F786D6C2076657273696F6E3D
      22312E302220656E636F64696E673D225554462D38223F3E0A3C73766720786D
      6C6E733D22687474703A2F2F7777772E77332E6F72672F323030302F73766722
      20786D6C6E733A786C696E6B3D22687474703A2F2F7777772E77332E6F72672F
      313939392F786C696E6B222077696474683D223234707822206865696768743D
      2232347078222076696577426F783D2230203020323420323422207665727369
      6F6E3D22312E31223E0A3C672069643D227375726661636531223E0A3C706174
      68207374796C653D22207374726F6B653A6E6F6E653B66696C6C2D72756C653A
      6E6F6E7A65726F3B66696C6C3A7267622830252C30252C3025293B66696C6C2D
      6F7061636974793A313B2220643D224D203132203620432031322E3431343036
      3220362031322E373520362E3333353933382031322E373520362E3735204C20
      31322E37352031312E3235204C2031372E32352031312E323520432031372E36
      36343036322031312E32352031382031312E3538353933382031382031322043
      2031382031322E3431343036322031372E3636343036322031322E3735203137
      2E32352031322E3735204C2031322E37352031322E3735204C2031322E373520
      31372E323520432031322E37352031372E3636343036322031322E3431343036
      3220313820313220313820432031312E3538353933382031382031312E323520
      31372E3636343036322031312E32352031372E3235204C2031312E3235203132
      2E3735204C20362E37352031322E3735204320362E3333353933382031322E37
      3520362031322E3431343036322036203132204320362031312E353835393338
      20362E3333353933382031312E323520362E37352031312E3235204C2031312E
      32352031312E3235204C2031312E323520362E373520432031312E323520362E
      3333353933382031312E35383539333820362031322036205A204D2031322036
      20222F3E0A3C2F673E0A3C2F7376673E0A}
    ButtonAppearance.TabListIcon.Data = {
      0D544164765356474269746D6170D90000003C7376672077696474683D223234
      707822206865696768743D2232347078222076696577426F783D223020302032
      342032342220786D6C6E733D22687474703A2F2F7777772E77332E6F72672F32
      3030302F737667223E3C70617468207374726F6B653D2263757272656E74436F
      6C6F7222207374726F6B652D6C696E656361703D22726F756E6422207374726F
      6B652D6C696E656A6F696E3D22726F756E6422207374726F6B652D7769647468
      3D22322220643D226D31372031302D3520352D352D35222066696C6C3D226E6F
      6E65222F3E3C2F7376673E}
    ButtonAppearance.ScrollNextIcon.Data = {
      0D544164765356474269746D6170D80000003C7376672077696474683D223234
      707822206865696768743D2232347078222076696577426F783D223020302032
      342032342220786D6C6E733D22687474703A2F2F7777772E77332E6F72672F32
      3030302F737667223E3C706174682066696C6C3D226E6F6E6522207374726F6B
      653D2263757272656E74436F6C6F7222207374726F6B652D6C696E656361703D
      22726F756E6422207374726F6B652D6C696E656A6F696E3D22726F756E642220
      7374726F6B652D77696474683D22322220643D226D31302037203520352D3520
      35222F3E3C2F7376673E}
    ButtonAppearance.ScrollPreviousIcon.Data = {
      0D544164765356474269746D6170D80000003C7376672077696474683D223234
      707822206865696768743D2232347078222076696577426F783D223020302032
      342032342220786D6C6E733D22687474703A2F2F7777772E77332E6F72672F32
      3030302F737667223E3C706174682066696C6C3D226E6F6E6522207374726F6B
      653D2263757272656E74436F6C6F7222207374726F6B652D6C696E656361703D
      22726F756E6422207374726F6B652D6C696E656A6F696E3D22726F756E642220
      7374726F6B652D77696474683D22322220643D226D313420372D352035203520
      35222F3E3C2F7376673E}
    Options.CloseMode = tcmTab
    Options.CloseAction = ttcaFree
    Options.InsertMode = timTab
    Tabs = <
      item
        Text = 'Tab 1'
        Bitmaps = <>
        DisabledBitmaps = <>
        UseDefaultAppearance = True
      end
      item
        Text = 'Tab 2'
        Bitmaps = <>
        DisabledBitmaps = <>
        UseDefaultAppearance = True
      end
      item
        Text = 'Tab 3'
        Bitmaps = <>
        DisabledBitmaps = <>
        UseDefaultAppearance = True
      end>
    TabSize.Height = 33.000000000000000000
    TabSize.Margins.Left = 12.000000000000000000
    TabSize.Margins.Top = 12.000000000000000000
    TabSize.Margins.Right = 12.000000000000000000
    TabSize.Margins.Bottom = 12.000000000000000000
    GlobalFont.Scale = 1.000000000000000000
    GlobalFont.Style = []
    OnCloseTab = TMSFNCTabSet1CloseTab
    OnChangeTab = TMSFNCTabSet1ChangeTab
    OnInsertTab = TMSFNCTabSet1InsertTab
    AlignWithMargins = True
  end
  object TMSFNCMemo1: TTMSFNCMemo
    Left = 0
    Top = 30
    Width = 625
    Height = 413
    Margins.Left = 16
    Margins.Top = 0
    Margins.Right = 16
    Margins.Bottom = 0
    Align = alClient
    ParentDoubleBuffered = False
    DoubleBuffered = True
    Font.Charset = DEFAULT_CHARSET
    Font.Height = -12
    Font.Name = 'Consolas'
    Font.Style = []
    TabOrder = 1
    Options.WordWrap = wwtOff
    Options.WordWrapColumn = 80
    CompletionList = <>
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
    object TMSFNCToolBar1: TTMSFNCToolBar
      Left = 0
      Top = 383
      Width = 625
      Height = 29
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 16
      Align = alBottom
      ParentDoubleBuffered = False
      DoubleBuffered = True
      Font.Charset = DEFAULT_CHARSET
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = []
      TabOrder = 0
      Appearance.HorizontalSpacing = 3.000000000000000000
      Appearance.VerticalSpacing = 3.000000000000000000
      CompactBitmaps = <>
      CompactWidth = 50.000000000000000000
      CompactBitmapSize = 24.000000000000000000
      Text = ''
      AlignWithMargins = True
      object TMSFNCToolBarButton1: TTMSFNCToolBarButton
        Left = 9
        Top = 3
        Width = 30
        Height = 24
        Margins.Left = 3
        Margins.Top = 3
        Margins.Right = 3
        Margins.Bottom = 3
        ParentDoubleBuffered = False
        DoubleBuffered = True
        Font.Charset = DEFAULT_CHARSET
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentColor = True
        TabOrder = 1
        OnClick = TMSFNCToolBarButton1Click
        DropDownHeight = 202.500000000000000000
        DropDownWidth = 202.500000000000000000
        Text = ''
        Bitmaps = <>
        LargeLayoutBitmaps = <>
        DisabledBitmaps = <>
        HoverBitmaps = <>
        LargeLayoutDisabledBitmaps = <>
        LargeLayoutHoverBitmaps = <>
        BitmapSize = 36.000000000000000000
        LargeLayoutBitmapSize = 48.000000000000000000
        ControlIndex = 0
      end
      object TMSFNCToolBarButton2: TTMSFNCToolBarButton
        Left = 41
        Top = 3
        Width = 30
        Height = 24
        Margins.Left = 3
        Margins.Top = 3
        Margins.Right = 3
        Margins.Bottom = 3
        ParentDoubleBuffered = False
        DoubleBuffered = True
        Font.Charset = DEFAULT_CHARSET
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentColor = True
        TabOrder = 2
        OnClick = TMSFNCToolBarButton2Click
        DropDownHeight = 202.500000000000000000
        DropDownWidth = 202.500000000000000000
        Text = ''
        Bitmaps = <>
        LargeLayoutBitmaps = <>
        DisabledBitmaps = <>
        HoverBitmaps = <>
        LargeLayoutDisabledBitmaps = <>
        LargeLayoutHoverBitmaps = <>
        BitmapSize = 36.000000000000000000
        LargeLayoutBitmapSize = 48.000000000000000000
        ControlIndex = 1
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 197
    Top = 144
  end
  object ThemeManager: TTMSFNCThemeManager
    Theme = 'Fluent Light'
    Left = 16
    Top = 16
  end
end
