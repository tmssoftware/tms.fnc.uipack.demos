object AppData: TAppData
  Height = 240
  Width = 480
  object DataSettings: TTMSFNCDataSettings
    Left = 40
    Top = 24
  end
  object dsOrder: TTMSFNCDataSet
    Active = True
    FieldDefs = <
      item
        Name = 'Id'
        DataType = ftInteger
      end
      item
        Name = 'OrderDate'
        DataType = ftDateTime
      end
      item
        Name = 'Status'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'Amount'
        DataType = ftFloat
      end
      item
        Name = 'CustomerId'
        DataType = ftInteger
      end
      item
        Name = 'CustomerName'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'CustomerCity'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'CustomerCountry'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'CustomerCredit'
        DataType = ftFloat
      end
      item
        Name = 'CustomerActive'
        DataType = ftBoolean
      end
      item
        Name = 'CustomerCreated'
        DataType = ftDateTime
      end>
    DataLink = linkOrder
    Left = 224
    Top = 104
  end
  object linkOrder: TTMSFNCDataLinkREST
    BaseURL = 'http://127.0.0.1:8793/tms/xdata'
    Resource = 'Order'
    Dialect = drdXData
    OrderBy = 'OrderDate desc'
    Expand = 'Customer'
  end
  object dsDsOrder: TDataSource
    DataSet = dsOrder
    Left = 232
    Top = 112
  end
  object dsTask: TTMSFNCDataSet
    Active = True
    FieldDefs = <
      item
        Name = 'Id'
        DataType = ftInteger
      end
      item
        Name = 'Title'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'Status'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'Owner'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'Priority'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'Order'
        DataType = ftInteger
      end
      item
        Name = 'CustomerId'
        DataType = ftInteger
      end>
    DataLink = linkTask
    Left = 240
    Top = 120
  end
  object linkTask: TTMSFNCDataLinkREST
    BaseURL = 'http://127.0.0.1:8793/tms/xdata'
    Resource = 'Task'
    Dialect = drdXData
    Auth = draSignIn
    Secret = 'TaskApi'
    SignInResource = 'LoginService/Login'
    SignInUserField = 'User'
    SignInPasswordField = 'Password'
  end
  object dsDsTask: TDataSource
    DataSet = dsTask
    Left = 248
    Top = 128
  end
end
