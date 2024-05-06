//
//  DetailedView.swift
//  ebay
//
//  Created by Daniel Tong on 11/20/23.
//

import SwiftUI

struct DetailedView: View {
    var item : Item
    var url : String
    
    init(item : Item) {
        self.item = item
        self.url = "https://www.facebook.com/sharer/sharer.php?u=\(self.item.viewItemURL[0])"
    }
    
    var body: some View {
        TabView {
            InfoView(item : item)
                .tabItem {
                    Label("Info", systemImage: "info.circle.fill")
                }
            ShippingView(item: item)
                .tabItem {
                    Label("Shipping", systemImage: "shippingbox.fill")
                }
            PhotosView(item: item)
                .tabItem {
                    Label("Photos", systemImage: "photo.stack")
                }
            SimilarView(item: item)
                .tabItem {
                    Label("Similar", systemImage: "list.bullet.indent")
                }
            
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Link(destination: URL(string: self.url)!) {
                    Image("facebookIcon").resizable().scaledToFit().frame(width: 25, height: 25)
                }
                WishlistButtonView(item : item, calledFromDetails : true)
            }
        }
    }
}
