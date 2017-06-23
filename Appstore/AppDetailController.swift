//
//  AppDetailController.swift
//  Appstore
//
//  Created by Zone 3 on 4/27/17.
//  Copyright © 2017 Zone 3. All rights reserved.
//

import UIKit

class AppDetailController : UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    var app : App?{
        didSet{
            navigationItem.title = app?.name
            
            if app?.screenshots != nil{
                return
            }
            
            if let id = app?.id {
                let urlString = "http://www.statsallday.com/appstore/appdetail?id=\(id)"
                URLSession.shared.dataTask(with: URL(string : urlString)!, completionHandler: { (data, response, error) in
                    
                    if error != nil{
                            print(error!)
                        return
                        }
                    
                    do{
                        let json = try(JSONSerialization.jsonObject(with: data!, options: .mutableContainers))
                        let appDetail = App()
                        appDetail.setValuesForKeys(json as! [String : Any])
                        self.app = appDetail
                        
                        DispatchQueue.main.async(execute: { 
                            self.collectionView?.reloadData()
                        })
                        
                        
                        
                    }catch let err{
                        print(err)
                    
                    }
                    
                    
                }).resume()
            }
            
            
        
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "appdesc", for: indexPath) as! AppDescriptionCell
            cell.appDescTextView.attributedText = descriptionAttributedText()
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! ScreenshotsCell
            cell.app = app
        return cell
    }
    
    
    func descriptionAttributedText() -> NSAttributedString{
        let attributedText = NSMutableAttributedString(string: "Description\n", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 14)])
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        
        let range = NSMakeRange(0, attributedText.string.characters.count)
        
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: range)
        if let desc = app?.desc{
            attributedText.append(NSAttributedString(string: desc, attributes : [NSFontAttributeName : UIFont.systemFont(ofSize: 11), NSForegroundColorAttributeName : UIColor.darkGray]))
        }
        return attributedText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        collectionView?.register(AppDetailHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "appheader")
        collectionView?.register(ScreenshotsCell.self, forCellWithReuseIdentifier: "cellid")
        collectionView?.register(AppDescriptionCell.self, forCellWithReuseIdentifier: "appdesc")
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "appheader", for: indexPath) as! AppDetailHeader
        header.app = app
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item == 1{
            let dummySize = CGSize(width: view.frame.width, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
            let rect = descriptionAttributedText().boundingRect(with: dummySize, options: options, context: nil)
            return CGSize(width :view.frame.width, height :rect.height + 32)
            
        }
        return CGSize(width: view.frame.width, height: 150)
    }
    
}

class AppDetailHeader : BaseCell{
    var app : App?{
        didSet{
            if let imageName = app?.imageName{
                appImage.image = UIImage(named: imageName)
            }
            if let appName = app?.name{
                nameLabel.text = appName
            }
            
            if let price = app?.price{
                buyButton.setTitle("$\(price)", for: .normal)
            }else{
                buyButton.setTitle("free", for: .normal)
            }
        
        }
    
    }
    
    let appImage : UIImageView = {
        let iv  = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 20
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let segmentedControl : UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Details","Reviews", "Related"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = .darkGray
        sc.selectedSegmentIndex  = 0
        return sc
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Disney"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints =  false
        return label
    }()
    
    let buyButton : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("BUY", for: .normal)
        button.layer.borderColor = UIColor(red: 0, green: 129/255, blue: 250/255, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    let dividerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.7, alpha: 0.7)
        return view
    }()
    
    
    
    override func setupViews() {
        super.setupViews()
        addSubview(appImage)
        addSubview(segmentedControl)
        addSubview(nameLabel)
        addSubview(buyButton)
        addSubview(dividerView)

        
        
        appImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        appImage.leftAnchor.constraint(equalTo: self.leftAnchor,  constant: 8).isActive = true
        appImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        appImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        segmentedControl.bottomAnchor.constraint(equalTo: self.bottomAnchor,  constant: -8).isActive = true
        segmentedControl.leftAnchor.constraint(equalTo: self.leftAnchor, constant : 40).isActive = true
        segmentedControl.rightAnchor.constraint(equalTo: self.rightAnchor, constant : -40).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: appImage.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: appImage.rightAnchor,  constant: 8).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant : -8).isActive = true
        
        buyButton.bottomAnchor.constraint(equalTo: segmentedControl.topAnchor, constant: -8).isActive = true
        buyButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        buyButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        buyButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant : -12).isActive = true
        
        
        dividerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dividerView.leftAnchor.constraint(equalTo: self.leftAnchor,  constant: 8).isActive = true
        dividerView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        dividerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
    }


}


class BaseCell : UICollectionViewCell{
   override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews(){
    
    
    }

}

class AppDescriptionCell : BaseCell{

    let appDescTextView  : UITextView = {
        let tv = UITextView()
        tv.text = "Sample heaven"
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let dividerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.7, alpha: 0.7)
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(appDescTextView)
        addSubview(dividerView)
        
        
        appDescTextView.bottomAnchor.constraint(equalTo: dividerView.topAnchor, constant : -4).isActive = true
        appDescTextView.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 12).isActive = true
        appDescTextView.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -12).isActive = true
        appDescTextView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        
        dividerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dividerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        dividerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        dividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}

class ScreenshotsCell : BaseCell,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    var app : App?{
        didSet{
            screenshotCollectionView.reloadData()
        }
    }

    
    let dividerLineView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let screenshotCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = app?.screenshots?.count{
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "screenshotimagecell", for: indexPath) as! ScreenshotImageCell
        if let imageName = app?.screenshots?[indexPath.item]{
            cell.screenshotImage.image = UIImage(named : imageName)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: frame.height - 28)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }
    
    
    override func setupViews() {
        
        screenshotCollectionView.register(ScreenshotImageCell.self, forCellWithReuseIdentifier: "screenshotimagecell")
        
        addSubview(screenshotCollectionView)
        addSubview(dividerLineView)
        screenshotCollectionView.delegate = self
        screenshotCollectionView.dataSource = self
        
        screenshotCollectionView.bottomAnchor.constraint(equalTo: dividerLineView.topAnchor,constant: -4).isActive = true
        screenshotCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        screenshotCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        screenshotCollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        dividerLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        dividerLineView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        dividerLineView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        dividerLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        
    }
    
    private class ScreenshotImageCell : BaseCell{
    
        let screenshotImage : UIImageView = {
            let iv = UIImageView()
            iv.translatesAutoresizingMaskIntoConstraints = false
            iv.contentMode = .scaleAspectFill
            iv.layer.masksToBounds = true
            return iv
        }()
        
        
        public override func setupViews() {
            addSubview(screenshotImage)
            
            screenshotImage.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            screenshotImage.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            screenshotImage.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            screenshotImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        }
    
    }
}
