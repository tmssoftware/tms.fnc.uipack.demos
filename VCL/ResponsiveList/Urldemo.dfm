object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'TMS FNC UI Pack - ResponsiveList'
  ClientHeight = 640
  ClientWidth = 760
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object DemoHeader: TTMSFNCPanel
    Left = 0
    Top = 0
    Width = 274
    Height = 72
    Align = alTop
    TabOrder = 0
    Fill.Kind = gfkNone
    Stroke.Kind = gskNone
    Header.Visible = False
    object DemoThemeSelector: TTMSFNCThemeSelector
      AlignWithMargins = True
      Left = 90
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
      Width = 50
      Height = 30
      Anchors = [akLeft, akTop, akRight]
      Font.Height = -20
      Font.Name = 'Segoe UI Semibold'
      TabOrder = 1
      HorizontalTextAlign = gtaLeading
      Trimming = gttCharacter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Text = 'ResponsiveList'
    end
    object DemoDescription: TTMSFNCHTMLText
      Left = 24
      Top = 42
      Width = 50
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      TextRole = htrSecondary
      HorizontalTextAlign = gtaLeading
      Trimming = gttCharacter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Text = 'Resize the window: the number of columns follows its width'
    end
  end
  object TMSFNCResponsiveList1: TTMSFNCResponsiveList
    Left = 32
    Top = 111
    Width = 207
    Height = 361
    Cursor = crDefault
    HorzScrollBar.Range = 185
    HorzScrollBar.Tracking = True
    VertScrollBar.Range = 447
    VertScrollBar.Tracking = True
    ReadOnly = True
    TabOrder = 0
    BorderColor = clNone
    Conditions = <
      item
        Columns = 0
        HeightFrom = -1
        ItemHeight = 150
        WidthTo = 250
        Tag = 0
      end
      item
        Columns = 2
        HeightFrom = -1
        ItemHeight = 150
        WidthFrom = 250
        WidthTo = 500
        Tag = 0
      end
      item
        Columns = 3
        HeightFrom = -1
        ItemHeight = 150
        WidthFrom = 500
        WidthTo = 750
        Tag = 0
      end
      item
        Columns = 4
        HeightFrom = -1
        ItemHeight = 150
        WidthFrom = 750
        Tag = 0
      end>
    Items = <
      item
        Content = 'item 1'
        HeaderColor = 16436871
        Visible = True
        ControlName = ''
      end
      item
        Content = 'item 2'
        HeaderColor = 16436871
        Visible = True
        ControlName = ''
      end
      item
        Content = 'item 3'
        HeaderColor = 16436871
        Visible = True
        ControlName = ''
      end>
    Version = '1.2.0.0'
    Align = alClient
    AlignWithMargins = True
    Margins.Left = 16
    Margins.Top = 0
    Margins.Right = 16
    Margins.Bottom = 16
  end
  object ThemeManager: TTMSFNCThemeManager
    Theme = 'Fluent Light'
    Left = 24
    Top = 24
  end
end
