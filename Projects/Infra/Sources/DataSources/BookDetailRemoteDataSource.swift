//
//  BookDetailRemoteDataSource.swift
//  Infra
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import Foundation
import Domain

public protocol BookDetailRemoteDataSource {
    func fetchBookDetail(_ isbn13: String) async throws -> ItBookBookDetailDTO
}

public final class BookDetailRemoteDataSourceImpl: BookDetailRemoteDataSource {
    private let client: NetworkClient
    public init(client: NetworkClient) { self.client = client }

    public func fetchBookDetail(_ isbn13: String) async throws -> ItBookBookDetailDTO {
        do {
            let dto: ItBookBookDetailDTO = try await client.request(
                ItBookAPIEndpoint.detail(isbn13: isbn13),
                as: ItBookBookDetailDTO.self,
                decoder: .init()
            )

            if let code = Int(dto.error), code != 0 {
                throw ItBookAPIError.platform(code: code, message: nil)
            }
            return dto
        } catch {
            throw ItBookAPIErrorMapper.map(error)
        }
    }
}
