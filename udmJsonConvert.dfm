object dmJsonConvert: TdmJsonConvert
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 404
  Width = 434
  object cnSqlite: TFDConnection
    Params.Strings = (
      'Database=V:\JSONConvert\chinook.db'
      'DriverID=SQLite')
    UpdateOptions.AssignedValues = [uvLockMode, uvRefreshMode, uvCheckRequired]
    UpdateOptions.LockMode = lmOptimistic
    UpdateOptions.RefreshMode = rmAll
    ConnectedStoredUsage = [auDesignTime]
    LoginPrompt = False
    Left = 144
    Top = 88
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 88
    Top = 136
  end
  object qryCustomers: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    Connection = cnSqlite
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    SQL.Strings = (
      'select CustomerID, FirstName, LastName, City, State'
      'from customers'
      'order by CustomerID')
    Left = 112
    Top = 248
    object qryCustomersCustomerId: TFDAutoIncField
      FieldName = 'CustomerId'
      Origin = 'CustomerId'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = False
    end
    object qryCustomersFirstName: TWideStringField
      FieldName = 'FirstName'
      Origin = 'FirstName'
      Required = True
      Size = 40
    end
    object qryCustomersLastName: TWideStringField
      FieldName = 'LastName'
      Origin = 'LastName'
      Required = True
    end
    object qryCustomersCity: TWideStringField
      FieldName = 'City'
      Origin = 'City'
      Size = 40
    end
    object qryCustomersState: TWideStringField
      FieldName = 'State'
      Origin = 'State'
      Size = 40
    end
  end
  object qryInvoices: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    MasterSource = srcCustomers
    MasterFields = 'CustomerId'
    DetailFields = 'CustomerId'
    Connection = cnSqlite
    FetchOptions.AssignedValues = [evMode, evCache]
    FetchOptions.Mode = fmAll
    FetchOptions.Cache = [fiBlobs, fiMeta]
    SQL.Strings = (
      'select InvoiceId, CustomerId, InvoiceDate, Total'
      'from Invoices'
      'where CustomerId = :CustomerId'
      'order by InvoiceId'
      '')
    Left = 208
    Top = 248
    ParamData = <
      item
        Name = 'CUSTOMERID'
        DataType = ftAutoInc
        ParamType = ptInput
        Value = 1
      end>
    object qryInvoicesInvoiceId: TFDAutoIncField
      FieldName = 'InvoiceId'
      Origin = 'InvoiceId'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = False
    end
    object qryInvoicesCustomerId: TIntegerField
      FieldName = 'CustomerId'
      Origin = 'CustomerId'
      Required = True
    end
    object qryInvoicesInvoiceDate: TDateTimeField
      FieldName = 'InvoiceDate'
      Origin = 'InvoiceDate'
      Required = True
    end
    object qryInvoicesTotal: TBCDField
      FieldName = 'Total'
      Origin = 'Total'
      Required = True
      EditFormat = '$,0.00'
      Precision = 10
      Size = 2
    end
  end
  object qryInvoiceItems: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    MasterSource = srcInvoices
    MasterFields = 'InvoiceId'
    DetailFields = 'InvoiceId'
    Connection = cnSqlite
    FetchOptions.AssignedValues = [evMode, evCache]
    FetchOptions.Mode = fmAll
    FetchOptions.Cache = [fiBlobs, fiMeta]
    SQL.Strings = (
      'select InvoiceId, InvoiceLineId, TrackId, UnitPrice, Quantity'
      'from invoice_items'
      'where InvoiceId = :InvoiceId'
      'order by InvoiceLineId')
    Left = 304
    Top = 248
    ParamData = <
      item
        Name = 'INVOICEID'
        DataType = ftAutoInc
        ParamType = ptInput
        Value = 98
      end>
    object qryInvoiceItemsInvoiceId: TIntegerField
      FieldName = 'InvoiceId'
      Origin = 'InvoiceId'
      Required = True
    end
    object qryInvoiceItemsInvoiceLineId: TFDAutoIncField
      FieldName = 'InvoiceLineId'
      Origin = 'InvoiceLineId'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = False
    end
    object qryInvoiceItemsTrackId: TIntegerField
      FieldName = 'TrackId'
      Origin = 'TrackId'
      Required = True
    end
    object qryInvoiceItemsUnitPrice: TBCDField
      FieldName = 'UnitPrice'
      Origin = 'UnitPrice'
      Required = True
      DisplayFormat = '$,0.00'
      Precision = 10
      Size = 2
    end
    object qryInvoiceItemsQuantity: TIntegerField
      FieldName = 'Quantity'
      Origin = 'Quantity'
      Required = True
    end
  end
  object srcCustomers: TDataSource
    DataSet = qryCustomers
    Left = 112
    Top = 312
  end
  object srcInvoices: TDataSource
    DataSet = qryInvoices
    Left = 208
    Top = 312
  end
end
