//
//  SimilarProductManager.swift
//  ebay
//
//  Created by Daniel Tong on 12/6/23.
//

import Foundation
import SwiftUI
import Alamofire



struct SimilarProductManager {
    let url = "https://cs571-hw3-404504.wl.r.appspot.com/api/similar"
    
    func fetchSimilar(query : String) async throws -> [SimilarItem] {
        let param = ["ItemId" : query]
        
        let response = try await AF.request(url, parameters: param).serializingDecodable(SimilarResponse.self)
        print(response)
        let similarProductsArray = try await response.value
        print("Similar Products array \(similarProductsArray)")
        return similarProductsArray.getSimilarItemsResponse.itemRecommendations.item
    }
    
    func extractTimeLeft(item : SimilarItem) -> Int {
        let timeLeft = item.timeLeft // Example string
        
        if let pIndex = timeLeft.range(of: "P")?.upperBound,
           let dIndex = timeLeft.range(of: "D")?.lowerBound {
            let daysString = String(timeLeft[pIndex..<dIndex])
            if let days = Int(daysString) { // Convert the extracted string to an integer
                if days == 1 {
                    return 1
                    
                } else {
                    return days
                    
                }
            } else {
                return 0
                print("Error: Days not found or invalid format")
            }
        } else {
            return 0
            print("Format not recognized")
        }
    }
    
    func sort(sort_by: String, order: String, array : [SimilarItem]) -> [SimilarItem]{
        switch(sort_by, order, array) {
            case ("name", "ascending", array):
                return array.sorted { $0.title < $1.title}
            case ("name", "descending", array):
                return array.sorted { $0.title > $1.title}
            case("price", "ascending", array):
                return array.sorted {
                    guard let price1 = Float($0.buyItNowPrice.value), let price2 = Float($1.buyItNowPrice.value) else {return false}
                    return price1 < price2
                }
            case ("price", "descending", array):
                return array.sorted {
                    guard let price1 = Float($0.buyItNowPrice.value), let price2 = Float($1.buyItNowPrice.value) else { return false }
                    return price1 > price2
                }
            case ("shipping", "ascending", array):
                return array.sorted {
                    guard let ship1 = Float($0.shippingCost.value), let ship2 = Float($1.shippingCost.value) else {return false}
                    return ship1 < ship2
            }
            case ("shipping", "descending", array):
                return array.sorted {
                    guard let ship1 = Float($0.shippingCost.value), let ship2 = Float($1.shippingCost.value) else {return false}
                    return ship1 > ship2
            }
            case("daysleft", "ascending", array):
                return array.sorted {
                    extractTimeLeft(item : $0) < extractTimeLeft(item : $1)
                }
            case("daysleft", "descending", array):
                return array.sorted {
                    extractTimeLeft(item : $0) > extractTimeLeft(item : $1)
                }
            default:
                print("error in func sort in similarproductmanager")
                return array
        }
    }
}
