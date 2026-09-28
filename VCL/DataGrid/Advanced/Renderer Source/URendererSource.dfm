object FormRendererSource: TFormRendererSource
  Left = 0
  Top = 0
  Caption = 'TMS FNC Data Grid RendererSource Demo'
  ClientHeight = 560
  ClientWidth = 920
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object Panel1: TPanel
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
    TabOrder = 0
    object btnSales: TButton
      Left = 13
      Top = 12
      Width = 130
      Height = 24
      Caption = 'Sales by Region'
      TabOrder = 0
      OnClick = btnSalesClick
    end
    object btnInventory: TButton
      Left = 151
      Top = 12
      Width = 130
      Height = 24
      Caption = 'Product Inventory'
      TabOrder = 1
      OnClick = btnInventoryClick
    end
    object btnDefault: TButton
      Left = 289
      Top = 12
      Width = 130
      Height = 24
      Caption = 'Grid''s own layer'
      TabOrder = 2
      OnClick = btnDefaultClick
    end
    object btnAddRow: TButton
      Left = 451
      Top = 12
      Width = 170
      Height = 24
      Caption = 'Add row to active layer'
      TabOrder = 3
      OnClick = btnAddRowClick
    end
  end
  object lblStatus: TLabel
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
