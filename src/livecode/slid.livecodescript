script "SLID"

## SLID = Secure Lightweight Identifier
# timestamp: 2025-09-12_22-53-00_CEST

## Versioning policy (SemVer)
# Pre-1.0 (0.Y.Z):
#   Y (MINOR): bump for any breaking change to public behavior.
#   Z (PATCH): bump for non-breaking features, fixes, docs, perf.
# 1.0+:
#   MAJOR: breaking; MINOR: features; PATCH: fixes.

local sSLID_Version = "0.1.3"
local sBuf
local sPos

function genSLID pCmd , pValue
   switch pCmd
      ---
      case "bulk"
         return generateSLIDList (pValue)
         break
         ---
      case "validate"
         return validateSLID (pValue)
         break
         ---
      case "-v"
      case "--version"
      case "version"
         return merge("SLID [[sSLID_Version]]")
         break
         ---
      case "-h"
      case "--help"
      case "?"
      case "help"
         return SLID_Help()
         break
         ---
      case "--about"
      case "about"
      case "--license"
      case "license"
         return SLID_About()
         break
         ---
      default
         return generateSLID()
   end switch
end genSLID

function generateSLID
   ## Generate CSPRNG 18-character SLID (base62), unbiased
   # timestamp: 2025-09-12_22-53-00_CEST
   # purpose: Return a secure 18-char alphanumeric ID using buffered randomBytes()
   # notes: Rejection sampling avoids modulo bias
   
   local tAlphabet
   local tAlphabetLen
   local tTargetLen
   local tID
   local tVal
   local tMaxAccept
   local tIndex
   
   put "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz" into tAlphabet
   put the number of chars of tAlphabet into tAlphabetLen   -- 62
   put 18 into tTargetLen
   put floor(256 / tAlphabetLen) * tAlphabetLen into tMaxAccept   -- 248
   
   repeat while the number of chars of tID < tTargetLen
      put _SLID_nextByte() into tVal          -- buffered byte
      if tVal < tMaxAccept then               -- accept only 0..247
         put 1 + (tVal mod tAlphabetLen) into tIndex
         put char tIndex of tAlphabet after tID
      end if
   end repeat
   
   return tID
end generateSLID

function _SLID_nextByte
   ## Return one CSPRNG byte (0..255) from a buffered pool
   # timestamp: 2025-09-12_22-53-00_CEST
   # purpose: Reduce overhead vs randomBytes(1) per char
   
   local tLen
   local tVal
   
   put the number of chars of sBuf into tLen
   if sPos >= tLen then
      put sBuf & randomBytes(8192) into sBuf
      put the number of chars of sBuf into tLen
   end if
   
   add 1 to sPos
   put charToNum(char sPos of sBuf) into tVal
   
   if sPos > 16384 then
      delete char 1 to sPos of sBuf
      put 0 into sPos
   end if
   
   return tVal
end _SLID_nextByte

function generateSLIDList pCount
   ## Generate a CR-delimited list of SLIDs (array + combine, faster)
   # usage:
   #   put generateSLIDList(5)
   #   put generateSLIDList(100000)
   # timestamp: 2025-09-12_22-53-00_CEST
   # purpose: Return pCount SLIDs, each on its own line (CR-delimited)
   # notes:
   #   - Avoids costly string appends by collecting in an array
   #   - Uses 'repeat pCount' per your preference
   #   - Yields UI every 1000 items
   
   local tA
   local i
   
   add 0 to pCount
   if pCount is not a number or pCount < 1 then
      return empty
   end if
   if pCount > 100000 then put 100000 into pCount
   
   put 0 into i
   repeat pCount
      add 1 to i
      put generateSLID() into tA[i]
      if (i mod 1000) = 0 then wait 0 with messages
   end repeat
   combine tA by cr and tab
   return tA
end generateSLIDList

function validateSLID pID
   ## Validate SLID: exactly 18 chars, base62 alphabet only
   # usage:
   #   put validateSLID(genSLID())          -- true
   #   put validateSLID("abc-INVALID-123")  -- false
   # timestamp: 2025-09-12_22-53-00_CEST
   # purpose: Return true if pID is a valid SLID, otherwise false
   
   local tAlphabet
   local tLen
   local tChar
   local i
   
   put "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz" into tAlphabet
   
   put the number of chars of pID into tLen
   if tLen <> 18 then
      return false
   end if
   
   repeat with i = 1 to tLen
      put char i of pID into tChar
      if tChar is not among the chars of tAlphabet then
         return false
      end if
   end repeat
   
   return true
end validateSLID

function SLID_About
   ## About / license / credits
   # usage:
   #   put genSLID("--about")
   # timestamp: 2025-09-12_00-00-00_CEST
   # purpose: Provide license/credit info without cluttering --help/--version
   
   local t
   put "SLID = Secure Lightweight Identifier" & cr into t
   put merge("Version: [[sSLID_Version]]") & cr after t
   put "License: MIT (see LICENSE in repo)" & cr after t
   put "Copyright: © 2025 Roland Hüttmann, Switzerland. All rights reserved." & cr after t
   put "Repository: https://github.com/GoingLive/SLID" & cr after t
   return t
end SLID_About

function SLID_Help
   ## Short help text for SLID
   # usage:
   #   put genSLID("--help")
   # timestamp: 2025-09-12_00-00-00_CEST
   # purpose: Show usage synopsis and supported commands
   
   local t, q
   put quote into q
   
   put "SLID = Secure Lightweight Identifier" & cr into t
   put "Version: " & sSLID_Version & cr & cr after t
   
   put "Usage:" & cr after t
   put "  genSLID()                      -> new 18-char SLID" & cr after t
   put merge("  genSLID([[q]]validate[[q]], s)   -> true | false") & cr after t
   put merge("  genSLID([[q]]bulk[[q]], n)       -> CR-delimited list (n ≤ 100000)") & cr after t
   put merge("  genSLID([[q]]--version[[q]])     -> show version") & cr after t
   put merge("  genSLID([[q]]--help[[q]])        -> this help") & cr after t
   put merge("  genSLID([[q]]--about[[q]])       -> license & credits") & cr & cr after t
   
   put "Notes:" & cr after t
   put "  - SLID length: 18; alphabet: 0-9 A-Z a-z (base62)" & cr after t
   put "  - Generation uses CSPRNG with rejection sampling (unbiased)" & cr after t
   put "  - Bulk: yields UI every 1000 items; capped at 100000" & cr after t
   
   return t
end SLID_Help




