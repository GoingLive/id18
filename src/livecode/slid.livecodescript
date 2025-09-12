script "SLID"

## SLID = Secure Lightweight Identifier
## SLID = Secure Lightweight Identifier
# timestamp: 2025-09-12_16-54-00_CEST

function genSLID
    ## Generate CSPRNG 18-character SLID (base62), unbiased
    # timestamp: 2025-09-12_22-00-00_CEST
    # purpose: Return a secure 18-char alphanumeric ID using randomBytes()
    # notes: Rejection sampling avoids modulo bias

    local tAlphabet
    local tAlphabetLen
    local tTargetLen
    local tID
    local tBytes
    local tVal
    local tMaxAccept
    local tIndex

    put "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz" into tAlphabet
    put the number of chars of tAlphabet into tAlphabetLen   -- 62
    put 18 into tTargetLen
    put (floor(256 / tAlphabetLen) * tAlphabetLen) into tMaxAccept   -- 248

    repeat while the number of chars of tID < tTargetLen
        put randomBytes(1) into tBytes
        put charToNum(char 1 of tBytes) into tVal           -- 0..255
        if tVal < tMaxAccept then                            -- accept only 0..247
            put 1 + (tVal mod tAlphabetLen) into tIndex
            put char tIndex of tAlphabet after tID
        end if
    end repeat

    return tID
end genSLID

/*
close stack "Slid"
put "G:\My Drive\Documents\GitHub\SLID\src\livecode\slid.livecodescript" into tStack
replace backslash with slash in tStack
start using stack tStack
--put there is a stack tStack
put genSLID()

---

close stack "Slid"
put "G:\My Drive\Documents\GitHub\SLID\src\livecode\slid.livecodescript" into tStack
replace backslash with slash in tStack
--start using stack tStack
stop using stack tStack
--put there is a stack tStack
--put genSLID()
*/	