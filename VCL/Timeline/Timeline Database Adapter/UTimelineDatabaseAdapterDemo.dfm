object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'TMS FNC UI Pack - Timeline Database Adapter'
  ClientHeight = 600
  ClientWidth = 1200
  OnCreate = FormCreate
  Position = poScreenCenter
  object DemoHeader: TTMSFNCPanel
    Left = 0
    Top = 0
    Width = 1170
    Height = 72
    Align = alTop
    TabOrder = 0
    Fill.Kind = gfkNone
    Stroke.Kind = gskNone
    Header.Visible = False
    object DemoThemeSelector: TTMSFNCThemeSelector
      AlignWithMargins = True
      Left = 986
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
      Width = 946
      Height = 30
      Anchors = [akLeft, akTop, akRight]
      Font.Height = -20
      Font.Name = 'Segoe UI Semibold'
      TabOrder = 1
      HorizontalTextAlign = gtaLeading
      Trimming = gttCharacter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Text = 'Timeline Database Adapter: history'
    end
    object DemoDescription: TTMSFNCHTMLText
      Left = 24
      Top = 42
      Width = 946
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      TextRole = htrSecondary
      HorizontalTextAlign = gtaLeading
      Trimming = gttCharacter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Text = 'Sections and indicators read from a TClientDataSet with the Timeline Database Adapter'
    end
  end
  object SettingsPanel: TTMSFNCPanel
    AlignWithMargins = True
    Left = 16
    Top = 72
    Width = 260
    Height = 600
    Margins.Left = 16
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 16
    Align = alLeft
    TabOrder = 1
    Header.Visible = False
    object DataCaption: TTMSFNCHTMLText
      AlignWithMargins = True
      Left = 16
      Top = 12
      Width = 228
      Height = 24
      Margins.Left = 16
      Margins.Top = 12
      Margins.Right = 16
      Margins.Bottom = 0
      Align = alTop
      Font.Height = -15
      Font.Name = 'Segoe UI Semibold'
      HorizontalTextAlign = gtaLeading
      Trimming = gttCharacter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Text = 'Database'
    end
    object ConnectBtn: TTMSFNCButton
      AlignWithMargins = True
      Left = 16
      Top = 44
      Width = 228
      Height = 32
      Margins.Left = 16
      Margins.Top = 8
      Margins.Right = 16
      Margins.Bottom = 0
      Align = alTop
      TabOrder = 0
      Text = 'Disconnect'
      OnClick = ConnectBtnClick
    end
    object InfoText: TTMSFNCHTMLText
      AlignWithMargins = True
      Left = 16
      Top = 92
      Width = 228
      Height = 120
      Margins.Left = 16
      Margins.Top = 16
      Margins.Right = 16
      Margins.Bottom = 0
      Align = alTop
      TextRole = htrSecondary
      HorizontalTextAlign = gtaLeading
      WordWrapping = True
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Text = 'The sections (periods) and indicators (events) come from the HistoryData data set; their colours come from its Color field. Disconnect and connect again to reload them.'
    end
  end
  object TMSFNCTimeline1: TTMSFNCTimeline
    Left = 8
    Top = 110
    Width = 1154
    Height = 392
    TabOrder = 0
    Appearance.DivisionFont.Height = -9
    Appearance.DefaultIndicatorAppearance.Stroke.Width = 2.000000000000000000
    Appearance.DefaultIndicatorAppearance.SelectedStroke.Width = 2.000000000000000000
    Appearance.DefaultIndicatorAppearance.Size = 20
    Appearance.DefaultAnnotationAppearance.TextMargins.Left = 2
    Appearance.DefaultAnnotationAppearance.TextMargins.Top = 2
    Appearance.DefaultAnnotationAppearance.TextMargins.Right = 2
    Appearance.DefaultAnnotationAppearance.TextMargins.Bottom = 2
    Appearance.DefaultAnnotationAppearance.RoundedCorners = [gcTopLeft, gcTopRight, gcBottomLeft, gcBottomRight]
    Appearance.DefaultSectionAppearance.Font.Color = 4539717
    Appearance.DefaultSectionAppearance.HoverFont.Color = 4539717
    Appearance.DefaultSectionAppearance.SelectedFont.Color = 4539717
    Appearance.DefaultSectionAppearance.Fill.Color = 15660543
    Appearance.DefaultSectionAppearance.TextMargins.Left = 2
    Appearance.DefaultSectionAppearance.TextMargins.Top = 2
    Appearance.DefaultSectionAppearance.TextMargins.Right = 2
    Appearance.DefaultSectionAppearance.TextMargins.Bottom = 2
    Appearance.DefaultSectionAppearance.RoundedCorners = [gcTopLeft, gcTopRight, gcBottomLeft, gcBottomRight]
    Division.Position = tlpBottomRight
    Division.TextFormat.ValueFormat = '%.0f'
    Division.TextWordWrap = True
    Indicators = <
      item
        Appearance.Stroke.Width = 2.000000000000000000
        Appearance.SelectedStroke.Width = 2.000000000000000000
        Appearance.Size = 20
        Annotation.Appearance.TextMargins.Left = 2
        Annotation.Appearance.TextMargins.Top = 2
        Annotation.Appearance.TextMargins.Right = 2
        Annotation.Appearance.TextMargins.Bottom = 2
        Annotation.Appearance.RoundedCorners = [gcTopLeft, gcTopRight, gcBottomLeft, gcBottomRight]
        Annotation.Text = 'Social Media'
        TimelineValue = 45524.250000000000000000
        TimelineDate = 45524.250000000000000000
      end>
    Layout.Margins.Left = 10
    Layout.Margins.Top = 10
    Layout.Margins.Right = 10
    Layout.Margins.Bottom = 10
    Layout.Size = 90
    Layout.IndicatorAnnotationSpacing = 20.000000000000000000
    Layout.IndicatorHoverBehavior = tlibBoth
    Layout.DrawSectionsBeneathDivisions = True
    Layout.OverlapSections = False
    Range.RangeType = tlrValue
    Range.DivisionSpan = 50.000000000000000000
    Range.MinimumValue = 450
    Range.MaximumValue = 2050
    Range.MinimumDate = -520103.000000000000000000
    Range.MaximumDate = 36526.000000000000000000
    Sections = <
      item
        Appearance.Font.Color = 4539717
        Appearance.HoverFont.Color = 4539717
        Appearance.SelectedFont.Color = 4539717
        Appearance.Fill.Color = 15660543
        Appearance.TextMargins.Left = 2
        Appearance.TextMargins.Top = 2
        Appearance.TextMargins.Right = 2
        Appearance.TextMargins.Bottom = 2
        Appearance.RoundedCorners = [gcTopLeft, gcTopRight, gcBottomLeft, gcBottomRight]
        Text = 'Marketing Phase'
        StartTimelineValue = 45521.833333333340000000
        EndTimelineValue = 45526.666666666660000000
        StartTimelineDate = 45521.833333333340000000
        EndTimelineDate = 45526.666666666660000000
      end>
    OnBeforeDrawIndicator = TMSFNCTimeline1BeforeDrawIndicator
    Align = alClient
    AlignWithMargins = True
    Margins.Left = 16
    Margins.Top = 0
    Margins.Right = 16
    Margins.Bottom = 16
  end
  object TMSFNCTimelineDatabaseAdapter1: TTMSFNCTimelineDatabaseAdapter
    Width = 39
    Height = 39
    Left = 1008
    Top = 80
    Item.DataSource = DataSource1
    OnFieldsToSection = TMSFNCTimelineDatabaseAdapter1FieldsToSection
    OnIndicatorRead = TMSFNCTimelineDatabaseAdapter1IndicatorRead
    OnSectionRead = TMSFNCTimelineDatabaseAdapter1SectionRead
  end
  object HistoryData: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 1104
    Top = 8
  end
  object DataSource1: TDataSource
    DataSet = HistoryData
    Left = 1048
    Top = 8
  end
  object ThemeManager: TTMSFNCThemeManager
    Theme = 'Fluent Light'
    Left = 24
    Top = 24
  end
end
