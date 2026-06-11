import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    let privacyService: PrivacyService

    @State private var showingDeleteConfirmation = false
    @State private var showingPrivacyExplanation = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Reminders") {
                    Toggle("Daily reminder", isOn: $viewModel.reminderEnabled)

                    if viewModel.reminderEnabled {
                        DatePicker(
                            "Reminder time",
                            selection: reminderTimeBinding,
                            displayedComponents: .hourAndMinute
                        )
                    }

                    if viewModel.reminderEnabled && !viewModel.notificationPermissionGranted {
                        Text("Notifications are disabled in iOS Settings. Enable them to receive reminders.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Privacy") {
                    Button("View privacy explanation") {
                        showingPrivacyExplanation = true
                    }

                    Button("Delete all local data", role: .destructive) {
                        showingDeleteConfirmation = true
                    }
                }

                if let message = viewModel.deleteConfirmationMessage {
                    Section {
                        Text(message)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .task { await viewModel.onAppear() }
            .alert("Delete all data?", isPresented: $showingDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    viewModel.deleteAllData()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This permanently removes your tiny win history, streak, and reminder settings from this device. This cannot be undone.")
            }
            .sheet(isPresented: $showingPrivacyExplanation) {
                NavigationStack {
                    ScrollView {
                        Text(privacyService.privacyExplanation)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .navigationTitle("Privacy")
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") { showingPrivacyExplanation = false }
                        }
                    }
                }
            }
        }
    }

    private var reminderTimeBinding: Binding<Date> {
        Binding(
            get: {
                var components = DateComponents()
                components.hour = viewModel.reminderHour
                components.minute = viewModel.reminderMinute
                return Calendar.current.date(from: components) ?? Date()
            },
            set: { newValue in
                let components = Calendar.current.dateComponents([.hour, .minute], from: newValue)
                viewModel.reminderHour = components.hour ?? 9
                viewModel.reminderMinute = components.minute ?? 0
            }
        )
    }
}
