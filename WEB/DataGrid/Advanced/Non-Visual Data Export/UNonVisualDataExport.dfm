object Form130: TForm130
  Width = 437
  Height = 160
  Caption = 'TMS FNC Data Grid Non Visual Data Export Demo'
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
    Caption = 'Title'
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
    Caption = 'Description'
    Color = clBtnFace
    ElementID = 'description'
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
  end
  object Button4: TWebButton
    AlignWithMargins = True
    Left = 5
    Top = 57
    Width = 427
    Height = 44
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Align = alTop
    Caption = 'Export to CSV'
    HeightPercent = 100.000000000000000000
    TabOrder = 1
    WidthPercent = 100.000000000000000000
    OnClick = Button4Click
  end
  object Button3: TWebButton
    AlignWithMargins = True
    Left = 5
    Top = 109
    Width = 427
    Height = 44
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Align = alTop
    Caption = 'Export to HTML'
    HeightPercent = 100.000000000000000000
    TabOrder = 2
    WidthPercent = 100.000000000000000000
    OnClick = Button3Click
  end
  object Button1: TWebButton
    AlignWithMargins = True
    Left = 5
    Top = 5
    Width = 427
    Height = 44
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Align = alTop
    Caption = 'Export to PDF'
    HeightPercent = 100.000000000000000000
    TabOrder = 3
    WidthPercent = 100.000000000000000000
    OnClick = Button1Click
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
end
