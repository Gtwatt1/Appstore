//
//  ViewController.swift
//  Appstore
//
//  Created by Zone 3 on 4/26/17.
//  Copyright © 2017 Zone 3. All rights reserved.
//

import UIKit

class FeaturedAppController: UICollectionViewController, UICollectionViewDelegateFlowLayout{

    var featuredApps : FeaturedApps?
    var appCategories : [AppCategory]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Featured Apps"
        AppCategory.fetchFeaturedApps { (featuredApps) -> () in
            self.appCategories = featuredApps.appCategories
            self.featuredApps = featuredApps
            self.collectionView?.reloadData()
        }
//        appCategories = AppCategory.sampleAppCategories()
        collectionView?.backgroundColor = .white //UIColor(white: 0.9, alpha: 1)
        collectionView?.register(CategoryCell.self, forCellWithReuseIdentifier: "mycell")
        collectionView?.register(LargeCategoryCell.self, forCellWithReuseIdentifier: "largecell")
        collectionView?.register(Header.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headercell")
    }


    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = appCategories?.count else {
            return 0
        }
        return count
    }

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "largecell", for: indexPath) as! CategoryCell
            cell.appCategory = appCategories?[indexPath.item]
            cell.featuredAppController = self
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mycell", for: indexPath) as! CategoryCell
        cell.appCategory = appCategories?[indexPath.item]
        cell.featuredAppController = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item == 2{
            return CGSize(width: view.frame.width, height: 160)
        }
        return CGSize(width: view.frame.width, height: 220)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headercell", for: indexPath) as! Header
        header.appCategory = featuredApps?.bannerCategory
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: view.frame.width, height: 120)
    }
    
    func showAppDetails(app : App){
        let layout = UICollectionViewFlowLayout()
        let appDetailController = AppDetailController(collectionViewLayout: layout)
        appDetailController.app = app
        navigationController?.pushViewController(appDetailController, animated: true)
    }
}

class Header : CategoryCell{

    override func setupViews() {
        
        appsColletionView.dataSource = self
        appsColletionView.delegate = self
        
        addSubview(appsColletionView)
        appsColletionView.register(BannerCell.self, forCellWithReuseIdentifier: "bannercell")
        
        appsColletionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        appsColletionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        appsColletionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        appsColletionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width/2 + 50, height: frame.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannercell", for: indexPath) as! BannerCell
        cell.app = appCategory?.apps?[indexPath.item]
        return cell
    }
    
    private class BannerCell : AppCell{
        override func setupViews() {
            addSubview(appImage)
            appImage.layer.cornerRadius = 0
            appImage.layer.borderColor = UIColor(white: 0.8, alpha: 0.8).cgColor
            appImage.layer.borderWidth = 1
            appImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 4).isActive = true
            appImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            appImage.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            appImage.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            
        }
    }
    
    
}


class LargeCategoryCell : CategoryCell{
    
    override func setupViews() {
        super.setupViews()
        appsColletionView.register(LargeAppCell.self, forCellWithReuseIdentifier: "largeappcell")
    }

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
               return CGSize(width: 200, height: frame.height-32)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "largeappcell", for: indexPath) as! AppCell
        cell.app = appCategory?.apps?[indexPath.item]
        return cell
    }
    
    private class LargeAppCell : AppCell{
        override func setupViews() {
           addSubview(appImage)
            appImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 4).isActive = true
            appImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
            appImage.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -4).isActive = true
            appImage.bottomAnchor.constraint(equalTo: self.bottomAnchor,  constant: -4).isActive = true
            
        }
        
    }
}




