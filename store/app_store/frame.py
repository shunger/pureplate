"""Frames app screenshots in a drawn device bezel under a short caption.

usage: frame.py ipad|iphone|duo OUT_DIR SHOT.png "Caption" [SHOT.png "Caption" ...]
"""
import sys
from PIL import Image, ImageDraw, ImageFont, ImageFilter

SIZES = {"ipad": (2064, 2752), "iphone": (1206, 2622), "duo": (1398, 2034)}
BG_TOP = (255, 246, 238)
BG_BOTTOM = (250, 222, 206)
INK = (45, 30, 25)
BEZEL = (24, 24, 27)
FONT = "/System/Library/Fonts/SFNS.ttf"


def font(size, weight):
    f = ImageFont.truetype(FONT, size)
    try:
        # Axes: width, optical size, grade, weight.
        f.set_variation_by_axes([100, 96, 400, weight])
    except Exception:
        pass
    return f


def gradient(w, h):
    bg = Image.new("RGB", (w, h))
    px = ImageDraw.Draw(bg)
    for y in range(h):
        t = y / h
        px.line([(0, y), (w, y)], fill=tuple(int(a + (b - a) * t) for a, b in zip(BG_TOP, BG_BOTTOM)))
    return bg


def wrap(draw, text, f, max_w):
    lines, line = [], ""
    for word in text.split():
        trial = f"{line} {word}".strip()
        if draw.textlength(trial, font=f) <= max_w:
            line = trial
        else:
            lines.append(line)
            line = word
    lines.append(line)
    return lines


def rounded_mask(size, radius):
    m = Image.new("L", size, 0)
    ImageDraw.Draw(m).rounded_rectangle([0, 0, size[0] - 1, size[1] - 1], radius, fill=255)
    return m


def frame(kind, shot_path, caption, out_path):
    W, H = SIZES[kind]
    canvas = gradient(W, H)
    draw = ImageDraw.Draw(canvas)

    # Caption block.
    cap_size = int(W * {"ipad": 0.058, "iphone": 0.082, "duo": 0.062}[kind])
    f = font(cap_size, 700)
    lines = wrap(draw, caption, f, W * 0.84)
    line_h = int(cap_size * 1.18)
    top = int(H * 0.05)
    for i, ln in enumerate(lines):
        tw = draw.textlength(ln, font=f)
        draw.text(((W - tw) / 2, top + i * line_h), ln, font=f, fill=INK)
    caption_bottom = top + len(lines) * line_h

    # Device: screenshot scaled to fit below the caption, bezel around it.
    shot = Image.open(shot_path).convert("RGB")
    bezel = int(W * {"ipad": 0.022, "iphone": 0.03, "duo": 0.026}[kind])
    avail_h = H - caption_bottom - int(H * 0.04) - int(H * 0.035)
    avail_w = int(W * {"ipad": 0.86, "iphone": 0.80, "duo": 0.82}[kind])
    scale = min((avail_w - 2 * bezel) / shot.width, (avail_h - 2 * bezel) / shot.height)
    sw, sh = int(shot.width * scale), int(shot.height * scale)
    shot = shot.resize((sw, sh), Image.LANCZOS)
    dw, dh = sw + 2 * bezel, sh + 2 * bezel
    dx, dy = (W - dw) // 2, caption_bottom + int(H * 0.04)

    screen_r = int(sw * {"ipad": 0.035, "iphone": 0.12, "duo": 0.07}[kind])
    device_r = screen_r + bezel

    # Soft shadow.
    shadow = Image.new("L", (W, H), 0)
    ImageDraw.Draw(shadow).rounded_rectangle(
        [dx, dy + int(bezel * 0.8), dx + dw, dy + dh + int(bezel * 0.8)], device_r, fill=110)
    shadow = shadow.filter(ImageFilter.GaussianBlur(bezel * 1.4))
    canvas.paste(Image.new("RGB", (W, H), (120, 70, 50)), (0, 0), shadow)

    draw = ImageDraw.Draw(canvas)
    draw.rounded_rectangle([dx, dy, dx + dw, dy + dh], device_r, fill=BEZEL)
    # Thin edge highlight, like a metal band.
    draw.rounded_rectangle([dx, dy, dx + dw, dy + dh], device_r, outline=(70, 70, 76),
                           width=max(2, bezel // 8))
    canvas.paste(shot, (dx + bezel, dy + bezel), rounded_mask((sw, sh), screen_r))

    if kind == "iphone":
        # Dynamic Island.
        iw, ih = int(sw * 0.30), int(sw * 0.088)
        ix, iy = dx + bezel + (sw - iw) // 2, dy + bezel + int(sw * 0.03)
        draw.rounded_rectangle([ix, iy, ix + iw, iy + ih], ih // 2, fill=(0, 0, 0))

    canvas.save(out_path, "PNG")


if __name__ == "__main__":
    kind, out_dir, rest = sys.argv[1], sys.argv[2], sys.argv[3:]
    for n, i in enumerate(range(0, len(rest), 2), start=1):
        out = f"{out_dir}/{kind}_{n:02d}.png"
        frame(kind, rest[i], rest[i + 1], out)
        print(out)
