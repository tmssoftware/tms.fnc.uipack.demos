object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Timeline Database Adapter Demo'
  ClientHeight = 440
  ClientWidth = 1170
  OnCreate = FormCreate
  object TMSFNCTimeline1: TTMSFNCTimeline
    Left = 8
    Top = 38
    Width = 1154
    Height = 392
    TabOrder = 0
    Appearance.DivisionFont.Height = -9
    Appearance.DefaultIndicatorAppearance.Stroke.Width = 2.000000000000000000
    Appearance.DefaultIndicatorAppearance.SelectedStroke.Width = 2.000000000000000000
    Appearance.DefaultIndicatorAppearance.Size = 20
    Appearance.DefaultAnnotationAppearance.Font.Color = 4539717
    Appearance.DefaultAnnotationAppearance.HoverFont.Color = 4539717
    Appearance.DefaultAnnotationAppearance.SelectedFont.Color = 4539717
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
        Annotation.Appearance.Font.Color = 4539717
        Annotation.Appearance.HoverFont.Color = 4539717
        Annotation.Appearance.SelectedFont.Color = 4539717
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
  end
  object ConnectBtn: TButton
    Left = 8
    Top = 8
    TabOrder = 1
    Caption = 'Disconnect'
    WordWrap = True
    OnClick = ConnectBtnClick
  end
  object TMSFNCTimelineDatabaseAdapter1: TTMSFNCTimelineDatabaseAdapter
    Width = 39
    Height = 39
    Left = 1008
    Top = 8
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
end
