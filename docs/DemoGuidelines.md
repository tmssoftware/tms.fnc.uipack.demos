# TMS FNC demo guidelines (Core 5.0 / UI Pack 8.0)

Every TMS FNC Core and UI Pack demo follows these rules, on every framework it ships for (FMX, VCL,
WEB, LCL). The reference for the look is the Theming Dashboard
(`Shared Code/Form Unit/Theming Dashboard`, `WEB/Theming Dashboard`). The tools in `tools/` scan,
convert and check demos against this guide (see `tools/README.md`).

## 1. The rule that matters most

**A `TTMSFNCThemeManager` on the main form themes everything, and switching between Light and Dark
leaves nothing unreadable.** Concretely:

- the chrome (labels, buttons, check boxes, edits, panels, combo boxes) consists of FNC controls, so
  the theme reaches it (section 3);
- no FNC control carries a hard-coded colour that the theme cannot override, except where the demo
  is *about* colour (section 4);
- the demo still works and stays readable **without** a theme: remove the manager (or clear its
  `Theme`) and the classic FNC look appears, nothing is lost.

`python -I tools/democheck.py shoot <project>` verifies it: it runs the demo as shipped, without a
theme and with a manager injected for 'Fluent Light' and 'Fluent Dark', saves the screenshots and
flags text whose contrast to its background is below 3:1.

## 2. Theme manager: shipped themed

Demos ship **themed by default**: a `TTMSFNCThemeManager` named `ThemeManager` on the main form with
`Theme = 'Fluent Light'` and `Scope = tsApplication` (the default), exactly as the Theming Dashboard.

Why not ship it with an empty `Theme` (which keeps the released appearance)? The professional 8.0 look
*is* the theme: FNC controls placed without a theme show the classic look of earlier versions, and a
demo is the first thing a customer judges the product by. Shipping themed also shows the feature in
every demo instead of one. The other direction stays covered: the check runs every demo with no theme
as well, so deleting the manager, clearing its `Theme` or dropping your own manager with another
theme all work. A developer who wants the classic look sets `Theme` to ''.

The header (section 5) carries a `TTMSFNCThemeSelector` linked to the manager (`ThemeManager`
property) that offers 'Fluent Light' and 'Fluent Dark'; demos that need the room may leave it out.
LCL has no theme manager (no LCL theme unit): LCL demos follow the layout rules only.

