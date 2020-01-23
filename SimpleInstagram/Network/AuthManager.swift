//
//  AuthManager.swift
//  SimpleInstagram
//
//  Created by INITS on 23/01/2020.
//  Copyright © 2020 clementozemoya. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire
import ObjectMapper

class AuthRequestManager: NSObject {
    let BASIC_URL = "https://api.instagram.com/"
    let graphUrl = "https://graph.instagram.com/"
    
    func getAccessToken(code: String, clientId: String, clientSecret: String, redirectUrl: String) -> Observable<AccessTokenResponse> {
        let url = BASIC_URL + "oauth/access_token"
        let params = [
            "client_id": clientId,
            "client_secret": clientSecret,
            "code": code,
            "redirect_uri": redirectUrl,
            "grant_type": "authorization_code"
        ]
        return RxAlamofire.requestJSON(.post, url, parameters: params)
            .debug()
            .mapObject(type: AccessTokenResponse.self)
    }
    
    func getLongLivedToken(accessToken: String, clientSecret: String) -> Observable<AccessTokenResponse> {
        let url = graphUrl + "access_token"
        let params = [
            "client_secret": clientSecret,
            "access_token": accessToken,
            "grant_type": "ig_exchange_token"
        ]
        return RxAlamofire.requestJSON(.get, url, parameters: params)
            .debug()
            .mapObject(type: AccessTokenResponse.self)
    }
}
