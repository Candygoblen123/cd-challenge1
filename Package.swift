// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "challenge1",
    platforms: [.macOS("12")],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "challenge1",
            dependencies: [
                .target(name: "CSDL2"),
                .target(name: "CSDL2_Image"),
                .target(name: "CSDL2_ttf")
            ]),
        .systemLibrary(name: "CSDL2", pkgConfig: "sdl2"),
        .systemLibrary(name: "CSDL2_Image", pkgConfig: "sdl2_image"),
        .systemLibrary(name: "CSDL2_ttf", pkgConfig: "sdl2_ttf"),
    ]
)
