//
//  SingleItemManager.swift
//  ebay
//
//  Created by Daniel Tong on 11/21/23.
//

import Foundation
import Alamofire


struct SingleItemManager {
    var itemID : String
    
    func fetchSingleEbayItem() async throws -> SingleItemModel {
        let url = "https://cs571-hw3-404504.wl.r.appspot.com/api/singleitem"
        var params = ["ItemId" : itemID]
        print("inside fetchSingleEbayItem")
        
        let task = try await AF.request(url, parameters: params).serializingDecodable(SingleItemModel.self)
        print(task)
        let response = await task.response
        print(response)
        let result = await task.result
        print(result)
        let value = try await task.value
        print(value)
        return value
        

//        print(singleItem)
//        
//        return singleItem;
    }
}


