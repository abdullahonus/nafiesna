# Research: NafieSna Mobile App MVP

## Decision 1: PDF Rendering
- **Decision**: Use `syncfusion_flutter_pdfviewer` for PDF display.
- **Rationale**: It provides a robust, out-of-the-box continuous vertical scrolling experience as mandated by the constitution (Principle VII). It supports local assets and has excellent performance for large documents.
- **Alternatives considered**: `flutter_pdfview` (requires more manual work for continuous scroll), `native_pdf_view` (less feature-rich for the "premium" feel).

## Decision 2: YouTube Integration
- **Decision**: Use `youtube_player_flutter` to embed the live broadcast.
- **Rationale**: This allows users to watch the `@NafiEsna` live stream directly within the app's "Home" screen, fulfilling the FR-001 requirement without forcing users out of the application experience.
- **Alternatives considered**: `url_launcher` (redirects to YouTube app, breaking the "premium hub" experience).

## Decision 3: Prayer Times Calculation
- **Decision**: Use the `adhan` package for local calculation of prayer times.
- **Rationale**: Local calculation is more reliable as it doesn't depend on an internet connection (aligning with "No Connectivity" edge case). It's a standard, highly accurate library for Islamic prayer times.
- **Alternatives considered**: Remote API (requires internet, introduces latency).

## Decision 4: State Management & MVS
- **Decision**: Implement a `lib/features/` based modular structure with `model`, `view`, and `state` sub-directories for each feature.
- **Rationale**: Directly aligns with Constitution Principle III (Clean Modular Architecture) and Principle II (Riverpod). Each feature (home, prayer_times, pdf, content) will have its own scoped folder.
- **Alternatives considered**: Layer-first structure (leads to "organizational-only" complexity).

## Decision 5: Visual Theme
- **Decision**: Custom `ThemeData` with `ColorScheme.dark`, `primary: Color(0xFF008080)`, and gold accents (`Color(0xFFFFD700)`) for highlights.
- **Rationale**: Complies with Constitution Principle V (Dark Mode) and Principle VI (Teal Primary). Gold will be used sparingly for visual hierarchy.
