object AppData: TAppData
  Height = 280
  Width = 400
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
    Left = 40
    Top = 104
  end
  object linkOrder: TTMSFNCDataLinkREST
    BaseURL = 'http://127.0.0.1:8793/tms/xdata'
    Resource = 'Order'
    Dialect = drdXData
    OrderBy = 'OrderDate desc'
    Expand = 'Customer'
    Left = 160
    Top = 104
  end
  object dsDsOrder: TDataSource
    DataSet = dsOrder
    Left = 280
    Top = 104
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
    Left = 40
    Top = 184
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
    Left = 160
    Top = 184
  end
  object dsDsTask: TDataSource
    DataSet = dsTask
    Left = 280
    Top = 184
  end
end
