# Demo revision plan (Core 5.0 / UI Pack 8.0)

Goal (user, 2026-10-30): every TMS FNC Core and UI Pack demo, on every platform, looks professional
and a `TTMSFNCThemeManager` on it themes everything (`docs/DemoGuidelines.md`).

## Pilot (done, 2026-10-30)

| Demo | FMX | VCL | WEB | LCL |
| --- | --- | --- | --- | --- |
| UI Pack Ribbon | theme manager, window | same | - | - |
| UI Pack Pickers | converter + targeted fixes | same | - | native header |
| UI Pack Calendar | redesigned, FNC list box, exemption | same | - | native header |
| UI Pack TreeView | settings panel, header | same | - | native header |
| UI Pack Kanban Board (shared code) | header, theme colours, readable cards | same | same form | native header |
| UI Pack DataGrid Basic / Filtering | filter bar, stray grid colours removed | same | FNC chrome, selector | - |
| Core TMSFNCPopupMenu (Appearance, Runtime build) | header, theme switch in the menu | same | - | - |
| Core PDFLib | header | same | - | native header |

What the pilot taught:

- The converter does the mechanical 70 %: native chrome, default colours, header, theme manager.
  The rest is layout: FNC controls are 32 px high under the theme where native ones were 19-22 px,
  so dense absolute layouts (Pickers) overlap and need room; spacious ones (TreeView, DataGrid,
  Kanban) are done in minutes.
- Hard-coded colours that survive a theme are rarer than the 8000 colour lines suggest: most are
  default-equal or theme-owned. The real ones are in grids (selection colours), in code
  (`FormCreate`, business logic) and in demos about colour.
- Text drawn in a default colour (`gcBlack` is the default of many `TextColor` properties) is replaced
  by the theme; a colour that must stay (dark text on a coloured card) must differ from the default.
- VCL forms designed at 144 DPI (`PixelsPerInch = 144`) scale every coordinate written for 96 DPI:
  set `PixelsPerInch = 96` when the layout is rewritten.
- Core demos have no FNC chrome: native labels follow the theme in code (pattern in the PopupMenu
  and PDFLib demos), and a form without FNC controls is not coloured by the manager (see Risks).

## Remaining demos: groups for one agent each

Counts from `demoscan.py --brief` (forms across frameworks, native controls, colour lines). Effort is
agent time for conversion, layout, compile (FMX all platforms, VCL Win32/Win64, WEB) and screenshots.

| Group | Demos | Forms | Natives (manual) | Converter vs manual | Effort |
| --- | --- | --- | --- | --- | --- |
| U1 DataGrid Basic | AutoFill, Cell Controls, Editing, Grouping, Merging, PDF Export, Sorting, XLS Export (FMX/VCL/WEB) | 24 | ~110 (20) | converter + the Filtering filter-bar pattern; WEB natives by hand | 1 day |
| U2 DataGrid Advanced + Database | 7 advanced + 5 database (FireDAC/ClientDataSet/StellarDS) | 34 | ~140 (40) | converter; Conditional Formatting exempt (`demo-colors`); database demos need data files at run time | 1-1.5 days |
| U3 Planner family | Planner, Planner Database Adapter and PDFLib, Planner TV Guide, Timeline (9 forms), TableView | 24 | ~200 (50) | manual design: item colours are the subject (exempt), dense settings | 1.5 days |
| U4 Dialogs and input A | TaskDialog (170 natives), PassLock, SignatureCapture | 10 | ~300 (40) | converter for the chrome, manual layout of option pages | 1 day |
| U5 Dialogs and input B | TrackBar, Progressbar and Rating (3 variants), Listbox, ListEditor, ControlPicker (+ Control Picker) | 17 | ~170 (20) | converter-heavy | 1 day |
| U6 Navigation and containers | NavigationPanel, TabSet_PageControl, TileList, ResponsiveList, SearchList, Object Inspector, Filter View, FilterDialog, HotSpotImage | 29 | ~150 (30) | mixed; container demos have no natives but many colours | 1-1.5 days |
| U7 Editors and documents | RichEditor, Memo (9), Chat (6), PrintIO, SpreadGrid, SVG, PDFLib BMI | 31 | ~120 (30) | mixed; editor content stays document-coloured | 1-1.5 days |
| U8 Templates and WEB pages | Template/* (DataGrid, KanbanBoard, Planner, TreeView), WEB `index.html` title/description of every WEB demo, Theming Dashboard check | ~10 | few | manual (templates are what customers copy: highest visibility) | 0.5 day |
| C1 Core PDF | PDFCapabilities, PDFLibFormFields, PDFLibManipulation, PDFLibWatermark, Printer | 14 | ~35 (6) | header + native listener pattern | 0.5-1 day |
| C2 Core browsers and cloud | EdgeWebBrowser (12 forms), WebBrowser, CloudBase | 19 | ~200 (36) | manual layout; browser content is not themed | 1 day |
| C3 Core data | DataBinding (+WEB), TTMSFNCDataSet, FilterRulesManager, Responsive, SVG VirtualImageList | 13 | ~85 (21) | header + listener; FilterRulesManager editors are FNC | 0.5-1 day |

Four agents at a time (AGENTS.md): e.g. U1, U3, U4, C1 first; then U2, U5, U6, C2; then U7, U8, C3.
Each agent owns its demo folders only (Shared Code units are owned by the group of their demo), works
in its own worktree branch off `work/demos-pilot` (UI Pack demos) or `5.0.0.0` (Core demos), and
runs `democheck.py shoot` through `heavy.py`.

## Before the rounds start (Sol)

1. Decide the shipped default (guideline section 2: themed 'Fluent Light' with a Light/Dark
   selector, recommended) - the pilot implements it.
2. LCL: decide whether LCL demos are compiled anywhere (no Lazarus FNC packages on this machine).
3. WEB: the command-line TMS WEB compiler cannot build units shared through `{$IFDEF}` form classes
   (Kanban Board, also before the pilot); verify those in the IDE or give WEB its own unit.
