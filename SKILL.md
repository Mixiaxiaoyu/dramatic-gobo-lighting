---
name: dramatic-gobo-lighting
description: Apply dramatic gobo lighting and projected shadow breakup to an existing image or a new image using the gobo masks in this workspace. Use when a user wants cinematic projected shadows, window light, venetian blinds, leaf breakup, caustics, graphic bars, water reflections, or other patterned shadows.
---

# Dramatic Gobo Lighting

## Overview

Turn the local gobo masks in this workspace into repeatable cinematic lighting. This skill is for projected light and shadow breakup, not for pasting a flat texture overlay on top of an image.

This skill composes `$imagegen` for the actual image generation or image editing. Use this skill to choose the right gobo family, inspect the mask, build the lighting prompt, and iterate until the projection feels physically plausible and dramatic.

For edit tasks, the default bias should be preservation-first. Assume the user wants the original image, model, layout, labels, UI, accessories, and background hue preserved unless they explicitly ask for a broader restyle.

## User Control Tags

Users can explicitly control background handling and gobo placement by placing these tags anywhere in their prompt:

```text
@gobo-bg: lock
@gobo-bg: free
@gobo-bg: auto
@gobo-angle: fixed
@gobo-angle: random
@gobo-angle: auto
@gobo-edge: crisp
@gobo-edge: soft
@gobo-edge: diffuse
@gobo-edge: auto
@gobo-edge: soft*2
@gobo-edge: diffuse*2
@gobo-scale: 1.0
@gobo-scale: 2.0
@gobo-file: GSG_Gobos_Windows_Blinds_07.jpg
```

These tags should be parsed before any other prompt interpretation.

- `@gobo-bg: lock`
  - Keep the exact background hue, gradient direction, and background structure.
  - Use preservation-first behavior.
  - Best for brand backgrounds, clean renders, UI shots, and dense images with fragile small elements.

- `@gobo-bg: free`
  - Allow the background color, value, and atmosphere to shift if it helps the dramatic lighting.
  - Preserve the main subject and composition, but do not force the background to stay identical.
  - Best for more cinematic, mood-driven, or poster-like results.

- `@gobo-bg: auto`
  - Let the skill choose.
  - For complex edits, prefer `lock`.
  - For simpler scenes or when stronger atmosphere helps, allow behavior closer to `free`.

Rules for this tag:

- If the user includes the tag, obey it exactly.
- If multiple `@gobo-bg:` tags appear, the last one wins.
- Strip the tag from the final `$imagegen` prompt, but keep its effect.
- If the user gives natural-language instructions that conflict with the tag, the tag wins unless the user explicitly corrects it.
- If the tag is missing, default to `@gobo-bg: auto`.

Users can also control whether the projected light angle and landing position stay conservative or become randomized:

- `@gobo-angle: fixed`
  - Use a deliberate, conservative angle and landing zone.
  - Best for product shots, UI shots, dense 3D renders, and any image where stability matters more than exploration.

- `@gobo-angle: random`
  - Randomize the light direction, source side, source height, and projected landing emphasis for each attempt.
  - Keep the result physically plausible and compositionally usable.
  - Best for ideation, mood exploration, and quickly trying different dramatic-light directions.

- `@gobo-angle: auto`
  - Let the skill choose.
  - For complex edits, prefer `fixed`.
  - For simple portraits, fashion shots, or exploratory mood work, allow behavior closer to `random`.

Rules for this tag:

- If multiple `@gobo-angle:` tags appear, the last one wins.
- Strip the tag from the final `$imagegen` prompt, but keep its effect.
- If the tag is missing, default to `@gobo-angle: auto`.
- If the user explicitly describes a precise angle in plain language, that explicit angle overrides `random`.
- `random` means controlled randomization, not chaos. Do not block key labels, hero facial features, or critical UI unless the user clearly wants that.

Users can also control how sharp or blurred the light-to-shadow boundary should be:

