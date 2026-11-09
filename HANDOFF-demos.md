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
  the HTML editor).

## Next (plan order)

1. A6 Master-Detail Explorer (`TTMSFNCDataGridMasterDetail`, tree-grid `TreeOptions`), A8 Project Board
   (Kanban/Planner/Timeline DataSource), A7 TreeView Database update, A1 Theme Studio, A2 Brand Studio, A3 Dashboard
   update, A10 App Shell, A11 Input Forms, A13 and A14 (Core demos repository), B23-B28, the C updates, E1.
2. Run the gate `demos` step once heavy runs are allowed (about 220 projects x 2 compilers): expect the PDFLib BMI
   WEB project to need `--extra` (the gate passes the Dashboard Pack source when the folder exists).
3. `democheck.py shoot` on the new demos (Light/Dark contrast check) once heavy runs are allowed.
4. LCL demos are not compiled anywhere (plan decision 7): extend `lcl_check.py` if they should be.

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
