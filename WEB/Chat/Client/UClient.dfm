object Form43: TForm43
  Width = 800
  Height = 600
  Caption = 'TMS FNC UI Pack - Chat client'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormContainer = 'appcontent'
  ParentFont = False
  OnCreate = WebFormCreate
  object WebLabel3: TWebLabel
    Left = 8
    Top = 8
    Width = 215
    Height = 15
    Caption = 'WebSocket based TTMSFNCChat client demo'
    Color = clBtnFace
    ElementID = 'title'
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
  end
  object WebLabel4: TWebLabel
    Left = 8
    Top = 38
    Width = 151
    Height = 15
    Caption = 'Connect to the chat server and exchange messages with other clients'
    Color = clBtnFace
    ElementID = 'description'
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
  end
  object DemoBar: TTMSFNCPanel
    AlignWithMargins = True
    Left = 10
    Top = 10
    Width = 780
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
      Left = 600
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
  object WebPanel1: TTMSFNCPanel
    AlignWithMargins = True
    Left = 16
    Top = 74
    Width = 260
    Height = 510
    Margins.Left = 16
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 16
    Align = alLeft
    TabOrder = 1
    Header.Visible = False
    object WebLabel2: TTMSFNCHTMLText
      Left = 16
      Top = 8
      Width = 228
      Height = 20
      Text = 'Server'
      WordWrapping = False
      HorizontalTextAlign = gtaLeading
      AutoSize = False
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object WebEdit2: TTMSFNCEdit
      Left = 16
      Top = 32
      Width = 228
      Height = 32
      TabOrder = 0
      Text = 'localhost'
    end
    object WebLabel5: TTMSFNCHTMLText
      Left = 16
      Top = 80
      Width = 228
      Height = 20
      Text = 'Port'
      WordWrapping = False
      HorizontalTextAlign = gtaLeading
      AutoSize = False
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object WebEdit3: TTMSFNCEdit
      Left = 16
      Top = 104
      Width = 228
      Height = 32
      MaxLength = 4
      TabOrder = 1
      Text = '8888'
    end
    object WebLabel1: TTMSFNCHTMLText
      Left = 16
      Top = 152
      Width = 228
      Height = 20
      Text = 'Name'
      WordWrapping = False
      HorizontalTextAlign = gtaLeading
      AutoSize = False
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object WebEdit1: TTMSFNCEdit
      Left = 16
      Top = 176
      Width = 228
      Height = 32
      TabOrder = 2
    end
    object WebButton1: TTMSFNCButton
      Left = 16
      Top = 232
      Width = 228
      Height = 32
      Text = 'Connect'
      Default = True
      TabOrder = 3
      OnClick = WebButton1Click
    end
  end
  object TMSFNCChat1: TTMSFNCChat
    AlignWithMargins = True
    Left = 292
    Top = 74
    Width = 492
    Height = 510
    Margins.Left = 16
    Margins.Top = 0
    Margins.Right = 16
    Margins.Bottom = 16
    Align = alClient
    ParentDoubleBuffered = False
    DoubleBuffered = True
    TabOrder = 2
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
  end
  object ThemeManager: TTMSFNCThemeManager
    Theme = 'Fluent Light'
    Left = 24
    Top = 24
  end
  object WebSocketClient1: TWebSocketClient
    OnConnect = WebSocketClient1Connect
    OnDisconnect = WebSocketClient1Disconnect
    OnDataReceived = WebSocketClient1DataReceived
    Left = 176
    Top = 416
  end
end
