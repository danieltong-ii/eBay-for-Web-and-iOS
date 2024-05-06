//
//  ZipcodeManager.swift
//  ebay
//
//  Created by Daniel Tong on 12/7/23.
//

import Foundation
import Alamofire


struct ZipcodeManager {
    
    func getZipcodeSuggestions(query: String) async throws -> [Location] {
        let param = ["input": query]
        let url = "https://cs571-hw3-404504.wl.r.appspot.com/api/zipcode_autocomplete"
            
        let response = try await AF.request(url, parameters: param).serializingDecodable(PostalCodeResponse.self)
        let postalCodeResponse = try await response.value
//        print(postalCodeResponse.postalCodes)
        return postalCodeResponse.postalCodes
    }
}
