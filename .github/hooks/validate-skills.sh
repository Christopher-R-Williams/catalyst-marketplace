#!/bin/bash
#
# Pre-commit hook to validate SKILL.md files
# This script checks YAML frontmatter and file structure
#

set -e

echo "🔍 Validating skill files..."

# Find all SKILL.md files
SKILL_FILES=$(find . -name "SKILL.md" -not -path "./.git/*" -not -path "./node_modules/*")

if [ -z "$SKILL_FILES" ]; then
    echo "✅ No SKILL.md files found to validate"
    exit 0
fi

VALIDATION_FAILED=0

for file in $SKILL_FILES; do
    echo "  Checking: $file"

    # Check if file starts with YAML frontmatter
    if ! head -n 1 "$file" | grep -q "^---$"; then
        echo "    ❌ Missing YAML frontmatter opening (---)"
        VALIDATION_FAILED=1
        continue
    fi

    # Extract YAML frontmatter (between first two --- markers)
    YAML_CONTENT=$(sed -n '/^---$/,/^---$/p' "$file" | sed '1d;$d')

    if [ -z "$YAML_CONTENT" ]; then
        echo "    ❌ Empty or invalid YAML frontmatter"
        VALIDATION_FAILED=1
        continue
    fi

    # Check for required 'name' field
    if ! echo "$YAML_CONTENT" | grep -q "^name:"; then
        echo "    ❌ Missing required field: 'name'"
        VALIDATION_FAILED=1
    fi

    # Check for required 'description' field
    if ! echo "$YAML_CONTENT" | grep -q "^description:"; then
        echo "    ❌ Missing required field: 'description'"
        VALIDATION_FAILED=1
    fi

    # Check if description contains "PROACTIVELY"
    DESCRIPTION=$(echo "$YAML_CONTENT" | grep "^description:" || echo "")
    if [ -n "$DESCRIPTION" ]; then
        if ! echo "$DESCRIPTION" | grep -qi "PROACTIVELY"; then
            echo "    ⚠️  Warning: Description should contain 'PROACTIVELY' for auto-activation"
        fi

        # Check description length (should be at least 50 chars)
        DESC_LENGTH=${#DESCRIPTION}
        if [ "$DESC_LENGTH" -lt 50 ]; then
            echo "    ⚠️  Warning: Description is very short ($DESC_LENGTH chars, recommend 50+)"
        fi
    fi

    # Check for required sections in markdown content
    REQUIRED_SECTIONS=(
        "## Purpose"
        "## IMPORTANT: Proactive Usage"
        "## When to Use"
        "## How to Use"
    )

    for section in "${REQUIRED_SECTIONS[@]}"; do
        if ! grep -q "^$section" "$file"; then
            echo "    ⚠️  Warning: Missing recommended section: '$section'"
        fi
    done

    if [ $VALIDATION_FAILED -eq 0 ]; then
        echo "    ✅ Valid"
    fi
done

if [ $VALIDATION_FAILED -ne 0 ]; then
    echo ""
    echo "❌ Skill validation failed. Please fix the errors above."
    exit 1
fi

echo ""
echo "✅ All skill files validated successfully!"
exit 0
