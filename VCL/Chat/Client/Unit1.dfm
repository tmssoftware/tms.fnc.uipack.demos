object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Demo chat client'
  ClientHeight = 424
  ClientWidth = 618
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
  object TMSFNCChat1: TTMSFNCChat
    Left = 0
    Top = 41
    Width = 618
    Height = 383
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
    ExplicitWidth = 608
    ExplicitHeight = 365
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 618
    Height = 41
    Align = alTop
    TabOrder = 1
    ExplicitWidth = 608
    DesignSize = (
      618
      41)
    object Label1: TLabel
      Left = 12
      Top = 12
      Width = 35
      Height = 15
      Caption = 'Server:'
    end
    object Label2: TLabel
      Left = 183
      Top = 12
      Width = 25
      Height = 15
      Caption = 'Port:'
    end
    object Label3: TLabel
      Left = 289
      Top = 12
      Width = 35
      Height = 15
      Caption = 'Name:'
    end
    object Edit1: TEdit
      Left = 51
      Top = 9
      Width = 121
      Height = 23
      TabOrder = 0
      Text = 'localhost'
    end
    object Edit2: TEdit
      Left = 214
      Top = 9
      Width = 62
      Height = 23
      MaxLength = 4
      NumbersOnly = True
      TabOrder = 1
      Text = '8888'
    end
    object Button1: TButton
      Left = 528
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akLeft, akRight]
      Caption = 'Connect'
      TabOrder = 2
      OnClick = Button1Click
      ExplicitWidth = 65
    end
    object Edit3: TEdit
      Left = 329
      Top = 9
      Width = 121
      Height = 23
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
end
