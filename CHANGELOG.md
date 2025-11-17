# Changelog

All notable changes to Catalyst will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-17

### Added
- **Ignite Skill**: Parallel research agents for tech stack exploration
- **Architect Skill**: Detailed implementation planning with API contracts and database schemas
- **Deploy Skill**: Parallel agent orchestration for simultaneous component development
- **Ship Skill**: Component integration and end-to-end testing
- Start-session hook with Catalyst workflow introduction
- Automated Claude PR review workflow using GitHub Actions
- Comprehensive documentation (README, WORKFLOW, CONTRIBUTING, GITHUB_SETUP)
- Plugin configuration for Claude Code marketplace distribution
- MIT License for open-source usage
- YAML frontmatter validation in PR review script
- Stack-agnostic design supporting any technology combination

### Changed
- Rebranded from "Enterprise Web App Development Skills" to "Catalyst"
- Renamed skills with modern, catchy names:
  - `enterprise-app-researcher` → `ignite`
  - `enterprise-app-planner` → `architect`
  - `parallel-deployer` → `deploy`
  - `component-integrator` → `ship`

### Fixed
- Corrected plugin.json schema (repository field as string)
- Enhanced plugin.json for better plugin manager detection
- Fixed marketplace.json schema validation errors
- Updated all documentation to reflect new skill names

### Documentation
- Created comprehensive README with installation, usage, and examples
- Added WORKFLOW.md detailing the 4-phase development process
- Created CONTRIBUTING.md with contribution guidelines
- Added GITHUB_SETUP.md for marketplace distribution setup
- Documented proactive skill activation triggers
- Added PR template with skill-specific review checklist

### Infrastructure
- GitHub Actions workflow for automated PR reviews
- Python script for YAML validation and Claude-powered code review
- Git repository with proper .gitignore configuration
- Marketplace-ready plugin configuration

## [Unreleased]

### Planned
- Plugin icon/logo for visual identity
- Sample implementation plan examples
- API contract and database schema templates
- Quick reference cheat sheet
- Enhanced troubleshooting guide
- Skill structure validation tooling
- YAML validation pre-commit hooks

---

[1.0.0]: https://github.com/Christopher-R-Williams/catalyst-marketplace/releases/tag/v1.0.0
