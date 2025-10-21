import ProjectDescription

public enum Configs {
    public static let orgName = "annyeongjelly"
    public static let bundlePrefix = "com.annyeongjelly.booksearch"
    public static let iOSTargets: ProjectDescription.DeploymentTargets = .iOS("15.0")
}

// InfoPlist는 코드 내에서 관리 (파일 분리 없음)
private enum Plists {
    static let app: ProjectDescription.InfoPlist = .extendingDefault(with: [
        // 스토리보드 없이 빈 런치 스크린
        "UILaunchScreen": .dictionary([:]),
        "UIApplicationSceneManifest": .dictionary([
            "UIApplicationSupportsMultipleScenes": .boolean(false),
            "UISceneConfigurations": .dictionary([
                "UIWindowSceneSessionRoleApplication": .array([
                    .dictionary([
                        "UISceneConfigurationName": .string("Default Configuration"),
                        "UISceneDelegateClassName": .string("$(PRODUCT_MODULE_NAME).SceneDelegate")
                    ])
                ])
            ])
        ]),
        "UIViewControllerBasedStatusBarAppearance": .boolean(false)
    ])

    static let framework: ProjectDescription.InfoPlist = .default
}

public enum Factory {

    // 공통 빌드 설정
    public static func baseSettings() -> ProjectDescription.Settings {
        .settings(base: [
            "SWIFT_VERSION": "6.0",
            "SWIFT_STRICT_CONCURRENCY": "complete",
            "CODE_SIGN_STYLE": "Automatic"
        ])
    }

    // App 타깃
    public static func appTarget(
        name: String,
        dependencies: [ProjectDescription.TargetDependency]
    ) -> ProjectDescription.Target {
        ProjectDescription.Target.target(
            name: name,
            destinations: ProjectDescription.Destinations.iOS,      // ← Tuist 4 방식
            product: ProjectDescription.Product.app,
            bundleId: "\(Configs.bundlePrefix).app",
            deploymentTargets: Configs.iOSTargets,
            infoPlist: Plists.app,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            scripts: [],
            dependencies: dependencies,
            settings: baseSettings()
        )
    }

    // 정적 라이브러리(Feature/Domain/Infra/CoreKit 공통)
    public static func staticLib(
        name: String,
        bundleSuffix: String,
        dependencies: [ProjectDescription.TargetDependency] = []
    ) -> ProjectDescription.Target {
        ProjectDescription.Target.target(
            name: name,
            destinations: ProjectDescription.Destinations.iOS,
            product: ProjectDescription.Product.staticLibrary,
            bundleId: "\(Configs.bundlePrefix).\(bundleSuffix)",
            deploymentTargets: Configs.iOSTargets,
            infoPlist: Plists.framework,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            scripts: [],
            dependencies: dependencies,
            settings: baseSettings()
        )
    }

    // 테스트 타깃
    public static func tests(
        name: String,
        targetName: String
    ) -> ProjectDescription.Target {
        ProjectDescription.Target.target(
            name: name,
            destinations: ProjectDescription.Destinations.iOS,
            product: ProjectDescription.Product.unitTests,
            bundleId: "\(Configs.bundlePrefix).tests.\(targetName)",
            deploymentTargets: Configs.iOSTargets,
            infoPlist: ProjectDescription.InfoPlist.default,
            sources: ["Tests/**"],
            resources: [],
            scripts: [],
            dependencies: [.target(name: targetName)],
            settings: baseSettings()
        )
    }

    // Project 래퍼
    public static func project(
        name: String,
        targets: [ProjectDescription.Target]
    ) -> ProjectDescription.Project {
        ProjectDescription.Project(
            name: name,
            organizationName: Configs.orgName,
            options: .options(),
            settings: .settings(configurations: [
                .debug(name: .debug),
                .release(name: .release)
            ]),
            targets: targets
        )
    }
}
