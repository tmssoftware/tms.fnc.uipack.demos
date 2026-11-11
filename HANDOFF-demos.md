# Handoff: FNC 5.0 / 8.0 demos (branch `work/demos`)

Plan: `~/tms.environment/workspaces/delphi/tasks/plans/plan-demos.md` (57 demos). Worktrees: this one
(`tms.fnc.uipack.demos-theming-demos`, from `work/integration`), `tms.fnc.core.demos-theming-demos` (branch
`work/demos` from `5.0.0.0`, a Core demos agent builds A1 and A2 there) and `tms.fnc.uipack.extras-theming-demos`
(branch `work/demos-gate`, the gate patch). Sources compiled against: `tms.fnc.core-theming-int` and
`tms.fnc.uipack-theming-int` (`work/integration`).

## Done

- Tools: `tools/democheck.py` compiles WEB projects whose shared form unit declares the form class under
  `{$IFDEF}` (resolved for WEBLIB in a scratch copy), builds `<RcItem>` resources into the `.dres`, takes `--extra`
  source folders (PDFLib BMI needs `tms.fnc.dashboardpack/Source`). `tools/demonew.py` scaffolds a demo (FMX, VCL,
  WEB, one shared unit; the README per folder is still written by hand). `Shared Code/Business Logic/Demo
  Layout/UDemoLayout.pas` holds the layout and in-memory dataset helpers every new demo uses. SVG and PDFLib BMI WEB
  forms got `WEBLib.TMSFNCGraphicsTypes`.
- Gate (Extras `work/demos-gate`): `tools/gate.py` step `demos` (Win32 D13 + D12 and WEB by default, `--with
  demos-full` for Win64 and the FMX cross targets, `--demos` / `--coredemos` for standalone checkouts). Not run yet.
- Encoding: the 35 shared demo units (`Shared Code/Form Unit/*/UDemo.pas`, `UDemoLayout.pas`) are UTF-8 with BOM
  and CRLF (2026-11-10; 15 were LF, none had a BOM).
- Demos, each FMX + VCL + WEB from one shared unit, compiled with Delphi 13 and 12 Win32 and TMS WEB Core, FMX and
  VCL started on the hidden desktop (smoke) unless noted:
  - B1-B22 (without B23-B28 until 2026-11-10): Avatar, Breadcrumb, Buttons and Toggles, CardPanel, Repeater,
    DataNavigator, Divider, GroupBox and Expander, HeaderControl, Knob, ListView, MaskEdit, MenuBar, NumberBox,
    ScrollBox, Skeleton, SplitView, StackPanel and FlowPanel, Stepper, TagEdit, Theme Pickers, Toast.
  - A4 Orders Data Form (now with SelectedRecords: Ctrl+click rows, the total of the selection; KPI tiles bound to
    a one-record dataset through `TTMSFNCDataBinder.ConnectSingleHTMLTemplate`), A5 DataGrid Database Editing,
    C12 DataGrid Import (FMX and VCL only: no import dialog on WEB), A12 HTML in the UI (now with Kanban cards with
    marked-up text and theme colours and the HTML editor with ExtendedMarkup on the article), A6 Master-Detail
    Explorer (datasets page desktop only; Cards template, template per level, detail toolbar and peek wait for
    phase 5A), A8 Project Board, A7 TreeView Database (now with the status column as pills, `Columns[].StatusValues`,
    and the company column as avatars; the lookup editor is still open, see Next).
  - 2026-11-10 (smoke and screenshots queued, see Next): A10 App Shell (menu bar, brand logo, split view rail,
    breadcrumb, dashboard of cards and a repeater behind a skeleton, project list under a header control,
    accordion, onboarding stepper, toasts, accent selector), A11 Input Forms (every FNC input in one validated form;
    DirectoryEdit desktop only), B23 Touch Keyboard, B24 PageSlider, B26 Grid (classic grid: glFluent, filter
    drop-down, editing with the tool bar pop-up (desktop), database adapter, PDF and print export with Export as on
    screen), B25 ToolBar Family (FMX and VCL only: the rich editor is not on WEB; dock panel with the five
    ready-made tool bars on a rich editor, a tool bar built in code with every picker, a pop-up tool bar).
  - C updates 2026-11-10 (existing demos, compiled D13 and D12 and WEB where the demo has one, not smoked):
    C2 Chat `ShowAvatars` (FMX, VCL, WEB), C3 NavigationPanel `Look := nplFluent`, `BadgeKind`, `ShowBrandLogo`,
    C4 Ribbon `Theme := rbtFluent`, `BrandMark`, C13 PDFLib BMI "Export as on screen" check box (the PrintIO demo
    not yet: designed forms per framework), C15 Master_Detail_FireDac_SQLite kept as the adapter demo with a README
    pointing to the Master-Detail Explorer.

