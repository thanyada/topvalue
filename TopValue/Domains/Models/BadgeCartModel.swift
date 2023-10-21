//
//  BadgeCartModel.swift
//  TopValue
//
//  Created by Natthanan Gumyan on 21/10/2566 BE.
//

import Foundation
import ObjectMapper

public class BadgeCartModel: Mappable {
    
    var badgeCartCouting: String = ""
  
    init() {
        
    }
    
    public required init?(map: Map) {
        mapping(map: map)
    }
    
    public func mapping(map: Map) {
        badgeCartCouting <- map["badgeCartCouting"]
    }
}
