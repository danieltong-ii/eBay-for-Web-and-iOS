//
//  Photos.swift
//  ebay
//
//  Created by Daniel Tong on 12/1/23.
//

import Foundation

struct Photos : Codable {
    var items : [Items]
}

struct Items : Codable, Identifiable {
    var link : String
    var id : String {
        return link
    }
}
