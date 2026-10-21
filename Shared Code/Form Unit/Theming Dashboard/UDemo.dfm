object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'TMS FNC Theming Dashboard Demo'
  ClientHeight = 1277
  ClientWidth = 1440
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object TMSFNCThemeManager1: TTMSFNCThemeManager
    Left = 24
    Top = 24
    Theme = 'Fluent Light'
  end
end
