import SwiftUI

struct ContentView: View {

    static let appGroupID = "group.chat.delta.ios"
    static let inviteLinkKey = "appClipInviteLink"
    static let appStoreURL = URL(string: "https://apps.apple.com/app/delta-chat/id1459523234")!

    @State private var inviteLink: String?

    var body: some View {
        VStack(spacing: 24) {
            Image("AppIcon")
                .resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(22)

            Text("Delta Chat")
                .font(.largeTitle)
                .bold()

            Text("Install the full Delta Chat app to use this invite link.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)

            if let inviteLink {
                Text(inviteLink)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.horizontal)
            }

            Link(destination: Self.appStoreURL) {
                Label("Get Delta Chat", systemImage: "arrow.down.circle.fill")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(14)
            }
            .padding(.horizontal)
        }
        .padding()
        .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { userActivity in
            guard let url = userActivity.webpageURL else { return }
            let link = url.absoluteString
            Self.storeInviteLink(link)
            inviteLink = link
        }
    }

    static func storeInviteLink(_ link: String) {
        UserDefaults(suiteName: appGroupID)?.set(link, forKey: inviteLinkKey)
    }
}
