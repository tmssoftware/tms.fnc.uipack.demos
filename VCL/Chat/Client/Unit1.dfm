object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'TMS FNC UI Pack - Chat client'
  ClientHeight = 600
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 15
  ActiveControl = Edit1
  object DemoHeader: TTMSFNCPanel
    Left = 0
    Top = 0
    Width = 618
    Height = 72
    Align = alTop
    TabOrder = 0
    Fill.Kind = gfkNone
    Stroke.Kind = gskNone
    Header.Visible = False
    object DemoThemeSelector: TTMSFNCThemeSelector
      AlignWithMargins = True
      Left = 434
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
      Width = 394
      Height = 30
      Anchors = [akLeft, akTop, akRight]
      Font.Height = -20
      Font.Name = 'Segoe UI Semibold'
      TabOrder = 1
      HorizontalTextAlign = gtaLeading
      Trimming = gttCharacter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Text = 'Chat client'
    end
    object DemoDescription: TTMSFNCHTMLText
      Left = 24
      Top = 42
      Width = 394
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      TextRole = htrSecondary
      HorizontalTextAlign = gtaLeading
      Trimming = gttCharacter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Text = 'Connect to the chat server and exchange messages with other clients'
    end
  end
  object TMSFNCChat1: TTMSFNCChat
    Left = 292
    Top = 72
    Width = 492
    Height = 512
    Align = alClient
    ParentDoubleBuffered = False
    DoubleBuffered = True
    TabOrder = 0
    Appearance.TitleFont.Charset = DEFAULT_CHARSET
    Appearance.TitleFont.Color = clBlack
    Appearance.TitleFont.Height = -11
    Appearance.TitleFont.Name = 'Segoe UI'
    Appearance.TitleFont.Style = []
    Appearance.Spacing = 10.000000000000000000
    ChatMessages = <
      item
        SelectedFill.Color = 10526880
        SelectedStroke.Kind = gskNone
        Fill.Color = 16748574
        Stroke.Kind = gskNone
        MessageLocation = cmlRight
        Title = 'Me'
        TitleVerticalTextAlign = gtaCenter
        TitleColor = clWhite
        Text = 'Hi Tom! Are you free tomorrow?'
        VerticalTextAlign = gtaCenter
        TextColor = clWhite
      end
      item
        SelectedFill.Color = 10526880
        SelectedStroke.Kind = gskNone
        Fill.Color = 13882323
        Stroke.Kind = gskNone
        Title = 'Tom'
        TitleVerticalTextAlign = gtaCenter
        Text = 'Hi George! Unfortunately, no.'
        VerticalTextAlign = gtaCenter
      end
      item
        SelectedFill.Color = 10526880
        SelectedStroke.Kind = gskNone
        Fill.Color = 13882323
        Stroke.Kind = gskNone
        Title = 'Tom'
        TitleVerticalTextAlign = gtaCenter
        Text = 'I have an exam tomorrow afternoon.'
        VerticalTextAlign = gtaCenter
      end
      item
        SelectedFill.Color = 10526880
        SelectedStroke.Kind = gskNone
        Fill.Color = 16748574
        Stroke.Kind = gskNone
        MessageLocation = cmlRight
        Title = 'Me'
        TitleVerticalTextAlign = gtaCenter
        TitleColor = clWhite
        Text = 'Wow, good luck with that!'
        VerticalTextAlign = gtaCenter
        TextColor = clWhite
      end
      item
        SelectedFill.Color = 10526880
        SelectedStroke.Kind = gskNone
        Fill.Color = 13882323
        Stroke.Kind = gskNone
        Title = 'Tom'
        TitleVerticalTextAlign = gtaCenter
        Text = 'Thank you! We can meet up on Sunday afternoon if you are free'
        VerticalTextAlign = gtaCenter
      end
      item
        SelectedFill.Color = 10526880
        SelectedStroke.Kind = gskNone
        Fill.Color = 16748574
        Stroke.Kind = gskNone
        MessageLocation = cmlRight
        Title = 'Me'
        TitleVerticalTextAlign = gtaCenter
        TitleColor = clWhite
        Text = 'Sure, see you on Sunday then!'
        VerticalTextAlign = gtaCenter
        TextColor = clWhite
      end>
    Header.Visible = False
    Header.Text = 'Header'
    Header.Fill.Color = 16382457
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = 4539717
    Header.Font.Height = -13
    Header.Font.Name = 'Segoe UI'
    Header.Font.Style = [fsBold]
    Header.Stroke.Kind = gskNone
    Header.Stroke.Color = 11711154
    Header.Height = 30.000000000000000000
    Footer.Visible = False
    Footer.Text = 'Footer'
    Footer.Fill.Kind = gfkNone
    Footer.Fill.Color = 16382457
    Footer.Font.Charset = DEFAULT_CHARSET
    Footer.Font.Color = 4539717
    Footer.Font.Height = -11
    Footer.Font.Name = 'Segoe UI'
    Footer.Font.Style = []
    Footer.Stroke.Color = 11711154
    Footer.Height = 30.000000000000000000
    Stroke.Color = 13420488
    DefaultRightItem.SelectedFill.Color = 13005335
    DefaultRightItem.SelectedStroke.Kind = gskNone
    DefaultRightItem.Fill.Color = 16748574
    DefaultRightItem.Stroke.Kind = gskNone
    DefaultRightItem.TitleVerticalTextAlign = gtaCenter
    DefaultRightItem.TitleColor = clWhite
    DefaultRightItem.SelectedTitleColor = clWhite
    DefaultRightItem.VerticalTextAlign = gtaCenter
    DefaultRightItem.TextColor = clWhite
    DefaultRightItem.SelectedTextColor = clWhite
    DefaultLeftItem.SelectedFill.Color = 10526880
    DefaultLeftItem.SelectedStroke.Kind = gskNone
    DefaultLeftItem.Fill.Color = 13882323
    DefaultLeftItem.Stroke.Kind = gskNone
    DefaultLeftItem.TitleVerticalTextAlign = gtaCenter
    DefaultLeftItem.VerticalTextAlign = gtaCenter
    Reload.Stroke.Width = 2.000000000000000000
    MessageTimestamp.Font.Charset = DEFAULT_CHARSET
    MessageTimestamp.Font.Color = clWindowText
    MessageTimestamp.Font.Height = -11
    MessageTimestamp.Font.Name = 'Segoe UI'
    MessageTimestamp.Font.Style = []
    GlobalFont.Scale = 1.000000000000000000
    GlobalFont.Style = []
    OnAfterSendMessage = TMSFNCChat1SendMessage
    AlignWithMargins = True
    Margins.Left = 16
    Margins.Top = 0
    Margins.Right = 16
    Margins.Bottom = 16
  end
  object Panel1: TTMSFNCPanel
    Left = 16
    Top = 72
    Width = 260
    Height = 512
    Align = alLeft
    TabOrder = 1
    Header.Visible = False
    AlignWithMargins = True
    Margins.Left = 16
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 16
    object Label1: TTMSFNCHTMLText
      Left = 16
      Top = 8
      Width = 228
      Height = 20
      Text = 'Server:'
      HorizontalTextAlign = gtaLeading
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object Label2: TTMSFNCHTMLText
      Left = 16
      Top = 80
      Width = 228
      Height = 20
      Text = 'Port:'
      HorizontalTextAlign = gtaLeading
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object Label3: TTMSFNCHTMLText
      Left = 16
      Top = 152
      Width = 228
      Height = 20
      Text = 'Name:'
      HorizontalTextAlign = gtaLeading
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object Edit1: TTMSFNCEdit
      Left = 16
      Top = 32
      Width = 228
      Height = 32
      TabOrder = 0
      Text = 'localhost'
    end
    object Edit2: TTMSFNCEdit
      Left = 16
      Top = 104
      Width = 228
      Height = 32
      MaxLength = 4
      EditType = etNumeric
      TabOrder = 1
      Text = '8888'
    end
    object Button1: TTMSFNCButton
      Left = 16
      Top = 232
      Width = 228
      Height = 32
      Anchors = [akLeft, akTop]
      Text = 'Connect'
      TabOrder = 2
      OnClick = Button1Click
      Default = True
    end
    object Edit3: TTMSFNCEdit
      Left = 16
      Top = 176
      Width = 228
      Height = 32
      TabOrder = 3
    end
  end
  object IdTCPClient1: TIdTCPClient
    OnDisconnected = IdTCPClient1Disconnected
    OnConnected = IdTCPClient1Connected
    ConnectTimeout = 0
    Port = 0
    ReadTimeout = -1
    Left = 152
    Top = 292
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer1Timer
    Left = 436
    Top = 300
  end
  object ThemeManager: TTMSFNCThemeManager
    Theme = 'Fluent Light'
    Left = 24
    Top = 24
  end
end
