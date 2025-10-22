//
//  ImageDataLoader.swift
//  CoreKit
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import Foundation

public protocol ImageDataLoader {
    func load(from url: URL) async throws -> Data
}
