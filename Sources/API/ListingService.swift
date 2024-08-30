//
//  ListingService.swift
//  ClassifiedApp
//
//  Created by Muhammad Nouman on 30/08/2024.
//

import Foundation
import Combine

protocol ListingHandler {
    func getList() -> AnyPublisher<[ListingMdl], ClassifiedError>
}

class ListingService: ListingHandler {
    func getList() -> AnyPublisher<[ListingMdl], ClassifiedError> {
        ListingAPI.getList().mapClassError()
    }
}
