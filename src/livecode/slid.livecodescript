script "SLID"

## SLID = Secure Lightweight Identifier
# timestamp: 2025-09-12_15-36-53_CEST

function genSLID
    -- 18-char fixed test value; replace with CSPRNG later
    return "0123456789ABCDEFGH"
end genSLID