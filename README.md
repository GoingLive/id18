# SLID
Cryptographically secure 18-char identifier library

---

## Overview

SLID generates fixed-length, secure identifiers based on a cryptographically secure pseudorandom number generator (CSPRNG).  
It is designed to provide short, unique, and safe IDs for applications that require both compactness and security.

- Length: 18 characters
- Alphabet: alphanumeric (0-9, A-Z, a-z)
- Backed by system-grade CSPRNG

---

## Features

- Generates strong random identifiers
- Fixed 18-character format
- Simple API
- Language-agnostic specification (reference implementation in LiveCode)

---

## Usage

Example (pseudo code):
id = generateSLID()
// returns: "3kZt7GfQ8yNcPW5dR2"

-- LiveCode usage
put genSLID()                        -- new 18-char SLID
put genSLID("validate", genSLID())   -- true // or use any string as the second parameter to test
put genSLID("bulk", 5)               -- CR-delimited 5 lines
put genSLID("--version")
put genSLID("--help")
