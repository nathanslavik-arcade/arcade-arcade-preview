#!/bin/sh
# Rebuilds the preview site from the source repos next to it.
#   ./build.sh <leaderboard-api-url>
set -e
API="$1"
[ -n "$API" ] || { echo "usage: ./build.sh <leaderboard-api-url>"; exit 1; }
cd "$(dirname "$0")"
for d in arcade-arcade guardrail-blocker rogue-agent shadow-agents; do
  mkdir -p "$d"
  sed "s|const LEADERBOARD_API = \"http://127.0.0.1:8787\";|const LEADERBOARD_API = \"$API\";|" "../$d/index.html" > "$d/index.html"
  grep -q "const LEADERBOARD_API = \"$API\";" "$d/index.html" || { echo "$d: API not set"; exit 1; }
done
echo "built with $API"
