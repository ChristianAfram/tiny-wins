# Release Checklist: Tiny Wins

Complete every item before submitting a build to App Store Connect.

## Hard Launch Blockers

Do not release if any of the following are true:

- [ ] Streak logic has failing tests
- [ ] Delete-all-data does not work
- [ ] Notification permission denial breaks onboarding or the main flows
- [ ] App crashes on fresh install
- [ ] App crashes on second launch
- [ ] `PrivacyInfo.xcprivacy` is missing or out of date
- [ ] Privacy policy is missing or out of date
- [ ] App Store copy contains medical, diagnostic, or "clinically proven"
      claims
- [ ] Local data migration is untested
- [ ] No rollback plan documented (`Docs/RUNBOOK.md`)
- [ ] No owner listed in the runbook
- [ ] This checklist is incomplete

## Automated Checks

- [ ] `xcodegen generate` succeeds
- [ ] App builds for Release configuration
- [ ] All unit tests pass (`TinyWinsTests`)
- [ ] All UI tests pass (`TinyWinsUITests`)
- [ ] CI workflow (`.github/workflows/ci.yml`) is green
- [ ] No forbidden third-party SDKs added
- [ ] App version/build number updated

## Assets

- [ ] Replace the placeholder `AppIcon` slot in
      `TinyWins/Assets.xcassets/AppIcon.appiconset` with a real 1024x1024 PNG
      before App Store submission

## Manual QA Checklist

- [ ] Fresh install
- [ ] Upgrade install (previous build -> this build)
- [ ] Delete app and reinstall
- [ ] Notification permission denied flow
- [ ] Notification permission granted flow
- [ ] Airplane mode
- [ ] Dark mode
- [ ] Large text / accessibility sizes
- [ ] Small iPhone screen (e.g. iPhone SE)
- [ ] Timezone change while app is running
- [ ] Device reboot, then relaunch app

## App Store Review Readiness

- [ ] Copy avoids: "improve depression", "treat anxiety", "fix ADHD",
      "diagnose burnout", "clinically proven", "medical-grade"
- [ ] Copy uses wellness language: "build small daily momentum", "complete
      one tiny positive action per day", "a gentle self-improvement
      companion"
- [ ] App privacy details in App Store Connect match `PRIVACY_POLICY.md` and
      `PrivacyInfo.xcprivacy` (no data collected, no tracking)

## Release Strategy

1. Internal TestFlight
2. External TestFlight, 25 users
3. External TestFlight, 100 users
4. App Store phased release
