# Demo tools

Python 3 (stdlib; Pillow for screenshots/contrast), run from the repository root with `python -I`.
They implement the rules of `docs/DemoGuidelines.md`. They work on any FNC demo folder, also the Core
demos repository (pass its paths).

| Tool | What it does |
| --- | --- |
| `demoscan.py <folder or form>...` | Per form: native controls (with the FNC replacement or "manual"), colour properties of FNC controls classified `default` / `theme` / `developer` / `exempt` / `unknown`, native and form colours, theme manager present. `--brief` one line per form, `--json` the full report. |
| `democonvert.py <form>... [--native] [--colors default\|theme\|developer] [--header TITLE DESCRIPTION] [--theme-manager THEME] [--write]` | Dry run by default. `--native` replaces simple native controls (label, button, check box, radio button, edit, panel, group box, combo box) and updates the unit (field types, uses, `IsChecked`/`Caption` accesses, class references); `--colors` removes colours by class; `--header` adds the guideline header with a theme selector (and a `ThemeManager`, 'Fluent Light'); units shared by several frameworks are reported, not changed. |
| `formedit.py <form> <Object> Prop=Value -Prop [--delete] [--rename Class]` | Scripted manual edits of one object (FMX floats are written in form-file notation). |
| `democheck.py compile <project>... --platforms win32 win64 osx64 osxarm64 iosarm64 android64 [--delphi 13 12]` | Builds Win32/Win64 (linked) and compiles the project's units for macOS, iOS and Android (no SDK, nothing linked) against the theming sources; WEB projects with TMS WEB Core. Results in `<out>/compile-<tag>.json`. |
| `democheck.py shoot <project>... --tag before\|after` | Builds Win32 with `delphi/DemoShot.pas` linked in, runs the demo on the hidden desktop (harness `hidden_desktop.py`) and captures it as shipped (`asis`), without a theme (`none`) and with an injected `TTMSFNCThemeManager` ('Fluent Light', 'Fluent Dark'). Writes per mode a PNG and a JSON (controls, bounds, `TTMSFNCTheme.DeveloperValues`), `defaults.json` (run-time defaults of the FNC classes, used by `demoscan`) and `summary.json` (low-contrast text-bearing controls, ratio below 3:1; visible native controls). A streaming error or exception ends the demo with `error.txt`. |
| `democheck.py sheet --tags before after --modes asis "Fluent Dark"` | Contact sheet of a results folder (one row per demo). |

Defaults: theming sources `E:/Delphi/tms.fnc.core-theming` and `tms.fnc.uipack-theming` (`--core`,
`--uipack`), results `.../TMS FNC Theming/results/demos-pilot` (`--out`), scratch builds
`%TEMP%/claude/democheck` (`--work`; FNC DCUs are cached per compiler and platform there).

Machine rules (AGENTS.md): runs over more than a couple of demos go through the harness
`tools/heavy.py` (`python -I ".../TMS FNC Theming/tools/heavy.py" python -I tools/democheck.py shoot ...`);
demo executables only start through `hidden_desktop`.

Typical round for one demo: see the checklist at the end of `docs/DemoGuidelines.md`.

Known limits: WEB forms are compiled, not run; WEB natives (`TWebLabel`...) are not converted
automatically; LCL forms only get `--header` (native) and are not compiled here (no Lazarus FNC
packages); the command-line TMS WEB compiler fails on units shared with `{$IFDEF}` form classes
(Kanban Board, also before any change).
