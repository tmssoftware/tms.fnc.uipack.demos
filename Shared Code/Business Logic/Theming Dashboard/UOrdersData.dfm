object OrdersData: TOrdersData
  OnCreate = DataModuleCreate
  Height = 320
  Width = 420
  object Database: TFDConnection
    Params.Strings = (
      'DriverID=SQLite'
      'LockingMode=Normal')
    LoginPrompt = False
    Left = 48
    Top = 32
  end
  object Orders: TFDQuery
    OnCalcFields = OrdersCalcFields
    OnFilterRecord = OrdersFilterRecord
    AfterPost = OrdersChanged
    AfterDelete = OrdersChanged
    OnNewRecord = OrdersNewRecord
    Connection = Database
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    SQL.Strings = (
      'SELECT id, customer, order_date, amount, status, fulfilment, express'
      'FROM orders'
      'ORDER BY id DESC')
    Left = 160
    Top = 32
    object OrdersId: TIntegerField
      DisplayLabel = 'Order'
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      OnGetText = OrdersIdGetText
    end
    object OrdersCustomer: TStringField
      DisplayLabel = 'Customer'
      FieldName = 'customer'
      Origin = 'customer'
      Required = True
      Size = 60
    end
    object OrdersOrderDate: TDateField
      DisplayLabel = 'Date'
      FieldName = 'order_date'
      Origin = 'order_date'
      Required = True
      OnGetText = OrdersOrderDateGetText
    end
    object OrdersAmount: TFloatField
      DisplayLabel = 'Total'
      FieldName = 'amount'
      Origin = 'amount'
      Required = True
      OnGetText = OrdersAmountGetText
    end
    object OrdersStatus: TStringField
      DisplayLabel = 'Status'
      FieldName = 'status'
      Origin = 'status'
      Required = True
      Size = 12
    end
    object OrdersFulfilment: TIntegerField
      DisplayLabel = 'Fulfilment'
      FieldName = 'fulfilment'
      Origin = 'fulfilment'
      Required = True
    end
    object OrdersExpress: TBooleanField
      DisplayLabel = 'Express'
      FieldName = 'express'
      Origin = 'express'
      Required = True
    end
    object OrdersTitle: TStringField
      FieldKind = fkCalculated
      FieldName = 'title'
      Size = 30
      Calculated = True
    end
    object OrdersStatusIndex: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'status_index'
      Calculated = True
    end
    object OrdersStatusKind: TStringField
      FieldKind = fkCalculated
      FieldName = 'status_kind'
      Size = 12
      Calculated = True
    end
  end
  object Kpis: TFDQuery
    Connection = Database
    SQL.Strings = (
      '-- one row: the key figures of the latest month in the data and the goals of its quarter, as numbers and as text'
      'WITH ref AS (SELECT MAX(order_date) AS d FROM orders),'
      ' per AS (SELECT strftime(''%Y-%m'', d) AS cur, strftime(''%Y-%m'', d, ''start of month'', ''-1 month'') AS prev,'
      '   date(d, ''start of month'', ''-'' || ((CAST(strftime(''%m'', d) AS INT) - 1) % 3) || '' months'') AS qstart FROM ref),'
      ' firsts AS (SELECT customer, strftime(''%Y-%m'', MIN(order_date)) AS first FROM orders GROUP BY customer),'
      ' q AS (SELECT orders.* FROM orders, per WHERE order_date >= qstart),'
      ' seen AS (SELECT DISTINCT customer FROM orders, per WHERE order_date < qstart),'
      ' v AS (SELECT'
      '  (SELECT CAST(strftime(''%Y'', d) AS INT) FROM ref) AS ref_year,'
      '  (SELECT CAST(strftime(''%m'', d) AS INT) FROM ref) AS ref_month,'
      '  (SELECT COUNT(*) FROM orders) AS order_count,'
      '  (SELECT COUNT(*) FROM orders WHERE (:status = '''' OR status = :status COLLATE NOCASE)'
      '    AND (:search = '''' OR instr(lower(customer || '' #'' || id), :search) > 0)) AS shown,'
      '  (SELECT TOTAL(amount) FROM orders, per WHERE strftime(''%Y-%m'', order_date) = cur) AS revenue,'
      '  (SELECT TOTAL(amount) FROM orders, per WHERE strftime(''%Y-%m'', order_date) = prev) AS revenue_prev,'
      '  (SELECT COUNT(*) FROM orders WHERE status <> ''Shipped'') AS open_orders,'
      '  (SELECT COUNT(*) FROM orders WHERE status = ''Late'') AS late_orders,'
      '  (SELECT COUNT(*) FROM customers) AS customers,'
      '  (SELECT COUNT(*) FROM firsts, per WHERE first = cur) AS new_customers,'
      '  (SELECT COALESCE(AVG(amount), 0) FROM orders, per WHERE strftime(''%Y-%m'', order_date) = cur) AS avg_order,'
      '  (SELECT COALESCE(AVG(amount), 0) FROM orders, per WHERE strftime(''%Y-%m'', order_date) = prev) AS avg_order_prev,'
      '  (SELECT 100.0 * TOTAL(amount) / (SELECT target FROM goals WHERE metric = ''revenue'') FROM q) AS goal_revenue,'
      '  (SELECT 100.0 * TOTAL(status <> ''Late'') / MAX(1, COUNT(*)) FROM q) AS goal_on_time,'
      '  (SELECT 100.0 * COUNT(DISTINCT customer) / MAX(1, (SELECT COUNT(*) FROM seen)) FROM q WHERE customer IN seen) AS goal_retention)'
      'SELECT v.*,'
      ' printf(''$%.1fK'', revenue / 1000) AS revenue_text,'
      ' CASE WHEN revenue >= revenue_prev THEN printf(''+%.1f%%'', 100.0 * (revenue - revenue_prev) / MAX(revenue_prev, 1))'
      '   ELSE char(8722) || printf(''%.1f%%'', 100.0 * (revenue_prev - revenue) / revenue_prev) END AS revenue_change,'
      ' printf(''%d late'', late_orders) AS late_text,'
      ' printf(''+%d new'', new_customers) AS new_text,'
      ' printf(''$%,d'', CAST(ROUND(avg_order) AS INT)) AS average_text,'
      ' CASE WHEN avg_order >= avg_order_prev THEN printf(''+%.1f%%'', 100.0 * (avg_order - avg_order_prev) / MAX(avg_order_prev, 1))'
      '   ELSE char(8722) || printf(''%.1f%%'', 100.0 * (avg_order_prev - avg_order) / avg_order_prev) END AS average_change,'
      ' printf(''%d%%'', CAST(ROUND(goal_revenue) AS INT)) AS goal_revenue_text,'
      ' printf(''%d%%'', CAST(ROUND(goal_on_time) AS INT)) AS goal_on_time_text,'
      ' printf(''%d%%'', CAST(ROUND(goal_retention) AS INT)) AS goal_retention_text,'
      ' CASE WHEN revenue >= revenue_prev THEN ''tskSuccess'' ELSE ''tskError'' END AS revenue_kind,'
      ' CASE WHEN late_orders > 0 THEN ''tskWarning'' ELSE ''tskSuccess'' END AS late_kind,'
      ' CASE WHEN avg_order >= avg_order_prev THEN ''tskSuccess'' ELSE ''tskError'' END AS average_kind,'
      ' printf(''%d orders'', order_count) AS order_count_text,'
      ' printf(''%d of %d orders'', shown, order_count) AS shown_text,'
      ' CASE ref_month WHEN 1 THEN ''January'' WHEN 2 THEN ''February'' WHEN 3 THEN ''March'' WHEN 4 THEN ''April'''
      '   WHEN 5 THEN ''May'' WHEN 6 THEN ''June'' WHEN 7 THEN ''July'' WHEN 8 THEN ''August'' WHEN 9 THEN ''September'''
      '   WHEN 10 THEN ''October'' WHEN 11 THEN ''November'' ELSE ''December'' END || '' '' || ref_year || '' '' || char(183) ||'
      '   '' all regions'' AS subtitle'
      'FROM v')
    ParamData = <
      item
        Name = 'STATUS'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'SEARCH'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end>
    Left = 160
    Top = 104
  end
  object Customers: TFDQuery
    Connection = Database
    SQL.Strings = (
      'SELECT name, region, contact FROM customers ORDER BY name')
    Left = 160
    Top = 176
  end
  object Projects: TFDQuery
    Connection = Database
    SQL.Strings = (
      '-- the projects, each followed by its tasks: a project is done when all its tasks are, at risk when an open task is'
      'SELECT p.id, p.parent_id, p.name, p.owner,'
      '  CASE WHEN p.parent_id IS NOT NULL THEN p.done'
      '    ELSE NOT EXISTS (SELECT 1 FROM projects t WHERE t.parent_id = p.id AND NOT t.done) END AS done,'
      '  CASE WHEN p.parent_id IS NOT NULL THEN p.status'
      '    WHEN NOT EXISTS (SELECT 1 FROM projects t WHERE t.parent_id = p.id AND NOT t.done) THEN ''Done'''
      '    WHEN EXISTS (SELECT 1 FROM projects t WHERE t.parent_id = p.id AND NOT t.done AND t.status = ''At risk'') THEN ''At risk'''
      '    ELSE ''On track'' END AS status'
      'FROM projects p'
      'ORDER BY COALESCE(p.parent_id, p.id), p.parent_id IS NOT NULL, p.id')
    Left = 288
    Top = 104
  end
end
