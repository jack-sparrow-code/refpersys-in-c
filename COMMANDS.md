# RefPerSys-in-C - Command Reference

This document lists all available commands and options for **RefPerSys-in-C**, the C implementation of the Reflective Persistent System.

---

## Table of Contents

- [Build Commands](#build-commands)
- [Execution Commands](#execution-commands)
- [Runtime Options](#runtime-options)
- [Debug Flags](#debug-flags)
- [Test Commands](#test-commands)
- [Examples](#examples)

---

## Build Commands

### Basic Compilation

| Command | Description |
|---------|-------------|
| `make` | Compile the project (default target: `all`) |
| `make all` | Compile and link the `refpersys` executable |
| `make clean` | Remove all object files and the executable |
| `make objects` | Compile source files to object files only |

### Maintenance Commands

| Command | Description |
|---------|-------------|
| `make indent` | Reformat all C source files using `indent` |
| `make tarball` | Create a tarball archive in `/tmp/refpersys-in-c.tar.gz` |

### Test Build Commands

| Command | Description |
|---------|-------------|
| `make testdump` | Run dump test (creates dump in `/tmp/rpsdump`) |

---

## Execution Commands

### Main Executable

```
refpersys [OPTION...]
```

The main RefPerSys executable with various runtime options.

---

## Runtime Options

### Application Options

| Option | Description | Example |
|--------|-------------|---------|
| `-h, --help` | Show help options | `refpersys --help` |
| `--help-all` | Show all help options including GTK+ | `refpersys --help-all` |
| `--help-gtk` | Show GTK+ specific options | `refpersys --help-gtk` |
| `-L, --load-directory=DIR` | Load persistent heap from directory DIR | `refpersys -L /path/to/heap` |
| `-B, --batch` | Run in batch mode, without user interface | `refpersys --batch` |
| `--version` | Show version information and default options | `refpersys --version` |
| `--show-types` | Show type information and more (some random oids) | `refpersys --show-types` |
| `-D, --dump=DIR` | Dump heap into directory DIR | `refpersys --dump=/tmp/mydump` |
| `-T, --nb-threads=NBTHREADS` | Set number of agenda threads | `refpersys --nb-threads=4` |
| `-s, --shell-before-load=SHCMD` | Run shell command SHCMD before load | `refpersys -s 'rm -rf /tmp/dump'` |
| `--debug-load=DBGFLAGS` | Set debugging flags for loading | `refpersys --debug-load=GARBCOLL` |
| `--debug-after=DBGFLAGS` | Set debugging flags after loading | `refpersys --debug-after=DUMP` |

---

## Debug Flags

Debug flags control the verbosity and behavior of RefPerSys during execution.

### Available Debug Flags

| Flag | Description | Effect |
|------|-------------|--------|
| `GARBCOLL` | Garbage collection debugging | Enables GC-related debug output |
| `DUMP` | Dump debugging | Enables dump-related debug output |
| `LOAD` | Load debugging | Shows detailed loading information |
| `OBJECT` | Object debugging | Shows object creation/destruction |
| `ALL` | All debug flags | Maximum verbosity |

### Debug Flag Usage

Debug flags can be combined and are set at different stages:

```bash
# Set debug flags before loading
refpersys --debug-load=GARBCOLL

# Set debug flags after loading
refpersys --debug-after=DUMP

# Combine multiple flags
refpersys --debug-load=GARBCOLL,OBJECT --debug-after=DUMP,LOAD
```

---

## Test Commands

### Standard Test

```bash
# Basic dump test
make testdump

# This runs:
./refpersys --shell-before-load='rm -rf /tmp/rpsdump' \
           --debug-load=GARBCOLL \
           --debug-after=DUMP \
           --dump=/tmp/rpsdump
```

### Custom Test

```bash
# Dump to a custom directory
./refpersys --dump=/my/custom/dump/dir

# Load from a specific directory
./refpersys -L /path/to/persistent/heap

# Batch mode with loading
./refpersys --batch -L /path/to/heap --show-types

# Full debug mode
./refpersys --debug-load=ALL --debug-after=ALL
```

---

## Examples

### Example 1: Basic Compilation and Test

```bash
# Clean previous build
make clean

# Compile everything
make all

# Run the dump test
make testdump

# Check the dump output
ls -la /tmp/rpsdump/
```

### Example 2: Load and Dump with Debug

```bash
# Load from the default directory with debug
./refpersys --debug-load=GARBCOLL,LOAD \
           --debug-after=DUMP \
           --dump=/tmp/my_refpersys_dump

# Check what was dumped
ls -la /tmp/my_refpersys_dump/
```

### Example 3: Batch Mode (No GUI)

```bash
# Run without GTK interface
./refpersys --batch --show-types

# With custom thread count
./refpersys --batch --nb-threads=2 --show-types
```

### Example 4: Version Information

```bash
# Show version and build info
./refpersys --version

# Sample output:
# ./refpersys - a Reflexive Persistent System
# build timestamp: Sat 18 Jul 2026 12:35:24 PM CEST
# short git id: b7377fe70b38902e+
# full git id: b7377fe70b38902e435512c1180327ed59a73ea1+
# last git tag: heads/main
# last git commit: b7377fe70b38 Add OS check helper routines
```

### Example 5: Clean Build from Scratch

```bash
# Remove everything
make clean

# Remove git ignore files too
git clean -fd

# Recompile from scratch
make all
```

### Example 6: Code Formatting

```bash
# Reformat all source files
make indent

# Or manually
indent src/*.c
indent Refpersys.h
```

---

## Environment Variables

| Variable | Purpose | Default |
|----------|---------|---------|
| `CC` | C compiler to use | `gcc` |
| `CFLAGS` | Compiler flags | `-O0 -ggdb3` |
| `CPPFLAGS` | Preprocessor flags | Includes from pkg-config |
| `LDFLAGS` | Linker flags | `-rdynamic -pie -Bdynamic -pthread` |

### Custom Compilation

```bash
# Compile with AddressSanitizer
make clean
CXTRAFLAGS=-fsanitize=address make all

# Compile with optimization
CXTRAFLAGS=-O2 make all

# Compile with custom compiler
CC=clang make all
```

---

## Persistent Heap Management

RefPerSys uses a **persistent heap** stored in the `persistore/` directory.

### Structure

```
persistore/
├── sp_XXXXXXXXXXXXXXXX-rps.json    # Space data files
├── sp_XXXXXXXXXXXXXXXX-rps.meta    # Metadata files
└── ...
```

### Commands

```bash
# Load from a specific persistore directory
./refpersys -L /custom/persistore/path

# Dump to a new location
./refpersys --dump=/new/persistore/path

# Clean the current persistore
rm -rf persistore/
```

---

## Performance Options

| Option | Description | Use Case |
|--------|-------------|----------|
| `--nb-threads=N` | Number of agenda threads | Parallel processing |
| `-O2` (via CXTRAFLAGS) | Optimization level | Faster execution |
| `-fsanitize=address` | Memory error detection | Debugging |

---

## Common Patterns

### Pattern 1: Development Cycle

```bash
# Edit source files
$EDITOR src/some_file_rps.c

# Recompile
make clean all

# Test
make testdump

# Check for issues
./refpersys --debug-load=ALL --debug-after=DUMP
```

### Pattern 2: Debugging a Specific Issue

```bash
# Clean build with debug symbols
make clean
CXTRAFLAGS=-fsanitize=address make all

# Run with maximum debug
./refpersys --debug-load=GARBCOLL,OBJECT,LOAD \
           --debug-after=DUMP,OBJECT \
           -L persistore/ \
           --dump=/tmp/debug_dump
```

### Pattern 3: Batch Processing

```bash
# Run without GUI, load and dump
./refpersys --batch \
           -L /input/persistore \
           --dump=/output/persistore \
           --nb-threads=4
```

---

## Troubleshooting Commands

### Check Dependencies

```bash
# Verify pkg-config can find libraries
pkg-config --cflags --libs libcurl jansson gtk+-3.0

# Check installed development packages
dpkg -l | grep -E "libcurl|jansson|gtk-3|unistring|backtrace"
```

### Verify Build Environment

```bash
# Check GCC version
gcc --version

# Check make version
make --version

# Check pkg-config version
pkg-config --version
```

### Clean Problematic Files

```bash
# Remove all build artifacts
make clean

# Remove generated files
rm -rf generated/

# Remove backup files
rm -f *~ refpersys~
```

---

## File Locations

| File/Directory | Purpose |
|----------------|---------|
| `src/` | C source files (e.g., `main_rps.c`, `object_rps.c`) |
| `include/` | Header files (e.g., `Refpersys.h`, `kavl.h`) |
| `persistore/` | Default persistent heap storage |
| `generated/` | Generated files (e.g., `__timestamp.c`) |
| `tools/` | Build helper scripts |
| `refpersys` | Compiled executable |
| `/tmp/rpsdump/` | Default dump test directory |

---

## Makefile Targets Summary

| Target | Dependencies | Action |
|--------|--------------|--------|
| `all` | `refpersys` | Main build target |
| `clean` | - | Remove build artifacts |
| `objects` | `$(RPS_C_OBJECTS)` | Compile objects only |
| `refpersys` | `objects $(RPS_TSTAMP).o` | Link executable |
| `indent` | - | Format source code |
| `tarball` | - | Create source tarball |
| `testdump` | `refpersys` | Run dump test |

---

## MySQL/MariaDB Plugin (db-explore)

RefPerSys can be extended with the **db-explore** Python plugin for MySQL/MariaDB database integration.

### Installation

```bash
# Clone the plugin into the plugins directory
mkdir -p plugins
cd plugins
git clone https://github.com/jack-sparrow-code/db-explore.git
cd db-explore

# Install Python dependencies
pip install --break-system-packages mysql-connector-python

# Or using apt (Debian/Ubuntu)
sudo apt install -y python3-mysql.connector
```

### Configuration

Edit `plugins/db-explore/config.py` to set your MySQL/MariaDB connection details:

```python
DB_CONFIG = {
    "host": "localhost",
    "user": "your_mysql_user",      # Change this
    "password": "your_mysql_password",  # Change this
    "database": "refpersys_db"      # Database name
}
```

### Using the Shell Wrapper

A convenient wrapper script is available at `tools/db-explore.sh`:

```bash
# Create the database and users table
./tools/db-explore.sh create

# Insert a user
./tools/db-explore.sh insert "Alice" 30

# Update a user's age
./tools/db-explore.sh update "Alice" 31

# List all users
./tools/db-explore.sh query

# Launch interactive menu
./tools/db-explore.sh menu
```

### Using Python Directly

You can also use the plugin modules directly:

```bash
# Create database
python3 plugins/db-explore/create_database.py

# Insert data
python3 plugins/db-explore/insert_data.py "Bob" 25

# Query data
python3 plugins/db-explore/query_data.py

# Update data
python3 plugins/db-explore/update_data.py "Bob" 26
```

### Python Module Functions

| File | Function | Description |
|------|----------|-------------|
| `create_database.py` | `create_database()` | Creates database and users table |
| `insert_data.py` | `insert_data(nom, age)` | Inserts a new user |
| `update_data.py` | `update_data(nom, new_age)` | Updates a user's age |
| `query_data.py` | `query_data()` | Lists all users |
| `main.py` | `main()` | Interactive menu |

### Plugin Structure

```
plugins/db-explore/
├── main.py              # Interactive menu
├── config.py            # Database configuration
├── create_database.py   # Create DB and table
├── insert_data.py       # Insert users
├── update_data.py       # Update users
├── query_data.py        # Query users
├── requirement.txt       # Python dependencies
└── README.md            # Plugin documentation
```

### Notes

- Requires **MySQL 8.0+** or **MariaDB 10.5+**
- Requires **Python 3.8+**
- The plugin is **independent** of RefPerSys C code
- Data is stored in **MySQL**, not in RefPerSys persistent heap
- For production use, consider using environment variables for credentials

---

## See Also

- [README.md](./README.md) - General project information
- [README.debian-trixie.md](./README.debian-trixie.md) - Debian Trixie installation guide
- [RefPerSys Website](http://refpersys.org/) - Official project website
