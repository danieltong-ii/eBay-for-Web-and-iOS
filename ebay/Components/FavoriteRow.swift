//
//  FavoriteView.swift
//  ebay
//
//  Created by Daniel Tong on 11/20/23.
//

import SwiftUI
import Kingfisher

struct FavoriteRow: View {
    var favorite : Favorite
    
    var body: some View {
        HStack {
            VStack{
                if let url = URL(string: favorite.image_url) {
                    KFImage(url)
                        .resizable() // Makes the image resizable
                        .aspectRatio(contentMode: .fill) // Keeps the aspect ratio and fits the content within the frame
                        .frame(width: 80, height: 80) // Sets the frame of the image
                        .clipShape(RoundedRectangle(cornerRadius: 8.0)) // Clips the image to a rounded rectangle shape
                } else {
                    Text("Invalid URL")
                }
            }
            VStack(alignment: .leading) {
                Text(favorite.title)
                    .font(.headline)
                    .lineLimit(1)
                    .fontWeight(.regular)
                    .padding(.vertical, 1.0)
                Text("$\(favorite.price)")
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundColor(Color.blue)
                    .padding(.vertical, 1.0)
                if favorite.shipping == "0.0" {
                    Text("FREE SHIPPING")
                        .font(.callout)
                        .foregroundColor(Color.gray)
                        .padding(.vertical, 1.0)
                } else {
                    Text("$\(favorite.shipping)")
                        .font(.callout)
                        .foregroundColor(Color.gray)
                        .padding(.vertical, 1.0)
                }
                HStack {
                    Text(favorite.zipcode)
                        .font(.callout)
                    Spacer()
                    Text(favorite.condition.uppercased())
                        .font(.callout)
                        .padding(.trailing, -4.0)
                        
                }.foregroundColor(Color.gray)
            }
        }
    }
}

