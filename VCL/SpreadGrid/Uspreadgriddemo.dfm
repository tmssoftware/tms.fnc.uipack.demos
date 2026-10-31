object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'TMS FNC UI Pack - Spreadsheet'
  ClientHeight = 680
  ClientWidth = 1100
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    889
    517)
  PixelsPerInch = 96
  TextHeight = 13
  object DemoHeader: TTMSFNCPanel
    Left = 0
    Top = 0
    Width = 889
    Height = 72
    Align = alTop
    TabOrder = 0
    Fill.Kind = gfkNone
    Stroke.Kind = gskNone
    Header.Visible = False
    object DemoThemeSelector: TTMSFNCThemeSelector
      AlignWithMargins = True
      Left = 705
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
      Width = 665
      Height = 30
      Anchors = [akLeft, akTop, akRight]
      Font.Height = -20
      Font.Name = 'Segoe UI Semibold'
      TabOrder = 1
      HorizontalTextAlign = gtaLeading
      Trimming = gttCharacter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Text = 'Spreadsheet'
    end
    object DemoDescription: TTMSFNCHTMLText
      Left = 24
      Top = 42
      Width = 665
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      TextRole = htrSecondary
      HorizontalTextAlign = gtaLeading
      Trimming = gttCharacter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Text = 'A spreadsheet grid with formulas, named cells and ranges, and file import'
    end
  end
  object SettingsPanel: TTMSFNCPanel
    AlignWithMargins = True
    Left = 16
    Top = 72
    Width = 260
    Height = 300
    Margins.Left = 16
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 16
    Align = alLeft
    TabOrder = 1
    Header.Visible = False
    object Button1: TTMSFNCButton
      Left = 16
      Top = 96
      Width = 228
      Height = 32
      Text = 'Clear'
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button2: TTMSFNCButton
      Left = 16
      Top = 136
      Width = 228
      Height = 32
      Text = 'File demo'
      TabOrder = 2
      OnClick = Button2Click
    end
    object Button3: TTMSFNCButton
      Left = 16
      Top = 56
      Width = 228
      Height = 32
      Text = 'Name demo'
      TabOrder = 3
      OnClick = Button3Click
    end
    object Button4: TTMSFNCButton
      Left = 16
      Top = 16
      Width = 228
      Height = 32
      Text = 'Range demo'
      TabOrder = 4
      OnClick = Button4Click
    end
    object ckShowFormula: TTMSFNCCheckBox
      Left = 16
      Top = 192
      Width = 228
      Height = 24
      Text = 'Show formulas'
      TabOrder = 5
      OnClick = ckShowFormulaClick
    end
    object ckNameMode: TTMSFNCCheckBox
      Left = 16
      Top = 224
      Width = 228
      Height = 24
      Text = 'RC cell name mode'
      TabOrder = 6
      OnClick = ckNameModeClick
    end
  end
  object Label1: TTMSFNCHTMLText
    AlignWithMargins = True
    Left = 16
    Top = 648
    Width = 1068
    Height = 24
    Margins.Left = 16
    Margins.Top = 0
    Margins.Right = 16
    Margins.Bottom = 8
    Align = alBottom
    HorizontalTextAlign = gtaLeading
    Fill.Kind = gfkNone
    Stroke.Kind = gskNone
    WordWrapping = False
  end
  object ThemeManager: TTMSFNCThemeManager
    Theme = 'Fluent Light'
    Left = 24
    Top = 24
  end
  object TMSFNCSpreadGrid1: TTMSFNCSpreadGrid
    Left = 292
    Top = 72
    Width = 792
    Height = 552
    ParentDoubleBuffered = False
    DoubleBuffered = True
    TabOrder = 0
    Options.Editing.CalcFormat = '%g'
    Options.Grouping.CalcFormat = '%g'
    Options.Grouping.GroupCountFormat = '(%d)'
    Options.IO.XMLEncoding = 'ISO-8859-1'
    Columns = <
      item
        BorderWidth = 1
        FixedFont.Charset = DEFAULT_CHARSET
        FixedFont.Color = clWindowText
        FixedFont.Height = -11
        FixedFont.Name = 'Tahoma'
        FixedFont.Style = []
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ID = ''
        Width = 68.000000000000000000
      end
      item
        BorderWidth = 1
        FixedFont.Charset = DEFAULT_CHARSET
        FixedFont.Color = clWindowText
        FixedFont.Height = -11
        FixedFont.Name = 'Tahoma'
        FixedFont.Style = []
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ID = ''
        Width = 68.000000000000000000
      end
      item
        BorderWidth = 1
        FixedFont.Charset = DEFAULT_CHARSET
        FixedFont.Color = clWindowText
        FixedFont.Height = -11
        FixedFont.Name = 'Tahoma'
        FixedFont.Style = []
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ID = ''
        Width = 68.000000000000000000
      end
      item
        BorderWidth = 1
        FixedFont.Charset = DEFAULT_CHARSET
        FixedFont.Color = clWindowText
        FixedFont.Height = -11
        FixedFont.Name = 'Tahoma'
        FixedFont.Style = []
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ID = ''
        Width = 68.000000000000000000
      end
      item
        BorderWidth = 1
        FixedFont.Charset = DEFAULT_CHARSET
        FixedFont.Color = clWindowText
        FixedFont.Height = -11
        FixedFont.Name = 'Tahoma'
        FixedFont.Style = []
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ID = ''
        Width = 68.000000000000000000
      end>
    TopRow = 1
    Appearance.FixedLayout.Font.Charset = DEFAULT_CHARSET
    Appearance.FixedLayout.Font.Height = -11
    Appearance.FixedLayout.Font.Name = 'Tahoma'
    Appearance.FixedLayout.Font.Style = [fsBold]
    Appearance.NormalLayout.Font.Charset = DEFAULT_CHARSET
    Appearance.NormalLayout.Font.Height = -11
    Appearance.NormalLayout.Font.Name = 'Tahoma'
    Appearance.NormalLayout.Font.Style = []
    Appearance.GroupLayout.Font.Charset = DEFAULT_CHARSET
    Appearance.GroupLayout.Font.Height = -11
    Appearance.GroupLayout.Font.Name = 'Tahoma'
    Appearance.GroupLayout.Font.Style = []
    Appearance.SummaryLayout.Font.Charset = DEFAULT_CHARSET
    Appearance.SummaryLayout.Font.Height = -11
    Appearance.SummaryLayout.Font.Name = 'Tahoma'
    Appearance.SummaryLayout.Font.Style = []
    Appearance.SelectedLayout.Font.Charset = DEFAULT_CHARSET
    Appearance.SelectedLayout.Font.Height = -11
    Appearance.SelectedLayout.Font.Name = 'Tahoma'
    Appearance.SelectedLayout.Font.Style = []
    Appearance.FocusedLayout.Font.Charset = DEFAULT_CHARSET
    Appearance.FocusedLayout.Font.Height = -11
    Appearance.FocusedLayout.Font.Name = 'Tahoma'
    Appearance.FocusedLayout.Font.Style = []
    Appearance.FixedSelectedLayout.Font.Charset = DEFAULT_CHARSET
    Appearance.FixedSelectedLayout.Font.Height = -11
    Appearance.FixedSelectedLayout.Font.Name = 'Tahoma'
    Appearance.FixedSelectedLayout.Font.Style = []
    Appearance.BandLayout.Font.Charset = DEFAULT_CHARSET
    Appearance.BandLayout.Font.Height = -11
    Appearance.BandLayout.Font.Name = 'Tahoma'
    Appearance.BandLayout.Font.Style = []
    Appearance.ProgressLayout.Format = '%.0f%%'
    LeftCol = 1
    ScrollMode = scmItemScrolling
    OnSelectCell = TMSFNCSpreadGrid1SelectCell
    FloatFormat = '%.2f'
    OnFormulaError = TMSFNCSpreadGrid1FormulaError
    OnIsCustomFunction = TMSFNCSpreadGrid1IsCustomFunction
    OnCalcCustomFunction = TMSFNCSpreadGrid1CalcCustomFunction
    AlignWithMargins = True
    Align = alClient
    Margins.Left = 16
    Margins.Top = 0
    Margins.Right = 16
    Margins.Bottom = 8
  end
end
