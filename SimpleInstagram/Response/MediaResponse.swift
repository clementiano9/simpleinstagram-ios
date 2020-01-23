//
//  MediaResponse.swift
//  SimpleInstagram
//
//  Created on 23/01/2020.
//  Copyright © 2020 clementozemoya. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper

class MediaResponse: Mappable {
    var data: [MediaData]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        data <- map["data"]
    }
}
