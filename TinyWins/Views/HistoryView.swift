import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: HistoryViewModel

    private let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()

    var body: some View {
        NavigationStack {
            List(viewModel.days) { day in
                HStack {
                    VStack(alignment: .leading) {
                        Text(dayFormatter.string(from: day.date))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(dateFormatter.string(from: day.date))
                            .font(.subheadline)
                    }
                    .frame(width: 60, alignment: .leading)

                    if let win = day.win {
                        Text(win.title)
                            .lineLimit(1)
                    } else {
                        Text("No tiny win")
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    statusIcon(for: day.win)
                }
            }
            .navigationTitle("Last 7 Days")
            .onAppear { viewModel.loadHistory() }
        }
    }

    @ViewBuilder
    private func statusIcon(for win: DailyWin?) -> some View {
        switch win?.status {
        case .completed:
            Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
        case .planned:
            Image(systemName: "circle.dashed").foregroundStyle(.secondary)
        case .missed, .none:
            Image(systemName: "minus.circle").foregroundStyle(.secondary.opacity(0.5))
        }
    }
}
