#!/usr/bin/env bash
# build the slides and serve them at http://localhost:8000, opening a browser once the server is up
set -euo pipefail
cd "$(dirname "$0")"
if command -v open >/dev/null; then (sleep 1 && open http://localhost:8000) & fi
exec python3 slides/build.py --serve
