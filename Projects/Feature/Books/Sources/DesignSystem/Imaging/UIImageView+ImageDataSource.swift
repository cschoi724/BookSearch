//
//  UIImageView+ImageDataSource.swift
//  Books
//
//  Created by 일하는석찬 on 10/25/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import UIKit

private enum AssocKey {
    @MainActor static var tokenKey: UInt8 = 0
    @MainActor static var tokenPtr: UnsafeRawPointer = withUnsafePointer(to: &AssocKey.tokenKey) {
        UnsafeRawPointer($0)
    }
}

public extension UIImageView {

    @MainActor
    @discardableResult
    func setImage(from urlString: String?, options: ImageOptions = .init()) -> ImageLoadToken? {
        cancelImageLoad()
        let token = ImageDataSource.shared.setImage(
            in: self,
            from: urlString,
            options: options
        )
        if let token {
            objc_setAssociatedObject(
                self,
                AssocKey.tokenPtr,
                token, .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
        return token
    }

    @MainActor
    @discardableResult
    func setImage(from url: URL, options: ImageOptions = .init()) -> ImageLoadToken {
        cancelImageLoad()
        let token = ImageDataSource.shared.setImage(
            in: self,
            from: url,
            options: options
        )
        objc_setAssociatedObject(
            self,
            AssocKey.tokenPtr,
            token, .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
        return token
    }

    @MainActor
    func cancelImageLoad() {
        if let token = objc_getAssociatedObject(self, AssocKey.tokenPtr) as? ImageLoadToken {
            token.cancel()
            objc_setAssociatedObject(
                self,
                AssocKey.tokenPtr,
                nil,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
}
