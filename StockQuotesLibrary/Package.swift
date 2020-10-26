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
        
    ],
    targets: [
        .target(name: "TradernetClient", dependencies: ["SocketIO", "Starscream"]),
        .binaryTarget(name: "SocketIO", path: "Frameworks/Socket.IO-Client-Swift.xcframework"),
        .binaryTarget(name: "Starscream", path: "Frameworks/Starscream.xcframework")
    ]
)
