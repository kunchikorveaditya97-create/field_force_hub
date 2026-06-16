# \# Field Force Hub

# 

# A robust, enterprise-grade \*\*Field Force Management System\*\* built using Flutter. The architecture is cleanly designed to handle distributed task execution, permission-aware workflows, dynamic mock AI diagnostics, and offline data caching.

# 

# \---

# 

# \## 🚀 Core Features

# 

# \* \*\*Role-Based Access Control (RBAC):\*\* Restricts data layers and actions dynamically matching specific organizational responsibilities (Admin, Regional Manager, Team Lead, Field Agent, and Auditor).

# \* \*\*Task Lifecycle Dispatcher:\*\* Live status grid updates paired with dropdown visibility filter selectors.

# \* \*\*Visit Tracking Tracking \& Audit Forms:\*\* Interactive structured entry layouts mapped with real-time text validation boundaries.

# \* \*\*Mock AI Insight Engine:\*\* Deterministic keyword scanning abstraction that flags system vulnerabilities (Normal, Warning, Critical) and computes adaptive recommendations based on field inputs.

# \* \*\*Dynamic Time-Elapsed Activity Logs:\*\* Authentic runtime telemetry counters displaying logs in user-friendly formats (\*e.g., "Just now", "5 mins ago", "1 hour ago"\*).

# \* \*\*Offline Local Persistence:\*\* Native device storage caching system managed via Hive boxes ensuring data survives cold restarts.

# 

# \---

# 

# \## 🛠️ Tech Stack Matrix

# 

# | Architectural Layer | Core Technology / Package Framework |

# | :--- | :--- |

# | \*\*Mobile Framework\*\* | Flutter Rendering SDK |

# | \*\*State Management\*\* | GetX State Architecture Pipeline (`Reactive State \& Obx`) |

# | \*\*Local Data Storage\*\* | Hive Binary NoSQL Key-Value Local Blocks |

# | \*\*Navigation Wrapper\*\* | Material Navigation Shell Structure |

# 

# \---

# 

# \## 📁 System Directory Framework

# 

# ```text

# lib/

# ├── controllers/

# │   └── task\_controller.dart      # Business logic wrapper \& time-elapsed parser

# ├── data/

# │   └── task\_model.dart            # Native data schemas \& Hive initialization structures

# └── screens/

# &#x20;   ├── login\_screen.dart          # Role gateway authentication interface panel

# &#x20;   ├── main\_navigation.dart       # Unified multi-tab dashboard layout core shell

# &#x20;   ├── reports\_tab.dart           # Mock AI diagnostic calculation interface

# &#x20;   └── tasks\_tab.dart             # Filter-enabled operational lists renderer





\---



\## 🔑 Access Control \& Permissions Matrix



| Operational Capability | Admin | Regional Manager | Team Lead | Field Agent | Auditor |

| :--- | :---: | :---: | :---: | :---: | :---: |

| \*\*Create/Dispatch Tasks\*\* | ✅ | ✅ | ✅ | ❌ | ❌ |

| \*\*View Cross-Team Logs\*\* | ✅ | ✅ | ❌ | ❌ | ❌ |

| \*\*View Assigned Team Run\*\* | ✅ | ✅ | ✅ | ✅ | ❌ |

| \*\*Execute Site Audit Visits\*\*| ✅ | ✅ | ✅ | ✅ | ❌ |

| \*\*View Audit Logs Timeline\*\* | ❌ | ❌ | ❌ | ❌ | ✅ |

| \*\*View Management Reports\*\* | ✅ | ✅ | ❌ | ❌ | ✅ |



\---



\## 🔐 Reviewer Testing Credentials Matrix



Use the following authentic demo profile layers inside the secure login gateway form to explore role-specific behaviors and layout mutations:



\* \*\*Role 1 — Corporate Admin:\*\* `Username: admin` | `Password: admin123`

\* \*\*Role 2 — Regional Manager:\*\* `Username: manager` | `Password: manager123`

\* \*\*Role 3 — Operations Team Lead:\*\* `Username: lead` | `Password: lead123`

\* \*\*Role 4 — Active Field Force Agent:\*\* `Username: agent` | `Password: agent123`

\* \*\*Role 5 — Compliance Auditor:\*\* `Username: auditor` | `Password: auditor123`



\---



\## ⚙️ Local Development Setup Instructions



\### Prerequisites

Make sure your computer station has the following framework engines initialized:

\* \*\*Flutter SDK:\*\* Version `3.0.0` or higher

\* \*\*Dart SDK:\*\* Version `3.0.0` or higher



\### Initialization Commands

1\. Clone this enterprise repository block to your local machine:

&#x20;  ```bash

&#x20;  git clone \[https://github.com/TUMHARA\_USERNAME/field\_force\_hub.git](https://github.com/TUMHARA\_USERNAME/field\_force\_hub.git)

