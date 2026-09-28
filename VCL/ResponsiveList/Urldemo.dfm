object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Responsive list demo'
  ClientHeight = 439
  ClientWidth = 274
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    274
    439)
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 32
    Top = 405
    Width = 158
    Height = 26
    Anchors = [akLeft, akBottom]
    Caption = 'Resize the form to see effect on the responsive list'
    WordWrap = True
    ExplicitTop = 449
  end
  object Label1: TLabel
    Left = 32
    Top = 20
    Width = 33
    Height = 13
    Caption = 'Car list'
  end
  object TMSFNCResponsiveList1: TTMSFNCResponsiveList
    Left = 32
    Top = 39
    Width = 207
    Height = 361
    Cursor = crDefault
    HorzScrollBar.Range = 185
    HorzScrollBar.Tracking = True
    VertScrollBar.Range = 447
    VertScrollBar.Tracking = True
    Anchors = [akLeft, akTop, akRight, akBottom]
    ReadOnly = True
    TabOrder = 0
    BorderColor = clNone
    Conditions = <
      item
        Columns = 0
        HeightFrom = -1
        ItemHeight = 150
        WidthTo = 250
        Tag = 0
      end
      item
        Columns = 2
        HeightFrom = -1
        ItemHeight = 150
        WidthFrom = 250
        WidthTo = 500
        Tag = 0
      end
      item
        Columns = 3
        HeightFrom = -1
        ItemHeight = 150
        WidthFrom = 500
        WidthTo = 750
        Tag = 0
      end
      item
        Columns = 4
        HeightFrom = -1
        ItemHeight = 150
        WidthFrom = 750
        Tag = 0
      end>
    Items = <
      item
        Content = 'item 1'
        HeaderColor = 16436871
        Visible = True
        ControlName = ''
      end
      item
        Content = 'item 2'
        HeaderColor = 16436871
        Visible = True
        ControlName = ''
      end
      item
        Content = 'item 3'
        HeaderColor = 16436871
        Visible = True
        ControlName = ''
      end>
    Version = '1.2.0.0'
  end
end
