<h1 align="center">
  🎯 Hyperfocus
</h1>

<p align="center">
  <strong>Task manager designed for ADHD minds, with gacha-style gamification.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/status-WIP-yellow?style=flat-square" alt="Status: WIP"/>
  <img src="https://img.shields.io/badge/platform-Android-3DDC84?style=flat-square&logo=android&logoColor=white" alt="Android"/>
  <img src="https://img.shields.io/badge/Flutter-3.41-02569B?style=flat-square&logo=flutter&logoColor=white" alt="Flutter"/>
  <img src="https://img.shields.io/badge/backend-Supabase-3FCF8E?style=flat-square&logo=supabase&logoColor=white" alt="Supabase"/>
  <img src="https://img.shields.io/badge/license-MIT-blue?style=flat-square" alt="License"/>
</p>

---

> **⚠️ This project is under active development and is not yet ready for production use.**
> Features, APIs, and database schemas may change without notice.

---

## What is Hyperfocus?

Hyperfocus is a cross-platform task manager built specifically for people with ADHD. Instead of relying on willpower alone, it uses gacha-inspired gamification mechanics — the same reward loops that make games like Genshin Impact and Honkai: Star Rail so engaging — to turn productivity into something genuinely fun.

### Core ideas

- **Persistent nudges, not guilt trips.** Configurable ping notifications remind you of pending tasks without being punishing. Silence hours keep your sleep sacred.
- **Gacha drops for completing tasks.** Every task you finish has a chance to drop a collectible item, with rarity tiers (Common → Legendary) and a pity system guaranteeing drops after a streak of bad luck.
- **Streaks with freezes.** Build daily streaks to earn bonus points, but life happens — you get 2 monthly freezes so a bad day doesn't erase your progress.
- **Therapeutic friction.** When a task has been postponed too many times, Hyperfocus suggests breaking it into smaller pieces instead of just nagging harder.
- **Difficulty-based rewards.** Tag tasks as Easy, Medium, or Hard. Harder tasks earn more points, leveling up your profile with titles.

## Tech stack

| Layer | Technology |
|---|---|
| Mobile app | Flutter (Android first, iOS later) |
| State management | Riverpod |
| Navigation | go_router |
| Backend & Auth | Supabase (PostgreSQL + Auth + Realtime) |
| Local cache | Drift (SQLite) |
| Notifications | flutter_local_notifications + WorkManager |
| Desktop (Phase 2) | Tauri + SvelteKit |

## Project structure

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── theme/           # Dark theme + rarity/difficulty colors
│   ├── supabase/        # Client configuration
│   ├── local_db/        # Drift offline cache (Sprint 9)
│   ├── notifications/   # Local push notifications
│   ├── sync/            # Offline-first sync engine (Sprint 9)
│   └── router.dart      # go_router with shell navigation
├── features/
│   ├── auth/            # Login / register
│   ├── tasks/           # CRUD, difficulty, recurrence
│   ├── projects/        # Hierarchical projects + tags
│   ├── inbox/           # Quick capture
│   ├── today/           # Today view + daily progress
│   ├── calendar/        # Weekly/monthly calendar
│   ├── gamification/    # Drops, pity, streaks, levels, stats
│   ├── notifications/   # Reminder management UI
│   └── settings/        # User preferences
└── shared/
    ├── widgets/         # Reusable UI components
    ├── utils/           # Helpers
    └── constants/       # App-wide constants
```

Each feature follows the `data / domain / presentation` pattern.

## Development roadmap

### Phase 1 — Android app (current)

| Sprint | Focus | Status |
|--------|-------|--------|
| 0 | Project setup, Supabase schema, RLS | 🔄 In progress |
| 1 | Auth (login / register / logout) | ⬜ |
| 2 | Task CRUD + Inbox | ⬜ |
| 3 | Projects & tags | ⬜ |
| 4 | Today view & Calendar | ⬜ |
| 5 | Recurrence engine | ⬜ |
| 6 | Gamification core (drops, pity, streaks, levels) | ⬜ |
| 7 | Scheduled reminders | ⬜ |
| 8 | Global ping + streak notifications | ⬜ |
| 9 | Therapeutic friction + offline cache + polish | ⬜ |

### Phase 2 — Desktop app

Tauri + SvelteKit desktop client sharing the same Supabase backend. Will be planned in detail once v1.0 is stable.

## Getting started

### Prerequisites

- Flutter 3.41+ with Android SDK
- A Supabase project (free tier works)

### Setup

```bash
git clone https://github.com/YOUR_USER/hyperfocus.git
cd hyperfocus
flutter pub get
```

Update your Supabase credentials in `lib/core/supabase/supabase_client.dart`:

```dart
static const String _url = 'https://YOUR_PROJECT.supabase.co';
static const String _anonKey = 'YOUR_ANON_KEY';
```

Then run:

```bash
flutter run
```

## Contributing

This is a personal project in early development. Issues and suggestions are welcome, but pull requests may not be reviewed quickly while the core architecture is still taking shape.

## License

MIT
