# SLID = Secure Lightweight Identifier
# Cryptographically secure 18-char generator (base62)

import secrets

_ALPHABET = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
_LENGTH = 18

def generate_slid():
    return ''.join(secrets.choice(_ALPHABET) for _ in range(_LENGTH))
