from __future__ import annotations

import argparse
import re
from pathlib import Path


def native_jme_version(native_header_path: Path | None) -> str | None:
    if native_header_path is None or not native_header_path.exists():
        return None

    content = native_header_path.read_text()
    match = re.search(r'#define\s+JME_VERSION\s+"([^"]+)"', content)
    if match is None:
        return None

    return match.group(1)


def build_header(
    source_path: Path,
    output_path: Path,
    native_header_path: Path | None = None,
) -> None:
    content = source_path.read_text()

    constants = re.findall(r"public const (JME_[A-Z0-9_]+) = (.*?);", content)
    cdef_match = re.search(r"\$cdef = <<<'CDEF'(.*?)\n\s*CDEF;", content, re.DOTALL)
    cdef = cdef_match.group(1) if cdef_match else ""
    version_override = native_jme_version(native_header_path)

    output_path.parent.mkdir(parents=True, exist_ok=True)
    with output_path.open("w") as f:
        f.write("#ifndef JME_H\n")
        f.write("#define JME_H\n\n")
        f.write("#include <stddef.h>\n\n")

        for name, value in constants:
            if name == "JME_VERSION" and version_override is not None:
                value = f'"{version_override}"'
            f.write(f"#define {name} {value}\n")

        f.write("\n")
        f.write(cdef)
        f.write("\n\n#endif // JME_H\n")


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Generate the bundled jme.h header from a wrapper source file.",
    )
    parser.add_argument("source", help="Path to the source file containing constants and CDEF")
    parser.add_argument(
        "--output",
        default="src/include/jme/jme.h",
        help="Output header path",
    )
    parser.add_argument(
        "--native-header",
        default="../../jpl-ephemeris/include/jme/jme.h",
        help="Path to the native jme.h used as the source of truth for JME_VERSION",
    )
    args = parser.parse_args()

    source_path = Path(args.source)
    output_path = Path(args.output)
    native_header_path = Path(args.native_header)
    build_header(source_path, output_path, native_header_path)
    print(f"Generated {output_path}")


if __name__ == "__main__":
    main()
