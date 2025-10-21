import ProjectDescription
import ProjectDescriptionHelpers

let infra = Factory.staticLib(
    name: "Infra",
    bundleSuffix: "infra",
    dependencies: [
        .project(target: "Domain", path: "../Domain"),
        .project(target: "CoreKit", path: "../Shared/CoreKit")
    ]
)

let tests = Factory.tests(
    name: "InfraTests",
    targetName: "Infra"
)

let project = Factory.project(
    name: "Infra",
    targets: [infra, tests]
)
