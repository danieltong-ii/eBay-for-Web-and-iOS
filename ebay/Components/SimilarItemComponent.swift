//
//  SimilarItemComponent.swift
//  ebay
//
//  Created by Daniel Tong on 12/6/23.
//

import SwiftUI
import Kingfisher

struct SimilarItemComponent: View {
    var item : SimilarItem
    @State private var timeLeftString : String?
    let manager = SimilarProductManager()
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 21)
                .stroke(Color(red: 196 / 255, green: 196 / 255, blue: 196 / 255), lineWidth: 2)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(red: 245 / 255, green: 245 / 255, blue: 245 / 255)))
                .frame(width: 170, height: 300)
            VStack {
                KFImage(URL(string: item.imageURL)!)
                    .resizable()
                    .frame(width: 155, height: 155) // Adjust width and height as needed
                    .scaledToFit()
                    .cornerRadius(10)
                    .padding(.bottom, 10)
                VStack(spacing: 4) {
                    Text(item.title)
                        .font(.subheadline)
                        .lineLimit(2)
                    HStack {
                        Text("$\(item.shippingCost.value)")
                            .foregroundColor(.gray)
                            .font(.caption2) // Makes the text grey
                        Spacer()
                        if let timeLeftString = timeLeftString {
                            Text(timeLeftString)
                                .foregroundColor(.gray)
                                .font(.caption2) // Makes the text grey
                        }
                    }
                }.padding(5)
                HStack {
                    Spacer()
                    Text("$\(item.buyItNowPrice.value)")
                        .foregroundColor(.blue)
                        .fontWeight(.bold)
                        .padding(8)
                }
            }
            .frame(width: 160, height: 290)
            .onAppear {
                let timeLeftInt = manager.extractTimeLeft(item: item)
                if timeLeftInt == 1 {
                    timeLeftString = "1 day left"
                    
                } else {
                    timeLeftString = "\(timeLeftInt) days left"
                }
            }
        }
    }
}
