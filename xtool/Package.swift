// swift-tools-version: 6.0

import Foundation
import PackageDescription

let packageRoot = URL(fileURLWithPath: #filePath).deletingLastPathComponent()

func resourcesDirectoryContents(targetPath: String, directory: String) -> [String] {
    let url = packageRoot.appendingPathComponent(targetPath).appendingPathComponent(directory)
    return (try? FileManager.default.contentsOfDirectory(atPath: url.path)) ?? []
}

func localizedResources(targetPath: String, directory: String) -> [Resource] {
    resourcesDirectoryContents(targetPath: targetPath, directory: directory)
        .filter { $0.hasSuffix(".lproj") }
        .sorted()
        .map { .process("\(directory)/\($0)") }
}

func processedIfExists(targetPath: String, path: String) -> [Resource] {
    let url = packageRoot.appendingPathComponent(targetPath).appendingPathComponent(path)
    guard FileManager.default.fileExists(atPath: url.path) else {
        return []
    }
    return [.process(path)]
}

func copiedIfExists(targetPath: String, path: String) -> [Resource] {
    let url = packageRoot.appendingPathComponent(targetPath).appendingPathComponent(path)
    guard FileManager.default.fileExists(atPath: url.path) else {
        return []
    }
    return [.copy(path)]
}

let deltaChatAppResources =
    copiedIfExists(targetPath: "Targets/DeltaChatApp", path: "Resources/deltachat-ios/Assets") +
    processedIfExists(targetPath: "Targets/DeltaChatApp", path: "Resources/deltachat-ios/Assets.xcassets") +
    localizedResources(targetPath: "Targets/DeltaChatApp", directory: "Resources/deltachat-ios")

let dcShareResources =
    processedIfExists(targetPath: "Targets/DcShareExtension", path: "Resources/DcShare/Base.lproj") +
    processedIfExists(targetPath: "Targets/DcShareExtension", path: "Resources/deltachat-ios/Assets.xcassets") +
    localizedResources(targetPath: "Targets/DcShareExtension", directory: "Resources/deltachat-ios")

let dcNotificationServiceResources =
    localizedResources(targetPath: "Targets/DcNotificationServiceExtension", directory: "Resources/deltachat-ios")

let dcWidgetResources =
    processedIfExists(targetPath: "Targets/DcWidgetExtension", path: "Resources/DcWidget/Assets.xcassets") +
    processedIfExists(targetPath: "Targets/DcWidgetExtension", path: "Resources/deltachat-ios/Assets.xcassets") +
    localizedResources(targetPath: "Targets/DcWidgetExtension", directory: "Resources/deltachat-ios")

let package = Package(
    name: "DeltaChatXTool",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(name: "DeltaChatApp", targets: ["DeltaChatApp"]),
        .library(name: "DcShare", targets: ["DcShareExtension"]),
        .library(name: "DcNotificationService", targets: ["DcNotificationServiceExtension"]),
        .library(name: "DcWidget", targets: ["DcWidgetExtension"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ashleymills/Reachability.swift.git", exact: "5.2.4"),
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", exact: "5.20.0"),
        .package(url: "https://github.com/SDWebImage/SDWebImageWebPCoder.git", exact: "0.14.6"),
        .package(url: "https://github.com/SDWebImage/SDWebImageSVGKitPlugin.git", exact: "1.4.0"),
        .package(url: "https://github.com/SDWebImage/SDWebImageSwiftUI.git", exact: "2.2.7"),
        .package(url: "https://github.com/deltachat/MCEmojiPicker.git", revision: "a94d61d273847209758c3e8736e61f1d622ec01a"),
        .package(url: "https://github.com/stasel/WebRTC.git", exact: "140.0.0"),
    ],
    targets: [
        .target(
            name: "CDeltaChat",
            path: "Targets/CDeltaChat",
            publicHeadersPath: "include",
            linkerSettings: [
                .unsafeFlags(["-L", "Support", "-ldeltachat"]),
            ]
        ),
        .target(
            name: "DcCore",
            dependencies: ["CDeltaChat"],
            path: "Targets/DcCore",
            sources: ["Sources"]
        ),
        .target(
            name: "SCSiriWaveformView",
            path: "Sources/SCSiriWaveformView"
        ),
        .target(
            name: "DeltaChatApp",
            dependencies: [
                "DcCore",
                "SCSiriWaveformView",
                .product(name: "Reachability", package: "reachability.swift"),
                .product(name: "SDWebImage", package: "sdwebimage"),
                .product(name: "SDWebImageWebPCoder", package: "sdwebimagewebpcoder"),
                .product(name: "SDWebImageSVGKitPlugin", package: "sdwebimagesvgkitplugin"),
                .product(name: "SDWebImageSwiftUI", package: "sdwebimageswiftui"),
                .product(name: "MCEmojiPicker", package: "mcemojipicker"),
                .product(name: "WebRTC", package: "webrtc"),
            ],
            path: "Targets/DeltaChatApp",
            sources: ["Sources"],
            resources: deltaChatAppResources,
            swiftSettings: [
                .define("MAIN_APPLICATION"),
            ]
        ),
        .target(
            name: "DcShareExtension",
            dependencies: [
                "DcCore",
                .product(name: "SDWebImage", package: "sdwebimage"),
                .product(name: "SDWebImageWebPCoder", package: "sdwebimagewebpcoder"),
            ],
            path: "Targets/DcShareExtension",
            sources: ["Sources"],
            resources: dcShareResources
        ),
        .target(
            name: "DcNotificationServiceExtension",
            dependencies: ["DcCore"],
            path: "Targets/DcNotificationServiceExtension",
            sources: ["Sources"],
            resources: dcNotificationServiceResources
        ),
        .target(
            name: "DcWidgetExtension",
            dependencies: ["DcCore"],
            path: "Targets/DcWidgetExtension",
            sources: ["Sources"],
            resources: dcWidgetResources
        ),
    ]
)
