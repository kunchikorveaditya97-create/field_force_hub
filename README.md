# Field Force Hub

A Flutter mobile app for field task and visit tracking. The app implements role-based access for five user types, task and visit tracking, an activity timeline, and a mocked AI module that analyzes visit notes.

---

## 1. Prerequisites

Before setting up the project, make sure the following are installed:

| Requirement | Minimum Version | Notes |
|---|---|---|
| Flutter SDK | 3.10+ (Dart 3.0+) | [flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install) |
| Dart SDK | Bundled with Flutter | — |
| Android Studio or VS Code | Latest | With Flutter & Dart plugins installed |
| Android SDK / Platform Tools | API 21+ | Installed via Android Studio SDK Manager |
| Java Development Kit (JDK) | 17 | Required for Gradle/Android builds |
| Git | Latest | To clone the repository |
| Android Emulator or physical device | Android 5.0 (API 21) and above | For running/testing the app |
| Xcode (optional) | Latest | Only needed if testing on iOS/macOS |

Run `flutter doctor` after installation to confirm your environment is correctly configured.

No paid services, API keys, or backend servers are required — the app runs entirely offline using a local seeded data layer.

---

## 2. Project Overview

Field Force Hub simulates a field operations workflow where:
- **Admins, Regional Managers, and Team Leads** oversee and manage field tasks.
- **Field Agents** execute on-ground visits and submit audit/visit reports.
- **Auditors** review and validate field execution.

Core flows include authentication with role-based routing, a task list with status filters, a visit-report submission form, a mocked AI engine that evaluates submitted notes, and a live activity timeline across all tasks.

---

## 3. Tech Stack

| Layer | Choice |
|---|---|
| Framework | Flutter |
| State Management | GetX (reactive state + dependency injection + navigation) |
| Local Persistence | Hive (`hive_flutter`) — used as the offline data layer instead of a remote backend |
| Mock AI | Deterministic, rule-based logic (keyword matching on visit notes) implemented as a dedicated method in the controller layer |

---

## 4. Setup & Installation

```bash
# 1. Clone the repository
git clone (https://github.com/kunchikorveaditya97-create/field_force_hub.git)
cd field_force_hub

# 2. Install dependencies
flutter pub get

# 3. Run on a connected device or emulator
flutter run

# 4. (Optional) Build a release APK for distribution
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

No backend setup is required — `Hive` initializes a local box (`field_tasks_box`) on first launch and auto-seeds dummy task data.

---

## 5. Demo Credentials

Use any of the following on the login screen :

| Role | Login ID | Password |
|---|---|---|
| Admin | `admin` | `admin123` |
| Regional Manager | `manager` | `manager123` |
| Team Lead | `lead` | `lead123` |
| Field Agent | `agent` | `agent123` |
| Auditor | `auditor` | `auditor123` |

---

## 6. Sample / Dummy Data

On first run, two seeded field tasks (`TSK-9021`, `TSK-4082`) are created automatically in Hive, each with site name, location, priority, status, and an initial activity timeline. All data persists locally across app restarts, so reviewers can submit a visit report, close the app, and see the change retained on relaunch.

---

## 7. Core Modules Implemented

- **Authentication & Role Routing** — Login screen validates against 5 fixed demo accounts and routes into a role-aware dashboard.
- **Task Management** — Task list with filtering by status (`All`, `Pending`, `In-Progress`, `Completed`); Admin/Manager/Team Lead see an additional "privileged scope" banner indicating cross-team visibility.
- **Visit Reporting** — A dedicated report form lets the assigned user submit visit notes, which triggers status update and mock AI evaluation.
- **Activity / History Timeline** — A dedicated tab renders a chronological log per task (task assigned, report compiled, etc.) with human-readable relative timestamps ("2 hours ago").

---

## 8. Mock AI Design

The mock AI logic lives in `TaskController.submitFieldAuditLogs()`, isolated from the UI layer so it can later be swapped for a real LLM/AI service without touching screens.

**Behavior:** when a visit report is submitted, the notes are scanned for keywords and a flag + summary are generated deterministically:

| Keywords detected in notes | AI Flag | Output |
|---|---|---|
| none of the below | `Normal` | Generic "parameters match reference metrics" summary |
| `broken`, `fault`, `error` | `Warning` | Component failure flagged in report |
| `theft`, `damage`, `danger`, `fire` | `Critical` | Safety hazard flagged, immediate check recommended |

Both the original visit notes and the generated AI flag/summary are stored on the `FieldTask` model and persisted to Hive, then displayed back to the user on the Reports tab once a task is marked `Completed`.

---

## 9. Folder Structure

```
lib/
├── main.dart                  # App entry point, Hive init, GetMaterialApp root
├── controllers/
│   └── task_controller.dart   # GetX controller: state, mock AI logic, time formatting
├── data/
│   └── task_model.dart        # FieldTask & ActivityLog models + HiveStorageBridge
└── screens/
    ├── splash_screen.dart     # Animated splash
    ├── login_screen.dart      # Auth + role mapping
    ├── main_navigation.dart   # Bottom-nav shell: dashboard, tasks, reports, timeline
    ├── tasks_tab.dart         # Task list with status filter + role-aware banner
    └── reports_tab.dart       # Visit report submission + AI output display
```

---

## 10. Architecture Notes

- **State management:** GetX was chosen for its low boilerplate — a single `TaskController` is registered once via `Get.put()` at login and retrieved with `Get.find()` across screens, with `Obx()` widgets reacting to the observable `tasks`, `currentRole`, and `username` streams.
- **Data layer:** Hive acts as the persistence layer in place of a remote backend, in line with the assignment's "minimal backend" allowance. All task and timeline data is serialized to/from `Map` objects for storage.
- **Separation of concerns:** UI screens contain no business logic; task mutation and AI evaluation are centralized in `TaskController`, and storage read/write is centralized in `HiveStorageBridge`.
- **Role-based access:** Role string is stored on the controller after login and read by each screen to conditionally render management banners and gate features (e.g., management-only banner in Tasks tab).

---

## 11. Assumptions & Tradeoffs

- Task **creation/reassignment** UI for Admin/Manager/Team Lead is not implemented in this version; tasks are pre-seeded and only their status/notes are updated via the visit-report flow. This was a scope tradeoff given the assignment timeframe.
- Authentication is a static, hardcoded 5-account check rather than a real auth service, consistent with the "minimal backend" and "no paid services" requirements.
- The AI module is intentionally simple and rule-based (keyword matching) so it can be swapped for a real AI/LLM service later without changing the calling code in the UI.
- Search/sort and automated test coverage (listed as bonus items) were deprioritized in favor of completing the core required flows.
