object Form1: TForm1
  Width = 1000
  Height = 640
  Caption = 'TMS FNC UI Pack - Timeline Positions'
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
      Text = 'Timeline positions'
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
      Text = 'The same settings on a horizontal and a vertical timeline: move the line, the divisions, the annotations and the section texts'
    end
  end
  object TMSFNCTimeline1: TTMSFNCTimeline
    Left = 0
    Top = 72
    Width = 1035
    Height = 200
    Align = alTop
    ParentDoubleBuffered = False
    Color = 7382754
    DoubleBuffered = True
    TabOrder = 0
    Appearance.TimelineFill.Kind = gfkNone
    Appearance.TimelineStroke.Color = clWhite
    Appearance.DivisionFont.Charset = DEFAULT_CHARSET
    Appearance.DivisionFont.Color = clWhite
    Appearance.DivisionFont.Height = -10
    Appearance.DivisionFont.Name = 'Segoe UI'
    Appearance.DivisionFont.Style = []
    Appearance.DivisionTickmarkStroke.Color = clWhite
    Appearance.DefaultIndicatorAppearance.Fill.Color = 11386342
    Appearance.DefaultIndicatorAppearance.Stroke.Color = clWhite
    Appearance.DefaultIndicatorAppearance.Stroke.Width = 2.000000000000000000
    Appearance.DefaultIndicatorAppearance.HoverFill.Color = 11581890
    Appearance.DefaultIndicatorAppearance.HoverStroke.Color = 11581890
    Appearance.DefaultIndicatorAppearance.SelectedFill.Color = clWhite
    Appearance.DefaultIndicatorAppearance.SelectedStroke.Color = 5924990
    Appearance.DefaultIndicatorAppearance.SelectedStroke.Width = 2.000000000000000000
    Appearance.DefaultAnnotationAppearance.Font.Charset = DEFAULT_CHARSET
    Appearance.DefaultAnnotationAppearance.Font.Color = clWhite
    Appearance.DefaultAnnotationAppearance.Font.Height = -11
    Appearance.DefaultAnnotationAppearance.Font.Name = 'Segoe UI'
    Appearance.DefaultAnnotationAppearance.Font.Style = []
    Appearance.DefaultAnnotationAppearance.HoverFont.Charset = DEFAULT_CHARSET
    Appearance.DefaultAnnotationAppearance.HoverFont.Color = 11581890
    Appearance.DefaultAnnotationAppearance.HoverFont.Height = -11
    Appearance.DefaultAnnotationAppearance.HoverFont.Name = 'Segoe UI'
    Appearance.DefaultAnnotationAppearance.HoverFont.Style = []
    Appearance.DefaultAnnotationAppearance.SelectedFont.Charset = DEFAULT_CHARSET
    Appearance.DefaultAnnotationAppearance.SelectedFont.Color = 5924990
    Appearance.DefaultAnnotationAppearance.SelectedFont.Height = -11
    Appearance.DefaultAnnotationAppearance.SelectedFont.Name = 'Segoe UI'
    Appearance.DefaultAnnotationAppearance.SelectedFont.Style = []
    Appearance.DefaultAnnotationAppearance.Fill.Kind = gfkNone
    Appearance.DefaultAnnotationAppearance.Stroke.Color = clWhite
    Appearance.DefaultAnnotationAppearance.HoverFill.Kind = gfkNone
    Appearance.DefaultAnnotationAppearance.HoverFill.Color = 11386342
    Appearance.DefaultAnnotationAppearance.HoverStroke.Color = 11581890
    Appearance.DefaultAnnotationAppearance.HoverStroke.Width = 2.000000000000000000
    Appearance.DefaultAnnotationAppearance.SelectedFill.Color = clWhite
    Appearance.DefaultAnnotationAppearance.SelectedStroke.Color = 5924990
    Appearance.DefaultAnnotationAppearance.SelectedStroke.Width = 2.000000000000000000
    Appearance.DefaultAnnotationAppearance.TextMargins.Left = 2.000000000000000000
    Appearance.DefaultAnnotationAppearance.TextMargins.Top = 2.000000000000000000
    Appearance.DefaultAnnotationAppearance.TextMargins.Right = 2.000000000000000000
    Appearance.DefaultAnnotationAppearance.TextMargins.Bottom = 2.000000000000000000
    Appearance.DefaultAnnotationAppearance.RoundedCorners = [gcTopLeft, gcTopRight, gcBottomLeft, gcBottomRight]
    Appearance.DefaultAnnotationAppearance.AnnotationLine.Color = clWhite
    Appearance.DefaultSectionAppearance.Font.Charset = DEFAULT_CHARSET
    Appearance.DefaultSectionAppearance.Font.Color = clWhite
    Appearance.DefaultSectionAppearance.Font.Height = -11
    Appearance.DefaultSectionAppearance.Font.Name = 'Segoe UI'
    Appearance.DefaultSectionAppearance.Font.Style = []
    Appearance.DefaultSectionAppearance.HoverFont.Charset = DEFAULT_CHARSET
    Appearance.DefaultSectionAppearance.HoverFont.Color = clWhite
    Appearance.DefaultSectionAppearance.HoverFont.Height = -11
    Appearance.DefaultSectionAppearance.HoverFont.Name = 'Segoe UI'
    Appearance.DefaultSectionAppearance.HoverFont.Style = []
    Appearance.DefaultSectionAppearance.SelectedFont.Charset = DEFAULT_CHARSET
    Appearance.DefaultSectionAppearance.SelectedFont.Color = clWhite
    Appearance.DefaultSectionAppearance.SelectedFont.Height = -11
    Appearance.DefaultSectionAppearance.SelectedFont.Name = 'Segoe UI'
    Appearance.DefaultSectionAppearance.SelectedFont.Style = []
    Appearance.DefaultSectionAppearance.Fill.Color = 8221159
    Appearance.DefaultSectionAppearance.Stroke.Color = 11907771
    Appearance.DefaultSectionAppearance.HoverFill.Color = 9665498
    Appearance.DefaultSectionAppearance.HoverStroke.Color = 14476013
    Appearance.DefaultSectionAppearance.SelectedFill.Color = 6372267
    Appearance.DefaultSectionAppearance.SelectedStroke.Color = 11581890
    Appearance.DefaultSectionAppearance.TextMargins.Left = 5.000000000000000000
    Appearance.DefaultSectionAppearance.TextMargins.Top = 2.000000000000000000
    Appearance.DefaultSectionAppearance.TextMargins.Right = 5.000000000000000000
    Appearance.DefaultSectionAppearance.TextMargins.Bottom = 2.000000000000000000
    Appearance.DefaultSectionAppearance.RoundedCorners = [gcTopLeft, gcTopRight, gcBottomLeft, gcBottomRight]
    Appearance.DefaultSectionAppearance.Rounding = 4
    Division.TextWordWrap = True
    Fill.Kind = gfkGradient
    Fill.Orientation = gfoHorizontal
    Fill.Color = 7382754
    Fill.ColorTo = 6508721
    Indicators = <
      item
        Appearance.Fill.Color = 11386342
        Appearance.Stroke.Color = clWhite
        Appearance.Stroke.Width = 2.000000000000000000
        Appearance.HoverFill.Color = 11581890
        Appearance.HoverStroke.Color = 11581890
        Appearance.SelectedFill.Color = clWhite
        Appearance.SelectedStroke.Color = 5924990
        Appearance.SelectedStroke.Width = 2.000000000000000000
        Annotation.Appearance.Font.Charset = DEFAULT_CHARSET
        Annotation.Appearance.Font.Color = clWhite
        Annotation.Appearance.Font.Height = -11
        Annotation.Appearance.Font.Name = 'Segoe UI'
        Annotation.Appearance.Font.Style = []
        Annotation.Appearance.HoverFont.Charset = DEFAULT_CHARSET
        Annotation.Appearance.HoverFont.Color = 11581890
        Annotation.Appearance.HoverFont.Height = -11
        Annotation.Appearance.HoverFont.Name = 'Segoe UI'
        Annotation.Appearance.HoverFont.Style = []
        Annotation.Appearance.SelectedFont.Charset = DEFAULT_CHARSET
        Annotation.Appearance.SelectedFont.Color = 5924990
        Annotation.Appearance.SelectedFont.Height = -11
        Annotation.Appearance.SelectedFont.Name = 'Segoe UI'
        Annotation.Appearance.SelectedFont.Style = []
        Annotation.Appearance.Fill.Kind = gfkNone
        Annotation.Appearance.Stroke.Color = clWhite
        Annotation.Appearance.HoverFill.Kind = gfkNone
        Annotation.Appearance.HoverFill.Color = 11386342
        Annotation.Appearance.HoverStroke.Color = 11581890
        Annotation.Appearance.HoverStroke.Width = 2.000000000000000000
        Annotation.Appearance.SelectedFill.Color = clWhite
        Annotation.Appearance.SelectedStroke.Color = 5924990
        Annotation.Appearance.SelectedStroke.Width = 2.000000000000000000
        Annotation.Appearance.TextMargins.Left = 2.000000000000000000
        Annotation.Appearance.TextMargins.Top = 2.000000000000000000
        Annotation.Appearance.TextMargins.Right = 2.000000000000000000
        Annotation.Appearance.TextMargins.Bottom = 2.000000000000000000
        Annotation.Appearance.RoundedCorners = [gcTopLeft, gcTopRight, gcBottomLeft, gcBottomRight]
        Annotation.Appearance.AnnotationLine.Color = clWhite
        Annotation.Text = 'Social Media'
        TimelineValue = 45446.525000000000000000
        TimelineDate = 45446.525000000000000000
      end>
    Layout.Margins.Left = 10.000000000000000000
    Layout.Margins.Top = 10.000000000000000000
    Layout.Margins.Right = 10.000000000000000000
    Layout.Margins.Bottom = 10.000000000000000000
    Layout.IndicatorHoverBehavior = tlibBoth
    Range.MinimumDate = 45437.000000000000000000
    Range.MaximumDate = 45457.000000000000000000
    AlignWithMargins = True
    Margins.Left = 16
    Margins.Top = 0
    Margins.Right = 16
    Margins.Bottom = 16
    Sections = <
      item
        Appearance.Font.Charset = DEFAULT_CHARSET
        Appearance.Font.Color = clWhite
        Appearance.Font.Height = -11
        Appearance.Font.Name = 'Segoe UI'
        Appearance.Font.Style = []
        Appearance.HoverFont.Charset = DEFAULT_CHARSET
        Appearance.HoverFont.Color = clWhite
        Appearance.HoverFont.Height = -11
        Appearance.HoverFont.Name = 'Segoe UI'
        Appearance.HoverFont.Style = []
        Appearance.SelectedFont.Charset = DEFAULT_CHARSET
        Appearance.SelectedFont.Color = clWhite
        Appearance.SelectedFont.Height = -11
        Appearance.SelectedFont.Name = 'Segoe UI'
        Appearance.SelectedFont.Style = []
        Appearance.Fill.Color = 8221159
        Appearance.Stroke.Color = 11907771
        Appearance.HoverFill.Color = 9665498
        Appearance.HoverStroke.Color = 14476013
        Appearance.SelectedFill.Color = 6372267
        Appearance.SelectedStroke.Color = 11581890
        Appearance.TextMargins.Left = 5.000000000000000000
        Appearance.TextMargins.Top = 2.000000000000000000
        Appearance.TextMargins.Right = 5.000000000000000000
        Appearance.TextMargins.Bottom = 2.000000000000000000
        Appearance.RoundedCorners = [gcTopLeft, gcTopRight, gcBottomLeft, gcBottomRight]
        Appearance.Rounding = 4
        Text = 'Marketing Phase'
        StartTimelineValue = 45443.350000000000000000
        EndTimelineValue = 45449.700000000000000000
        StartTimelineDate = 45443.350000000000000000
        EndTimelineDate = 45449.700000000000000000
      end>
  end
  object TMSFNCTimeline2: TTMSFNCTimeline
    Left = 0
    Top = 288
    Width = 260
    Height = 715
    Align = alLeft
    ParentDoubleBuffered = False
    Color = 7382754
    DoubleBuffered = True
    TabOrder = 2
    Appearance.TimelineFill.Kind = gfkNone
    Appearance.TimelineStroke.Color = clWhite
    Appearance.DivisionFont.Charset = DEFAULT_CHARSET
    Appearance.DivisionFont.Color = clWhite
    Appearance.DivisionFont.Height = -10
    Appearance.DivisionFont.Name = 'Segoe UI'
    Appearance.DivisionFont.Style = []
    Appearance.DivisionTickmarkStroke.Color = clWhite
    Appearance.DefaultIndicatorAppearance.Fill.Color = 11386342
    Appearance.DefaultIndicatorAppearance.Stroke.Color = clWhite
    Appearance.DefaultIndicatorAppearance.Stroke.Width = 2.000000000000000000
    Appearance.DefaultIndicatorAppearance.HoverFill.Color = 11581890
    Appearance.DefaultIndicatorAppearance.HoverStroke.Color = 11581890
    Appearance.DefaultIndicatorAppearance.SelectedFill.Color = clWhite
    Appearance.DefaultIndicatorAppearance.SelectedStroke.Color = 5924990
    Appearance.DefaultIndicatorAppearance.SelectedStroke.Width = 2.000000000000000000
    Appearance.DefaultAnnotationAppearance.Font.Charset = DEFAULT_CHARSET
    Appearance.DefaultAnnotationAppearance.Font.Color = clWhite
    Appearance.DefaultAnnotationAppearance.Font.Height = -11
    Appearance.DefaultAnnotationAppearance.Font.Name = 'Segoe UI'
    Appearance.DefaultAnnotationAppearance.Font.Style = []
    Appearance.DefaultAnnotationAppearance.HoverFont.Charset = DEFAULT_CHARSET
    Appearance.DefaultAnnotationAppearance.HoverFont.Color = 11581890
    Appearance.DefaultAnnotationAppearance.HoverFont.Height = -11
    Appearance.DefaultAnnotationAppearance.HoverFont.Name = 'Segoe UI'
    Appearance.DefaultAnnotationAppearance.HoverFont.Style = []
    Appearance.DefaultAnnotationAppearance.SelectedFont.Charset = DEFAULT_CHARSET
    Appearance.DefaultAnnotationAppearance.SelectedFont.Color = 5924990
    Appearance.DefaultAnnotationAppearance.SelectedFont.Height = -11
    Appearance.DefaultAnnotationAppearance.SelectedFont.Name = 'Segoe UI'
    Appearance.DefaultAnnotationAppearance.SelectedFont.Style = []
    Appearance.DefaultAnnotationAppearance.Fill.Kind = gfkNone
    Appearance.DefaultAnnotationAppearance.Stroke.Color = clWhite
    Appearance.DefaultAnnotationAppearance.HoverFill.Kind = gfkNone
    Appearance.DefaultAnnotationAppearance.HoverFill.Color = 11386342
    Appearance.DefaultAnnotationAppearance.HoverStroke.Color = 11581890
    Appearance.DefaultAnnotationAppearance.HoverStroke.Width = 2.000000000000000000
    Appearance.DefaultAnnotationAppearance.SelectedFill.Color = clWhite
    Appearance.DefaultAnnotationAppearance.SelectedStroke.Color = 5924990
    Appearance.DefaultAnnotationAppearance.SelectedStroke.Width = 2.000000000000000000
    Appearance.DefaultAnnotationAppearance.TextOrientation = tltoRight
    Appearance.DefaultAnnotationAppearance.TextMargins.Left = 2.000000000000000000
    Appearance.DefaultAnnotationAppearance.TextMargins.Top = 2.000000000000000000
    Appearance.DefaultAnnotationAppearance.TextMargins.Right = 2.000000000000000000
    Appearance.DefaultAnnotationAppearance.TextMargins.Bottom = 2.000000000000000000
    Appearance.DefaultAnnotationAppearance.RoundedCorners = [gcTopLeft, gcTopRight, gcBottomLeft, gcBottomRight]
    Appearance.DefaultAnnotationAppearance.AnnotationLine.Color = clWhite
    Appearance.DefaultSectionAppearance.Font.Charset = DEFAULT_CHARSET
    Appearance.DefaultSectionAppearance.Font.Color = clWhite
    Appearance.DefaultSectionAppearance.Font.Height = -11
    Appearance.DefaultSectionAppearance.Font.Name = 'Segoe UI'
    Appearance.DefaultSectionAppearance.Font.Style = []
    Appearance.DefaultSectionAppearance.HoverFont.Charset = DEFAULT_CHARSET
    Appearance.DefaultSectionAppearance.HoverFont.Color = clWhite
    Appearance.DefaultSectionAppearance.HoverFont.Height = -11
    Appearance.DefaultSectionAppearance.HoverFont.Name = 'Segoe UI'
    Appearance.DefaultSectionAppearance.HoverFont.Style = []
    Appearance.DefaultSectionAppearance.SelectedFont.Charset = DEFAULT_CHARSET
    Appearance.DefaultSectionAppearance.SelectedFont.Color = clWhite
    Appearance.DefaultSectionAppearance.SelectedFont.Height = -11
    Appearance.DefaultSectionAppearance.SelectedFont.Name = 'Segoe UI'
    Appearance.DefaultSectionAppearance.SelectedFont.Style = []
    Appearance.DefaultSectionAppearance.Fill.Color = 8221159
    Appearance.DefaultSectionAppearance.Stroke.Color = 11907771
    Appearance.DefaultSectionAppearance.HoverFill.Color = 9665498
    Appearance.DefaultSectionAppearance.HoverStroke.Color = 14476013
    Appearance.DefaultSectionAppearance.SelectedFill.Color = 6372267
    Appearance.DefaultSectionAppearance.SelectedStroke.Color = 11581890
    Appearance.DefaultSectionAppearance.TextOrientation = tltoRight
    Appearance.DefaultSectionAppearance.TextMargins.Left = 2.000000000000000000
    Appearance.DefaultSectionAppearance.TextMargins.Top = 5.000000000000000000
    Appearance.DefaultSectionAppearance.TextMargins.Right = 2.000000000000000000
    Appearance.DefaultSectionAppearance.TextMargins.Bottom = 5.000000000000000000
    Appearance.DefaultSectionAppearance.RoundedCorners = [gcTopLeft, gcTopRight, gcBottomLeft, gcBottomRight]
    Appearance.DefaultSectionAppearance.Rounding = 4
    Division.TextWordWrap = True
    Division.TextOrientation = tltoRight
    Fill.Kind = gfkGradient
    Fill.Orientation = gfoHorizontal
    Fill.Color = 7382754
    Fill.ColorTo = 6508721
    Indicators = <
      item
        Appearance.Fill.Color = 11386342
        Appearance.Stroke.Color = clWhite
        Appearance.Stroke.Width = 2.000000000000000000
        Appearance.HoverFill.Color = 11581890
        Appearance.HoverStroke.Color = 11581890
        Appearance.SelectedFill.Color = clWhite
        Appearance.SelectedStroke.Color = 5924990
        Appearance.SelectedStroke.Width = 2.000000000000000000
        Annotation.Appearance.Font.Charset = DEFAULT_CHARSET
        Annotation.Appearance.Font.Color = clWhite
        Annotation.Appearance.Font.Height = -11
        Annotation.Appearance.Font.Name = 'Segoe UI'
        Annotation.Appearance.Font.Style = []
        Annotation.Appearance.HoverFont.Charset = DEFAULT_CHARSET
        Annotation.Appearance.HoverFont.Color = 11581890
        Annotation.Appearance.HoverFont.Height = -11
        Annotation.Appearance.HoverFont.Name = 'Segoe UI'
        Annotation.Appearance.HoverFont.Style = []
        Annotation.Appearance.SelectedFont.Charset = DEFAULT_CHARSET
        Annotation.Appearance.SelectedFont.Color = 5924990
        Annotation.Appearance.SelectedFont.Height = -11
        Annotation.Appearance.SelectedFont.Name = 'Segoe UI'
        Annotation.Appearance.SelectedFont.Style = []
        Annotation.Appearance.Fill.Kind = gfkNone
        Annotation.Appearance.Stroke.Color = clWhite
        Annotation.Appearance.HoverFill.Kind = gfkNone
        Annotation.Appearance.HoverFill.Color = 11386342
        Annotation.Appearance.HoverStroke.Color = 11581890
        Annotation.Appearance.HoverStroke.Width = 2.000000000000000000
        Annotation.Appearance.SelectedFill.Color = clWhite
        Annotation.Appearance.SelectedStroke.Color = 5924990
        Annotation.Appearance.SelectedStroke.Width = 2.000000000000000000
        Annotation.Appearance.TextOrientation = tltoRight
        Annotation.Appearance.TextMargins.Left = 2.000000000000000000
        Annotation.Appearance.TextMargins.Top = 2.000000000000000000
        Annotation.Appearance.TextMargins.Right = 2.000000000000000000
        Annotation.Appearance.TextMargins.Bottom = 2.000000000000000000
        Annotation.Appearance.RoundedCorners = [gcTopLeft, gcTopRight, gcBottomLeft, gcBottomRight]
        Annotation.Appearance.AnnotationLine.Color = clWhite
        Annotation.Text = 'Social Media'
        TimelineValue = 45446.525000000000000000
        TimelineDate = 45446.525000000000000000
      end>
    Layout.Orientation = tloVertical
    Layout.Margins.Left = 10.000000000000000000
    Layout.Margins.Top = 10.000000000000000000
    Layout.Margins.Right = 10.000000000000000000
    Layout.Margins.Bottom = 10.000000000000000000
    Layout.IndicatorHoverBehavior = tlibBoth
    Range.MinimumDate = 45437.000000000000000000
    Range.MaximumDate = 45457.000000000000000000
    AlignWithMargins = True
    Margins.Left = 16
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 16
    Sections = <
      item
        Appearance.Font.Charset = DEFAULT_CHARSET
        Appearance.Font.Color = clWhite
        Appearance.Font.Height = -11
        Appearance.Font.Name = 'Segoe UI'
        Appearance.Font.Style = []
        Appearance.HoverFont.Charset = DEFAULT_CHARSET
        Appearance.HoverFont.Color = clWhite
        Appearance.HoverFont.Height = -11
        Appearance.HoverFont.Name = 'Segoe UI'
        Appearance.HoverFont.Style = []
        Appearance.SelectedFont.Charset = DEFAULT_CHARSET
        Appearance.SelectedFont.Color = clWhite
        Appearance.SelectedFont.Height = -11
        Appearance.SelectedFont.Name = 'Segoe UI'
        Appearance.SelectedFont.Style = []
        Appearance.Fill.Color = 8221159
        Appearance.Stroke.Color = 11907771
        Appearance.HoverFill.Color = 9665498
        Appearance.HoverStroke.Color = 14476013
        Appearance.SelectedFill.Color = 6372267
        Appearance.SelectedStroke.Color = 11581890
        Appearance.TextOrientation = tltoRight
        Appearance.TextMargins.Left = 2.000000000000000000
        Appearance.TextMargins.Top = 5.000000000000000000
        Appearance.TextMargins.Right = 2.000000000000000000
        Appearance.TextMargins.Bottom = 5.000000000000000000
        Appearance.RoundedCorners = [gcTopLeft, gcTopRight, gcBottomLeft, gcBottomRight]
        Appearance.Rounding = 4
        Text = 'Marketing Phase'
        StartTimelineValue = 45443.350000000000000000
        EndTimelineValue = 45449.700000000000000000
        StartTimelineDate = 45443.350000000000000000
        EndTimelineDate = 45449.700000000000000000
      end>
  end
  object TimelinePanel: TTMSFNCPanel
    Left = 292
    Top = 288
    Width = 320
    Height = 600
    Margins.Left = 16
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 16
    AlignWithMargins = True
    Align = alLeft
    TabOrder = 3
    Header.Visible = False
    object TimelineCaption: TTMSFNCHTMLText
      Left = 16
      Top = 12
      Width = 288
      Height = 24
      Margins.Left = 16
      Margins.Top = 12
      Margins.Right = 16
      Margins.Bottom = 0
      AlignWithMargins = True
      Align = alTop
      Font.Height = -15
      Font.Name = 'Segoe UI Semibold'
      HorizontalTextAlign = gtaLeading
      Trimming = gttCharacter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Text = 'Timeline and divisions'
    end
    object TimelinePositionRow: TTMSFNCPanel
      Left = 16
      Top = 44
      Width = 288
      Height = 32
      Margins.Left = 16
      Margins.Top = 8
      Margins.Right = 16
      Margins.Bottom = 0
      AlignWithMargins = True
      Align = alTop
      TabOrder = 0
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Header.Visible = False
      object TimelinePositionLabel: TTMSFNCHTMLText
        Left = 0
        Top = 0
        Width = 112
        Height = 32
        Align = alLeft
        TextRole = htrSecondary
        HorizontalTextAlign = gtaLeading
        Trimming = gttCharacter
        Fill.Kind = gfkNone
        Stroke.Kind = gskNone
        Text = 'Line position'
      end
      object TimelinePositionCombo: TTMSFNCComboBox
        Left = 112
        Top = 0
        Width = 176
        Height = 32
        Align = alClient
        TabOrder = 0
        Style = csDropDownList
        Items.Strings = (
          'Top / left'
          'Middle'
          'Bottom / right')
        ItemIndex = 1
        OnChange = SettingChange
      end
    end
    object DivisionPositionRow: TTMSFNCPanel
      Left = 16
      Top = 84
      Width = 288
      Height = 32
      Margins.Left = 16
      Margins.Top = 8
      Margins.Right = 16
      Margins.Bottom = 0
      AlignWithMargins = True
      Align = alTop
      TabOrder = 1
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Header.Visible = False
      object DivisionPositionLabel: TTMSFNCHTMLText
        Left = 0
        Top = 0
        Width = 112
        Height = 32
        Align = alLeft
        TextRole = htrSecondary
        HorizontalTextAlign = gtaLeading
        Trimming = gttCharacter
        Fill.Kind = gfkNone
        Stroke.Kind = gskNone
        Text = 'Divisions'
      end
      object DivisionPositionCombo: TTMSFNCComboBox
        Left = 112
        Top = 0
        Width = 176
        Height = 32
        Align = alClient
        TabOrder = 0
        Style = csDropDownList
        Items.Strings = (
          'Top / left'
          'Middle'
          'Bottom / right')
        ItemIndex = 1
        OnChange = SettingChange
      end
    end
    object DivisionTextRow: TTMSFNCPanel
      Left = 16
      Top = 124
      Width = 288
      Height = 32
      Margins.Left = 16
      Margins.Top = 8
      Margins.Right = 16
      Margins.Bottom = 0
      AlignWithMargins = True
      Align = alTop
      TabOrder = 2
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Header.Visible = False
      object DivisionTextLabel: TTMSFNCHTMLText
        Left = 0
        Top = 0
        Width = 112
        Height = 32
        Align = alLeft
        TextRole = htrSecondary
        HorizontalTextAlign = gtaLeading
        Trimming = gttCharacter
        Fill.Kind = gfkNone
        Stroke.Kind = gskNone
        Text = 'Division text'
      end
      object DivisionTextCombo: TTMSFNCComboBox
        Left = 112
        Top = 0
        Width = 176
        Height = 32
        Align = alClient
        TabOrder = 0
        Style = csDropDownList
        Items.Strings = (
          'Leading'
          'Center'
          'Trailing')
        ItemIndex = 1
        OnChange = SettingChange
      end
    end
    object DivisionAngleRow: TTMSFNCPanel
      Left = 16
      Top = 164
      Width = 288
      Height = 32
      Margins.Left = 16
      Margins.Top = 8
      Margins.Right = 16
      Margins.Bottom = 0
      AlignWithMargins = True
      Align = alTop
      TabOrder = 3
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Header.Visible = False
      object DivisionAngleLabel: TTMSFNCHTMLText
        Left = 0
        Top = 0
        Width = 112
        Height = 32
        Align = alLeft
        TextRole = htrSecondary
        HorizontalTextAlign = gtaLeading
        Trimming = gttCharacter
        Fill.Kind = gfkNone
        Stroke.Kind = gskNone
        Text = 'Division angle'
      end
      object DivisionAngleCombo: TTMSFNCComboBox
        Left = 112
        Top = 0
        Width = 176
        Height = 32
        Align = alClient
        TabOrder = 0
        Style = csDropDownList
        Items.Strings = (
          'Horizontal'
          'Upside down'
          'Left'
          'Right')
        ItemIndex = 0
        OnChange = SettingChange
      end
    end
  end
  object AnnotationPanel: TTMSFNCPanel
    Left = 628
    Top = 288
    Width = 320
    Height = 600
    Margins.Left = 16
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 16
    AlignWithMargins = True
    Align = alLeft
    TabOrder = 4
    Header.Visible = False
    object AnnotationCaption: TTMSFNCHTMLText
      Left = 16
      Top = 12
      Width = 288
      Height = 24
      Margins.Left = 16
      Margins.Top = 12
      Margins.Right = 16
      Margins.Bottom = 0
      AlignWithMargins = True
      Align = alTop
      Font.Height = -15
      Font.Name = 'Segoe UI Semibold'
      HorizontalTextAlign = gtaLeading
      Trimming = gttCharacter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Text = 'Annotations and sections'
    end
    object AnnotationPositionRow: TTMSFNCPanel
      Left = 16
      Top = 44
      Width = 288
      Height = 32
      Margins.Left = 16
      Margins.Top = 8
      Margins.Right = 16
      Margins.Bottom = 0
      AlignWithMargins = True
      Align = alTop
      TabOrder = 0
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Header.Visible = False
      object AnnotationPositionLabel: TTMSFNCHTMLText
        Left = 0
        Top = 0
        Width = 112
        Height = 32
        Align = alLeft
        TextRole = htrSecondary
        HorizontalTextAlign = gtaLeading
        Trimming = gttCharacter
        Fill.Kind = gfkNone
        Stroke.Kind = gskNone
        Text = 'Annotations'
      end
      object AnnotationPositionCombo: TTMSFNCComboBox
        Left = 112
        Top = 0
        Width = 176
        Height = 32
        Align = alClient
        TabOrder = 0
        Style = csDropDownList
        Items.Strings = (
          'Top / left'
          'Middle'
          'Bottom / right')
        ItemIndex = 0
        OnChange = SettingChange
      end
    end
    object AnnotationAlignRow: TTMSFNCPanel
      Left = 16
      Top = 84
      Width = 288
      Height = 32
      Margins.Left = 16
      Margins.Top = 8
      Margins.Right = 16
      Margins.Bottom = 0
      AlignWithMargins = True
      Align = alTop
      TabOrder = 1
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Header.Visible = False
      object AnnotationAlignLabel: TTMSFNCHTMLText
        Left = 0
        Top = 0
        Width = 112
        Height = 32
        Align = alLeft
        TextRole = htrSecondary
        HorizontalTextAlign = gtaLeading
        Trimming = gttCharacter
        Fill.Kind = gfkNone
        Stroke.Kind = gskNone
        Text = 'Alignment'
      end
      object AnnotationAlignCombo: TTMSFNCComboBox
        Left = 112
        Top = 0
        Width = 176
        Height = 32
        Align = alClient
        TabOrder = 0
        Style = csDropDownList
        Items.Strings = (
          'Leading'
          'Center'
          'Trailing')
        ItemIndex = 1
        OnChange = SettingChange
      end
    end
    object TextHorizontalRow: TTMSFNCPanel
      Left = 16
      Top = 124
      Width = 288
      Height = 32
      Margins.Left = 16
      Margins.Top = 8
      Margins.Right = 16
      Margins.Bottom = 0
      AlignWithMargins = True
      Align = alTop
      TabOrder = 2
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Header.Visible = False
      object TextHorizontalLabel: TTMSFNCHTMLText
        Left = 0
        Top = 0
        Width = 112
        Height = 32
        Align = alLeft
        TextRole = htrSecondary
        HorizontalTextAlign = gtaLeading
        Trimming = gttCharacter
        Fill.Kind = gfkNone
        Stroke.Kind = gskNone
        Text = 'Text horizontal'
      end
      object TextHorizontalCombo: TTMSFNCComboBox
        Left = 112
        Top = 0
        Width = 176
        Height = 32
        Align = alClient
        TabOrder = 0
        Style = csDropDownList
        Items.Strings = (
          'Leading'
          'Center'
          'Trailing')
        ItemIndex = 1
        OnChange = SettingChange
      end
    end
    object TextVerticalRow: TTMSFNCPanel
      Left = 16
      Top = 164
      Width = 288
      Height = 32
      Margins.Left = 16
      Margins.Top = 8
      Margins.Right = 16
      Margins.Bottom = 0
      AlignWithMargins = True
      Align = alTop
      TabOrder = 3
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Header.Visible = False
      object TextVerticalLabel: TTMSFNCHTMLText
        Left = 0
        Top = 0
        Width = 112
        Height = 32
        Align = alLeft
        TextRole = htrSecondary
        HorizontalTextAlign = gtaLeading
        Trimming = gttCharacter
        Fill.Kind = gfkNone
        Stroke.Kind = gskNone
        Text = 'Text vertical'
      end
      object TextVerticalCombo: TTMSFNCComboBox
        Left = 112
        Top = 0
        Width = 176
        Height = 32
        Align = alClient
        TabOrder = 0
        Style = csDropDownList
        Items.Strings = (
          'Leading'
          'Center'
          'Trailing')
        ItemIndex = 1
        OnChange = SettingChange
      end
    end
    object TextAngleRow: TTMSFNCPanel
      Left = 16
      Top = 204
      Width = 288
      Height = 32
      Margins.Left = 16
      Margins.Top = 8
      Margins.Right = 16
      Margins.Bottom = 0
      AlignWithMargins = True
      Align = alTop
      TabOrder = 4
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Header.Visible = False
      object TextAngleLabel: TTMSFNCHTMLText
        Left = 0
        Top = 0
        Width = 112
        Height = 32
        Align = alLeft
        TextRole = htrSecondary
        HorizontalTextAlign = gtaLeading
        Trimming = gttCharacter
        Fill.Kind = gfkNone
        Stroke.Kind = gskNone
        Text = 'Text angle'
      end
      object TextAngleCombo: TTMSFNCComboBox
        Left = 112
        Top = 0
        Width = 176
        Height = 32
        Align = alClient
        TabOrder = 0
        Style = csDropDownList
        Items.Strings = (
          'Horizontal'
          'Upside down'
          'Left'
          'Right')
        ItemIndex = 0
        OnChange = SettingChange
      end
    end
  end
  object ThemeManager: TTMSFNCThemeManager
    Theme = 'Fluent Light'
    Left = 24
    Top = 24
  end
end
