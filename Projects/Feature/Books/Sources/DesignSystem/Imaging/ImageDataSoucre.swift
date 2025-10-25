//
//  ImageDataSoucre.swift
//  Books
//
//  Created by 일하는석찬 on 10/25/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import UIKit
import CoreKit

public enum ImageTransition {
    case none
    case fade(TimeInterval)
}

public struct ImageOptions {
    public var placeholder: UIImage?
    public var transition: ImageTransition

    public init(placeholder: UIImage? = nil, transition: ImageTransition = .fade(0.15)) {
        self.placeholder = placeholder
        self.transition = transition
    }
}

public final class ImageLoadToken {
    fileprivate var task: Task<Void, Never>?
    public init() {}
    public func cancel() { task?.cancel() }
}

@MainActor
public final class ImageDataSource {
    public static private(set) var shared: ImageDataSource!
    
    private let loader: ImageDataLoader

    public init(loader: ImageDataLoader) {
        self.loader = loader
    }
    
    public static func configure(loader: ImageDataLoader) {
        self.shared = ImageDataSource(loader: loader)
    }

    @discardableResult
    public func setImage(
        in imageView: UIImageView,
        from urlString: String?,
        options: ImageOptions = .init()
    ) -> ImageLoadToken? {
        guard let s = urlString, let url = URL(string: s) else {
            if let ph = options.placeholder {
                imageView.image = ph
            }
            return nil
        }
        return setImage(in: imageView, from: url, options: options)
    }

    @discardableResult
    public func setImage(
        in imageView: UIImageView,
        from url: URL,
        options: ImageOptions = .init()
    ) -> ImageLoadToken {
        if let ph = options.placeholder {
            imageView.image = ph
        }

        let token = ImageLoadToken()
        print("▶️ IMG req url:\(url.absoluteString)")
        token.task = Task { [weak imageView, loader] in
            do {
                let data = try await loader.load(from: url)
                guard !Task.isCancelled, let image = UIImage(data: data) else {
                    print("🟡 IMG cancelled/invalid url:\(url)")
                    return
                }
                try Task.checkCancellation()

                await MainActor.run {
                    guard let iv = imageView else { return }
                    switch options.transition {
                    case .none:
                        iv.image = image
                    case .fade(let duration):
                        UIView.transition(with: iv,
                                          duration: duration,
                                          options: .transitionCrossDissolve) {
                            iv.image = image
                            print("✅ IMG set url:\(url)")
                        }
                    }
                }
            } catch {
                print("❌ IMG error [\(error.localizedDescription)] url:\(url)")
            }
        }
        return token
    }
}
