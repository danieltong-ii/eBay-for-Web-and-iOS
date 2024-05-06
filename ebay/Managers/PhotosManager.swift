//
//  PhotosManager.swift
//  ebay
//
//  Created by Daniel Tong on 12/1/23.
//

import Foundation
import Alamofire


struct PhotosManager {
    let url = "https://cs571-hw3-404504.wl.r.appspot.com/api/photosearch"
    
    func fetchPhotos(query : String) async throws -> Photos {
        let param = ["query" : query]
        
        let response = try await AF.request(url, parameters: param).serializingDecodable(Photos.self)
        let photo = try await response.value
        print("Photos array \(photo)")
        return photo
    }
}
