//
//  SplashScreenView.swift
//  ebay
//
//  Created by Daniel Tong on 12/2/23.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var opacity = 1.0
    var body: some View {
        
        if (isActive) {
            ContentView()
                .environment(ResultsData.sharedInstance)
                .environment(FavoritesManager.sharedInstance)
        } else {
            VStack {
                VStack {
                    HStack {
                        Text("Powered by")
                            .font(.headline)
                            .fontWeight(/*@START_MENU_TOKEN@*/.medium/*@END_MENU_TOKEN@*/)
                        Image("ebay")
                            .resizable()
//                            .aspectRatio(contentMode: .fit) // or .fill
                            .frame(width: 100, height: 40) // Adjust width and height as needed
                            .scaledToFit()
                    }
                }
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        
                    }
                }
            }.onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
