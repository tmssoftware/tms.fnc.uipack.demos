# TMS FNC UI Pack - Platform styles

Use the picker to switch the application style with `TStyleManager`. Compare
standard VCL controls with their TMS FNC counterparts, a tree view, and a grid.

The FNC button sets `AdaptToStyle := True` to use the Windows10 Dark style
for its face and caption.

Build `Demo.dproj` with Delphi 13 for Win32 or Win64. The project embeds the
Windows10, Windows10 Dark, and Aqua Light Slate styles from the Delphi
installation. Windows is the built-in default.

Run `Demo.exe --self-check --output "<this demo folder>\output"` to capture
one PNG per style and exit. If you omit `--output`, the demo writes to an
`output` folder beside the executable.