Core demos: Core has no chrome controls (button, label, panel are UI Pack). Core demos keep native
chrome and let it follow the theme in code (`TTMSFNCTheme.AddChangeListener`: native label text in the
theme's text colour); native buttons and edits keep the platform look, which is readable on both.

## 3. Controls: FNC for the chrome

Use the FNC control wherever one exists; keep a native control only where FNC has no equivalent.

| Native | FNC | Notes |
| --- | --- | --- |
| TLabel, TStaticText, TText | TTMSFNCHTMLText | `HorizontalTextAlign = gtaLeading`, `Fill.Kind = gfkNone`, `Stroke.Kind = gskNone`; secondary text: `TextRole = htrSecondary` (never a grey font colour) |
| TButton, TSpeedButton, TBitBtn | TTMSFNCButton | `Default` on the primary action |
| TCheckBox | TTMSFNCCheckBox | FMX `IsChecked` / VCL `Checked` -> `Checked`; VCL `OnClick` -> `OnChange` |
| TRadioButton | TTMSFNCRadioButton | VCL groups by parent -> `GroupName` |
| TEdit | TTMSFNCEdit | same events (it descends from the platform edit) |
| TPanel | TTMSFNCPanel | `Header.Visible = False` for plain containers |
| TGroupBox | TTMSFNCPanel | `Header.Text` = the caption, or a section caption (HTMLText) above a plain panel |
| TComboBox | TTMSFNCComboBox | FMX/VCL list combo: `Style = csDropDownList` |
| TTrackBar | TTMSFNCTrackBar | `OnChange` -> `OnValueChanged(Sender; AValue: Single)` (manual) |
| TSwitch | TTMSFNCSwitch / TTMSFNCToggleButton | manual |
| TListBox | TTMSFNCListBox | items are a collection (manual) |
| TRadioGroup | TTMSFNCRadioGroup | manual |
| TPageControl / TTabControl | TTMSFNCPageControl / TTMSFNCTabSet | manual, part of the layout redesign |
| TSpinEdit / TSpinBox / TNumberBox | TTMSFNCSpinEdit | manual |
| TMemo | keep (TTMSFNCMemo is a code editor) | readable on both: native edits keep the platform look |
| TImage, TLayout, TScrollBox, TSplitter | keep | layout only |

`tools/democonvert.py --native` makes the replacements of the first rows automatically, including
field types, uses clause and `IsChecked`/`Caption` accesses; the rest is reported as manual.

## 4. Colours and fonts

- No hard-coded colours on FNC controls. A colour property that equals the class default is noise
  (remove it); a colour the theme owns is fine but still noise in the form; a *developer* colour
  (`TTMSFNCTheme.DeveloperValues`) survives every theme switch and is the usual cause of white panels
  in Dark. `democonvert.py --colors default|theme|developer` removes them by class.
- Demos about colour or custom drawing keep their colours on purpose (Timeline custom drawing,
  Planner item colours, DataGrid conditional formatting, colour pickers, Kanban card colours, the
  green "customized" calendar). Mark them so scans and reviewers know:
  - a comment in the form unit: `{ demo-colors: TMSFNCCalendar2, ColorPanel.Fill.Color }`, and
  - where the colours must not change under a theme at all, `ThemingEnabled = False` on that control
    (or a `ThemeName` of its own).
- Colour in code (`MakeGraphicsColor`, `gcXxx` in `FormCreate`) follows the same rule: use theme
  tokens through the control's defaults, or keep it only when the colour is the subject.
- Fonts come from the theme: no `Font.Name`, no `Font.Color`. Sizes and weight may be set for
  hierarchy only: title 20 pt semibold, section captions 13 pt semibold, body default, secondary text
  `TextRole = htrSecondary`.

## 5. Layout

```
+--------------------------------------------------------------------------+
| Title (20 pt semibold)                           [Fluent Light|Dark]     |  header 72
| One-line description (secondary)                                          |
+-------------------+------------------------------------------------------+
| Settings panel    |                                                      |
| (TTMSFNCPanel,    |   the demo's subject control(s), Align Client        |
|  260 wide, left)  |                                                      |
|  section captions |                                                      |
|  FNC check boxes, |                                                      |
|  radios, buttons  |                                                      |
+-------------------+------------------------------------------------------+
```

- **Header** (`DemoHeader`, TTMSFNCPanel, Align Top, height 72, no fill, no stroke): `DemoTitle`
  (the component and the scenario, not "Demo"), `DemoDescription` (one line, what to try),
  `DemoThemeSelector` (Align Right, 240 wide, margins 18/24/18). `democonvert.py --header` adds it.
- **Settings panel** on the left (Align Left, width 240-280, margins 16 left/16 bottom), section
  captions as HTMLText, controls aligned Top with 8 px between them, related options grouped. Demos
  whose subject is the window chrome (Ribbon) keep their own top area and get no header.
- **Content**: the subject control Align Client with 16 px margins; nothing absolutely positioned
  that could overlap at other sizes or DPI.
- **Spacing**: an 8 px grid (8, 16, 24); controls 32 px high (theme density standard); labels left
  aligned with the controls they describe.
- **Window**: `Position = poScreenCenter` / `ScreenCenter`, a client size that shows the demo without
  scrolling at 100 % on 1366x768 (about 1200x720 or less), resizable; the subject grows with the window.
- **DPI**: VCL forms are designed at 96 DPI with `Scaled = True` (default); no pixel sizes in code
  without `ScaleValue`/`TTMSFNCUtils.MulDivInt`; FMX is DPI independent.
- **Caption**: `TMS FNC <Product> - <Demo>` (e.g. `TMS FNC UI Pack - Calendar`).
- **About**: the description says what to try; longer explanations go into a secondary HTMLText in
  the settings panel, not into message boxes.
- **TMS logo**: only in demos that show a document or branding (PDF output, Ribbon application
  menu); never as decoration of the chrome.

## 6. Platform notes

- **FMX desktop and mobile**: the same form works on Windows, macOS, iOS and Android. On phones the
  settings panel collapses (use `TTMSFNCPanel` with Align Top and a collapsible header, or move the
  settings to a second tab); keep touch targets 32 px or more. Every FMX demo compiles for Win32,
  Win64, macOS (x64/ARM64), iOS ARM64 and Android 64 (`democheck.py compile --platforms ...`).
- **VCL**: Win32 and Win64.
- **WEB**: the form's `.html` template stays minimal; FNC controls are placed on the form as for VCL.
  The theme manager works the same; the page's `theme-color` follows when `TitleBar = tbTheme`.
- **LCL**: layout and cleanup only (no theme manager); keep the `.lfm` free of hard-coded colours so a
  later LCL theme unit can take over.

## 7. Checklist per demo

1. `python -I tools/demoscan.py <demo folder>`: note native controls and colours.
2. `python -I tools/democheck.py shoot <project> --tag before` (screenshots of today).
3. `python -I tools/democonvert.py <form> --native --colors default --header "Title" "Description" --write`
   (dry run first, without `--write`).
4. Manual pass: settings panel and content per section 5, manual natives, developer colours
   (`--colors developer` or exempt them), remove titles inside the content that the header now has.
5. `python -I tools/democheck.py compile <project> --platforms win32 win64 [osx64 osxarm64 iosarm64 android64]`.
6. `python -I tools/democheck.py shoot <project> --tag after`, then `sheet`; look at Light and Dark
   yourself, no low-contrast flags left (or explained).
7. Commit the demo per framework group, master copies together.