- `@gobo-edge: crisp`
  - Keep the light/shadow boundary sharp and well-defined.
  - Best for hard sunlight, venetian blinds, graphic product shots, and noir looks.

- `@gobo-edge: soft`
  - Add a gentle feather to the edge transition.
  - Keep the projected pattern readable, but soften the penumbra.
  - Best for polished ad work where the edge should feel less harsh.

- `@gobo-edge: diffuse`
  - Use a visibly softer transition and a more defocused projected edge.
  - Keep the gobo shape readable, but let the boundary bloom and blur more.
  - Best for dreamy light, hazy interiors, and gentler editorial mood.

- `@gobo-edge: soft*2`
  - Make the `soft` boundary about one step softer than normal `soft`.
  - Use a broader feather while keeping the pattern clearly readable.

- `@gobo-edge: diffuse*2`
  - Make the `diffuse` boundary about one step softer than normal `diffuse`.
  - This is the recommended way to ask for "even softer than diffuse" without inventing a new mode.
  - Keep the projected pattern recognizable and the image itself sharp.

- `@gobo-edge: auto`
  - Let the skill choose.
  - For `Windows / Blinds`, `Lines`, and hard graphic looks, prefer `crisp`.
  - For `Plants`, `Caustics`, and softer beauty or atmosphere work, prefer `soft` or `diffuse`.

Users can also control the projected pattern scale, meaning how large the gobo appears in frame:

- `@gobo-scale: 1.0`
  - Neutral baseline.
  - Use the gobo at a normal projected size.

- `@gobo-scale: 2.0`
  - Enlarge the projected pattern roughly 2x.
  - This makes each window pane, blind stripe, or leaf shadow appear larger.
  - Best when the user wants the gobo to affect only part of the composition instead of repeating densely across the whole frame.

- Values above `1.0`
  - Enlarge the projected pattern.
  - Result: fewer, larger shapes and more local coverage.

- Values below `1.0`
  - Shrink the projected pattern.
  - Result: more repetitions and denser breakup across the frame.

Recommended mental model:

- bigger value = bigger gobo projection = more local / fewer repeats
- smaller value = smaller gobo projection = more tiled / more repeats

Rules for this tag:

- If multiple `@gobo-edge:` tags appear, the last one wins.
- Strip the tag from the final `$imagegen` prompt, but keep its effect.
- If the tag is missing, default to `@gobo-edge: auto`.
- If the user explicitly asks for "hard edge", "sharp shadow", "soft edge", "blurred boundary", or similar phrasing, that explicit request overrides `auto`.
- Edge softness should affect the light/shadow boundary, not blur the whole image or destroy the gobo pattern.
- Supported multiplier syntax is intentionally narrow for stability:
  - `soft*2`
  - `diffuse*2`
- Do not invent arbitrary values such as `*1.3`, `*4`, or `crisp*2`.
- If an unsupported multiplier appears, fall back to the base mode:
  - `soft*9` -> behave like `soft`
  - `diffuse*9` -> behave like `diffuse`

Rules for `@gobo-scale:`:

- Format it as a simple numeric value, for example:
  - `@gobo-scale: 0.75`
  - `@gobo-scale: 1.0`
  - `@gobo-scale: 1.5`
  - `@gobo-scale: 2.0`
- If multiple `@gobo-scale:` tags appear, the last one wins.
- Strip the tag from the final `$imagegen` prompt, but keep its effect.
- If the tag is missing, default to `@gobo-scale: 1.0`.
- Supported safe range is `0.5` to `3.0`.
- If the user gives a value outside that range, clamp it:
  - below `0.5` -> behave like `0.5`
  - above `3.0` -> behave like `3.0`
- Prefer combining larger scales with `@gobo-angle: fixed` when the user wants the light only on one side or one local region.

Users can also force one exact gobo file instead of using automatic selection:

