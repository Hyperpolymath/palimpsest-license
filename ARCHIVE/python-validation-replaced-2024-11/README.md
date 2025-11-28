# Python Validation Files - Archived

**Date Archived:** 2024-11-22
**Reason:** Replaced with Haskell-based functional validation suite

## Background

These Python configuration files were scaffolding for a planned Python-based validation toolkit. However, after careful consideration, the project adopted a **Haskell-based functional programming approach** instead for the following reasons:

1. **Type Safety**: Haskell's strong static typing provides legal precision
2. **Reliability**: Pure functional programming ensures predictable validation
3. **Composability**: Functional validators are easier to combine and maintain
4. **Performance**: Compiled Haskell code is faster than interpreted Python
5. **Legal Domain Fit**: Type systems better model legal document structures

## Replacement

The Python approach has been replaced with:

**Location:** `/TOOLS/validation/haskell/`

**Documentation:** `/docs/validation-tools.md`

**Installation:** `/TOOLS/validation/install.sh`

## Files Archived

- `pyproject.toml` - Python project configuration (never implemented)
- `requirements.txt` - Python dependencies (placeholder only)

No actual Python implementation existed; these were placeholder files.

## Migration Notes

If you need Python tooling for other purposes:

1. The Haskell validator can be called from Python using `subprocess`
2. JSON output mode could be added to the Haskell validator for Python integration
3. Python could be used for complementary tools (visualisation, reporting)

## See Also

- `/docs/validation-tools.md` - Comprehensive documentation of the Haskell validator
- `/TOOLS/validation/haskell/README.md` - Haskell project README
- `CONTRIBUTING.md` - How to contribute to the validation toolkit
