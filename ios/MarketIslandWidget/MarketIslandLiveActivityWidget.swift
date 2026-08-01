import ActivityKit
import Foundation
import SwiftUI
import WidgetKit

@main
struct MarketIslandWidgetBundle: WidgetBundle {
    var body: some Widget {
        MarketIslandLiveActivityWidget()
    }
}

struct MarketIslandLiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MarketActivityAttributes.self) { context in
            lockScreenView(for: context.state)
                .activityBackgroundTint(Color.black.opacity(0.9))
                .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    quoteColumn(
                        title: "NASDAQ",
                        value: context.state.nasdaq.formatted(.number.precision(.fractionLength(2))),
                        caption: changeText(context.state.nasdaqChange),
                        color: changeColor(context.state.nasdaqChange)
                    )
                }
                DynamicIslandExpandedRegion(.trailing) {
                    quoteColumn(
                        title: "USD / KRW",
                        value: "₩\(context.state.usdKrw.formatted(.number.precision(.fractionLength(2))))",
                        caption: "기준환율",
                        color: .green
                    )
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        Label("Market Island", systemImage: "chart.line.uptrend.xyaxis")
                        Spacer()
                        Text(context.state.updatedAt, style: .time)
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
            } compactLeading: {
                HStack(spacing: 3) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text(context.state.nasdaq.formatted(.number.precision(.fractionLength(0))))
                }
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.white)
            } compactTrailing: {
                Text("₩\(context.state.usdKrw.formatted(.number.precision(.fractionLength(0))))")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.green)
            } minimal: {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundStyle(.green)
            }
            .widgetURL(URL(string: "marketisland://open"))
            .keylineTint(.green)
        }
    }

    private func lockScreenView(for state: MarketActivityAttributes.ContentState) -> some View {
        HStack(spacing: 18) {
            quoteColumn(
                title: "NASDAQ",
                value: state.nasdaq.formatted(.number.precision(.fractionLength(2))),
                caption: changeText(state.nasdaqChange),
                color: changeColor(state.nasdaqChange)
            )
            Divider()
            quoteColumn(
                title: "USD / KRW",
                value: "₩\(state.usdKrw.formatted(.number.precision(.fractionLength(2))))",
                caption: "기준환율",
                color: .green
            )
        }
        .padding(.horizontal)
    }

    private func quoteColumn(title: String, value: String, caption: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary)
            Text(value)
                .font(.headline.monospacedDigit())
            Text(caption)
                .font(.caption2.weight(.medium))
                .foregroundStyle(color)
        }
    }

    private func changeText(_ change: Double?) -> String {
        guard let change else { return "변동 데이터 없음" }
        return String(format: "%@ %.2f%%", change >= 0 ? "▲" : "▼", abs(change))
    }

    private func changeColor(_ change: Double?) -> Color {
        guard let change else { return .secondary }
        return change >= 0 ? .green : .red
    }
}
