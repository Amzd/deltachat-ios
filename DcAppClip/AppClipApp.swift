import SwiftUI

@main
struct AppClipApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onContinueUserActivity(NSUserActivityTypeBrowsingWeb, perform: handleUserActivity)
        }
    }

    private func handleUserActivity(_ userActivity: NSUserActivity) {
        guard let incomingURL = userActivity.webpageURL else { return }
        ContentView.storeInviteLink(incomingURL.absoluteString)
    }
}
