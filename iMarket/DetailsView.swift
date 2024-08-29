//
//  DetailsView.swift
//  iMarket
//
//  Created by Kate Song on 8/28/24.
//

import Foundation
import SwiftUI

struct DetailsView: View {
    let product: Product
    @EnvironmentObject var cartManager: CartManager
    @State private var isAddedToCart = false

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                Text(product.title)
                    .font(.title)
                    .padding()

                HStack {
                    ForEach(0..<5) { index in
                        Image(systemName: index < Int(product.rating ?? 0) ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                    }
                    Text("(\(product.reviews?.count ?? 0) reviews)")
                        .foregroundColor(.secondary)
                }

                AsyncImage(url: URL(string: product.images?.first ?? "")) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Color.gray
                }
                .frame(height: 300)
                .cornerRadius(12)

                Text("$\(String(format: "%.2f", product.price))")
                    .font(.title2)
                    .fontWeight(.bold)

                HStack {
                    Text(product.stock ?? 0 > 0 ? "In Stock" : "Out of Stock")
                        .foregroundColor(product.stock ?? 0 > 0 ? .green : .red)
                        .underline()
                    Text("at Chapel Hill")
                }

                HStack(spacing: 20) {
                    Button(action: {
                        cartManager.addToCart(product)
                        isAddedToCart = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            isAddedToCart = false
                        }
                    }) {
                        Text("Add to Cart")
                            .padding()
                            .background(isAddedToCart ? Color.blue.opacity(0.7) : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        cartManager.toggleFavorite(product)
                    }) {
                        Image(systemName: cartManager.isFavorited(product) ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                            .frame(width: 44, height: 44)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(Circle())
                    }
                }

                Text("Description")
                    .font(.headline)
                    .padding(.top)
                Text(product.description)
                    .padding(.horizontal)

                Text("Reviews")
                    .font(.headline)
                    .padding(.top)

                ForEach(product.reviews ?? [], id: \.reviewerEmail) { review in
                    ReviewRow(review: review)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ReviewRow: View {
    let review: Review

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                ForEach(0..<5) { index in
                    Image(systemName: index < review.rating ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                }
                Text(review.reviewerName)
                    .font(.subheadline)
                Spacer()
                Text(formatDate(review.date))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Text(review.comment)
                .font(.body)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }

    func formatDate(_ dateString: String) -> String {
        // Implement date formatting logic here
        return dateString
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(product: Product(id: 1, title: "Sample Product", description: "This is a sample product description.", price: 19.99, discountPercentage: 10, rating: 4.5, stock: 50, brand: "Sample Brand", category: "Electronics", thumbnail: "", images: [], reviews: []))
            .environmentObject(CartManager())
    }
}
