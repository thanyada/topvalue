//
//  BadgeWishlistModel.swift
//  TopValue
//
//  Created by Natthanan Gumyan on 21/10/2566 BE.
//

import Foundation
import ObjectMapper

public struct BadgeWishlistModel: Mappable {
    var badgeWishlistCount: Int = 0

    public init?(map: Map) {
        self.mapping(map: map)
    }

    public mutating func mapping(map: Map) {
        badgeWishlistCount <- map["total_count"]
    }
}
