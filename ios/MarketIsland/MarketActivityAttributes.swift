import ActivityKit
import Foundation

struct MarketActivityAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var nasdaq: Double
        var nasdaqChange: Double?
        var usdKrw: Double
        var updatedAt: Date
    }

    var title: String
}
