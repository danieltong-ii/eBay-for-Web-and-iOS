//
//  ShippingView.swift
//  ebay
//
//  Created by Daniel Tong on 11/22/23.
//

import SwiftUI

struct ShippingView: View {
    var item : Item
    @State private var singleItem : SingleItemModel?
    
    let columns: [GridItem] = [
           GridItem(.flexible(), spacing: 0),
           GridItem(.flexible(), spacing: 0)
        ]

    
    var body: some View {
        NavigationStack {
            if let singleItem = singleItem {
                VStack(alignment: .leading, spacing: 4) {
                    Divider()
                    HStack {
                        Image(systemName: "storefront")
                        Text("Seller")
                    }
                    Divider()
                }
                VStack(spacing: 4) {
                    LazyVGrid(columns: columns) {
                        Text("Store Name")
                        // store name
                        if let storeInfoArray = item.storeInfo,
                           let storeNameFirst = storeInfoArray.first?.storeName.first {
                            if let storeURL = storeInfoArray.first?.storeURL.first {
                                Link(storeNameFirst,
                                     destination: URL(string: storeURL)!)
                            }
                        }
                        //
                        Text("Feedback Score")
                        if let sellerInfoArray = item.sellerInfo,
                           let sellerfeedbackScore = sellerInfoArray.first?.feedbackScore.first {
                            Text(sellerfeedbackScore)
                        }
                        Text("Popularity")
                        if let sellerInfoArray = item.sellerInfo,
                           let positiveFeedbackPercent = sellerInfoArray.first?.positiveFeedbackPercent.first {
                            Text(positiveFeedbackPercent)
                        }
                    }
                }

                VStack(alignment: .leading) {
                    Divider()
                    HStack {
                        Image(systemName: "sailboat")
                        Text("Shipping Info")
                    }
                    Divider()
                }
                LazyVGrid(columns: columns) {
                    Text("Shipping Cost")
                    var shippingCost = item.shippingInfo[0].shippingServiceCost[0].__value__
                    if shippingCost == "0.0" {
                        Text("Free")
                    } else {
                        Text(shippingCost)
                    }
                    Text("Global Shipping")
                    var globalShipping : Bool = singleItem.Item.GlobalShipping
                    if globalShipping {
                        Text("Yes")
                    } else {
                        Text("No")
                    }
                    Text("Handling Time")
                    var handlingTime = singleItem.Item.HandlingTime
                    Text("\(handlingTime) day\(handlingTime == 1 ? "" : "s")")
                }
                
                if singleItem.Item.ReturnPolicy.ReturnsAccepted != nil ||
                   singleItem.Item.ReturnPolicy.Refund != nil ||
                   singleItem.Item.ReturnPolicy.ReturnsWithin != nil ||
                   singleItem.Item.ReturnPolicy.ShippingCostPaidBy != nil {

                    VStack(alignment: .leading) {
                        Divider()
                        HStack {
                            Image(systemName: "return")
                            Text("Return Policy")
                        }
                        Divider()
                    }
                }

                LazyVGrid(columns: columns) {
                    if let returnsAccepted = singleItem.Item.ReturnPolicy.ReturnsAccepted {
                        Text("Policy")
                        Text(returnsAccepted)
                    }
                    
                    if let refundMode = singleItem.Item.ReturnPolicy.Refund {
                        Text("Refund Mode")
                        Text(refundMode)
                    }
                    
                    if let refundWithin = singleItem.Item.ReturnPolicy.ReturnsWithin {
                        Text("Refund Within")
                        Text(refundWithin)
                    }
                    
                    if let shippingCostPaidBy = singleItem.Item.ReturnPolicy.ShippingCostPaidBy {
                        Text("Shipping Cost Paid By")
                        Text(shippingCostPaidBy)
                    }
                }

                Spacer()

            } else {
                ProgressView()
            }
        }.task {
            do {
                let singleItemManager = SingleItemManager(itemID: item.itemId[0])
                singleItem = try await singleItemManager.fetchSingleEbayItem()
            } catch {
                print("error in infoview")
            }
        }

    }
}
