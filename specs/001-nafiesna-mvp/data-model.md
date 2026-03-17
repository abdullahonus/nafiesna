# Data Model: NafieSna Mobile App MVP

## Core Entities

### Home Feed (`lib/features/home/models/home_model.dart`)
- **live_status**: Enum { Live, Offline }
- **daily_hadith**: String (current day's content)
- **hadith_source**: String (citation)

### Prayer Schedule (`lib/features/prayer_times/models/prayer_model.dart`)
- **fajr**: DateTime
- **dhuhr**: DateTime
- **asr**: DateTime
- **maghrib**: DateTime
- **isha**: DateTime
- **location**: Object { latitude, longitude }

### PDF Document (`lib/features/pdf/models/pdf_model.dart`)
- **file_path**: String (e.g., `assets/kaside.pdf`)
- **scroll_offset**: Double (last saved position, optional)

### Content Feed (`lib/features/content/models/content_model.dart`)
- **religious_day**: Object { title, date, description }
- **is_active**: Boolean (whether it should be prominently displayed)

## State Transitions
- **Home**: Fetches live stream status (Live vs Offline) and populates the current day's hadith.
- **Prayer Times**: Recalculates times whenever the location or date changes.
- **PDF**: Renders the local asset continuously.
- **Content**: Filters and displays religious days based on the current date.
