// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NotchNotification",
    platforms: [
        .macOS(.v12),
    ],
    products: [
        .library(
            name: "NotchNotification",
            targets: ["NotchNotification"]
        ),
    ],
    targets: [
        .target(name: "NotchNotification"),
    ]
)
