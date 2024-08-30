//
//  ContentView.swift
//  ClassifiedApp
//
//  Created by Muhammad Nouman on 30/08/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ListingsViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(viewModel.listings) { listing in
                        ListingCell(listing: listing)
                    }
                }
            }
            .navigationTitle("Classifieds")
            .onAppear {
                viewModel.fetchListings()
            }
        }
    }
}

#Preview {
    ContentView()
}
