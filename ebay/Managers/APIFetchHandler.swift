//
//  APIFetchHandler.swift
//  ebay
//
//  Created by Daniel Tong on 11/19/23.
//

import Foundation
import Alamofire
import SwiftUI

class APIFetchHandler {
    var mainSearchParams : ProductSearchParams
    
    init(mainSearchParams: ProductSearchParams) {
        self.mainSearchParams = mainSearchParams
    }
    
//    func fetchMainSearch() async throws{
//        print("inside fetchMainSearch")
//        Task {
//            try await mainSearch()
//        }
//    }
    
    func mainSearch() async throws {
        print("inside mainSearch")
        let url = "https://cs571-hw3-404504.wl.r.appspot.com/api/mainsearch"

        let model: Product = try await AF.request(url, method: .get, parameters: mainSearchParams)
            .serializingDecodable(Product.self)
            .value

        ResultsData.sharedInstance.results = model
        ResultsData.sharedInstance.ready = true
        print("leaving mainSearch")
    }

}
