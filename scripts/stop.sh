#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PORT="${PORT:-8080}"
PID_FILE="${ROOT}/.preview.pid"
LOG_FILE="${ROOT}/.preview.log"

cd "$ROOT"

stopped=0

if [[ -f "$PID_FILE" ]]; then
  PID="$(cat "$PID_FILE")"
  if kill -0 "$PID" 2>/dev/null; then
    kill "$PID" 2>/dev/null || true
    # Wait briefly for clean exit
    for _ in 1 2 3 4 5; do
      if ! kill -0 "$PID" 2>/dev/null; then
        break
      fi
      sleep 0.1
    done
    if kill -0 "$PID" 2>/dev/null; then
      kill -9 "$PID" 2>/dev/null || true
    fi
    echo "Stopped preview server (pid ${PID})."
    stopped=1
  else
    echo "Stale pid file found; cleaning up."
  fi
  rm -f "$PID_FILE"
fi

# Fallback: anything still bound to the preview port
if command -v lsof >/dev/null 2>&1; then
  EXTRA_PIDS="$(lsof -tiTCP:"$PORT" -sTCP:LISTEN 2>/dev/null || true)"
  if [[ -n "$EXTRA_PIDS" ]]; then
    echo "$EXTRA_PIDS" | xargs -r kill 2>/dev/null || true
    echo "Stopped process(es) on port ${PORT}."
    stopped=1
  fi
fi

rm -f "$LOG_FILE"

if [[ "$stopped" -eq 0 ]]; then
  echo "No preview server was running."
fi
