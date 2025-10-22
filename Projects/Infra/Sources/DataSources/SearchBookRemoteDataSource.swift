//
//  SearchBookRemoteDataSource.swift
//  Infra
//
//  Created by 일하는석찬 on 10/22/25.
//  Copyright © 2025 annyeongjelly. All rights reserved.
//

import Foundation
import Domain

public protocol SearchBookRemoteDataSource {
    func searchBooks(_ request: SearchRequest) async throws -> ItBookSearchResponseDTO
}

public final class SearchBookRemoteDataSourceImpl: SearchBookRemoteDataSource {
    
    private let client: NetworkClient
    
    public init(client: NetworkClient) {
        self.client = client
    }

    public func searchBooks(_ request: SearchRequest) async throws -> ItBookSearchResponseDTO {
        do {
            let dto: ItBookSearchResponseDTO = try await client.request(
                ItBookAPIEndpoint.search(request: request),
                as: ItBookSearchResponseDTO.self,
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
