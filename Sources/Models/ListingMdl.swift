//
//  ListingMdl.swift
//  ClassifiedApp
//
//  Created by Muhammad Nouman on 30/08/2024.
//

import Foundation

public struct ListingsResponse: Codable {
    let results: [ListingMdl]
}

public struct ListingMdl: Codable, Identifiable {
    public let id = UUID()
    let uid: String?
    let name: String?
    let createdAt: String?
    let price: String?
    let imageIds: [String]?
    let imageUrls: [String]?
    let imageUrlsThumbnails: [String]?
    
    public init(uid: String? = nil, name: String? = nil, createdAt: String? = nil,
                price: String? = nil, imageIds: [String]? = nil,
                imageUrls: [String]? = nil, imageUrlsThumbnails: [String]? = nil) {
        self.uid = uid
        self.name = name
        self.createdAt = createdAt
        self.price = price
        self.imageIds = imageIds
        self.imageUrls = imageUrls
        self.imageUrlsThumbnails = imageUrlsThumbnails
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uid = try container.decodeIfPresent(String.self, forKey: .uid)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        self.price = try container.decodeIfPresent(String.self, forKey: .price)
        self.imageIds = try container.decodeIfPresent([String].self, forKey: .imageIds)
        self.imageUrls = try container.decodeIfPresent([String].self, forKey: .imageUrls)
        self.imageUrlsThumbnails = try container.decodeIfPresent([String].self, forKey: .imageUrlsThumbnails)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uid, forKey: .uid)
        try container.encode(name, forKey: .name)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(price, forKey: .price)
        try container.encode(imageIds, forKey: .imageIds)
        try container.encode(imageUrls, forKey: .imageUrls)
        try container.encode(imageUrlsThumbnails, forKey: .imageUrlsThumbnails)
    }
    
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case uid
        case name
        case createdAt = "created_at"
        case price
        case imageIds = "image_ids"
        case imageUrls = "image_urls"
        case imageUrlsThumbnails = "image_urls_thumbnails"
    }
}
