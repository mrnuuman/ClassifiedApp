//
//  ListingCell.swift
//  ClassifiedApp
//
//  Created by Muhammad Nouman on 30/08/2024.
//
import SwiftUI
import SDWebImageSwiftUI

struct ListingCell: View {
    let listing: ListingMdl

    var body: some View {
        HStack {
            imageView
            VStack(alignment: .leading, spacing: 4) {
                nameView
                priceView
                dateView
            }
            .padding(.leading, 8)
        }
        .padding()
    }
    
    var imageView: some View {
        WebImage(url: URL(string: listing.imageUrls?.first ?? ""))
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 100, height: 100)
            .clipped()
            .cornerRadius(5)
    }
    
    var placeholderImage: some View {
        Image(uiImage: UIImage(named: "")!)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100)
            .cornerRadius(5)
    }
    
    var nameView: some View {
        Text(listing.name ?? "")
            .font(.headline)
            .foregroundColor(.primary)
    }
    
    var priceView: some View {
        Text(listing.price ?? "")
            .font(.subheadline)
            .foregroundColor(.secondary)
    }
    
    var dateView: some View {
        Text(listing.createdAt ?? "")
            .font(.subheadline)
            .foregroundColor(.secondary)
    }
}
