# TMS FNC UI Pack - Service Desk Details

One detail view (TTMSFNCDetailView) beside the list controls of a service desk, each a master through its
MasterDetail: a tree of customers with their tickets (a customer shows its tickets, a ticket its comments through the
MasterDetail of the tree's ticket level), a ticket board (the comments of the selected card) and a list of agents
without a database (the open and the done tickets of an agent from OnGetDetailData), and a data grid of customers
that shows the details in its rows under captions over its columns (ColumnGroups). Sections split a detail into the
records and the record itself as a form that is edited in place (MasterDetail.Sections; Ctrl+PgDn / Ctrl+PgUp change
the section). Pick how the records show (grid, form, cards, tabs), where (beside, below, or in place of the list with
Back to return), the tool bar and editing.

At design time the same setup takes a few clicks: Data > Details in the context menu of a list control, or the Details
section of its quick setup (the lightning button).
