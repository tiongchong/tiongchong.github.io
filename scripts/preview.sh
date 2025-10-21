#!/usr/bin/env bash
set -euo pipefail

./scripts/sync_repos.sh
rm -rf site .zensical-i18n .cache
zensical-i18n build
echo "Serving multilingual site at http://127.0.0.1:8000 (Ctrl+C to stop)"
python3 -m http.server 8000 --directory site
