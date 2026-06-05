---
name: chibi-stickers
description: Create matching chibi sticker sheets or individual stickers for recurring male/female lead characters from an existing generated sticker sheet reference. Use this skill whenever the user asks for 男主/女主表情包, chibi stickers, sticker sheet, single sticker, couples stickers, or wants to reuse a generated sticker-sheet style as a new reference image.
---

# Chibi Stickers

Use this skill to quickly generate a consistent chibi sticker sheet or a single sticker for recurring couple/character designs. The intended workflow is **reference-driven**: the user should provide the already-generated sticker sheet as the primary reference image, and the prompt should preserve its character designs, sticker outline, shadows, text style, pastel background, and overall kawaii rendering.

## Inputs to collect

Ask only for missing essentials:

1. **Reference sticker sheet image**: local path or attached image. Treat it as a style + character reference, not an edit target, unless the user explicitly asks to modify it.
2. **Character**: female lead / 女主, male lead / 男主, or both.
3. **Output type**: `3x3 sticker sheet` or `single sticker`.
4. **Sticker action + exact label** for single stickers, or a list of 9 actions/labels for a custom sheet. If absent, use the defaults below.
5. **Destination** only if the image needs to be saved somewhere specific.

Default to one combined skill, not separate skills: sheet and single-sticker generation share the same references and invariants.

## Shared invariants

Always include these constraints unless the user overrides them:

- Polished kawaii chibi illustration, clean digital sticker art, rounded shapes, expressive face, high cuteness, soft pastel accents.
- Preserve the reference sticker sheet's character identity and style.
- One character per sticker unless the user explicitly requests a couple sticker.
- Thick white sticker outline and soft shadow around each sticker.
- Chinese label rendered verbatim, large, rounded, legible, unified pink font color, cute handwritten style.
- Clean pastel pink background `#FFF5F7` for sheets unless transparent output is requested.
- No watermark, no extra people, no photo realism, no cluttered background.
- Upper body only (waist up / 上半身). No full-body shots, no legs, no shoes.

## Character identity anchors

Use these only as anchors; prefer the provided reference sticker sheet if it differs.

### Female lead / 女主

Young East Asian woman, long wavy black hair parted near center, soft round face, fair skin, gentle eyes, soft smile, crisp white button-up shirt, warm affectionate feeling.

### Male lead / 男主

Young East Asian man, short straight black hair with neat bangs, black rectangular glasses, fair skin, friendly smile, crisp white button-up shirt, warm affectionate feeling.

## Default 3x3 sheet labels

### Female sheet

1. 开心「开心」
2. 比心「爱你」
3. OK 手势「好哒」
4. 双手张开「抱抱」
5. 生气鼓脸「哼」
6. 流泪感动「感动」
7. 害羞脸红「害羞」
8. 睡觉抱枕「晚安」
9. 举小红心「想你」

### Male sheet

1. 开心「开心」
2. 比心「爱你」
3. OK 手势「好哒」
4. 双手张开「抱抱」
5. 推眼镜「认真」
6. 流泪感动「感动」
7. 加油握拳「加油」
8. 睡觉抱枕「晚安」
9. 举小红心「想你」

## Prompt templates

### 3x3 sticker sheet

```text
Using the provided generated sticker sheet as the primary reference for character design, line style, coloring, sticker outline, shadows, text treatment, and overall kawaii mood, create a new 3x3 chibi sticker sheet for [CHARACTER].

Character identity: [CHARACTER_ANCHOR]. Preserve recognizable features from the reference sheet.

Composition: 9 separate stickers arranged evenly in a 3x3 grid. Each sticker must be independent and easy to crop. Leave clear empty gutters between stickers; the thick white sticker outlines and soft shadows must never touch, overlap, or merge with neighboring stickers. Keep every sticker fully inside its own cell with visible margin on all sides.

Sticker items with exact Chinese labels: [NUMBERED_ACTION_LABEL_LIST].

Text: render every Chinese label verbatim in the same unified pink, large, rounded, legible cute handwritten style as the reference sheet.

Background: soft pastel pink (#FFF5F7), clean and uncluttered, no decorative background elements.

Constraints: upper body only (waist up), no full body; one character only; keep the reference style unified; each sticker isolated; no watermark; no extra people; no photo realism; avoid distorted hands, misspelled Chinese text, connected stickers, overlapping sticker outlines, merged shadows, cramped layout, cluttered background.
```

