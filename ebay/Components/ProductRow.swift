//
//  ProductRow.swift
//  ebay
//
//  Created by Daniel Tong on 11/18/23.
//

import SwiftUI
import Kingfisher
import Alamofire

struct ProductRow: View {
    let item : Item
    var body: some View {
        
        HStack {
            VStack{
                if let url = URL(string: item.galleryURL[0]) {
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
                Text(item.title[0])
                    .font(.headline)
                    .lineLimit(1)
                    .fontWeight(.regular)
                    .padding(.vertical, 1.0)
                Text("$\(item.sellingStatus[0].currentPrice[0].__value__)")
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundColor(Color.blue)
                    .padding(.vertical, 1.0)
                if item.shippingInfo[0].shippingServiceCost[0].__value__ == "0.0" {
                    Text("FREE SHIPPING")
                        .font(.callout)
                        .foregroundColor(Color.gray)
                        .padding(.vertical, 1.0)
                } else {
                    Text("$\(item.shippingInfo[0].shippingServiceCost[0].__value__)")
                        .font(.callout)
                        .foregroundColor(Color.gray)
                        .padding(.vertical, 1.0)
                }
                HStack {
                    Text(item.postalCode[0])
                        .font(.callout)
                    Spacer()
                    Text(item.condition?.first?.conditionDisplayName.first ?? "NA")
                        .font(.callout)
                        .padding(.trailing, -4.0)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .textCase(.uppercase)
                }.foregroundColor(Color.gray)
            }
            VStack{
                HStack{
                    WishlistButtonView(item : item, calledFromDetails : false)
                        .padding(.leading, -2.0)
                }
            }
        }
    }
}
