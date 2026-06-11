# Tiny Wins

Tiny Wins is a simple, local-first iOS app that helps you complete **one small
positive action per day**.

> One day. One tiny win. One tap to complete.

The MVP deliberately avoids accounts, backend infrastructure, AI features,
social feeds, subscriptions, and complex habit-tracking mechanics. Everything
runs on-device using SwiftData, UserDefaults, and local notifications.

See `Docs/` for the spec, runbook, release checklist, and privacy notes that
guided this implementation.

## Project Structure

```
TinyWins/
  TinyWinsApp.swift        # App entry point + SwiftData container
  RootView.swift           # Onboarding gate + main tab navigation
  Models/                  # SwiftData models and enums
  Views/                   # SwiftUI screens
  ViewModels/              # MVVM view models
  Services/                # Date, streak, suggestion, notification, privacy
  Repositories/            # SwiftData repository + protocol
  Resources/               # PrivacyInfo.xcprivacy
TinyWinsTests/              # Unit tests (date, streak, suggestions, repository)
TinyWinsUITests/            # UI tests for happy-path flows
Docs/                       # Runbook, release checklist, privacy notes
```

## Getting Started

This project uses [XcodeGen](https://github.com/yonaskolb/XcodeGen) to generate
the `.xcodeproj` from `project.yml`, so the project file itself isn't checked
into source control.

1. Install XcodeGen: `brew install xcodegen`
2. Generate the Xcode project: `xcodegen generate`
3. Open `TinyWins.xcodeproj` in Xcode (iOS 17+ / Xcode 15+)
4. Run the `TinyWins` scheme on an iOS 17+ simulator or device

## Running Tests

In Xcode: `Cmd+U` on the `TinyWins` scheme, or:

```
xcodebuild test -scheme TinyWins -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Architecture

Local-first SwiftUI MVVM:

```
SwiftUI Views -> ViewModels -> Domain Services -> Repositories -> SwiftData / UserDefaults / UserNotifications
```

No server, accounts, or third-party SDKs are used in the MVP. All data stays
on-device. See `PRIVACY_POLICY.md` and `Docs/PRIVACY_NOTES.md` for details.
