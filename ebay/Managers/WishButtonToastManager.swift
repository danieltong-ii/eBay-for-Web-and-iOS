//
//  WishButtonToastManager.swift
//  ebay
//
//  Created by Daniel Tong on 12/6/23.
//

import Foundation
import SwiftUI


class WishButtonToastManager:ObservableObject {
    static let sharedInstance = WishButtonToastManager()
    
    @Published var showAdded : Bool = false
    @Published var showRemoved : Bool = false
    
}