- 2026-11-11 (session 3):
  - Merges: the Demos `work/integration` (500f78f) was already in `work/demos`; Extras `work/demos-gate` merged up to
    `work/integration` 38ee137 (1e80586). 39 Demo.res build outputs restored.
  - Click-through driver (dc86ee0, 26f2f26): `democheck.py click <projects> --ppi 96 120 144 192 --jobs 2` builds
    with `tools/delphi/DemoShot.pas` and drives the demo like a person per DPI: every reachable control by kind
    (button: click + 3 fast clicks; editor: click, type, theme switch to Dark while editing, Ctrl+Z, Esc; list:
    hover, click, arrows, double click, type, Dark while editing, Esc, F2, Enter, Ctrl+C/Z, wheel, right click,
    drag; drop-down: open at its button, Dark while open, Down+Enter; slider: drag, wheel, arrows), a capture after
    every action incl. the windows it opened, modal dialogs captured and closed by a watchdog, Tab order walk,
    resize to 80 %, then Dark with the pop-ups again. `issues.json` per run (exceptions, windows left open,
    controls outside their parent / overlapping, stuck Tab, hang); `clicksheet` (light/dark/resized per DPI) and
    `stepsheet --ppi N` (every step shot, labelled) to judge by eye. Scratch builds link a manifest (common
    controls 6, Windows 10, PMv2). DPI: FMX forced window scale (exact); VCL: monitor + screen DPI emulated but the
    form keeps 96 at load (cause not found: Monitor.PixelsPerInch and Screen.PixelsPerInch report the DPI, Win
    10.0, PMv2) so it is scaled with ScaleForPPI after start (= moved to a monitor with that DPI).
    `demonew.py` copies only tracked template files and writes the README files.
  - A3 Theming Dashboard: brand picker (TTMSFNCBrand.PresetNames / LoadPreset into ThemeManager.Brand) and a
    TTMSFNCBrandLogo mark in the top bar (desktop; WEB unchanged). Full theme list not added: the selector already
    has 5 themes + Follow system in 743 px (decision, see below).
  - Kanban Board redone (FMX, VCL, WEB; old code moved to `LCL/Kanban Board`, LCL unchanged): sprint board, WIP
    limits enforced, swimlanes, header counts, footer points, HTML cards with theme colours + priority Kind,
    overdue in red, filter, drag/drop, rename in place, details pane (title, owner, priority, points, due), Delete
    with undo toast. Form 1360 x 780, columns 230.
  - C5 Listbox rewritten as a shared unit with a WEB project (mail client: folders with tinted theme icons, Fluent
    pills, badges by kind; HTML message rows, lookup, search, sort, drag a message onto a folder; labels as a
    TTMSFNCCheckedListBox).
  - C6 Planner: items by status Kind instead of fixed colours; pumInplace + TTMSFNCPlannerToolBarPopup.
  - C8 RichEditor: Save as HTML / RTF (HTMLIO, RTFIO + OpenFile), Find / Replace dialogs (non-modal), tool bar
    pop-up.
  - C9 HotSpotImage: "Edit hot spots..." opens TTMSFNCHotSpotImageEditor (ExecuteModal).
  - All compiled D13 Win32 (FMX, VCL) and WEB where they have one; D12 not yet for these.

## Next (plan order)

