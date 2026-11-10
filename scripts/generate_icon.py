"""Draw the app's simple plus icon using only the Python standard library."""
import struct
import zlib
from pathlib import Path

SIZE = 1024


def rounded_rectangle(x, y, left, top, right, bottom, radius):
    nearest_x = max(left + radius, min(x, right - radius))
    nearest_y = max(top + radius, min(y, bottom - radius))
    return (x - nearest_x) ** 2 + (y - nearest_y) ** 2 <= radius ** 2


def chunk(kind, data):
    return struct.pack(">I", len(data)) + kind + data + struct.pack(">I", zlib.crc32(kind + data))


rows = bytearray()
for y in range(SIZE):
    rows.append(0)
    background = (30, int(115 - 35 * y / SIZE), int(246 - 20 * y / SIZE))
    for x in range(SIZE):
        is_plus = rounded_rectangle(x, y, 432, 238, 592, 786, 38) or rounded_rectangle(
            x, y, 238, 432, 786, 592, 38
        )
        rows.extend((255, 255, 255) if is_plus else background)

png = b"\x89PNG\r\n\x1a\n"
png += chunk(b"IHDR", struct.pack(">IIBBBBB", SIZE, SIZE, 8, 2, 0, 0, 0))
png += chunk(b"IDAT", zlib.compress(rows, 9))
png += chunk(b"IEND", b"")
destination = Path(__file__).resolve().parents[1] / "TapCounter/Assets.xcassets/AppIcon.appiconset/AppIcon.png"
destination.write_bytes(png)
print(destination)
