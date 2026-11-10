# Handoff: FNC 5.0 / 8.0 demos (branch `work/demos`)

Plan: `~/tms.environment/workspaces/delphi/tasks/plans/plan-demos.md` (57 demos). Worktrees: this one
(`tms.fnc.uipack.demos-theming-demos`, from `work/integration`), `tms.fnc.core.demos-theming-demos` (branch
`work/demos` from `5.0.0.0`, nothing committed yet) and `tms.fnc.uipack.extras-theming-demos` (branch
`work/demos-gate`, the gate patch). Sources compiled against: `tms.fnc.core-theming-int` and
`tms.fnc.uipack-theming-int` (`work/integration`).

## Done

- Tools: `tools/democheck.py` compiles WEB projects whose shared form unit declares the form class under
  `{$IFDEF}` (resolved for WEBLIB in a scratch copy), builds `<RcItem>` resources into the `.dres`, takes `--extra`
  source folders (PDFLib BMI needs `tms.fnc.dashboardpack/Source`). `tools/demonew.py` scaffolds a demo (FMX, VCL,
  WEB, one shared unit, README lines). `Shared Code/Business Logic/Demo Layout/UDemoLayout.pas` holds the layout
  and in-memory dataset helpers every new demo uses. SVG and PDFLib BMI WEB forms got `WEBLib.TMSFNCGraphicsTypes`.
- Gate (Extras `work/demos-gate`): `tools/gate.py` step `demos` (Win32 D13 + D12 and WEB by default, `--with
  demos-full` for Win64 and the FMX cross targets, `--demos` / `--coredemos` for standalone checkouts). Not run yet
  (no heavy runs allowed); only `--help` checked.
- Demos, each FMX + VCL + WEB from one shared unit, compiled with Delphi 13 and 12 Win32 and TMS WEB Core, FMX and
  VCL started on the hidden desktop: Avatar, Breadcrumb, Buttons and Toggles, CardPanel, ControlList, DataNavigator,
  Divider, GroupBox and Expander, HeaderControl, Knob, ListView, MaskEdit, MenuBar, NumberBox, ScrollBox, Skeleton,
  SplitView, StackPanel and FlowPanel, Stepper, TagEdit, Theme Pickers, Toast (plan B1-B22 without B23-B28);
  Orders Data Form (A4, without DataBinder KPIs and SelectedRecords), DataGrid Database Editing (A5),
  DataGrid Import (C12, FMX and VCL only: no import dialog on WEB), HTML in the UI (A12 without Kanban cards and
  the HTML editor), Master-Detail Explorer (A6: datasets page desktop only, the dataset master-detail is
  `{$IFNDEF WEBLIB}` in the product; WEB has the OnGetDetailData page and the tree grid; Cards template, template
  per level, detail toolbar and peek wait for phase 5A), Project Board (A8: Kanban, Planner and Timeline on one
  tasks dataset with ColumnSource, LaneSource, ResourceSource and Detail to a checklist grid; without Kind
  categories, see the harmony findings).

## Next (plan order)

1. A1 Theme Studio, A2 Brand Studio, A3 Dashboard update, A10 App Shell, A11 Input Forms, A13 and A14 (Core demos
   repository `tms.fnc.core.demos-theming-demos`, nothing committed there yet), B23-B28, the C updates (C1-C11,
   C13-C15), E1, the A4 gaps (DataBinder KPIs, SelectedRecords) and the A12 gaps (Kanban cards, HTMLEditor). TreeView
   Database still lacks the lookup editor (`UseLookupEditor`, desktop only) and StatusValues/Avatar columns of the
   plan.
2. Run the gate `demos` step once heavy runs are allowed (about 220 projects x 2 compilers): expect the PDFLib BMI
   WEB project to need `--extra` (the gate passes the Dashboard Pack source when the folder exists).
3. `democheck.py shoot` on the new demos (Light/Dark contrast check) once heavy runs are allowed.
4. LCL demos are not compiled anywhere (plan decision 7): extend `lcl_check.py` if they should be.

## Harmony findings

Things that did not work together nicely or were unintuitive while building the demos; product code untouched.

- Kanban board, Planner, Timeline: `DataOptions` have no `KindField`. A bound card, item or section cannot get a
  status `Kind` (tskSuccess, tskWarning, ...) from a field; `ColorField` only takes a fixed colour, which breaks
  theming. Suggestion: a `KindField` (kind names or indexes) in the three data options, next to `ColorField`.
