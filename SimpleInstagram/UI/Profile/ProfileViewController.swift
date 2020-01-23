//
//  ProfileViewController.swift
//  SimpleInstagram
//
//  Created on 23/01/2020.
//  Copyright © 2020 clementozemoya. All rights reserved.
//

import UIKit
import AlamofireImage

class ProfileViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var presenter: ProfilePresenter?
    var profile: ProfileDetailsResponse?
    var mediaList = [MediaData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = ProfilePresenter(delegate: self)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let spacing:CGFloat = 0
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = spacing
        layout.headerReferenceSize = CGSize(width: 414, height: 195)
        collectionView.collectionViewLayout = layout
    
        loadProfile()
    }
    
    func loadProfile() {
        presenter?.fetchProfile()
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        let alert = UIAlertController.init(title: "Logout", message: "Are you sure you want to logout", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "No", style: .default, handler: nil))
        alert.addAction(UIAlertAction.init(title: "Yes", style: .destructive, handler: { _ in
            self.logout()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func logout() {
        UserManager.setUserLoggedOut()
        
        // launch login view
        let next = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "login")
        let window = UIApplication.shared.windows[0] as UIWindow;
        window.rootViewController = next;
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {})
    }
}

// MARK: - Profile view delegate
extension ProfileViewController: ProfileDelegate {
    func profileDidLoad(profile: ProfileDetailsResponse) {
        print("Update UI with profile")
        self.profile = profile
        collectionView.reloadData()
    }
    
    func profileLoadFailed(error: Error) {
        print("Error occurred")
    }
    
    func recentMediaDidLoad(recentMedia: [MediaData]) {
        // TODO: Load pictures
        mediaList = recentMedia
        collectionView.reloadData()
    }
    
    
}

// MARK: - CollectionView Setup
extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profile?.mediaList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "profileHeader", for: indexPath) as! HeaderViewCell
        // Customize headerView here
        headerView.name.text = presenter?.username.value
        headerView.mediaCount.text = "\(presenter?.postCount.value ?? 0)"
        if let profile = profile {
            headerView.bio.text = profile.biography
            headerView.name.text = profile.fullname
            headerView.followCount.text = "\(profile.follow ?? 0)"
            headerView.followersCount.text = "\(profile.followedBy ?? 0)"
            if let pic = profile.profilePicUrl {
            headerView.profilePic.af_setImage(withURL: URL(string: pic)!)
            }
        }
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mediaItem", for: indexPath) as! MediaViewCell
        
        if let media = profile?.mediaList?[indexPath.item].displayUrl {
            cell.imageView.af_setImage(withURL: URL(string: media)!)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 1, left: 1, bottom: 1, right: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width / 3 - 1.5, height: view.frame.size.width / 3 - 1.5)
    }
}
