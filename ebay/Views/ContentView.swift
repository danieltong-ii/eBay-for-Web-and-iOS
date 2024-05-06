//
//  ContentView.swift
//  ebay
//
//  Created by Daniel Tong on 11/17/23.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        ProductSearch().environmentObject(WishButtonToastManager.sharedInstance)
    }
}

#Preview {
    ContentView()
}