- `@gobo-file: GSG_Gobos_Windows_Blinds_07.jpg`
  - Use this when the user wants one exact gobo, not just a family.
  - Preferred format is the exact filename from `references/gobo-catalog.md`.
  - This tag overrides automatic family selection.

Rules for `@gobo-file:`:

- If multiple `@gobo-file:` tags appear, the last one wins.
- Strip the tag from the final `$imagegen` prompt, but keep its effect.
- If the file resolves cleanly, use that exact gobo and skip automatic selection.
- Prefer exact filenames with the `.jpg` extension copied from `references/gobo-catalog.md`.
- `@gobo-file:` overrides family hints and selector ranking, but it does not override `@gobo-bg:`, `@gobo-angle:`, `@gobo-edge:`, or `@gobo-scale:`.
- If the user does not provide `@gobo-file:`, use normal automatic selection.

Example user prompts:

```text
@gobo-bg: lock Give this 3D render dramatic window light but keep the light blue background exactly the same.
@gobo-bg: free Add cinematic blinds lighting and let the background become moodier if needed.
@gobo-bg: auto Give this portrait leaf-shadow lighting.
@gobo-bg: lock @gobo-angle: fixed Give this product render clean architectural window light.
@gobo-bg: free @gobo-angle: random Try a more cinematic blinds-light version with a different light angle each time.
@gobo-bg: lock @gobo-angle: fixed @gobo-edge: soft Keep the same background but soften the shadow edge slightly.
@gobo-bg: lock @gobo-angle: fixed @gobo-edge: diffuse*2 Keep the same background but make the shadow boundary much softer.
@gobo-bg: lock @gobo-angle: fixed @gobo-scale: 2.0 Keep the same background but make the window pattern much larger so it only affects a local area.
@gobo-bg: lock @gobo-angle: fixed @gobo-file: GSG_Gobos_Windows_Blinds_07.jpg Use this exact blinds gobo on the uploaded render and keep the background exactly the same.
@gobo-bg: free @gobo-angle: random @gobo-file: GSG_Gobos_Caustics_Caustics_02.jpg Create a new spa-style scene using this exact water-caustics gobo.
```

## Project Assumption

This is a self-contained GitHub-distributable skill. The optimized gobo assets ship inside this folder under:

- `assets/gobos/abstract`
- `assets/gobos/caustics`
- `assets/gobos/lines`
- `assets/gobos/plants`
- `assets/gobos/windows`

Do not depend on external `Gobos ...` folders. When this skill is installed correctly, `scripts/select_gobo.ps1` resolves the bundled assets automatically.

## Generation Delegation

Before generating or editing images, load and follow the installed image generation skill:

```text
${CODEX_HOME:-$HOME/.codex}/skills/.system/imagegen/SKILL.md
```

Use `$imagegen` for all actual visual generation. Do not fake the lighting with HTML/CSS, SVG, or code-native filters. The gobo masks in this workspace should act as visual references that guide the projected light pattern.

## When To Use

Use this skill when a user wants any of the following:

- dramatic lighting on an existing image
- projected patterned shadows on walls, floors, faces, or products
- window light, venetian blind light, leaf breakup, caustics, or graphic light bars
- a moody, cinematic, editorial, noir, stage, or luxury-lighting look
- the same effects described in any language, including Chinese briefs that mention dramatic relighting or patterned shadows

## When Not To Use

Do not use this skill when:

- the user wants vector artwork or code-native graphics instead of a bitmap image
- the request is standard retouching with no lighting redesign
- the user wants physically accurate 3D scene relighting inside a DCC tool rather than a final image result

## Default Workflow

1. Decide the mode.
   - If the user already has an image to modify, treat it as an edit task.
   - If the user wants a brand-new image, treat it as a generate task.

