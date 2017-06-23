//
//  CategoryCell.swift
//  Appstore
//
//  Created by Zone 3 on 4/26/17.
//  Copyright © 2017 Zone 3. All rights reserved.
//

import UIKit


class CategoryCell : UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var featuredAppController : FeaturedAppController?

    var appCategory : AppCategory? {
        didSet{
            if let name = appCategory?.name{
                self.nameLabel.text = name
            }
            appsColletionView.reloadData()
           
        }
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let appsColletionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(AppCell.self, forCellWithReuseIdentifier: "appcell")
        return collection
    }()
    
    let dividerLineView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Top Apps"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = appCategory?.apps?.count{
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "appcell", for: indexPath) as! AppCell
        cell.app = appCategory?.apps?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: frame.height-32)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 16, 0, 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let  app = appCategory?.apps?[indexPath.item]{
            featuredAppController?.showAppDetails(app: app)
        }
    }
    
    
    func setupViews(){
        addSubview(appsColletionView)
        addSubview(dividerLineView)
        addSubview(nameLabel)
        
        appsColletionView.delegate = self
        appsColletionView.dataSource = self
        
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        
        appsColletionView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,  constant: 8).isActive = true
        appsColletionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        appsColletionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        appsColletionView.bottomAnchor.constraint(equalTo: dividerLineView.topAnchor, constant: -4).isActive = true
        
        dividerLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        dividerLineView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        dividerLineView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        dividerLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    
}

class AppCell : UICollectionViewCell{

    var app : App?{
        didSet{
            
            if let name = app?.name{
                nameLabel.text = name
            }
            if let imageName = app?.imageName{
                appImage.image = UIImage(named: imageName)
            }
            if let category = app?.category{
                categoryLabel.text = category
            }
            if let price = app?.price{
                priceLabel.text = "$\(price)"
            }else{
                priceLabel.text = "free"
            }
        
        }
    
    
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let appImage : UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 18
        iv.image = UIImage(named: "angrybirdsspace")
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.backgroundColor = .orange
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Disney Build It: Frozen"
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    
    let categoryLabel : UILabel = {
        let label = UILabel()
        label.text = "Entertainment"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11)
        label.numberOfLines = 2
        return label
    }()
    
    let priceLabel : UILabel = {
        let label = UILabel()
        label.text = "$0.99"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10)
        label.numberOfLines = 2
        return label
    }()
    
    func setupViews(){
        
        addSubview(appImage)
        addSubview(nameLabel)
        addSubview(categoryLabel)
        addSubview(priceLabel)
        
        appImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 4).isActive = true
        appImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        appImage.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -4).isActive = true
        appImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 4).isActive = true
        nameLabel.topAnchor.constraint(equalTo: appImage.bottomAnchor, constant: 4).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -4).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        categoryLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 4).isActive = true
        categoryLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
        categoryLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -4).isActive = true
        categoryLabel.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        priceLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 4).isActive = true
        priceLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 4).isActive = true
        priceLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -4).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 10).isActive = true
      
    }

}
