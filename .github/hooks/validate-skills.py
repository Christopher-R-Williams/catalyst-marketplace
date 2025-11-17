#!/usr/bin/env python3
"""
Pre-commit hook to validate SKILL.md files.
Checks YAML frontmatter structure and required sections.
"""

import sys
import yaml
from pathlib import Path
from typing import Tuple, List


def extract_yaml_frontmatter(content: str) -> Tuple[bool, dict, str]:
    """
    Extract YAML frontmatter from markdown content.
    Returns: (success, metadata_dict, error_message)
    """
    if not content.startswith('---'):
        return False, {}, "File must start with YAML frontmatter (---)"

    try:
        parts = content.split('---', 2)
        if len(parts) < 3:
            return False, {}, "Invalid YAML frontmatter format (missing closing ---)"

        yaml_content = parts[1].strip()
        metadata = yaml.safe_load(yaml_content)

        if not isinstance(metadata, dict):
            return False, {}, "YAML frontmatter must be a dictionary"

        return True, metadata, ""

    except yaml.YAMLError as e:
        return False, {}, f"YAML parsing error: {e}"
    except Exception as e:
        return False, {}, f"Unexpected error: {e}"


def validate_metadata(metadata: dict) -> List[str]:
    """
    Validate metadata fields.
    Returns list of error messages (empty if valid).
    """
    errors = []
    warnings = []

    # Check required fields
    if 'name' not in metadata:
        errors.append("Missing required field: 'name'")
    elif not isinstance(metadata['name'], str) or not metadata['name'].strip():
        errors.append("Field 'name' must be a non-empty string")

    if 'description' not in metadata:
        errors.append("Missing required field: 'description'")
    else:
        description = metadata['description']
        if not isinstance(description, str):
            errors.append("Field 'description' must be a string")
        else:
            # Check description length
            if len(description) < 50:
                warnings.append(f"Description is short ({len(description)} chars, recommend 50+)")

            # Check for PROACTIVELY keyword
            if 'PROACTIVELY' not in description and 'proactively' not in description:
                warnings.append("Description should include 'PROACTIVELY' for auto-activation")

    return errors, warnings


def validate_markdown_structure(content: str) -> List[str]:
    """
    Validate markdown structure and required sections.
    Returns list of warnings for missing sections.
    """
    warnings = []

    required_sections = [
        "## Purpose",
        "## IMPORTANT: Proactive Usage",
        "## When to Use",
        "## How to Use",
        "## Best Practices",
        "## Examples",
    ]

    for section in required_sections:
        if section not in content:
            warnings.append(f"Missing recommended section: '{section}'")

    return warnings


def validate_skill_file(file_path: Path) -> Tuple[bool, List[str], List[str]]:
    """
    Validate a single SKILL.md file.
    Returns: (is_valid, errors, warnings)
    """
    try:
        content = file_path.read_text(encoding='utf-8')
    except Exception as e:
        return False, [f"Error reading file: {e}"], []

    errors = []
    warnings = []

    # Validate YAML frontmatter
    success, metadata, error_msg = extract_yaml_frontmatter(content)
    if not success:
        errors.append(error_msg)
        return False, errors, warnings

    # Validate metadata fields
    meta_errors, meta_warnings = validate_metadata(metadata)
    errors.extend(meta_errors)
    warnings.extend(meta_warnings)

    # Validate markdown structure
    structure_warnings = validate_markdown_structure(content)
    warnings.extend(structure_warnings)

    is_valid = len(errors) == 0
    return is_valid, errors, warnings


def main():
    """Main validation function."""
    print("🔍 Validating skill files...")

    # Find all SKILL.md files
    repo_root = Path(__file__).parent.parent.parent
    skill_files = list(repo_root.glob("**/SKILL.md"))

    # Exclude files in .git and node_modules
    skill_files = [
        f for f in skill_files
        if '.git' not in f.parts and 'node_modules' not in f.parts
    ]

    if not skill_files:
        print("✅ No SKILL.md files found to validate")
        return 0

    overall_valid = True

    for skill_file in skill_files:
        rel_path = skill_file.relative_to(repo_root)
        print(f"\n  Checking: {rel_path}")

        is_valid, errors, warnings = validate_skill_file(skill_file)

        # Print errors
        for error in errors:
            print(f"    ❌ ERROR: {error}")
            overall_valid = False

        # Print warnings
        for warning in warnings:
            print(f"    ⚠️  WARNING: {warning}")

        if is_valid and not warnings:
            print(f"    ✅ Valid")
        elif is_valid:
            print(f"    ✅ Valid (with warnings)")

    print()

    if not overall_valid:
        print("❌ Skill validation failed. Please fix the errors above.")
        return 1

    print("✅ All skill files validated successfully!")
    return 0


if __name__ == '__main__':
    sys.exit(main())
