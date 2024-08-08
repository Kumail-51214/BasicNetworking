//
//  DataModel.swift
//  BasicNetworking
//
//  Created by Muhammad Kumail on 8/1/24.
//

import Foundation

struct DataModel: Codable {
    let id: Int?
    var stock: Int?
    var price: Int?
    var title, description: String?
    let discountPercentage, rating: Double?
    let brand, category: String?
    let thumbnail: String?
    let images: [String]?
}
