object Form130: TForm130
  Left = 0
  Top = 0
  Caption = 'TMS FNC Pickers Demo'
  ClientHeight = 769
  ClientWidth = 1115
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 425
    Height = 763
    Align = alLeft
    TabOrder = 0
    object Label6: TLabel
      Left = 8
      Top = 14
      Width = 406
      Height = 23
      AutoSize = False
      Caption = 'Watch and Digital Time Selector'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 8
      Top = 43
      Width = 68
      Height = 13
      Caption = 'Selected time:'
    end
    object Label8: TLabel
      Left = 82
      Top = 43
      Width = 44
      Height = 13
      Caption = '00:00:00'
    end
    object Label9: TLabel
      Left = 194
      Top = 249
      Width = 42
      Height = 13
      Caption = 'Interval:'
    end
    object Label10: TLabel
      Left = 8
      Top = 248
      Width = 175
      Height = 88
      AutoSize = False
      Caption = 
        'To select the hour, click inside the watch. To select the minute' +
        ', click outside of the watch. To change the AM/PM, click the AM/' +
        'PM rectangle.'
      WordWrap = True
    end
    object TMSFNCDigitalTimeSelector1: TTMSFNCDigitalTimeSelector
      Left = 194
      Top = 80
      Width = 220
      Height = 150
      ParentDoubleBuffered = False
      DoubleBuffered = True
      TabOrder = 0
      Appearance.Stroke.Color = 11119017
      Appearance.Fill.Color = 15329769
      Appearance.StrokeHover.Color = 10061943
      Appearance.FillHover.Color = 13419707
      Appearance.StrokeDown.Color = 9470064
      Appearance.FillDown.Color = 13156536
      Appearance.StrokeSelected.Color = 5197615
      Appearance.FillSelected.Color = 13156536
      Appearance.StrokeDisabled.Color = 11119017
      Appearance.FillDisabled.Color = clSilver
      Appearance.SeparatorStroke.Color = 11119017
      Appearance.Font.Charset = DEFAULT_CHARSET
      Appearance.Font.Color = clWindowText
      Appearance.Font.Height = -11
      Appearance.Font.Name = 'Tahoma'
      Appearance.Font.Style = []
      EndTime = 0.999988425925926000
      OnTimeSelected = TMSFNCDigitalTimeSelector1TimeSelected
    end
    object CheckBox2: TCheckBox
      Left = 17
      Top = 327
      Width = 97
      Height = 17
      Caption = 'Auto'
      TabOrder = 1
      OnClick = CheckBox2Click
    end
    object CheckBox3: TCheckBox
      Left = 17
      Top = 350
      Width = 97
      Height = 17
      Caption = 'Read only'
      TabOrder = 2
      OnClick = CheckBox3Click
    end
    object CheckBox4: TCheckBox
      Left = 16
      Top = 373
      Width = 97
      Height = 17
      Caption = 'Customize'
      TabOrder = 3
      OnClick = CheckBox4Click
    end
    object Edit1: TEdit
      Left = 242
      Top = 246
      Width = 172
      Height = 21
      TabOrder = 5
      Text = '5'
      OnChange = Edit1Change
    end
    object GroupBox3: TGroupBox
      Left = 189
      Top = 302
      Width = 220
      Height = 88
      Caption = 'Interval Unit'
      TabOrder = 4
      object RadioButton6: TRadioButton
        Left = 6
        Top = 17
        Width = 113
        Height = 17
        Caption = 'Seconds'
        TabOrder = 0
        OnClick = RadioButton6Click
      end
      object RadioButton7: TRadioButton
        Left = 6
        Top = 40
        Width = 113
        Height = 17
        Caption = 'Minutes'
        Checked = True
        TabOrder = 1
        TabStop = True
        OnClick = RadioButton7Click
      end
      object RadioButton8: TRadioButton
        Left = 6
        Top = 63
        Width = 113
        Height = 17
        Caption = 'Hours'
        TabOrder = 2
        OnClick = RadioButton8Click
      end
    end
    object TMSFNCAnalogTimeSelector1: TTMSFNCAnalogTimeSelector
      Left = 8
      Top = 62
      Width = 180
      Height = 180
      ParentDoubleBuffered = False
      Color = clBtnFace
      DoubleBuffered = True
      TabOrder = 6
      Fill.Color = -1
      Stroke.Color = -1
      Appearance.Stroke.Color = clBlack
      Appearance.Stroke.Width = 4.000000000000000000
      Appearance.HourMark.Color = clBlack
      Appearance.HourFont.Charset = DEFAULT_CHARSET
      Appearance.HourFont.Color = clBlack
      Appearance.HourFont.Height = -11
      Appearance.HourFont.Name = 'Tahoma'
      Appearance.HourFont.Style = []
      Appearance.MinuteMark.Color = clBlack
      Appearance.AMPMStroke.Color = clBlack
      Appearance.AMPMFont.Charset = DEFAULT_CHARSET
      Appearance.AMPMFont.Color = clBlack
      Appearance.AMPMFont.Height = -11
      Appearance.AMPMFont.Name = 'Tahoma'
      Appearance.AMPMFont.Style = []
      Appearance.HourPointer.Color = clBlack
      Appearance.HourPointer.Width = 4.000000000000000000
      Appearance.MinutePointer.Color = clBlack
      Appearance.MinutePointer.Width = 3.000000000000000000
      Appearance.SecondPointer.Color = clRed
      Appearance.HourPointerShadow.Color = clMedGray
      Appearance.HourPointerShadow.Width = 4.000000000000000000
      Appearance.MinutePointerShadow.Color = clMedGray
      Appearance.MinutePointerShadow.Width = 3.000000000000000000
      Appearance.CenterPointFill.Color = clBlack
      Appearance.CenterPointStroke.Color = clBlack
      OnTimeChanged = TMSFNCAnalogTimeSelector1TimeChanged
    end
    object Panel1: TPanel
      Left = 1
      Top = 412
      Width = 423
      Height = 200
      Align = alBottom
      TabOrder = 7
      object Label1: TLabel
        Left = 7
        Top = 8
        Width = 347
        Height = 23
        AutoSize = False
        Caption = 'Digital and Analog Time Picker'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label2: TLabel
        Left = 155
        Top = 48
        Width = 33
        Height = 13
        Caption = 'Analog'
      end
      object Label3: TLabel
        Left = 264
        Top = 48
        Width = 29
        Height = 13
        Caption = 'Digital'
      end
      object Label4: TLabel
        Left = 8
        Top = 48
        Width = 68
        Height = 13
        Caption = 'Selected time:'
      end
      object Label5: TLabel
        Left = 155
        Top = 107
        Width = 112
        Height = 13
        Caption = 'Digital Time Picker only:'
      end
      object Label15: TLabel
        Left = 82
        Top = 48
        Width = 44
        Height = 13
        Caption = '00:00:00'
      end
      object TMSFNCAnalogTimePicker1: TTMSFNCAnalogTimePicker
        Left = 155
        Top = 67
        Width = 90
        Height = 22
        ParentDoubleBuffered = False
        DoubleBuffered = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        TabOrder = 0
        DropDownWidth = 180.000000000000000000
        DropDownHeight = 180.000000000000000000
        SelectorAppearance.Stroke.Color = clBlack
        SelectorAppearance.Stroke.Width = 4.000000000000000000
        SelectorAppearance.HourMark.Color = clBlack
        SelectorAppearance.HourFont.Charset = DEFAULT_CHARSET
        SelectorAppearance.HourFont.Color = clBlack
        SelectorAppearance.HourFont.Height = -11
        SelectorAppearance.HourFont.Name = 'Tahoma'
        SelectorAppearance.HourFont.Style = []
        SelectorAppearance.MinuteMark.Color = clBlack
        SelectorAppearance.AMPMStroke.Color = clBlack
        SelectorAppearance.AMPMFont.Charset = DEFAULT_CHARSET
        SelectorAppearance.AMPMFont.Color = clBlack
        SelectorAppearance.AMPMFont.Height = -11
        SelectorAppearance.AMPMFont.Name = 'Tahoma'
        SelectorAppearance.AMPMFont.Style = []
        SelectorAppearance.HourPointer.Color = clBlack
        SelectorAppearance.HourPointer.Width = 4.000000000000000000
        SelectorAppearance.MinutePointer.Color = clBlack
        SelectorAppearance.MinutePointer.Width = 3.000000000000000000
        SelectorAppearance.SecondPointer.Color = clRed
        SelectorAppearance.HourPointerShadow.Color = clMedGray
        SelectorAppearance.HourPointerShadow.Width = 4.000000000000000000
        SelectorAppearance.MinutePointerShadow.Color = clMedGray
        SelectorAppearance.MinutePointerShadow.Width = 3.000000000000000000
        SelectorAppearance.CenterPointFill.Color = clBlack
        SelectorAppearance.CenterPointStroke.Color = clBlack
        OnTimeSelected = TMSFNCAnalogTimePicker1TimeSelected
      end
      object TMSFNCDigitalTimePicker1: TTMSFNCDigitalTimePicker
        Left = 264
        Top = 67
        Width = 90
        Height = 22
        ParentDoubleBuffered = False
        DoubleBuffered = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        TabOrder = 1
        DropDownWidth = 220.000000000000000000
        DropDownHeight = 150.000000000000000000
        Appearance.Stroke.Color = 11119017
        Appearance.Fill.Color = 15329769
        Appearance.StrokeHover.Color = 10061943
        Appearance.FillHover.Color = 13419707
        Appearance.StrokeDown.Color = 9470064
        Appearance.FillDown.Color = 13156536
        Appearance.StrokeSelected.Color = 5197615
        Appearance.FillSelected.Color = 13156536
        Appearance.StrokeDisabled.Color = 11119017
        Appearance.FillDisabled.Color = clSilver
        Appearance.VerticalSpacing = 0.041666667908430100
        Appearance.HorizontalSpacing = 0.041666667908430100
        Appearance.SeparatorStroke.Color = 11119017
        Appearance.Font.Charset = DEFAULT_CHARSET
        Appearance.Font.Color = clWindowText
        Appearance.Font.Height = 0
        Appearance.Font.Name = 'Tahoma'
        Appearance.Font.Style = []
        EndTime = 0.999988425925926000
        HeaderSize = 0
        OnTimeSelected = TMSFNCDigitalTimePicker1TimeSelected
      end
      object CheckBox1: TCheckBox
        Left = 8
        Top = 77
        Width = 97
        Height = 17
        Caption = 'Editable'
        TabOrder = 2
        OnClick = CheckBox1Click
      end
      object GroupBox1: TGroupBox
        Left = 155
        Top = 126
        Width = 136
        Height = 63
        Caption = 'Start Time - End Time'
        TabOrder = 3
        object RadioButton1: TRadioButton
          Left = 7
          Top = 18
          Width = 124
          Height = 17
          Caption = '00:00:00 - 23:59:59'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = RadioButton1Click
        end
        object RadioButton2: TRadioButton
          Left = 7
          Top = 40
          Width = 124
          Height = 17
          Caption = '08:00:00 - 16:30:00'
          TabOrder = 1
          OnClick = RadioButton2Click
        end
      end
      object GroupBox2: TGroupBox
        Left = 8
        Top = 100
        Width = 136
        Height = 89
        Caption = 'Time Format'
        TabOrder = 4
        object RadioButton3: TRadioButton
          Left = 7
          Top = 18
          Width = 113
          Height = 17
          Caption = 'hh:nn:ss'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = RadioButton3Click
        end
        object RadioButton4: TRadioButton
          Left = 7
          Top = 40
          Width = 113
          Height = 17
          Caption = 'hh:nn:ss.zzz'
          TabOrder = 1
          OnClick = RadioButton4Click
        end
        object RadioButton5: TRadioButton
          Left = 7
          Top = 63
          Width = 113
          Height = 17
          Caption = 'hh:nn'
          TabOrder = 2
          OnClick = RadioButton5Click
        end
      end
    end
    object Panel6: TPanel
      Left = 1
      Top = 612
      Width = 423
      Height = 150
      Align = alBottom
      TabOrder = 8
      object Label22: TLabel
        Left = 7
        Top = 8
        Width = 391
        Height = 23
        AutoSize = False
        Caption = 'DateTime Picker'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label23: TLabel
        Left = 8
        Top = 37
        Width = 68
        Height = 13
        Caption = 'Selected time:'
      end
      object Label24: TLabel
        Left = 82
        Top = 37
        Width = 3
        Height = 13
      end
      object CheckBox5: TCheckBox
        Left = 8
        Top = 56
        Width = 97
        Height = 17
        Caption = 'Editable'
        TabOrder = 0
        OnClick = CheckBox5Click
      end
      object GroupBox5: TGroupBox
        Left = 8
        Top = 79
        Width = 136
        Height = 63
        Caption = 'Time picker mode'
        TabOrder = 1
        object RadioButton12: TRadioButton
          Left = 7
          Top = 18
          Width = 124
          Height = 17
          Caption = 'Analog'
          TabOrder = 0
          OnClick = RadioButton12Click
        end
        object RadioButton13: TRadioButton
          Left = 7
          Top = 40
          Width = 124
          Height = 17
          Caption = 'Digital'
          Checked = True
          TabOrder = 1
          TabStop = True
          OnClick = RadioButton13Click
        end
      end
      object TMSFNCDateTimePicker1: TTMSFNCDateTimePicker
        Left = 218
        Top = 34
        Width = 180
        Height = 22
        ParentDoubleBuffered = False
        Color = 11119017
        DoubleBuffered = True
        TabOrder = 2
        SelectedDateTime = 43453.000000000000000000
        OnDateTimeChanged = TMSFNCDateTimePicker1DateTimeChanged
      end
    end
  end
  object Panel3: TPanel
    AlignWithMargins = True
    Left = 434
    Top = 3
    Width = 300
    Height = 763
    Align = alLeft
    TabOrder = 1
    object Label11: TLabel
      Left = 8
      Top = 8
      Width = 281
      Height = 23
      AutoSize = False
      Caption = 'Fill/Stroke Kind Selector/Picker'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object Label12: TLabel
      Left = 8
      Top = 374
      Width = 58
      Height = 13
      Caption = 'Stroke Kind:'
    end
    object Label13: TLabel
      Left = 8
      Top = 217
      Width = 39
      Height = 13
      Caption = 'Fill Kind:'
    end
    object Label14: TLabel
      Left = 11
      Top = 49
      Width = 263
      Height = 26
      Caption = 
        'The Fill/Stroke Kind Selector and Picker are in sync via  events' +
        '.'
      WordWrap = True
    end
    object TMSFNCFillKindSelector1: TTMSFNCFillKindSelector
      Left = 8
      Top = 236
      Width = 121
      Height = 121
      ParentDoubleBuffered = False
      DoubleBuffered = True
      TabOrder = 0
      Appearance.Stroke.Color = 11119017
      Appearance.Fill.Color = 15329769
      Appearance.StrokeHover.Color = 10061943
      Appearance.FillHover.Color = 13419707
      Appearance.StrokeDown.Color = 9470064
      Appearance.FillDown.Color = 13156536
      Appearance.StrokeSelected.Color = 5197615
      Appearance.FillSelected.Color = 13156536
      Appearance.StrokeDisabled.Color = 11119017
      Appearance.FillDisabled.Color = clSilver
      Appearance.SeparatorStroke.Color = 11119017
      Appearance.Font.Charset = DEFAULT_CHARSET
      Appearance.Font.Color = clWindowText
      Appearance.Font.Height = -11
      Appearance.Font.Name = 'Tahoma'
      Appearance.Font.Style = []
      Columns = 1
      Items = <
        item
          Name = 'None'
        end
        item
          Kind = gfkSolid
          Name = 'Solid'
        end
        item
          Kind = gfkGradient
          Name = 'Gradient'
        end
        item
          Kind = gfkTexture
          Name = 'Texture'
        end>
      OnFillKindSelected = TMSFNCFillKindSelector1FillKindSelected
    end
    object TMSFNCStrokeKindSelector1: TTMSFNCStrokeKindSelector
      Left = 8
      Top = 393
      Width = 130
      Height = 135
      ParentDoubleBuffered = False
      DoubleBuffered = True
      TabOrder = 1
      Appearance.Stroke.Color = 11119017
      Appearance.Fill.Color = 15329769
      Appearance.StrokeHover.Color = 10061943
      Appearance.FillHover.Color = 13419707
      Appearance.StrokeDown.Color = 9470064
      Appearance.FillDown.Color = 13156536
      Appearance.StrokeSelected.Color = 5197615
      Appearance.FillSelected.Color = 13156536
      Appearance.StrokeDisabled.Color = 11119017
      Appearance.FillDisabled.Color = clSilver
      Appearance.SeparatorStroke.Color = 11119017
      Appearance.Font.Charset = DEFAULT_CHARSET
      Appearance.Font.Color = clWindowText
      Appearance.Font.Height = -11
      Appearance.Font.Name = 'Tahoma'
      Appearance.Font.Style = []
      Columns = 1
      Rows = 6
      Items = <
        item
        end
        item
          Kind = gskSolid
        end
        item
          Kind = gskDash
        end
        item
          Kind = gskDot
        end
        item
          Kind = gskDashDot
        end
        item
          Kind = gskDashDotDot
        end>
      OnStrokeKindSelected = TMSFNCStrokeKindSelector1StrokeKindSelected
    end
    object TMSFNCFillKindPicker1: TTMSFNCFillKindPicker
      Left = 135
      Top = 236
      Width = 100
      Height = 25
      ParentDoubleBuffered = False
      DoubleBuffered = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      TabOrder = 2
      DropDownWidth = 121.000000000000000000
      DropDownHeight = 121.000000000000000000
      Appearance.Stroke.Color = 11119017
      Appearance.Fill.Color = 15329769
      Appearance.StrokeHover.Color = 10061943
      Appearance.FillHover.Color = 13419707
      Appearance.StrokeDown.Color = 9470064
      Appearance.FillDown.Color = 13156536
      Appearance.StrokeSelected.Color = 5197615
      Appearance.FillSelected.Color = 13156536
      Appearance.StrokeDisabled.Color = 11119017
      Appearance.FillDisabled.Color = clSilver
      Appearance.VerticalSpacing = 0.041666667908430100
      Appearance.HorizontalSpacing = 0.041666667908430100
      Appearance.SeparatorStroke.Color = 11119017
      Appearance.Font.Charset = DEFAULT_CHARSET
      Appearance.Font.Color = clWindowText
      Appearance.Font.Height = 0
      Appearance.Font.Name = 'Tahoma'
      Appearance.Font.Style = []
      Columns = 1
      Items = <
        item
          Name = 'None'
        end
        item
          Kind = gfkSolid
          Name = 'Solid'
        end
        item
          Kind = gfkGradient
          Name = 'Gradient'
        end
        item
          Kind = gfkTexture
          Name = 'Texture'
        end>
      OnFillKindSelected = TMSFNCFillKindPicker1FillKindSelected
    end
    object TMSFNCStrokeKindPicker1: TTMSFNCStrokeKindPicker
      Left = 144
      Top = 396
      Width = 70
      Height = 22
      ParentDoubleBuffered = False
      DoubleBuffered = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      TabOrder = 3
      DropDownWidth = 130.000000000000000000
      Appearance.Stroke.Color = 11119017
      Appearance.Fill.Color = 15329769
      Appearance.StrokeHover.Color = 10061943
      Appearance.FillHover.Color = 13419707
      Appearance.StrokeDown.Color = 9470064
      Appearance.FillDown.Color = 13156536
      Appearance.StrokeSelected.Color = 5197615
      Appearance.FillSelected.Color = 13156536
      Appearance.StrokeDisabled.Color = 11119017
      Appearance.FillDisabled.Color = clSilver
      Appearance.SeparatorStroke.Color = 11119017
      Appearance.Font.Charset = DEFAULT_CHARSET
      Appearance.Font.Color = clWindowText
      Appearance.Font.Height = -11
      Appearance.Font.Name = 'Tahoma'
      Appearance.Font.Style = []
      Rows = 6
      Columns = 1
      Items = <
        item
        end
        item
          Kind = gskSolid
        end
        item
          Kind = gskDash
        end
        item
          Kind = gskDot
        end
        item
          Kind = gskDashDot
        end
        item
          Kind = gskDashDotDot
        end>
      OnStrokeKindSelected = TMSFNCStrokeKindPicker1StrokeKindSelected
      SelectedItemIndex = 1
    end
    object TMSFNCPanel1: TTMSFNCPanel
      Left = 8
      Top = 81
      Width = 281
      Height = 120
      ParentDoubleBuffered = False
      DoubleBuffered = True
      TabOrder = 4
      Fill.Texture.Data = {
        0954506E67496D61676589504E470D0A1A0A0000000D49484452000000FF0000
        00C8080300000010A9C7ED000000017352474200AECE1CE90000000467414D41
        0000B18F0BFC610500000300504C544582828283838384848485858586868687
        87878888888989898A8A8A8B8B8B8C8C8C8D8D8D8E8E8E8F8F8F909090919191
        9292929393939494949595959696969797979898989999999A9A9A9B9B9B9C9C
        9C9D9D9D9E9E9E9F9F9FA0A0A0A1A1A1A2A2A2A3A3A3A4A4A4A5A5A5A6A6A6A7
        A7A7A8A8A8A9A9A9AAAAAAABABABACACACADADADAEAEAEAFAFAFB0B0B0B1B1B1
        B2B2B2B3B3B3B4B4B4B5B5B5B6B6B6B7B7B7B8B8B8B9B9B9BABABABBBBBBBCBC
        BCBDBDBDBEBEBEBFBFBFC0C0C0C1C1C1C2C2C2C3C3C3C4C4C4C5C5C5C6C6C6C7
        C7C7C8C8C8C9C9C9CACACACBCBCBCCCCCCCDCDCDCECECECFCFCFD0D0D0D1D1D1
        D2D2D2D3D3D3D4D4D4D5D5D5D6D6D6D7D7D7D8D8D8D9D9D9DADADADBDBDBDCDC
        DCDDDDDDDEDEDEDFDFDFE0E0E0E1E1E1E2E2E2E3E3E3E4E4E4E5E5E500000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000000000000000000000000000C4FC672B000000097048597300000EC3
        00000EC301C76FA8640000001974455874536F667477617265007061696E742E
        6E657420342E302E3231F12069950000128B4944415478DAD59DE9571B4716C5
        AB25B510080C168B9D78013293CC64426672423239B1CDCC9973F279BECEC9DF
        3C660BC4C606AF6084596CB30809ADD3A0AD5EABBAEF6DD18D98FE64E1A2E9A7
        AEAEFBEB77EB55597F50CD23351657CC51CBE7CB5443A592C9C921FF16D5A7AF
        B853C54793A8492AD1F1A38FD95AFB43DF786780563B7E151FEFE3AEE5ECB448
        7E0189C4E713A0C9BBDF2ADCB96EA6510B3B69B97F94DF2CB53FC4C6537EF12B
        353AC85D4A397756E35AC61323F741B73A9ACF71E71AB8698116F154478BF296
        7EF69B377CE3578319F427EA47357746DE352BD93F95F26F525ECE72E7B24713
        A08595EAF8B26BBBFBDAA77426E617BF4A8EA33FD1386B215FA21A3A576DDF1F
        014D5EAC71DDC91A4DA1267D76C78F0EB7ABDAD58C8B06EEF8556CAC9F0BAB98
        2B91CF402271EB36E856FB8B67DCB9866EA00E6A1804CEDE6AE3953536E017BF
        5223C3DCA59473C52AD73266DF9804DDAA30FF913B575F06A9542C1573FFA8B2
        75A27D1A1E6E7F4386F8D5C0684C3147F5B4C00E02766A6A009C2C3C21340C02
        6A6F57FBA029BD297EF733E279D4CE4EE9412071771434095108939D5FD1F196
        D659DB4A6F8CDFF58CF81CA51376108827C6EE82473744214CF475B4286E16B4
        4F9921BFF8E533E277547267F420909E023D374421340D02D943ED537AD4F28B
        9FA7E1D30249C3960D69384C2134D0F0C18EF6C19E48F8C51F808673EC2040D0
        708842681804725BDABDB2C6FBFDE28F86866FDE03DD2A3FFF893B171642030D
        9736F3DAA7E111DFF8A3A1E169D0ADAA4F5E73E72284B0BF6310A86575CE488D
        FBC6CFD330FF4A6CDB9388AFB656421342F44A1CF78FDFF4C6683E8A39FE9518
        D2F0D1E353EE5C5808D12B3188BF47345C5E7CCF9D0B0B217825B6BE298013F4
        8486D5C6B3B084D0FF95D89A2D9D82BFD41B1ADE5B6285107650BF57626B5655
        4EC17D8B8286EDB13BE0D1E585107650C32050D82C36E377466F34764542C3D3
        A05B852884DEAFC4E7F13B08970727E80D0D872784A657E2DDBD56FCAA7C0AEE
        5B7C02A69FEB074FC3761CD2708842E8F14ADC88DF19BDD17DA369F8A448D370
        E62EE856210AA1E195F86CABD08CDF196FD0781B3E0DC76C48C3B410C6324808
        8DAFC4EDF855310FFE5204349CB4EF23F90A51080D34ACC5EF8CDE6010888486
        6FDFBA3A21EC1C04AC7F67DB41E341207C1A8E27200D8728841D346CFD5ADAD6
        FA57E17AD2707842E81E04AC5F5575F7A8FDB927346CDF41347C381F9A10CA41
        C089DF39BB2632BDA0E14402D2706971973B17164241C317F1ABC276FBC1BFA6
        34ACD69F872584FA20508F5F9577B4FE15220DE7E94100D3F0DE02F9404121D4
        68B811BFAAED6B79B1F068B8C00F02F13BE3A049FEF121752A42085BAFC4CDF8
        1D1ADE69F72F288456A617345C5D7D4B9E0B0A61731068C7AFCEB6B57B056978
        080EB48D6BCE15E84160600AD1F0E66A584218EF8BB9E257D5ACE6BF41214C4E
        843D5DCAB2EDC91BA00D2D84E911707FEA83801EBF520707ED7F4321E469F884
        37886EDF064D4214C2F34140C6AF721A0DD7E0D87513DDADC611C42082341CA2
        103AAFC4AEF855301A76CF26F23A02D070B20FD2302D8437D0FD89A5DCF14B1A
        8642C8D3708E3788EE6640135A0853F0FE74C4AFD427ED01ABE6AE250D872784
        86F8553EABDD2B38D5330A1A1E9C42DD8A15426BC45F084DF1AB725623E0B302
        B86FA9716E10A8E5F857E2E414E2AB9084D018BFAAED6929179816EA0D0D8723
        84E6F8953A7A7FED69381421F48A5FD23014C2DED0F0EEE2A585D0337E55D9B9
        FE347C3A7F5921F48EBFF7346CC7210D575637B9737909A15FFC9286615A280A
        1A1EBE8F687873857BA03C84D0377E49C3302D14090D4FA3E9E8878FD175352F
        CF2484FEF1ABEAFBE3F687F068B8008D86E6914C401A2E2DEC71E7320921885F
        A98FDAC9B1108E93C503A513DE201AFF1C69CBB38DAE8510C6AFF2DB5A678569
        A16154EAD138781A8E27862651B7EA5E0871FCAABCADA93F344923A1E16994CD
        EA5A0889F803D27062BC1734CC0BE198ACFFF90F73BB741A8669A108683891C8
        DC417CD59D105AB71E32D3BC0BD9EB4FC35D09A1A5D2733789DFA964B5D7CD72
        0EDC3753A5A9E908978669214C665A42E87C13B11FBF602EF5C3F5A7E12E84F0
        A227FC719619044E7622A1E100AFC49886030B61FD49189D63B8A5B8AD050DD3
        42340D07982E856938A810364682D4835BCCA5F69E86EFA1C12AA010364742EB
        BB3F33BF140D0D07992E8569389010B64F36F50373BB4EB35A678542C8D3307A
        9A9A0743C39FE67921D4BECC91476806C2F9216818A68522A0E164720AD17071
        911642BD33D90F3E672E75571B61A0104642C377C74093EAFA3A77AE987C9866
        BE657EE97057A3612484340D97720168F82EEA56BB0BDC98EA1A4C3E7BC0DC2E
        7DBA5488347CC21B4498864F1F1F31A7725FDAE01C3364491A464248D37080E9
        5298862B2B5B5DC4AF123F4C33977AF0A1FD019AA4B189D04B69191A7EBB8AFB
        93A16BFEE93B8A86F5324298168A84862751B72284D0F4684E3C084CC3302DC4
        D330FF4A8C69180BA17168EA7F8404E6E252751A8669A17AB9393E781AB66C4C
        C35008CD43B335FB2573051FB4957542A4E100D3A5300D0321F4FAF5E91F9931
        3BB713090D9FF00611A6617F21F4FCFA320F196E110611A4E1FEB10868781A4D
        C0F11542EFEE937C0805E6FC52DF6BDF6E8834CC4F978ADF43C5037E42E8F3F8
        583333CC05FC3FD0B0B710FA0E1FF77E625E89050D4393B43734EC2984FE1733
        F40F865BAE010D4FA157772F21043723F1D37DE652050D2321EC110DBF5F345D
        17EC8CDFCC3063B65E3CD0131AB687D1328B2A376F1042FC30720651F19D76AF
        A0104641C3A929C457E5D54E212406A3F4432830E797BAA32D31D71B1A86CB2C
        AA37ABEE1BC30CC69C412468189BA4E1D3B01DC734FCE9B10B523931E20C227D
        BAD475A5E1E2C2BEF8CCC5AF461F31D3BC050D4393347C1A8ED99886ABCF3744
        FC16F7E59206915E3C00D34211D0703286695808A1F5970DCE7B210D22BD9416
        CE9DE76938C074294CC3BA105AFF3ADCA012A5AC41246918D93A37509556E3E0
        69389E189846DD4A1342EB975AEEF58EA28EE139CA20D24B69A110F68686DB42
        68FD723ED5FB15F7E59206915E4A0B6938826516EDF86770B06A0AE179FCAA7C
        B08ED4AA71700691A061288419A657A960D3A5300D3784F0227E553D5E27D7D8
        E00C22513C80697834FCE952A9693401A72E84F5F81DCE7CFD8E3B3567108952
        5A9816E26918496AF3A068F85C081BF13B7729FB921359CE2012C503302DC42F
        3A1E8086273E43DDCA11C256FCAAF2E9195951C519448286615A28121A9E42DD
        AABCDA8EDFE1CCF503451D9C41246918A585781ACED38300A661A5C5EFDCA5CD
        D7DCA9498348D03012C2F069D8B2E370994511BF2AEF3DE79E2FD220D24B6961
        5AC81A85CBB9D68FD2316F10211A96F1ABEAD1DA89A20ECE2012A5B4D0246569
        38C8742940C3AEF89D2BDE20579CE30C22514ADB0B1A4E267C69B8237E557AF7
        921B60488328221A3EE10D223F1AEE8C5F550FD6B815E74883482F1EB876346C
        88DF9198A7E4245ACE20EA3D0D7B6FC1638ADF19A95E90344C1A443B91D0701E
        9DA915A4370D9BE377AEF839776ECE20BA0634ECB1E8B847FCAAF6E909398996
        3388AE2B0D7BC5EF08E1D30F8A3A3883A8F7346C5C58C63B7E557E43EEC8431A
        44D792867DE257D5FD27DCB94983482F1EE8050DDBF1CC3DF720E017BFD3BB56
        C81D79BEF891E9AFA294160A214DC30106810E1AF68DDF19619F9134CC1944A2
        78000A6104CB2C266DD7328B207E55D97AC10D309C41244A69A1491A010D2763
        72D17114BF23842BA441F4B7AF996651D130B948B49B8661FCCE53BB4AD23069
        10E9A5B45008691A0E6010E9344CC4AFCA2FC89232CE2012D3A5A049CA2F3ADE
        150D33F13BD2FD8434887EBEC334D369189AA4D1D23015BF52C7CBA11A447A29
        2D3649691A3EE65F89871ACB2C92F1ABE2937DAE21671089E20198168A9086AD
        7F7245AAAAFAE605D770F011534F2F8A0742A3617E99C5260D5BB3FD64A57AED
        C34AA80691A061248491D0F0E85DEB7CFF037B80EB5D2ABF4CE68639834894D2
        F68486D353C9F3FD1F62694E6254F9F936D79033887A4DC331DB9EACEF7F3140
        72662DFB846B989A630C2249C3282D14090D37F6FF480E9013E18EC805164883
        482F1EC069A10868D89AA97FA9F134D7BB5471954C0B710691982E056998DE82
        E7843588ACAFE2FDF58D60D3AC10BE22D34223738C412469180961E8346C7DA5
        ACFEFA8D4AA5B82FB776F05BA806915E3C00D34261D3B013BF1379FDD627D2AC
        102E70B961D22012A5B4D02465B7E0E168F8227E65D7F7C6B20659215C23A70C
        DEF99979AA82D130BB050F45C3F5F855ACB1532C2D84EFD6B8869C41246818A6
        851213ECC23278BA54237E6535B6C5E185905C60813488F4E281ABA4E166FC4E
        E4F55B1F1B2485B0B444A685BEFE2B6510E9A5B470EE7C6834DC8E5F251AE37F
        9A741EAA2FDE700DBB308842A4617FA6D0E26F09615F3F2984FBCBDC17C01944
        A294F6AA68588FBF0B219CE7D242A441246918211C4DC3C73E5FA53523FEB329
        842C0C5656C995863883E8EA69D89A2D0B968937F687A3B3229BCFB9869C4174
        E534ECBCFF5505263485D04E872C84A44124681809214FC3C71E1779B1FFB1DC
        B3B7AF3EFED342585C3CA6DA910691281E8069A1CBD270FDFDBF28DE3A9A42C8
        C2607583DC8D84338844292D14427E434A230D37F21F15F1D6116BEC0F47C3E0
        EE0AF7BACD1944A294160AE1E568B8B5FFB1AC316C08617C9015C2C75CC68534
        88AE8E865BFBDFD6CEC47F4626849C4124A64B4121A4B7E0E9A4616DFFDF92F8
        9E9B42982247585A08398348D0303449BBA761B1FFB19850D9A4611A060F17B8
        94136910E9D3A5605AA86B1AD6E3F71242D61E282E7195A4A441148C86E9EDD9
        250D8BF82F2D84EBE44401CE2012340CD342DDD1B0F5AD7C1ACBE27B6EA68542
        1742D220DA899C86ADAF1232EDEB12C2FEFA39697B20FF5F6EB6106910E9C503
        91D0B0F3FE1B4B89D85C4298AC6F946A0D905991CA0A3751803488A2A2E1E673
        AEE7BF5B7FC62C84AC3DC00A21671089E281F068B8593C20F2DFAD3F23683832
        21E40C22514A0B69985F74BCCE14AEFC77EB7F4D4248DB03A5454E083983484E
        97422629BF21E5050DBBF3DFAD3F23BEE7E618C966455821240DA20869B823FF
        DDFA334621A4B322AC10720691A4612484340DE7F2552DFFD91CE89A7FC69816
        A2B3226C6A74E811554F1F110D1F9BF2DFCDAFC725848D73B2F600FB46481A44
        A294160A214DC332FFDD2763730961C316A0ED81CD75EE19E00C22514A1B1A0D
        CBF8950B062F2984EC6419CE2012A5B4D0242569D8157F070CE64D69213A2B52
        5AE052A3FD73944114010DBBE3EF80C133933FC2DB03EB5C6A94348844F10034
        49191AEE8CDF0D831E42C84E9ADCFD9D8341CE2012340CD342040D1BE277C3A0
        8710B2591176B24C668E3288F4525A38771ED3B0297E370CBA68B829846C56A4
        F23BB751336710B96818A485200D1BE3EF8041735A88CE8ABCE58490348842A5
        618FF8DD3068F647E8ACC8E1329715B9FFF7ABA661AFF8DD3068F64778215CE6
        D6D7220D2241C348087DB767F78CDF0D83B5A25108E9AC082984A441248A072E
        43C33EF1BB61D03C518086C1BD554E0867BE095C4A0BD342DE34EC17BF1B062F
        2B844B5C3131671089E2019816F2A461DFF8DD30684E0BF1F6C0EF5C31316710
        89E2019816F2DA9012C4EF86C14B0AE1D6334A08498348D2301242330DA3F8DD
        30E812C2C67FD24278BCC4F9E45F7E4F19447A292D1442230DC3F8DD30681642
        3A2B525AE1CA273883484C97826921130DE3F8DD30E812C2863FC20BE14BAE7C
        823388240DA3B9F3061A66E277C3A0D91FA185F080AB23B4BE672E4DD2304C0B
        75D03015BF1B06CD1305687BA0B0C4D511720691281E084CC35CFC1D30681642
        DA1E789AA5DA9106915E3C109486D9F8DD30681642DA1ED85EA34A88923F330B
        2E5F8686ADEFE855C4240C9AD342B43D70B244D903A441244A6903D1B035EBEA
        CB3E878441F344015A08CB2BDC62AB9C41149086275A77E97CFE4B91AD969430
        689E2840DB03EAE52B0A063983A85B1ABE98FF53413567ADDFEBF713C246E0F4
        A4C90F2B943D401A4462BA14A4E1E6163CF5F94F557ABF350983667F84CE8A9C
        2D71F600671089E95250081B5BF034E67FB9A0CEE770C1A01C3C9A23043D69F2
        19B3472B6B107543C3ADF96F657A49590983667F84B607B26B54CF230D22513C
        8084F08286DBF3FFAAECDA212E18F41042362B72B24CD903A441244A69191AD6
        E63FBAC6739F43C2A0392D14BA3DC019448286A1499A1A17F33F4BE4223F2E18
        F49828406745DE6C508F1E671005A46139FFB5D2250C7A08219B15F9C82DB146
        1A44A2780009A16BFE6FB7307849212CAE7C649A910691A0616092BAE2EF1E06
        8D130542B707BA3088FC4DD28EF8BB8641B310D25911D227E70C22514AEB6B92
        76C6DF350C9A8590CE8A9C2E53F6006910091AF6114243FC5DC3A08710B25991
        CA536E5109CE202269D8147FD730E891160ADB1EE00C2249C35E42F83F38C2FC
        8E0943BE060000000049454E44AE426082}
      Sections = <>
      SectionsAppearance.Font.Charset = DEFAULT_CHARSET
      SectionsAppearance.Font.Color = clWindowText
      SectionsAppearance.Font.Height = -11
      SectionsAppearance.Font.Name = 'Tahoma'
      SectionsAppearance.Font.Style = []
      SectionsAppearance.Fill.Color = 15790320
      Header.Text = 'Header'
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Header.Visible = False
      Header.Fill.Color = 15000804
      Footer.Text = 'Footer'
      Footer.Font.Charset = DEFAULT_CHARSET
      Footer.Font.Color = clWindowText
      Footer.Font.Height = -11
      Footer.Font.Name = 'Tahoma'
      Footer.Font.Style = []
      Footer.Fill.Color = 15000804
    end
    object Panel5: TPanel
      Left = 0
      Top = 552
      Width = 274
      Height = 209
      TabOrder = 5
      object Label21: TLabel
        Left = 8
        Top = 10
        Width = 218
        Height = 23
        AutoSize = False
        Caption = 'Font dialog'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Button1: TButton
        Left = 8
        Top = 51
        Width = 75
        Height = 25
        Caption = 'Open'
        TabOrder = 0
        OnClick = Button1Click
      end
      object TMSFNCFontDialog1: TTMSFNCFontDialog
        Left = 232
        Top = 16
        Width = 26
        Height = 26
        Visible = True
        OnDialogResult = TMSFNCFontDialog1DialogResult
      end
      object TMSFNCHTMLText1: TTMSFNCHTMLText
        Left = 8
        Top = 82
        Width = 257
        Height = 115
        ParentDoubleBuffered = False
        Color = clBtnFace
        DoubleBuffered = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        TabOrder = 2
        Fill.Kind = gfkNone
        Stroke.Kind = gskDot
        Stroke.Color = clBlack
        Text = 'This is a sample text for showing the result of the FontDialog.'
        WordWrapping = True
      end
    end
  end
  object Panel4: TPanel
    AlignWithMargins = True
    Left = 740
    Top = 3
    Width = 370
    Height = 763
    Align = alLeft
    TabOrder = 2
    object Label16: TLabel
      Left = 16
      Top = 8
      Width = 345
      Height = 23
      AutoSize = False
      Caption = 'Color Selector/Picker and Color Wheel'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label17: TLabel
      Left = 8
      Top = 43
      Width = 71
      Height = 13
      Caption = 'Selected color:'
    end
    object Label18: TLabel
      Left = 8
      Top = 120
      Width = 62
      Height = 13
      Caption = 'Color Wheel:'
    end
    object Label19: TLabel
      Left = 8
      Top = 337
      Width = 151
      Height = 13
      Caption = 'Color Selector and Color Picker:'
    end
    object Label20: TLabel
      Left = 159
      Top = 360
      Width = 202
      Height = 39
      Caption = 
        'The mode selection will set the mode of the Color Selector and t' +
        'he Color Picker as well.'
      WordWrap = True
    end
    object GroupBox4: TGroupBox
      Left = 8
      Top = 356
      Width = 145
      Height = 88
      Caption = 'Mode'
      TabOrder = 0
      object RadioButton9: TRadioButton
        Left = 6
        Top = 17
        Width = 113
        Height = 17
        Caption = 'Simple'
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = RadioButton9Click
      end
      object RadioButton10: TRadioButton
        Left = 6
        Top = 40
        Width = 113
        Height = 17
        Caption = 'Extended'
        TabOrder = 1
        OnClick = RadioButton10Click
      end
      object RadioButton11: TRadioButton
        Left = 6
        Top = 63
        Width = 113
        Height = 17
        Caption = 'Extended More'
        TabOrder = 2
        OnClick = RadioButton11Click
      end
    end
    object TMSFNCColorWheel1: TTMSFNCColorWheel
      Left = 8
      Top = 139
      Width = 350
      Height = 175
      ParentDoubleBuffered = False
      DoubleBuffered = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      TabOrder = 1
      OnSelectedColorChanged = TMSFNCColorWheel1SelectedColorChanged
    end
    object TMSFNCPanel2: TTMSFNCPanel
      Left = 8
      Top = 62
      Width = 353
      Height = 35
      ParentDoubleBuffered = False
      DoubleBuffered = True
      TabOrder = 2
      Fill.Texture.Data = {
        0954506E67496D61676589504E470D0A1A0A0000000D49484452000000FF0000
        00C8080300000010A9C7ED000000017352474200AECE1CE90000000467414D41
        0000B18F0BFC610500000300504C544582828283838384848485858586868687
        87878888888989898A8A8A8B8B8B8C8C8C8D8D8D8E8E8E8F8F8F909090919191
        9292929393939494949595959696969797979898989999999A9A9A9B9B9B9C9C
        9C9D9D9D9E9E9E9F9F9FA0A0A0A1A1A1A2A2A2A3A3A3A4A4A4A5A5A5A6A6A6A7
        A7A7A8A8A8A9A9A9AAAAAAABABABACACACADADADAEAEAEAFAFAFB0B0B0B1B1B1
        B2B2B2B3B3B3B4B4B4B5B5B5B6B6B6B7B7B7B8B8B8B9B9B9BABABABBBBBBBCBC
        BCBDBDBDBEBEBEBFBFBFC0C0C0C1C1C1C2C2C2C3C3C3C4C4C4C5C5C5C6C6C6C7
        C7C7C8C8C8C9C9C9CACACACBCBCBCCCCCCCDCDCDCECECECFCFCFD0D0D0D1D1D1
        D2D2D2D3D3D3D4D4D4D5D5D5D6D6D6D7D7D7D8D8D8D9D9D9DADADADBDBDBDCDC
        DCDDDDDDDEDEDEDFDFDFE0E0E0E1E1E1E2E2E2E3E3E3E4E4E4E5E5E500000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000000000000000000000000000C4FC672B000000097048597300000EC3
        00000EC301C76FA8640000001974455874536F667477617265007061696E742E
        6E657420342E302E3231F12069950000128B4944415478DAD59DE9571B4716C5
        AB25B510080C168B9D78013293CC64426672423239B1CDCC9973F279BECEC9DF
        3C660BC4C606AF6084596CB30809ADD3A0AD5EABBAEF6DD18D98FE64E1A2E9A7
        AEAEFBEB77EB55597F50CD23351657CC51CBE7CB5443A592C9C921FF16D5A7AF
        B853C54793A8492AD1F1A38FD95AFB43DF786780563B7E151FEFE3AEE5ECB448
        7E0189C4E713A0C9BBDF2ADCB96EA6510B3B69B97F94DF2CB53FC4C6537EF12B
        353AC85D4A397756E35AC61323F741B73A9ACF71E71AB8698116F154478BF296
        7EF69B377CE3578319F427EA47357746DE352BD93F95F26F525ECE72E7B24713
        A08595EAF8B26BBBFBDAA77426E617BF4A8EA33FD1386B215FA21A3A576DDF1F
        014D5EAC71DDC91A4DA1267D76C78F0EB7ABDAD58C8B06EEF8556CAC9F0BAB98
        2B91CF402271EB36E856FB8B67DCB9866EA00E6A1804CEDE6AE3953536E017BF
        5223C3DCA59473C52AD73266DF9804DDAA30FF913B575F06A9542C1573FFA8B2
        75A27D1A1E6E7F4386F8D5C0684C3147F5B4C00E02766A6A009C2C3C21340C02
        6A6F57FBA029BD297EF733E279D4CE4EE9412071771434095108939D5FD1F196
        D659DB4A6F8CDFF58CF81CA51376108827C6EE82473744214CF475B4286E16B4
        4F9921BFF8E533E277547267F420909E023D374421340D02D943ED537AD4F28B
        9FA7E1D30249C3960D69384C2134D0F0C18EF6C19E48F8C51F808673EC2040D0
        708842681804725BDABDB2C6FBFDE28F86866FDE03DD2A3FFF893B171642030D
        9736F3DAA7E111DFF8A3A1E169D0ADAA4F5E73E72284B0BF6310A86575CE488D
        FBC6CFD330FF4A6CDB9388AFB656421342F44A1CF78FDFF4C6683E8A39FE9518
        D2F0D1E353EE5C5808D12B3188BF47345C5E7CCF9D0B0B217825B6BE298013F4
        8486D5C6B3B084D0FF95D89A2D9D82BFD41B1ADE5B6285107650BF57626B5655
        4EC17D8B8286EDB13BE0D1E585107650C32050D82C36E377466F34764542C3D3
        A05B852884DEAFC4E7F13B08970727E80D0D872784A657E2DDBD56FCAA7C0AEE
        5B7C02A69FEB074FC3761CD2708842E8F14ADC88DF19BDD17DA369F8A448D370
        E62EE856210AA1E195F86CABD08CDF196FD0781B3E0DC76C48C3B410C6324808
        8DAFC4EDF855310FFE5204349CB4EF23F90A51080D34ACC5EF8CDE6010888486
        6FDFBA3A21EC1C04AC7F67DB41E341207C1A8E27200D8728841D346CFD5ADAD6
        FA57E17AD2707842E81E04AC5F5575F7A8FDB927346CDF41347C381F9A10CA41
        C089DF39BB2632BDA0E14402D2706971973B17164241C317F1ABC276FBC1BFA6
        34ACD69F872584FA20508F5F9577B4FE15220DE7E94100D3F0DE02F9404121D4
        68B811BFAAED6B79B1F068B8C00F02F13BE3A049FEF121752A42085BAFC4CDF8
        1D1ADE69F72F288456A617345C5D7D4B9E0B0A61731068C7AFCEB6B57B056978
        080EB48D6BCE15E84160600AD1F0E66A584218EF8BB9E257D5ACE6BF41214C4E
        843D5DCAB2EDC91BA00D2D84E911707FEA83801EBF520707ED7F4321E469F884
        37886EDF064D4214C2F34140C6AF721A0DD7E0D87513DDADC611C42082341CA2
        103AAFC4AEF855301A76CF26F23A02D070B20FD2302D8437D0FD89A5DCF14B1A
        8642C8D3708E3788EE6640135A0853F0FE74C4AFD427ED01ABE6AE250D872784
        86F8553EABDD2B38D5330A1A1E9C42DD8A15426BC45F084DF1AB725623E0B302
        B86FA9716E10A8E5F857E2E414E2AB9084D018BFAAED6929179816EA0D0D8723
        84E6F8953A7A7FED69381421F48A5FD23014C2DED0F0EEE2A585D0337E55D9B9
        FE347C3A7F5921F48EBFF7346CC7210D575637B9737909A15FFC9286615A280A
        1A1EBE8F687873857BA03C84D0377E49C3302D14090D4FA3E9E8878FD175352F
        CF2484FEF1ABEAFBE3F687F068B8008D86E6914C401A2E2DEC71E7320921885F
        A98FDAC9B1108E93C503A513DE201AFF1C69CBB38DAE8510C6AFF2DB5A678569
        A16154EAD138781A8E27862651B7EA5E0871FCAABCADA93F344923A1E16994CD
        EA5A0889F803D27062BC1734CC0BE198ACFFF90F73BB741A8669A108683891C8
        DC417CD59D105AB71E32D3BC0BD9EB4FC35D09A1A5D2733789DFA964B5D7CD72
        0EDC3753A5A9E908978669214C665A42E87C13B11FBF602EF5C3F5A7E12E84F0
        A227FC719619044E7622A1E100AFC49886030B61FD49189D63B8A5B8AD050DD3
        42340D07982E856938A810364682D4835BCCA5F69E86EFA1C12AA010364742EB
        BB3F33BF140D0D07992E8569389010B64F36F50373BB4EB35A678542C8D3307A
        9A9A0743C39FE67921D4BECC91476806C2F9216818A68522A0E164720AD17071
        911642BD33D90F3E672E75571B61A0104642C377C74093EAFA3A77AE987C9866
        BE657EE97057A3612484340D97720168F82EEA56BB0BDC98EA1A4C3E7BC0DC2E
        7DBA5488347CC21B4498864F1F1F31A7725FDAE01C3364491A464248D37080E9
        5298862B2B5B5DC4AF123F4C33977AF0A1FD019AA4B189D04B69191A7EBB8AFB
        93A16BFEE93B8A86F5324298168A84862751B72284D0F4684E3C084CC3302DC4
        D330FF4A8C69180BA17168EA7F8404E6E252751A8669A17AB9393E781AB66C4C
        C35008CD43B335FB2573051FB4957542A4E100D3A5300D0321F4FAF5E91F9931
        3BB713090D9FF00611A6617F21F4FCFA320F196E110611A4E1FEB10868781A4D
        C0F11542EFEE937C0805E6FC52DF6BDF6E8834CC4F978ADF43C5037E42E8F3F8
        583333CC05FC3FD0B0B710FA0E1FF77E625E89050D4393B43734EC2984FE1733
        F40F865BAE010D4FA157772F21043723F1D37DE652050D2321EC110DBF5F345D
        17EC8CDFCC3063B65E3CD0131AB687D1328B2A376F1042FC30720651F19D76AF
        A0104641C3A929C457E5D54E212406A3F4432830E797BAA32D31D71B1A86CB2C
        AA37ABEE1BC30CC69C412468189BA4E1D3B01DC734FCE9B10B523931E20C227D
        BAD475A5E1E2C2BEF8CCC5AF461F31D3BC050D4393347C1A8ED99886ABCF3744
        FC16F7E59206915E3C00D34211D0703286695808A1F5970DCE7B210D22BD9416
        CE9DE76938C074294CC3BA105AFF3ADCA012A5AC41246918D93A37509556E3E0
        69389E189846DD4A1342EB975AEEF58EA28EE139CA20D24B69A110F68686DB42
        68FD723ED5FB15F7E59206915E4A0B6938826516EDF86770B06A0AE179FCAA7C
        B08ED4AA71700691A061288419A657A960D3A5300D3784F0227E553D5E27D7D8
        E00C22513C80697834FCE952A9693401A72E84F5F81DCE7CFD8E3B3567108952
        5A9816E26918496AF3A068F85C081BF13B7729FB921359CE2012C503302DC42F
        3A1E8086273E43DDCA11C256FCAAF2E9195951C519448286615A28121A9E42DD
        AABCDA8EDFE1CCF503451D9C41246918A585781ACED38300A661A5C5EFDCA5CD
        D7DCA9498348D03012C2F069D8B2E370994511BF2AEF3DE79E2FD220D24B6961
        5AC81A85CBB9D68FD2316F10211A96F1ABEAD1DA89A20ECE2012A5B4D0246569
        38C8742940C3AEF89D2BDE20579CE30C22514ADB0B1A4E267C69B8237E557AF7
        921B60488328221A3EE10D223F1AEE8C5F550FD6B815E74883482F1EB876346C
        88DF9198A7E4245ACE20EA3D0D7B6FC1638ADF19A95E90344C1A443B91D0701E
        9DA915A4370D9BE377AEF839776ECE20BA0634ECB1E8B847FCAAF6E909398996
        3388AE2B0D7BC5EF08E1D30F8A3A3883A8F7346C5C58C63B7E557E43EEC8431A
        44D792867DE257D5FD27DCB94983482F1EE8050DDBF1CC3DF720E017BFD3BB56
        C81D79BEF891E9AFA294160A214DC30106810E1AF68DDF19619F9134CC1944A2
        78000A6104CB2C266DD7328B207E55D97AC10D309C41244A69A1491A010D2763
        72D17114BF23842BA441F4B7AF996651D130B948B49B8661FCCE53BB4AD23069
        10E9A5B45008691A0E6010E9344CC4AFCA2FC89232CE2012D3A5A049CA2F3ADE
        150D33F13BD2FD8434887EBEC334D369189AA4D1D23015BF52C7CBA11A447A29
        2D3649691A3EE65F89871ACB2C92F1ABE2937DAE21671089E20198168A9086AD
        7F7245AAAAFAE605D770F011534F2F8A0742A3617E99C5260D5BB3FD64A57AED
        C34AA80691A061248491D0F0E85DEB7CFF037B80EB5D2ABF4CE68639834894D2
        F68486D353C9F3FD1F62694E6254F9F936D79033887A4DC331DB9EACEF7F3140
        72662DFB846B989A630C2249C3282D14090D37F6FF480E9013E18EC805164883
        482F1EC069A10868D89AA97FA9F134D7BB5471954C0B710691982E056998DE82
        E7843588ACAFE2FDF58D60D3AC10BE22D34223738C412469180961E8346C7DA5
        ACFEFA8D4AA5B82FB776F05BA806915E3C00D34261D3B013BF1379FDD627D2AC
        102E70B961D22012A5B4D02465B7E0E168F8227E65D7F7C6B20659215C23A70C
        DEF99979AA82D130BB050F45C3F5F855ACB1532C2D84EFD6B8869C41246818A6
        851213ECC23278BA54237E6535B6C5E185905C60813488F4E281ABA4E166FC4E
        E4F55B1F1B2485B0B444A685BEFE2B6510E9A5B470EE7C6834DC8E5F251AE37F
        9A741EAA2FDE700DBB308842A4617FA6D0E26F09615F3F2984FBCBDC17C01944
        A294F6AA68588FBF0B219CE7D242A441246918211C4DC3C73E5FA53523FEB329
        842C0C5656C995863883E8EA69D89A2D0B968937F687A3B3229BCFB9869C4174
        E534ECBCFF5505263485D04E872C84A44124681809214FC3C71E1779B1FFB1DC
        B3B7AF3EFED342585C3CA6DA910691281E8069A1CBD270FDFDBF28DE3A9A42C8
        C2607583DC8D84338844292D14427E434A230D37F21F15F1D6116BEC0F47C3E0
        EE0AF7BACD1944A294160AE1E568B8B5FFB1AC316C08617C9015C2C75CC68534
        88AE8E865BFBDFD6CEC47F4626849C4124A64B4121A4B7E0E9A4616DFFDF92F8
        9E9B42982247585A08398348D0303449BBA761B1FFB19850D9A4611A060F17B8
        94136910E9D3A5605AA86B1AD6E3F71242D61E282E7195A4A441148C86E9EDD9
        250D8BF82F2D84EBE44401CE2012340CD342DDD1B0F5AD7C1ACBE27B6EA68542
        1742D220DA899C86ADAF1232EDEB12C2FEFA39697B20FF5F6EB6106910E9C503
        91D0B0F3FE1B4B89D85C4298AC6F946A0D905991CA0A3751803488A2A2E1E673
        AEE7BF5B7FC62C84AC3DC00A21671089E281F068B8593C20F2DFAD3F23683832
        21E40C22514A0B69985F74BCCE14AEFC77EB7F4D4248DB03A5454E083983484E
        97422629BF21E5050DBBF3DFAD3F23BEE7E618C966455821240DA20869B823FF
        DDFA334621A4B322AC10720691A4612484340DE7F2552DFFD91CE89A7FC69816
        A2B3226C6A74E811554F1F110D1F9BF2DFCDAFC725848D73B2F600FB46481A44
        A294160A214DC332FFDD2763730961C316A0ED81CD75EE19E00C22514A1B1A0D
        CBF8950B062F2984EC6419CE2012A5B4D0242569D8157F070CE64D69213A2B52
        5AE052A3FD73944114010DBBE3EF80C133933FC2DB03EB5C6A94348844F10034
        49191AEE8CDF0D831E42C84E9ADCFD9D8341CE2012340CD342040D1BE277C3A0
        8710B2591176B24C668E3288F4525A38771ED3B0297E370CBA68B829846C56A4
        F23BB751336710B96818A485200D1BE3EF8041735A88CE8ABCE58490348842A5
        618FF8DD3068F647E8ACC8E1329715B9FFF7ABA661AFF8DD3068F64778215CE6
        D6D7220D2241C348087DB767F78CDF0D83B5A25108E9AC082984A441248A072E
        43C33EF1BB61D03C518086C1BD554E0867BE095C4A0BD342DE34EC17BF1B062F
        2B844B5C3131671089E2019816F2A461DFF8DD30684E0BF1F6C0EF5C31316710
        89E2019816F2DA9012C4EF86C14B0AE1D6334A08498348D2301242330DA3F8DD
        30E812C2C67FD24278BCC4F9E45F7E4F19447A292D1442230DC3F8DD30681642
        3A2B525AE1CA273883484C97826921130DE3F8DD30E812C2863FC20BE14BAE7C
        823388240DA3B9F3061A66E277C3A0D91FA185F080AB23B4BE672E4DD2304C0B
        75D03015BF1B06CD1305687BA0B0C4D511720691281E084CC35CFC1D30681642
        DA1E789AA5DA9106915E3C109486D9F8DD30681642DA1ED85EA34A88923F330B
        2E5F8686ADEFE855C4240C9AD342B43D70B244D903A441244A6903D1B035EBEA
        CB3E878441F344015A08CB2BDC62AB9C41149086275A77E97CFE4B91AD969430
        689E2840DB03EAE52B0A063983A85B1ABE98FF53413567ADDFEBF713C246E0F4
        A4C90F2B943D401A4462BA14A4E1E6163CF5F94F557ABF350983667F84CE8A9C
        2D71F600671089E95250081B5BF034E67FB9A0CEE770C1A01C3C9A23043D69F2
        19B3472B6B107543C3ADF96F657A49590983667F84B607B26B54CF230D22513C
        8084F08286DBF3FFAAECDA212E18F41042362B72B24CD903A441244A69191AD6
        E63FBAC6739F43C2A0392D14BA3DC019448286A1499A1A17F33F4BE4223F2E18
        F49828406745DE6C508F1E671005A46139FFB5D2250C7A08219B15F9C82DB146
        1A44A2780009A16BFE6FB7307849212CAE7C649A910691A0616092BAE2EF1E06
        8D130542B707BA3088FC4DD28EF8BB8641B310D25911D227E70C22514AEB6B92
        76C6DF350C9A8590CE8A9C2E53F6006910091AF6114243FC5DC3A08710B25991
        CA536E5109CE202269D8147FD730E891160ADB1EE00C2249C35E42F83F38C2FC
        8E0943BE060000000049454E44AE426082}
      Sections = <>
      SectionsAppearance.Font.Charset = DEFAULT_CHARSET
      SectionsAppearance.Font.Color = clWindowText
      SectionsAppearance.Font.Height = -11
      SectionsAppearance.Font.Name = 'Tahoma'
      SectionsAppearance.Font.Style = []
      SectionsAppearance.Fill.Color = 15790320
      Header.Text = 'Header'
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Header.Visible = False
      Header.Fill.Color = 15000804
      Footer.Text = 'Footer'
      Footer.Font.Charset = DEFAULT_CHARSET
      Footer.Font.Color = clWindowText
      Footer.Font.Height = -11
      Footer.Font.Name = 'Tahoma'
      Footer.Font.Style = []
      Footer.Fill.Color = 15000804
    end
    object TMSFNCColorPicker1: TTMSFNCColorPicker
      Left = 159
      Top = 422
      Width = 60
      Height = 22
      ParentDoubleBuffered = False
      DoubleBuffered = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      TabOrder = 3
      DropDownWidth = 200.000000000000000000
      DropDownHeight = 175.000000000000000000
      Appearance.Stroke.Color = 11119017
      Appearance.Fill.Color = 15329769
      Appearance.StrokeHover.Color = 10061943
      Appearance.FillHover.Color = 13419707
      Appearance.StrokeDown.Color = 9470064
      Appearance.FillDown.Color = 13156536
      Appearance.StrokeSelected.Color = 5197615
      Appearance.FillSelected.Color = 13156536
      Appearance.StrokeDisabled.Color = 11119017
      Appearance.FillDisabled.Color = clSilver
      Appearance.VerticalSpacing = 0.041666667908430100
      Appearance.HorizontalSpacing = 0.041666667908430100
      Appearance.SeparatorStroke.Color = 11119017
      Appearance.Font.Charset = DEFAULT_CHARSET
      Appearance.Font.Color = clWindowText
      Appearance.Font.Height = 0
      Appearance.Font.Name = 'Tahoma'
      Appearance.Font.Style = []
      Rows = 7
      Columns = 8
      Items = <
        item
          ColumnSpan = 8
          Text = 'Automatic'
          Color = clBlack
        end
        item
          Color = clBlack
        end
        item
          Color = 10040064
        end
        item
          Color = 3355392
        end
        item
          Color = 13056
        end
        item
          Color = 13158
        end
        item
          Color = clNavy
        end
        item
          Color = 3355445
        end
        item
          Color = 3355443
        end
        item
          Color = clMaroon
        end
        item
          Color = 26367
        end
        item
          Color = clOlive
        end
        item
          Color = clGreen
        end
        item
          Color = clTeal
        end
        item
          Color = clBlue
        end
        item
          Color = 10053222
        end
        item
          Color = clGray
        end
        item
          Color = clRed
        end
        item
          Color = 39423
        end
        item
          Color = 52377
        end
        item
          Color = 6723891
        end
        item
          Color = 13421619
        end
        item
          Color = 16737843
        end
        item
          Color = clPurple
        end
        item
          Color = 10066329
        end
        item
          Color = clFuchsia
        end
        item
          Color = 52479
        end
        item
          Color = clYellow
        end
        item
          Color = clLime
        end
        item
          Color = clAqua
        end
        item
          Color = 16763904
        end
        item
          Color = 6697881
        end
        item
          Color = clSilver
        end
        item
          Color = 13408767
        end
        item
          Color = 10079487
        end
        item
          Color = 10092543
        end
        item
          Color = 13434828
        end
        item
          Color = 16777164
        end
        item
          Color = 16764057
        end
        item
          Color = 16751052
        end
        item
          Color = clWhite
        end
        item
          CanSelect = False
          ColumnSpan = 8
          Text = 'More Colors...'
          Color = clBlack
        end
        item
          Visible = False
          Color = clBlack
        end>
      Mode = csmExtendedMore
      OnColorSelected = TMSFNCColorPicker1ColorSelected
    end
    object TMSFNCColorSelector1: TTMSFNCColorSelector
      Left = 0
      Top = 450
      Width = 135
      Height = 135
      ParentDoubleBuffered = False
      DoubleBuffered = True
      TabOrder = 4
      Appearance.Stroke.Color = 11119017
      Appearance.Fill.Color = 15329769
      Appearance.StrokeHover.Color = 10061943
      Appearance.FillHover.Color = 13419707
      Appearance.StrokeDown.Color = 9470064
      Appearance.FillDown.Color = 13156536
      Appearance.StrokeSelected.Color = 5197615
      Appearance.FillSelected.Color = 13156536
      Appearance.StrokeDisabled.Color = 11119017
      Appearance.FillDisabled.Color = clSilver
      Appearance.SeparatorStroke.Color = 11119017
      Appearance.Font.Charset = DEFAULT_CHARSET
      Appearance.Font.Color = clWindowText
      Appearance.Font.Height = -11
      Appearance.Font.Name = 'Tahoma'
      Appearance.Font.Style = []
      Items = <
        item
          Color = clBlack
        end
        item
          Color = clMaroon
        end
        item
          Color = clGreen
        end
        item
          Color = clOlive
        end
        item
          Color = clNavy
        end
        item
          Color = clPurple
        end
        item
          Color = clTeal
        end
        item
          Color = clSilver
        end
        item
          Color = clGray
        end
        item
          Color = clRed
        end
        item
          Color = clLime
        end
        item
          Color = clYellow
        end
        item
          Color = clBlue
        end
        item
          Color = clFuchsia
        end
        item
          Color = clAqua
        end
        item
          Color = clWhite
        end>
      OnColorSelected = TMSFNCColorSelector1ColorSelected
    end
  end
end
