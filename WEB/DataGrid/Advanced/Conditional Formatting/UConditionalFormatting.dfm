object frmConditionalFormatting: TfrmConditionalFormatting
  Width = 1180
  Height = 720
  Caption = 'TMS FNC UI Pack - Data Grid Conditional Formatting'
  OnCreate = WebFormCreate
  object Panel1: TTMSFNCPanel
    AlignWithMargins = True
    Left = 16
    Top = 0
    Width = 1100
    Height = 56
    Margins.Left = 16
    Margins.Top = 16
    Margins.Right = 16
    Margins.Bottom = 12
    Align = alTop
    TabOrder = 5
    Header.Visible = False
    object DemoThemeSelector: TTMSFNCThemeSelector
      AlignWithMargins = True
      Left = 1000
      Top = 10
      Width = 160
      Height = 36
      Margins.Left = 0
      Margins.Top = 10
      Margins.Right = 16
      Margins.Bottom = 10
      Align = alRight
      TabOrder = 20
      ThemeManager = ThemeManager
      Themes.Strings = (
        'Fluent Light=Light'
        'Fluent Dark=Dark')
    end
  end
  object ThemeManager: TTMSFNCThemeManager
    Theme = 'Fluent Light'
    Left = 760
    Top = 160
  end
end
