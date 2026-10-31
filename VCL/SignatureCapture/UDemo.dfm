object Form130: TForm130
  Left = 0
  Top = 0
  Caption = 'TMS FNC UI Pack - Signature Capture'
  ClientHeight = 560
  ClientWidth = 900
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object DemoHeader: TTMSFNCPanel
    Left = 0
    Top = 0
    Width = 656
    Height = 72
    Align = alTop
    TabOrder = 0
    Fill.Kind = gfkNone
    Stroke.Kind = gskNone
    Header.Visible = False
    object DemoThemeSelector: TTMSFNCThemeSelector
      AlignWithMargins = True
      Left = 472
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
      Width = 432
      Height = 30
      Anchors = [akLeft, akTop, akRight]
      Font.Height = -20
      Font.Name = 'Segoe UI Semibold'
      TabOrder = 1
      HorizontalTextAlign = gtaLeading
      Trimming = gttCharacter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Text = 'Signature Capture'
    end
    object DemoDescription: TTMSFNCHTMLText
      Left = 24
      Top = 42
      Width = 432
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      TextRole = htrSecondary
      HorizontalTextAlign = gtaLeading
      Trimming = gttCharacter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      Text = 'Sign with the mouse, a pen or your finger'
    end
  end
  object Panel1: TTMSFNCPanel
    Align = alLeft
    AlignWithMargins = True
    Margins.Left = 16
    Margins.Top = 0
    Margins.Right = 8
    Margins.Bottom = 16
    Width = 272
    Header.Visible = False
    object SigSecPen: TTMSFNCHTMLText
      Anchors = [akLeft, akTop, akRight]
      Left = 16
      Top = 12
      Width = 240
      Height = 24
      Font.Height = -17
      Font.Name = 'Segoe UI Semibold'
      Text = 'Pen'
      HorizontalTextAlign = gtaLeading
      VerticalTextAlign = gtaCenter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object SigPenColorCaption: TTMSFNCHTMLText
      Left = 16
      Top = 48
      Width = 112
      Height = 32
      Text = 'Pen color'
      HorizontalTextAlign = gtaLeading
      VerticalTextAlign = gtaCenter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object TMSFNCColorPicker1: TTMSFNCColorPicker
      Anchors = [akLeft, akTop, akRight]
      Left = 128
      Top = 48
      Width = 128
      Height = 32
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
      OnColorSelected = TMSFNCColorPicker1ColorSelected
      SelectedColor = clTeal
      SelectedItemIndex = 6
    end
    object Label3: TTMSFNCHTMLText
      Left = 16
      Top = 92
      Width = 112
      Height = 24
      VerticalTextAlign = gtaCenter
      Text = 'Pen width'
      HorizontalTextAlign = gtaLeading
      AutoSize = True
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object TrackBar1: TTMSFNCTrackBar
      Anchors = [akLeft, akTop, akRight]
      Left = 16
      Top = 120
      Width = 240
      Height = 32
      Max = 10.000000000000000000
      Min = 1.000000000000000000
      Value = 1.000000000000000000
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
      OnValueChanged = TrackBar1ValueChanged
    end
    object Label4: TTMSFNCHTMLText
      Left = 16
      Top = 152
      Width = 60
      Height = 24
      VerticalTextAlign = gtaCenter
      TextRole = htrSecondary
      Text = '1'
      HorizontalTextAlign = gtaLeading
      AutoSize = True
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object Label5: TTMSFNCHTMLText
      Anchors = [akTop, akRight]
      Left = 196
      Top = 152
      Width = 60
      Height = 24
      VerticalTextAlign = gtaCenter
      TextRole = htrSecondary
      Text = '10'
      HorizontalTextAlign = gtaTrailing
      AutoSize = True
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object SigSecFiles: TTMSFNCHTMLText
      Anchors = [akLeft, akTop, akRight]
      Left = 16
      Top = 196
      Width = 240
      Height = 24
      Font.Height = -17
      Font.Name = 'Segoe UI Semibold'
      Text = 'Files'
      HorizontalTextAlign = gtaLeading
      VerticalTextAlign = gtaCenter
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object Edit1: TTMSFNCEdit
      Left = 16
      Top = 232
      Width = 112
      Height = 32
      Text = 'demo.txt'
    end
    object Button1: TTMSFNCButton
      Anchors = [akTop, akRight]
      Left = 136
      Top = 232
      Width = 120
      Height = 32
      Text = 'Save to file'
      OnClick = Button1Click
    end
    object Edit2: TTMSFNCEdit
      Left = 16
      Top = 272
      Width = 112
      Height = 32
      Text = 'demo.txt'
    end
    object Button2: TTMSFNCButton
      Anchors = [akTop, akRight]
      Left = 136
      Top = 272
      Width = 120
      Height = 32
      Text = 'Load from file'
      OnClick = Button2Click
    end
    object Edit3: TTMSFNCEdit
      Left = 16
      Top = 312
      Width = 112
      Height = 32
      Text = 'demo.png'
    end
    object Button3: TTMSFNCButton
      Anchors = [akTop, akRight]
      Left = 136
      Top = 312
      Width = 120
      Height = 32
      Text = 'Save to image'
      OnClick = Button3Click
    end
    object Label1: TTMSFNCHTMLText
      Anchors = [akLeft, akTop, akRight]
      Left = 16
      Top = 364
      Width = 240
      Height = 48
      WordWrapping = True
      TextRole = htrSecondary
      VerticalTextAlign = gtaLeading
      Text = 
        'To clear the signature, click the clear icon in the bottom left ' +
        'corner.'
      WordWrapping = True
      HorizontalTextAlign = gtaLeading
      AutoSize = True
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
    object Label2: TTMSFNCHTMLText
      Anchors = [akLeft, akTop, akRight]
      Left = 16
      Top = 420
      Width = 240
      Height = 48
      WordWrapping = True
      TextRole = htrSecondary
      VerticalTextAlign = gtaLeading
      Text = 'The images and files are saved to this demo'#39's folder.'
      WordWrapping = True
      HorizontalTextAlign = gtaLeading
      AutoSize = True
      Fill.Kind = gfkNone
      Stroke.Kind = gskNone
    end
  end
  object TMSFNCSignatureCapture1: TTMSFNCSignatureCapture
    Align = alClient
    AlignWithMargins = True
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 16
    Margins.Bottom = 16
    ClearSig.Image.Data = {
      0954506E67496D61676589504E470D0A1A0A0000000D49484452000000180000
      00180806000000E0773DF8000000097048597300000EC300000EC301C76FA864
      0000015A4944415478DABD95817183300C456103466004BA01D92099A0648366
      82BA13944E906CD07482B0411881113242BE7A9F9E221B9B5C437CA723912D3D
      FB5B823C5B78E44F0338E74A3C3E6105EC077680EFF248C0371E6B3527C9BFE0
      774B01C6D1C356734F8375C59807BF0F56A23325B2E342481F495CE3F10A6BB8
      A90D7C436E1609444E524DE4D9CAAE4C4CC3C4355D2D7C3B4F221324BABFC720
      DCF11E56D23F70AE0BDE4100523141E834BDF1B7B08FD03D25FB20719AE0AEEF
      021022729C025322D536163BE7046B4A554C2CF12E7E360081D2D96FCA251A8B
      1CB65F5EA64A78AA8A0A4A5299E4BFBDC0D2DCABB98190F425B37A4E4612AFD1
      0290237C9B28606E72B55E008D7249F71E8380C8ABC20B8A403CA93440765E9B
      F81DFC6D961806E2BF2A28CDD9C4256B3C02F9ABAA11E0B2DB6EBD2B3973E8CA
      EBF07FA5015AFF9B23FE032285D13DFC9B4C88A8514AD93EEFA3BFD4B802597A
      AE192BE517620000000049454E44AE426082}
    Pen.Color = clTeal
  end
  object ThemeManager: TTMSFNCThemeManager
    Theme = 'Fluent Light'
    Left = 24
    Top = 24
  end
end
