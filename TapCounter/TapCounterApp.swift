import SwiftUI

@main
struct TapCounterApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @AppStorage("tapCount") private var count = 0

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            Image(systemName: "hand.tap.fill")
                .font(.system(size: 44))
                .foregroundStyle(.blue)
                .accessibilityHidden(true)

            VStack(spacing: 8) {
                Text("点一点")
                    .font(.largeTitle.bold())
                Text("每点一下，记录一个小小的进步。")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            Text(count.formatted())
                .font(.system(size: 88, weight: .bold, design: .rounded))
                .monospacedDigit()
                .minimumScaleFactor(0.3)
                .lineLimit(1)
                .frame(maxWidth: .infinity)
                .accessibilityLabel("当前计数")
                .accessibilityValue(String(count))
                .accessibilityIdentifier("countLabel")

            Button {
                if count < Int.max {
                    count += 1
                }
            } label: {
                Label("点击加一", systemImage: "plus")
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 18))
            .accessibilityIdentifier("incrementButton")

            Button("清零") {
                count = 0
            }
            .font(.body.weight(.medium))
            .disabled(count == 0)
            .accessibilityIdentifier("resetButton")

            Spacer()

            Text("计数会自动保存在这台手机上")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 24)
        .frame(maxWidth: 440)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemBackground))
        .tint(.blue)
    }
}