1.5 Parse the user control tag.
   - Scan the raw user prompt for `@gobo-bg: lock`, `@gobo-bg: free`, or `@gobo-bg: auto`.
   - Scan the raw user prompt for `@gobo-angle: fixed`, `@gobo-angle: random`, or `@gobo-angle: auto`.
   - Scan the raw user prompt for `@gobo-edge: crisp`, `@gobo-edge: soft`, `@gobo-edge: diffuse`, `@gobo-edge: auto`, `@gobo-edge: soft*2`, or `@gobo-edge: diffuse*2`.
   - Scan the raw user prompt for `@gobo-scale: <number>`.
   - Scan the raw user prompt for `@gobo-file: <exact filename>`.
   - Decide background behavior, angle behavior, edge behavior, and scale behavior from the tags before building the image prompt.
   - If `@gobo-file:` is present, resolve it against `references/gobo-catalog.md` before running any automatic selector.
   - Remove the tags themselves from the final prompt sent to `$imagegen`.

2. Pick the gobo.
   - If `@gobo-file:` is present, use that exact gobo from `references/gobo-catalog.md` and skip automatic family selection.
   - If the user already specified a family such as windows, plants, or caustics, honor it.
   - If the user brief is not already in English, rewrite it into a short English selector brief before running the helper script. Keep only the subject, mood, and desired light pattern.
   - Otherwise run the bundled selector script:
     ```powershell
     powershell -ExecutionPolicy Bypass -File "<skill-root>\scripts\select_gobo.ps1" -Brief "<user brief>"
     ```
   - `<skill-root>` means the installed `dramatic-gobo-lighting` folder.
   - `-Root` is optional and is mainly useful for debugging or alternate folder layouts.

3. Inspect the references.
   - Load the target image if this is an edit request.
   - Load one to three gobo images with `view_image`.
   - Prefer one dominant gobo. Use two only when they belong to the same family and the effect needs variation rather than a second unrelated pattern.

4. Build the lighting brief.
   Include:
   - where the light source sits
   - how hard or soft the projection is
   - how much ambient fill remains
   - what surfaces receive the pattern
   - whether haze, dust, or moisture should reveal the beam
   - what must stay readable
   - which tiny elements must not move, redraw, disappear, or change color
   - whether the background hue must stay exactly locked
   - whether the gobo angle should stay fixed or be randomized
   - how sharp or feathered the light/shadow boundary should be
   - how large or small the projected gobo should appear in frame

5. Call `$imagegen`.
   - For edits: preserve composition, identity, lens, pose, materials, layout, labels, and background hue unless the user asked to change them.
   - For new generations: design the scene around one dominant projected pattern.
   - Always describe the effect as projected light through a gobo or cookie, not as a texture pasted on top.
   - If `@gobo-bg: lock` is active, explicitly lock the background hue and structure.
   - If `@gobo-bg: free` is active, allow background mood and color drift in service of the lighting.
   - If `@gobo-angle: fixed` is active, keep the light direction and landing zone deliberate and conservative.
   - If `@gobo-angle: random` is active, randomize angle and placement within safe, physically plausible bounds.
   - If `@gobo-edge: crisp` is active, keep the edge hard and graphic.
   - If `@gobo-edge: soft` is active, add mild feathering to the light/shadow boundary.
   - If `@gobo-edge: diffuse` is active, add stronger feathering and defocus to the boundary while preserving pattern readability.
   - If `@gobo-scale:` is larger than `1.0`, make the projected pattern larger and less repeated.
   - If `@gobo-scale:` is smaller than `1.0`, make the projected pattern smaller and more repeated.
   - If `@gobo-file:` is active, treat that exact gobo reference as authoritative and do not substitute a different pattern unless the user explicitly asks for it.

6. Validate and iterate.
   - The pattern should wrap over geometry and obey perspective.
   - The light should feel directional, not like a 2D overlay.
   - If the effect is weak, make one targeted change: harder key, darker ambient, tighter beam, stronger haze, or closer gobo.
   - If the effect is too fake, reduce density, widen the source slightly, or keep more clean light on the subject.

## Prompt Rules

### For edit tasks

Use language like:

