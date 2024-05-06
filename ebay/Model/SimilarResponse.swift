//
//  SimilarResponse.swift
//  ebay
//
//  Created by Daniel Tong on 12/6/23.
//

import Foundation

struct SimilarResponse: Codable {
    let getSimilarItemsResponse: GetSimilarItemsResponse
}

struct GetSimilarItemsResponse: Codable {
    let itemRecommendations: ItemRecommendations
}

struct ItemRecommendations: Codable {
    let item: [SimilarItem]
}

struct SimilarItem: Codable, Identifiable, Equatable {
    let itemId: String
    let title: String
    let viewItemURL: String
    let timeLeft: String
    let imageURL: String
    let buyItNowPrice: Price
    let shippingCost: Price
    
    var id: String { // 'id' instead of 'Id', and it should be a computed property
        return itemId
    }
}

struct Price: Codable, Equatable {
    let currencyId: String
    let value: String

    enum CodingKeys: String, CodingKey {
        case currencyId = "@currencyId"
        case value = "__value__"
    }
}
