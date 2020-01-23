//
//  MediaItem.swift
//  SimpleInstagram
//
//  Created by INITS on 23/01/2020.
//  Copyright © 2020 clementozemoya. All rights reserved.
//

import Foundation
import ObjectMapper

class MediaItem: Mappable {
    var mediaType: String?
    var id: String?
    var mediaUrl: String?
    var timestamp: String?
    var username: String?
    var displayUrl: String?
    
    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        mediaType  <- map["media_type"]
        id <- map["id"]
        mediaUrl <- map["media_url"]
        timestamp <- map["timestamp"]
        username <- map["username"]
        displayUrl <- map["node.display_url"]
    }
}
