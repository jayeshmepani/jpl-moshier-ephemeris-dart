"""Regenerate lib/src/jme_metadata.dart from the bundled src/include/jme/jme.h
(sorted jme_* function names and JME_* constant names)."""

from __future__ import annotations

import re
from pathlib import Path

header = Path("src/include/jme/jme.h").read_text()
functions = sorted(set(re.findall(r"\b(jme_[A-Za-z0-9_]+)\s*\(", header)))
constants = sorted(set(re.findall(r"\b(JME_[A-Z0-9_]+)\b", header)) - {"JME_H"})
out = ["/// Generated metadata for the public JME surface.", "const List<String> jmeSignatureNames = <String>["]
out += [f"  '{n}'," for n in functions]
out += ["];", "", "/// Names of all exported JME constants tracked by the Dart wrapper.", "const List<String> jmeConstantNames = <String>["]
out += [f"  '{n}'," for n in constants]
out += [
    "];",
    "",
    "/// Returns the ordered list of exported native JME function names.",
    "Iterable<String> signatureNames() => jmeSignatureNames;",
    "",
    "/// Returns the ordered list of exported native JME constant names.",
    "Iterable<String> constantNames() => jmeConstantNames;",
    "",
]
Path("lib/src/jme_metadata.dart").write_text("\n".join(out))
print(len(functions), "functions,", len(constants), "constants")
