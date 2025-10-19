# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Cadenza is a structured development workflow system that uses AI-assisted Product Requirements Documents (PRDs) and task list management to guide feature implementation. The workflow follows a three-phase approach: PRD creation, task generation, and task-by-task implementation with automated testing and version control.

## Development Workflow

### 1. Creating a PRD

When creating a new PRD, use the `.cursor/rules/create-prd.md` workflow:

1. Ask clarifying questions before writing the PRD (problem/goal, target user, core functionality, user stories, acceptance criteria, scope, data requirements, design/UI, edge cases)
2. Provide answer options in letter/number lists for easy user responses
3. Generate PRD targeting a junior developer audience with explicit, unambiguous requirements
4. Save as `/tasks/[n]-prd-[feature-name].md` where `n` is zero-padded 4-digit sequence (e.g., `0001-prd-user-authentication.md`)
5. Do NOT start implementing the PRD after creation
6. Iterate on the PRD based on user feedback

**PRD Structure:**
- Introduction/Overview
- Goals
- User Stories
- Functional Requirements (numbered)
- Non-Goals (Out of Scope)
- Design Considerations (optional)
- Technical Considerations (optional)
- Success Metrics
- Open Questions

### 2. Generating Tasks from PRD

When generating tasks from a PRD, use the `.cursor/rules/generate-tasks.md` workflow:

1. Read and analyze the specified PRD
2. Assess current codebase state to understand existing infrastructure, patterns, conventions, and reusable components
3. **Phase 1:** Generate 5-7 high-level parent tasks and present to user
4. Inform user: "I have generated the high-level tasks based on the PRD. Ready to generate the sub-tasks? Respond with 'Go' to proceed."
5. **Wait for user confirmation** ("Go")
6. **Phase 2:** Break down each parent task into actionable sub-tasks
7. Identify relevant files (including test files) in the `Relevant Files` section
8. Save as `/tasks/tasks-[prd-file-name].md` (e.g., `tasks-0001-prd-user-profile-editing.md`)

**Task List Format:**
```markdown
## Relevant Files
- `path/to/file.ts` - Description of relevance
- `path/to/file.test.ts` - Unit tests for file.ts

### Notes
- Testing commands and conventions

## Tasks
- [ ] 1.0 Parent Task Title
  - [ ] 1.1 Sub-task description
  - [ ] 1.2 Sub-task description
- [ ] 2.0 Parent Task Title
  - [ ] 2.1 Sub-task description
```

### 3. Processing Task Lists

When implementing tasks, follow the `.cursor/rules/process-task-list.md` protocol:

**Implementation Rules:**
- Work on ONE sub-task at a time
- After each sub-task, ask user for permission before proceeding
- Do NOT start the next sub-task until user says "yes" or "y"

**Completion Protocol:**
1. When finishing a sub-task:
   - Mark sub-task complete: `[ ]` → `[x]`
2. When ALL sub-tasks under a parent are complete:
   - Run full test suite (language-specific: `pytest`, `npm test`, `bin/rails test`, etc.)
   - Only if tests pass: stage changes (`git add .`)
   - Clean up temporary files and code
   - Commit with conventional commit format using `-m` flags:
     ```
     git commit -m "feat: description" -m "- Key change 1" -m "- Key change 2" -m "Related to Task X in PRD"
     ```
   - Mark parent task complete: `[ ]` → `[x]`

**Task List Maintenance:**
- Update task list after significant work
- Add newly discovered tasks as they emerge
- Keep "Relevant Files" section accurate and up-to-date
- Check which sub-task is next before starting work
- Pause for user approval after implementing each sub-task

## Testing

Test commands depend on the technology stack of the specific project. Common patterns:
- Run all tests: language-specific command (e.g., `npx jest`, `pytest`, `npm test`)
- Run specific test file: `npx jest path/to/test/file` (JavaScript/TypeScript example)
- Unit tests should be placed alongside source files (e.g., `MyComponent.tsx` and `MyComponent.test.tsx`)

## Environment

This project uses [Devbox](https://www.jetify.com/devbox) for environment management. The `devbox.json` file defines packages and shell scripts.

### Kubernetes Cluster

A Kubernetes cluster is available in the default context for deployment and testing.

**Container Registry:**
- Registry URL: `registry.192.168.1.239.nip.io:443`
- Images should be tagged and pushed to this registry for deployment

**Deployment:**
- Kubernetes manifests are located in the `k8s/` directory
- Uses Kustomize for declarative configuration management
- Standard layout with base configurations and environment-specific overlays

## Key Principles

- PRDs target junior developer understanding with explicit requirements
- Task implementation is incremental with user approval gates
- Every parent task completion requires passing tests and a commit
- Conventional commit format is required for all commits
- Maintain task list accuracy throughout development
