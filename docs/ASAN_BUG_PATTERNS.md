# Address Sanitizer Bug Patterns - iccDEV Recent Fixes

## Analysis Period
- Commits analyzed: 117 (since Nov 2025)
- Primary contributors: Chris Cox, D Hoyt
- Repository: InternationalColorConsortium/iccDEV

## Bug Classes Identified

### 1. Heap Buffer Overflow
**Frequency:** HIGH (5+ instances)

#### PR #329 - CIccLocalizedUnicode::GetText()
- **File:** IccProfLib/IccTagBasic.cpp
- **Root Cause:** Missing bounds check in UTF-16 string iteration
- **Fix Pattern:**
  - Added `str_end` pointer: `m_pBuf + m_nLength`
  - Changed loop: `while (*str)` → `while ((str < str_end) && *str)`
  - Added safety buffer: `malloc((nSize+2)*sizeof(icUInt16Number))`
  - Double null termination for malformed unicode

#### PR #231 - CIccMBB::Validate()
- **File:** IccProfLib/IccTagLut.cpp
- **Impact:** 42 lines changed (20 insertions, 22 deletions)
- **Pattern:** Array bounds validation in LUT processing

#### PR #229 - CIccXmlArrayType::ParseText()
- **File:** IccXML/IccLibXML/IccUtilXml.cpp
- **Impact:** 46 lines changed (23 insertions, 23 deletions)
- **Pattern:** Array parsing with insufficient bounds checking

### 2. Null Pointer Dereference (NPD)
**Frequency:** MEDIUM (3+ instances)

#### PR #322 / Commit 9bb41cf - CIccProfile::CheckTagTypes()
- **File:** IccProfLib/IccProfile.cpp
- **Root Cause:** Missing null checks before accessing `i->pTag`
- **Fix Pattern:**
  - Added null check for `m_Tags` container pointer
  - Added null check before calling tag methods:
    ```cpp
    if (i->pTag) {
      typesig = i->pTag->GetType();
      structSig = i->pTag->GetTagStructType();
      arraySig = i->pTag->GetTagArrayType();
    }
    ```
  - Initialized to safe defaults (`icSigUnknownType`, etc.)
  - Applied defensive check: `if (pTag && !GetTag(pTag))`

### 3. Integer Overflow / Read Length Mismatch
**Frequency:** MEDIUM

#### Commit 3a71e06 - Tag Read Length Validation
- **File:** IccProfLib/IccProfile.cpp
- **Root Cause:** 1KB profile claiming 1.6GB tag data → allocate → fail → display corrupted
- **Fix Pattern:**
  ```cpp
  size_t expected_length = pIO->GetLength();
  size_t read_length = m_pAttachIO->Read8(pIO->GetData(), expected_length);
  if (read_length == expected_length)
    return pIO;
  else {
    delete pIO;
    return NULL;
  }
  ```
- **Combined in PR #329:** Merged with heap-buffer-overflow fix

### 4. NaN/Infinity Handling
**Frequency:** LOW-MEDIUM (2 instances)

#### PR #269, #268 - Runtime Error: NaN Outside Range
- **Fix:** Bounds checking and NaN validation
- **Context:** Floating-point arithmetic in color calculations
- **Pattern:** Validate before cast/bounds operations

### 5. Use-After-Free
**Frequency:** LOW (1 instance)

#### Commit 82c5f8e - CIccXform::Create()
- **File:** (Not in recent diff view)
- **Pattern:** Object lifetime management issue

### 6. Type Confusion
**Frequency:** LOW (1 instance)

#### PR #228 - icStatusCMM::CIccEvalCompare::EvaluateProfile()
- **Pattern:** Incorrect type assumptions in evaluation logic

## Common Patterns

### Defensive Programming Additions
1. **Container null checks:** `if (!m_Tags)` before iteration
2. **Pointer validation:** `if (pTag)` before dereference
3. **Bounds enforcement:** `while ((ptr < end) && *ptr)`
4. **Safe initialization:** Default to `icSigUnknownType`
5. **Read verification:** `if (read_length == expected_length)`
6. **Extra null terminators:** Buffer `+2` instead of `+1` for malformed data

### Memory Safety Patterns
- Validate read length against expected before processing
- Add sentinel values at buffer boundaries
- Check container existence before element access
- Free memory on validation failure
- Return NULL on mismatch instead of proceeding

### Static Analysis Integration
- Multiple "Fix: sast reports" commits (PR #276, #275, #274, #273, #272, #271)
- Files: IccTagMPE.cpp, IccTagLut.cpp, IccMpeCalc.cpp, IccApplyProfiles.cpp, IccMpeBasic.cpp, IccEval.cpp
- Pattern: Proactive fixes from static analysis tools

## Risk Areas

### High Priority
1. **Unicode string handling** - UTF-16 parsing without bounds
2. **Tag reading** - Profile claims vs actual data size
3. **Container dereferencing** - Tag list pointer chains
4. **LUT processing** - Multi-dimensional array access

### Medium Priority
1. **XML parsing** - Array type conversion
2. **Floating-point validation** - NaN/Infinity checks
3. **Initialization** - Uninitialized variable access

## Mitigation Strategy Observed
1. Add validation layer at I/O boundary (read length checks)
2. Defensive null checks throughout call chains
3. Buffer oversizing for malformed input tolerance
4. Early return on validation failure with cleanup
5. Static analysis integration in CI/CD

## Files Most Frequently Patched
1. `IccProfLib/IccProfile.cpp` - Core profile handling
2. `IccProfLib/IccTagBasic.cpp` - Tag data structures
3. `IccProfLib/IccTagLut.cpp` - LUT processing
4. `IccXML/IccLibXML/IccUtilXml.cpp` - XML parsing
5. `IccProfLib/IccMpeBasic.cpp` - MPE elements

## Notes
- Comment from @ccox in NPD fix: "better solution would be to get rid of the pointer and put the container directly in the class"
- Indicates architectural debt: pointer-to-container design creates NPD surface
- Future refactor opportunity: Convert `m_Tags` from pointer to direct member
