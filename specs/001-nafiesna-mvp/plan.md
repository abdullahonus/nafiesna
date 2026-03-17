# Implementation Plan: NafieSna Mobile App MVP

**Branch**: `001-nafiesna-mvp` | **Date**: 2026-03-17 | **Spec**: [specs/001-nafiesna-mvp/spec.md]
**Input**: Feature specification from `/specs/001-nafiesna-mvp/spec.md`

## Summary
Build a Flutter-based Islamic mobile application MVP using a clean, modular Model-View-State (MVS) architecture with Riverpod. The app will feature a Home hub with live YouTube streaming, daily prayer times calculation, continuous PDF reading, and an informational religious days content screen.

## Technical Context

**Language/Version**: [Flutter 3.x (Stable) / Dart 3.x]  
**Primary Dependencies**: [Riverpod, Flutter SDK, syncfusion_flutter_pdfviewer, youtube_player_flutter, adhan]  
**Storage**: [N/A]  
**Testing**: [flutter_test]  
**Target Platform**: [iOS / Android]
**Project Type**: [mobile-app]  
**Performance Goals**: [60+ fps, fluid vertical PDF scroll]  
**Constraints**: [Dark mode default, Primary Teal #008080, No Auth]  
**Scale/Scope**: [MVP - scoped feature modules]

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- [x] Does the design strictly avoid authentication/login flows? (Principle VIII)
- [x] Is the state management exclusively handled by Riverpod? (Principle II)
- [x] Does the UI adhere to the "Premium Minimal" teal/dark/gold aesthetic? (Principle V, VI)
- [x] Is the architecture following the Model-View-State (MVS) structure? (Principle III)
- [x] Is the PDF experience a continuous vertical scroll? (Principle VII)

## Project Structure

### Documentation (this feature)

```text
specs/001-nafiesna-mvp/
├── plan.md              # This file
├── research.md          # PDF rendering, YouTube player, and Prayer Times logic
├── data-model.md        # Entities for Home, Prayer, PDF, and Content
├── quickstart.md        # Setup and verification instructions
├── contracts/           # UI and Interaction contracts
└── tasks.md             # Implementation tasks
```

### Source Code (repository root)

```text
lib/
├── core/
│   ├── theme/           # App-wide theme configuration (Teal/Dark/Gold)
│   ├── navigation/      # Bottom navigation shell and routing
│   └── utils/           # Shared utility classes
├── features/
│   ├── home/
│   │   ├── models/
│   │   ├── views/
│   │   └── providers/
│   ├── prayer_times/
│   │   ├── models/
│   │   ├── views/
│   │   └── providers/
│   ├── pdf/
│   │   ├── models/
│   │   ├── views/
│   │   └── providers/
│   └── content/
│       ├── models/
│       ├── views/
│       └── providers/
└── main.dart            # Entry point initializing Riverpod and the app shell
```

**Structure Decision**: A feature-first modular structure is chosen to support the "Clean Modular Architecture" principle. Each feature encapsulates its own MVS components.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| N/A | No violations detected. | N/A |

## Implementation Strategy

### Stage 1: App Foundation and Structural Alignment
- Initialize `core` and `features` folder structure.
- Define the `AppTheme` with dark mode defaults and teal #008080 primary.
- Setup Riverpod `ProviderScope` in `main.dart`.

### Stage 2: Theme and App Shell
- Implement the `MainNavigationShell` with `BottomNavigationBar`.
- Create the routing logic to switch between the four core features.

### Stage 3: Feature Screen Scaffolding
- Create placeholder views for Home, Prayer Times, PDF, and Content.
- Establish the basic MVS folder structure for each feature.

### Stage 4: Local Content Integration
- Implement the PDF screen using `syncfusion_flutter_pdfviewer` for `assets/kaside.pdf`.
- Implement the Prayer Times screen using the `adhan` package for local calculation.

### Stage 5: Live and Dynamic Integrations
- Integrate `youtube_player_flutter` on the Home screen for the live broadcast.
- Implement the daily hadith section on the Home screen.
- Populate the Content screen with religious days data.

### Stage 6: Refinements
- Finalize the premium minimal UI touches (gold accents, spacing).
- Ensure WCAG accessibility standards are met for older users.
- Add basic loading and error states for network-dependent features.
