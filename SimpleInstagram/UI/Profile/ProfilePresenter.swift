//
//  ProfilePresenter.swift
//  SimpleInstagram
//
//  Created on 23/01/2020.
//  Copyright © 2020 clementozemoya. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ProfileDelegate: class {
    func profileDidLoad(profile: ProfileDetailsResponse)
    func profileLoadFailed(error: Error)
}

class ProfilePresenter {
    var delegate: ProfileDelegate?
    let token = UserManager.getToken()
    let requestManager = ProfileRequestManager()
    let disposeBag = DisposeBag()
    
    let username: BehaviorRelay<String> = BehaviorRelay(value: "")
    let postCount: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    
    required init(delegate: ProfileDelegate) {
        self.delegate = delegate
        fetchProfile()
    }
    
    func fetchProfile() {
        loadProfile()
            .flatMap({ meResponse -> Observable<ProfileDetailsResponse> in
                // TODO: - Check that it is not nil
                return self.loadProfileDetails(username: meResponse.username ?? "")
            })
            .subscribe( onNext: { [weak self] response in
                print("Profile loaded successfully")
                //self.profileDetails.onNext(response)
                self?.delegate?.profileDidLoad(profile: response)
            }, onError: { [weak self] error in
                print("Error loading profile", error)
                self?.delegate?.profileLoadFailed(error: error)
            }).disposed(by: disposeBag)
    }
    
    func loadProfile() -> Observable<MeResponse> {
        guard let token = token else { return Observable.empty() }
        return requestManager.getMe(accessToken: token)
            .do(onNext: { [weak self] response in
                print("On next")
                self?.username.accept(response.username ?? "")
                self?.postCount.accept(response.media ?? 0)
            })
    }
    
    func loadProfileDetails(username: String) -> Observable<ProfileDetailsResponse> {
        return requestManager.getProfileDetails(username: username)
    }
}
