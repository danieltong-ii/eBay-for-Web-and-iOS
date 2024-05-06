//
//  PhotosView.swift
//  ebay
//
//  Created by Daniel Tong on 12/1/23.
//

import SwiftUI
import Kingfisher

struct PhotosView: View {
    var item : Item
    @State var photo : Photos?
    @State private var isLoading : Bool = true
    
    var body: some View {
        NavigationStack {
            if isLoading {
                VStack {
                    ProgressView()
                }
            } else {
                HStack{
                    Text("Powered By")
                    Image("google")
                        .resizable()
                        .frame(width: 110, height: 35) // Adjust width and height as needed
                        .scaledToFit()
                }
                ScrollView {
                    VStack(alignment: .leading) {
                        if let unWrappedPhoto = photo {
                            ForEach(unWrappedPhoto.items) { item in
                                let url = URL(string: item.link)
                                KFImage(url)
                                    .resizable()
                                    .frame(width: 200, height: 200) // Adjust width and height as needed
                                    .scaledToFill()
                                }
                            }
                        }
                    }
            }
        
        }
        .task {
            do {
                photo = try await PhotosManager().fetchPhotos(query: item.title[0])
                isLoading = false;
                // Successful fetching, update state as needed
            } catch {
                // Handle the error, e.g., show an alert or log the error
                print("Error while fetching photos: \(error)")
            }
        }
    }
}
