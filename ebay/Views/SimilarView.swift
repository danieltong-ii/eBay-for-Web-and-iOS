//
//  SimilarView.swift
//  ebay
//
//  Created by Daniel Tong on 12/6/23.
//

import SwiftUI

struct SimilarView: View {
    var item : Item
    let manager = SimilarProductManager()
    let columns = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15),
    ]
    
    enum sortTypes: String, CaseIterable, Identifiable {
        case Default, Name, Price, DaysLeft, Shipping
        var id: Self {self}
    }
    
    @State private var selectedSortBy: String = "default"
    @State private var selectedOrder: String = "ascending"
    @State private var similarItemsArray : [SimilarItem]?
    @State private var defaultArray : [SimilarItem]?
    @State private var isLoading : Bool = true
    
    
    var body: some View {
        NavigationStack{
            if isLoading {
                VStack {
                    ProgressView()
                }
            } else {
                ZStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Sort by")
                                .font(.title3)
                                .fontWeight(.heavy)
                                .padding(.top, 110)
                            Spacer()
                        }.padding(.leading)
                        VStack {
                            Picker("Sort", selection: $selectedSortBy) {
                                Text("Default").tag("default")
                                Text("Name").tag("name")
                                Text("Price").tag("price")
                                Text("Days Left").tag("daysleft")
                                Text("Shipping").tag("shipping")
                            }
                            .pickerStyle(.segmented)
                            .onChange(of: selectedSortBy) {
                                if selectedSortBy != "default" {
                                    if let similarItemsArrayUnwrapped = similarItemsArray {
                                        self.similarItemsArray = manager.sort(sort_by: selectedSortBy, order: selectedOrder, array: similarItemsArrayUnwrapped)
                                    }
                                } else {
                                    similarItemsArray = defaultArray
                                    selectedOrder = "ascending"
                                }
                            }
                        }.padding(EdgeInsets(top: 4, leading: 13, bottom: 10, trailing: 13))
                        if selectedSortBy != "default" {
                            HStack {
                                Text("Order")
                                    .font(.title3)
                                    .fontWeight(.heavy)
                                    .padding(.top, 10)
                                Spacer()
                            }.padding(.leading)
                            VStack {
                                Picker("Order", selection: $selectedOrder) {
                                    Text("Ascending").tag("ascending")
                                    Text("Descending").tag("descending")
                                }
                                .pickerStyle(.segmented)
                                .onChange(of: selectedOrder) {
                                    if selectedSortBy != "default" {
                                        if let similarItemsArrayUnwrapped = similarItemsArray {
                                            self.similarItemsArray = manager.sort(sort_by: selectedSortBy, order: selectedOrder, array: similarItemsArrayUnwrapped)
                                        }
                                    } else {
                                        similarItemsArray = defaultArray
                                        selectedOrder = "ascending"
                                    }
                                }
                            }.padding(EdgeInsets(top: 4, leading: 13, bottom: 10, trailing: 13))
                        }
                        VStack{
                                if let similarItemsArray = similarItemsArray {
                                    ScrollView {
                                        LazyVGrid(columns: columns) {
                                            ForEach(similarItemsArray) { item in
                                                SimilarItemComponent(item : item)
                                            }
                                        }
                                    }
                                }
                        }.padding(1)

                    }

                    }.edgesIgnoringSafeArea(.top)
                }
        }.onAppear {
            Task {
                do {
                    print("Current ItemdID:")
                    print(item.itemId[0])
              
                    similarItemsArray = try await manager.fetchSimilar(query : item.itemId[0])
                    
                    if let similarItemsArray = similarItemsArray {
                        defaultArray = similarItemsArray
                    }
           
                    isLoading = false;
                    if let similarItemsArray = similarItemsArray {
                        print(similarItemsArray)
                    }
                } catch {
                    // Handle the error, e.g., show an alert or log the error
                    print("Error while fetching similar products: \(error)")
                }
        
            }
        }
    }
}

