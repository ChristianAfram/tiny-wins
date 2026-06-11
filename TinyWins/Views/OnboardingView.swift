import SwiftUI

struct OnboardingView: View {
    @AppStorage("settings.onboardingCompleted") private var onboardingCompleted = false
    @ObservedObject var settingsViewModel: SettingsViewModel

    @State private var step = 0

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            if step == 0 {
                welcomeStep
            } else {
                reminderStep
            }

            Spacer()

            Button(step == 0 ? "Continue" : "Get Started") {
                if step == 0 {
                    step = 1
                } else {
                    onboardingCompleted = true
                    DebugMetricsLogger.log(.onboardingCompleted)
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
        .multilineTextAlignment(.center)
    }

    private var welcomeStep: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 64))
                .foregroundStyle(.green)

            Text("Tiny Wins")
                .font(.largeTitle.bold())

            Text("One day. One tiny win. One tap to complete.")
                .font(.title3)
                .foregroundStyle(.secondary)
        }
    }

    private var reminderStep: some View {
        VStack(spacing: 16) {
            Image(systemName: "bell.badge.fill")
                .font(.system(size: 48))
                .foregroundStyle(.orange)

            Text("Stay on track")
                .font(.title.bold())

            Text("Get a gentle daily reminder to complete your tiny win. You can change or turn this off anytime in Settings.")
                .foregroundStyle(.secondary)

            DatePicker(
                "Reminder time",
                selection: reminderTimeBinding,
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(.wheel)
            .labelsHidden()

            Button("Enable reminders") {
                Task { await settingsViewModel.enableReminders() }
            }
            .buttonStyle(.bordered)
        }
    }

    private var reminderTimeBinding: Binding<Date> {
        Binding(
            get: {
                var components = DateComponents()
                components.hour = settingsViewModel.reminderHour
                components.minute = settingsViewModel.reminderMinute
                return Calendar.current.date(from: components) ?? Date()
            },
            set: { newValue in
                let components = Calendar.current.dateComponents([.hour, .minute], from: newValue)
                settingsViewModel.reminderHour = components.hour ?? 9
                settingsViewModel.reminderMinute = components.minute ?? 0
            }
        )
    }
}
