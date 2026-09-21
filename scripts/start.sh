#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PORT="${PORT:-8080}"
URL="http://localhost:${PORT}"
PID_FILE="${ROOT}/.preview.pid"
LOG_FILE="${ROOT}/.preview.log"

cd "$ROOT"

if [[ -f "$PID_FILE" ]]; then
  OLD_PID="$(cat "$PID_FILE")"
  if kill -0 "$OLD_PID" 2>/dev/null; then
    echo "Preview already running (pid ${OLD_PID}) at ${URL}"
    echo "Stop it with: ./scripts/stop.sh"
    exit 0
  fi
  rm -f "$PID_FILE"
fi

python3 -m http.server "$PORT" >"$LOG_FILE" 2>&1 &
echo $! >"$PID_FILE"

echo "Serving blog from: ${ROOT}"
echo "Open in your browser: ${URL}"
echo "Stop with: ./scripts/stop.sh"
