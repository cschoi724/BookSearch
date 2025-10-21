import ProjectDescription
import ProjectDescriptionHelpers

let domain = Factory.staticLib(
    name: "Domain",
    bundleSuffix: "domain",
    dependencies: []
)

let tests = Factory.tests(
    name: "DomainTests",
    targetName: "Domain"
)

let project = Factory.project(
    name: "Domain",
    targets: [domain, tests]
)
