object FormRendererSource: TFormRendererSource
  Left = 0
  Top = 0
  Caption = 'TMS FNC Data Grid RendererSource Demo'
  ClientHeight = 720
  ClientWidth = 1100
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object DemoHeader: TTMSFNCPanel
    Left = 0
    Top = 0
    Width = 920
    Height = 72
    Align = alTop
    TabOrder = 0
    Fill.Kind = gfkNone
    Stroke.Kind = gskNone
    Header.Visible = False
    object DemoThemeSelector: TTMSFNCThemeSelector
      AlignWithMargins = True
      Left = 736
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
      Width = 696
      Height = 30
      Anchors = [akLeft, akTop, akRight]
      Font.Height = -20
      Font.Name = 'Segoe UI Semibold'
      TabOrder = 1
      HorizontalTextAlign = gtaLeading
      Trimming = gttCharacter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Text = 'DataGrid renderer source'
    end
    object DemoDescription: TTMSFNCHTMLText
      Left = 24
      Top = 42
      Width = 696
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      TextRole = htrSecondary
      HorizontalTextAlign = gtaLeading
      Trimming = gttCharacter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Text = 'Switch the grid between several data layers that share one renderer'
    end
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
    Left = 24
    Top = 24
  end
end
