object FormRendererSource: TFormRendererSource
  Width = 920
  Height = 560
  Caption = 'TMS FNC Data Grid RendererSource Demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormContainer = 'appcontent'
  ParentFont = False
  OnCreate = FormCreate
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
  object Panel1: TWebPanel
    AlignWithMargins = True
    Left = 10
    Top = 10
    Width = 900
    Height = 47
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 5
    Align = alTop
    BorderColor = clSilver
    BorderStyle = bsSingle
    ChildOrder = 1
    TabOrder = 0
    object btnSales: TWebButton
      Left = 13
      Top = 12
      Width = 130
      Height = 24
      Caption = 'Sales by Region'
      ChildOrder = 1
      TabOrder = 0
      OnClick = btnSalesClick
    end
    object btnInventory: TWebButton
      Left = 151
      Top = 12
      Width = 130
      Height = 24
      Caption = 'Product Inventory'
      ChildOrder = 2
      TabOrder = 1
      OnClick = btnInventoryClick
    end
    object btnDefault: TWebButton
      Left = 289
      Top = 12
      Width = 130
      Height = 24
      Caption = 'Grid''s own layer'
      ChildOrder = 3
      TabOrder = 2
      OnClick = btnDefaultClick
    end
    object btnAddRow: TWebButton
      Left = 451
      Top = 12
      Width = 170
      Height = 24
      Caption = 'Add row to active layer'
      ChildOrder = 4
      TabOrder = 3
      OnClick = btnAddRowClick
    end
  end
  object lblStatus: TWebLabel
    AlignWithMargins = True
    Left = 10
    Top = 62
    Width = 900
    Height = 22
    Margins.Left = 10
    Margins.Top = 0
    Margins.Right = 10
    Margins.Bottom = 5
    Align = alTop
    Caption = 'Active layer:'
    ChildOrder = 2
    Color = clBtnFace
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
  end
  object TMSFNCDataGrid1: TTMSFNCDataGrid
    AlignWithMargins = True
    Left = 10
    Top = 89
    Width = 900
    Height = 461
    Margins.Left = 10
    Margins.Top = 0
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alClient
    ParentDoubleBuffered = False
    DoubleBuffered = True
    TabOrder = 1
    Options.Mouse.ClickMargin = 0
    Stroke.Color = clDarkgray
  end
end
