object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'SearchList Demo'
  ClientHeight = 369
  ClientWidth = 852
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
  object GroupBox1: TGroupBox
    Left = 8
    Top = 24
    Width = 281
    Height = 337
    Caption = 'Dictionary lookup'
    TabOrder = 0
    object Edit1: TEdit
      Left = 15
      Top = 24
      Width = 121
      Height = 21
      TabOrder = 0
      OnChange = Edit1Change
    end
    object ckSearchLimit: TCheckBox
      Left = 15
      Top = 263
      Width = 130
      Height = 17
      Caption = 'Limit search results to:'
      TabOrder = 1
      OnClick = ckSearchLimitClick
    end
    object TMSFNCSearchList1: TTMSFNCSearchList
      Left = 15
      Top = 51
      Width = 250
      Height = 206
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
    end
    object TMSFNCSearchEdit1: TTMSFNCSearchEdit
      Left = 15
      Top = 299
      Width = 249
      Height = 23
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
    end
  end
  object SpinEdit1: TSpinEdit
    Left = 192
    Top = 287
    Width = 80
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 1
    Value = 10
  end
  object GroupBox2: TGroupBox
    Left = 295
    Top = 24
    Width = 549
    Height = 337
    Caption = 'Car lookup'
    TabOrder = 2
    object Edit2: TEdit
      Left = 16
      Top = 24
      Width = 121
      Height = 21
      TabOrder = 0
      OnChange = Edit2Change
    end
    object ckDescr: TCheckBox
      Left = 160
      Top = 26
      Width = 121
      Height = 17
      Caption = 'Filter also description'
      TabOrder = 1
      OnClick = ckDescrClick
    end
    object Panel1: TPanel
      Left = 368
      Top = 20
      Width = 25
      Height = 24
      TabOrder = 2
      OnClick = Panel1Click
      object Shape1: TShape
        Left = 0
        Top = 0
        Width = 25
        Height = 24
        Hint = 'Highlight color'
        Brush.Color = clRed
        Enabled = False
        ParentShowHint = False
        ShowHint = True
      end
    end
    object TMSFNCSearchList2: TTMSFNCSearchList
      Left = 16
      Top = 51
      Width = 377
      Height = 243
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
    end
    object TMSFNCSearchEdit2: TTMSFNCSearchEdit
      Left = 16
      Top = 300
      Width = 377
      Height = 23
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
    end
    object CheckListBox1: TCheckListBox
      Left = 408
      Top = 51
      Width = 129
      Height = 166
      OnClickCheck = CheckListBox1ClickCheck
      ItemHeight = 13
      TabOrder = 5
    end
  end
  object ColorDialog1: TColorDialog
    Left = 768
    Top = 176
  end
end
