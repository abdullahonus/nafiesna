<!--
Sync Impact Report:
- Version change: none → 1.0.0
- List of modified principles:
    - I. Flutter-First Framework (Added)
    - II. Riverpod State Management (Added)
    - III. Clean Modular Architecture (Added)
    - IV. Incremental Foundation (Added)
    - V. Accessible Premium UI (Added)
    - VI. Navigation & Experience (Added)
    - VII. MVP Scope & Constraints (Added)
- Added sections: Technology Stack & Constraints, MVP Governance
- Removed sections: None
- Templates requiring updates:
    - .specify/templates/plan-template.md (✅ updated)
    - .specify/templates/spec-template.md (✅ updated)
    - .specify/templates/tasks-template.md (✅ updated)
- Follow-up TODOs: None
-->

# NafieSna Constitution

## Core Principles

### I. Flutter-First Framework
The application MUST be built using the Flutter framework as its foundation. All platform-specific implementations should be handled through Flutter's multi-platform capabilities unless a native bridge is strictly required for MVP functionality.

### II. Riverpod State Management
Riverpod MUST be used as the exclusive state management solution. This ensures a robust, testable, and maintainable state layer across the entire application. Avoid mixing other state management patterns.

### III. Clean Modular Architecture
The project structure MUST remain clean, modular, and maintainable. Features MUST be organized using a clear Model-View-State (MVS) structure. Logic and UI must be strictly separated to facilitate long-term extensibility.

### IV. Incremental Foundation
Build the project incrementally. The application foundation (base themes, core utilities, navigation shell) MUST be established and verified before implementing specific feature content.

### V. Accessible Premium UI
Prioritize readability, simplicity, and accessibility, specifically targeting ease of use for older users. The UI MUST be minimal, premium, and consistent. Dark mode is the DEFAULT design system.

### VI. Visual Identity
The primary color MUST be HEX #008080 (Teal). Subtle gold accents SHOULD be used only where they improve hierarchy and visual elegance. The design should feel premium and respectful of its Islamic context.

### VII. Navigation & Experience
Primary navigation MUST use a bottom navigation structure. The PDF viewing experience MUST be implemented as a continuous vertical scroll, not paginated, to ensure a modern and fluid user experience.

### VIII. MVP Scope & Constraints
Do NOT include authentication or login flows. Feature work MUST be strictly limited to the approved MVP scope. Prefer reusable UI components and scoped feature modules to prevent code bloat.

## Technology Stack & Constraints

- **Framework**: Flutter (Latest Stable)
- **State Management**: Riverpod
- **Design System**: Dark Mode (Default), HEX #008080 Primary, Subtle Gold Accents
- **Navigation**: Bottom Navigation
- **Content Delivery**: Continuous Vertical PDF Scroll
- **Auth**: None (Public Access)

## MVP Governance

- **Scope Control**: Any feature or architectural change outside the approved MVP scope is prohibited without a formal constitution amendment.
- **Foundational Priority**: No feature development may begin until the core architectural foundation is ratified and implemented.
- **Code Review**: All PRs must be checked against the "Premium Minimal UI" standard and "Modular Structure" principle.

## Governance

This constitution supersedes all other development practices within the NafieSna project. Any amendments to these principles require a version bump and documentation of the rationale. All contributors must verify compliance with these principles during the planning and implementation phases.

**Version**: 1.0.0 | **Ratified**: 2026-03-17 | **Last Amended**: 2026-03-17
