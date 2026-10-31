object FormRendererSource: TFormRendererSource
  Width = 1100
  Height = 720
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
    Caption = 'DataGrid renderer source'
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
    Caption = 'Switch the grid between several data layers that share one renderer'
    Color = clBtnFace
    ElementID = 'description'
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
  end
  object Panel1: TTMSFNCPanel
    AlignWithMargins = True
    Left = 10
    Top = 10
    Width = 900
    Height = 56
    Margins.Left = 16
    Margins.Top = 0
    Margins.Right = 16
    Margins.Bottom = 12
    Align = alTop
    TabOrder = 0
    Header.Visible = False
    object btnSales: TTMSFNCButton
      Left = 12
      Top = 12
      Width = 140
      Height = 32
      Text = 'Sales by Region'
      TabOrder = 0
      OnClick = btnSalesClick
    end
    object btnInventory: TTMSFNCButton
      Left = 160
      Top = 12
      Width = 140
      Height = 32
      Text = 'Product Inventory'
      TabOrder = 1
      OnClick = btnInventoryClick
    end
    object btnDefault: TTMSFNCButton
      Left = 308
      Top = 12
      Width = 140
      Height = 32
      Text = 'Grid''s own layer'
      TabOrder = 2
      OnClick = btnDefaultClick
    end
    object btnAddRow: TTMSFNCButton
      Left = 456
      Top = 12
      Width = 190
      Height = 32
      Text = 'Add row to active layer'
      TabOrder = 3
      OnClick = btnAddRowClick
    end
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
  object lblStatus: TTMSFNCHTMLText
    AlignWithMargins = True
    Left = 10
    Top = 62
    Width = 900
    Height = 22
    Margins.Left = 16
    Margins.Top = 0
    Margins.Right = 16
    Margins.Bottom = 8
    Align = alTop
    Text = 'Active layer:'
    HorizontalTextAlign = gtaLeading
    Fill.Kind = gfkNone
    Stroke.Kind = gskNone
  end
  object TMSFNCDataGrid1: TTMSFNCDataGrid
    AlignWithMargins = True
    Left = 10
    Top = 89
    Width = 900
    Height = 461
    Margins.Left = 16
    Margins.Top = 0
    Margins.Right = 16
    Margins.Bottom = 16
    Align = alClient
    ParentDoubleBuffered = False
    DoubleBuffered = True
    TabOrder = 1
    Options.Mouse.ClickMargin = 0
  end
  object ThemeManager: TTMSFNCThemeManager
    Theme = 'Fluent Light'
    Left = 760
    Top = 160
  end
end
