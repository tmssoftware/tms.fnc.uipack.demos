# Demo revision status (UI Pack 8.0)

Generated 2026-10-31 by group U8 from the demos repository (branch `work/demos-u8`), `tools/demoscan.py` and the result folders `TMS FNC Theming/results/demos-*` of the theming harness.

Columns: per framework `TM` = the main form has a `TTMSFNCThemeManager`, `no TM` = it has none, `layout` = LCL (no theme manager, layout rules only), `-` = the demo does not exist for that framework. Compile: the last result per target (Win32/Win64 for Delphi 13 and 12, macOS/iOS/Android for FMX, TMS WEB Core for WEB; the number is the targets checked). Shot: the last `democheck.py shoot` (as shipped, no theme, Fluent Light, Fluent Dark), with the low-contrast text flags summed over the modes and the result folder.

| Demo | FMX | VCL | WEB | LCL | Compile | Last shot |
| --- | --- | --- | --- | --- | --- | --- |
| Calendar | TM | TM | - | layout | FMX ok (8); VCL ok (4) | FMX 4 modes, 0 low (demos-pilot/after); VCL 4 modes, 0 low (demos-pilot/after) |
| Chat/Client | TM | TM | TM | - | FMX ok (8); VCL ok (4); WEB ok (1) | FMX 4 modes, 0 low (demos-u7/after); VCL ERROR (demos-u7) |
| Chat/Server | TM | TM | - | - | FMX ok (8); VCL ok (4) | FMX 4 modes, 0 low (demos-u7/after); VCL 4 modes, 0 low (demos-u7/after) |
| ControlPicker | TM | TM | TM | layout | FMX ok (12); VCL ok (4); WEB ok (1) | FMX 4 modes, 1 low (demos-u5/after); VCL 4 modes, 1 low (demos-u5/after) |
| DataGrid/Advanced/Conditional Formatting | TM | TM | TM | - | FMX ok (8); VCL ok (4); WEB ok (1) | FMX 4 modes, 0 low (demos-u2/after); VCL 4 modes, 0 low (demos-u2/after) |
| DataGrid/Advanced/Filter Row | TM | TM | TM | - | FMX ok (8); VCL ok (4); WEB ok (1) | FMX 4 modes, 0 low (demos-u2/after); VCL 4 modes, 0 low (demos-u2/after) |
| DataGrid/Advanced/Grid in Grid | TM | TM | TM | - | FMX ok (8); VCL ok (4); WEB ok (1) | FMX 4 modes, 0 low (demos-u2/after); VCL 4 modes, 0 low (demos-u2/after) |
| DataGrid/Advanced/Multi-Column Grouping | TM | TM | TM | - | FMX ok (8); VCL ok (4); WEB ok (1) | FMX 4 modes, 0 low (demos-u2/after); VCL 4 modes, 0 low (demos-u2/after) |
| DataGrid/Advanced/Non-Visual Data Export | TM | TM | TM | - | FMX ok (8); VCL ok (4); WEB ok (1) | FMX 4 modes, 0 low (demos-u2/after); VCL 4 modes, 0 low (demos-u2/after) |
| DataGrid/Advanced/Renderer Source | TM | TM | TM | - | FMX ok (8); VCL ok (4); WEB ok (1) | FMX 4 modes, 0 low (demos-u2/after); VCL 4 modes, 0 low (demos-u2/after) |
| DataGrid/Advanced/Visual Grouping | TM | TM | TM | - | FMX ok (8); VCL ok (4); WEB ok (1) | FMX 4 modes, 0 low (demos-u2/after); VCL 4 modes, 0 low (demos-u2/after) |
| DataGrid/Basic/AutoFill | TM | TM | TM | - | FMX ok (8); VCL ok (4); WEB ok (1) | FMX 4 modes, 0 low (demos-u1/after); VCL 4 modes, 0 low (demos-u1/after) |
| DataGrid/Basic/Cell Controls | TM | TM | TM | - | FMX ok (8); VCL ok (4); WEB ok (1) | FMX 3 modes, 0 low (demos-u1/after); VCL 4 modes, 0 low (demos-u1/after) |
| DataGrid/Basic/Editing | TM | TM | TM | - | FMX ok (8); VCL ok (4); WEB ok (1) | FMX 4 modes, 0 low (demos-u1/after); VCL 4 modes, 0 low (demos-u1/after) |
| DataGrid/Basic/Filtering | TM | TM | TM | - | FMX ok (8); VCL ok (4); WEB ok (1) | FMX 4 modes, 0 low (demos-pilot/after); VCL 4 modes, 0 low (demos-pilot/after) |
| DataGrid/Basic/Grouping | TM | TM | TM | - | FMX ok (8); VCL ok (4); WEB ok (1) | FMX 4 modes, 0 low (demos-u1/after); VCL 4 modes, 0 low (demos-u1/after) |
| DataGrid/Basic/Merging | TM | TM | TM | - | FMX ok (8); VCL ok (4); WEB ok (1) | FMX 4 modes, 0 low (demos-u1/after); VCL 4 modes, 0 low (demos-u1/after) |
| DataGrid/Basic/PDF Export | TM | TM | TM | - | FMX ok (8); VCL ok (4); WEB ok (1) | FMX 4 modes, 0 low (demos-u1/after); VCL 4 modes, 0 low (demos-u1/after) |
| DataGrid/Basic/Sorting | TM | TM | TM | - | FMX ok (8); VCL ok (4); WEB ok (1) | FMX 4 modes, 0 low (demos-u1/after); VCL 4 modes, 0 low (demos-u1/after) |
| DataGrid/Basic/XLS Export | TM | TM | - | - | FMX ok (8); VCL ok (4) | FMX 4 modes, 0 low (demos-u1/after); VCL 4 modes, 0 low (demos-u1/after) |
| DataGrid/Database/Biolife_ClientDataSet | TM | TM | - | - | FMX ok (8); VCL ok (4) | FMX 4 modes, 0 low (demos-u2/after); VCL 4 modes, 0 low (demos-u2/after) |
| DataGrid/Database/Biolife_ClientDataSet_Filtering_Sorting | TM | TM | - | - | FMX ok (8); VCL ok (4) | FMX 4 modes, 0 low (demos-u2/after); VCL 4 modes, 0 low (demos-u2/after) |
| DataGrid/Database/Customers_FireDac_SQLite | TM | TM | - | - | FMX ok (8); VCL ok (4) | FMX 4 modes, 0 low (demos-u2/after); VCL 4 modes, 0 low (demos-u2/after) |
| DataGrid/Database/Master_Detail_FireDac_SQLite | TM | TM | - | - | FMX ok (8); VCL ok (4) | FMX 4 modes, 0 low (demos-u2/after); VCL 4 modes, 0 low (demos-u2/after) |
| DataGrid/Database/StellarDS | TM | TM | - | - | FMX ok (8); VCL ok (4) | FMX 4 modes, 0 low (demos-u2/after); VCL 4 modes, 0 low (demos-u2/after) |
| DataGrid/Template | TM | - | - | - | FMX ok (12) | FMX 4 modes, 0 low (demos-u8/after) |
| FilterDialog/DataSet/Biolife_ClientDataSet | TM | TM | - | - | FMX ok (4); VCL ok (4) | FMX 4 modes, 0 low (demos-u6/after); VCL 4 modes, 0 low (demos-u6/after) |
| FilterDialog/DataSet/Customers_FireDac_SQLite | TM | TM | - | - | FMX ok (4); VCL ok (4) | FMX 4 modes, 0 low (demos-u6/after); VCL 4 modes, 0 low (demos-u6/after) |
| Filter View | - | TM | - | - | VCL ok (1) | VCL 4 modes, 0 low (demos-u6/after) |
| Filter View/DatabaseFilter | TM | - | - | - | FMX ok (1) | FMX 4 modes, 0 low (demos-u6/after) |
| Filter View/DataGridFilter | TM | - | - | - | FMX ok (4) | FMX 4 modes, 1 low (demos-u6/after) |
| HotSpotImage | TM | TM | TM | layout | FMX ok (4); VCL ok (4); WEB ok (1) | FMX 4 modes, 0 low (demos-u6/after); VCL 4 modes, 0 low (demos-u6/after) |
| Kanban Board | TM | TM | TM | layout | FMX ok (8); VCL ok (4); WEB FAIL web (1) | FMX 4 modes, 0 low (demos-pilot/after); VCL 4 modes, 0 low (demos-pilot/after) |
| Listbox | TM | TM | - | layout | FMX ok (12); VCL ok (4) | FMX 4 modes, 0 low (demos-u5/after); VCL 4 modes, 0 low (demos-u5/after) |
| ListEditor | TM | TM | - | layout | FMX ok (12); VCL ok (4) | FMX 4 modes, 0 low (demos-u5/after); VCL 4 modes, 0 low (demos-u5/after) |
| Memo/Default | TM | TM | TM | - | FMX ok (8); VCL FAIL d13-win32 (1); WEB ok (1) | FMX ERROR (demos-u7); VCL 4 modes, 4 low (demos-u7/after) |
| Memo/Language and Theme | TM | TM | TM | - | FMX ok (8); VCL ok (4); WEB ok (1) | FMX 4 modes, 0 low (demos-u7/after); VCL 4 modes, 0 low (demos-u7/after) |
| Memo/Sources | TM | TM | TM | - | FMX ok (8); VCL ok (4); WEB ok (1) | FMX 4 modes, 0 low (demos-u7/after); VCL 4 modes, 4 low (demos-u7/after) |
| NavigationPanel | TM | TM | - | layout | FMX ok (4); VCL ok (4) | FMX 4 modes, 0 low (demos-u6/after); VCL 4 modes, 0 low (demos-u6/after) |
| Object Inspector | TM | TM | - | layout | FMX ok (4); VCL ok (4) | FMX 4 modes, 0 low (demos-u6/after); VCL 4 modes, 0 low (demos-u6/after) |
| PassLock | no TM | no TM | no TM | layout | FMX ok (12); VCL ok (4); WEB ok (1) | FMX 4 modes, 0 low (demos-u4/after); VCL 4 modes, 0 low (demos-u4/after) |
| PDFLib | TM | TM | - | layout | FMX ok (12); VCL ok (4) | FMX 4 modes, 0 low (demos-u8/after); VCL 4 modes, 0 low (demos-u8/after) |
| PDFLib BMI | TM | TM | TM | - | FMX ok (8); VCL ok (4); WEB FAIL web (1) | FMX 4 modes, 0 low (demos-u7/after); VCL 4 modes, 0 low (demos-u7/after) |
| Pickers | TM | TM | - | layout | FMX FAIL d13-osx64 (8); VCL ok (4) | FMX 4 modes, 0 low (demos-pilot/after); VCL 4 modes, 0 low (demos-pilot/after) |
| Planner | TM | TM | - | layout | FMX ok (8); VCL ok (4) | FMX 4 modes, 0 low (demos-u3/after); VCL 4 modes, 0 low (demos-u3/after) |
| Planner Database Adapter and PDFLib | TM | TM | TM | layout | FMX ok (8); VCL ok (4); WEB ok (1) | FMX 4 modes, 0 low (demos-u3/after); VCL 4 modes, 0 low (demos-u3/after) |
| Planner TV Guide | TM | TM | TM | layout | FMX ok (8); VCL ok (4); WEB ok (1) | FMX 4 modes, 0 low (demos-u3/after); VCL 4 modes, 0 low (demos-u3/after) |
| PrintIO | TM | TM | TM | layout | FMX ok (8); VCL ok (4); WEB ok (1) | FMX 4 modes, 0 low (demos-u7/after); VCL 4 modes, 0 low (demos-u7/after) |
| Progressbar and Rating | TM | TM | TM | layout | FMX ok (12); VCL ok (4); WEB ok (1) | FMX 4 modes, 0 low (demos-u5/after); VCL 4 modes, 0 low (demos-u5/after) |
| ResponsiveList | TM | TM | - | layout | FMX ok (4); VCL ok (4) | FMX 4 modes, 0 low (demos-u6/after); VCL 4 modes, 0 low (demos-u6/after) |
| Ribbon | TM | TM | - | layout | FMX ok (8); VCL ok (4) | FMX 4 modes, 0 low (demos-pilot/after); VCL 4 modes, 0 low (demos-pilot/after) |
| RichEditor | TM | TM | - | layout | FMX ok (8); VCL ok (4) | FMX 4 modes, 0 low (demos-u7/after); VCL 4 modes, 0 low (demos-u7/after) |
| SearchList | TM | TM | - | layout | FMX ok (1); VCL ok (1) | FMX 4 modes, 0 low (demos-u6/after); VCL 4 modes, 2 low (demos-u6/after) |
| SignatureCapture | no TM | no TM | - | layout | FMX ok (12); VCL ok (4) | FMX 4 modes, 0 low (demos-u4/after); VCL 4 modes, 0 low (demos-u4/after) |
| SpreadGrid | TM | TM | - | layout | FMX ok (8); VCL ok (4) | FMX 4 modes, 0 low (demos-u7/after); VCL 4 modes, 0 low (demos-u7/after) |
| SVG | TM | TM | TM | layout | FMX ok (8); VCL ok (4); WEB FAIL web (1) | FMX 4 modes, 0 low (demos-u7/after); VCL 4 modes, 0 low (demos-u7/after) |
| TableView | TM | TM | - | layout | FMX ok (8); VCL ok (4) | FMX 4 modes, 0 low (demos-u3/after); VCL 4 modes, 0 low (demos-u3/after) |
| TabSet_PageControl | TM | TM | - | layout | FMX ok (1); VCL ok (1) | FMX 4 modes, 0 low (demos-u6/after); VCL 4 modes, 0 low (demos-u6/after) |
| TaskDialog | no TM | no TM | - | layout | FMX ok (12); VCL ok (4) | FMX 4 modes, 0 low (demos-u4/after); VCL 4 modes, 0 low (demos-u4/after) |
| Template/DataGrid | TM | - | - | - | FMX ok (12) | FMX 4 modes, 0 low (demos-u8/after) |
| Template/KanbanBoard | TM | - | - | - | FMX ok (12) | FMX 4 modes, 0 low (demos-u8/after) |
| Template/Planner | TM | - | - | - | FMX ok (12) | FMX 4 modes, 0 low (demos-u8/after) |
| Template/TreeView | TM | - | - | - | FMX ok (12) | FMX 4 modes, 0 low (demos-u8/after) |
| Theming Dashboard | TM | TM | TM | - | FMX ok (12); VCL ok (4); WEB ok (1) | FMX 4 modes, 0 low (demos-u8/after); VCL 4 modes, 1 low (demos-u8/after) |
| TileList | TM | TM | TM | - | FMX ok (1); VCL ok (1); WEB ok (1) | FMX 4 modes, 0 low (demos-u6/after); VCL 4 modes, 0 low (demos-u6/after) |
| Timeline/CustomDrawing | TM | TM | TM | - | FMX ok (8); VCL ok (4); WEB ok (1) | FMX 4 modes, 0 low (demos-u3/after); VCL 4 modes, 0 low (demos-u3/after) |
| Timeline/Positions | TM | TM | TM | - | FMX ok (8); VCL ok (4); WEB ok (1) | FMX 4 modes, 0 low (demos-u3/after); VCL 4 modes, 0 low (demos-u3/after) |
| Timeline/Timeline Database Adapter | TM | TM | - | - | FMX ok (8); VCL ok (4) | FMX 4 modes, 0 low (demos-u3/after); VCL 4 modes, 0 low (demos-u3/after) |
| Timeline/Timetable Demo | TM | - | - | - | FMX ok (8) | FMX 4 modes, 0 low (demos-u3/after) |
| TrackBar | TM | TM | - | layout | FMX ok (12); VCL ok (4) | FMX 4 modes, 0 low (demos-u5/after); VCL 4 modes, 0 low (demos-u5/after) |
| TreeView | TM | TM | - | layout | FMX ok (8); VCL ok (4) | FMX 4 modes, 0 low (demos-pilot/after); VCL 4 modes, 0 low (demos-pilot/after) |

