"""Header and search-results assets: three framed iPhones, optional caption.

usage: banners.py OUT_DIR LEFT.png CENTER.png RIGHT.png
"""
import sys
from PIL import Image, ImageDraw, ImageFilter
from frame import BEZEL, INK, font, gradient, rounded_mask, wrap

CAPTION = "Dinner ideas from what's already in your pantry"


def phone(shot_path, height):
    """A framed iPhone, as RGBA, `height` pixels tall."""
    shot = Image.open(shot_path).convert("RGB")
    bezel = int(height * 0.014)
    sh = height - 2 * bezel
    sw = int(shot.width * sh / shot.height)
    shot = shot.resize((sw, sh), Image.LANCZOS)
    w = sw + 2 * bezel
    screen_r = int(sw * 0.12)
    out = Image.new("RGBA", (w, height), (0, 0, 0, 0))
    d = ImageDraw.Draw(out)
    d.rounded_rectangle([0, 0, w - 1, height - 1], screen_r + bezel, fill=BEZEL + (255,),
                        outline=(70, 70, 76, 255), width=max(2, bezel // 8))
    out.paste(shot, (bezel, bezel), rounded_mask((sw, sh), screen_r))
    iw, ih = int(sw * 0.30), int(sw * 0.088)
    ix, iy = bezel + (sw - iw) // 2, bezel + int(sw * 0.03)
    d.rounded_rectangle([ix, iy, ix + iw, iy + ih], ih // 2, fill=(0, 0, 0, 255))
    return out


def place(canvas, img, x, y, angle=0):
    """Pastes `img` centred on x with its top at y, with a soft shadow."""
    if angle:
        img = img.rotate(angle, resample=Image.BICUBIC, expand=True)
    W, H = canvas.size
    blur = int(img.height * 0.025)
    shadow = Image.new("L", (W, H), 0)
    alpha = img.split()[3].point(lambda a: int(a * 0.45))
    shadow.paste(alpha, (int(x - img.width / 2), int(y + blur * 0.8)))
    shadow = shadow.filter(ImageFilter.GaussianBlur(blur))
    canvas.paste(Image.new("RGB", (W, H), (120, 70, 50)), (0, 0), shadow)
    canvas.paste(img, (int(x - img.width / 2), int(y)), img)


def build(size, shots, caption, out_path):
    W, H = size
    canvas = gradient(W, H)
    top = int(H * 0.08)
    if caption:
        draw = ImageDraw.Draw(canvas)
        cap = int(W * 0.048)
        f = font(cap, 700)
        lines = wrap(draw, caption, f, W * 0.80)
        for i, ln in enumerate(lines):
            tw = draw.textlength(ln, font=f)
            draw.text(((W - tw) / 2, top + i * cap * 1.18), ln, font=f, fill=INK)
        top += int(len(lines) * cap * 1.18 + H * 0.05)

    # Phones run off the bottom edge; the centre one is the focal point.
    center_h = int((H - top) * 1.15)
    side_h = int(center_h * 0.86)
    left, center, right = shots
    gap = phone(center, center_h).width * 0.78
    place(canvas, phone(left, side_h), W / 2 - gap, top + center_h * 0.10, angle=4)
    place(canvas, phone(right, side_h), W / 2 + gap, top + center_h * 0.10, angle=-4)
    place(canvas, phone(center, center_h), W / 2, top)
    canvas.convert("RGB").save(out_path, "PNG")
    print(out_path)


if __name__ == "__main__":
    out_dir, shots = sys.argv[1], sys.argv[2:5]
    build((3840, 1646), shots, None, f"{out_dir}/header_3840x1646.png")
    build((3840, 2560), shots, CAPTION, f"{out_dir}/search_3840x2560.png")
    build((5244, 2950), shots, CAPTION, f"{out_dir}/universal_5244x2950.png")
