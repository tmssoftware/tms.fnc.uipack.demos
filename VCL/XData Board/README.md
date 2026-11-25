# TMS FNC UI Pack - XData Board

The orders and the team tasks of a TMS XData server in a DataGrid and a Kanban board, bound with Bind to data in the
IDE (no code): the orders with their customer expanded (`$expand`, ordered on the server), the tasks behind the JWT
sign-in of the service operation `LoginService/Login`. The data module `UAppData` and the settings file
`Demo.data.json` are what Bind to data made; no key or password is in any file.

1. Start the server: `Shared Code/XData Demo Server/XDataDemoServer.dpr` (needs TMS XData). Its window shows the
   address and the password of the user `demo` (a new one at every start).
2. Run this demo. The orders load at once; for the tasks the demo asks to sign in (user `demo`, the password of the
   server window; "Remember on this computer" keeps it in the credential store of Windows).

Without the server, both controls say that they cannot reach the service, with Retry: start the server and click
Retry. Another server address: change `BaseURL` in `Demo.data.json` (per profile, Development and Production).
