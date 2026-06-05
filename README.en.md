# Dramatic Gobo Lighting

中文说明见 [README.md](./README.md).

Self-contained GitHub-distributable Codex skill for adding dramatic projected gobo lighting to existing images or new generated scenes.

This package includes:

- the skill instructions
- the selector script
- optimized bundled gobo assets
- tag-based controls for background locking, angle randomization, edge softness, and projection scale

## What It Does

Use this skill to add projected:

- window light
- venetian blind shadows
- leaf shadows
- caustic water reflections
- graphic line shadows
- abstract broken light

The skill is designed for image edits where the user wants lighting changes without redesigning the underlying subject.

## Repository Layout

```text
dramatic-gobo-lighting/
  README.md
  README.en.md
  README.zh-CN.md
  SKILL.md
  agents/
    openai.yaml
  references/
    gobo-library.md
  scripts/
    select_gobo.ps1
  assets/
    gobos/
      abstract/
      caustics/
      lines/
      plants/
      windows/
```

## Install

Copy this folder into your local Codex skills directory as:

```text
~/.codex/skills/dramatic-gobo-lighting
```

Typical Windows path:

```text
C:\Users\<you>\.codex\skills\dramatic-gobo-lighting
```

If you are standing in the repository root, you can test the selector with:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\select_gobo.ps1 -Brief "moody noir portrait with blind shadows"
```

## Core Tags

Use these tags directly in the user prompt.

### Background control

```text
@gobo-bg: lock
@gobo-bg: free
@gobo-bg: auto
```

### Angle control

```text
@gobo-angle: fixed
@gobo-angle: random
@gobo-angle: auto
```

### Edge softness

```text
@gobo-edge: crisp
@gobo-edge: soft
@gobo-edge: diffuse
@gobo-edge: soft*2
@gobo-edge: diffuse*2
@gobo-edge: auto
```

### Projection scale

```text
@gobo-scale: 0.75
@gobo-scale: 1.0
@gobo-scale: 1.5
@gobo-scale: 2.0
@gobo-scale: 2.5
```

Larger scale values make the projected pattern larger and more local.

### Manual gobo selection

```text
@gobo-file: GSG_Gobos_Windows_Blinds_07.jpg
@gobo-file: GSG_Gobos_Caustics_Caustics_02.jpg
```

Use the exact filename from [references/gobo-catalog.md](./references/gobo-catalog.md).

If this tag is present, it overrides automatic gobo selection and forces that exact reference.

## Recommended Prompt Patterns

### Image Edit / User Uploads An Image

Keep the background identical:

```text
@gobo-bg: lock @gobo-angle: fixed @gobo-edge: soft
Give this render dramatic architectural window light while keeping the background the same.
```

Let the background become moodier:

```text
@gobo-bg: free @gobo-angle: fixed @gobo-edge: diffuse
Add cinematic window light and allow the background atmosphere to shift darker.
```

Make the gobo larger so it only hits part of the frame:

```text
@gobo-bg: free @gobo-angle: fixed @gobo-edge: soft @gobo-scale: 2.0
Add a larger local window-light event that affects only one side of the composition.
```

Explore alternate angles:

```text
@gobo-bg: lock @gobo-angle: random @gobo-edge: soft
Try a different but still usable gobo-light direction on this render.
```

Use one exact gobo from the catalog:

```text
@gobo-bg: lock @gobo-angle: fixed @gobo-file: GSG_Gobos_Windows_Blinds_07.jpg
Use this exact blinds gobo on the uploaded render and keep the background the same.
```

### Text-to-Image / No Source Image

Generate a fashion portrait with venetian blinds:

```text
@gobo-bg: free @gobo-angle: fixed @gobo-edge: crisp
A cinematic fashion portrait of a woman in a dark hotel room, dramatic venetian blind shadows across the wall and shoulder, hard sunlight, low ambient fill, editorial luxury mood.
```

Generate a softer beauty image with plant shadows:

```text
@gobo-bg: free @gobo-angle: random @gobo-edge: diffuse
A clean beauty portrait with soft tropical leaf-shadow lighting on the face and background, warm afternoon sun, airy highlights, premium skincare campaign look.
```

Generate a product shot with a larger local gobo event:

```text
@gobo-bg: free @gobo-angle: fixed @gobo-edge: soft @gobo-scale: 2.0
A premium perfume bottle on a stone pedestal, a large localized window-light projection hitting only one side of the set, elegant shadows, luxury still-life photography.
```

Generate a watery caustics scene:

```text
@gobo-bg: free @gobo-angle: random @gobo-edge: diffuse*2
A sculptural cosmetic bottle in a sunlit spa setting with soft water-caustic reflections across the wall and surface, humid air, calm luxury atmosphere.
```

Generate with one exact gobo from the catalog:

```text
@gobo-bg: free @gobo-angle: fixed @gobo-file: GSG_Gobos_Caustics_Caustics_02.jpg
A premium skincare bottle in a quiet spa room, built around this exact caustics pattern, soft reflected water light across the wall, elegant luxury mood.
```

## Distribution Notes

- This GitHub version bundles optimized JPEG assets rather than the original 4K source files.
- The bundled assets are intended as reference guides for generation and editing, not as archival masters.
- The selector script assumes Windows PowerShell.
- The image generation path still depends on the host Codex environment having `$imagegen` available.

## Publish To GitHub

To share this with other people, make this folder the repository root, or upload the folder contents directly into a new repository.

Recommended structure:

```text
<repo-root>/
  README.md
  README.en.md
  README.zh-CN.md
  SKILL.md
  agents/
  references/
  scripts/
  assets/
```

Anyone who downloads or clones the repository only needs to copy the whole folder into:

```text
~/.codex/skills/dramatic-gobo-lighting
```

After that, the skill is self-contained. It does not depend on your original local `Gobos ...` folders.

## Practical Defaults

If no tags are provided, the skill behaves like this:

```text
@gobo-bg: auto
@gobo-angle: auto
@gobo-edge: auto
@gobo-scale: 1.0
```

For complex edits, the skill still defaults toward preservation-first behavior.
