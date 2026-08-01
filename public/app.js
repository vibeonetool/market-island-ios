const ui = {
  refresh: document.querySelector('#refreshButton'),
  nasdaqPrice: document.querySelector('#nasdaqPrice'),
  nasdaqChange: document.querySelector('#nasdaqChange'),
  exchangePrice: document.querySelector('#exchangePrice'),
  exchangeChange: document.querySelector('#exchangeChange'),
  status: document.querySelector('#marketStatus'),
  updatedAt: document.querySelector('#updatedAt'),
  installButton: document.querySelector('#installButton'),
  installDescription: document.querySelector('#installDescription'),
};

let deferredInstallPrompt;
const nf = new Intl.NumberFormat('en-US', { maximumFractionDigits: 2 });
const krw = new Intl.NumberFormat('ko-KR', { maximumFractionDigits: 2 });

function setText(element, value) { element.textContent = value; }

function showChange(element, value, suffix = '%') {
  if (!Number.isFinite(value)) {
    element.className = 'change neutral';
    setText(element, '변동 데이터 없음');
    return;
  }
  const positive = value >= 0;
  element.className = `change ${positive ? 'positive' : 'negative'}`;
  setText(element, `${positive ? '▲' : '▼'} ${Math.abs(value).toFixed(2)}${suffix}`);
}

async function getMarketData() {
  const response = await fetch('/api/market-data', { cache: 'no-store' });
  if (!response.ok) throw new Error('시장 데이터를 가져오지 못했습니다.');
  return response.json();
}

function renderNasdaq(quote) {
  setText(ui.nasdaqPrice, nf.format(quote.price));
  showChange(ui.nasdaqChange, quote.change);
}

function renderUsdKrw(quote) {
  setText(ui.exchangePrice, `₩${krw.format(quote.price)}`);
  ui.exchangeChange.className = 'change neutral';
  setText(ui.exchangeChange, `${quote.date} 기준`);
}

async function refreshQuotes() {
  ui.refresh.classList.add('loading');
  ui.refresh.disabled = true;
  setText(ui.status, '최신 시세를 확인 중');

  try {
    const data = await getMarketData();
    renderNasdaq(data.nasdaq);
    renderUsdKrw(data.exchange);
    setText(ui.status, '시장 데이터 연결됨');
    const now = new Intl.DateTimeFormat('ko-KR', { hour: '2-digit', minute: '2-digit' }).format(new Date());
    setText(ui.updatedAt, `마지막 확인 ${now}`);
  } catch {
    setText(ui.status, '시장 데이터 연결 실패');
    setText(ui.updatedAt, '연결을 확인한 뒤 새로고침하세요.');
  }
  ui.refresh.classList.remove('loading');
  ui.refresh.disabled = false;
}

window.addEventListener('beforeinstallprompt', (event) => {
  event.preventDefault();
  deferredInstallPrompt = event;
  ui.installButton.hidden = false;
});

ui.installButton.addEventListener('click', async () => {
  if (!deferredInstallPrompt) return;
  deferredInstallPrompt.prompt();
  await deferredInstallPrompt.userChoice;
  deferredInstallPrompt = undefined;
  ui.installButton.hidden = true;
});

if (/iPhone|iPad|iPod/i.test(navigator.userAgent)) {
  setText(ui.installDescription, 'Safari 공유 버튼 → 홈 화면에 추가를 누르세요.');
}

window.addEventListener('appinstalled', () => {
  setText(ui.installDescription, '홈 화면에 설치되었습니다.');
  ui.installButton.hidden = true;
});

ui.refresh.addEventListener('click', refreshQuotes);
if ('serviceWorker' in navigator) navigator.serviceWorker.register('./service-worker.js');
refreshQuotes();
setInterval(refreshQuotes, 5 * 60 * 1000);
