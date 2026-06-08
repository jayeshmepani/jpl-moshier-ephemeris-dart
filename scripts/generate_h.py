import re
import os

php_file = "jpl-moshier-ephemeris-php/src/FFI/JmeEphFFI.php"
with open(php_file, "r") as f:
    content = f.read()

# Extract constants
constants = re.findall(r"public const (JME_[A-Z0-9_]+) = (.*?);", content)

# Extract cdef
cdef_match = re.search(r"\$cdef = <<<'CDEF'(.*?)\n\s*CDEF;", content, re.DOTALL)
cdef = cdef_match.group(1) if cdef_match else ""

with open("jpl_moshier_ephemeris_dart/src/include/jme/jme.h", "w") as f:
    f.write("#ifndef JME_H\n")
    f.write("#define JME_H\n\n")
    f.write("#include <stddef.h>\n\n")
    
    for name, value in constants:
        f.write(f"#define {name} {value}\n")
            
    f.write("\n")
    f.write(cdef)
    f.write("\n\n#endif // JME_H\n")

print("Generated jpl_moshier_ephemeris_dart/src/include/jme/jme.h")
