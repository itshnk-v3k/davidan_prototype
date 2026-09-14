#!/usr/bin/env bash
#
# Downloads the images listed in tools/image_manifest.txt, downsizes them and
# converts them to WebP under assets/images/<kind>/<slug>.webp.
#
# Rerunnable: an entry is skipped when its output exists and
# tools/image_sources.lock records the same source URL and settings.
# Raw downloads are cached in tools/.raw_downloads/ (gitignored).
#
# Usage:    tools/fetch_and_optimize_images.sh [--force]
# Requires: curl, cwebp (brew install webp), sips (built into macOS)

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MANIFEST="$ROOT/tools/image_manifest.txt"
LOCK="$ROOT/tools/image_sources.lock"
RAW_DIR="$ROOT/tools/.raw_downloads"
ASSETS_DIR="$ROOT/assets/images"

force=0
[[ "${1:-}" == "--force" ]] && force=1

for tool in curl cwebp sips; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "error: '$tool' not found." >&2
    [[ "$tool" == "cwebp" ]] && echo "Install it with: brew install webp" >&2
    exit 1
  fi
done

# "<max width px> <webp quality>" per kind. Images narrower than the max are
# never upscaled.
settings_for() {
  case "$1" in
    products) echo "800 80" ;;
    banners) echo "900 80" ;;
    brand) echo "600 90" ;;
    *) return 1 ;;
  esac
}

mkdir -p "$RAW_DIR"
new_lock="$(mktemp)"
trap 'rm -f "$new_lock"' EXIT

converted=0
skipped=0
failed=0
expected=""

while read -r kind slug url <&3 || [[ -n "${kind:-}" ]]; do
  [[ -z "${kind:-}" || "$kind" == \#* ]] && continue

  if ! settings="$(settings_for "$kind")"; then
    echo "  ✗ $slug: unknown kind '$kind'" >&2
    failed=$((failed + 1))
    continue
  fi
  read -r max_width quality <<<"$settings"

  rel_out="$kind/$slug.webp"
  out="$ASSETS_DIR/$rel_out"
  lock_line="$rel_out"$'\t'"$url"$'\t'"w=$max_width q=$quality"
  expected+="$rel_out"$'\n'

  if [[ $force -eq 0 && -f "$out" ]] && grep -Fqx -- "$lock_line" "$LOCK" 2>/dev/null; then
    echo "$lock_line" >>"$new_lock"
    skipped=$((skipped + 1))
    continue
  fi

  # Raw cache is keyed by URL, so a changed URL downloads again.
  ext="${url##*.}"
  raw="$RAW_DIR/$(printf '%s' "$url" | shasum -a 1 | cut -c1-16).$ext"
  if [[ ! -s "$raw" ]]; then
    if ! curl -fsSL --retry 2 -o "$raw.part" "$url"; then
      rm -f "$raw.part"
      echo "  ✗ $slug: download failed ($url)" >&2
      failed=$((failed + 1))
      continue
    fi
    mv "$raw.part" "$raw"
  fi

  width="$(sips -g pixelWidth "$raw" 2>/dev/null | awk '/pixelWidth/ { print $2 }')"
  resize=()
  if [[ -n "$width" && "$width" -gt "$max_width" ]]; then
    resize=(-resize "$max_width" 0)
  fi

  mkdir -p "$(dirname "$out")"
  if ! cwebp -quiet -mt -m 6 -sharp_yuv -metadata none -q "$quality" -alpha_q 100 \
    ${resize[@]+"${resize[@]}"} "$raw" -o "$out.part"; then
    rm -f "$out.part"
    echo "  ✗ $slug: cwebp failed" >&2
    failed=$((failed + 1))
    continue
  fi
  mv "$out.part" "$out"

  echo "$lock_line" >>"$new_lock"
  converted=$((converted + 1))
  echo "  ✓ $rel_out  (${width:-?}px wide source, $(($(stat -f %z "$out") / 1024)) KB)"
done 3<"$MANIFEST"

sort "$new_lock" >"$LOCK"

# Outputs no longer in the manifest are reported, never deleted automatically.
for file in "$ASSETS_DIR"/*/*.webp; do
  [[ -e "$file" ]] || continue
  rel="${file#"$ASSETS_DIR"/}"
  if ! grep -Fqx -- "$rel" <<<"$expected"; then
    echo "  ! $rel is not in the manifest (delete it if unused)"
  fi
done

echo
echo "converted: $converted, skipped: $skipped, failed: $failed"
echo "total size of assets/images: $(du -sh "$ASSETS_DIR" | cut -f1)"

[[ $failed -eq 0 ]]