1. Click-through results to read (scratch `.../scratchpad/res/click`, logs `click-batch1.log`): batch 1 ran VCL
   Kanban, FMX Listbox, VCL Dashboard, FMX Planner, VCL HotSpotImage at 144 before the last Kanban fix. Re-run the
   changed demos FMX + VCL at 96 and 144 (`click ... --ppi 96 144 --jobs 2`), then `stepsheet` and look at every
   page. Open Kanban check: FMX cards clipped their title after Swimlanes off + theme switch (card height not
   recomputed?) - confirm with the new run; if it stays, it is a Kanban product issue (report, do not fix here).
2. Remaining C items: C1 Pickers (+ WEB port: BitmapSelector, CheckGroup(Picker), RadioGroup(Picker),
   FontNamePicker, Spinner, csmTheme), C10 SpreadGrid (GridBinder, math libraries), C11 Customers_FireDac_SQLite
   (adapter KeyFields, SortTarget/FilterTarget, FilterOptions, OnValidateCell, OnPostError), C13 PrintIO
   (ExportAsOnScreen toggle), A7 lookup editor, then Core: A14, C14, B27 smoke; A1 Theme Studio, A2 Brand Studio.
3. Quality pass: the B demos (B1-B28) are all "settings panel left + content": the user wants each demo a small
   real application with its own layout (memory demo-quality). Redo them one by one like Kanban/Listbox, starting
   with the ones the user is likely to open first (Avatar, Toast, Stepper, Breadcrumb, TagEdit, NumberBox).
4. Full click-through campaign through `heavy.py` (all FMX + VCL demos x 96/120/144/192; about 75 demos x 8 runs x
   2-4 min, so split in batches of ~10 demos), fix what it finds, D12 + WEB compile of everything, gate demos step.
5. `code-review` (medium) on the branch diffs (demos, core demos, extras gate), fix findings. No merge, no push.

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
- TreeView: `UseLookupEditor` lives on the adapter component only (`TTMSFNCTreeViewDatabaseAdapter`), not in
  `TTMSFNCTreeView.DataOptions`; a tree bound through `DataSource` reaches it only through `DataAdapter` after
  binding. Suggestion: publish it in `DataOptions` like the other adapter options.
- `TTMSFNCEdit.Prefix` and `Suffix` are protected (declared in `TTMSFNCCustomEdit`, not republished): the plan lists
  a prefix and suffix on every edit (A11), an application cannot set them. `ClearButton` and `PasswordReveal` are
  FMX and VCL only (the WEB edit has neither) while `TTMSFNCMaskEdit` and `TTMSFNCNumberBox` have `ShowClearButton`
  on every framework. Suggestion: publish Prefix/Suffix and a WEB clear button, one name (`ShowClearButton`).
- Placeholder texts have four names: `TTMSFNCEdit.TextPrompt` (FMX) / `TextHint` (VCL, WEB), `Placeholder` on
  MaskEdit, NumberBox and TagEdit, `EmptyText` on `Edit.Lookup` and `TTMSFNCDirectoryEdit`. The password edit is
  `Password` (FMX) / `PasswordChar` (VCL, WEB). A shared unit needs `{$IFDEF}`s for both.
- Collections name their caption differently: SplitView, Breadcrumb, ListView, Stepper items use `Text`, the
  Kanban column uses `HeaderText`, the Planner resource `Name`. SplitView items have no `Tag` (Breadcrumb items do):
  mapping rail items to pages needs a parallel array.
- `TTMSFNCProgressBar` has `Maximum` only (no `Minimum`, `Min` or `Max`) while TrackBar, SpinEdit and Knob use
  `Min`/`Max`.
- Tool bars: `TextVisible` is protected on `TTMSFNCToolBar` and on the ready-made Font/Paragraph/... tool bars (only
  `Text` is published); `TTMSFNCToolBarPopup` has no `Look` (the pop-up follows the theme by itself, the tool bars in
  the dock do not: each needs `Look := tlbFluent`). `TTMSFNCGridToolBarPopup` has no WEB unit while
  `TTMSFNCToolBarPopup` has one. `TTMSFNCRichEditor` is not on WEB, so the rich editor tool bars cannot be shown
  there.