- "Keep the existing image composition, subject identity, camera angle, lens feel, wardrobe, and materials."
- "Change the lighting only."
- "Introduce a projected gobo light based on the attached reference mask."
- "The pattern should read as real light and shadow moving across 3D surfaces, not as a flat overlay."

Background behavior depends on `@gobo-bg:`:

- `lock`: explicitly preserve the exact background hue and structure
- `free`: allow the background to become moodier or darker if it helps the image
- `auto`: choose based on scene complexity and user intent

Angle behavior depends on `@gobo-angle:`:

- `fixed`: use a chosen, stable light direction and landing zone
- `random`: vary the light angle and placement for exploration
- `auto`: choose fixed for fragile scenes and random for exploratory scenes

Edge behavior depends on `@gobo-edge:`:

- `crisp`: hard edge, tight penumbra, strong graphic shadow
- `soft`: gentle feathering, cleaner ad-style falloff
- `diffuse`: broader penumbra, more atmospheric blur at the boundary
- `soft*2`: clearly softer than `soft`, but still commercially clean
- `diffuse*2`: clearly softer than `diffuse`, but still recognizable as the same gobo
- `auto`: choose from the scene type and gobo family

Scale behavior depends on `@gobo-scale:`:

- `> 1.0`: enlarge the projected pattern
- `= 1.0`: normal projected size
- `< 1.0`: shrink the projected pattern

Protect these invariants unless the user says otherwise:

- face identity
- pose and framing
- product geometry and branding
- architecture layout
- material realism
- text, labels, logos, icons, and screen content
- small accessories and repeated decorative parts
- background hue and gradient structure

### For new image generation

Use language like:

- "Create a scene lit by a single dominant gobo projection inspired by the attached reference image."
- "Let the gobo define the shadow breakup and beam shape."
- "Keep the rest of the lighting restrained so the projection remains the hero."

### Shared cinematography rules

Always specify:

- source angle: side, back-side, top, or frontal offset
- source hardness: razor sharp, crisp, medium-soft, or diffused
- coverage: face only, background only, or environment plus subject
- contrast: low fill, deep shadows, or soft moody falloff
- atmosphere: clean air, subtle haze, humid air, dusty beam, or underwater shimmer
- color temperature if relevant

Avoid these failure modes:

- flat texture overlays
- random double shadows from mixed families
- fully obscuring eyes or product marks unless requested
- uniform full-frame patterns with no falloff
- lighting that ignores perspective or surface curvature

## Preservation-First Mode

Use this mode by default for complex edits, including:

- dense 3D character renders
- product renders with small labels or UI
- phone screens, dashboards, and interface mockups
- images with many accessories, ornaments, or micro-details
- any image where the background color is part of the brand look

In preservation-first mode, assume all of these are locked unless the user says otherwise:

- every object stays in the same place
- no accessories are added, removed, resized, or redesigned
- labels and small text stay unchanged
- the main silhouette stays identical
- the background hue, gradient direction, and color family stay unchanged
- the image remains the same scene, not a reinterpretation

When editing a complex image, explicitly include lines like:

- "Edit the attached image only."
- "Change the lighting only."
- "Do not redesign, replace, remove, or reinterpret any object."
- "Do not alter any small accessory, label, icon, text, UI element, or decorative part."
- "Keep the exact background hue and gradient structure. Do not recolor the background."
- "Preserve the exact silhouette, proportions, and spacing of all parts."

If the scene is asset-dense, prefer a conservative first pass:

- keep the gobo strongest on the background and secondary planes
- let only partial spill land on fragile hero elements
- avoid full-frame coverage on the first edit
- keep one clean read area around labels, UI, or facial features

If a first pass drifts small elements, do not immediately switch families. Retry once with tighter preservation language and lower gobo coverage first.

## Background Mode Mapping

Map the user tag to prompt behavior like this:

- `@gobo-bg: lock`
  - Use the locked edit scaffold or equivalent language.
  - Add explicit lines preserving the exact background hue, gradient, and structure.
  - Bias gobo coverage toward background planes and controlled spill.

