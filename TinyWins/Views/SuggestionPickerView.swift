import SwiftUI

struct SuggestionPickerView: View {
    @ObservedObject var viewModel: TodayViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section("Suggestions") {
                    ForEach(viewModel.suggestionService.suggestions) { suggestion in
                        Button {
                            viewModel.selectSuggestion(suggestion)
                            dismiss()
                        } label: {
                            Label(suggestion.title, systemImage: suggestion.category.symbolName)
                        }
                        .foregroundStyle(.primary)
                    }
                }

                Section("Write your own") {
                    TextField("Describe your tiny win", text: $viewModel.customTitle)

                    Picker("Category", selection: $viewModel.selectedCategory) {
                        ForEach(WinCategory.allCases) { category in
                            Text(category.displayName).tag(category)
                        }
                    }

                    Button("Save") {
                        viewModel.saveCustomWin()
                        dismiss()
                    }
                    .disabled(viewModel.customTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .navigationTitle("Today's Tiny Win")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
