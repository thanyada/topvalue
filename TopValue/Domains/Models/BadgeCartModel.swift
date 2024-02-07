//
//  BadgeCartModel.swift
//  TopValue
//
//  Created by Natthanan Gumyan on 21/10/2566 BE.
//

import Foundation
import ObjectMapper

public struct BadgeCartModel: Mappable {
    
    var badgeCartCouting: Int = 0
    
    public init?(map: Map) {
        self.mapping(map: map)
    }
    
    public mutating func mapping(map: Map) {
        badgeCartCouting <- map["items_qty"]
    }
}
