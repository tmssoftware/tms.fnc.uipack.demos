object Form130: TForm130
  Left = 0
  Top = 0
  Caption = 'TMS FNC UI Pack - Data Grid Non-Visual Data Export'
  ClientHeight = 248
  ClientWidth = 760
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object DemoHeader: TTMSFNCPanel
    Left = 0
    Top = 0
    Width = 437
    Height = 72
    Align = alTop
    TabOrder = 0
    Fill.Kind = gfkNone
    Stroke.Kind = gskNone
    Header.Visible = False
    object DemoThemeSelector: TTMSFNCThemeSelector
      AlignWithMargins = True
      Left = 253
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
      Width = 213
      Height = 30
      Anchors = [akLeft, akTop, akRight]
      Font.Height = -20
      Font.Name = 'Segoe UI Semibold'
      TabOrder = 1
      HorizontalTextAlign = gtaLeading
      Trimming = gttCharacter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Text = 'DataGrid data export'
    end
    object DemoDescription: TTMSFNCHTMLText
      Left = 24
      Top = 42
      Width = 213
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      TextRole = htrSecondary
      HorizontalTextAlign = gtaLeading
      Trimming = gttCharacter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Text = 'Export the data to CSV, HTML, XLS and PDF without the grid being shown'
    end
  end
  object Button4: TTMSFNCButton
    Left = 0
    Top = 48
    Width = 437
    Height = 32
    AlignWithMargins = True
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
    Left = 0
    Top = 88
    Width = 437
    Height = 32
    AlignWithMargins = True
    Margins.Left = 16
    Margins.Top = 8
    Margins.Right = 16
    Align = alTop
    Text = 'Export to HTML'
    TabOrder = 2
    OnClick = Button3Click
    Margins.Bottom = 0
  end
  object Button2: TTMSFNCButton
    Left = 0
    Top = 128
    Width = 437
    Height = 32
    AlignWithMargins = True
    Margins.Left = 16
    Margins.Top = 8
    Margins.Right = 16
    Align = alTop
    Text = 'Export to XLS'
    TabOrder = 0
    OnClick = Button2Click
    Margins.Bottom = 16
  end
  object Button1: TTMSFNCButton
    Left = 0
    Top = 8
    Width = 437
    Height = 32
    AlignWithMargins = True
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
    Left = 56
    Top = 174
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
  object TMSFNCDataGridExcelIO1: TTMSFNCDataGridExcelIO
    Left = 56
    Top = 208
    Width = 39
    Height = 39
    Visible = True
    Options.ExportOverwriteMessage = 'File %s already exists'#13'Ok to overwrite ?'
    UseUnicode = False
    Version = '3.24'
  end
  object ThemeManager: TTMSFNCThemeManager
    Theme = 'Fluent Light'
    Left = 24
    Top = 24
  end
end
