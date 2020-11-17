// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GBDeviceInfo",
	platforms: [
		.iOS(.v8),
		.macOS(.v10_10)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "GBDeviceInfo",
            targets: ["GBDeviceInfo"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
		.target(
            name: "GBDeviceInfo",
            dependencies: [],
			path: "GBDeviceInfo",
			sources: ["GBDeviceInfo_Common.m", "GBDeviceInfo_iOS.m","GBDeviceInfo_OSX.m"],
			publicHeadersPath: ""
		),
		
		// required GBJailbreakDetection to be converted to package
//		.target(
//			name: "iOS jailbreak",
//            dependencies: ["iOS"]),
    ]
)
