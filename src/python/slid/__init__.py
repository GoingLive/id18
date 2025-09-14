"""
SLID (Secure Lightweight Identifier) — Python package
"""

import secrets

__version__ = "0.1.3"  # single source of truth (manual bump to match LiveCode)

_ALPHABET = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
_ALPHASET = set(_ALPHABET)
_LENGTH = 18

def generate_slid() -> str:
    return ''.join(secrets.choice(_ALPHABET) for _ in range(_LENGTH))

def validate_slid(s: str) -> bool:
    return isinstance(s, str) and len(s) == _LENGTH and all(ch in _ALPHASET for ch in s)

_HELP_TEXT = (
    "SLID = Secure Lightweight Identifier\n\n"
    "Usage:\n"
    "  get_slid()                      -> new 18-char ID\n"
    "  get_slid('validate', s)         -> True/False\n"
    "  get_slid('-h' | '--help' | '?') -> help text\n"
    "  get_slid('--version')           -> version\n"
)

def get_slid(mode: str | None = None, value: str | None = None):
    """
    Unified entrypoint:
      - get_slid() -> returns new 18-char SLID
      - get_slid('validate', s) -> True/False
      - get_slid('-h'|'--help'|'?') -> help text (str)
      - get_slid('--version'|'version'|'-v') -> version (str)
    """
    if isinstance(mode, str):
        m = mode.lower()
        if m == "validate":
            return validate_slid(value)
        if m in ("?", "-h", "--help", "help"):
            return _HELP_TEXT
        if m in ("-v", "--version", "version"):
            return f"SLID {__version__}"
    return generate_slid()

__all__ = ["generate_slid", "validate_slid", "get_slid", "__version__"]
