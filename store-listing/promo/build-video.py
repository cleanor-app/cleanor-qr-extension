#!/usr/bin/env python3
import subprocess, sys
SC = "/private/tmp/claude-501/-Users-igorshenshin-Developer-Web-cleanor-image-extension/89bc08c0-5659-4da9-8bf6-20c2f35fb115/scratchpad/promo"
FPS = 30
T = 0.6  # crossfade seconds — smooth dissolve, no motion → no jitter
# static scenes; durations sum 33.65; after 6 xfades → 30.05s ≈ voiceover
scenes = [
    ("scene-intro.png", 5.0),
    ("scene-ss1.png", 4.5),
    ("scene-ss2.png", 4.5),
    ("scene-ss3.png", 5.0),
    ("scene-ss4.png", 5.0),
    ("scene-ss5.png", 4.0),
    ("scene-outro.png", 5.65),
]
inputs = []
for img, d in scenes:
    inputs += ["-loop", "1", "-t", f"{d}", "-i", f"{SC}/{img}"]
inputs += ["-i", f"{SC}/voiceover.mp3"]
n = len(scenes)
fc = []
for i, (img, d) in enumerate(scenes):
    fc.append(f"[{i}:v]scale=1920:1080,setsar=1,fps={FPS},format=yuv420p[v{i}]")
prev = "v0"; run = scenes[0][1]
for i in range(1, n):
    off = run - T; out = f"x{i}"
    fc.append(f"[{prev}][v{i}]xfade=transition=fade:duration={T}:offset={off:.3f}[{out}]")
    prev = out; run = run + scenes[i][1] - T
total = run
fc.append(f"[{prev}]fade=t=in:st=0:d=0.4,fade=t=out:st={total-0.5:.3f}:d=0.5[vout]")
fc.append(f"[{n}:a]loudnorm=I=-16:TP=-1.5:LRA=11,afade=t=out:st={total-0.6:.3f}:d=0.6[aout]")
cmd = ["ffmpeg","-y",*inputs,"-filter_complex",";".join(fc),
       "-map","[vout]","-map","[aout]",
       "-c:v","libx264","-profile:v","high","-pix_fmt","yuv420p","-r",str(FPS),
       "-c:a","aac","-b:a","192k","-movflags","+faststart","-t",f"{total:.3f}",
       f"{SC}/cleanor-qr-promo.mp4"]
print("total video:", round(total,2),"s")
r = subprocess.run(cmd, capture_output=True, text=True)
if r.returncode != 0:
    sys.stderr.write(r.stderr[-2000:]); sys.exit(1)
print("OK")
