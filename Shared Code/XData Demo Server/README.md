# TMS XData demo server

The server of the **XData Board** demo (`VCL/XData Board`, `FMX/XData Board`): a small TMS XData server with
customers, orders and the tasks of a team, on http://127.0.0.1:8793/tms/xdata.

- Needs TMS XData (with TMS Aurelius, Sparkle and BCL) to compile; the FNC demo itself needs only TMS FNC UI Pack.
  Open `XDataDemoServer.dpr` in Delphi and run it (Win32 or Win64).
- Entity sets: `Customer`, `Order` (a lazy association to its customer: ask `$expand=Customer` for its members) and
  `Task` (an eager association to a customer; only for a signed-in user).
- Sign-in: the service operation `LoginService/Login` with the parameters `User` and `Password` returns a JWT. The
  user is `demo`; the password is made when the server starts and shown in its window (a new one at every start).
  Nothing secret is stored in a file: the key that signs the tokens is made at start too.
- The server runs on 127.0.0.1 only, on Indy (`XDemo.IndyDispatcher.pas`), so it needs no administrator rights, no
  URL reservation and no firewall rule. A real server uses `TSparkleHttpSysDispatcher` or `TSparkleSocketDispatcher`.
- The data is a SQLite database in the temporary folder, filled with the sample rows at every start.

`XDataDemoServer --port 8793` takes another port; press Enter in its window to stop it.
