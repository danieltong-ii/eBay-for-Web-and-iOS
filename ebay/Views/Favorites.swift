//
//  Favorites.swift
//  ebay
//
//  Created by Daniel Tong on 11/20/23.
//

import SwiftUI
import Alamofire

struct Favorites: View {
    @Environment(FavoritesManager.self) private var favoriteManager
    @State private var isLoading : Bool = true
    
    var body: some View {
        
        NavigationStack {
            if isLoading {
                Text("Loading...")
            }
            else {
                if favoriteManager.favorites.isEmpty {
                    Text("No items in wishlist")
                        .navigationTitle("Favorites")
                } else {
                    List {
                        HStack{
                            Text("Wishlist total(\(favoriteManager.numOfItems)) items:")
                            Spacer()
                            Text("$\(favoriteManager.total)")
                        }
                        
                        ForEach(favoriteManager.favorites) { favorite in
                            FavoriteRow(favorite : favorite)
                        }.onDelete(perform : removeRows)
                    }
                }
            }
        }.navigationTitle("Favorites")
         .onAppear {
             Task {
                 do {
                    print("inside isLoading")
                    let success = try await FavoritesManager.sharedInstance.getUpdatedFavorites()
                    if success {
                        isLoading = false
                    }
                } catch {
                    
                }
            }
        }
    }
    
    func removeRows(at offsets: IndexSet) {
        for index in offsets {
            deleteFavorite(_id: favoriteManager.favorites[index]._id)
            favoriteManager.favorites.remove(atOffsets: offsets)
        }
    }
    
    func deleteFavorite(_id : String) {
        let params = ["ItemId" : _id]
        let url = "https://cs571-hw3-404504.wl.r.appspot.com/api/wishlist_delete"
        
        AF.request(url, parameters: params).responseString { response in
            print(response)
        }
    }
}



