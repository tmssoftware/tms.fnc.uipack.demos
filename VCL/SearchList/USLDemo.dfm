object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'TMS FNC UI Pack - SearchList'
  ClientHeight = 720
  ClientWidth = 1100
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
    Width = 852
    Height = 72
    Align = alTop
    TabOrder = 0
    Fill.Kind = gfkNone
    Stroke.Kind = gskNone
    Header.Visible = False
    object DemoThemeSelector: TTMSFNCThemeSelector
      AlignWithMargins = True
      Left = 668
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
      Width = 628
      Height = 30
      Anchors = [akLeft, akTop, akRight]
      Font.Height = -20
      Font.Name = 'Segoe UI Semibold'
      TabOrder = 1
      HorizontalTextAlign = gtaLeading
      Trimming = gttCharacter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Text = 'SearchList'
    end
    object DemoDescription: TTMSFNCHTMLText
      Left = 24
      Top = 42
      Width = 628
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      TextRole = htrSecondary
      HorizontalTextAlign = gtaLeading
      Trimming = gttCharacter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Text = 'Type to filter the lists, with a result limit and filtering on the description'
    end
  end
  object GroupBox1: TTMSFNCPanel
    Left = 8
    Top = 96
    Width = 330
    Height = 345
    TabOrder = 0
    Header.Text = 'Dictionary lookup'
    Header.Visible = True
    Header.Size = 24.000000000000000000
    Align = alLeft
    AlignWithMargins = True
    Margins.Left = 16
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 16
    object Edit1: TTMSFNCEdit
      Left = 16
      Top = 32
      Width = 298
      Height = 32
      TabOrder = 0
      OnChange = Edit1Change
      Anchors = [akLeft, akTop, akRight]
    end
    object ckSearchLimit: TTMSFNCCheckBox
      Left = 16
      Top = 546
      Width = 170
      Height = 24
      Text = 'Limit search results to:'
      TabOrder = 1
      OnClick = ckSearchLimitClick
      Anchors = [akLeft, akBottom]
    end
    object SpinEdit1: TTMSFNCSpinEdit
      Left = 214
      Top = 542
      Width = 100
      Height = 32
      Anchors = [akRight, akBottom]
      TabOrder = 4
      Max = 1000
      Min = 1
      Value = 10
    end
    object TMSFNCSearchList1: TTMSFNCSearchList
      Left = 16
      Top = 72
      Width = 298
      Height = 458
      HorzScrollBar.Tracking = True
      VertScrollBar.Range = 20
      VertScrollBar.Tracking = True
      ReadOnly = True
      TabOrder = 2
      Appearance.CategoryControlFont = False
      Appearance.CategoryFont.Charset = DEFAULT_CHARSET
      Appearance.CategoryFont.Color = clWindowText
      Appearance.CategoryFont.Height = -11
      Appearance.CategoryFont.Name = 'Tahoma'
      Appearance.CategoryFont.Style = []
      Appearance.DescriptionFont.Charset = DEFAULT_CHARSET
      Appearance.DescriptionFont.Color = clWindowText
      Appearance.DescriptionFont.Height = -11
      Appearance.DescriptionFont.Name = 'Tahoma'
      Appearance.DescriptionFont.Style = []
      Appearance.DescriptionControlFont = False
      Appearance.FilterCountFont.Charset = DEFAULT_CHARSET
      Appearance.FilterCountFont.Color = clWindowText
      Appearance.FilterCountFont.Height = -11
      Appearance.FilterCountFont.Name = 'Tahoma'
      Appearance.FilterCountFont.Style = []
      Appearance.FilterCountFormat = '(%d)'
      Appearance.ItemCategoryFont.Charset = DEFAULT_CHARSET
      Appearance.ItemCategoryFont.Color = 42495
      Appearance.ItemCategoryFont.Height = -11
      Appearance.ItemCategoryFont.Name = 'Tahoma'
      Appearance.ItemCategoryFont.Style = []
      Appearance.ItemCategoryFormat = 'in %s'
      FilterCondition.AutoSelect = False
      BorderColor = clNone
      Categories = <>
      Color = clWhite
      Columns = <
        item
          ControlFont = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
        end>
      Items = <>
      Version = '1.0.0.0'
      Anchors = [akLeft, akTop, akRight, akBottom]
    end
    object TMSFNCSearchEdit1: TTMSFNCSearchEdit
      Left = 16
      Top = 584
      Width = 298
      Height = 32
      ParentDoubleBuffered = False
      DoubleBuffered = True
      TabOrder = 3
      Appearance.CategoryControlFont = False
      Appearance.CategoryFont.Charset = DEFAULT_CHARSET
      Appearance.CategoryFont.Color = clWindowText
      Appearance.CategoryFont.Height = -11
      Appearance.CategoryFont.Name = 'Tahoma'
      Appearance.CategoryFont.Style = []
      Appearance.DescriptionFont.Charset = DEFAULT_CHARSET
      Appearance.DescriptionFont.Color = clWindowText
      Appearance.DescriptionFont.Height = -11
      Appearance.DescriptionFont.Name = 'Tahoma'
      Appearance.DescriptionFont.Style = []
      Appearance.DescriptionControlFont = False
      Appearance.FilterCountFont.Charset = DEFAULT_CHARSET
      Appearance.FilterCountFont.Color = clWindowText
      Appearance.FilterCountFont.Height = -11
      Appearance.FilterCountFont.Name = 'Tahoma'
      Appearance.FilterCountFont.Style = []
      Appearance.FilterCountFormat = '(%d)'
      Appearance.ItemCategoryFont.Charset = DEFAULT_CHARSET
      Appearance.ItemCategoryFont.Color = 42495
      Appearance.ItemCategoryFont.Height = -11
      Appearance.ItemCategoryFont.Name = 'Tahoma'
      Appearance.ItemCategoryFont.Style = []
      Appearance.ItemCategoryFormat = 'in %s'
      Categories = <>
      CategoryButton.Appearance.Rounding = 0.000000000000000000
      CategoryButton.Appearance.InnerStroke.Color = clWhite
      CategoryButton.Appearance.NormalFill.Kind = gfkGradient
      CategoryButton.Appearance.NormalFill.Color = 16579577
      CategoryButton.Appearance.NormalFill.ColorTo = 15461350
      CategoryButton.Appearance.NormalFill.ColorMirror = 15523036
      CategoryButton.Appearance.NormalFill.ColorMirrorTo = 15524316
      CategoryButton.Appearance.NormalStroke.Color = clGray
      CategoryButton.Appearance.HoverFill.Kind = gfkGradient
      CategoryButton.Appearance.HoverFill.Color = 15263717
      CategoryButton.Appearance.HoverFill.ColorTo = 14145490
      CategoryButton.Appearance.HoverFill.ColorMirror = 14207176
      CategoryButton.Appearance.HoverFill.ColorMirrorTo = 14208456
      CategoryButton.Appearance.HoverStroke.Color = clGray
      CategoryButton.Appearance.DownFill.Kind = gfkGradient
      CategoryButton.Appearance.DownFill.Color = 14605787
      CategoryButton.Appearance.DownFill.ColorTo = 13487560
      CategoryButton.Appearance.DownFill.ColorMirror = 13549246
      CategoryButton.Appearance.DownFill.ColorMirrorTo = 13550526
      CategoryButton.Appearance.DownStroke.Color = clGray
      CategoryButton.Appearance.DisabledStroke.Color = clGray
      CategoryButton.Bitmaps = <>
      CategoryButton.Visible = False
      Columns = <
        item
          ControlFont = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
        end>
      DropDownWidth = 250.000000000000000000
      EmptyText = 'Search ...'
      FilterCondition.AutoSelect = True
      ItemHeight = 20
      Items = <
        item
          CategoryID = 0
          Columns = <
            item
              Caption = 'Item A'
            end>
        end
        item
          CategoryID = 0
          Columns = <
            item
              Caption = 'Item B'
            end>
        end
        item
          CategoryID = 0
          Columns = <
            item
              Caption = 'Item C'
            end>
        end>
      SearchButton.Appearance.Rounding = 0.000000000000000000
      SearchButton.Appearance.InnerStroke.Color = clWhite
      SearchButton.Appearance.NormalFill.Kind = gfkGradient
      SearchButton.Appearance.NormalFill.Color = 16579577
      SearchButton.Appearance.NormalFill.ColorTo = 15461350
      SearchButton.Appearance.NormalFill.ColorMirror = 15523036
      SearchButton.Appearance.NormalFill.ColorMirrorTo = 15524316
      SearchButton.Appearance.NormalStroke.Color = clGray
      SearchButton.Appearance.HoverFill.Kind = gfkGradient
      SearchButton.Appearance.HoverFill.Color = 15263717
      SearchButton.Appearance.HoverFill.ColorTo = 14145490
      SearchButton.Appearance.HoverFill.ColorMirror = 14207176
      SearchButton.Appearance.HoverFill.ColorMirrorTo = 14208456
      SearchButton.Appearance.HoverStroke.Color = clGray
      SearchButton.Appearance.DownFill.Kind = gfkGradient
      SearchButton.Appearance.DownFill.Color = 14605787
      SearchButton.Appearance.DownFill.ColorTo = 13487560
      SearchButton.Appearance.DownFill.ColorMirror = 13549246
      SearchButton.Appearance.DownFill.ColorMirrorTo = 13550526
      SearchButton.Appearance.DownStroke.Color = clGray
      SearchButton.Appearance.DisabledStroke.Color = clGray
      SearchButton.Text = '...'
      SearchButton.Bitmaps = <>
      SearchButton.Visible = False
      Text = ''
      Anchors = [akLeft, akRight, akBottom]
    end
  end
  object GroupBox2: TTMSFNCPanel
    Left = 295
    Top = 96
    Width = 549
    Height = 345
    TabOrder = 2
    Header.Text = 'Car lookup'
    Header.Visible = True
    Header.Size = 24.000000000000000000
    Align = alClient
    AlignWithMargins = True
    Margins.Left = 16
    Margins.Top = 0
    Margins.Right = 16
    Margins.Bottom = 16
    object Edit2: TTMSFNCEdit
      Left = 16
      Top = 32
      Width = 250
      Height = 32
      TabOrder = 0
      OnChange = Edit2Change
      Anchors = [akLeft, akTop, akRight]
    end
    object ckDescr: TTMSFNCCheckBox
      Left = 282
      Top = 36
      Width = 190
      Height = 24
      Text = 'Filter also description'
      TabOrder = 1
      OnClick = ckDescrClick
    end
    object Panel1: TTMSFNCPanel
      Left = 674
      Top = 32
      Width = 32
      Height = 32
      TabOrder = 2
      OnClick = Panel1Click
      Header.Visible = False
      Anchors = [akTop, akRight]
      object Shape1: TShape
        Left = 0
        Top = 0
        Width = 32
        Height = 32
        Hint = 'Highlight color'
        Brush.Color = clRed
        Enabled = False
        ParentShowHint = False
        ShowHint = True
      end
    end
    object TMSFNCSearchList2: TTMSFNCSearchList
      Left = 16
      Top = 72
      Width = 456
      Height = 458
      HorzScrollBar.Tracking = True
      VertScrollBar.Range = 20
      VertScrollBar.Tracking = True
      ReadOnly = True
      TabOrder = 3
      Appearance.CategoryControlFont = False
      Appearance.CategoryFont.Charset = DEFAULT_CHARSET
      Appearance.CategoryFont.Color = clWindowText
      Appearance.CategoryFont.Height = -11
      Appearance.CategoryFont.Name = 'Tahoma'
      Appearance.CategoryFont.Style = []
      Appearance.DescriptionFont.Charset = DEFAULT_CHARSET
      Appearance.DescriptionFont.Color = clWindowText
      Appearance.DescriptionFont.Height = -11
      Appearance.DescriptionFont.Name = 'Tahoma'
      Appearance.DescriptionFont.Style = []
      Appearance.DescriptionControlFont = False
      Appearance.FilterCountFont.Charset = DEFAULT_CHARSET
      Appearance.FilterCountFont.Color = clWindowText
      Appearance.FilterCountFont.Height = -11
      Appearance.FilterCountFont.Name = 'Tahoma'
      Appearance.FilterCountFont.Style = []
      Appearance.FilterCountFormat = '(%d)'
      Appearance.ItemCategoryFont.Charset = DEFAULT_CHARSET
      Appearance.ItemCategoryFont.Color = 42495
      Appearance.ItemCategoryFont.Height = -11
      Appearance.ItemCategoryFont.Name = 'Tahoma'
      Appearance.ItemCategoryFont.Style = []
      Appearance.ItemCategoryFormat = 'in %s'
      FilterCondition.AutoSelect = False
      BorderColor = clNone
      Categories = <>
      Color = clWhite
      Columns = <
        item
          ControlFont = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
        end>
      Items = <>
      Version = '1.0.0.0'
      Anchors = [akLeft, akTop, akRight, akBottom]
    end
    object TMSFNCSearchEdit2: TTMSFNCSearchEdit
      Left = 16
      Top = 584
      Width = 690
      Height = 32
      ParentDoubleBuffered = False
      DoubleBuffered = True
      TabOrder = 4
      Appearance.CategoryControlFont = False
      Appearance.CategoryFont.Charset = DEFAULT_CHARSET
      Appearance.CategoryFont.Color = clWindowText
      Appearance.CategoryFont.Height = -11
      Appearance.CategoryFont.Name = 'Tahoma'
      Appearance.CategoryFont.Style = []
      Appearance.DescriptionFont.Charset = DEFAULT_CHARSET
      Appearance.DescriptionFont.Color = clWindowText
      Appearance.DescriptionFont.Height = -11
      Appearance.DescriptionFont.Name = 'Tahoma'
      Appearance.DescriptionFont.Style = []
      Appearance.DescriptionControlFont = False
      Appearance.FilterCountFont.Charset = DEFAULT_CHARSET
      Appearance.FilterCountFont.Color = clWindowText
      Appearance.FilterCountFont.Height = -11
      Appearance.FilterCountFont.Name = 'Tahoma'
      Appearance.FilterCountFont.Style = []
      Appearance.FilterCountFormat = '(%d)'
      Appearance.ItemCategoryFont.Charset = DEFAULT_CHARSET
      Appearance.ItemCategoryFont.Color = 42495
      Appearance.ItemCategoryFont.Height = -11
      Appearance.ItemCategoryFont.Name = 'Tahoma'
      Appearance.ItemCategoryFont.Style = []
      Appearance.ItemCategoryFormat = 'in %s'
      Categories = <>
      CategoryButton.Appearance.Rounding = 0.000000000000000000
      CategoryButton.Appearance.InnerStroke.Color = clWhite
      CategoryButton.Appearance.NormalFill.Kind = gfkGradient
      CategoryButton.Appearance.NormalFill.Color = 16579577
      CategoryButton.Appearance.NormalFill.ColorTo = 15461350
      CategoryButton.Appearance.NormalFill.ColorMirror = 15523036
      CategoryButton.Appearance.NormalFill.ColorMirrorTo = 15524316
      CategoryButton.Appearance.NormalStroke.Color = clGray
      CategoryButton.Appearance.HoverFill.Kind = gfkGradient
      CategoryButton.Appearance.HoverFill.Color = 15263717
      CategoryButton.Appearance.HoverFill.ColorTo = 14145490
      CategoryButton.Appearance.HoverFill.ColorMirror = 14207176
      CategoryButton.Appearance.HoverFill.ColorMirrorTo = 14208456
      CategoryButton.Appearance.HoverStroke.Color = clGray
      CategoryButton.Appearance.DownFill.Kind = gfkGradient
      CategoryButton.Appearance.DownFill.Color = 14605787
      CategoryButton.Appearance.DownFill.ColorTo = 13487560
      CategoryButton.Appearance.DownFill.ColorMirror = 13549246
      CategoryButton.Appearance.DownFill.ColorMirrorTo = 13550526
      CategoryButton.Appearance.DownStroke.Color = clGray
      CategoryButton.Appearance.DisabledStroke.Color = clGray
      CategoryButton.Bitmaps = <>
      CategoryButton.Visible = False
      Columns = <
        item
          ControlFont = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
        end>
      DropDownWidth = 250.000000000000000000
      EmptyText = 'Search ...'
      FilterCondition.AutoSelect = True
      ItemHeight = 20
      Items = <
        item
          CategoryID = 0
          Columns = <
            item
              Caption = 'Item A'
            end>
        end
        item
          CategoryID = 0
          Columns = <
            item
              Caption = 'Item B'
            end>
        end
        item
          CategoryID = 0
          Columns = <
            item
              Caption = 'Item C'
            end>
        end>
      SearchButton.Appearance.Rounding = 0.000000000000000000
      SearchButton.Appearance.InnerStroke.Color = clWhite
      SearchButton.Appearance.NormalFill.Kind = gfkGradient
      SearchButton.Appearance.NormalFill.Color = 16579577
      SearchButton.Appearance.NormalFill.ColorTo = 15461350
      SearchButton.Appearance.NormalFill.ColorMirror = 15523036
      SearchButton.Appearance.NormalFill.ColorMirrorTo = 15524316
      SearchButton.Appearance.NormalStroke.Color = clGray
      SearchButton.Appearance.HoverFill.Kind = gfkGradient
      SearchButton.Appearance.HoverFill.Color = 15263717
      SearchButton.Appearance.HoverFill.ColorTo = 14145490
      SearchButton.Appearance.HoverFill.ColorMirror = 14207176
      SearchButton.Appearance.HoverFill.ColorMirrorTo = 14208456
      SearchButton.Appearance.HoverStroke.Color = clGray
      SearchButton.Appearance.DownFill.Kind = gfkGradient
      SearchButton.Appearance.DownFill.Color = 14605787
      SearchButton.Appearance.DownFill.ColorTo = 13487560
      SearchButton.Appearance.DownFill.ColorMirror = 13549246
      SearchButton.Appearance.DownFill.ColorMirrorTo = 13550526
      SearchButton.Appearance.DownStroke.Color = clGray
      SearchButton.Appearance.DisabledStroke.Color = clGray
      SearchButton.Text = '...'
      SearchButton.Bitmaps = <>
      SearchButton.Visible = False
      Text = ''
      Anchors = [akLeft, akRight, akBottom]
    end
    object CheckListBox1: TTMSFNCCheckedListBox
      Left = 488
      Top = 72
      Width = 218
      Height = 458
      Anchors = [akTop, akRight, akBottom]
      TabOrder = 5
      OnItemCheckChanged = CheckListBox1ItemCheckChanged
    end
  end
  object ColorDialog1: TColorDialog
    Left = 768
    Top = 176
  end
  object ThemeManager: TTMSFNCThemeManager
    Theme = 'Fluent Light'
    Left = 24
    Top = 24
  end
end
