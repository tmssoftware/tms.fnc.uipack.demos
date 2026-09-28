object Form130: TForm130
  Left = 0
  Top = 0
  Caption = 'TMS FNC Signature Capture Demo'
  ClientHeight = 316
  ClientWidth = 656
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
  object TMSFNCSignatureCapture1: TTMSFNCSignatureCapture
    Left = 246
    Top = 8
    Width = 400
    Height = 300
    ParentDoubleBuffered = False
    DoubleBuffered = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    TabOrder = 0
    Pen.Color = clBlack
    TextPosition.Line.Color = clGray
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
  end
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 232
    Height = 300
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 212
      Height = 26
      Caption = 
        'To clear the signature, click the clear icon in the bottom left ' +
        'corner.'
      WordWrap = True
    end
    object Label2: TLabel
      Left = 8
      Top = 40
      Width = 184
      Height = 26
      Caption = 'The images and files are saved to this demo'#39's folder.'
      WordWrap = True
    end
    object Label3: TLabel
      Left = 8
      Top = 183
      Width = 47
      Height = 13
      Caption = 'Pen width'
    end
    object Label4: TLabel
      Left = 77
      Top = 183
      Width = 6
      Height = 13
      Caption = '1'
    end
    object Label5: TLabel
      Left = 210
      Top = 183
      Width = 12
      Height = 13
      Caption = '10'
    end
    object TLabel
      Left = 8
      Top = 152
      Width = 44
      Height = 13
      Caption = 'Pen color'
    end
    object Button1: TButton
      Left = 135
      Top = 213
      Width = 90
      Height = 25
      Caption = 'Save to file'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 135
      Top = 241
      Width = 90
      Height = 25
      Caption = 'Load from file'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 135
      Top = 269
      Width = 90
      Height = 25
      Caption = 'Save to image'
      TabOrder = 2
      OnClick = Button3Click
    end
    object Edit1: TEdit
      Left = 8
      Top = 215
      Width = 121
      Height = 21
      TabOrder = 3
      Text = 'demo.txt'
    end
    object Edit2: TEdit
      Left = 8
      Top = 243
      Width = 121
      Height = 21
      TabOrder = 4
      Text = 'demo.txt'
    end
    object Edit3: TEdit
      Left = 8
      Top = 271
      Width = 121
      Height = 21
      TabOrder = 5
      Text = 'demo.png'
    end
    object TrackBar1: TTrackBar
      Left = 83
      Top = 180
      Width = 129
      Height = 27
      Min = 1
      Position = 1
      TabOrder = 6
      TickStyle = tsNone
      OnChange = TrackBar1Change
    end
    object TMSFNCColorPicker1: TTMSFNCColorPicker
      Left = 77
      Top = 149
      Width = 60
      Height = 22
      ParentDoubleBuffered = False
      DoubleBuffered = True
      TabOrder = 7
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
      OnColorSelected = TMSFNCColorPicker1ColorSelected
      SelectedColor = clBlack
      SelectedItemIndex = 0
    end
  end
end
