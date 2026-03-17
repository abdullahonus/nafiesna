# Feature Specification: NafieSna Mobile App MVP

**Feature Branch**: `001-nafiesna-mvp`  
**Created**: 2026-03-17  
**Status**: Draft  
**Input**: Build a Flutter-based Islamic mobile application MVP for NafieSna.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Browse Home (Priority: P1)

As a user, I want to access a central hub where I can watch live broadcasts and read a daily hadith to stay spiritually connected.

**Why this priority**: Essential for immediate engagement and fulfilling the core mission of NafieSna.

**Independent Test**: Verify that the Home screen displays the YouTube live stream from @NafiEsna and a daily hadith section upon launch.

**Acceptance Scenarios**:

1. **Given** the app is launched, **When** the Home screen is visible, **Then** the live broadcast section is displayed at the top.
2. **Given** the Home screen is open, **When** I scroll down, **Then** a daily hadith section is visible.

---

### User Story 2 - Check Prayer Times (Priority: P1)

As a user, I want to see the daily prayer times so I can plan my worship throughout the day.

**Why this priority**: Fundamental requirement for an Islamic application and a key driver for daily app usage.

**Independent Test**: Access the Prayer Times screen from the bottom navigation and verify current daily times are displayed.

**Acceptance Scenarios**:

1. **Given** I am on any screen, **When** I tap the Prayer Times icon in the bottom navigation, **Then** the Prayer Times screen is displayed.

---

### User Story 3 - Read Kaside PDF (Priority: P2)

As a user, I want to read the "Kaside" text in a fluid, continuous manner without interruptions from pagination.

**Why this priority**: Provides a premium and uninterrupted reading experience for core religious content.

**Independent Test**: Navigate to the PDF screen and verify that `assets/kaside.pdf` is rendered as a continuous vertical scroll.

**Acceptance Scenarios**:

1. **Given** I am on the PDF screen, **When** I swipe vertically, **Then** the document scrolls continuously without page transitions.

---

### User Story 4 - Explore Content (Priority: P2)

As a user, I want to learn about religious days and Islamic information to increase my knowledge.

**Why this priority**: Complements the live and static content with educational material.

**Independent Test**: Navigate to the Content screen and verify information about religious days is accessible.

**Acceptance Scenarios**:

1. **Given** I am on the Content screen, **When** I browse the sections, **Then** I can see details about upcoming religious days and general Islamic content.

---

## Edge Cases

- **No Connectivity**: How does the YouTube live broadcast section and dynamic hadith content behave when there is no internet?
- **Invalid PDF**: What is the fallback if the local `assets/kaside.pdf` is missing or corrupted?
- **Localization**: How are prayer times and content displayed if the user's locale is different from the primary target? (Assumption: Default is Turkish/English).

## Requirements *(mandatory)*

<!--
  PROJECT CONSTRAINT: No authentication or login flows permitted in MVP scope.
  PROJECT CONSTRAINT: PDF experience MUST be continuous vertical scroll.
-->

### Functional Requirements

- **FR-001**: System MUST display a live broadcast section on the Home screen using the @NafiEsna YouTube source.
- **FR-002**: System MUST display a daily hadith section on the Home screen.
- **FR-003**: System MUST provide a dedicated screen for daily Prayer Times accessible via bottom navigation.
- **FR-004**: System MUST render `assets/kaside.pdf` as a continuous vertical scroll on the PDF screen.
- **FR-005**: System MUST provide an informational Content screen detailing religious days.
- **FR-006**: System MUST use a bottom navigation pattern with four main sections: Home, Prayer Times, PDF, and Content.
- **FR-007**: System MUST strictly adhere to a premium dark mode theme with #008080 (Teal) as the primary color and subtle gold accents.
- **FR-008**: System MUST NOT require user authentication or login for any feature.

### Key Entities

- **Home Feed**: Represents the collection of live streams and daily hadiths.
- **Prayer Schedule**: Represents the daily prayer times.
- **PDF Document**: Represents the Kaside text rendered for the user.
- **Religious Calendar**: Represents the data for religious days and Islamic content.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can access any of the four core sections in under 2 taps from the home screen.
- **SC-002**: The PDF document loads and becomes scrollable within 1 second of navigating to the screen.
- **SC-003**: 100% of UI elements follow the approved dark mode and teal/gold color palette.
- **SC-004**: Users are never prompted for login or credentials during their journey.
- **SC-005**: Text on all screens meets WCAG accessibility standards for readability, specifically for older users.
