//
//  Model.swift
//  iMarket
//
//  Created by Kate Song on 8/27/24.
//

import Foundation

struct Product: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let discountPercentage: Double?
    let rating: Double?
    let stock: Int?
    let brand: String?
    let category: String?
    let thumbnail: String?
    let images: [String]?

    enum CodingKeys: String, CodingKey {
        case id, title, description, price, discountPercentage, rating, stock, brand, category, thumbnail, images
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        price = try container.decode(Double.self, forKey: .price)
        discountPercentage = try container.decodeIfPresent(Double.self, forKey: .discountPercentage)
        rating = try container.decodeIfPresent(Double.self, forKey: .rating)
        stock = try container.decodeIfPresent(Int.self, forKey: .stock)
        brand = try container.decodeIfPresent(String.self, forKey: .brand)
        category = try container.decodeIfPresent(String.self, forKey: .category)
        thumbnail = try container.decodeIfPresent(String.self, forKey: .thumbnail)
        images = try container.decodeIfPresent([String].self, forKey: .images)
    }
}

struct ProductResponse: Codable {
    let products: [Product]
    let total: Int
    let skip: Int
    let limit: Int
}

enum ProductError: Error { 
    case invalidURL
    case invalidResponse
    case invalidData
    case networkError(Error)
    case decodingError(Error)
}
