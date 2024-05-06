//
//  WishlistButtonModel.swift
//  ebay
//
//  Created by Daniel Tong on 11/21/23.
//

import Foundation
import Alamofire

class WishlistButtonManager {
    var item : Item
    var isInWishlist : Bool
    
    init(item : Item){
        self.item = item
        self.isInWishlist = false
    }
    
    
    func checkIfInWishlist() async throws -> Void {
        let url = "https://cs571-hw3-404504.wl.r.appspot.com/api/wishlist_query"
        let params = ["ItemId" : item.itemId[0]]
        
        isInWishlist = try await AF.request(url, parameters: params).serializingDecodable(Bool.self).value
        print("inside check if in wishlist, value is \(isInWishlist)")
    }
        
    
    func removeFromWishlist() {
        let url = "https://cs571-hw3-404504.wl.r.appspot.com/api/wishlist_delete"
        let params = ["ItemId" : item.itemId[0]]
        AF.request(url, parameters: params).responseString { response in
                print(response)
            }
        }
    func addToWishlist() {
        let url = "https://cs571-hw3-404504.wl.r.appspot.com/api/wishlist_insert"
        var conditionDisplayName : String = ""
        
        if let conditions = item.condition {
            if let firstCondition = conditions.first {
                conditionDisplayName = firstCondition.conditionDisplayName.first ?? "NA"
            }
        }
        
        let params = [
            "ItemId" : item.itemId[0],
            "image_url" : item.galleryURL[0],
            "title" : item.title[0],
            "price" : item.sellingStatus[0].currentPrice[0].__value__,
            "shipping" : item.shippingInfo[0].shippingServiceCost[0].__value__,
            "zipcode" : item.postalCode[0],
            "condition" : conditionDisplayName
        ]
    
        AF.request(url, parameters: params).responseString { response in
            print(response)
        }
    }
    
    
}
