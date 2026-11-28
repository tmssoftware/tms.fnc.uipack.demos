# TMS FNC UI Pack - Platform styles

Shared form for the [VCL](../../../VCL/Styles) and [FMX](../../../FMX/Styles)
Styles demos. The FNC check box, combo box, tree view, and grid enable
`AdaptToStyle` in both demos. The VCL demo also enables it on the FNC button.
The FMX button and the FNC edit in both demos use their framework's styling.

When an application theme (a `TTMSFNCThemeManager`) switches to a dark theme,
the demo picks the dark style of the list, so the standard controls do not stay
light on a dark form; a light theme brings back the light style picked before.
