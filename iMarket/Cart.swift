//
//  Cart.swift
//  iMarket
//
//  Created by Kate Song on 8/27/24.
//

import Foundation


class Cart: ObservableObject {
    @Published var items = [CartItem]()
    @Published var favoritedItems: Set<Int> = []
    
    var subtotal: Double {
        items.reduce(0) { current, item in
            current + item.product.price
        }
    }
    
    var savings: Double {
        items.reduce(0) { current, item in
            current + (item.product.discountPercentage ?? 0) / 100 * item.product.price
        }
    }
    
    var taxes: Double {
        (subtotal - savings) * 0.05
    }
    
    var total: Double {
        subtotal - savings + taxes
    }
    
    func addToCart(_ product: Product) {
        if let index = items.firstIndex(where: { item in item.product.id == product.id }) {
            items[index].quantity += 1
        } else {
            items.append(CartItem(product: product, quantity: 1))
        }
    }
    
    func removeFromCart(_ product: Product) {
        items.removeAll { item in item.product.id == product.id }
    }
    
    func toggleFavorite(_ product: Product) {
        if favoritedItems.contains(product.id) {
            favoritedItems.remove(product.id)
        } else {
            favoritedItems.insert(product.id)
        }
    }
    
    func isFavorited(_ product: Product) -> Bool { 
        favoritedItems.contains(product.id)
    }
    
}

struct CartItem: Identifiable {
    let id = UUID()
    let product: Product
    var quantity: Int
}