- `TTMSFNCSampleData.ProjectTasks` has no dates (the Project Board builds its own): a `DueDate` would let the
  App Shell and the lists show a date column without a second data set.

- Click-through (2026-11-11), product issues seen, not fixed here: FMX `TTMSFNCComboBox` drop-down opened in Dark
  keeps a dark list background after switching back to Light while open (the text follows); FNC radio buttons draw
  a hard rectangle as focus cue around the caption (VCL Knob demo, 144 DPI); Knob compact knobs lose their track
  without ticks (looks like only a dot).
- Orders Data Form (FMX): the record form's stack panel is taller than its panel at 1100 x 700 (Paid switch,
  Priority order and the notes are clipped below) - demo fix needed (scroll box or shorter form).
- An editable FMX TTMSFNCComboBox (csDropDown) does not open when its text is clicked, the VCL one does.

## Pitfalls

- Scaffold with `python -I tools/demonew.py "<Name>" --description "..." [--data] [--no-web]`; write the unit,
  then `python -I tools/democheck.py --core <core-int> --uipack <uipack-int> --out <scratch> --work <scratch>
  compile FMX/<Name>/Demo.dproj VCL/<Name>/Demo.dproj WEB/<Name>/TMSWeb_FNC<Name>.dproj --delphi 13 12 --platforms
  win32`. Pass Windows paths (`C:/...`) to Python, not MSYS paths. PDFLib BMI needs `--extra
  E:/Delphi/tms.fnc.dashboardpack/Source`.
- Two democheck runs on the same project at the same time collide in the scratch folder.
- Heavy runs (`smoke`, `shoot`) go through the Extras `tools/heavy.py`; one heavy run machine-wide, a queued run
  prints "waiting" and starts when the lock is free. Start them with `nohup ... &` and read the log later.
- WEB: event handlers need `{$IFDEF WEBLIB}@{$ENDIF}`; `TField.AsCurrency`, `IndexFieldNames`, `TTMSFNCButton.Look`
  and `TTMSFNCSwitch.Look` are not available on WEB; `x.Free` needs a variable; array constants indexed by an enum
  must match the enum's declaration order (check with `sed` on the type, XMLDoc regions sit between the values).
  `TTMSFNCEdit.ClearButton`/`PasswordReveal` and `TTMSFNCGridToolBarPopup` are `{$IFNDEF WEBLIB}`.
- Enum names found so far: `lpaStretch/lpaStart/lpaCenter/lpaEnd`, `lpjStart/lpjCenter/lpjEnd/lpjSpaceBetween`,
  `capNone/capLeft/capTop`, `gdcsNone/gdcsProportional/gdcsLastColumn`, `elmStartsWith/elmContains/elmWordStart`,
  `mbakDefault/mbakAlt`, `dnimInsert/dnimAppend`, `htrPrimary/htrSecondary/htrTertiary`, divider
  `dtpStart/dtpCenter/dtpEnd`, keyboard `ktQWERTY/ktAZERTY/ktQWERTZ/ktDVORAK/ktNUMERIC/ktCELLPHONE`, grid
  `glClassic/glFluent`, `gsmNone/gsmNormal/gsmIndexed` (classic grid sorting), DataGrid selection
  `gsmSingleRow/gsmDisjunctRow/...` (in `*.TMSFNCDataGridRenderer`), popup placement `ppTop/ppBottom/...` (in
  `*.TMSFNCPopup`), tool bar `tlbClassic/tlbFluent`, navigation panel `nplClassic/nplFluent`, ribbon `rbtFluent`.
- `TTMSFNCSampleData` (Core) supplies people, customers, orders, tasks and project tasks (`Project`, `Task`, `Owner`,
  `Status`, `Kind`, `Progress`) for the sample data.