### Single sticker

```text
Using the provided generated sticker sheet as the primary reference for character design, line style, coloring, sticker outline, shadows, text treatment, and overall kawaii mood, create one standalone chibi sticker for [CHARACTER].

Character identity: [CHARACTER_ANCHOR]. Preserve recognizable features from the reference sheet.

Sticker action/expression: [ACTION].
Exact Chinese label: 「[LABEL]」.

Composition: one centered sticker, fully visible, easy to crop, with a thick white sticker outline and soft shadow. Leave generous empty margin on all sides. The pose and facial expression should read clearly at messaging-app size.

Text: render the Chinese label verbatim in the same unified pink, large, rounded, legible cute handwritten style as the reference sheet.

Background: soft pastel pink (#FFF5F7), clean and uncluttered, no decorative background elements. If the user requested transparency, use imagegen's transparent-output workflow instead.

Constraints: upper body only (waist up), no full body; one character only; keep the reference style unified; no watermark; no extra people; no photo realism; avoid distorted hands, misspelled Chinese text, cramped layout, cluttered background.
```

## Execution guidance

- Use the `imagegen` skill / Pi `codex_generate_image` tool for actual generation.
- In the prompt, explicitly name the provided sticker sheet as the **primary reference image**.
- If the user requests both characters, make separate image generation calls for female lead and male lead unless they request a couple sticker.
- If Chinese text accuracy matters, remind the user that generated text may need iteration; validate labels visually after generation and regenerate with targeted corrections if needed.
- For transparent single stickers, follow the imagegen chroma-key/transparent-output workflow; do not silently switch to CLI fallback.
- Report the final saved path(s), character(s), output type, and the final prompt(s) used.

## Background removal post-processing (ImageMagick)

When the generated sticker sheet has a pastel pink (`#FFF5F7`, `#FDF2F4`, `#FCF7F8`) or similar light-colored solid background that needs to be made transparent, use ImageMagick flood fill from the four corners instead of chroma-key removal (chroma-key struggles with pastel colors close to the white sticker outlines and clothing).

### Core command

```bash
magick input.png -alpha set -fuzz N% -fill none \
  -draw 'color 0,0 floodfill' \
  -draw 'color W,0 floodfill' \
  -draw 'color 0,H floodfill' \
  -draw 'color W,H floodfill' \
  output.png
```

where `W = width - 1` and `H = height - 1`.

### Fuzz threshold guide

Test multiple fuzz values and visually inspect each, then pick the cleanest one:

```bash
for f in 1 2 3 4; do
  magick input.png -alpha set -fuzz ${f}% -fill none \
    -draw 'color 0,0 floodfill' -draw 'color 1253,0 floodfill' \
    -draw 'color 0,1253 floodfill' -draw 'color 1253,1253 floodfill' \
    output-f${f}.png
done
```

Fuzz selection principle: **maximize fuzz without eating into white clothing or white sticker outlines.**

| fuzz    | typical outcome                                              |
| ------- | ------------------------------------------------------------ |
| 0.3%–1% | background remnants left around edges                        |
| **2%**  | cleanest balance for most chibi sticker sheets (Recommended) |
| 3%–4%   | starts biting into white shirts and sticker white areas      |
| >5%     | significantly erodes white clothing, unusable                |

### Common pitfalls

- **White-clothing bleed**: These stickers feature chibi characters with white button-up shirts and thick white outlines, so the pastel background is spectrally very close to subject pixels. Keep fuzz ≤ 2% when in doubt.
- **Shadow edge treatment**: Soft drop shadows around stickers produce a gradient halo. Start at 2%, then fine-tune in 0.2% steps (e.g. 1.2%, 1.5%, 1.8%) if the shadow fringe is too thick. If shadows should remain, accept a slightly lower fuzz.
- **Checkerboard backgrounds**: Some intermediate outputs may show a faux checkerboard pattern (alternating `#F6F6F6` / `#FCFCFC`). Flood fill works on these as long as both checker colors are within the fuzz tolerance of each other — push fuzz up slightly (3–4%) and verify no clothing damage.
