//
//  ItBookAPIErrorMapper.swift
//  Infra
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import Foundation

enum ItBookAPIErrorMapper {
    static func map(_ error: Error) -> Error {
        guard let net = error as? NetworkError else { return error }

        switch net {
        case let .statusCode(status, data):
            if let data, let code = extractErrorCode(from: data) {
                return ItBookAPIError.platform(code: code, message: nil)
            } else {
                return ItBookAPIError.unknown(statusCode: status)
            }

        default:
            return net
        }
    }

    private static func extractErrorCode(from data: Data) -> Int? {
        guard let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return nil
        }
        if let s = obj["error"] as? String, let code = Int(s) { return code }
        if let n = obj["error"] as? NSNumber { return n.intValue }
        if let i = obj["error"] as? Int { return i }
        return nil
    }
}
