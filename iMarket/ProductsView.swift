//
//  ProductsView.swift
//  iMarket
//
//  Created by Kate Song on 8/27/24.
//

import SwiftUI

struct ProductsView: View {
    @State private var products = [Product]()
    @State private var searchText = ""
    @State private var searchResults = [Product]()
    @EnvironmentObject var cartManager: CartManager

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("What are you looking for?", text: $searchText)
                    .onChange(of: searchText) { _ in
                        searchProducts()
                    }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(20)
            .padding()

            if !searchText.isEmpty {
                HStack {
                    Text("\(searchResults.count) results for")
                    Text("\"\(searchText)\"")
                        .bold()
                    Spacer()
                }
                .padding(.horizontal)
            }

            
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(searchText.isEmpty ? products : searchResults) { product in
                        ProductRow(product: product, cartManager: cartManager)
                    }
                }
                .padding(.horizontal)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .task {
            await fetchData()
        }
    }

    func fetchData() async {
        do {
            products = try await ProductService.shared.fetchProducts()
        } catch {
            print("Error fetching products: \(error)")
        }
    }

    func searchProducts() {
        if searchText.isEmpty {
            searchResults = products
        } else {
            searchResults = products.filter { product in
                product.title.lowercased().contains(searchText.lowercased())
            }
        }
    }
}

struct ProductRow: View {
    let product: Product
    @ObservedObject var cartManager: CartManager
    @State private var isAddedToCart = false

    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: product.thumbnail ?? "")) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 130, height: 130)
            .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text(product.title)
                    .font(.subheadline)
                    .lineLimit(1)
                
                
                if let discountPercentage = product.discountPercentage {
                    HStack {
                        Text("$\(String(format: "%.2f", product.price))")
                          .strikethrough()
                          .foregroundColor(.gray)
                        Text("$\(String(format: "%.2f", product.price * (1 - discountPercentage / 100)))")
                         .foregroundColor(.green)
                    }
                    .font(.headline)
                } else {
                    Text("$\(String(format: "%.2f", product.price))")
                        .font(.headline)
                }
                
                
                
                
    
                HStack {
                    Text(product.category?.capitalized ?? "")
                        .font(.caption)
                        .padding(.vertical, 3)
                        .padding(.horizontal, 5)
                        .foregroundColor(.white)
                        .background(Color.gray)
                        .cornerRadius(5)
                    
                    if product.stock ?? 0 <= 5 {
                        Text("Almost gone!")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
                
                
                
                HStack {
                    Button(action: {
                        cartManager.addToCart(product)
                        isAddedToCart = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            isAddedToCart = false
                        }
                    }) {
                        Text("Add to Cart")
                            .font(.subheadline)
                            .padding(.horizontal, 36)
                            .padding(.vertical, 8)
                            .background(isAddedToCart ? Color.blue.opacity(0.7) : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .padding(.top, 5)
                    }
                    Button(action: {
                        cartManager.toggleFavorite(product)
                    }) {
                        Image(systemName: cartManager.isFavorited(product) ? "heart.fill" : "heart")
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                            .background(Color.gray)
                            .clipShape(Circle()) 
                    }
                }
            }

            Spacer()
        }
        .padding(.vertical, 8)
    }
}

struct ProductsView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsView()
            .environmentObject(CartManager())
    }
}