- `@gobo-bg: free`
  - Use the normal edit scaffold.
  - You may allow the background to darken, warm up, cool down, or pick up more atmosphere.
  - Still preserve the main subject, composition, and key readable elements.

- `@gobo-bg: auto`
  - For dense 3D renders, UI shots, and branded backgrounds, behave like `lock`.
  - For simpler scenes, portrait mood shots, and poster-style edits, you may behave like `free`.

## Angle Mode Mapping

Map the user tag to prompt behavior like this:

- `@gobo-angle: fixed`
  - Use explicit light placement language such as side-left, side-right, top-front, or back-side.
  - Keep the landing zone intentional and repeatable.
  - Prefer this for dense images, product renders, branded compositions, and UI-heavy scenes.

- `@gobo-angle: random`
  - Randomize from a controlled set of plausible placements:
    - left side key
    - right side key
    - high side slash
    - offset frontal window spill
    - back-side rim projection
  - Also randomize where the gobo lands most strongly:
    - background-first
    - upper-face-first
    - shoulder-and-chest-first
    - object-edge-first
  - Keep at least one clean readable area around labels, eyes, screens, or hero details.
  - Do not use fully centered full-face obstruction as the default random outcome.

- `@gobo-angle: auto`
  - For fragile, complex, or branded images, behave like `fixed`.
  - For portraits, exploratory fashion, mood boards, and ideation passes, you may behave like `random`.

## Edge Mode Mapping

Map the user tag to prompt behavior like this:

- `@gobo-edge: crisp`
  - Use prompt language such as:
    - "crisp shadow edge"
    - "sharp projected boundary"
    - "tight penumbra"
  - Prefer smaller-source, harder-light behavior.

- `@gobo-edge: soft`
  - Use prompt language such as:
    - "slightly feathered shadow edge"
    - "gentle light-to-shadow transition"
    - "softened penumbra while keeping the pattern readable"
  - This is the best default when the user wants exactly the kind of subtle blur shown in the screenshot.

- `@gobo-edge: soft*2`
  - Use prompt language such as:
    - "noticeably softer feathered edge"
    - "broader penumbra than normal soft"
    - "still clean and readable, but one level softer"
  - Good when `soft` is not enough but `diffuse` would change the mood too much.

- `@gobo-edge: diffuse`
  - Use prompt language such as:
    - "visibly diffused projected edge"
    - "broader penumbra"
    - "soft blurry boundary but still recognizable gobo pattern"
  - Good for haze, atmosphere, beauty, and dreamy lighting.

- `@gobo-edge: diffuse*2`
  - Use prompt language such as:
    - "much softer than normal diffuse"
    - "very broad penumbra"
    - "soft atmospheric boundary with the window pattern still readable"
  - Use this when the user explicitly wants the same diffuse idea but about twice as soft.
  - Keep the blur on the shadow boundary only; do not blur materials, labels, or the whole image.

- `@gobo-edge: auto`
  - For `Windows / Blinds`, `Lines`, and hard product drama, behave like `crisp`.
  - For `Windows / Window` in clean ad work, usually behave like `soft`.
  - For `Plants`, `Caustics`, haze, and softer mood work, behave like `soft` or `diffuse`.

## Scale Mode Mapping

Map `@gobo-scale:` to prompt behavior like this:

- `@gobo-scale: 0.5` to `0.9`
  - Use prompt language such as:
    - "smaller projected pattern"
    - "denser repetition"
    - "more frequent shadow breakup across the frame"

- `@gobo-scale: 1.0`
  - Use normal size behavior.

- `@gobo-scale: 1.1` to `1.6`
  - Use prompt language such as:
    - "slightly enlarged projected pattern"
    - "fewer larger shapes"
    - "less dense repetition"

- `@gobo-scale: 1.7` to `2.3`
  - Use prompt language such as:
    - "much larger projected pattern"
    - "localized coverage"
    - "the gobo should only affect part of the composition"
  - This is the best range when the user wants a result like the red-box example.

