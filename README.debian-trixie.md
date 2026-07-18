# RefPerSys-in-C on Debian Trixie (13) - Installation Guide

This document describes how to compile and install **RefPerSys-in-C** on **Debian GNU/Linux 13 (Trixie)**.

---

## Prerequisites

RefPerSys-in-C requires the following development libraries:

| Library | Debian Package (dev) | Purpose |
|---------|----------------------|---------|
| libcurl | `libcurl4-openssl-dev` | HTTP client library |
| jansson | `libjansson-dev` | JSON C library |
| GTK+ 3.0 | `libgtk-3-dev` | Graphical interface library |
| libunistring | `libunistring-dev` | Unicode string library |
| libbacktrace | `libbacktrace-dev` | Symbolic backtracing |
| pkg-config | `pkg-config` | Build configuration helper |
| indent | `indent` | C code formatter |
| build-essential | `build-essential` | GCC, make, and other build tools |

---

## Installation Steps

### 1. Install Dependencies

Run the following command as root or with sudo:

```bash
sudo apt update
sudo apt install -y build-essential pkg-config \
    libcurl4-openssl-dev libjansson-dev libgtk-3-dev \
    libunistring-dev libbacktrace-dev indent
```

### 2. Clone the Repository (if not already done)

```bash
cd /path/to/your/workspace
git clone git@github.com:jack-sparrow-code/refpersys-in-c.git
cd refpersys-in-c
```

### 3. Required Fixes for Debian Trixie

Before compiling, apply the following fixes to address type incompatibilities detected with GCC 13 on Debian Trixie:

#### Fix 1: Iterator Type Mismatch in `src/composite_rps.c`
Two iterator functions were using the wrong type (`rpsmusetob` instead of `strdicnodrps`):

```bash
# Line 1031 and 1084: Replace kavl_itr_next_rpsmusetob with kavl_itr_next_strdicnodrps
sed -i '1031s/kavl_itr_next_rpsmusetob/kavl_itr_next_strdicnodrps/' src/composite_rps.c
sed -i '1084s/kavl_itr_next_rpsmusetob/kavl_itr_next_strdicnodrps/' src/composite_rps.c
```

**Explanation**: The iterator was initialized with `kavl_itr_first_strdicnodrps` but iterated using `kavl_itr_next_rpsmusetob`, causing a type mismatch error.

#### Fix 2: Missing Type Cast in `src/object_rps.c`
A return statement was missing a required type cast:

```bash
# Line 994: Add (RpsValue_t) cast
sed -i '994s/return obdump;/return (RpsValue_t) obdump;/' src/object_rps.c
```

**Explanation**: The function expected to return a `RpsValue_t` (unsigned long) but was returning a `RpsObject_t*` pointer without a cast.

#### Fix 3: Create Required Directory
The build script `tools/generate-timestamp.sh` requires a temporary directory:

```bash
mkdir -p ~/tmp
```

### 4. Compile RefPerSys

From the repository root directory:

```bash
make clean all
```

This will:
1. Compile all source files in `src/`
2. Generate the timestamp file in `generated/`
3. Link all objects into the `refpersys` executable

---

## Verification

### Check the Executable

```bash
ls -lh refpersys
# Should show: -rwxr-xr-x 1 user group ~2.0M refpersys
```

### Run Version Information

```bash
./refpersys --version
```

Expected output (example):
```
./refpersys - a Reflexive Persistent System - see refpersys.org
... is an open source symbolic artificial intelligence project.
	 email contact: <team@refpersys.org>
	 build timestamp: Sat 18 Jul 2026 12:35:24 PM CEST (1784370924)
	 top directory: /home/jean-christophe/Documents/codes/refpersys-in-c
	 short git id: b7377fe70b38902e+
	 full git id: b7377fe70b38902e435512c1180327ed59a73ea1+
	 last git tag: heads/main
	 last git commit: b7377fe70b38 Add OS check helper routines to install.sh
	 git remote origin URL: git@github.com:jack-sparrow-code/refpersys-in-c.git
```

### Show Help

```bash
./refpersys --help
```

---

## Running Tests

To run the dump test (creates a dump in `/tmp/rpsdump`):

```bash
make testdump
```

Or manually:
```bash
./refpersys --shell-before-load='rm -rf /tmp/rpsdump' --debug-load=GARBCOLL --debug-after=DUMP --dump=/tmp/rpsdump
```

---

## Cleaning Up

To remove all compiled files and the executable:

```bash
make clean
```

---

## Troubleshooting

### Error: "cp: cannot create regular file '/home/.../tmp/refpersys.tar.gz'"
**Solution**: Create the `~/tmp` directory as shown in Fix 3 above.

### Error: "kavl_itr_next_rpsmusetob: passing argument from incompatible pointer type"
**Solution**: Apply Fix 1 to correct the iterator type.

### Error: "returning 'RpsObject_t*' from a function with return type 'RpsValue_t'"
**Solution**: Apply Fix 2 to add the missing type cast.

### pkg-config: command not found
**Solution**: Ensure `pkg-config` is installed (part of the dependencies in step 1).

### Missing headers (jansson.h, gtk/gtk.h, etc.)
**Solution**: Verify all `-dev` packages from step 1 are installed.

---

## Notes

- Tested on **Debian GNU/Linux 13 (Trixie)** with GCC 13.2.0
- The fixes are specific to the current state of the repository (commit b7377fe)
- These fixes address warnings treated as errors by newer versions of GCC
- The `install.sh` script has OS version checks but requires sudo privileges

---

## Original README

See the main [README.md](./README.md) for general project information.
