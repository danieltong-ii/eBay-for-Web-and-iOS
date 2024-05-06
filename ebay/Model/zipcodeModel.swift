//
//  zipcodeModel.swift
//  ebay
//
//  Created by Daniel Tong on 12/7/23.
//

import Foundation

struct PostalCodeResponse: Decodable, Hashable  {
    let postalCodes: [Location]
}

struct Location: Decodable, Hashable, Identifiable {
    let postalCode: String
    var id : String {postalCode}
}
