//
//  FavoritesManagerModel.swift
//  ebay
//
//  Created by Daniel Tong on 11/20/23.
//

import Foundation
import SwiftUI
import Alamofire

@Observable
class FavoritesManager {
    static let sharedInstance = FavoritesManager()
    private init(){
        
    }
    
    var favorites : [Favorite] = []
    
    var total : String {
        let totalPrice : Float = favorites.reduce(0) { sum, favorite in
            sum + (Float(favorite.price) ?? 0) + (Float(favorite.shipping) ?? 0)
        }
    
        return String(format: "%.2f", totalPrice)
    }
    
    var numOfItems : Int {
        favorites.count
    }

    
    func getUpdatedFavorites() async throws -> Bool {
        print("inside getUpdatedFavorites")
        let url = "https://cs571-hw3-404504.wl.r.appspot.com/api/wishlist_get"
        AF.request(url).responseDecodable(of: [Favorite].self) { response in
            switch response.result {
                case .success(let favorites):
                    self.favorites = favorites
                    print(favorites)
                case .failure(let error):
                    print(error)
            }
        }
        return true
    }
}


struct Favorite : Codable, Identifiable {
    var _id : String
    var title : String
    var image_url: String
    var zipcode : String
    var shipping : String
    var price: String
    var condition: String
    
    var id : Int {
        return Int(_id) ?? 0
    }
}
