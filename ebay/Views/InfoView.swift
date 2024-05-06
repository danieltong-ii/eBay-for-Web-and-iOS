//
//  InfoView.swift
//  ebay
//
//  Created by Daniel Tong on 11/21/23.
//

import SwiftUI
import Kingfisher

struct InfoView: View {
    var item : Item
    @State private var singleItem : SingleItemModel?
    @State private var isLoading : Bool = true
    let columns = [GridItem(.flexible(), spacing: 0),GridItem(.flexible(), spacing: 0)]
    
    init(item : Item) {
        self.item = item
        UIPageControl.appearance().currentPageIndicatorTintColor = .black
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
    }
    
    var body: some View {
        NavigationStack {
            if isLoading {
                ProgressView()
            } else {
                VStack {
                    TabView {
                        if let singleItem = singleItem {
                            ForEach(singleItem.Item.PictureURL, id: \.self) { pictureUrl in
                                KFImage(URL(string: pictureUrl)!)
                                    .resizable()
                                    .scaledToFit()
                                    .containerRelativeFrame(.horizontal)
                                
                            }
                        }
                    }
                }.tabViewStyle(PageTabViewStyle())
                .frame(minWidth: 0, maxHeight: 230, alignment: .topLeading)
                
                VStack(alignment: .leading) {
                    if let singleItem = singleItem {

                     
                        VStack(alignment : .leading) {
                            Text(singleItem.Item.Title)
                            .frame(alignment: .leading)
                                .font(.headline)
                                .fontWeight(.medium)
                                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                            
                            Text(String(format: "$%.2f", singleItem.Item.CurrentPrice.Value))
                                .frame(alignment: .leading)
                                .font(.callout)
                                .fontWeight(.bold)
                                .foregroundColor(Color.blue)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                           
                            HStack() {
                                Image(systemName: "magnifyingglass")
                                Text("Description")
                            }.frame(alignment: .leading)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                        }.padding(14)
                        .frame(alignment: .leading)

                        VStack(spacing: 0) {
                            ScrollView {
                                Divider().frame(minHeight: 1.2).overlay(Color.gray).padding(-0.2)

                                LazyVGrid(columns: columns) {
                                    ForEach(singleItem.Item.ItemSpecifics.NameValueList, id: \.self) { item in
                                        VStack(alignment: .leading, spacing: 0) {
                                            Text(item.Name)
                                                .padding([.top, .bottom], -3)
                                                .font(.headline)
                                                .fontWeight(.medium)
                                                .lineLimit(1)
                                                .truncationMode(.tail)
                                            Divider().frame(minHeight: 1).overlay(Color.gray).padding(-0.5)

                                        }
                                        VStack(alignment: .leading, spacing: 0) {
                                            Text(item.Value[0])
                                                .padding([.top, .bottom], -3)
                                                .font(.headline)
                                                .fontWeight(.medium)
                                                .lineLimit(1)
                                                .truncationMode(.tail)
                                            Divider().frame(minHeight: 1).overlay(Color.gray).padding(-0.1)
                                        }
                                    }
                                }
                            }
                        }.padding(14)
                    }
                    
                }

            }
        }.task {
            do {
                let singleItemManager = SingleItemManager(itemID: item.itemId[0])
                singleItem = try await singleItemManager.fetchSingleEbayItem()
                isLoading = false
            } catch {
                print("error in infoview")
            }
        }
    }
}
