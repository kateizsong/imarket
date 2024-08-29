//
//  CartView.swift
//  iMarket
//
//  Created by Kate Song on 8/27/24.
//

import Foundation
import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartManager: CartManager
    @State private var deliveryMethod = "Pick up"
    @State private var location = "Chapel Hill"
    @State private var isExpanded = false
    
    var body: some View {
        NavigationView {
            ZStack {
                
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading) {
                        HStack {
                            Picker("Delivery Method", selection: $deliveryMethod) {
                                Text("Pick up").tag("Pick up")
                                Text("Delivery").tag("Delivery")
                            }
                            .pickerStyle(MenuPickerStyle())
                            .accentColor(.primary)
                            
                            Text("from")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text(location)
                                .underline()
                        }
                    }
                    .padding(9)
                    
                    List {
                        ForEach(cartManager.items) { item in
                            CartItemRow(item: item)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        cartManager.removeFromCart(item.product)
                                    } label: {
                                        Label("Remove", systemImage: "trash")
                                    }
                                }
                        }
                        .listRowInsets(EdgeInsets())
                    }
                    .listStyle(PlainListStyle())
                    
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("$\(String(format: "%.2f", cartManager.total)) total")
                                    .font(.headline)
                                Text("\(cartManager.items.count) items")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation {
                                isExpanded.toggle()
                            }
                        }
                        
                        if isExpanded {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Subtotal")
                                    Spacer()
                                    Text("$\(String(format: "%.2f", cartManager.subtotal))")
                                }
                                HStack {
                                    Text("Savings")
                                    Spacer()
                                    Text("-$\(String(format: "%.2f", cartManager.savings))")
                                        .foregroundColor(.green)
                                }
                                HStack {
                                    Text("Taxes")
                                    Spacer()
                                    Text("$\(String(format: "%.2f", cartManager.taxes))")
                                }
                            }
                            .padding(.top)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding()
                    
                    Button(action: {
                    }) {
                        Text("Check out")
                            .font(.title3)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(7)
                            .background(Color.blue)
                            .cornerRadius(50)
                    }
                    .padding()
                }
            }
            .navigationTitle("Cart")
        }
    }
}

struct CartItemRow: View {
    let item: CartItem
    
    var body: some View {
        HStack(spacing: 2) {
            AsyncImage(url: URL(string: item.product.thumbnail ?? "")) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 60, height: 60)
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.product.title)
                    .padding(10)
                    .font(.subheadline)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(width: 200, alignment: .leading) 
            }
            
            Spacer()
            
            Text("$\(String(format: "%.2f", item.product.price))")
                .font(.headline)
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
            .environmentObject(CartManager())
    }
}