- `@gobo-scale: 2.4` to `3.0`
  - Use prompt language such as:
    - "very large projected pattern"
    - "single local window or shadow event"
    - "do not tile the pattern across the whole frame"
  - Use carefully and usually together with `@gobo-angle: fixed`.

## Family Selection Guide

Read `references/gobo-library.md` for the full family map and `references/gobo-catalog.md` for exact file names. Use these defaults:

- `Windows / Blinds`: noir portraits, interrogations, hotel rooms, office interiors, hard stripes
- `Windows / Window`: lofts, churches, architectural spill, morning or late-afternoon frames
- `Plants / Palm`: tropical editorial, vacation mood, warmer sun breakup
- `Plants / Tree`: natural leaf dapple, outdoor softness, organic breakup
- `Caustics`: water reflections, pool shimmer, underwater, spa, humid luxury
- `Lines`: graphic bars, sci-fi slashes, stage beams, minimal product drama
- `Abstract`: smoky breakup, unstable beams, dreamlike or experimental contrast

## Prompt Scaffolds

### Edit scaffold

```text
Use case: lighting-weather
Primary request: add dramatic projected gobo lighting to the attached image.
Keep the existing subject identity, pose, composition, lens feel, materials, and environment layout.
Use the attached gobo reference to shape the light and shadow breakup.
Treat it as a real projected light through a gobo or cookie, not as a pasted texture overlay.
Lighting direction: <angle>.
Light quality: <hardness>.
Coverage: <where the pattern lands>.
Ambient fill: <low / moderate / near-black negative fill>.
Atmosphere: <clean air / haze / dust / humidity>.
Mood: <noir / editorial / luxury / tense / dreamy>.
Preserve readability of <eyes / face / product logo / architecture features>.
```

### Locked edit scaffold for complex images

```text
Use case: lighting-weather
Primary request: add dramatic projected gobo lighting to the attached image.
Edit the attached image only. Change the lighting only.
Keep the exact composition, camera angle, perspective, subject identity, silhouette, materials, labels, text, UI, accessories, and spacing of all parts.
Keep the exact background hue and gradient structure. Do not recolor or redesign the background.
Do not add, remove, redesign, resize, or reinterpret any small element.
Use the attached gobo reference only to shape projected light and cast shadow.
The pattern must read as real projected light wrapping across existing 3D surfaces, not as a flat overlay.
Coverage: <background first / edge spill on hero object / partial face coverage / controlled shoulder spill>.
Keep a clean readable area around <label / face / screen / logo / hero accessory>.
Maintain the original scene exactly; only the lighting and resulting shadows should change.
```

### Generate scaffold

```text
Use case: stylized-concept
Primary request: create a new scene built around dramatic gobo lighting.
Use the attached gobo reference as the shadow-breakup guide for a projected key light.
Scene: <scene>.
Subject: <subject>.
Lighting direction: <angle>.
Light quality: <hardness>.
Coverage: <subject / wall / floor / full room>.
Ambient fill: <low / moderate>.
Atmosphere: <haze / mist / humid air / clean>.
Mood: <cinematic mood>.
Do not flatten the image with an all-over texture. Keep the projection directional and physically plausible.
```

## Quick Recovery Moves

If the first result misses:

- too subtle: ask for stronger contrast, lower fill, a tighter beam, and a more legible projected pattern
- too harsh: ask for slightly softer edges and a cleaner light-to-shadow transition
- too fake: ask for realistic falloff, surface wrapping, and partial occlusion over geometry
- too busy: reduce pattern coverage and keep one clean hero area
- not dramatic enough: darken the room, add negative fill, and let the projection become the main key

## Tools And Resources

- gobo map: `references/gobo-library.md`
- gobo catalog: `references/gobo-catalog.md`
- selector helper: `scripts/select_gobo.ps1`
- visual generation: `$imagegen`
