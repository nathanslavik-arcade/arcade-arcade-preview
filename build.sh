#!/bin/sh
# Builds the site in the same layout as arcade.dev/arcade/: the hub at the top,
# each game in its own folder underneath.
#   ./build.sh <leaderboard-api> [out-dir]
# Analytics are stripped and pages marked noindex unless KEEP_ANALYTICS=1, which is
# only for the copy that goes into the arcade.dev repo (public/arcade/). The team
# preview (this repo) uses the personal workers.dev leaderboard.
set -e
API="$1"; OUT="${2:-.}"
[ -n "$API" ] || { echo "usage: ./build.sh <leaderboard-api> [out-dir]"; exit 1; }
SRC="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$OUT"
page() {  # page <source-folder> <dest-folder>
  mkdir -p "$2"
  python3 - "$SRC/$1/index.html" "$2/index.html" "$API" "${KEEP_ANALYTICS:-0}" <<'PY'
import re, sys
src, dst, api, keep = sys.argv[1:]
h = open(src).read()
h = h.replace('const LEADERBOARD_API = "/api/arcade-leaderboard";', f'const LEADERBOARD_API = "{api}";')
assert f'const LEADERBOARD_API = "{api}";' in h, src
if keep != "1":
    h = re.sub(r'<!-- analytics:.*?<!-- /analytics -->\n', '<meta name="robots" content="noindex">\n', h, flags=re.S)
    assert "GTM-" not in h, src
open(dst, "w").write(h)
PY
}
page arcade-arcade "$OUT"
cp -R "$SRC/arcade-arcade/fonts" "$SRC/arcade-arcade/share.jpg" "$OUT/"
for g in guardrail-blocker rogue-agent shadow-agents; do page "$g" "$OUT/$g"; done
echo "built $OUT with $API"
