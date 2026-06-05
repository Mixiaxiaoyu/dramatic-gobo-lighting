# Gobo Library

This distributable skill ships with 64 optimized gobo masks across five families:

- `assets/gobos/windows` - 30 files
- `assets/gobos/plants` - 15 files
- `assets/gobos/abstract` - 10 files
- `assets/gobos/lines` - 6 files
- `assets/gobos/caustics` - 3 files

Use the selector script for quick matching:

```powershell
& "<skill-root>\scripts\select_gobo.ps1" -Brief "moody noir portrait with blind shadows"
```

`<skill-root>` means the installed `dramatic-gobo-lighting` folder.

For exact file-level selection, use `references/gobo-catalog.md` and the prompt tag below:

```text
@gobo-file: GSG_Gobos_Windows_Blinds_07.jpg
```

You can also test an exact file match directly in PowerShell:

```powershell
& "<skill-root>\scripts\select_gobo.ps1" -Brief "manual override" -GoboFile "GSG_Gobos_Windows_Blinds_07.jpg"
```

The bundled assets are resized from the original 4K masters to a GitHub-friendlier distribution size. They are still large enough for reference-driven image editing and generation.

## Family Notes

### Windows

Best when the light should feel architectural, tense, or cinematic.

- `*_Blinds_*`
  - Use for venetian blind stripes, interrogation-room lighting, office noir, hotel-room tension, slatted face shadows, and hard-edged dramatic bars.
  - Prompt cues: hard key light, low fill, angled stripes, high contrast, shadow rhythm across face and wall.

- `*_Window_*`
  - Use for window panes, chapel or loft spill, strong rectangular frames, morning shafts, and formal interior geometry.
  - Prompt cues: long sunbeam, rectangular projection, architectural falloff, calm but dramatic ambient darkness.

### Plants

Best when the light should feel organic, editorial, tropical, or naturally dappled.

- `*_Palm_*`
  - Use for resort, editorial fashion, balcony light, tropical afternoons, warm vacation energy, and large leaf silhouettes.
  - Prompt cues: warm sunlight, tropical breakup, bold leaf edges, partial face coverage, airy highlights.

- `*_Tree_*`
  - Use for natural leaf dappling, softer outdoor breakup, garden mood, woodland shadow play, and grounded realism.
  - Prompt cues: softer organic pattern, moving leaf shade, filtered sunlight, believable outdoor spill.

### Caustics

Best when the light should feel watery, humid, reflective, or luxurious.

- Use for pool reflections, underwater shimmer, bathroom caustics, spa scenes, coastal resorts, and rippled refracted highlights.
- Prompt cues: moving water reflections, bright specular ripples, shimmer on skin or walls, humid air, cool or sunlit tones.

### Lines

Best when the light should feel graphic, minimal, stage-like, or sci-fi.

- Use for narrow beams, scan-line style breaks, product hero bars, fashion slashes, and highly controlled light geometry.
- Prompt cues: razor-sharp line light, clean dark negative space, sparse composition, precision, hard contrast.

### Abstract

Best when the light should feel unstable, smoky, textural, or experimental.

- Use for breakup that should not read as a real window or a literal leaf.
- Good for dream sequences, club mood, uneasy interiors, smoky shafts, or generalized "broken light" without a named source.
- Prompt cues: uneven breakup, textured haze, partial beam visibility, moody darkness, controlled chaos.

## Fast Matching Guide

- noir portrait, blinds, interrogation, office tension -> `Windows / Blinds`
- loft, hotel, chapel, morning window pattern -> `Windows / Window`
- beauty portrait with leaf shadows -> `Plants / Palm` or `Plants / Tree`
- tropical fashion, balcony light, resort mood -> `Plants / Palm`
- natural outdoor dappling -> `Plants / Tree`
- underwater, pool, spa, bathroom shimmer -> `Caustics`
- bottle, watch, jewelry, minimalist product drama -> `Lines` or `Windows / Window`
- experimental, smoky, unstable breakup -> `Abstract`

## Practical Rules

- Prefer one hero family per image.
- Use two gobo references only if they belong to the same family and differ mainly in density or shape.
- If a pattern lands on skin, keep at least one clean read area for the eyes or hero facial feature unless the user explicitly wants obscuration.
- If a pattern lands on a product, preserve logos, key contours, and readable silhouettes.
- When in doubt, start with `Windows / Blinds` for high-drama portraiture and `Windows / Window` for interior storytelling.
- For dense 3D renders or UI-heavy product shots, start conservatively with `Windows / Window`, `Plants / Tree`, or softer `Caustics` before using aggressive full-frame `Windows / Blinds`.
- For fragile scenes with many small elements, bias the first pass toward background coverage plus limited subject spill instead of full subject coverage.
