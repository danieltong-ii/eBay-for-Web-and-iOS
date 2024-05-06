//
//  ProductSearchParams.swift
//  ebay
//
//  Created by Daniel Tong on 11/19/23.
//

import Foundation

struct ProductSearchParams : Encodable {
    let keywords : String
    let buyerPostalCode : String
    let categoryId : String
    let condition_new : Int
    let condition_used : Int
    let LocalPickupOnly : Int
    let FreeShippingOnly : Int
    let MaxDistance : Int
}
