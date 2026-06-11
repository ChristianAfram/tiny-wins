# Privacy Notes: Tiny Wins

These notes summarize the privacy posture for engineering and App Store
Connect submission. The user-facing policy lives in `PRIVACY_POLICY.md`.

## Data Collected

None. Tiny Wins has no remote data collection, no account data, no email,
no name, no location, no contacts, no health data, no advertising ID, and no
third-party analytics.

## Data Stored Locally Only

Stored via SwiftData (`DailyWin`):

- Daily win title
- Category
- Date key (`YYYY-MM-DD`)
- Completion status (`planned` / `completed` / `missed`)
- Completion timestamp
- Created/updated timestamps

Stored via UserDefaults (`settings.*`):

- Reminder enabled flag
- Reminder hour/minute
- Onboarding completion flag

## User Controls

Available from Settings:

- Delete all local data (`PrivacyService.deleteAllData()`)
- Disable reminders
- Change reminder time
- View privacy explanation

## Privacy Manifest

`TinyWins/Resources/PrivacyInfo.xcprivacy` declares:

- `NSPrivacyTracking`: false
- `NSPrivacyTrackingDomains`: empty
- `NSPrivacyCollectedDataTypes`: empty
- `NSPrivacyAccessedAPITypes`: UserDefaults (reason `CA92.1`, app's own data)

## App Store Connect

App privacy details entered in App Store Connect must match this document:
"Data Not Collected".

## Third-Party SDKs

None. Any future dependency must be reviewed against this document and the
threat model in `Docs/RUNBOOK.md` before being added (dependency approval
gate).
