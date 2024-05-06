//
//  WishlistButtonManager.swift
//  ebay
//
//  Created by Daniel Tong on 11/21/23.
//

import SwiftUI
import Alamofire

struct WishlistButtonView: View {
    let item : Item
    var wishlistButtonManager : WishlistButtonManager
    @State private var isInWishlist : Bool
    var calledFromDetails : Bool
    
    init(item : Item, calledFromDetails : Bool?) {
        self.item = item
        self.wishlistButtonManager = WishlistButtonManager(item: item)
        self.isInWishlist = wishlistButtonManager.isInWishlist
        self.calledFromDetails = calledFromDetails ?? false
    }
    
    var body: some View {
        
        Image(systemName: isInWishlist ? "heart.fill" : "heart")
            .foregroundColor(.red)
            .font(calledFromDetails ? .headline : .title2)
            .onTapGesture {
                if isInWishlist {
                    print("item in wishlist \(isInWishlist)")
                    wishlistButtonManager.removeFromWishlist()
                    WishButtonToastManager.sharedInstance.showRemoved = true
                    print("WishButtonToast Show removed: \(WishButtonToastManager.sharedInstance.showRemoved)")
                    print("removed")
                } else {
                    print("item in wishlist \(isInWishlist)")
                    wishlistButtonManager.addToWishlist()
                    WishButtonToastManager.sharedInstance.showAdded = true
                    print("WishButtonToast Show added: \(WishButtonToastManager.sharedInstance.showAdded)")
                    print("added")
                }
                isInWishlist.toggle()
            }
            .task {
                do {
                    try await wishlistButtonManager.checkIfInWishlist()
                    self.isInWishlist = wishlistButtonManager.isInWishlist
                } catch {
                    print("error wishlistButtonManager.checkIfInWishlist()")
                }
            }
    }
}
func updateWishlist() {
    
}
