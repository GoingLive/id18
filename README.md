# id18
Cryptographically secure 18-char identifier library

---

## Overview

id18 generates fixed-length, secure identifiers based on a cryptographically secure pseudorandom number generator (CSPRNG).  
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
id = generateid18()
// returns: "3kZt7GfQ8yNcPW5dR2"

-- LiveCode usage
put genid18()                        -- new 18-char id18
put genid18("validate", genid18())   -- true // or use any string as the second parameter to test
put genid18("bulk", 5)               -- CR-delimited 5 lines
put genid18("--version")
put genid18("--help")
