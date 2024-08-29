//
//  ProductService.swift
//  iMarket
//
//  Created by Kate Song on 8/27/24.
//

import Foundation

class ProductService {
    static let shared = ProductService()
    
    private init() {}
    
    func fetchProducts() async throws -> [Product] {
        guard let url = URL(string: "https://dummyjson.com/products") else {
            throw ProductError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
      
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw ProductError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder() 
            let productResponse = try decoder.decode(ProductResponse.self, from: data)
            return productResponse.products
        } catch {
            throw ProductError.decodingError(error)
        }
    }
}
