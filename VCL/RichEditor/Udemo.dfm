object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'TMS FNC UI Pack - Rich editor'
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
    Width = 898
    Height = 72
    Align = alTop
    TabOrder = 0
    Fill.Kind = gfkNone
    Stroke.Kind = gskNone
    Header.Visible = False
    object DemoThemeSelector: TTMSFNCThemeSelector
      AlignWithMargins = True
      Left = 714
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
      Width = 674
      Height = 30
      Anchors = [akLeft, akTop, akRight]
      Font.Height = -20
      Font.Name = 'Segoe UI Semibold'
      TabOrder = 1
      HorizontalTextAlign = gtaLeading
      Trimming = gttCharacter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Text = 'Rich text editor'
    end
    object DemoDescription: TTMSFNCHTMLText
      Left = 24
      Top = 42
      Width = 674
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      TextRole = htrSecondary
      HorizontalTextAlign = gtaLeading
      Trimming = gttCharacter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Text = 'Edit formatted text, load a sample, export the document to PDF or print it'
    end
  end
  object Panel2: TTMSFNCPanel
    Left = 16
    Top = 72
    Width = 260
    Height = 632
    Align = alLeft
    TabOrder = 1
    Header.Visible = False
    AlignWithMargins = True
    Margins.Left = 16
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 16
    object Label1: TTMSFNCHTMLText
      Left = 16
      Top = 12
      Width = 228
      Height = 20
      Text = 'Samples'
      HorizontalTextAlign = gtaLeading
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object ListBox1: TTMSFNCListBox
      Left = 16
      Top = 40
      Width = 228
      Height = 304
      TabOrder = 0
      OnItemSelected = ListBox1ItemSelected
    end
    object TMSFNCRichEditorPDFIO1: TTMSFNCRichEditorPDFIO
      Left = 176
      Top = 255
      Width = 26
      Height = 26
      Visible = True
      RichEditor = TMSFNCRichEditor1
      Options.DefaultFont.Name = 'Arial'
      Options.Header = 'TMS PDF Header'
      Options.Footer = 'TMS PDF Footer'
      Options.Margins.Left = 20.000000000000000000
      Options.Margins.Top = 50.000000000000000000
      Options.Margins.Right = 20.000000000000000000
      Options.Margins.Bottom = 50.000000000000000000
      Options.HeaderFont.Name = 'Arial'
      Options.FooterFont.Name = 'Arial'
      Options.HeaderMargins.Left = 5.000000000000000000
      Options.HeaderMargins.Top = 5.000000000000000000
      Options.HeaderMargins.Right = 5.000000000000000000
      Options.HeaderMargins.Bottom = 5.000000000000000000
      Options.FooterMargins.Left = 5.000000000000000000
      Options.FooterMargins.Top = 5.000000000000000000
      Options.FooterMargins.Right = 5.000000000000000000
      Options.FooterMargins.Bottom = 5.000000000000000000
      Options.PageNumberMargins.Left = 10.000000000000000000
      Options.PageNumberMargins.Top = 5.000000000000000000
      Options.PageNumberMargins.Right = 10.000000000000000000
      Options.PageNumberMargins.Bottom = 5.000000000000000000
      Options.PageNumberFont.Name = 'Arial'
      OnGetFooter = TMSFNCRichEditorPDFIO1GetFooter
    end
    object Button1: TTMSFNCButton
      Left = 16
      Top = 360
      Width = 228
      Height = 32
      Text = 'Export To PDF'
      TabOrder = 2
      OnClick = Button1Click
    end
    object Button2: TTMSFNCButton
      Left = 16
      Top = 400
      Width = 228
      Height = 32
      Text = 'Print'
      TabOrder = 3
      OnClick = Button2Click
    end
    object TMSFNCRichEditorPrintIO1: TTMSFNCRichEditorPrintIO
      Left = 176
      Top = 287
      Width = 26
      Height = 26
      Visible = True
      Options.DefaultFont.Charset = DEFAULT_CHARSET
      Options.DefaultFont.Height = -11
      Options.DefaultFont.Name = 'Tahoma'
      Options.DefaultFont.Style = []
      Options.FooterFont.Charset = DEFAULT_CHARSET
      Options.FooterFont.Height = -11
      Options.FooterFont.Name = 'Tahoma'
      Options.FooterFont.Style = []
      Options.FooterMargins.Left = 20.000000000000000000
      Options.FooterMargins.Top = 10.000000000000000000
      Options.FooterMargins.Right = 20.000000000000000000
      Options.FooterMargins.Bottom = 10.000000000000000000
      Options.HeaderFont.Charset = DEFAULT_CHARSET
      Options.HeaderFont.Height = -11
      Options.HeaderFont.Name = 'Tahoma'
      Options.HeaderFont.Style = []
      Options.HeaderMargins.Left = 20.000000000000000000
      Options.HeaderMargins.Top = 10.000000000000000000
      Options.HeaderMargins.Right = 20.000000000000000000
      Options.HeaderMargins.Bottom = 10.000000000000000000
      Options.Margins.Left = 20.000000000000000000
      Options.Margins.Top = 50.000000000000000000
      Options.Margins.Right = 20.000000000000000000
      Options.Margins.Bottom = 50.000000000000000000
      Options.PageNumber = pnNone
      Options.PageNumberFont.Charset = DEFAULT_CHARSET
      Options.PageNumberFont.Height = -11
      Options.PageNumberFont.Name = 'Tahoma'
      Options.PageNumberFont.Style = []
      Options.PageNumberFormat = '%d'
      Options.PageNumberMargins.Left = 20.000000000000000000
      Options.PageNumberMargins.Top = 10.000000000000000000
      Options.PageNumberMargins.Right = 20.000000000000000000
      Options.PageNumberMargins.Bottom = 10.000000000000000000
      RichEditor = TMSFNCRichEditor1
    end
  end
  object Panel3: TTMSFNCPanel
    Left = 292
    Top = 72
    Width = 792
    Height = 632
    Align = alClient
    TabOrder = 2
    Header.Visible = False
    AlignWithMargins = True
    Margins.Left = 16
    Margins.Top = 0
    Margins.Right = 16
    Margins.Bottom = 16
    object Panel1: TTMSFNCPanel
      Left = 0
      Top = 0
      Width = 898
      Height = 80
      Align = alTop
      TabOrder = 0
      Header.Visible = False
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      object TMSFNCRichEditorEditToolBar1: TTMSFNCRichEditorEditToolBar
        Left = 8
        Top = 6
        Width = 208
        Height = 30
        ParentDoubleBuffered = False
        DoubleBuffered = True
        Font.Charset = DEFAULT_CHARSET
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        TabOrder = 0
        Appearance.Fill.Kind = gfkGradient
        CompactBitmaps = <>
        CompactAppearance.NormalFill.Kind = gfkGradient
        CompactAppearance.HoverFill.Kind = gfkGradient
        CompactAppearance.DownFill.Kind = gfkGradient
        QuickMenuButtonAppearance.NormalFill.Kind = gfkGradient
        QuickMenuButtonAppearance.HoverFill.Kind = gfkGradient
        QuickMenuButtonAppearance.DownFill.Kind = gfkGradient
        Text = ''
        OptionsMenu.ShowButton = False
        RichEditor = TMSFNCRichEditor1
      end
      object TMSFNCRichEditorFormatToolBar1: TTMSFNCRichEditorFormatToolBar
        Left = 8
        Top = 42
        Width = 688
        Height = 30
        ParentDoubleBuffered = False
        DoubleBuffered = True
        Font.Charset = DEFAULT_CHARSET
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        TabOrder = 1
        Appearance.Fill.Kind = gfkGradient
        CompactBitmaps = <>
        CompactAppearance.NormalFill.Kind = gfkGradient
        CompactAppearance.HoverFill.Kind = gfkGradient
        CompactAppearance.DownFill.Kind = gfkGradient
        QuickMenuButtonAppearance.NormalFill.Kind = gfkGradient
        QuickMenuButtonAppearance.HoverFill.Kind = gfkGradient
        QuickMenuButtonAppearance.DownFill.Kind = gfkGradient
        Text = ''
        OptionsMenu.ShowButton = False
        RichEditor = TMSFNCRichEditor1
      end
    end
    object TMSFNCRichEditorHorizontalRuler1: TTMSFNCRichEditorHorizontalRuler
      Left = 1
      Top = 1
      Width = 678
      Height = 31
      Align = alTop
      ParentDoubleBuffered = False
      DoubleBuffered = True
      TabOrder = 1
      Appearance.Font.Charset = DEFAULT_CHARSET
      Appearance.Font.Height = -11
      Appearance.Font.Name = 'Tahoma'
      Appearance.Font.Style = []
      Layout.AutoPosition = True
      Layout.AutoWidth = True
      Layout.RightMargin = 40
      RichEditor = TMSFNCRichEditor1
      Stroke.Kind = gskNone
      Tabs = <>
    end
    object TMSFNCRichEditor1: TTMSFNCRichEditor
      Left = 4
      Top = 36
      Width = 670
      Height = 486
      Cursor = crIBeam
      HorzScrollBar.Tracking = True
      VertScrollBar.Range = 6
      VertScrollBar.Tracking = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      TabOrder = 0
      TabStop = True
      ParentFont = False
      Version = '1.8.5.3'
      Align = alClient
    end
  end
  object PrintDialog1: TPrintDialog
    Left = 816
    Top = 328
  end
  object ThemeManager: TTMSFNCThemeManager
    Theme = 'Fluent Light'
    Left = 24
    Top = 24
  end
end
