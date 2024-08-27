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
    
    var body: some View {
        VStack(spacing: 0) {
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("What are you looking for?", text: $searchText)
            }
            .padding()
            .background(Color(.systemGray6))
            
            // Product list
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(products) { product in
                        ProductRow(product: product)
                    }
                }
                .padding(.horizontal)
            }
            
            // Tab bar
            HStack {
                Spacer()
                TabBarItem(imageName: "carrot", text: "Products")
                Spacer()
                TabBarItem(imageName: "heart", text: "My Items")
                Spacer()
                TabBarItem(imageName: "cart", text: "Cart")
                Spacer()
            }
            .padding(.top, 8)
            .background(Color.white)
            .shadow(color: .gray.opacity(0.2), radius: 4, y: -2)
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
}

struct ProductRow: View {
    let product: Product
    
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
                Text("$\(String(format: "%.2f", product.price))")
                    .font(.headline)
                Text(product.category ?? "")
                    .font(.caption)
                    .padding(.vertical, 3)
                    .padding(.horizontal, 5)
                    .foregroundColor(.white)
                    .background(Color.gray)
                    .cornerRadius(5)
                HStack {
                    Button(action: {}) {
                        Text("Add to Cart")
                            .font(.subheadline)
                            .padding(.horizontal, 36)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .padding(.top, 5)
                    }
                    Button(action: {}) {
                        Image(systemName:"heart")
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

struct TabBarItem: View {
    let imageName: String
    let text: String
    
    var body: some View {
        VStack {
            Image(systemName: imageName)
            Text(text)
                .font(.caption)
        }
    }
}

struct ProductsView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsView()
    }
}
