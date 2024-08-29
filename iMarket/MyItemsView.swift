//
//  MyItemsView.swift
//  iMarket
//
//  Created by Kate Song on 8/27/24.
//

import Foundation

import SwiftUI

struct MyItemsView: View {
    @EnvironmentObject var cart: Cart
    @State private var favoritedProducts = [Product]()

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(favoritedProducts) { product in
                        ProductRow(product: product, cart: cart)
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
            let allProducts = try await Network.shared.fetchProducts()
            favoritedProducts = allProducts.filter { product in cart.isFavorited(product) }
        } catch {
            print("Error fetching favorited products: \(error)")
        }
    }
}

struct MyItemsView_Previews: PreviewProvider {
    static var previews: some View {
        MyItemsView()
            .environmentObject(Cart())
    }
}
