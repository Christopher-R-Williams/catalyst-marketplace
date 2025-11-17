#!/usr/bin/env python3
"""
Claude Code PR Review Script

This script uses the Anthropic API to review pull requests for the
Enterprise Web App Development Skills repository.
"""

import os
import sys
import argparse
import anthropic
import yaml
from pathlib import Path


def read_file_content(file_path: str) -> str:
    """Read and return file content."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return f.read()
    except Exception as e:
        return f"[Error reading file: {e}]"


def validate_skill_yaml(content: str) -> tuple[bool, str]:
    """Validate YAML frontmatter in SKILL.md files."""
    if not content.startswith('---'):
        return False, "Missing YAML frontmatter"

    try:
        # Extract YAML frontmatter
        parts = content.split('---', 2)
        if len(parts) < 3:
            return False, "Invalid YAML frontmatter format"

        yaml_content = parts[1]
        metadata = yaml.safe_load(yaml_content)

        # Check required fields
        if 'name' not in metadata:
            return False, "Missing 'name' field in YAML frontmatter"
        if 'description' not in metadata:
            return False, "Missing 'description' field in YAML frontmatter"

        # Check description quality
        description = metadata['description']
        if len(description) < 50:
            return False, f"Description too short ({len(description)} chars, minimum 50)"

        # Check for proactive triggers in description
        if 'PROACTIVELY' not in description and 'proactively' not in description:
            return False, "Description should include 'PROACTIVELY' to indicate auto-activation"

        return True, "YAML frontmatter is valid"

    except yaml.YAMLError as e:
        return False, f"YAML parsing error: {e}"
    except Exception as e:
        return False, f"Validation error: {e}"


def create_review_prompt(changed_files: list[str], file_contents: dict) -> str:
    """Create the prompt for Claude to review the PR."""

    prompt = """You are reviewing a pull request for the Enterprise Web App Development Skills repository.

This repository contains Claude skills for enterprise web application development with parallel agent workflows.

# Skills in this repository:
1. **ignite** - Launches parallel research agents to explore tech stacks
2. **architect** - Creates detailed implementation plans for parallel development
3. **deploy** - Orchestrates multiple agents building components simultaneously
4. **ship** - Integrates components into a working application

# Review Guidelines:

## For SKILL.md files:
- ✅ YAML frontmatter is valid and complete (name + description)
- ✅ Description includes "PROACTIVELY" and clear trigger keywords
- ✅ Contains "IMPORTANT: Proactive Usage" section
- ✅ Instructions use imperative/infinitive form (not second person)
- ✅ Examples are clear and practical
- ✅ Integrates properly with other skills in workflow
- ✅ Stack-agnostic (doesn't assume specific technologies)
- ✅ Follows progressive disclosure (metadata → SKILL.md → resources)

## For Documentation:
- ✅ Clear and concise
- ✅ Accurate technical information
- ✅ Proper markdown formatting
- ✅ Consistent with existing documentation style

## For Scripts:
- ✅ Well-commented and documented
- ✅ Error handling included
- ✅ Follows Python/JS best practices
- ✅ Has clear purpose and usage instructions

# Changed Files in this PR:
"""

    for file_path in changed_files:
        prompt += f"\n## File: {file_path}\n"

        if file_path in file_contents:
            content = file_contents[file_path]

            # Validate SKILL.md files
            if file_path.endswith('SKILL.md'):
                is_valid, message = validate_skill_yaml(content)
                if not is_valid:
                    prompt += f"\n**⚠️ VALIDATION ERROR**: {message}\n"

            prompt += f"\n```\n{content}\n```\n"
        else:
            prompt += "\n[File content not available]\n"

    prompt += """

# Your Task:

Provide a comprehensive review of these changes. Structure your review as follows:

## 📋 Summary
Brief overview of what this PR does

## ✅ What Looks Good
List positive aspects

## ⚠️ Issues Found
List any problems, errors, or concerns (if any)

## 💡 Suggestions for Improvement
Actionable suggestions to make this better

## 🎯 Recommendation
- [ ] **Approve** - Ready to merge
- [ ] **Request Changes** - Needs fixes before merging
- [ ] **Comment** - Feedback provided, but not blocking

---

**Review by Claude Code** 🤖

Be thorough, constructive, and specific. Focus on quality, accuracy, and consistency with the existing skills.
"""

    return prompt


def get_claude_review(prompt: str, api_key: str) -> str:
    """Get review from Claude API with retry logic."""
    import time

    max_retries = 3
    retry_delay = 2  # seconds

    for attempt in range(max_retries):
        try:
            client = anthropic.Anthropic(api_key=api_key)

            message = client.messages.create(
                model="claude-sonnet-4-20250514",
                max_tokens=4096,
                messages=[{
                    "role": "user",
                    "content": prompt
                }]
            )

            return message.content[0].text

        except anthropic.APIConnectionError as e:
            print(f"⚠️  Network error (attempt {attempt + 1}/{max_retries}): {e}")
            if attempt < max_retries - 1:
                print(f"   Retrying in {retry_delay} seconds...")
                time.sleep(retry_delay)
                retry_delay *= 2  # Exponential backoff
            else:
                return f"❌ Error: Could not connect to Claude API after {max_retries} attempts. Please check your network connection."

        except anthropic.RateLimitError as e:
            return f"❌ Error: Rate limit exceeded. Please try again later or upgrade your API plan."

        except anthropic.AuthenticationError as e:
            return f"❌ Error: Invalid API key. Please check your ANTHROPIC_API_KEY secret."

        except Exception as e:
            return f"❌ Error getting Claude review: {e}"

    return "❌ Error: Failed to get review after retries."


def main():
    parser = argparse.ArgumentParser(description='Claude Code PR Review')
    parser.add_argument('--changed-files', required=True, help='Space-separated list of changed files')
    parser.add_argument('--pr-number', required=True, help='Pull request number')
    parser.add_argument('--repo', required=True, help='Repository name')

    args = parser.parse_args()

    # Get API key from environment (check early)
    api_key = os.environ.get('ANTHROPIC_API_KEY')
    if not api_key:
        print("❌ Error: ANTHROPIC_API_KEY environment variable not set")
        print("💡 Please add it to GitHub Secrets:")
        print("   Settings → Secrets and variables → Actions → New repository secret")
        print("   Name: ANTHROPIC_API_KEY")
        print("   Value: Your Anthropic API key from https://console.anthropic.com/")
        sys.exit(1)

    # Parse changed files
    changed_files = args.changed_files.split()

    print(f"Reviewing PR #{args.pr_number} in {args.repo}")
    print(f"Changed files: {len(changed_files)}")

    # Read file contents
    file_contents = {}
    for file_path in changed_files:
        if os.path.exists(file_path):
            file_contents[file_path] = read_file_content(file_path)
            print(f"  ✓ Read {file_path}")
        else:
            print(f"  ⚠️ File not found: {file_path}")

    # Create review prompt
    print("\nGenerating Claude review...")
    prompt = create_review_prompt(changed_files, file_contents)

    # Get review from Claude
    review = get_claude_review(prompt, api_key)

    # Write review to file
    with open('claude_review.md', 'w', encoding='utf-8') as f:
        f.write(review)

    print("✓ Review complete! Written to claude_review.md")

    return 0


if __name__ == '__main__':
    sys.exit(main())
