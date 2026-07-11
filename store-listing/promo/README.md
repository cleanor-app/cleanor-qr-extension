# Promo video

- `cleanor-qr-promo.mp4` — 1920×1080, ~30s, H.264/AAC. Intro + 5 feature scenes + CTA outro,
  STATIC scenes with crossfades (no zoom → no text jitter), ElevenLabs (George) voiceover.
- `voiceover.mp3` — narration, ElevenLabs voice `JBFqnCBsd6RMkjVDRZzb` ("George"),
  model `eleven_multilingual_v2`. `script.txt` — the text.

Feature scenes are the 5 store screenshots (`../png/screenshot-1..5.png`) framed on the brand
blue gradient; intro/outro are generated to match (serif "New York" headline, white QR card).

## Rebuild
1. Voiceover: ElevenLabs TTS, George voice. Key from `~/Developer/Job/meta-ua-copilot/.env`
   (`ELEVENLABS_API_KEY`). POST `text-to-speech/JBFqnCBsd6RMkjVDRZzb`, Accept `audio/mpeg`.
2. `bash build-scenes.sh`  → scene-intro / scene-ss1..5 / scene-outro (1920×1080, ImageMagick).
3. `python3 build-video.py` → assembles static scenes + voiceover via ffmpeg (no zoompan = no jitter).
   Durations sum 33.65; after 6×0.6s crossfades → 30.05s ≈ voiceover.
