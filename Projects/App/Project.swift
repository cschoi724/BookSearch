import ProjectDescription
import ProjectDescriptionHelpers

let app = Factory.appTarget(
    name: "BookSearchApp",
    dependencies: [
        .project(target: "BooksFeature", path: "../Feature/Books"),
        .project(target: "Domain", path: "../Domain"),
        .project(target: "Infra", path: "../Infra"),
        .project(target: "CoreKit", path: "../Shared/CoreKit")
    ]
)

//let appTests = Factory.tests(
//    name: "BookSearchAppTests",
//    targetName: "BookSearchApp"
//)

let project = Factory.project(
    name: "App",
    targets: [app]
)
