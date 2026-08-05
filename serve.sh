#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PORT="${PORT:-8000}"

if [[ ! -f "$ROOT/.env" ]]; then
    echo "Missing .env. Create it with: MAPBOX_TOKEN=pk.xxx" >&2
    exit 1
fi

set -a
source "$ROOT/.env"
set +a

if [[ -z "${MAPBOX_TOKEN:-}" || "$MAPBOX_TOKEN" == __* ]]; then
    echo "MAPBOX_TOKEN is not set in .env" >&2
    exit 1
fi

BUILD_DIR="$(mktemp -d)"
trap 'rm -rf "$BUILD_DIR"' EXIT

cp "$ROOT/index.html" "$BUILD_DIR/index.html"
cp "$ROOT/hospitals_ready.geojson" "$BUILD_DIR/hospitals_ready.geojson"
cp "$ROOT/china_boundary.geojson" "$BUILD_DIR/china_boundary.geojson"

ESCAPED_TOKEN=$(printf '%s\n' "$MAPBOX_TOKEN" | sed -e 's/[\/&]/\\&/g')
sed -i "s/__MAPBOX_TOKEN__/$ESCAPED_TOKEN/g" "$BUILD_DIR/index.html"

if grep -q '__MAPBOX_TOKEN__' "$BUILD_DIR/index.html"; then
    echo "Token placeholder was not replaced." >&2
    exit 1
fi

echo "Serving at http://localhost:$PORT (Ctrl+C to stop)"
cd "$BUILD_DIR"
exec python3 -m http.server "$PORT"