- Timeline `DataOptions.AutoDetectFields` detects `Start/StartDate/Date` and `End/EndDate/Finish`, the Planner
  detects `StartTime/Start/Begin` and `EndTime/End/Finish`: a tasks table with `StartTime`/`EndTime` binds to the
  Planner by itself but needs `StartField`/`EndField` set for the Timeline. Suggestion: one detection list for
  both.
- DataGrid master-detail from datasets (`MasterSource`) is desktop only; WEB only has `OnGetDetailData` and
  `SourceGrid`. The property editor and the docs should say so (TMS WEB Core datasets have no `MasterSource`).
- `demonew.py` does not write the per-folder `README.md` its docstring promises; written by hand for every demo.
- TreeView `DataOptions` has `ColumnFields` but no way to name a column caption or format per field (the DataGrid
  has `DataOptions` columns with TField display settings): a `Price` column shows the raw float. Suggestion: honour
  `TField.DisplayLabel` and `DisplayFormat` in the adapter's columns, as the DataGrid does.

## Pitfalls

- Scaffold with `python -I tools/demonew.py "<Name>" --description "..." [--data] [--no-web]`; write the unit,
  then `python -I tools/democheck.py --core <core-int> --uipack <uipack-int> --out <scratch> --work <scratch>
  compile FMX/<Name>/Demo.dproj VCL/<Name>/Demo.dproj WEB/<Name>/TMSWeb_FNC<Name>.dproj --delphi 13 12 --platforms
  win32`. Pass Windows paths (`C:/...`) to Python, not MSYS paths.
- Two democheck runs on the same project at the same time collide in the scratch folder.
- WEB: event handlers need `{$IFDEF WEBLIB}@{$ENDIF}`; `TField.AsCurrency`, `IndexFieldNames`, `TTMSFNCButton.Look`
  and `TTMSFNCSwitch.Look` are not available on WEB; `x.Free` needs a variable; array constants indexed by an enum
  must match the enum's declaration order (check with `sed` on the type, XMLDoc regions sit between the values).
- Enum names found so far: `lpaStretch/lpaStart/lpaCenter/lpaEnd`, `lpjStart/lpjCenter/lpjEnd/lpjSpaceBetween`,
  `capNone/capLeft/capTop`, `gdcsNone/gdcsProportional/gdcsLastColumn`, `elmStartsWith/elmContains/elmWordStart`,
  `mbakDefault/mbakAlt`, `dnimInsert/dnimAppend`, `htrPrimary/htrSecondary/htrTertiary`.
- `TTMSFNCSampleData` (Core) supplies people, customers, orders, tasks and project tasks for the sample data.
- The Write tool writes LF; convert a new unit to CRLF before committing (the demos are CRLF).
- Index a class function result through a local variable (`people := TTMSFNCSampleData.People; people[I]`), and
  avoid `TDataSet.Locate` in shared units (not checked on WEB): look up in the array instead.
- FireDAC master-detail in memory: detail `IndexFieldNames` = the link field, then `MasterSource` and
  `MasterFields`; the DataGrid finds the detail datasets by itself.
- Smoke starts: `python -I tools/democheck.py ... smoke <projects> --delphi 13` (see Done). A crash address
  resolves with a `-GD` rebuild of the scratch `Demo.dpr` and the harness `mapaddr.py`; the harness
  `tools/UDbgStack.pas` added to the dpr writes the stack of the first chance.
- `tdmMove` and the other tree view interaction enums live in `*.TMSFNCCustomTreeView`, not in `*.TMSFNCTreeView`.
- A `DataSource` bound tree view creates its adapter when the source is assigned: `DataAdapter` (for
  `DeleteChildrenMode`, `AddRecord`, `DeleteRecord`, `ReloadNode`) is nil before that.
- Layout unit: `AddText` sizes itself to its text (`AutoSize`, the height argument only counts while the text is
  empty); check box and radio captions wrap to two lines when they do not fit; inside a stack or flow panel
  `Place` leaves `Align` None (an aligned child is skipped by the stack). Keep the settings panel within the
  700 px form: long value lists go two per line (Knob).
- The shared units have no BOM and the compiler reads them as ANSI: write non-ASCII characters as escapes
  (`#$B0'C'`), never literally.
- `TTMSFNCNumberBox.OnChange` also fires for a value set in code: a handler that reads other boxes must wait until
  they all exist (NumberBox demo `UpdateTotal`).
- The header description (dfm/fmx `DemoDescription`, WEB `index.html` meta) is one line of about 125 characters
  at most; longer texts are trimmed with an ellipsis.
