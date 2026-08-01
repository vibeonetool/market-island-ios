import ActivityKit
import Foundation

@MainActor
final class LiveActivityController: ObservableObject {
    @Published private(set) var isActive = !Activity<MarketActivityAttributes>.activities.isEmpty
    @Published private(set) var isLoading = false
    @Published private(set) var didFail = false
    @Published private(set) var statusMessage = "시작 버튼을 누르면 실제 다이나믹 아일랜드에 표시됩니다."

    private let marketData = MarketDataClient()

    func startOrRefresh() async {
        guard !isLoading else { return }
        isLoading = true
        didFail = false
        defer { isLoading = false }

        do {
            let quote = try await marketData.fetchQuote()
            let state = MarketActivityAttributes.ContentState(
                nasdaq: quote.nasdaq,
                nasdaqChange: quote.nasdaqChange,
                usdKrw: quote.usdKrw,
                updatedAt: .now
            )
            let content = ActivityContent(
                state: state,
                staleDate: Calendar.current.date(byAdding: .minute, value: 30, to: .now)
            )

            if let activity = Activity<MarketActivityAttributes>.activities.first {
                await activity.update(content)
                statusMessage = "최신 시세로 업데이트했습니다."
            } else {
                _ = try Activity.request(
                    attributes: MarketActivityAttributes(title: "Market Island"),
                    content: content,
                    pushType: nil
                )
                statusMessage = "다이나믹 아일랜드를 시작했습니다. 홈 화면으로 나가 확인하세요."
            }
            isActive = true
        } catch {
            didFail = true
            statusMessage = error.localizedDescription
        }
    }

    func end() async {
        for activity in Activity<MarketActivityAttributes>.activities {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
        isActive = false
        didFail = false
        statusMessage = "다이나믹 아일랜드를 종료했습니다."
    }
}
