"""Add a one-line doc comment to every generated jme_* method in
lib/src/jme_bindings.dart (run after `dart run ffigen`). Idempotent."""

from __future__ import annotations

import re
import sys
from pathlib import Path

path = Path(sys.argv[1] if len(sys.argv) > 1 else "lib/src/jme_bindings.dart")
lines = path.read_text().splitlines(keepends=True)
out: list[str] = []
pattern = re.compile(r"^  (?!late |return |final )[A-Za-z0-9_<>.,]+(?:<[^>]*>)? (jme_[A-Za-z0-9_]+)\(")
for line in lines:
    m = pattern.match(line.rstrip("\n"))
    if m and not (out and out[-1].lstrip().startswith("///")):
        out.append(f"  /// Calls the native `{m.group(1)}` entry point.\n")
    out.append(line)
path.write_text("".join(out))
