# Runbook: Tiny Wins MVP

## Owner

Product/Engineering Owner: Christian Afram
Support Contact: christianafram54@gmail.com

## System Summary

Tiny Wins is a local-first iOS app for completing one small daily
self-improvement action. There is no backend, no accounts, and no
third-party SDKs.

## Dependencies

- iOS 17+
- SwiftUI
- SwiftData
- UserNotifications

## Data Stores

- SwiftData local store (`DailyWin` records)
- UserDefaults (`settings.*` keys: onboarding flag, reminder preferences)

## Critical Flows

1. First launch onboarding
2. Create daily win (suggested or custom)
3. Complete daily win
4. Calculate streak
5. Schedule daily reminder
6. Delete all local data

## Known Failure Modes

- Incorrect streak after timezone change — covered by `DateKeyServiceTests`
  and `StreakServiceTests` using fixed calendars/timezones.
- Notification permission denied — app must continue to function fully;
  reminders simply stay disabled.
- SwiftData migration issue — see Migration Rule below before changing
  `DailyWin`.
- Large Dynamic Type / accessibility layout issues — verify manually before
  release (see `RELEASE_CHECKLIST.md`).

## Migration Rule

For MVP:

- Do not delete or rename fields on `DailyWin` after release 1.0.
- Only add optional fields unless a `SchemaMigrationPlan` is implemented and
  tested.

## Rollback

- Pause the App Store Connect phased release.
- Remove the bad build from sale if the issue is severe.
- Submit a hotfix build; never ship a destructive schema migration.
- Old local data must remain readable by the previous and next versions.

## Launch Checklist

- CI passing (build, unit tests, UI tests)
- Privacy manifest (`PrivacyInfo.xcprivacy`) present
- Privacy policy published (`PRIVACY_POLICY.md`)
- `RELEASE_CHECKLIST.md` completed
- TestFlight feedback reviewed
