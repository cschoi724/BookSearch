import ProjectDescription
import ProjectDescriptionHelpers

let corekit = Factory.staticLib(
    name: "CoreKit",
    bundleSuffix: "shared.corekit",
    dependencies: []
)

let tests = Factory.tests(
    name: "CoreKitTests",
    targetName: "CoreKit"
)

let project = Factory.project(
    name: "CoreKit",
    targets: [corekit, tests]
)