- The Write tool writes LF; `sed -i` on Windows also rewrites a CRLF file as LF; Python `read_text` converts CRLF to
  LF, so match LF in scripts and write `\r\n` back. The shared units are UTF-8 with BOM and CRLF: normalise before
  committing (`git ls-files --eol` shows `w/lf` for a wrong one).
- Index a class function result through a local variable (`people := TTMSFNCSampleData.People; people[I]`), and
  avoid `TDataSet.Locate` in shared units (not checked on WEB): look up in the array instead.
- FireDAC master-detail in memory: detail `IndexFieldNames` = the link field, then `MasterSource` and
  `MasterFields`; the DataGrid finds the detail datasets by itself.
- Smoke starts: `python -I tools/democheck.py ... smoke <projects> --delphi 13` (see Done). A crash address
  resolves with a `-GD` rebuild of the scratch `Demo.dpr` and the harness `mapaddr.py`; the harness
  `tools/UDbgStack.pas` added to the dpr writes the stack of the first chance.
- `tdmMove` and the other tree view interaction enums live in `*.TMSFNCCustomTreeView`, not in `*.TMSFNCTreeView`.
- A `DataSource` bound tree view creates its adapter when the source is assigned: `DataAdapter` (for
  `DeleteChildrenMode`, `AddRecord`, `DeleteRecord`, `ReloadNode`, `UseLookupEditor`) is nil before that; the bound
  columns (`Columns[].StatusValues`, `Avatar`) exist after it.
- Layout unit: `AddText` sizes itself to its text (`AutoSize`, the height argument only counts while the text is
  empty); check box and radio captions wrap to two lines when they do not fit; inside a stack or flow panel
  `Place` leaves `Align` None (an aligned child is skipped by the stack). Keep the settings panel within the
  700 px form: long value lists go two per line (Knob).
- `TTMSFNCNumberBox.OnChange` also fires for a value set in code: a handler that reads other boxes must wait until
  they all exist (NumberBox demo `UpdateTotal`).
- The header description (dfm/fmx `DemoDescription`, WEB `index.html` meta) is one line of about 125 characters
  at most; longer texts are trimmed with an ellipsis.
- A `TTimer` works on all three frameworks (`Vcl.ExtCtrls`, `FMX.Types`, `WEBLib.ExtCtrls`): the App Shell uses one
  for the skeleton. `TTMSFNCRepeater` draws one template of controls per item (`OnBeforeDrawItem` fills them).
- DataGrid: `TTMSFNCDataGridCellCoord` is in `*.TMSFNCDataGridCore`; `SelectedRecords` is a bookmark list, visit it
  with `DataSet.Bookmark := SelectedRecords[I]` between `DisableControls`/`EnableControls`. DataBinder templates
  name a field as `<#Field>`.
- Kanban in code: `Columns.Add` then `HeaderText`, `Column.AddItem(text)`, `Item.Kind`. HTML editor:
  `TTMSFNCHTMLEditor` is a component, `Execute` is a function on desktop and takes a callback on WEB.
- Classic grid: `Options.Filtering.DropDown`, `Options.Sorting.Mode`, `Cells[c, r]`, `Floats`, `Ints`,
  `ColumnWidths[c]`; the adapter is `TTMSFNCGridDatabaseAdapter` with `Grid`, `DataSource`, `Active`; PDF and print
  through `TTMSFNCGridPDFIO.Save(file)` and `TTMSFNCGridPrintIO.Print`, both with `Options.ExportAsOnScreen`.
- The Bash tool collapses `\\` in heredocs: write Python patch scripts with the Write tool into the scratchpad
  and run them (`python -I <script>`); never inline Windows paths with backslashes in a heredoc.
- FMX: toggling Visible of several top-aligned controls one by one reorders them; show/hide a container instead.
- Kanban: a column with WIPLimit > 0 draws count/limit in its header by itself; item Tag (not DataInteger) survives
  a drop (Assign copies Tag). TTMSFNCProgressBar value text: `Layout.ShowValue`.
- Old per-framework demos (Planner, HotSpotImage, RichEditor, PrintIO, Pickers, SpreadGrid) are ANSI (cp1252)
  units: patch them with cp1252 and keep CRLF.
