//
//  MediaItem.swift
//  SimpleInstagram
//
//  Created by INITS on 23/01/2020.
//  Copyright © 2020 clementozemoya. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper

class MediaData: Mappable {
    var caption: String?
    var id: String?
    
    required init(map: Map) {
    }
    
    func mapping(map: Map) {
        caption  <- map["caption"]
        id <- map["id"]
    }
}
