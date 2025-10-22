//
//  NetworkError.swift
//  Infra
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case statusCode(Int, Data?)
    case decoding(Error, Data)
    case transport(Error)
}
