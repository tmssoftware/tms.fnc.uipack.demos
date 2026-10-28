object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'TMS FNC Theming Dashboard Demo'
  Height = 1277
  Width = 1440
  Position = poScreenCenter
  OnCreate = WebFormCreate
  OnResize = WebFormResize
  object PageHeader: TTMSFNCPanel
    AlignWithMargins = True
    Left = 260
    Top = 80
    Width = 1152
    Height = 52
    Margins.Left = 260
    Margins.Top = 80
    Margins.Right = 28
    Margins.Bottom = 0
    ThemingEnabled = False
    Align = alTop
    TabOrder = 0
    Fill.Kind = gfkNone
    Sections = <>
    Stroke.Kind = gskNone
    Header.Visible = False
    ButtonsAppearance.ButtonAppearance.NormalFill.Color = 14803425
    ButtonsAppearance.ButtonAppearance.NormalStroke.Color = clDarkgray
    ButtonsAppearance.ButtonAppearance.HoverFill.Color = 16511461
    ButtonsAppearance.ButtonAppearance.HoverStroke.Color = 11632444
    ButtonsAppearance.ButtonAppearance.FlatStyle = True
    object PageTitle: TTMSFNCHTMLText
      Left = 0
      Top = 0
      Width = 600
      Height = 32
      Font.Height = -24
      Font.Name = 'Segoe UI Semibold'
      TabOrder = 0
      HorizontalTextAlign = gtaLeading
      Trimming = gttCharacter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Stroke.Color = -1
      Text = 'Overview'
    end
    object PageSubtitle: TTMSFNCHTMLText
      Left = 0
      Top = 32
      Width = 600
      Height = 20
      Font.Height = -13
      TabOrder = 1
      HorizontalTextAlign = gtaLeading
      Trimming = gttCharacter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Stroke.Color = -1
      Text = 'October 2026 '#183' 200 orders'
    end
    object NewOrderButton: TTMSFNCButton
      AlignWithMargins = True
      Left = 1000
      Top = 0
      Width = 104
      Height = 25
      Margins.Left = 0
      Margins.Top = 20
      Margins.Right = 0
      Margins.Bottom = 0
      Text = 'New order'
      Align = alRight
      Default = True
      TabOrder = 2
      OnClick = NewOrderButtonClick
    end
    object ResetButton: TTMSFNCButton
      AlignWithMargins = True
      Left = 100
      Top = 0
      Width = 100
      Height = 25
      Margins.Left = 0
      Margins.Top = 20
      Margins.Right = 12
      Margins.Bottom = 0
      Text = 'Reset data'
      Align = alRight
      TabOrder = 3
      OnClick = ResetButtonClick
    end
  end
  object KpiRow: TTMSFNCPanel
    AlignWithMargins = True
    Left = 258
    Top = 151
    Width = 1156
    Height = 126
    Margins.Left = 258
    Margins.Top = 19
    Margins.Right = 26
    Margins.Bottom = 0
    ThemingEnabled = False
    Align = alTop
    TabOrder = 1
    Fill.Kind = gfkNone
    Sections = <>
    Stroke.Kind = gskNone
    Header.Visible = False
    ButtonsAppearance.ButtonAppearance.NormalFill.Color = 14803425
    ButtonsAppearance.ButtonAppearance.NormalStroke.Color = clDarkgray
    ButtonsAppearance.ButtonAppearance.HoverFill.Color = 16511461
    ButtonsAppearance.ButtonAppearance.HoverStroke.Color = 11632444
    ButtonsAppearance.ButtonAppearance.FlatStyle = True
    object RevenueCard: TTMSFNCPanel
      AlignWithMargins = True
      Left = 0
      Top = 0
      Width = 280
      Height = 126
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 12
      Margins.Bottom = 0
      Align = alLeft
      TabOrder = 0
      Sections = <>
      Header.Visible = False
      ButtonsAppearance.ButtonAppearance.NormalFill.Color = 14803425
      ButtonsAppearance.ButtonAppearance.NormalStroke.Color = clDarkgray
      ButtonsAppearance.ButtonAppearance.HoverFill.Color = 16511461
      ButtonsAppearance.ButtonAppearance.HoverStroke.Color = 11632444
      ButtonsAppearance.ButtonAppearance.FlatStyle = True
      object RevenueTitle: TTMSFNCHTMLText
        Left = 21
        Top = 18
        Width = 238
        Height = 20
        Anchors = [akLeft, akTop, akRight]
        Font.Height = -13
        TabOrder = 0
        HorizontalTextAlign = gtaLeading
        Trimming = gttCharacter
        Fill.Kind = gfkNone
        Stroke.Kind = gskNone
        Stroke.Color = -1
        Text = 'Revenue'
      end
      object RevenueValue: TTMSFNCHTMLText
        Left = 21
        Top = 44
        Width = 238
        Height = 36
        Anchors = [akLeft, akTop, akRight]
        Font.Height = -28
        Font.Name = 'Segoe UI Semibold'
        TabOrder = 1
        HorizontalTextAlign = gtaLeading
        Trimming = gttCharacter
        Fill.Kind = gfkNone
        Stroke.Kind = gskNone
        Stroke.Color = -1
        Text = '$128.4K'
      end
      object RevenueNote: TTMSFNCHTMLText
        Left = 89
        Top = 86
        Width = 170
        Height = 20
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 3
        HorizontalTextAlign = gtaLeading
        Trimming = gttCharacter
        Fill.Kind = gfkNone
        Stroke.Kind = gskNone
        Stroke.Color = -1
        Text = 'vs last month'
      end
      object RevenueDelta: TTMSFNCBadge
        Left = 21
        Top = 86
        Width = 60
        Height = 20
        TabOrder = 2
        Visible = True
        Appearance.DisabledFont.Color = clLightgray
        Appearance.Font.Color = clWhite
        Appearance.Rounding = 15
        AutoSize = True
        Text = '+39.1%'
        Kind = tskSuccess
        Shape = bshPill
      end
    end
    object OpenCard: TTMSFNCPanel
      AlignWithMargins = True
      Left = 292
      Top = 0
      Width = 280
      Height = 126
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 12
      Margins.Bottom = 0
      Align = alLeft
      TabOrder = 1
      Sections = <>
      Header.Visible = False
      ButtonsAppearance.ButtonAppearance.NormalFill.Color = 14803425
      ButtonsAppearance.ButtonAppearance.NormalStroke.Color = clDarkgray
      ButtonsAppearance.ButtonAppearance.HoverFill.Color = 16511461
      ButtonsAppearance.ButtonAppearance.HoverStroke.Color = 11632444
      ButtonsAppearance.ButtonAppearance.FlatStyle = True
      object OpenTitle: TTMSFNCHTMLText
        Left = 21
        Top = 18
        Width = 238
        Height = 20
        Anchors = [akLeft, akTop, akRight]
        Font.Height = -13
        TabOrder = 0
        HorizontalTextAlign = gtaLeading
        Trimming = gttCharacter
        Fill.Kind = gfkNone
        Stroke.Kind = gskNone
        Stroke.Color = -1
        Text = 'Open orders'
      end
      object OpenValue: TTMSFNCHTMLText
        Left = 21
        Top = 44
        Width = 238
        Height = 36
        Anchors = [akLeft, akTop, akRight]
        Font.Height = -28
        Font.Name = 'Segoe UI Semibold'
        TabOrder = 1
        HorizontalTextAlign = gtaLeading
        Trimming = gttCharacter
        Fill.Kind = gfkNone
        Stroke.Kind = gskNone
        Stroke.Color = -1
        Text = '22'
      end
      object OpenNote: TTMSFNCHTMLText
        Left = 89
        Top = 86
        Width = 170
        Height = 20
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 3
        HorizontalTextAlign = gtaLeading
        Trimming = gttCharacter
        Fill.Kind = gfkNone
        Stroke.Kind = gskNone
        Stroke.Color = -1
        Text = 'not shipped yet'
      end
      object OpenDelta: TTMSFNCBadge
        Left = 21
        Top = 86
        Width = 60
        Height = 20
        TabOrder = 2
        Visible = True
        Appearance.DisabledFont.Color = clLightgray
        Appearance.Font.Color = clWhite
        Appearance.Rounding = 15
        AutoSize = True
        Text = '10 late'
        Kind = tskWarning
        Shape = bshPill
      end
    end
    object CustomersCard: TTMSFNCPanel
      AlignWithMargins = True
      Left = 584
      Top = 0
      Width = 280
      Height = 126
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 12
      Margins.Bottom = 0
      Align = alLeft
      TabOrder = 2
      Sections = <>
      Header.Visible = False
      ButtonsAppearance.ButtonAppearance.NormalFill.Color = 14803425
      ButtonsAppearance.ButtonAppearance.NormalStroke.Color = clDarkgray
      ButtonsAppearance.ButtonAppearance.HoverFill.Color = 16511461
      ButtonsAppearance.ButtonAppearance.HoverStroke.Color = 11632444
      ButtonsAppearance.ButtonAppearance.FlatStyle = True
      object CustomersTitle: TTMSFNCHTMLText
        Left = 21
        Top = 18
        Width = 238
        Height = 20
        Anchors = [akLeft, akTop, akRight]
        Font.Height = -13
        TabOrder = 0
        HorizontalTextAlign = gtaLeading
        Trimming = gttCharacter
        Fill.Kind = gfkNone
        Stroke.Kind = gskNone
        Stroke.Color = -1
        Text = 'Customers'
      end
      object CustomersValue: TTMSFNCHTMLText
        Left = 21
        Top = 44
        Width = 238
        Height = 36
        Anchors = [akLeft, akTop, akRight]
        Font.Height = -28
        Font.Name = 'Segoe UI Semibold'
        TabOrder = 1
        HorizontalTextAlign = gtaLeading
        Trimming = gttCharacter
        Fill.Kind = gfkNone
        Stroke.Kind = gskNone
        Stroke.Color = -1
        Text = '20'
      end
      object CustomersNote: TTMSFNCHTMLText
        Left = 89
        Top = 86
        Width = 170
        Height = 20
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 3
        HorizontalTextAlign = gtaLeading
        Trimming = gttCharacter
        Fill.Kind = gfkNone
        Stroke.Kind = gskNone
        Stroke.Color = -1
        Text = 'this month'
      end
      object CustomersDelta: TTMSFNCBadge
        Left = 21
        Top = 86
        Width = 60
        Height = 20
        TabOrder = 2
        Visible = True
        Appearance.DisabledFont.Color = clLightgray
        Appearance.Font.Color = clWhite
        Appearance.Rounding = 15
        AutoSize = True
        Text = '+3 new'
        Kind = tskSuccess
        Shape = bshPill
      end
    end
    object AverageCard: TTMSFNCPanel
      AlignWithMargins = True
      Left = 876
      Top = 0
      Width = 280
      Height = 126
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alClient
      TabOrder = 3
      Sections = <>
      Header.Visible = False
      ButtonsAppearance.ButtonAppearance.NormalFill.Color = 14803425
      ButtonsAppearance.ButtonAppearance.NormalStroke.Color = clDarkgray
      ButtonsAppearance.ButtonAppearance.HoverFill.Color = 16511461
      ButtonsAppearance.ButtonAppearance.HoverStroke.Color = 11632444
      ButtonsAppearance.ButtonAppearance.FlatStyle = True
      object AverageTitle: TTMSFNCHTMLText
        Left = 21
        Top = 18
        Width = 238
        Height = 20
        Anchors = [akLeft, akTop, akRight]
        Font.Height = -13
        TabOrder = 0
        HorizontalTextAlign = gtaLeading
        Trimming = gttCharacter
        Fill.Kind = gfkNone
        Stroke.Kind = gskNone
        Stroke.Color = -1
        Text = 'Average order'
      end
      object AverageValue: TTMSFNCHTMLText
        Left = 21
        Top = 44
        Width = 238
        Height = 36
        Anchors = [akLeft, akTop, akRight]
        Font.Height = -28
        Font.Name = 'Segoe UI Semibold'
        TabOrder = 1
        HorizontalTextAlign = gtaLeading
        Trimming = gttCharacter
        Fill.Kind = gfkNone
        Stroke.Kind = gskNone
        Stroke.Color = -1
        Text = '$3,132'
      end
      object AverageNote: TTMSFNCHTMLText
        Left = 89
        Top = 86
        Width = 170
        Height = 20
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 3
        HorizontalTextAlign = gtaLeading
        Trimming = gttCharacter
        Fill.Kind = gfkNone
        Stroke.Kind = gskNone
        Stroke.Color = -1
        Text = 'vs last month'
      end
      object AverageDelta: TTMSFNCBadge
        Left = 21
        Top = 86
        Width = 60
        Height = 20
        TabOrder = 2
        Visible = True
        Appearance.DisabledFont.Color = clLightgray
        Appearance.Font.Color = clWhite
        Appearance.Rounding = 15
        AutoSize = True
        Text = '+32.3%'
        Kind = tskSuccess
        Shape = bshPill
      end
    end
  end
  object Content: TTMSFNCPanel
    AlignWithMargins = True
    Left = 258
    Top = 294
    Width = 1156
    Height = 922
    Margins.Left = 258
    Margins.Top = 17
    Margins.Right = 26
    Margins.Bottom = 61
    ThemingEnabled = False
    Align = alClient
    TabOrder = 2
    Fill.Kind = gfkNone
    Sections = <>
    Stroke.Kind = gskNone
    Header.Visible = False
    ButtonsAppearance.ButtonAppearance.NormalFill.Color = 14803425
    ButtonsAppearance.ButtonAppearance.NormalStroke.Color = clDarkgray
    ButtonsAppearance.ButtonAppearance.HoverFill.Color = 16511461
    ButtonsAppearance.ButtonAppearance.HoverStroke.Color = 11632444
    ButtonsAppearance.ButtonAppearance.FlatStyle = True
    object RightColumn: TTMSFNCPanel
      AlignWithMargins = True
      Left = 900
      Top = 0
      Width = 324
      Height = 600
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      ThemingEnabled = False
      Align = alRight
      TabOrder = 0
      Fill.Kind = gfkNone
      Sections = <>
      Stroke.Kind = gskNone
      Header.Visible = False
      ButtonsAppearance.ButtonAppearance.NormalFill.Color = 14803425
      ButtonsAppearance.ButtonAppearance.NormalStroke.Color = clDarkgray
      ButtonsAppearance.ButtonAppearance.HoverFill.Color = 16511461
      ButtonsAppearance.ButtonAppearance.HoverStroke.Color = 11632444
      ButtonsAppearance.ButtonAppearance.FlatStyle = True
      object DetailsCard: TTMSFNCPanel
        AlignWithMargins = True
        Left = 0
        Top = 0
        Width = 324
        Height = 404
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        TabOrder = 0
        Sections = <>
        Header.Text = 'Order #10439'
        Header.Size = 57.000000000000000000
        ButtonsAppearance.ButtonAppearance.NormalFill.Color = 14803425
        ButtonsAppearance.ButtonAppearance.NormalStroke.Color = clDarkgray
        ButtonsAppearance.ButtonAppearance.HoverFill.Color = 16511461
        ButtonsAppearance.ButtonAppearance.HoverStroke.Color = 11632444
        ButtonsAppearance.ButtonAppearance.FlatStyle = True
        object CustomerLabel: TTMSFNCHTMLText
          Left = 21
          Top = 56
          Width = 282
          Height = 20
          Anchors = [akLeft, akTop, akRight]
          Font.Height = -13
          Font.Name = 'Segoe UI Semibold'
          TabOrder = 1
          HorizontalTextAlign = gtaLeading
          Trimming = gttCharacter
          Fill.Kind = gfkNone
          Stroke.Kind = gskNone
          Stroke.Color = -1
          Text = 'Customer'
        end
        object CustomerCombo: TTMSFNCComboBox
          Left = 21
          Top = 82
          Width = 282
          Height = 32
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 2
          DropDownWidth = 150.000000000000000000
          ItemHeight = 16.000000000000000000
          Text = ''
          ItemAppearance.ShowFocus = False
          ItemAppearance.ExpandColumn = -1
          ItemAppearance.FixedHeight = 16.000000000000000000
          ItemAppearance.VariableMinimumHeight = 25.000000000000000000
          ItemAppearance.ShowLines = False
          ItemAppearance.SelectionArea = tsaFull
          Appearance.Stroke.Color = clDarkgray
          Appearance.Fill.Color = 15329769
          Appearance.StrokeHover.Color = clLightslategray
          Appearance.FillHover.Color = 13419707
          Appearance.StrokeDown.Color = clSlategray
          Appearance.FillDown.Color = 13156536
          Appearance.StrokeSelected.Color = clDarkslategray
          Appearance.FillSelected.Color = 13156536
          Appearance.StrokeDisabled.Color = clDarkgray
          Appearance.FillDisabled.Color = clSilver
          Appearance.SeparatorStroke.Color = clDarkgray
        end
        object DateLabel: TTMSFNCHTMLText
          Left = 21
          Top = 128
          Width = 135
          Height = 20
          Font.Height = -13
          Font.Name = 'Segoe UI Semibold'
          TabOrder = 3
          HorizontalTextAlign = gtaLeading
          Trimming = gttCharacter
          Fill.Kind = gfkNone
          Stroke.Kind = gskNone
          Stroke.Color = -1
          Text = 'Order date'
        end
        object DatePicker: TTMSFNCDatePicker
          Left = 21
          Top = 154
          Width = 135
          Height = 32
          TabOrder = 4
          FirstDay = 1
          Events = <>
          BadgeSize = 14
          Header.Arrow.ArrowLeftBitmap = <>
          Header.Arrow.ArrowRightBitmap = <>
          DropDownWidth = 200.000000000000000000
          DropDownHeight = 180.000000000000000000
          OnDateSelected = DatePickerDateSelected
          SelectedDate = 46323.000000000000000000
          DateAppearance.SelectedFont.Color = clWhite
          DateAppearance.DisabledFont.Color = clLightgray
          DateAppearance.DateBeforeFont.Color = clMedGray
          DateAppearance.DateAfterFont.Color = clMedGray
          DateAppearance.TodayFont.Color = clRed
          DateAppearance.BadgeFont.Color = clWhite
          DateAppearance.BadgeFont.Height = -9
        end
        object AmountLabel: TTMSFNCHTMLText
          Left = 168
          Top = 128
          Width = 135
          Height = 20
          Font.Height = -13
          Font.Name = 'Segoe UI Semibold'
          TabOrder = 5
          HorizontalTextAlign = gtaLeading
          Trimming = gttCharacter
          Fill.Kind = gfkNone
          Stroke.Kind = gskNone
          Stroke.Color = -1
          Text = 'Total ($)'
        end
        object AmountEdit: TTMSFNCEdit
          Left = 168
          Top = 154
          Width = 135
          Height = 32
          TabOrder = 6
          Text = '0,00'
          EditType = etFloat
          Lookup.Separator = ';'
          Precision = 2
        end
        object StatusLabel: TTMSFNCHTMLText
          Left = 21
          Top = 200
          Width = 135
          Height = 20
          Font.Height = -13
          Font.Name = 'Segoe UI Semibold'
          TabOrder = 7
          HorizontalTextAlign = gtaLeading
          Trimming = gttCharacter
          Fill.Kind = gfkNone
          Stroke.Kind = gskNone
          Stroke.Color = -1
          Text = 'Status'
        end
        object StatusCombo: TTMSFNCComboBox
          Left = 21
          Top = 226
          Width = 135
          Height = 32
          TabOrder = 8
          DropDownWidth = 150.000000000000000000
          Items.Strings = (
            'Open'
            'Packing'
            'Shipped'
            'Late')
          ItemIndex = 0
          ItemHeight = 16.000000000000000000
          Style = csDropDownList
          Text = 'Open'
          ItemAppearance.ShowFocus = False
          ItemAppearance.ExpandColumn = -1
          ItemAppearance.FixedHeight = 16.000000000000000000
          ItemAppearance.VariableMinimumHeight = 25.000000000000000000
          ItemAppearance.ShowLines = False
          ItemAppearance.SelectionArea = tsaFull
          Appearance.Stroke.Color = clDarkgray
          Appearance.Fill.Color = 15329769
          Appearance.StrokeHover.Color = clLightslategray
          Appearance.FillHover.Color = 13419707
          Appearance.StrokeDown.Color = clSlategray
          Appearance.FillDown.Color = 13156536
          Appearance.StrokeSelected.Color = clDarkslategray
          Appearance.FillSelected.Color = 13156536
          Appearance.StrokeDisabled.Color = clDarkgray
          Appearance.FillDisabled.Color = clSilver
          Appearance.SeparatorStroke.Color = clDarkgray
        end
        object ExpressCheck: TTMSFNCCheckBox
          Left = 168
          Top = 232
          Width = 135
          Height = 20
          TabOrder = 9
          Text = 'Express'
        end
        object FulfilmentLabel: TTMSFNCHTMLText
          Left = 21
          Top = 272
          Width = 222
          Height = 20
          Font.Height = -13
          Font.Name = 'Segoe UI Semibold'
          TabOrder = 10
          HorizontalTextAlign = gtaLeading
          Trimming = gttCharacter
          Fill.Kind = gfkNone
          Stroke.Kind = gskNone
          Stroke.Color = -1
          Text = 'Fulfilment'
        end
        object FulfilmentValue: TTMSFNCHTMLText
          Left = 243
          Top = 272
          Width = 60
          Height = 20
          Anchors = [akTop, akRight]
          Font.Height = -13
          TabOrder = 11
          HorizontalTextAlign = gtaTrailing
          Trimming = gttCharacter
          Fill.Kind = gfkNone
          Stroke.Kind = gskNone
          Stroke.Color = -1
          Text = '10%'
        end
        object FulfilmentBar: TTMSFNCTrackBar
          Left = 17
          Top = 300
          Width = 291
          Height = 18
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 12
          Value = 10.000000000000000000
          OnValueChanged = FulfilmentBarValueChanged
        end
        object DeleteButton: TTMSFNCButton
          Left = 21
          Top = 350
          Width = 80
          Height = 32
          Text = 'Delete'
          TabOrder = 13
          OnClick = DeleteButtonClick
        end
        object SaveButton: TTMSFNCButton
          Left = 231
          Top = 350
          Width = 72
          Height = 32
          Text = 'Save'
          Anchors = [akTop, akRight]
          Default = True
          TabOrder = 14
          OnClick = SaveButtonClick
        end
        object CancelButton: TTMSFNCButton
          Left = 139
          Top = 350
          Width = 84
          Height = 32
          Text = 'Cancel'
          Anchors = [akTop, akRight]
          TabOrder = 15
          OnClick = CancelButtonClick
        end
        object DetailsStatus: TTMSFNCBadge
          Left = 224
          Top = 19
          Width = 80
          Height = 20
          Anchors = [akTop, akRight]
          TabOrder = 0
          Visible = True
          Appearance.DisabledFont.Color = clLightgray
          Appearance.Font.Color = clWhite
          Appearance.Rounding = 15
          Text = 'Open'
          Kind = tskInfo
          Shape = bshPill
          ShowDot = True
        end
      end
      object GoalsCard: TTMSFNCPanel
        AlignWithMargins = True
        Left = 0
        Top = 416
        Width = 324
        Height = 206
        Margins.Left = 0
        Margins.Top = 12
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        TabOrder = 1
        Sections = <>
        Header.Text = 'Quarterly goals'
        Header.Size = 57.000000000000000000
        ButtonsAppearance.ButtonAppearance.NormalFill.Color = 14803425
        ButtonsAppearance.ButtonAppearance.NormalStroke.Color = clDarkgray
        ButtonsAppearance.ButtonAppearance.HoverFill.Color = 16511461
        ButtonsAppearance.ButtonAppearance.HoverStroke.Color = 11632444
        ButtonsAppearance.ButtonAppearance.FlatStyle = True
        object RevenueGoalLabel: TTMSFNCHTMLText
          Left = 21
          Top = 56
          Width = 222
          Height = 20
          Anchors = [akLeft, akTop, akRight]
          Font.Height = -13
          TabOrder = 0
          HorizontalTextAlign = gtaLeading
          Trimming = gttCharacter
          Fill.Kind = gfkNone
          Stroke.Kind = gskNone
          Stroke.Color = -1
          Text = 'Revenue target'
        end
        object RevenueGoalValue: TTMSFNCHTMLText
          Left = 243
          Top = 56
          Width = 60
          Height = 20
          Anchors = [akTop, akRight]
          Font.Height = -13
          TabOrder = 1
          HorizontalTextAlign = gtaTrailing
          Trimming = gttCharacter
          Fill.Kind = gfkNone
          Stroke.Kind = gskNone
          Stroke.Color = -1
          Text = '71%'
        end
        object RevenueGoalBar: TTMSFNCProgressBar
          Left = 21
          Top = 82
          Width = 282
          Height = 8
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 2
          Layout.ShowValue = False
          Levels = <>
          Maximum = 100.000000000000000000
          Minimum = 0.000000000000000000
          CustomValue = ''
          Value = 71.000000000000000000
        end
        object OnTimeGoalLabel: TTMSFNCHTMLText
          Left = 21
          Top = 104
          Width = 222
          Height = 20
          Anchors = [akLeft, akTop, akRight]
          Font.Height = -13
          TabOrder = 3
          HorizontalTextAlign = gtaLeading
          Trimming = gttCharacter
          Fill.Kind = gfkNone
          Stroke.Kind = gskNone
          Stroke.Color = -1
          Text = 'On-time delivery'
        end
        object OnTimeGoalValue: TTMSFNCHTMLText
          Left = 243
          Top = 104
          Width = 60
          Height = 20
          Anchors = [akTop, akRight]
          Font.Height = -13
          TabOrder = 4
          HorizontalTextAlign = gtaTrailing
          Trimming = gttCharacter
          Fill.Kind = gfkNone
          Stroke.Kind = gskNone
          Stroke.Color = -1
          Text = '83%'
        end
        object OnTimeGoalBar: TTMSFNCProgressBar
          Left = 21
          Top = 130
          Width = 282
          Height = 8
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 5
          Layout.ShowValue = False
          Levels = <>
          Maximum = 100.000000000000000000
          Minimum = 0.000000000000000000
          CustomValue = ''
          Value = 83.000000000000000000
        end
        object RetentionGoalLabel: TTMSFNCHTMLText
          Left = 21
          Top = 152
          Width = 222
          Height = 20
          Anchors = [akLeft, akTop, akRight]
          Font.Height = -13
          TabOrder = 6
          HorizontalTextAlign = gtaLeading
          Trimming = gttCharacter
          Fill.Kind = gfkNone
          Stroke.Kind = gskNone
          Stroke.Color = -1
          Text = 'Customer retention'
        end
        object RetentionGoalValue: TTMSFNCHTMLText
          Left = 243
          Top = 152
          Width = 60
          Height = 20
          Anchors = [akTop, akRight]
          Font.Height = -13
          TabOrder = 7
          HorizontalTextAlign = gtaTrailing
          Trimming = gttCharacter
          Fill.Kind = gfkNone
          Stroke.Kind = gskNone
          Stroke.Color = -1
          Text = '76%'
        end
        object RetentionGoalBar: TTMSFNCProgressBar
          Left = 21
          Top = 178
          Width = 282
          Height = 8
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 8
          Layout.ShowValue = False
          Levels = <>
          Maximum = 100.000000000000000000
          Minimum = 0.000000000000000000
          CustomValue = ''
          Value = 76.000000000000000000
        end
      end
    end
    object LeftColumn: TTMSFNCPanel
      AlignWithMargins = True
      Left = 0
      Top = 0
      Width = 820
      Height = 922
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 12
      Margins.Bottom = 0
      ThemingEnabled = False
      Align = alClient
      TabOrder = 1
      Fill.Kind = gfkNone
      Sections = <>
      Stroke.Kind = gskNone
      Header.Visible = False
      ButtonsAppearance.ButtonAppearance.NormalFill.Color = 14803425
      ButtonsAppearance.ButtonAppearance.NormalStroke.Color = clDarkgray
      ButtonsAppearance.ButtonAppearance.HoverFill.Color = 16511461
      ButtonsAppearance.ButtonAppearance.HoverStroke.Color = 11632444
      ButtonsAppearance.ButtonAppearance.FlatStyle = True
      object OrdersCard: TTMSFNCPanel
        AlignWithMargins = True
        Left = 0
        Top = 0
        Width = 820
        Height = 636
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 12
        Align = alClient
        TabOrder = 0
        Sections = <>
        Header.Text = 'Orders'
        Header.Size = 62.000000000000000000
        Header.ActionSpacing = 12.000000000000000000
        Footer.Text = '200 orders'
        Footer.Size = 41.000000000000000000
        Footer.Visible = True
        Footer.ShowDivider = False
        ButtonsAppearance.ButtonAppearance.NormalFill.Color = 14803425
        ButtonsAppearance.ButtonAppearance.NormalStroke.Color = clDarkgray
        ButtonsAppearance.ButtonAppearance.HoverFill.Color = 16511461
        ButtonsAppearance.ButtonAppearance.HoverStroke.Color = 11632444
        ButtonsAppearance.ButtonAppearance.FlatStyle = True
        object FilterChips: TTMSFNCSegmentedControl
          Left = 269
          Top = 18
          Width = 319
          Height = 28
          Anchors = [akTop, akRight]
          TabOrder = 0
          SegmentAppearance.Font.Color = 7365723
          SegmentAppearance.SelectedFont.Color = 2630431
          ChipAppearance.Font.Color = 2630431
          ChipAppearance.Font.Height = -13
          ChipAppearance.SelectedFont.Color = 11428622
          ChipAppearance.SelectedFont.Height = -13
          ChipAppearance.SelectedFont.Name = 'Segoe UI Semibold'
          Items = <
            item
              Text = 'All'
              Bitmaps = <>
              Selected = True
            end
            item
              Text = 'Open'
              Bitmaps = <>
            end
            item
              Text = 'Packing'
              Bitmaps = <>
            end
            item
              Text = 'Shipped'
              Bitmaps = <>
            end
            item
              Text = 'Late'
              Bitmaps = <>
            end>
          Style = scsChips
          OnAfterSelectItem = FilterChipsAfterSelectItem
        end
        object SearchEdit: TTMSFNCEditButton
          Left = 600
          Top = 16
          Width = 200
          Height = 32
          Anchors = [akTop, akRight]
          TabOrder = 1
          Bitmap.ThemeTint = bttTextSecondary
          ButtonSize = 30
          ButtonPosition = ebpLeft
          Text = ''
        end
        object OrdersGrid: TTMSFNCDataGrid
          AlignWithMargins = True
          Left = 3
          Top = 63
          Width = 814
          Height = 528
          Margins.Top = 1
          Align = alClient
          TabOrder = 2
          ShowAcceleratorChar = False
          Footer.Bar.Buttons = <>
          Header.VisualGrouping.Layout.TextMargins.Left = 3.000000000000000000
          Header.VisualGrouping.Layout.TextMargins.Top = 3.000000000000000000
          Header.VisualGrouping.Layout.TextMargins.Right = 3.000000000000000000
          Header.VisualGrouping.Layout.TextMargins.Bottom = 3.000000000000000000
          Header.Bar.Buttons = <>
          Adapter = GridAdapter
          CellAppearance.FilterMatchLayout.TextMargins.Left = 3.000000000000000000
          CellAppearance.FilterMatchLayout.TextMargins.Top = 3.000000000000000000
          CellAppearance.FilterMatchLayout.TextMargins.Right = 3.000000000000000000
          CellAppearance.FilterMatchLayout.TextMargins.Bottom = 3.000000000000000000
          CellAppearance.FilterInverseMatchLayout.TextMargins.Left = 3.000000000000000000
          CellAppearance.FilterInverseMatchLayout.TextMargins.Top = 3.000000000000000000
          CellAppearance.FilterInverseMatchLayout.TextMargins.Right = 3.000000000000000000
          CellAppearance.FilterInverseMatchLayout.TextMargins.Bottom = 3.000000000000000000
          CellAppearance.BandLayout.TextMargins.Left = 3.000000000000000000
          CellAppearance.BandLayout.TextMargins.Top = 3.000000000000000000
          CellAppearance.BandLayout.TextMargins.Right = 3.000000000000000000
          CellAppearance.BandLayout.TextMargins.Bottom = 3.000000000000000000
          CellAppearance.FixedLayout.TextMargins.Left = 3.000000000000000000
          CellAppearance.FixedLayout.TextMargins.Top = 3.000000000000000000
          CellAppearance.FixedLayout.TextMargins.Right = 3.000000000000000000
          CellAppearance.FixedLayout.TextMargins.Bottom = 3.000000000000000000
          CellAppearance.FixedSelectedLayout.TextMargins.Left = 3.000000000000000000
          CellAppearance.FixedSelectedLayout.TextMargins.Top = 3.000000000000000000
          CellAppearance.FixedSelectedLayout.TextMargins.Right = 3.000000000000000000
          CellAppearance.FixedSelectedLayout.TextMargins.Bottom = 3.000000000000000000
          CellAppearance.FocusedLayout.TextMargins.Left = 3.000000000000000000
          CellAppearance.FocusedLayout.TextMargins.Top = 3.000000000000000000
          CellAppearance.FocusedLayout.TextMargins.Right = 3.000000000000000000
          CellAppearance.FocusedLayout.TextMargins.Bottom = 3.000000000000000000
          CellAppearance.GroupLayout.TextMargins.Left = 3.000000000000000000
          CellAppearance.GroupLayout.TextMargins.Top = 3.000000000000000000
          CellAppearance.GroupLayout.TextMargins.Right = 3.000000000000000000
          CellAppearance.GroupLayout.TextMargins.Bottom = 3.000000000000000000
          CellAppearance.NormalLayout.TextMargins.Left = 3.000000000000000000
          CellAppearance.NormalLayout.TextMargins.Top = 3.000000000000000000
          CellAppearance.NormalLayout.TextMargins.Right = 3.000000000000000000
          CellAppearance.NormalLayout.TextMargins.Bottom = 3.000000000000000000
          CellAppearance.SelectedLayout.TextMargins.Left = 3.000000000000000000
          CellAppearance.SelectedLayout.TextMargins.Top = 3.000000000000000000
          CellAppearance.SelectedLayout.TextMargins.Right = 3.000000000000000000
          CellAppearance.SelectedLayout.TextMargins.Bottom = 3.000000000000000000
          CellAppearance.SummaryLayout.TextMargins.Left = 3.000000000000000000
          CellAppearance.SummaryLayout.TextMargins.Top = 3.000000000000000000
          CellAppearance.SummaryLayout.TextMargins.Right = 3.000000000000000000
          CellAppearance.SummaryLayout.TextMargins.Bottom = 3.000000000000000000
          ColumnCount = 6
          ConditionalFormatting = <>
          Columns = <
            item
              Appearance.FilterMatchLayout.TextMargins.Left = 3.000000000000000000
              Appearance.FilterMatchLayout.TextMargins.Top = 3.000000000000000000
              Appearance.FilterMatchLayout.TextMargins.Right = 3.000000000000000000
              Appearance.FilterMatchLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.FilterInverseMatchLayout.TextMargins.Left = 3.000000000000000000
              Appearance.FilterInverseMatchLayout.TextMargins.Top = 3.000000000000000000
              Appearance.FilterInverseMatchLayout.TextMargins.Right = 3.000000000000000000
              Appearance.FilterInverseMatchLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.BandLayout.TextMargins.Left = 3.000000000000000000
              Appearance.BandLayout.TextMargins.Top = 3.000000000000000000
              Appearance.BandLayout.TextMargins.Right = 3.000000000000000000
              Appearance.BandLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.FixedLayout.TextMargins.Left = 3.000000000000000000
              Appearance.FixedLayout.TextMargins.Top = 3.000000000000000000
              Appearance.FixedLayout.TextMargins.Right = 3.000000000000000000
              Appearance.FixedLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.FixedSelectedLayout.TextMargins.Left = 3.000000000000000000
              Appearance.FixedSelectedLayout.TextMargins.Top = 3.000000000000000000
              Appearance.FixedSelectedLayout.TextMargins.Right = 3.000000000000000000
              Appearance.FixedSelectedLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.FocusedLayout.TextMargins.Left = 3.000000000000000000
              Appearance.FocusedLayout.TextMargins.Top = 3.000000000000000000
              Appearance.FocusedLayout.TextMargins.Right = 3.000000000000000000
              Appearance.FocusedLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.GroupLayout.TextMargins.Left = 3.000000000000000000
              Appearance.GroupLayout.TextMargins.Top = 3.000000000000000000
              Appearance.GroupLayout.TextMargins.Right = 3.000000000000000000
              Appearance.GroupLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.NormalLayout.TextMargins.Left = 3.000000000000000000
              Appearance.NormalLayout.TextMargins.Top = 3.000000000000000000
              Appearance.NormalLayout.TextMargins.Right = 3.000000000000000000
              Appearance.NormalLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.SelectedLayout.TextMargins.Left = 3.000000000000000000
              Appearance.SelectedLayout.TextMargins.Top = 3.000000000000000000
              Appearance.SelectedLayout.TextMargins.Right = 3.000000000000000000
              Appearance.SelectedLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.SummaryLayout.TextMargins.Left = 3.000000000000000000
              Appearance.SummaryLayout.TextMargins.Top = 3.000000000000000000
              Appearance.SummaryLayout.TextMargins.Right = 3.000000000000000000
              Appearance.SummaryLayout.TextMargins.Bottom = 3.000000000000000000
              Header = 'Order'
              Width = 112.000000000000000000
            end
            item
              Appearance.FilterMatchLayout.TextMargins.Left = 3.000000000000000000
              Appearance.FilterMatchLayout.TextMargins.Top = 3.000000000000000000
              Appearance.FilterMatchLayout.TextMargins.Right = 3.000000000000000000
              Appearance.FilterMatchLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.FilterInverseMatchLayout.TextMargins.Left = 3.000000000000000000
              Appearance.FilterInverseMatchLayout.TextMargins.Top = 3.000000000000000000
              Appearance.FilterInverseMatchLayout.TextMargins.Right = 3.000000000000000000
              Appearance.FilterInverseMatchLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.BandLayout.TextMargins.Left = 3.000000000000000000
              Appearance.BandLayout.TextMargins.Top = 3.000000000000000000
              Appearance.BandLayout.TextMargins.Right = 3.000000000000000000
              Appearance.BandLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.FixedLayout.TextMargins.Left = 3.000000000000000000
              Appearance.FixedLayout.TextMargins.Top = 3.000000000000000000
              Appearance.FixedLayout.TextMargins.Right = 3.000000000000000000
              Appearance.FixedLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.FixedSelectedLayout.TextMargins.Left = 3.000000000000000000
              Appearance.FixedSelectedLayout.TextMargins.Top = 3.000000000000000000
              Appearance.FixedSelectedLayout.TextMargins.Right = 3.000000000000000000
              Appearance.FixedSelectedLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.FocusedLayout.TextMargins.Left = 3.000000000000000000
              Appearance.FocusedLayout.TextMargins.Top = 3.000000000000000000
              Appearance.FocusedLayout.TextMargins.Right = 3.000000000000000000
              Appearance.FocusedLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.GroupLayout.TextMargins.Left = 3.000000000000000000
              Appearance.GroupLayout.TextMargins.Top = 3.000000000000000000
              Appearance.GroupLayout.TextMargins.Right = 3.000000000000000000
              Appearance.GroupLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.NormalLayout.TextMargins.Left = 3.000000000000000000
              Appearance.NormalLayout.TextMargins.Top = 3.000000000000000000
              Appearance.NormalLayout.TextMargins.Right = 3.000000000000000000
              Appearance.NormalLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.SelectedLayout.TextMargins.Left = 3.000000000000000000
              Appearance.SelectedLayout.TextMargins.Top = 3.000000000000000000
              Appearance.SelectedLayout.TextMargins.Right = 3.000000000000000000
              Appearance.SelectedLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.SummaryLayout.TextMargins.Left = 3.000000000000000000
              Appearance.SummaryLayout.TextMargins.Top = 3.000000000000000000
              Appearance.SummaryLayout.TextMargins.Right = 3.000000000000000000
              Appearance.SummaryLayout.TextMargins.Bottom = 3.000000000000000000
              Header = 'Customer'
              Width = 212.000000000000000000
            end
            item
              Appearance.FilterMatchLayout.TextMargins.Left = 3.000000000000000000
              Appearance.FilterMatchLayout.TextMargins.Top = 3.000000000000000000
              Appearance.FilterMatchLayout.TextMargins.Right = 3.000000000000000000
              Appearance.FilterMatchLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.FilterInverseMatchLayout.TextMargins.Left = 3.000000000000000000
              Appearance.FilterInverseMatchLayout.TextMargins.Top = 3.000000000000000000
              Appearance.FilterInverseMatchLayout.TextMargins.Right = 3.000000000000000000
              Appearance.FilterInverseMatchLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.BandLayout.TextMargins.Left = 3.000000000000000000
              Appearance.BandLayout.TextMargins.Top = 3.000000000000000000
              Appearance.BandLayout.TextMargins.Right = 3.000000000000000000
              Appearance.BandLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.FixedLayout.TextMargins.Left = 3.000000000000000000
              Appearance.FixedLayout.TextMargins.Top = 3.000000000000000000
              Appearance.FixedLayout.TextMargins.Right = 3.000000000000000000
              Appearance.FixedLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.FixedSelectedLayout.TextMargins.Left = 3.000000000000000000
              Appearance.FixedSelectedLayout.TextMargins.Top = 3.000000000000000000
              Appearance.FixedSelectedLayout.TextMargins.Right = 3.000000000000000000
              Appearance.FixedSelectedLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.FocusedLayout.TextMargins.Left = 3.000000000000000000
              Appearance.FocusedLayout.TextMargins.Top = 3.000000000000000000
              Appearance.FocusedLayout.TextMargins.Right = 3.000000000000000000
              Appearance.FocusedLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.GroupLayout.TextMargins.Left = 3.000000000000000000
              Appearance.GroupLayout.TextMargins.Top = 3.000000000000000000
              Appearance.GroupLayout.TextMargins.Right = 3.000000000000000000
              Appearance.GroupLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.NormalLayout.TextMargins.Left = 3.000000000000000000
              Appearance.NormalLayout.TextMargins.Top = 3.000000000000000000
              Appearance.NormalLayout.TextMargins.Right = 3.000000000000000000
              Appearance.NormalLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.SelectedLayout.TextMargins.Left = 3.000000000000000000
              Appearance.SelectedLayout.TextMargins.Top = 3.000000000000000000
              Appearance.SelectedLayout.TextMargins.Right = 3.000000000000000000
              Appearance.SelectedLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.SummaryLayout.TextMargins.Left = 3.000000000000000000
              Appearance.SummaryLayout.TextMargins.Top = 3.000000000000000000
              Appearance.SummaryLayout.TextMargins.Right = 3.000000000000000000
              Appearance.SummaryLayout.TextMargins.Bottom = 3.000000000000000000
              Header = 'Date'
              Width = 88.000000000000000000
            end
            item
              Appearance.FilterMatchLayout.TextMargins.Left = 3.000000000000000000
              Appearance.FilterMatchLayout.TextMargins.Top = 3.000000000000000000
              Appearance.FilterMatchLayout.TextMargins.Right = 3.000000000000000000
              Appearance.FilterMatchLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.FilterInverseMatchLayout.TextMargins.Left = 3.000000000000000000
              Appearance.FilterInverseMatchLayout.TextMargins.Top = 3.000000000000000000
              Appearance.FilterInverseMatchLayout.TextMargins.Right = 3.000000000000000000
              Appearance.FilterInverseMatchLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.BandLayout.TextMargins.Left = 3.000000000000000000
              Appearance.BandLayout.TextMargins.Top = 3.000000000000000000
              Appearance.BandLayout.TextMargins.Right = 3.000000000000000000
              Appearance.BandLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.FixedLayout.TextMargins.Left = 3.000000000000000000
              Appearance.FixedLayout.TextMargins.Top = 3.000000000000000000
              Appearance.FixedLayout.TextMargins.Right = 3.000000000000000000
              Appearance.FixedLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.FixedSelectedLayout.TextMargins.Left = 3.000000000000000000
              Appearance.FixedSelectedLayout.TextMargins.Top = 3.000000000000000000
              Appearance.FixedSelectedLayout.TextMargins.Right = 3.000000000000000000
              Appearance.FixedSelectedLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.FocusedLayout.TextMargins.Left = 3.000000000000000000
              Appearance.FocusedLayout.TextMargins.Top = 3.000000000000000000
              Appearance.FocusedLayout.TextMargins.Right = 3.000000000000000000
              Appearance.FocusedLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.GroupLayout.TextMargins.Left = 3.000000000000000000
              Appearance.GroupLayout.TextMargins.Top = 3.000000000000000000
              Appearance.GroupLayout.TextMargins.Right = 3.000000000000000000
              Appearance.GroupLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.NormalLayout.TextMargins.Left = 3.000000000000000000
              Appearance.NormalLayout.TextMargins.Top = 3.000000000000000000
              Appearance.NormalLayout.TextMargins.Right = 3.000000000000000000
              Appearance.NormalLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.SelectedLayout.TextMargins.Left = 3.000000000000000000
              Appearance.SelectedLayout.TextMargins.Top = 3.000000000000000000
              Appearance.SelectedLayout.TextMargins.Right = 3.000000000000000000
              Appearance.SelectedLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.SummaryLayout.TextMargins.Left = 3.000000000000000000
              Appearance.SummaryLayout.TextMargins.Top = 3.000000000000000000
              Appearance.SummaryLayout.TextMargins.Right = 3.000000000000000000
              Appearance.SummaryLayout.TextMargins.Bottom = 3.000000000000000000
              Header = 'Total'
              Width = 112.000000000000000000
            end
            item
              Type = gcitDataStatus
              Appearance.FilterMatchLayout.TextMargins.Left = 3.000000000000000000
              Appearance.FilterMatchLayout.TextMargins.Top = 3.000000000000000000
              Appearance.FilterMatchLayout.TextMargins.Right = 3.000000000000000000
              Appearance.FilterMatchLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.FilterInverseMatchLayout.TextMargins.Left = 3.000000000000000000
              Appearance.FilterInverseMatchLayout.TextMargins.Top = 3.000000000000000000
              Appearance.FilterInverseMatchLayout.TextMargins.Right = 3.000000000000000000
              Appearance.FilterInverseMatchLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.BandLayout.TextMargins.Left = 3.000000000000000000
              Appearance.BandLayout.TextMargins.Top = 3.000000000000000000
              Appearance.BandLayout.TextMargins.Right = 3.000000000000000000
              Appearance.BandLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.FixedLayout.TextMargins.Left = 3.000000000000000000
              Appearance.FixedLayout.TextMargins.Top = 3.000000000000000000
              Appearance.FixedLayout.TextMargins.Right = 3.000000000000000000
              Appearance.FixedLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.FixedSelectedLayout.TextMargins.Left = 3.000000000000000000
              Appearance.FixedSelectedLayout.TextMargins.Top = 3.000000000000000000
              Appearance.FixedSelectedLayout.TextMargins.Right = 3.000000000000000000
              Appearance.FixedSelectedLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.FocusedLayout.TextMargins.Left = 3.000000000000000000
              Appearance.FocusedLayout.TextMargins.Top = 3.000000000000000000
              Appearance.FocusedLayout.TextMargins.Right = 3.000000000000000000
              Appearance.FocusedLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.GroupLayout.TextMargins.Left = 3.000000000000000000
              Appearance.GroupLayout.TextMargins.Top = 3.000000000000000000
              Appearance.GroupLayout.TextMargins.Right = 3.000000000000000000
              Appearance.GroupLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.NormalLayout.TextMargins.Left = 3.000000000000000000
              Appearance.NormalLayout.TextMargins.Top = 3.000000000000000000
              Appearance.NormalLayout.TextMargins.Right = 3.000000000000000000
              Appearance.NormalLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.SelectedLayout.TextMargins.Left = 3.000000000000000000
              Appearance.SelectedLayout.TextMargins.Top = 3.000000000000000000
              Appearance.SelectedLayout.TextMargins.Right = 3.000000000000000000
              Appearance.SelectedLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.SummaryLayout.TextMargins.Left = 3.000000000000000000
              Appearance.SummaryLayout.TextMargins.Top = 3.000000000000000000
              Appearance.SummaryLayout.TextMargins.Right = 3.000000000000000000
              Appearance.SummaryLayout.TextMargins.Bottom = 3.000000000000000000
              Header = 'Status'
              Settings = [gcsType]
              TypeRange = gcirNormal
              Width = 140.000000000000000000
              StatusValues.Strings = (
                'Open=Info'
                'Packing=Warning'
                'Shipped=Success'
                'Late=Error')
            end
            item
              Type = gcitDataProgressBar
              Appearance.FilterMatchLayout.TextMargins.Left = 3.000000000000000000
              Appearance.FilterMatchLayout.TextMargins.Top = 3.000000000000000000
              Appearance.FilterMatchLayout.TextMargins.Right = 3.000000000000000000
              Appearance.FilterMatchLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.FilterInverseMatchLayout.TextMargins.Left = 3.000000000000000000
              Appearance.FilterInverseMatchLayout.TextMargins.Top = 3.000000000000000000
              Appearance.FilterInverseMatchLayout.TextMargins.Right = 3.000000000000000000
              Appearance.FilterInverseMatchLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.BandLayout.TextMargins.Left = 3.000000000000000000
              Appearance.BandLayout.TextMargins.Top = 3.000000000000000000
              Appearance.BandLayout.TextMargins.Right = 3.000000000000000000
              Appearance.BandLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.FixedLayout.TextMargins.Left = 3.000000000000000000
              Appearance.FixedLayout.TextMargins.Top = 3.000000000000000000
              Appearance.FixedLayout.TextMargins.Right = 3.000000000000000000
              Appearance.FixedLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.FixedSelectedLayout.TextMargins.Left = 3.000000000000000000
              Appearance.FixedSelectedLayout.TextMargins.Top = 3.000000000000000000
              Appearance.FixedSelectedLayout.TextMargins.Right = 3.000000000000000000
              Appearance.FixedSelectedLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.FocusedLayout.TextMargins.Left = 3.000000000000000000
              Appearance.FocusedLayout.TextMargins.Top = 3.000000000000000000
              Appearance.FocusedLayout.TextMargins.Right = 3.000000000000000000
              Appearance.FocusedLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.GroupLayout.TextMargins.Left = 3.000000000000000000
              Appearance.GroupLayout.TextMargins.Top = 3.000000000000000000
              Appearance.GroupLayout.TextMargins.Right = 3.000000000000000000
              Appearance.GroupLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.NormalLayout.TextMargins.Left = 3.000000000000000000
              Appearance.NormalLayout.TextMargins.Top = 3.000000000000000000
              Appearance.NormalLayout.TextMargins.Right = 3.000000000000000000
              Appearance.NormalLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.SelectedLayout.TextMargins.Left = 3.000000000000000000
              Appearance.SelectedLayout.TextMargins.Top = 3.000000000000000000
              Appearance.SelectedLayout.TextMargins.Right = 3.000000000000000000
              Appearance.SelectedLayout.TextMargins.Bottom = 3.000000000000000000
              Appearance.SummaryLayout.TextMargins.Left = 3.000000000000000000
              Appearance.SummaryLayout.TextMargins.Top = 3.000000000000000000
              Appearance.SummaryLayout.TextMargins.Right = 3.000000000000000000
              Appearance.SummaryLayout.TextMargins.Bottom = 3.000000000000000000
              Header = 'Fulfilment'
              Settings = [gcsType]
              TypeRange = gcirNormal
              Width = 150.000000000000000000
            end>
          DefaultRowHeight = 40.000000000000000000
          ProgressAppearance.ShowValue = True
          FilterActions = <>
          SortIndicatorAppearance.IndexFont.Color = -1
          SortIndicatorAppearance.IndexFont.Height = -11
          OnGetCellLayout = OrdersGridGetCellLayout
          Options.Column.Stretching.Enabled = True
          Options.Column.Stretching.Mode = gstmIndex
          Options.Column.Stretching.Index = 1
          Options.Selection.Mode = gsmSingleRow
          RowCount = 1
          Stroke.Kind = gskNone
        end
        object ViewAllLink: TTMSFNCHTMLText
          Left = 680
          Top = 601
          Width = 120
          Height = 20
          Anchors = [akRight, akBottom]
          Font.Name = 'Segoe UI Semibold'
          TabOrder = 3
          AutoOpenURL = False
          HorizontalTextAlign = gtaTrailing
          Trimming = gttCharacter
          Fill.Kind = gfkNone
          Stroke.Kind = gskNone
          Stroke.Color = -1
          Text = '<a href="all">Show all</a>'
          URLUnderline = False
          OnAnchorClick = ViewAllLinkAnchorClick
        end
      end
      object ProjectsCard: TTMSFNCPanel
        AlignWithMargins = True
        Left = 0
        Top = 647
        Width = 820
        Height = 275
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alBottom
        TabOrder = 1
        Sections = <>
        Header.Text = 'Projects'
        Header.Size = 54.000000000000000000
        ButtonsAppearance.ButtonAppearance.NormalFill.Color = 14803425
        ButtonsAppearance.ButtonAppearance.NormalStroke.Color = clDarkgray
        ButtonsAppearance.ButtonAppearance.HoverFill.Color = 16511461
        ButtonsAppearance.ButtonAppearance.HoverStroke.Color = 11632444
        ButtonsAppearance.ButtonAppearance.FlatStyle = True
        object ProjectsNote: TTMSFNCHTMLText
          Left = 560
          Top = 18
          Width = 240
          Height = 20
          Anchors = [akTop, akRight]
          TabOrder = 0
          HorizontalTextAlign = gtaTrailing
          Trimming = gttCharacter
          Fill.Kind = gfkNone
          Stroke.Kind = gskNone
          Stroke.Color = -1
          Text = '2 of 4 tasks done'
        end
        object ProjectTree: TTMSFNCCheckedTreeView
          AlignWithMargins = True
          Left = 3
          Top = 55
          Width = 814
          Height = 216
          Margins.Top = 1
          Margins.Bottom = 4
          Align = alClient
          TabOrder = 1
          Stroke.Kind = gskNone
          Stroke.Color = -1
          HorizontalScrollBarVisible = False
          VerticalScrollBarVisible = False
          Groups = <>
          GroupsAppearance.TopSize = 50.000000000000000000
          GroupsAppearance.BottomSize = 50.000000000000000000
          GroupsAppearance.TopFont.Color = clBlack
          GroupsAppearance.BottomFont.Color = clBlack
          Columns = <
            item
              Name = 'Column0'
              Text = 'Project'
              Width = 100.000000000000000000
            end
            item
              Name = 'Column1'
              Text = 'Owner'
              Width = 130.000000000000000000
            end
            item
              Name = 'Column2'
              Text = 'Status'
              Width = 136.000000000000000000
              StatusValues.Strings = (
                'On track=Success'
                'Done=Info'
                'In progress=Warning'
                'At risk=Error')
              StatusShowDot = False
            end>
          Nodes = <>
          ColumnsAppearance.Layouts = []
          ColumnsAppearance.StretchColumn = 0
          ColumnsAppearance.StretchAll = False
          ColumnsAppearance.TopSize = 25.000000000000000000
          ColumnsAppearance.BottomSize = 25.000000000000000000
          ColumnsAppearance.TopFont.Color = clBlack
          ColumnsAppearance.BottomFont.Color = clBlack
          NodesAppearance.ExpandWidth = 15.000000000000000000
          NodesAppearance.ExpandHeight = 15.000000000000000000
          NodesAppearance.LevelIndent = 20.000000000000000000
          NodesAppearance.FixedHeight = 25.000000000000000000
          NodesAppearance.VariableMinimumHeight = 25.000000000000000000
          NodesAppearance.Font.Height = -13
          NodesAppearance.ParentNodesSemibold = True
          OnAfterUnCheckNode = ProjectTreeNodeChecked
          OnAfterCheckNode = ProjectTreeNodeChecked
          OnGetNodeTextColor = ProjectTreeGetNodeTextColor
          DefaultViewJSONOptions.NameHTMLTemplate = '<#NAME>'
          DefaultViewJSONOptions.ValueHTMLTemplate = '<#VALUE>'
        end
      end
    end
  end
  object NavPanel: TTMSFNCPanel
    Left = -8
    Top = 48
    Width = 240
    Height = 1205
    Anchors = [akLeft, akTop, akBottom]
    TabOrder = 3
    Sections = <>
    Header.Visible = False
    ButtonsAppearance.ButtonAppearance.NormalFill.Color = 14803425
    ButtonsAppearance.ButtonAppearance.NormalStroke.Color = clDarkgray
    ButtonsAppearance.ButtonAppearance.HoverFill.Color = 16511461
    ButtonsAppearance.ButtonAppearance.HoverStroke.Color = 11632444
    ButtonsAppearance.ButtonAppearance.FlatStyle = True
    object NavList: TTMSFNCListBox
      Left = 18
      Top = 19
      Width = 211
      Height = 190
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      Stroke.Kind = gskNone
      ItemsAppearance.Font.Height = -14
      ItemsAppearance.FixedHeight = 38.000000000000000000
      ItemsAppearance.ShowFocus = False
      ItemsAppearance.BadgeFont.Color = clWhite
      ItemsAppearance.BadgeFont.Name = 'Segoe UI Semibold'
      ItemsAppearance.SelectedFont.Color = 11428622
      ItemsAppearance.SelectedFont.Height = -14
      ItemsAppearance.SelectedFont.Name = 'Segoe UI Semibold'
      ItemsAppearance.SelectionRounding = 6.000000000000000000
      ItemsAppearance.SelectionMargins.Top = 1.000000000000000000
      ItemsAppearance.SelectionMargins.Bottom = 1.000000000000000000
      ItemsAppearance.TintBitmaps = True
      Items = <
        item
          Text = 'Overview'
          BitmapWidth = 29.000000000000000000
          BitmapHeight = 22.000000000000000000
        end
        item
          Text = 'Orders'
          BitmapWidth = 29.000000000000000000
          BitmapHeight = 22.000000000000000000
        end
        item
          Text = 'Customers'
          BitmapWidth = 29.000000000000000000
          BitmapHeight = 22.000000000000000000
        end
        item
          Text = 'Planning'
          BitmapWidth = 29.000000000000000000
          BitmapHeight = 22.000000000000000000
        end
        item
          Text = 'Reports'
          BitmapWidth = 29.000000000000000000
          BitmapHeight = 22.000000000000000000
        end>
      Header.Text = 'Header'
      Header.Font.Color = clBlack
      Header.Size = 25.000000000000000000
      Header.SortIndicatorColor = clSteelblue
      ItemIndex = 0
      OnItemSelected = NavListItemSelected
      VerticalScrollBarVisible = False
    end
    object SettingsList: TTMSFNCListBox
      Left = 18
      Top = 1148
      Width = 211
      Height = 38
      Anchors = [akLeft, akRight, akBottom]
      TabOrder = 1
      Stroke.Kind = gskNone
      ItemsAppearance.Font.Height = -14
      ItemsAppearance.FixedHeight = 38.000000000000000000
      ItemsAppearance.ShowFocus = False
      ItemsAppearance.BadgeFont.Color = clWhite
      ItemsAppearance.BadgeFont.Name = 'Segoe UI Semibold'
      ItemsAppearance.SelectedFont.Color = 11428622
      ItemsAppearance.SelectedFont.Height = -14
      ItemsAppearance.SelectedFont.Name = 'Segoe UI Semibold'
      ItemsAppearance.SelectionRounding = 6.000000000000000000
      ItemsAppearance.SelectionMargins.Top = 1.000000000000000000
      ItemsAppearance.SelectionMargins.Bottom = 1.000000000000000000
      ItemsAppearance.TintBitmaps = True
      Items = <
        item
          Text = 'Settings'
          BitmapWidth = 29.000000000000000000
          BitmapHeight = 22.000000000000000000
        end>
      Header.Text = 'Header'
      Header.Font.Color = clBlack
      Header.Size = 25.000000000000000000
      Header.SortIndicatorColor = clSteelblue
      OnItemSelected = NavListItemSelected
      VerticalScrollBarVisible = False
    end
  end
  object StatusBar: TTMSFNCStatusBar
    Left = -1
    Top = 1245
    Width = 1442
    Height = 33
    Align = alNone
    TabOrder = 4
    Panels = <
      item
        Style = spsText
        Width = 11
        Progress.Level0Fill.Color = clLime
        Progress.Level1Fill.Color = clYellow
        Progress.Level2Fill.Color = clOrange
        Progress.Level3Fill.Color = clRed
        Progress.Position = 0
      end
      item
        Text = 'Theme: Fluent Light'
        Width = 200
        Progress.Level0Fill.Color = clLime
        Progress.Level1Fill.Color = clYellow
        Progress.Level2Fill.Color = clOrange
        Progress.Level3Fill.Color = clRed
        Progress.Position = 0
      end
      item
        Text = '200 orders'
        Style = spsText
        Width = 100
        Progress.Level0Fill.Color = clLime
        Progress.Level1Fill.Color = clYellow
        Progress.Level2Fill.Color = clOrange
        Progress.Level3Fill.Color = clRed
        Progress.Position = 0
      end
      item
        Style = spsText
        Width = 860
        Progress.Level0Fill.Color = clLime
        Progress.Level1Fill.Color = clYellow
        Progress.Level2Fill.Color = clOrange
        Progress.Level3Fill.Color = clRed
        Progress.Position = 0
      end
      item
        Text = 'TMS FNC Core 5.0 '#183' UI Pack 8.0'
        Style = spsText
        Alignment = taRightJustify
        Width = 260
        Progress.Level0Fill.Color = clLime
        Progress.Level1Fill.Color = clYellow
        Progress.Level2Fill.Color = clOrange
        Progress.Level3Fill.Color = clRed
        Progress.Position = 0
      end
      item
        Style = spsText
        Width = 11
        Progress.Level0Fill.Color = clLime
        Progress.Level1Fill.Color = clYellow
        Progress.Level2Fill.Color = clOrange
        Progress.Level3Fill.Color = clRed
        Progress.Position = 0
      end>
  end
  object TopBar: TTMSFNCPanel
    Left = -8
    Top = -8
    Width = 1456
    Height = 64
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 5
    Sections = <>
    Header.Visible = False
    ButtonsAppearance.ButtonAppearance.NormalFill.Color = 14803425
    ButtonsAppearance.ButtonAppearance.NormalStroke.Color = clDarkgray
    ButtonsAppearance.ButtonAppearance.HoverFill.Color = 16511461
    ButtonsAppearance.ButtonAppearance.HoverStroke.Color = 11632444
    ButtonsAppearance.ButtonAppearance.FlatStyle = True
    object AppTitle: TTMSFNCHTMLText
      Left = 66
      Top = 25
      Width = 170
      Height = 20
      Font.Height = -15
      Font.Name = 'Segoe UI Semibold'
      TabOrder = 1
      HorizontalTextAlign = gtaLeading
      Trimming = gttCharacter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Stroke.Color = -1
      Text = 'Theming Dashboard'
    end
    object AccentSelector: TTMSFNCAccentSelector
      AlignWithMargins = True
      Left = 1200
      Top = 0
      Width = 132
      Height = 28
      Margins.Left = 0
      Margins.Top = 22
      Margins.Right = 12
      Margins.Bottom = 14
      Align = alRight
      TabOrder = 3
      Appearance.Font.Color = 2630431
      Appearance.SelectedFont.Color = 2630431
      Appearance.DisabledOpacity = 0.400000005960464500
      Colors = <
        item
          Color = 12413967
          Text = 'Blue'
          Hint = 'Theme accent'
          Bitmaps = <>
        end
        item
          Color = 12275563
          Text = 'Purple'
          Hint = 'Purple'
          Bitmaps = <>
        end
        item
          Color = 6716430
          Text = 'Teal'
          Hint = 'Teal'
          Bitmaps = <>
        end
        item
          Color = 4927940
          Text = 'Crimson'
          Hint = 'Crimson'
          Bitmaps = <>
        end
        item
          Color = 28344
          Text = 'Amber'
          Hint = 'Amber'
          Bitmaps = <>
        end>
    end
    object Avatar: TTMSFNCBadge
      AlignWithMargins = True
      Left = 1400
      Top = 0
      Width = 32
      Height = 26
      Margins.Left = 0
      Margins.Top = 20
      Margins.Right = 28
      Margins.Bottom = 12
      Align = alRight
      TabOrder = 2
      Visible = True
      Appearance.DisabledFont.Color = clLightgray
      Appearance.Font.Color = clWhite
      Appearance.Rounding = 15
      Text = 'PS'
      Kind = tskAccent
      Shape = bshCircle
    end
    object AppMark: TTMSFNCBadge
      AlignWithMargins = True
      Left = 0
      Top = 0
      Width = 28
      Height = 26
      Margins.Left = 28
      Margins.Top = 22
      Margins.Right = 0
      Margins.Bottom = 14
      Align = alLeft
      TabOrder = 0
      Visible = True
      Appearance.DisabledFont.Color = clLightgray
      Appearance.Font.Color = clWhite
      Appearance.Rounding = 15
      Text = ''
      Bitmap.ThemeTint = bttAccent
      Kind = tskAccent
    end
    object ThemeSelector: TTMSFNCThemeSelector
      AlignWithMargins = True
      Left = 100
      Top = 0
      Width = 756
      Height = 36
      Margins.Left = 0
      Margins.Top = 18
      Margins.Right = 12
      Margins.Bottom = 10
      Align = alRight
      TabOrder = 4
      SegmentAppearance.Font.Color = 7365723
      SegmentAppearance.Font.Height = -13
      SegmentAppearance.SelectedFont.Color = 2630431
      SegmentAppearance.SelectedFont.Height = -13
      SegmentAppearance.SelectedFont.Name = 'Segoe UI Semibold'
      ChipAppearance.Font.Color = 2630431
      ChipAppearance.SelectedFont.Color = 11428622
      Themes.Strings = (
        'Fluent Light'
        'Fluent Dark'
        'Microsoft 365 Light'
        'Microsoft 365 Dark'
        'High Contrast=High contrast')
      ShowFollowSystem = True
      FollowSystemAppearance.Font.Color = 7365723
      FollowSystemAppearance.Font.Height = -13
    end
  end
  object GridAdapter: TTMSFNCDataGridDatabaseAdapter
    Left = 1336
    Top = 1088
    DataSource = OrderSource
    AutoCreateColumns = False
    AutoRemoveColumns = False
    Columns = <
      item
        FieldName = 'id'
        Header = 'Order'
        AutoCreated = False
      end
      item
        FieldName = 'customer'
        Header = 'Customer'
        AutoCreated = False
      end
      item
        FieldName = 'order_date'
        Header = 'Date'
        AutoCreated = False
      end
      item
        FieldName = 'amount'
        Header = 'Total'
        AutoCreated = False
      end
      item
        FieldName = 'status'
        Header = 'Status'
        AutoCreated = False
      end
      item
        FieldName = 'fulfilment'
        Header = 'Fulfilment'
        AutoCreated = False
      end>
    LoadMode = almAllRecords
    ShowDateTimeFields = False
  end
  object ThemeManager: TTMSFNCThemeManager
    Theme = 'Fluent Light'
    Left = 1336
    Top = 960
  end
  object DataRequest: TWebHttpRequest
    URL = 'orders.json'
    OnResponse = DataRequestResponse
    Left = 1336
    Top = 1152
  end
  object Orders: TWebClientDataSet
    Left = 1400
    Top = 1152
    AfterOpen = OrdersAfterOpen
    AfterPost = OrdersChanged
    AfterDelete = OrdersChanged
    OnFilterRecord = OrdersFilterRecord
    OnNewRecord = OrdersNewRecord
    object OrdersId: TIntegerField
      FieldName = 'id'
      OnGetText = OrdersIdGetText
    end
    object OrdersCustomer: TStringField
      FieldName = 'customer'
      Size = 60
    end
    object OrdersOrderDate: TStringField
      FieldName = 'order_date'
      OnGetText = OrdersOrderDateGetText
      Size = 10
    end
    object OrdersAmount: TFloatField
      FieldName = 'amount'
      OnGetText = OrdersAmountGetText
    end
    object OrdersStatus: TStringField
      FieldName = 'status'
      Size = 12
    end
    object OrdersFulfilment: TIntegerField
      FieldName = 'fulfilment'
    end
    object OrdersExpress: TBooleanField
      FieldName = 'express'
    end
  end
  object OrderSource: TWebDataSource
    DataSet = Orders
    OnDataChange = OrderSourceDataChange
    Left = 1336
    Top = 1024
  end
end