## Notes

- PassLock, SignatureCapture and TaskDialog show `no TM` here: their revision (group U4) is on branch
  `work/demos-u4` and not yet merged into `8.0.0.0`; their shots are from that branch.
- WEB demos are compiled, not run (no WEB shots). The command-line TMS WEB compiler fails on units shared
  with `{$IFDEF}` form classes (Kanban Board, PDFLib BMI, SVG): verify those in the IDE.
- LCL demos follow the layout rules only (no LCL theme unit, not compiled on this machine).
- WEB form HTML templates: the green TMS WEB banner (tmswebcoredemo.css, Material Icons from CDNs) is
  replaced by a minimal header styled by the page (`index.html`) like the FNC demo header; that HTML
  header stays light when the demo is switched to Dark.
- Remaining natives (scan): WEB `TWebLabel` title/description bound to the HTML header (by design),
  `TMemo` (kept by the guideline), the chat server log list box, one `TTrackBar`/`TShape`/`TListBox`
  marked manual.

## Scan totals (`demoscan.py` over FMX, VCL, WEB, Template, Shared Code; U8 start -> U8 end)

| | forms | without theme manager | native controls (manual) | developer colours |
| --- | --- | --- | --- | --- |
| FMX (incl. templates) | 70 | 9 -> 3 | 92 (9) -> 91 (9) | 256 -> 256 |
| VCL | 61 | 5 -> 4 | 94 (10) -> 93 (10) | 164 -> 164 |
| WEB | 34 | 1 -> 1 | 56 (56) -> 56 (56) | 0 -> 0 |

The remaining forms without a theme manager are the U4 demos (PassLock, SignatureCapture, TaskDialog, see
above) and the dashboard's data module. Developer colours are counted from each group's last run-time
data; most are in demos about colour or drawing (Timeline, HotSpotImage, Calendar) and await a
`demo-colors:` exemption or removal by their group.

## Product findings (U8)

- VCL, Fluent Dark: the Theming Dashboard search box (`TTMSFNCEditButton`) shows its text hint at 2.4:1
  and its search icon (`Bitmap.ThemeTint = bttTextSecondary`) black on the dark input; FMX is fine.
- Kanban board items: an HTML link (`<a>`) keeps the default blue in Fluent Dark (not themed); the
  template uses bold text instead.
