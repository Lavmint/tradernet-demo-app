// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StockQuotesLibrary",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "TradernetClient",
            targets: ["TradernetClient"]),
    ],
    dependencies: [
        .package(
            name: "SocketIO",
            url: "https://github.com/socketio/socket.io-client-swift",
            .upToNextMinor(from: "15.0.0"))
    ],
    targets: [
        .target(
            name: "TradernetClient",
            dependencies: ["SocketIO"])
    ]
)
