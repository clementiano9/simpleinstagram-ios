//
//  ProfileRequestManager.swift
//  SimpleInstagram
//
//  Created on 23/01/2020.
//  Copyright © 2020 clementozemoya. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire

class ProfileRequestManager {
    
    let GRAPH_URL = "https://graph.instagram.com/"
    let BASE_URL = "https://www.instagram.com/"
    
    func getMe(accessToken: String) -> Observable<MeResponse> {
        let url = GRAPH_URL + "me"
        let params = [
            "access_token": accessToken,
            "fields": "account_type, username, media_count, username"
        ]
        return RxAlamofire.requestJSON(.get, url, parameters: params)
            .debug()
            .mapObject(type: MeResponse.self)
    }
    
    func getProfileDetails(username: String) -> Observable<ProfileDetailsResponse>{
        let url = BASE_URL + "\(username)/?__a=1"

        return RxAlamofire.requestJSON(.get, url)
            .debug()
            .mapObject(type: ProfileDetailsResponse.self)
    }
    
    func getMediaList(accessToken: String) -> Observable<MediaResponse> {
        let url = GRAPH_URL + "me/media"
        let params = [
            "access_token": accessToken,
            "fields": "id, caption"
        ]
        return RxAlamofire.requestJSON(.get, url, parameters: params)
            .debug()
            .mapObject(type: MediaResponse.self)
    }
    
    func getMediaDetails(mediaId: String, accessToken: String) -> Observable<MediaItem> {
        let url = GRAPH_URL + "/\(mediaId)"
        let params = [
            "access_token": accessToken,
            "fields": "id,caption,media_type,media_url,username,timestamp"
        ]
        return RxAlamofire.requestJSON(.get, url, parameters: params)
            .debug()
            .mapObject(type: MediaItem.self)
    }
}
