script "id18"

## id18 = Secure Lightweight Identifier
# timestamp: 2025-09-12_22-53-00_CEST

## Versioning policy (SemVer)
# Pre-1.0 (0.Y.Z):
#   Y (MINOR): bump for any breaking change to public behavior.
#   Z (PATCH): bump for non-breaking features, fixes, docs, perf.
# 1.0+:
#   MAJOR: breaking; MINOR: features; PATCH: fixes.

local sid18_Version = "0.1.3"
local sBuf
local sPos

function genid18 pCmd , pValue
   switch pCmd
      ---
      case "bulk"
         return generateid18List (pValue)
         break
         ---
      case "validate"
         return validateid18 (pValue)
         break
         ---
      case "-v"
      case "--version"
      case "version"
         return merge("id18 [[sid18_Version]]")
         break
         ---
      case "-h"
      case "--help"
      case "?"
      case "help"
         return id18_Help()
         break
         ---
      case "--about"
      case "about"
      case "--license"
      case "license"
         return id18_About()
         break
         ---
      default
         return generateid18()
   end switch
end genid18

function generateid18
   ## Generate CSPRNG 18-character id18 (base62), unbiased
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
      put _id18_nextByte() into tVal          -- buffered byte
      if tVal < tMaxAccept then               -- accept only 0..247
         put 1 + (tVal mod tAlphabetLen) into tIndex
         put char tIndex of tAlphabet after tID
      end if
   end repeat
   
   return tID
end generateid18

function _id18_nextByte
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
end _id18_nextByte

function generateid18List pCount
   ## Generate a CR-delimited list of id18s (array + combine, faster)
   # usage:
   #   put generateid18List(5)
   #   put generateid18List(100000)
   # timestamp: 2025-09-12_22-53-00_CEST
   # purpose: Return pCount id18s, each on its own line (CR-delimited)
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
      put generateid18() into tA[i]
      if (i mod 1000) = 0 then wait 0 with messages
   end repeat
   combine tA by cr and tab
   return tA
end generateid18List

function validateid18 pID
   ## Validate id18: exactly 18 chars, base62 alphabet only
   # usage:
   #   put validateid18(genid18())          -- true
   #   put validateid18("abc-INVALID-123")  -- false
   # timestamp: 2025-09-12_22-53-00_CEST
   # purpose: Return true if pID is a valid id18, otherwise false
   
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
end validateid18

function id18_About
   ## About / license / credits
   # usage:
   #   put genid18("--about")
   # timestamp: 2025-09-12_00-00-00_CEST
   # purpose: Provide license/credit info without cluttering --help/--version
   
   local t
   put "id18 = Secure Lightweight Identifier" & cr into t
   put merge("Version: [[sid18_Version]]") & cr after t
   put "License: MIT (see LICENSE in repo)" & cr after t
   put "Copyright: © 2025 Roland Hüttmann, Switzerland. All rights reserved." & cr after t
   put "Repository: https://github.com/GoingLive/id18" & cr after t
   return t
end id18_About

function id18_Help
   ## Short help text for id18
   # usage:
   #   put genid18("--help")
   # timestamp: 2025-09-12_00-00-00_CEST
   # purpose: Show usage synopsis and supported commands
   
   local t, q
   put quote into q
   
   put "id18 = Secure Lightweight Identifier" & cr into t
   put "Version: " & sid18_Version & cr & cr after t
   
   put "Usage:" & cr after t
   put "  genid18()                      -> new 18-char id18" & cr after t
   put merge("  genid18([[q]]validate[[q]], s)   -> true | false") & cr after t
   put merge("  genid18([[q]]bulk[[q]], n)       -> CR-delimited list (n ≤ 100000)") & cr after t
   put merge("  genid18([[q]]--version[[q]])     -> show version") & cr after t
   put merge("  genid18([[q]]--help[[q]])        -> this help") & cr after t
   put merge("  genid18([[q]]--about[[q]])       -> license & credits") & cr & cr after t
   
   put "Notes:" & cr after t
   put "  - id18 length: 18; alphabet: 0-9 A-Z a-z (base62)" & cr after t
   put "  - Generation uses CSPRNG with rejection sampling (unbiased)" & cr after t
   put "  - Bulk: yields UI every 1000 items; capped at 100000" & cr after t
   
   return t
end id18_Help




