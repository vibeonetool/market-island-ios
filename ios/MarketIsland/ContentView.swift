import SwiftUI

struct ContentView: View {
    @StateObject private var liveActivity = LiveActivityController()

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(spacing: 10) {
                    Image(systemName: "chart.line.uptrend.xyaxis.circle.fill")
                        .font(.system(size: 58))
                        .foregroundStyle(.tint)
                    Text("Market Island")
                        .font(.largeTitle.bold())
                    Text("나스닥 · USD/KRW를 실제 다이나믹 아일랜드에 표시합니다.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 40)

                VStack(spacing: 12) {
                    Button {
                        Task { await liveActivity.startOrRefresh() }
                    } label: {
                        Label(
                            liveActivity.isActive ? "시세 새로고침" : "다이나믹 아일랜드 시작",
                            systemImage: liveActivity.isActive ? "arrow.clockwise" : "play.fill"
                        )
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .disabled(liveActivity.isLoading)

                    if liveActivity.isActive {
                        Button(role: .destructive) {
                            Task { await liveActivity.end() }
                        } label: {
                            Label("다이나믹 아일랜드 종료", systemImage: "stop.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                    }
                }

                Text(liveActivity.statusMessage)
                    .font(.footnote)
                    .foregroundStyle(liveActivity.didFail ? .red : .secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)

                Spacer()

                Text("시작 후 홈 화면으로 나가세요. 다이나믹 아일랜드를 길게 누르면 확장 시세를 볼 수 있습니다.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
