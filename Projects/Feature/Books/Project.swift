import ProjectDescription
import ProjectDescriptionHelpers

let feature = Factory.staticLib(
    name: "BooksFeature",
    bundleSuffix: "feature.books",
    dependencies: [
        .project(target: "Domain", path: "../../Domain"),
        .project(target: "CoreKit", path: "../../Shared/CoreKit")
    ]
)

let tests = Factory.tests(
    name: "BooksFeatureTests",
    targetName: "BooksFeature"
)

let project = Factory.project(
    name: "Books",
    targets: [feature, tests]
)
