//
//  SingleItemModel.swift
//  ebay
//
//  Created by Daniel Tong on 11/21/23.
//

import Foundation

struct SingleItemModel : Codable {
    var Item : Item_Single
    
}

struct Item_Single : Codable {
    var ItemID : String
    var Title : String
    var PictureURL : [String]
    var CurrentPrice : CurrentPrice_Single
    var ItemSpecifics : ItemSpecifics
    var GlobalShipping : Bool
    var HandlingTime : Int
    var ReturnPolicy : ReturnPolicy
}

struct ReturnPolicy: Codable {
    var ReturnsAccepted: String?
    var Refund: String?
    var ReturnsWithin: String?
    var ShippingCostPaidBy: String?
}

struct ItemSpecifics : Codable, Hashable {
    var NameValueList : [NameValueList]
}

struct NameValueList : Codable, Hashable {
    var Name : String
    var Value : [String]
}

struct CurrentPrice_Single : Codable {
    var Value : Double
}
