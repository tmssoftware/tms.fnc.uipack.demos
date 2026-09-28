object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'TMSFNCSpreadGrid demo'
  ClientHeight = 517
  ClientWidth = 889
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
  object TMSFNCSpreadGrid1: TTMSFNCSpreadGrid
    Left = 8
    Top = 48
    Width = 873
    Height = 444
    Anchors = [akLeft, akTop, akRight, akBottom]
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
    Appearance.FixedLayout.Fill.Color = 15132390
    Appearance.FixedLayout.Font.Charset = DEFAULT_CHARSET
    Appearance.FixedLayout.Font.Color = clWindowText
    Appearance.FixedLayout.Font.Height = -11
    Appearance.FixedLayout.Font.Name = 'Tahoma'
    Appearance.FixedLayout.Font.Style = [fsBold]
    Appearance.NormalLayout.Fill.Color = -1
    Appearance.NormalLayout.Font.Charset = DEFAULT_CHARSET
    Appearance.NormalLayout.Font.Color = clWindowText
    Appearance.NormalLayout.Font.Height = -11
    Appearance.NormalLayout.Font.Name = 'Tahoma'
    Appearance.NormalLayout.Font.Style = []
    Appearance.GroupLayout.Fill.Color = 12817262
    Appearance.GroupLayout.Font.Charset = DEFAULT_CHARSET
    Appearance.GroupLayout.Font.Color = clWhite
    Appearance.GroupLayout.Font.Height = -11
    Appearance.GroupLayout.Font.Name = 'Tahoma'
    Appearance.GroupLayout.Font.Style = []
    Appearance.SummaryLayout.Fill.Color = 14009785
    Appearance.SummaryLayout.Font.Charset = DEFAULT_CHARSET
    Appearance.SummaryLayout.Font.Color = clWindowText
    Appearance.SummaryLayout.Font.Height = -11
    Appearance.SummaryLayout.Font.Name = 'Tahoma'
    Appearance.SummaryLayout.Font.Style = []
    Appearance.SelectedLayout.Fill.Color = 14599344
    Appearance.SelectedLayout.Font.Charset = DEFAULT_CHARSET
    Appearance.SelectedLayout.Font.Color = clWhite
    Appearance.SelectedLayout.Font.Height = -11
    Appearance.SelectedLayout.Font.Name = 'Tahoma'
    Appearance.SelectedLayout.Font.Style = []
    Appearance.FocusedLayout.Fill.Color = 14599344
    Appearance.FocusedLayout.Font.Charset = DEFAULT_CHARSET
    Appearance.FocusedLayout.Font.Color = clWhite
    Appearance.FocusedLayout.Font.Height = -11
    Appearance.FocusedLayout.Font.Name = 'Tahoma'
    Appearance.FocusedLayout.Font.Style = []
    Appearance.FixedSelectedLayout.Fill.Color = 14599344
    Appearance.FixedSelectedLayout.Font.Charset = DEFAULT_CHARSET
    Appearance.FixedSelectedLayout.Font.Color = clWindowText
    Appearance.FixedSelectedLayout.Font.Height = -11
    Appearance.FixedSelectedLayout.Font.Name = 'Tahoma'
    Appearance.FixedSelectedLayout.Font.Style = []
    Appearance.BandLayout.Fill.Color = 14745599
    Appearance.BandLayout.Font.Charset = DEFAULT_CHARSET
    Appearance.BandLayout.Font.Color = clWindowText
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
  end
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 81
    Height = 25
    Caption = 'Clear'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 95
    Top = 8
    Width = 81
    Height = 25
    Caption = 'File demo'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 184
    Top = 8
    Width = 81
    Height = 25
    Caption = 'Name demo'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 271
    Top = 8
    Width = 81
    Height = 25
    Caption = 'Range demo'
    TabOrder = 4
    OnClick = Button4Click
  end
  object ckShowFormula: TCheckBox
    Left = 408
    Top = 8
    Width = 97
    Height = 17
    Caption = 'Show formulas'
    TabOrder = 5
    OnClick = ckShowFormulaClick
  end
  object ckNameMode: TCheckBox
    Left = 536
    Top = 8
    Width = 145
    Height = 17
    Caption = 'RC cell name mode'
    TabOrder = 6
    OnClick = ckNameModeClick
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 498
    Width = 889
    Height = 19
    Panels = <>
    SimplePanel = True
    ExplicitLeft = 456
    ExplicitTop = 272
    ExplicitWidth = 0
  end
end
