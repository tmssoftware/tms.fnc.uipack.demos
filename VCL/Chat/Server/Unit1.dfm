object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'TMS FNC UI Pack - Chat server'
  ClientHeight = 517
  ClientWidth = 633
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    633
    445)
  TextHeight = 15
  object DemoHeader: TTMSFNCPanel
    Left = 0
    Top = 0
    Width = 633
    Height = 72
    Align = alTop
    TabOrder = 0
    Fill.Kind = gfkNone
    Stroke.Kind = gskNone
    Header.Visible = False
    object DemoThemeSelector: TTMSFNCThemeSelector
      AlignWithMargins = True
      Left = 449
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
      Width = 409
      Height = 30
      Anchors = [akLeft, akTop, akRight]
      Font.Height = -20
      Font.Name = 'Segoe UI Semibold'
      TabOrder = 1
      HorizontalTextAlign = gtaLeading
      Trimming = gttCharacter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Text = 'Chat server'
    end
    object DemoDescription: TTMSFNCHTMLText
      Left = 24
      Top = 42
      Width = 409
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      TextRole = htrSecondary
      HorizontalTextAlign = gtaLeading
      Trimming = gttCharacter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Text = 'Relays the messages of the connected chat clients and logs the traffic'
    end
  end
  object Label1: TTMSFNCHTMLText
    Left = 16
    Top = 80
    Width = 60
    Height = 15
    Text = 'Server logs:'
    HorizontalTextAlign = gtaLeading
    AutoSize = True
    Fill.Kind = gfkNone
    Stroke.Kind = gskNone
  end
  object Memo1: TMemo
    Left = 16
    Top = 104
    Width = 601
    Height = 397
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
  end
  object IdTCPServer1: TIdTCPServer
    Bindings = <>
    DefaultPort = 8888
    OnConnect = IdTCPServer1Connect
    OnDisconnect = IdTCPServer1Disconnect
    OnExecute = IdTCPServer1Execute
    Left = 328
    Top = 144
  end
  object ThemeManager: TTMSFNCThemeManager
    Theme = 'Fluent Light'
    Left = 24
    Top = 24
  end
end
