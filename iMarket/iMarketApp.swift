//
//  iMarketApp.swift
//  iMarket
//
//  Created by Kate Song on 8/27/24.
//

import SwiftUI

@main // main entry point of the app
struct iMarketApp: App {
    @StateObject private var cart = Cart()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                ProductsView()
                    .tabItem {
                        Image(systemName: "carrot")
                        Text("Products")
                    }
                
                MyItemsView()
                    .tabItem {
                        Image(systemName: "heart.fill")
                        Text("My Items")
                    }
                
                CartView()
                    .tabItem {
                        Image(systemName: "cart")
                        Text("Cart")
                    }
            }
            .environmentObject(cart) 
        }
    }
}
