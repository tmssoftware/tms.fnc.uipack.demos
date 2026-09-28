object Form43: TForm43
  Width = 736
  Height = 622
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormContainer = 'appcontent'
  ParentFont = False
  OnCreate = WebFormCreate
  object WebLabel3: TWebLabel
    Left = 32
    Top = 552
    Width = 215
    Height = 13
    Caption = 'WebSocket based TTMSFNCChat client demo'
    ElementID = 'title'
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
  end
  object WebLabel4: TWebLabel
    Left = 32
    Top = 571
    Width = 151
    Height = 13
    Caption = 'Usage of TTMSFNCChat control'
    ElementID = 'description'
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
  end
  object WebPanel1: TWebPanel
    Left = 0
    Top = 0
    Width = 736
    Height = 50
    Align = alTop
    ChildOrder = 2
    object WebLabel1: TWebLabel
      AlignWithMargins = True
      Left = 326
      Top = 17
      Width = 31
      Height = 13
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 0
      Margins.Bottom = 10
      Caption = 'Name:'
      HeightPercent = 100.000000000000000000
      WidthPercent = 100.000000000000000000
    end
    object WebLabel2: TWebLabel
      Left = 16
      Top = 17
      Width = 36
      Height = 13
      Caption = 'Server:'
      HeightPercent = 100.000000000000000000
      WidthPercent = 100.000000000000000000
    end
    object WebLabel5: TWebLabel
      Left = 196
      Top = 17
      Width = 24
      Height = 13
      Caption = 'Port:'
      HeightPercent = 100.000000000000000000
      WidthPercent = 100.000000000000000000
    end
    object WebButton1: TWebButton
      AlignWithMargins = True
      Left = 630
      Top = 10
      Width = 96
      Height = 30
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alRight
      Caption = 'Connect'
      ChildOrder = 1
      HeightPercent = 100.000000000000000000
      WidthPercent = 100.000000000000000000
      OnClick = WebButton1Click
    end
    object WebEdit1: TWebEdit
      AlignWithMargins = True
      Left = 364
      Top = 10
      Width = 138
      Height = 30
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 0
      Margins.Bottom = 10
      ChildOrder = 2
      HeightPercent = 100.000000000000000000
      TabOrder = 1
      WidthPercent = 100.000000000000000000
    end
    object WebEdit2: TWebEdit
      AlignWithMargins = True
      Left = 58
      Top = 10
      Width = 121
      Height = 30
      Margins.Top = 10
      Margins.Bottom = 10
      ChildOrder = 5
      HeightPercent = 100.000000000000000000
      Text = 'localhost'
      WidthPercent = 100.000000000000000000
    end
    object WebEdit3: TWebEdit
      Left = 227
      Top = 10
      Width = 73
      Height = 30
      ChildOrder = 6
      EditType = weNumeric
      HeightPercent = 100.000000000000000000
      MaxLength = 4
      Text = '8888'
      WidthPercent = 100.000000000000000000
    end
  end
  object TMSFNCChat1: TTMSFNCChat
    Left = 0
    Top = 50
    Width = 736
    Height = 572
    Align = alClient
    ParentDoubleBuffered = False
    DoubleBuffered = True
    TabOrder = 1
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
  object WebSocketClient1: TWebSocketClient
    OnConnect = WebSocketClient1Connect
    OnDisconnect = WebSocketClient1Disconnect
    OnDataReceived = WebSocketClient1DataReceived
    Left = 176
    Top = 416
  end
end
