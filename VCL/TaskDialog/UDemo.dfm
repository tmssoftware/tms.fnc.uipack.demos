object Form130: TForm130
  Left = 0
  Top = 0
  Caption = 'TMS FNC UI Pack - TaskDialog'
  ClientHeight = 640
  ClientWidth = 1200
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object DemoHeader: TTMSFNCPanel
    Left = 0
    Top = 0
    Width = 616
    Height = 72
    Align = alTop
    TabOrder = 0
    Fill.Kind = gfkNone
    Stroke.Kind = gskNone
    Header.Visible = False
    object DemoThemeSelector: TTMSFNCThemeSelector
      AlignWithMargins = True
      Left = 432
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
      Width = 392
      Height = 30
      Anchors = [akLeft, akTop, akRight]
      Font.Height = -20
      Font.Name = 'Segoe UI Semibold'
      TabOrder = 1
      HorizontalTextAlign = gtaLeading
      Trimming = gttCharacter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Text = 'TaskDialog'
    end
    object DemoDescription: TTMSFNCHTMLText
      Left = 24
      Top = 42
      Width = 392
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      TextRole = htrSecondary
      HorizontalTextAlign = gtaLeading
      Trimming = gttCharacter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Text = 'Design a dialog with the options, or show a ready-made one'
    end
  end
  object Panel3: TTMSFNCPanel
    Align = alLeft
    AlignWithMargins = True
    Margins.Left = 16
    Margins.Top = 0
    Margins.Right = 8
    Margins.Bottom = 16
    Width = 288
    Height = 552
    Header.Visible = False
    object TDSecReady: TTMSFNCHTMLText
      Anchors = [akLeft, akTop, akRight]
      Left = 16
      Top = 12
      Width = 256
      Height = 24
      Font.Height = -17
      Font.Name = 'Segoe UI Semibold'
      Text = 'Ready-made dialogs'
      HorizontalTextAlign = gtaLeading
      VerticalTextAlign = gtaCenter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object TDReadyHint: TTMSFNCHTMLText
      Anchors = [akLeft, akTop, akRight]
      Left = 16
      Top = 44
      Width = 256
      Height = 64
      Text = 'Show a complete dialog with one click, or design your own with the options on the right.'
      HorizontalTextAlign = gtaLeading
      VerticalTextAlign = gtaLeading
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      WordWrapping = True
      TextRole = htrSecondary
    end
    object Button2: TTMSFNCButton
      Anchors = [akLeft, akTop, akRight]
      Left = 16
      Top = 116
      Width = 256
      Height = 32
      Text = 'Dialog with radio buttons'
      Font.Height = -13
      Font.Style = []
      OnClick = Button2Click
    end
    object Button3: TTMSFNCButton
      Anchors = [akLeft, akTop, akRight]
      Left = 16
      Top = 156
      Width = 256
      Height = 32
      Text = 'Dialog with custom buttons'
      Font.Height = -13
      Font.Style = []
      OnClick = Button3Click
    end
    object Button4: TTMSFNCButton
      Anchors = [akLeft, akTop, akRight]
      Left = 16
      Top = 196
      Width = 256
      Height = 32
      Text = 'Dialog with footer and verify box'
      Font.Height = -13
      Font.Style = []
      OnClick = Button4Click
    end
    object Label12: TTMSFNCHTMLText
      Anchors = [akLeft, akTop, akRight]
      Left = 16
      Top = 252
      Width = 256
      Height = 24
      Font.Height = -17
      Font.Name = 'Segoe UI Semibold'
      VerticalTextAlign = gtaCenter
      Text = 'Results'
      HorizontalTextAlign = gtaLeading
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object Label14: TTMSFNCHTMLText
      Left = 16
      Top = 284
      Width = 144
      Height = 24
      VerticalTextAlign = gtaCenter
      Text = 'Modal result:'
      HorizontalTextAlign = gtaLeading
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object Label18: TTMSFNCHTMLText
      Anchors = [akLeft, akTop, akRight]
      Left = 168
      Top = 284
      Width = 104
      Height = 24
      VerticalTextAlign = gtaCenter
      Text = '-'
      HorizontalTextAlign = gtaLeading
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object Label15: TTMSFNCHTMLText
      Left = 16
      Top = 312
      Width = 144
      Height = 24
      VerticalTextAlign = gtaCenter
      Text = 'Selected radio button:'
      HorizontalTextAlign = gtaLeading
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object Label19: TTMSFNCHTMLText
      Anchors = [akLeft, akTop, akRight]
      Left = 168
      Top = 312
      Width = 104
      Height = 24
      VerticalTextAlign = gtaCenter
      Text = '-'
      HorizontalTextAlign = gtaLeading
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object Label16: TTMSFNCHTMLText
      Left = 16
      Top = 340
      Width = 144
      Height = 24
      VerticalTextAlign = gtaCenter
      Text = 'Verify checked:'
      HorizontalTextAlign = gtaLeading
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object Label20: TTMSFNCHTMLText
      Anchors = [akLeft, akTop, akRight]
      Left = 168
      Top = 340
      Width = 104
      Height = 24
      VerticalTextAlign = gtaCenter
      Text = '-'
      HorizontalTextAlign = gtaLeading
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object Label17: TTMSFNCHTMLText
      Left = 16
      Top = 372
      Width = 256
      Height = 24
      VerticalTextAlign = gtaCenter
      Text = 'Input result:'
      HorizontalTextAlign = gtaLeading
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object Memo6: TMemo
      Anchors = [akLeft, akTop, akRight]
      Left = 16
      Top = 400
      Width = 256
      Height = 64
    end
    object TMSFNCBitmapContainer1: TTMSFNCBitmapContainer
      Left = 264
      Top = 8
      Width = 26
      Height = 26
      Visible = True
      Items = <
        item
          Bitmap.Data = {
            0954506E67496D61676589504E470D0A1A0A0000000D49484452000000200000
            00200806000000737A7AF4000000097048597300000EC300000EC301C76FA864
            000000844944415478DAEDD5A11180300C8561322623B0003A5816C0E2180B36
            2915C5726DF24280CB33EDD5FC9F2B75CEA3570398399593C66DD9F3759AFB61
            F502A4F27C202112C0350844038040100015040910412C004D104B4015E4D780
            DBB025A02A6C01680A2301A23002A00A6B0090B004E0FB1D23A3010840000210
            80EF009E983BE0043A37CE219645C7AA0000000049454E44AE426082}
          Name = 'Flag-Green.png'
          Tag = 0
        end>
    end
  end
  object ContentPanel: TTMSFNCPanel
    Align = alClient
    AlignWithMargins = True
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 16
    Margins.Bottom = 16
    Width = 872
    Height = 552
    Header.Visible = False
    Fill.Kind = gfkNone
    Stroke.Kind = gskNone
  object Panel1: TTMSFNCPanel
    Align = alLeft
    AlignWithMargins = True
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 8
    Margins.Bottom = 0
    Width = 432
    Height = 552
    Header.Visible = False
    object Label1: TTMSFNCHTMLText
      Anchors = [akLeft, akTop, akRight]
      Left = 16
      Top = 12
      Width = 400
      Height = 24
      Font.Height = -17
      Font.Name = 'Segoe UI Semibold'
      VerticalTextAlign = gtaCenter
      Text = 'Title'
      HorizontalTextAlign = gtaLeading
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object CheckBox1: TTMSFNCCheckBox
      Left = 16
      Top = 44
      Width = 116
      Height = 32
      Text = 'Default'
    end
    object Edit1: TTMSFNCEdit
      Anchors = [akLeft, akTop, akRight]
      Left = 140
      Top = 44
      Width = 276
      Height = 32
      Text = 'TMS FNC TaskDialog'
    end
    object Label2: TTMSFNCHTMLText
      Anchors = [akLeft, akTop, akRight]
      Left = 16
      Top = 92
      Width = 400
      Height = 24
      Font.Height = -17
      Font.Name = 'Segoe UI Semibold'
      VerticalTextAlign = gtaCenter
      Text = 'Instruction'
      HorizontalTextAlign = gtaLeading
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object CheckBox2: TTMSFNCCheckBox
      Left = 16
      Top = 124
      Width = 116
      Height = 32
      Text = 'Show'
      Checked = True
      Checked = True
    end
    object Edit2: TTMSFNCEdit
      Anchors = [akLeft, akTop, akRight]
      Left = 140
      Top = 124
      Width = 276
      Height = 32
      Text = 'Do you like the task dialog?'
    end
    object CheckBox3: TTMSFNCCheckBox
      Left = 16
      Top = 164
      Width = 116
      Height = 32
      Text = 'Show icon'
      Checked = True
      Checked = True
    end
    object RadioButton1: TTMSFNCRadioButton
      Left = 140
      Top = 164
      Width = 96
      Height = 32
      GroupName = 'Icon'
      Text = 'Question'
      Checked = True
      TabStop = True
    end
    object RadioButton2: TTMSFNCRadioButton
      Left = 244
      Top = 164
      Width = 88
      Height = 32
      GroupName = 'Icon'
      Text = 'Shield'
    end
    object RadioButton3: TTMSFNCRadioButton
      Left = 340
      Top = 164
      Width = 72
      Height = 32
      GroupName = 'Icon'
      Text = 'Error'
    end
    object Label3: TTMSFNCHTMLText
      Anchors = [akLeft, akTop, akRight]
      Left = 16
      Top = 212
      Width = 400
      Height = 24
      Font.Height = -17
      Font.Name = 'Segoe UI Semibold'
      VerticalTextAlign = gtaCenter
      Text = 'Content'
      HorizontalTextAlign = gtaLeading
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object CheckBox4: TTMSFNCCheckBox
      Left = 16
      Top = 244
      Width = 116
      Height = 32
      Text = 'Show'
      Checked = True
      Checked = True
    end
    object Memo1: TMemo
      Anchors = [akLeft, akTop, akRight]
      Left = 140
      Top = 244
      Width = 276
      Height = 64
      DoubleBuffered = False
      Lines.Strings = (
        'This is the content or description area of the task dialog.'
        ''
        'It supports <b><i>HTML formatting</i></b> too!')
      ParentDoubleBuffered = False
      ScrollBars = ssHorizontal
    end
    object Label4: TTMSFNCHTMLText
      Anchors = [akLeft, akTop, akRight]
      Left = 16
      Top = 324
      Width = 400
      Height = 24
      Font.Height = -17
      Font.Name = 'Segoe UI Semibold'
      VerticalTextAlign = gtaCenter
      Text = 'Radio buttons'
      HorizontalTextAlign = gtaLeading
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object CheckBox5: TTMSFNCCheckBox
      Left = 16
      Top = 356
      Width = 116
      Height = 32
      Text = 'Show'
    end
    object Memo2: TMemo
      Anchors = [akLeft, akTop, akRight]
      Left = 140
      Top = 356
      Width = 276
      Height = 56
      Lines.Strings = (
        'Radio button 1'
        'Radio button 2')
    end
    object Label6: TTMSFNCHTMLText
      Anchors = [akLeft, akTop, akRight]
      Left = 16
      Top = 428
      Width = 400
      Height = 24
      Font.Height = -17
      Font.Name = 'Segoe UI Semibold'
      VerticalTextAlign = gtaCenter
      Text = 'Custom buttons'
      HorizontalTextAlign = gtaLeading
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object CheckBox10: TTMSFNCCheckBox
      Left = 16
      Top = 460
      Width = 116
      Height = 32
      Text = 'Show'
    end
    object Memo3: TMemo
      Anchors = [akLeft, akTop, akRight]
      Left = 140
      Top = 460
      Width = 276
      Height = 56
      Lines.Strings = (
        'Custom 1'
        'Custom 2'
        'Custom 3')
    end
    object CheckBox11: TTMSFNCCheckBox
      Left = 16
      Top = 492
      Width = 116
      Height = 32
      Text = 'Command link'
    end
  end
  object Panel2: TTMSFNCPanel
    Align = alClient
    Width = 432
    Height = 552
    Header.Visible = False
    object Label7: TTMSFNCHTMLText
      Anchors = [akLeft, akTop, akRight]
      Left = 16
      Top = 12
      Width = 400
      Height = 24
      Font.Height = -17
      Font.Name = 'Segoe UI Semibold'
      VerticalTextAlign = gtaCenter
      Text = 'Expanded text'
      HorizontalTextAlign = gtaLeading
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object CheckBox12: TTMSFNCCheckBox
      Left = 16
      Top = 44
      Width = 116
      Height = 32
      Text = 'Show'
    end
    object Memo4: TMemo
      Anchors = [akLeft, akTop, akRight]
      Left = 140
      Top = 44
      Width = 276
      Height = 64
      Lines.Strings = (
        
          'This is the expandable text area. It also supports HTML formatti' +
          'ng! <img src="Flag-Green.png"/>')
      ScrollBars = ssHorizontal
    end
    object Label10: TTMSFNCHTMLText
      Anchors = [akLeft, akTop, akRight]
      Left = 16
      Top = 124
      Width = 400
      Height = 24
      Font.Height = -17
      Font.Name = 'Segoe UI Semibold'
      VerticalTextAlign = gtaCenter
      Text = 'Verification box'
      HorizontalTextAlign = gtaLeading
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object CheckBox13: TTMSFNCCheckBox
      Left = 16
      Top = 156
      Width = 116
      Height = 32
      Text = 'Show'
    end
    object Edit5: TTMSFNCEdit
      Anchors = [akLeft, akTop, akRight]
      Left = 140
      Top = 156
      Width = 276
      Height = 32
      Text = 'Don'#39't show again'
    end
    object Label11: TTMSFNCHTMLText
      Anchors = [akLeft, akTop, akRight]
      Left = 16
      Top = 204
      Width = 400
      Height = 24
      Font.Height = -17
      Font.Name = 'Segoe UI Semibold'
      VerticalTextAlign = gtaCenter
      Text = 'Footer'
      HorizontalTextAlign = gtaLeading
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object CheckBox14: TTMSFNCCheckBox
      Left = 16
      Top = 236
      Width = 116
      Height = 32
      Text = 'Show'
    end
    object Memo5: TMemo
      Anchors = [akLeft, akTop, akRight]
      Left = 140
      Top = 236
      Width = 276
      Height = 56
      Lines.Strings = (
        
          'Brought to Delphi by <a href="https://www.tmssoftware.com/">TMS ' +
          'Software</a>')
      ScrollBars = ssHorizontal
    end
    object CheckBox15: TTMSFNCCheckBox
      Left = 16
      Top = 300
      Width = 116
      Height = 32
      Text = 'Show icon'
    end
    object RadioButton4: TTMSFNCRadioButton
      Left = 140
      Top = 300
      Width = 80
      Height = 32
      GroupName = 'FooterIcon'
      Text = 'About'
      Checked = True
      TabStop = True
    end
    object RadioButton5: TTMSFNCRadioButton
      Left = 228
      Top = 300
      Width = 72
      Height = 32
      GroupName = 'FooterIcon'
      Text = 'Info'
    end
    object RadioButton6: TTMSFNCRadioButton
      Left = 308
      Top = 300
      Width = 100
      Height = 32
      GroupName = 'FooterIcon'
      Text = 'Warning'
    end
    object Label13: TTMSFNCHTMLText
      Anchors = [akLeft, akTop, akRight]
      Left = 16
      Top = 348
      Width = 400
      Height = 24
      Font.Height = -17
      Font.Name = 'Segoe UI Semibold'
      VerticalTextAlign = gtaCenter
      Text = 'Input field'
      HorizontalTextAlign = gtaLeading
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object CheckBox16: TTMSFNCCheckBox
      Left = 16
      Top = 380
      Width = 116
      Height = 32
      Text = 'Show'
    end
    object RadioButton7: TTMSFNCRadioButton
      Left = 140
      Top = 380
      Width = 72
      Height = 32
      GroupName = 'InputType'
      Text = 'Edit'
      Checked = True
      TabStop = True
    end
    object RadioButton8: TTMSFNCRadioButton
      Left = 220
      Top = 380
      Width = 72
      Height = 32
      GroupName = 'InputType'
      Text = 'Date'
    end
    object RadioButton9: TTMSFNCRadioButton
      Left = 140
      Top = 420
      Width = 276
      Height = 32
      GroupName = 'InputType'
      Text = 'Custom(TMSFNCColorWheel)'
    end
    object Button1: TTMSFNCButton
      Anchors = [akLeft, akTop, akRight]
      Left = 16
      Top = 476
      Width = 400
      Height = 40
      Default = True
      Text = 'Show dialog'
      Font.Height = -19
      Font.Style = []
      OnClick = Button1Click
    end
  end
  end
  object TMSFNCColorWheel1: TTMSFNCColorWheel
    Left = 1000
    Top = 100
    Width = 350
    Height = 175
    ParentDoubleBuffered = False
    DoubleBuffered = True
    Visible = False
  end
  object TMSFNCTaskDialog1: TTMSFNCTaskDialog
    Left = 255
    Top = 565
    Width = 26
    Height = 26
    Visible = True
    BitmapContainer = TMSFNCBitmapContainer1
  end
  object ThemeManager: TTMSFNCThemeManager
    Theme = 'Fluent Light'
    Left = 24
    Top = 24
  end
end
