const YAHOO_URL = 'https://query1.finance.yahoo.com/v8/finance/chart/%5EIXIC?range=5d&interval=1d';
const EXCHANGE_URL = 'https://api.frankfurter.dev/v1/latest?base=USD&symbols=KRW';

export default {
  async fetch() {
    try {
      const [nasdaqResponse, exchangeResponse] = await Promise.all([
        fetch(YAHOO_URL, { headers: { 'User-Agent': 'Market-Island/1.0' } }),
        fetch(EXCHANGE_URL),
      ]);
      if (!nasdaqResponse.ok || !exchangeResponse.ok) throw new Error('Upstream request failed');

      const [nasdaqData, exchangeData] = await Promise.all([
        nasdaqResponse.json(),
        exchangeResponse.json(),
      ]);
      const meta = nasdaqData.chart?.result?.[0]?.meta;
      const price = meta?.regularMarketPrice;
      const previous = meta?.chartPreviousClose ?? meta?.previousClose;
      const exchangePrice = exchangeData.rates?.KRW;
      if (![price, exchangePrice].every(Number.isFinite)) throw new Error('Invalid market data');

      const change = Number.isFinite(previous) && previous !== 0
        ? ((price - previous) / previous) * 100
        : null;

      return Response.json({
        nasdaq: { price, change },
        exchange: { price: exchangePrice, date: exchangeData.date },
      }, {
        headers: { 'Cache-Control': 'public, max-age=60, s-maxage=60' },
      });
    } catch {
      return Response.json({ error: 'Market data is temporarily unavailable.' }, { status: 502 });
    }
  },
};
