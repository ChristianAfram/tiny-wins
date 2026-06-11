import SwiftUI

struct TodayView: View {
    @ObservedObject var viewModel: TodayViewModel
    @State private var showingSuggestionPicker = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                streakHeader

                if let win = viewModel.todayWin {
                    winCard(for: win)
                } else {
                    emptyState
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Today")
            .onAppear { viewModel.loadToday() }
            .sheet(isPresented: $showingSuggestionPicker) {
                SuggestionPickerView(viewModel: viewModel)
            }
        }
    }

    private var streakHeader: some View {
        VStack(spacing: 4) {
            Text("\(viewModel.streakDisplay.count)")
                .font(.system(size: 48, weight: .bold, design: .rounded))

            Text("day streak")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private func winCard(for win: DailyWin) -> some View {
        VStack(spacing: 16) {
            Label(win.category.displayName, systemImage: win.category.symbolName)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(win.title)
                .font(.title2.bold())
                .multilineTextAlignment(.center)

            if viewModel.isCompleted {
                Label("Completed", systemImage: "checkmark.circle.fill")
                    .font(.headline)
                    .foregroundStyle(.green)
            } else {
                Button {
                    viewModel.markComplete()
                } label: {
                    Text("Mark as complete")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                Button("Edit") {
                    viewModel.beginEditingTodayWin()
                    showingSuggestionPicker = true
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Text("Pick today's tiny win")
                .font(.title2.bold())

            Text("One small positive action is enough.")
                .foregroundStyle(.secondary)

            Button("Choose a tiny win") {
                showingSuggestionPicker = true
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}
