---
name: design
user-invocable: true
description: '**WORKFLOW SKILL** — Assist with UI/interface design, color palettes, layouts, and design patterns for apps and websites in VS Code. USE FOR: generating design ideas, creating mockups, suggesting color schemes, layout structures. DO NOT USE FOR: code implementation (use default agent); non-design tasks.'
---

# Design Skill

This skill provides assistance with designing user interfaces, including layouts, color schemes, and patterns.

## Workflow

1. **Understand Requirements**: Clarify the design needs, target platform (e.g., iOS, web), and any constraints.

2. **Brainstorm Ideas**: Generate initial design concepts, including wireframes or descriptions.

3. **Color and Theme Suggestions**: Propose color palettes and themes based on best practices.

4. **Layout Structures**: Suggest component arrangements and navigation flows.

5. **Mockup Generation**: Create simple text-based mockups or diagrams.

6. **Feedback and Iteration**: Refine based on user input.

## Tools Used

- renderMermaidDiagram: For creating diagrams of layouts.
- vscode_askQuestions: To gather design requirements.
- semantic_search: To find existing design patterns in the codebase.

## Assets

- Templates for common UI components.
- Color palette generators.

Note: This skill focuses on design ideation; for implementation, switch to coding tasks.