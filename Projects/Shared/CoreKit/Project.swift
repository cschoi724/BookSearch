import ProjectDescription
import ProjectDescriptionHelpers

let corekit = Factory.staticLib(
    name: "CoreKit",
    bundleSuffix: "shared.corekit",
    dependencies: []
)

let project = Factory.project(
    name: "CoreKit",
    targets: [corekit]
)
