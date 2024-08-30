//
//  ListingsViewModel.swift
//  ClassifiedApp
//
//  Created by Muhammad Nouman on 30/08/2024.
//

import Foundation
import Combine

class ListingsViewModel: ObservableObject {
    @Published var listings: [ListingMdl] = []
    @Published var isLoading = false
    private var api = ListingService()
    private var disposables = Set<AnyCancellable>()
    
    func fetchListings() {
        self.isLoading = true
        api.getList()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard self != nil else { return }
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching listings: \(error)")
                }
            } receiveValue: { [weak self] list in
                self?.listings = list
            }
            .store(in: &disposables)
    }
}
