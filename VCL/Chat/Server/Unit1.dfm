object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Demo chat server'
  ClientHeight = 445
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
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 60
    Height = 15
    Caption = 'Server logs:'
  end
  object Memo1: TMemo
    Left = 8
    Top = 29
    Width = 612
    Height = 405
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
end
