import Foundation

struct MarketQuote: Sendable {
    let nasdaq: Double
    let nasdaqChange: Double?
    let usdKrw: Double
    let exchangeDate: String
}

private struct MarketResponse: Decodable {
    struct Nasdaq: Decodable {
        let price: Double
        let change: Double?
    }

    struct Exchange: Decodable {
        let price: Double
        let date: String
    }

    let nasdaq: Nasdaq
    let exchange: Exchange
}

enum MarketDataError: LocalizedError {
    case badResponse

    var errorDescription: String? {
        "시장 데이터를 불러오지 못했습니다. 잠시 후 다시 시도하세요."
    }
}

actor MarketDataClient {
    private let endpoint = URL(string: "https://market-island-vibeonetool.vercel.app/api/market-data")!

    func fetchQuote() async throws -> MarketQuote {
        let (data, response) = try await URLSession.shared.data(from: endpoint)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw MarketDataError.badResponse
        }

        let decoded = try JSONDecoder().decode(MarketResponse.self, from: data)
        return MarketQuote(
            nasdaq: decoded.nasdaq.price,
            nasdaqChange: decoded.nasdaq.change,
            usdKrw: decoded.exchange.price,
            exchangeDate: decoded.exchange.date
        )
    }
}
