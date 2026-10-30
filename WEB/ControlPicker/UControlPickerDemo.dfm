object Form1: TForm1
  Width = 640
  Height = 600
  Caption = 'TMS FNC UI Pack - ControlPicker'
  OnCreate = WebFormCreate
  object DemoHeader: TTMSFNCPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 72
    Align = alTop
    TabOrder = 0
    Fill.Kind = gfkNone
    Stroke.Kind = gskNone
    Header.Visible = False
    object DemoThemeSelector: TTMSFNCThemeSelector
      AlignWithMargins = True
      Left = 616
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
      Width = 576
      Height = 30
      Anchors = [akLeft, akTop, akRight]
      Font.Height = -20
      Font.Name = 'Segoe UI Semibold'
      TabOrder = 1
      HorizontalTextAlign = gtaLeading
      Trimming = gttCharacter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Text = 'ControlPicker'
    end
    object DemoDescription: TTMSFNCHTMLText
      Left = 24
      Top = 42
      Width = 576
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      TextRole = htrSecondary
      HorizontalTextAlign = gtaLeading
      Trimming = gttCharacter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Text = 'Pick values from any control: a tree view, a list editor, a native list box or a button'
    end
  end
  object TMSFNCControlPicker1: TTMSFNCControlPicker
    Left = 24
    Top = 112
    Width = 240
    Height = 32
    ParentDoubleBuffered = False
    DoubleBuffered = True
    Font.Color = clWindowText
    Font.Height = -11
    Font.Style = []
    TabOrder = 0
    Control = TMSFNCTreeView1
    DropDownControlHeight = 150.000000000000000000
    DropDownControlWidth = 150.000000000000000000
    DropDownHeightMode = chmControl
    DropDownWidthMode = cwmControl
    ItemHeight = 25.000000000000000000
    ItemWidth = 100.000000000000000000
    Text = 'TTMSFNCControlPicker'
  end
  object TMSFNCControlPicker2: TTMSFNCControlPicker
    Left = 24
    Top = 192
    Width = 240
    Height = 32
    ParentDoubleBuffered = False
    DoubleBuffered = True
    Font.Color = clWindowText
    Font.Height = -11
    Font.Style = []
    TabOrder = 1
    Control = TMSFNCListEditor1
    DropDownControlHeight = 150.000000000000000000
    DropDownControlWidth = 150.000000000000000000
    Text = 'TTMSFNCControlPicker'
  end
  object TMSFNCControlPicker3: TTMSFNCControlPicker
    Left = 336
    Top = 112
    Width = 240
    Height = 32
    ParentDoubleBuffered = False
    DoubleBuffered = True
    Font.Color = clWindowText
    Font.Height = -11
    Font.Style = []
    TabOrder = 2
    Control = WebListBox1
    DropDownControlHeight = 150.000000000000000000
    DropDownControlWidth = 150.000000000000000000
    Text = 'TTMSFNCControlPicker'
    OnAdjustDropDownHeight = TMSFNCControlPicker3AdjustDropDownHeight
    OnSetContent = TMSFNCControlPicker3SetContent
  end
  object TMSFNCControlPicker4: TTMSFNCControlPicker
    Left = 336
    Top = 192
    Width = 240
    Height = 32
    ParentDoubleBuffered = False
    DoubleBuffered = True
    Font.Color = clWindowText
    Font.Height = -11
    Font.Style = []
    TabOrder = 3
    DropDownControlHeight = 150.000000000000000000
    DropDownControlWidth = 150.000000000000000000
    DropDownHeightMode = chmControl
    Text = 'TTMSFNCControlPicker'
  end
  object TMSFNCTreeView1: TTMSFNCTreeView
    Left = 24
    Top = 256
    Width = 288
    Height = 236
    ParentDoubleBuffered = False
    DoubleBuffered = True
    TabOrder = 4
    Groups = <>
    GroupsAppearance.TopSize = 50.000000000000000000
    GroupsAppearance.BottomSize = 50.000000000000000000
    GroupsAppearance.TopFont.Color = clBlack
    GroupsAppearance.TopFont.Height = -11
    GroupsAppearance.TopFont.Style = []
    GroupsAppearance.BottomFont.Color = clBlack
    GroupsAppearance.BottomFont.Height = -11
    GroupsAppearance.BottomFont.Style = []
    GroupsAppearance.TopStroke.Color = 11119017
    GroupsAppearance.BottomStroke.Color = 11119017
    ColumnStroke.Color = -1
    Columns = <
      item
        Name = 'Column0'
        Text = 'Model'
        Width = 100.000000000000000000
        Fill.Color = -1
        Stroke.Color = 11119017
        Font.Color = clWindowText
        Font.Height = -11
        Font.Style = []
        TopFill.Kind = gfkNone
        TopStroke.Color = 11119017
        TopFont.Color = clWindowText
        TopFont.Height = -11
        TopFont.Style = []
        BottomFill.Kind = gfkNone
        BottomStroke.Color = 11119017
        BottomFont.Color = clWindowText
        BottomFont.Height = -11
        BottomFont.Style = []
      end
      item
        Name = 'Column1'
        Text = 'Year'
        Width = 100.000000000000000000
        Fill.Color = -1
        Stroke.Color = 11119017
        Font.Color = clWindowText
        Font.Height = -11
        Font.Style = []
        TopFill.Kind = gfkNone
        TopStroke.Color = 11119017
        TopFont.Color = clWindowText
        TopFont.Height = -11
        TopFont.Style = []
        BottomFill.Kind = gfkNone
        BottomStroke.Color = 11119017
        BottomFont.Color = clWindowText
        BottomFont.Height = -11
        BottomFont.Style = []
      end
      item
        Name = 'Column2'
        Text = 'Miles'
        Width = 100.000000000000000000
        Fill.Color = -1
        Stroke.Color = 11119017
        Font.Color = clWindowText
        Font.Height = -11
        Font.Style = []
        TopFill.Kind = gfkNone
        TopStroke.Color = 11119017
        TopFont.Color = clWindowText
        TopFont.Height = -11
        TopFont.Style = []
        BottomFill.Kind = gfkNone
        BottomStroke.Color = 11119017
        BottomFont.Color = clWindowText
        BottomFont.Height = -11
        BottomFont.Style = []
      end>
    Nodes = <
      item
        Values = <
          item
            Text = 'Audi'
          end>
        Expanded = True
        Extended = True
        Tag = 0
        Nodes = <
          item
            Values = <
              item
                Text = 'A3'
              end
              item
                Text = '2010'
              end
              item
                Text = '32,300'
              end>
            Expanded = True
            Tag = 0
            Nodes = <>
          end
          item
            Values = <
              item
                Text = 'A5 series'
              end>
            Expanded = True
            Tag = 0
            Nodes = <
              item
                Values = <
                  item
                    Text = 'S5'
                  end
                  item
                    Text = '2016'
                  end
                  item
                    Text = '40,000'
                  end>
                Expanded = True
                Tag = 0
                Nodes = <>
              end
              item
                Values = <
                  item
                    Text = 'RS5'
                  end
                  item
                    Text = '2012'
                  end
                  item
                    Text = '15,000'
                  end>
                Expanded = True
                Tag = 0
                Nodes = <>
              end>
          end
          item
            Values = <
              item
                Text = 'A8'
              end
              item
                Text = '2005'
              end
              item
                Text = '80,000'
              end>
            Expanded = True
            Tag = 0
            Nodes = <>
          end>
      end
      item
        Values = <
          item
            Text = 'Mercedes'
          end>
        Expanded = True
        Extended = True
        Tag = 0
        Nodes = <
          item
            Values = <
              item
                Text = 'SLS'
              end
              item
                Text = '2000'
              end
              item
                Text = '300,000'
              end>
            Expanded = True
            Tag = 0
            Nodes = <>
          end
          item
            Values = <
              item
                Text = 'SLK'
              end
              item
                Text = '2010'
              end
              item
                Text = '20,000'
              end>
            Expanded = True
            Tag = 0
            Nodes = <>
          end
          item
            Values = <
              item
                Text = 'GLA'
              end
              item
                Text = '2012'
              end
              item
                Text = '14,500'
              end>
            Expanded = True
            Tag = 0
            Nodes = <>
          end>
      end>
    ColumnsAppearance.TopSize = 25.000000000000000000
    ColumnsAppearance.BottomSize = 25.000000000000000000
    ColumnsAppearance.TopFont.Color = clBlack
    ColumnsAppearance.TopFont.Height = -11
    ColumnsAppearance.TopFont.Style = []
    ColumnsAppearance.BottomFont.Color = clBlack
    ColumnsAppearance.BottomFont.Height = -11
    ColumnsAppearance.BottomFont.Style = []
    ColumnsAppearance.TopStroke.Color = 11119017
    ColumnsAppearance.BottomStroke.Color = 11119017
    NodesAppearance.ExpandWidth = 15.000000000000000000
    NodesAppearance.ExpandHeight = 15.000000000000000000
    NodesAppearance.LevelIndent = 20.000000000000000000
    NodesAppearance.FixedHeight = 25.000000000000000000
    NodesAppearance.VariableMinimumHeight = 25.000000000000000000
    NodesAppearance.Fill.Color = -1
    NodesAppearance.Stroke.Kind = gskNone
    NodesAppearance.Stroke.Color = 11119017
    NodesAppearance.ColumnStroke.Color = -1
    NodesAppearance.LineStroke.Kind = gskDot
    NodesAppearance.LineStroke.Color = 11119017
    NodesAppearance.Font.Color = clBlack
    NodesAppearance.Font.Height = -11
    NodesAppearance.Font.Style = []
    NodesAppearance.TitleFont.Color = clBlack
    NodesAppearance.TitleFont.Height = -11
    NodesAppearance.TitleFont.Style = []
    NodesAppearance.SelectedFill.Color = 16297243
    NodesAppearance.SelectedStroke.Color = 16297243
    NodesAppearance.DisabledFill.Color = 11119017
    NodesAppearance.DisabledStroke.Kind = gskNone
    NodesAppearance.DisabledStroke.Color = 11119017
    NodesAppearance.ExtendedFill.Color = 16053492
    NodesAppearance.ExtendedStroke.Color = 11119017
    NodesAppearance.ExtendedFont.Color = clWindowText
    NodesAppearance.ExtendedFont.Height = -11
    NodesAppearance.ExtendedFont.Style = []
    NodesAppearance.ExtendedSelectedFill.Color = 16297243
    NodesAppearance.ExtendedSelectedStroke.Kind = gskNone
    NodesAppearance.ExtendedSelectedStroke.Color = 11119017
    NodesAppearance.ExtendedDisabledFill.Color = 11119017
    NodesAppearance.ExtendedDisabledStroke.Kind = gskNone
    NodesAppearance.ExtendedDisabledStroke.Color = 11119017
    NodesAppearance.ExpandNodeIcon.Data = {
      0954506E67496D61676589504E470D0A1A0A0000000D494844520000000B0000
      000B080200000026CEE071000000017352474200AECE1CE90000000467414D41
      0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000000
      1874455874536F667477617265007061696E742E6E657420342E302E36FC8C63
      DF000000334944415478DA63ACAEAD66C00B18812A5A9A5A7049D7D4D5A0ABF0
      F6F3DEBA692B8D540025301D01544A6F7710080FFC610A005ADF3FFDA83755DB
      0000000049454E44AE426082}
    NodesAppearance.CollapseNodeIcon.Data = {
      0954506E67496D61676589504E470D0A1A0A0000000D494844520000000B0000
      000B080200000026CEE071000000017352474200AECE1CE90000000467414D41
      0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000000
      1874455874536F667477617265007061696E742E6E657420342E302E36FC8C63
      DF0000002C4944415478DA63ACAEAD66C00B18812A5A9A5A7049D7D4D5D05B85
      B79F37B2DCD64D5B07C61DF854E00F53005DBC2DFDD89D52A70000000049454E
      44AE426082}
    NodesAppearance.ExpandNodeIconLarge.Data = {
      0954506E67496D61676589504E470D0A1A0A0000000D49484452000000160000
      001608020000004BD6FB6C000000017352474200AECE1CE90000000467414D41
      0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000000
      1874455874536F667477617265007061696E742E6E657420342E302E36FC8C63
      DF000000404944415478DA63ACAEAD66A00C3052CD8896A6163234D7D4D5D0C5
      086F3F6F20B975D3D6512306C40888066200C450DA183138C262D488C1535E50
      02A8600400AA8F7FF987EC13380000000049454E44AE426082}
    NodesAppearance.CollapseNodeIconLarge.Data = {
      0954506E67496D61676589504E470D0A1A0A0000000D49484452000000160000
      001608020000004BD6FB6C0000000467414D410000B18F0BFC61050000000970
      48597300000EC200000EC20115284A800000001874455874536F667477617265
      007061696E742E6E657420342E302E36FC8C63DF000000384944415478DA63AC
      AEAD66A00C3052CD8896A6163234D7D4D58C1A31628CF0F6F3C6A36DEBA6AD74
      31627084C5A81183C1084A00158C000071065BF9A44132100000000049454E44
      AE426082}
  end
  object TMSFNCListEditor1: TTMSFNCListEditor
    Left = 24
    Top = 504
    Width = 288
    Height = 80
    ParentDoubleBuffered = False
    DoubleBuffered = True
    TabOrder = 5
    Items = <
      item
        Text = 'One'
        Tag = 0
      end
      item
        Text = 'Two'
        Tag = 0
      end
      item
        Text = 'Three'
        Tag = 0
      end
      item
        Text = 'Four'
        Tag = 0
      end
      item
        Text = 'Five'
        Tag = 0
      end
      item
        Text = 'Six'
        Tag = 0
      end>
    ItemAppearance.FillNormal.Kind = gfkGradient
    ItemAppearance.FillNormal.Color = 16312028
    ItemAppearance.FillNormal.ColorTo = 15847357
    ItemAppearance.FillSelected.Kind = gfkGradient
    ItemAppearance.FillSelected.Color = 15115123
    ItemAppearance.FillSelected.ColorTo = 14183971
    ItemAppearance.StrokeNormal.Color = 14124408
    ItemAppearance.StrokeSelected.Color = 14183971
    ItemAppearance.Font.Color = clWindowText
    ItemAppearance.Font.Height = -11
    ItemAppearance.Font.Style = []
    Stroke.Color = 11119017
  end
  object WebListBox1: TWebListBox
    Left = 336
    Top = 256
    Width = 240
    Height = 236
    HeightPercent = 100.000000000000000000
    ItemHeight = 13
    ItemIndex = -1
    Items.Strings = (
      'One'
      'Two'
      'Three'
      'Four'
      'Five'
      'Six'
      'Seven'
      'Eight'
      'Nine'
      'Ten')
    WidthPercent = 100.000000000000000000
    OnClick = WebListBox1Click
  end
  object ThemeManager: TTMSFNCThemeManager
    Theme = 'Fluent Light'
    Left = 24
    Top = 24
  end
  object WebLabel1: TTMSFNCHTMLText
    TextRole = htrSecondary
    Left = 24
    Top = 88
    Width = 280
    Height = 24
    Anchors = [akLeft, akTop]
    TabOrder = 0
    HorizontalTextAlign = gtaLeading
    Trimming = gttCharacter
    Fill.Kind = gfkNone
    Stroke.Kind = gskNone
    Text = 'TTMSFNCTreeView:'
  end
  object WebLabel3: TTMSFNCHTMLText
    TextRole = htrSecondary
    Left = 336
    Top = 88
    Width = 280
    Height = 24
    Anchors = [akLeft, akTop]
    TabOrder = 0
    HorizontalTextAlign = gtaLeading
    Trimming = gttCharacter
    Fill.Kind = gfkNone
    Stroke.Kind = gskNone
    Text = 'Basic content for TListBox with events:'
  end
  object WebLabel2: TTMSFNCHTMLText
    TextRole = htrSecondary
    Left = 24
    Top = 168
    Width = 280
    Height = 24
    Anchors = [akLeft, akTop]
    TabOrder = 0
    HorizontalTextAlign = gtaLeading
    Trimming = gttCharacter
    Fill.Kind = gfkNone
    Stroke.Kind = gskNone
    Text = 'TTMSFNCListEditor:'
  end
  object WebLabel4: TTMSFNCHTMLText
    TextRole = htrSecondary
    Left = 336
    Top = 168
    Width = 280
    Height = 24
    Anchors = [akLeft, akTop]
    TabOrder = 0
    HorizontalTextAlign = gtaLeading
    Trimming = gttCharacter
    Fill.Kind = gfkNone
    Stroke.Kind = gskNone
    Text = 'Button Base Interface:'
  end
end
