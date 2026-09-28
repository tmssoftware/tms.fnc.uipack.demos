object Form130: TForm130
  Left = 0
  Top = 0
  Caption = 'TMS FNC TaskDialog Demo'
  ClientHeight = 568
  ClientWidth = 616
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
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 297
    Height = 553
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 27
      Height = 18
      Caption = 'Title'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 8
      Top = 57
      Width = 69
      Height = 18
      Caption = 'Instruction'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 8
      Top = 131
      Width = 51
      Height = 18
      Caption = 'Content'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 8
      Top = 233
      Width = 89
      Height = 18
      Caption = 'Radio buttons'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 8
      Top = 342
      Width = 104
      Height = 18
      Caption = 'Custom buttons'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label13: TLabel
      Left = 8
      Top = 470
      Width = 65
      Height = 18
      Caption = 'Input field'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object CheckBox1: TCheckBox
      Left = 8
      Top = 32
      Width = 65
      Height = 17
      Caption = 'Default'
      TabOrder = 0
    end
    object CheckBox2: TCheckBox
      Left = 8
      Top = 81
      Width = 65
      Height = 17
      Caption = 'Show'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object CheckBox3: TCheckBox
      Left = 8
      Top = 108
      Width = 69
      Height = 17
      Caption = 'Show icon'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object CheckBox4: TCheckBox
      Left = 8
      Top = 155
      Width = 65
      Height = 17
      Caption = 'Show'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
    object CheckBox5: TCheckBox
      Left = 8
      Top = 257
      Width = 65
      Height = 17
      Caption = 'Show'
      TabOrder = 4
    end
    object CheckBox10: TCheckBox
      Left = 8
      Top = 366
      Width = 65
      Height = 17
      Caption = 'Show'
      TabOrder = 5
    end
    object CheckBox11: TCheckBox
      Left = 8
      Top = 389
      Width = 82
      Height = 17
      Caption = 'Command link'
      TabOrder = 6
    end
    object CheckBox16: TCheckBox
      Left = 10
      Top = 494
      Width = 97
      Height = 17
      Caption = 'Show'
      TabOrder = 7
    end
    object Edit1: TEdit
      Left = 79
      Top = 30
      Width = 210
      Height = 21
      TabOrder = 8
      Text = 'TMS FNC TaskDialog'
    end
    object Edit2: TEdit
      Left = 79
      Top = 81
      Width = 210
      Height = 21
      TabOrder = 9
      Text = 'Do you like the task dialog?'
    end
    object Memo1: TMemo
      Left = 79
      Top = 153
      Width = 210
      Height = 74
      DoubleBuffered = False
      Lines.Strings = (
        'This is the content or description area of the task dialog.'
        ''
        'It supports <b><i>HTML formatting</i></b> too!')
      ParentDoubleBuffered = False
      ScrollBars = ssHorizontal
      TabOrder = 10
    end
    object Memo2: TMemo
      Left = 79
      Top = 257
      Width = 210
      Height = 42
      Lines.Strings = (
        'Radio button 1'
        'Radio button 2')
      TabOrder = 11
    end
    object Memo3: TMemo
      Left = 96
      Top = 366
      Width = 193
      Height = 60
      Lines.Strings = (
        'Custom 1'
        'Custom 2'
        'Custom 3')
      TabOrder = 12
    end
    object RadioButton1: TRadioButton
      Left = 109
      Top = 108
      Width = 62
      Height = 17
      Caption = 'Question'
      Checked = True
      TabOrder = 13
      TabStop = True
    end
    object RadioButton2: TRadioButton
      Left = 183
      Top = 108
      Width = 58
      Height = 17
      Caption = 'Shield'
      TabOrder = 14
    end
    object RadioButton3: TRadioButton
      Left = 247
      Top = 108
      Width = 42
      Height = 17
      Caption = 'Error'
      TabOrder = 15
    end
    object Panel4: TPanel
      Left = 8
      Top = 517
      Width = 281
      Height = 25
      BevelOuter = bvNone
      TabOrder = 16
      object RadioButton7: TRadioButton
        Left = 2
        Top = 0
        Width = 49
        Height = 17
        Caption = 'Edit'
        Checked = True
        TabOrder = 0
        TabStop = True
      end
      object RadioButton8: TRadioButton
        Left = 57
        Top = 0
        Width = 47
        Height = 17
        Caption = 'Date'
        TabOrder = 1
      end
      object RadioButton9: TRadioButton
        Left = 119
        Top = 0
        Width = 162
        Height = 17
        Caption = 'Custom(TMSFNCColorWheel)'
        TabOrder = 2
      end
    end
    object Button2: TButton
      Left = 8
      Top = 305
      Width = 281
      Height = 31
      Caption = 'Show dialog with radio buttons'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 17
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 8
      Top = 432
      Width = 281
      Height = 32
      Caption = 'Show dialog with command links'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 18
      OnClick = Button3Click
    end
  end
  object Panel2: TPanel
    Left = 311
    Top = 8
    Width = 297
    Height = 389
    TabOrder = 1
    object Label7: TLabel
      Left = 8
      Top = 8
      Width = 95
      Height = 18
      Caption = 'Expanded text'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label10: TLabel
      Left = 8
      Top = 105
      Width = 98
      Height = 18
      Caption = 'Verification box'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label11: TLabel
      Left = 8
      Top = 157
      Width = 42
      Height = 18
      Caption = 'Footer'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object CheckBox12: TCheckBox
      Left = 8
      Top = 32
      Width = 49
      Height = 17
      Caption = 'Show'
      TabOrder = 0
    end
    object CheckBox13: TCheckBox
      Left = 8
      Top = 129
      Width = 49
      Height = 17
      Caption = 'Show'
      TabOrder = 1
    end
    object CheckBox14: TCheckBox
      Left = 8
      Top = 179
      Width = 49
      Height = 17
      Caption = 'Show'
      TabOrder = 2
    end
    object CheckBox15: TCheckBox
      Left = 8
      Top = 247
      Width = 73
      Height = 17
      Caption = 'Show icon'
      TabOrder = 3
    end
    object Edit5: TEdit
      Left = 72
      Top = 129
      Width = 217
      Height = 21
      TabOrder = 4
      Text = 'Don'#39't show again'
    end
    object Memo4: TMemo
      Left = 72
      Top = 32
      Width = 217
      Height = 66
      Lines.Strings = (
        
          'This is the expandable text area. It also supports HTML formatti' +
          'ng! <img src="Flag-Green.png"/>')
      ScrollBars = ssHorizontal
      TabOrder = 5
    end
    object Memo5: TMemo
      Left = 72
      Top = 179
      Width = 217
      Height = 62
      Lines.Strings = (
        
          'Brought to Delphi by <a href="https://www.tmssoftware.com/">TMS ' +
          'Software</a>')
      ScrollBars = ssHorizontal
      TabOrder = 6
    end
    object RadioButton4: TRadioButton
      Left = 103
      Top = 247
      Width = 50
      Height = 17
      Caption = 'About'
      Checked = True
      TabOrder = 7
      TabStop = True
    end
    object RadioButton5: TRadioButton
      Left = 167
      Top = 247
      Width = 49
      Height = 17
      Caption = 'Info'
      TabOrder = 8
    end
    object RadioButton6: TRadioButton
      Left = 222
      Top = 247
      Width = 59
      Height = 17
      Caption = 'Warning'
      TabOrder = 9
    end
    object Button1: TButton
      Left = 8
      Top = 322
      Width = 281
      Height = 57
      Caption = 'Show dialog'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 10
      OnClick = Button1Click
    end
    object Button4: TButton
      Left = 8
      Top = 270
      Width = 281
      Height = 29
      Caption = 'Show dialog with footer and verify box'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 11
      OnClick = Button4Click
    end
  end
  object Panel3: TPanel
    Left = 311
    Top = 403
    Width = 297
    Height = 158
    TabOrder = 2
    object Label12: TLabel
      Left = 8
      Top = 8
      Width = 46
      Height = 18
      Caption = 'Results'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label14: TLabel
      Left = 8
      Top = 32
      Width = 62
      Height = 13
      Caption = 'Modal result:'
    end
    object Label15: TLabel
      Left = 8
      Top = 51
      Width = 107
      Height = 13
      Caption = 'Selected radio button:'
    end
    object Label16: TLabel
      Left = 8
      Top = 70
      Width = 74
      Height = 13
      Caption = 'Verify checked:'
    end
    object Label17: TLabel
      Left = 8
      Top = 89
      Width = 60
      Height = 13
      Caption = 'Input result:'
    end
    object Label18: TLabel
      Left = 89
      Top = 32
      Width = 4
      Height = 13
      Caption = '-'
    end
    object Label19: TLabel
      Left = 131
      Top = 51
      Width = 4
      Height = 13
      Caption = '-'
    end
    object Label20: TLabel
      Left = 96
      Top = 70
      Width = 4
      Height = 13
      Caption = '-'
    end
    object Memo6: TMemo
      Left = 74
      Top = 89
      Width = 215
      Height = 62
      TabOrder = 0
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
  object TMSFNCColorWheel1: TTMSFNCColorWheel
    Left = 624
    Top = 8
    Width = 350
    Height = 175
    ParentDoubleBuffered = False
    DoubleBuffered = True
    TabOrder = 3
    Visible = False
  end
  object TMSFNCTaskDialog1: TTMSFNCTaskDialog
    Left = 255
    Top = 493
    Width = 26
    Height = 26
    Visible = True
    BitmapContainer = TMSFNCBitmapContainer1
    ButtonFont.Charset = DEFAULT_CHARSET
    ButtonFont.Color = clWindowText
    ButtonFont.Height = -11
    ButtonFont.Name = 'Tahoma'
    ButtonFont.Style = []
    CommandLinkFont.Charset = DEFAULT_CHARSET
    CommandLinkFont.Color = 12866304
    CommandLinkFont.Height = -15
    CommandLinkFont.Name = 'Tahoma'
    CommandLinkFont.Style = []
  end
end
