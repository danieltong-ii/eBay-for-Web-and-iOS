//
//  ProductModel.swift
//  ebay
//
//  Created by Daniel Tong on 11/19/23.
//

import Foundation

struct Product: Codable {
    let findItemsAdvancedResponse: [FindItemsAdvancedResponse]
}

struct FindItemsAdvancedResponse: Codable {
    let searchResult: [SearchResult]
}

struct SearchResult: Codable {
    let item: [Item]?
    let count : String
    
    enum CodingKeys: String, CodingKey {
        case item
        case count = "@count"
    }
}


struct Item: Codable, Identifiable {
    var itemId : [String]
    var title : [String]
    var galleryURL: [String]
    var postalCode : [String]
    var storeInfo: [StoreInfo]?
    var sellerInfo: [Sellerinfo]?
    let shippingInfo : [ShippingInfo]
    let sellingStatus: [SellingStatus]
    let condition: [Condition]?
    var viewItemURL : [String]
    
    var id: Int {
        return Int(itemId[0]) ?? 0
    }
}

struct StoreInfo : Codable {
    var storeName : [String]
    var storeURL : [String]
}

struct Sellerinfo: Codable {
    var feedbackScore : [String]
    var positiveFeedbackPercent : [String]
}

struct Condition : Codable {
    var conditionDisplayName : [String]
}


struct SellingStatus : Codable {
    let currentPrice : [CurrentPrice]
}

struct CurrentPrice : Codable {
    let __value__ : String
}

struct ShippingInfo: Codable {
    let shippingServiceCost : [ShippingServiceCost]
}

struct ShippingServiceCost: Codable {
    var __value__ : String
}


let exampleCurrentPrice = CurrentPrice(__value__: "19.99")
let exampleShippingServiceCost = ShippingServiceCost(__value__: "5.00")

let exampleShippingInfo = ShippingInfo(shippingServiceCost: [exampleShippingServiceCost])
let exampleSellingStatus = SellingStatus(currentPrice: [exampleCurrentPrice])
let exampleCondition = Condition(conditionDisplayName: ["New", "Brand New"])



//let exampleItem = Item(
//    itemId: ["1234567890"],
//    title: ["Example Item 123123123242342342342342343242343123123"],
//    galleryURL: ["https://example.com/image.jpg"],
//    postalCode: ["12345"],
//    shippingInfo: [exampleShippingInfo],
//    sellingStatus: [exampleSellingStatus],
//    condition: [exampleCondition]
//)
