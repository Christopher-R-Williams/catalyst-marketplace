# Git Hooks for Catalyst

This directory contains validation scripts that can be used as Git hooks to ensure code quality before commits.

## Available Hooks

### validate-skills.py

Python-based validation script that checks SKILL.md files for:
- Valid YAML frontmatter structure
- Required fields (`name`, `description`)
- Description quality (length, PROACTIVELY keyword)
- Recommended markdown sections

**Requirements:**
- Python 3.7+
- PyYAML library (`pip install pyyaml`)

**Usage:**
```bash
# Run manually
python .github/hooks/validate-skills.py

# Or make executable and run directly
chmod +x .github/hooks/validate-skills.py
./.github/hooks/validate-skills.py
```

### validate-skills.sh

Bash-based validation script with similar functionality.
Useful if you don't have Python or prefer shell scripts.

**Requirements:**
- Bash shell
- Standard Unix utilities (grep, sed, find)

**Usage:**
```bash
# Run manually
bash .github/hooks/validate-skills.sh

# Or make executable and run directly
chmod +x .github/hooks/validate-skills.sh
./.github/hooks/validate-skills.sh
```

## Setting Up as Pre-commit Hook

To automatically run validation before each commit:

### Option 1: Symbolic Link (Recommended)

```bash
# From repository root
ln -s ../../.github/hooks/validate-skills.py .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

### Option 2: Copy Script

```bash
# From repository root
cp .github/hooks/validate-skills.py .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

### Option 3: Use Git Hooks Path

```bash
# Configure Git to use this directory for hooks
git config core.hooksPath .github/hooks
```

## Manual Validation

You can also run validation manually at any time:

```bash
# Python version (more thorough)
python .github/hooks/validate-skills.py

# Bash version (faster, basic checks)
bash .github/hooks/validate-skills.sh
```

## What Gets Validated

### YAML Frontmatter
- ✅ File starts with `---`
- ✅ Valid YAML syntax
- ✅ Contains `name` field
- ✅ Contains `description` field
- ✅ Description length (minimum 50 characters)
- ✅ Description includes "PROACTIVELY" keyword

### Markdown Structure
- ⚠️ Contains "## Purpose" section
- ⚠️ Contains "## IMPORTANT: Proactive Usage" section
- ⚠️ Contains "## When to Use" section
- ⚠️ Contains "## How to Use" section
- ⚠️ Contains "## Best Practices" section
- ⚠️ Contains "## Examples" section

**Legend:**
- ✅ = Error (blocks commit)
- ⚠️ = Warning (allows commit but shows message)

## Exit Codes

- `0` - All validations passed
- `1` - Validation errors found (commit should be blocked)

## Example Output

```
🔍 Validating skill files...

  Checking: ignite/SKILL.md
    ✅ Valid

  Checking: architect/SKILL.md
    ⚠️  WARNING: Missing recommended section: '## Best Practices'
    ✅ Valid (with warnings)

  Checking: deploy/SKILL.md
    ❌ ERROR: Missing required field: 'description'

❌ Skill validation failed. Please fix the errors above.
```

## Troubleshooting

### "command not found: python3"
Install Python 3.7+ or use the bash version instead.

### "No module named 'yaml'"
Install PyYAML:
```bash
pip install pyyaml
# or
pip3 install pyyaml
```

### Hook not running
Make sure the script is executable:
```bash
chmod +x .git/hooks/pre-commit
```

## Contributing

If you find issues with the validation scripts or want to add new checks:
1. Test your changes thoroughly
2. Update this README
3. Submit a pull request

---

**Note:** These hooks run locally on your machine. The GitHub Actions workflow provides additional validation on pull requests.
