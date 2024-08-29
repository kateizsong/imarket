//
//  MyItemsView.swift
//  iMarket
//
//  Created by Kate Song on 8/27/24.
//

import Foundation

import SwiftUI

struct MyItemsView: View {
    @EnvironmentObject var cartManager: CartManager
    @State private var favoritedProducts = [Product]()

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(favoritedProducts) { product in
                        ProductRow(product: product, cartManager: cartManager)
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("My Items")
            .task {
                await fetchFavoritedProducts()
            }
        }
    }

    func fetchFavoritedProducts() async {
        do {
            let allProducts = try await ProductService.shared.fetchProducts()
            favoritedProducts = allProducts.filter { product in cartManager.isFavorited(product) }
        } catch {
            print("Error fetching favorited products: \(error)")
        }
    }
}

struct MyItemsView_Previews: PreviewProvider {
    static var previews: some View {
        MyItemsView()
            .environmentObject(CartManager())
    }
}
