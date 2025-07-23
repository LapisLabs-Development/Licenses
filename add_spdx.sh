#!/bin/bash
shopt -s globstar nullglob
cd "$(dirname "$0")"
for file in ./**/*LICENSE*.txt; do
  [[ -f "$file" ]] || continue
  if grep -q "SPDX-License-Identifier:" "$file"; then
    echo "[SKIP] $file already has SPDX tag"
    continue
  fi
  license_name=$(head -n 5 "$file" | grep -i -m1 "license" | awk '{print toupper($0)}')
  case "$license_name" in
    *MIT*) spdx="MIT" ;;
    *GPL*3*) spdx="GPL-3.0-only" ;;
    *GPL*2*) spdx="GPL-2.0-only" ;;
    *GPL*) spdx="GPL-1.0-only" ;;
    *APACHE*2*) spdx="Apache-2.0" ;;
    *BSD*3*) spdx="BSD-3-Clause" ;;
    *BSD*) spdx="BSD-2-Clause" ;;
    *MOZILLA*2*) spdx="MPL-2.0" ;;
    *AGPL*) spdx="AGPL-3.0-only" ;;
    *UNLICENSE*) spdx="Unlicense" ;;
    *ISC*) spdx="ISC" ;;
    *ZLIB*) spdx="Zlib" ;;
    *) spdx="NOASSERTION" ;;
  esac
  tmpfile=$(mktemp)
  echo "// SPDX-License-Identifier: $spdx" > "$tmpfile"
  cat "$file" >> "$tmpfile"
  mv "$tmpfile" "$file"
  echo "[OK] $file -> $spdx"
done
