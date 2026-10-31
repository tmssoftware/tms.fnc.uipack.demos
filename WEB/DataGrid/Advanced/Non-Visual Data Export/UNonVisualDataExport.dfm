object Form130: TForm130
  Width = 760
  Height = 220
  Caption = 'TMS FNC UI Pack - Data Grid Non-Visual Data Export'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormContainer = 'appcontent'
  ParentFont = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  object lblTitle: TWebLabel
    Left = 8
    Top = 8
    Width = 22
    Height = 15
    Caption = 'DataGrid data export'
    Color = clBtnFace
    ElementID = 'title'
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
  end
  object lblDescription: TWebLabel
    Left = 8
    Top = 38
    Width = 60
    Height = 15
    Caption = 'Export the data to CSV, HTML, XLS and PDF without the grid being shown'
    Color = clBtnFace
    ElementID = 'description'
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
  end
  object Button4: TTMSFNCButton
    AlignWithMargins = True
    Left = 5
    Top = 128
    Width = 427
    Height = 32
    Margins.Left = 16
    Margins.Top = 8
    Margins.Right = 16
    Align = alTop
    Text = 'Export to CSV'
    TabOrder = 1
    OnClick = Button4Click
    Margins.Bottom = 0
  end
  object Button3: TTMSFNCButton
    AlignWithMargins = True
    Left = 5
    Top = 168
    Width = 427
    Height = 32
    Margins.Left = 16
    Margins.Top = 8
    Margins.Right = 16
    Align = alTop
    Text = 'Export to HTML'
    TabOrder = 2
    OnClick = Button3Click
    Margins.Bottom = 16
  end
  object Button1: TTMSFNCButton
    AlignWithMargins = True
    Left = 5
    Top = 88
    Width = 427
    Height = 32
    Margins.Left = 16
    Margins.Top = 8
    Margins.Right = 16
    Align = alTop
    Text = 'Export to PDF'
    TabOrder = 3
    OnClick = Button1Click
    Margins.Bottom = 0
  end
  object TMSFNCDataGridPDFIO1: TTMSFNCDataGridPDFIO
    Left = 120
    Top = 62
    Width = 39
    Height = 39
    Visible = True
    Options.DefaultFont.Name = 'Arial'
    Options.Header = 'TMS PDF Header'
    Options.Footer = 'TMS PDF Footer'
    Options.Margins.Left = 20.000000000000000000
    Options.Margins.Top = 50.000000000000000000
    Options.Margins.Right = 20.000000000000000000
    Options.Margins.Bottom = 50.000000000000000000
    Options.HeaderFont.Name = 'Arial'
    Options.FooterFont.Name = 'Arial'
    Options.HeaderMargins.Left = 5.000000000000000000
    Options.HeaderMargins.Top = 5.000000000000000000
    Options.HeaderMargins.Right = 5.000000000000000000
    Options.HeaderMargins.Bottom = 5.000000000000000000
    Options.FooterMargins.Left = 5.000000000000000000
    Options.FooterMargins.Top = 5.000000000000000000
    Options.FooterMargins.Right = 5.000000000000000000
    Options.FooterMargins.Bottom = 5.000000000000000000
    Options.PageNumberMargins.Left = 10.000000000000000000
    Options.PageNumberMargins.Top = 5.000000000000000000
    Options.PageNumberMargins.Right = 10.000000000000000000
    Options.PageNumberMargins.Bottom = 5.000000000000000000
    Options.PageNumberFormat = '%d'
    Options.PageNumberFont.Name = 'Arial'
  end
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
