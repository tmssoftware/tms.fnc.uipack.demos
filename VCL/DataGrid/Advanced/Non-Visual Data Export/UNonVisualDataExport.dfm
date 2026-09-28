object Form130: TForm130
  Left = 0
  Top = 0
  Caption = 'TMS FNC Data Grid Non Visual Data Export Demo'
  ClientHeight = 202
  ClientWidth = 437
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
  object Button4: TButton
    Left = 0
    Top = 44
    Width = 437
    Height = 44
    AlignWithMargins = True
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Align = alTop
    Caption = 'Export to CSV'
    TabOrder = 1
    WordWrap = True
    OnClick = Button4Click
    ExplicitWidth = 427
  end
  object Button3: TButton
    Left = 0
    Top = 88
    Width = 437
    Height = 44
    AlignWithMargins = True
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Align = alTop
    Caption = 'Export to HTML'
    TabOrder = 2
    WordWrap = True
    OnClick = Button3Click
    ExplicitWidth = 427
  end
  object Button2: TButton
    Left = 0
    Top = 132
    Width = 437
    Height = 44
    AlignWithMargins = True
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Align = alTop
    Caption = 'Export to XLS'
    TabOrder = 0
    WordWrap = True
    OnClick = Button2Click
    ExplicitWidth = 427
  end
  object Button1: TButton
    Left = 0
    Top = 0
    Width = 437
    Height = 44
    AlignWithMargins = True
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Align = alTop
    Caption = 'Export to PDF'
    TabOrder = 3
    WordWrap = True
    OnClick = Button1Click
    ExplicitWidth = 427
  end
  object TMSFNCDataGridPDFIO1: TTMSFNCDataGridPDFIO
    Left = 56
    Top = 102
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
    Top = 136
    Width = 39
    Height = 39
    Visible = True
    Options.ExportOverwriteMessage = 'File %s already exists'#13'Ok to overwrite ?'
    UseUnicode = False
    Version = '3.24'
  end
end
