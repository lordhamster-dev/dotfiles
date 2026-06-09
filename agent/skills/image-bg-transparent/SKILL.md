---
name: image-bg-transparent
description: Make solid or pastel image backgrounds transparent using ImageMagick corner flood fill. Use this skill whenever the user asks to remove an image background, make a background transparent,去背景,抠图,背景变透明, or needs to post-process a generated image that has a solid/pastel background into a transparent PNG.
---

# Image Background Transparency (ImageMagick Flood Fill)

Use this skill to remove a solid or pastel-colored background from a raster image and produce a clean transparent PNG. The core technique is **ImageMagick flood fill from the four corners**, which works reliably even with pastel backgrounds that are spectrally close to subject pixels — situations where chroma-key and automatic background removal tools typically fail.

## When to use this skill

- A generated image (sticker, illustration, icon, avatar, etc.) has a solid or near-solid background that needs to become transparent.
- Chroma-key removal (`-transparent`, `-fuzz` with exact color) produces halos, bites into edges, or fails with pastels.
- The background color is **known or can be sampled** and is roughly uniform but may have slight color variation, anti-aliasing, or gradient edges.
- The user explicitly asks for 去背景, 抠图, 背景变透明, transparent background, remove background, or similar.

Do **not** use this skill when the background is a complex photographic scene, or when the user needs subject cutout from a busy image. This technique shines with clean, solid or pastel backgrounds typical of generated sticker sheets, UI mockups, icons, and flat illustrations.

## Inputs to collect

Ask only for what is missing:

1. **Input image path**: local file to process.
2. **Background color(s)**: the dominant background color(s) to flood, e.g. `#FFF5F7`. If unknown, the agent should sample corner pixels from the image.
3. **Output path**: where to save the transparent PNG. Default: same directory with `-transparent` suffix.
4. **Keep shadows?**: whether soft drop shadows around the subject should be preserved (requires lower fuzz) or removed entirely.

## Core command

```bash
magick input.png -alpha set -fuzz N% -fill none \
  -draw 'color 0,0 floodfill' \
  -draw 'color W,0 floodfill' \
  -draw 'color 0,H floodfill' \
  -draw 'color W,H floodfill' \
  output.png
```

where `W = width - 1` and `H = height - 1`.

### How to get image dimensions

```bash
identify -format '%w %h' input.png
```

### Fuzz testing workflow (recommended)

Test multiple fuzz values and visually inspect each, then pick the cleanest one:

```bash
W=$(identify -format '%w' input.png)
H=$(identify -format '%h' input.png)
W=$((W - 1))
H=$((H - 1))

for f in 1 2 3 4; do
  magick input.png -alpha set -fuzz ${f}% -fill none \
    -draw "color 0,0 floodfill" -draw "color ${W},0 floodfill" \
    -draw "color 0,${H} floodfill" -draw "color ${W},${H} floodfill" \
    output-f${f}.png
done
```

Review each output and select the one with cleanest edges. Fine-tune in smaller steps (0.2%–0.5%) around the best value if needed.

## Fuzz threshold guide

Fuzz selection principle: **maximize fuzz without eating into subject pixels.**

General thresholds:

| fuzz    | typical outcome                                       |
| ------- | ----------------------------------------------------- |
| 0.3%–1% | background remnants left around edges                 |
| **2%**  | cleanest balance for most illustrations (Recommended) |
| 3%–4%   | starts biting into light-colored subject areas        |
| >5%     | significantly erodes subject, usually unusable        |

## Common pitfalls

- **Light-subject bleed**: When the subject has white or very light areas (clothing, outlines, highlights), the background and subject are spectrally close. Keep fuzz ≤ 2%, test increments of 0.2%, and accept a slight background halo rather than eating into the subject.
- **Shadow edge treatment**: Soft drop shadows around the subject produce a gradient halo. Start at 2%, then fine-tune in 0.2% steps (e.g. 1.2%, 1.5%, 1.8%) if the shadow fringe is too thick. If shadows should remain, accept a slightly lower fuzz.
- **Checkerboard backgrounds**: Some intermediate outputs may show a faux checkerboard pattern (alternating `#F6F6F6` / `#FCFCFC`). Flood fill works on these as long as both checker colors are within the fuzz tolerance of each other — push fuzz up slightly (3–4%) and verify no subject damage.
- **Non-uniform backgrounds**: If the background has a gradient or vignette, corner flood fill may still work if the gradient is gentle. Sample all four corners — if they differ significantly, flood from each corner with the sampled color as the anchor, or consider a different approach.

## Execution guidance

1. Verify `imagemagick` is installed (`which magick`). If missing, instruct the user to install it.
2. Sample the background color from at least two corners using `magick input.png -crop 1x1+0+0 txt:-` or similar.
3. Get image dimensions.
4. Run the fuzz testing loop above.
5. Ask the user to review outputs, or visually inspect with `read` if available.
6. Once the best fuzz is identified, produce the final output.
7. Report the output path and fuzz value used.
