"""
id18 (Secure Lightweight Identifier) — Python package
"""

import secrets

__version__ = "0.1.3"  # single source of truth (manual bump to match LiveCode)

_ALPHABET = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
_ALPHASET = set(_ALPHABET)
_LENGTH = 18

def generate_id18() -> str:
    return ''.join(secrets.choice(_ALPHABET) for _ in range(_LENGTH))

def validate_id18(s: str) -> bool:
    return isinstance(s, str) and len(s) == _LENGTH and all(ch in _ALPHASET for ch in s)

_HELP_TEXT = (
    "id18 = Secure Lightweight Identifier\n\n"
    "Usage:\n"
    "  get_id18()                      -> new 18-char ID\n"
    "  get_id18('validate', s)         -> True/False\n"
    "  get_id18('-h' | '--help' | '?') -> help text\n"
    "  get_id18('--version')           -> version\n"
)

def get_id18(mode: str | None = None, value: str | None = None):
    """
    Unified entrypoint:
      - get_id18() -> returns new 18-char id18
      - get_id18('validate', s) -> True/False
      - get_id18('-h'|'--help'|'?') -> help text (str)
      - get_id18('--version'|'version'|'-v') -> version (str)
    """
    if isinstance(mode, str):
        m = mode.lower()
        if m == "validate":
            return validate_id18(value)
        if m in ("?", "-h", "--help", "help"):
            return _HELP_TEXT
        if m in ("-v", "--version", "version"):
            return f"id18 {__version__}"
    return generate_id18()

__all__ = ["generate_id18", "validate_id18", "get_id18", "__version__"]
