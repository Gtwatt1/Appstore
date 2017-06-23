//
//  Models.swift
//  Appstore
//
//  Created by Zone 3 on 4/27/17.
//  Copyright © 2017 Zone 3. All rights reserved.
//

import UIKit


class FeaturedApps : NSObject{
    var bannerCategory : AppCategory?
    var appCategories :[AppCategory]?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "categories" {
            appCategories = [AppCategory]()
            
            for dict in value as! [[String : Any]]{
                let appcategory = AppCategory()
                appcategory.setValuesForKeys(dict)
                appCategories?.append(appcategory)
            }
        
        }else if key == "bannerCategory"{
            bannerCategory = AppCategory()
            bannerCategory?.setValuesForKeys(value as! [String : Any])
            
        }else {
            super.setValue(value, forKey: key)
        
        }
    }
}

class  AppCategory: NSObject {
    var name : String?
    var apps: [App]?
    var type: String?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "apps"{
            apps = [App]()
            for dict in value as! [[String: Any]]{
                let app = App()
                app.setValuesForKeys(dict)
                apps?.append(app)
            }
        
        }else{
            super.setValue(value, forKey: key)
        }
    }
    
    
    static func fetchFeaturedApps(completionHandler : @escaping (FeaturedApps) ->()) {
        let urlString = "http://www.statsallday.com/appstore/featured"        
        URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, response, error) in
            if error != nil{
                print(error!)
                return
            }
            
            do{
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: Any]
                
                let featuredApps = FeaturedApps()
                
                featuredApps.setValuesForKeys(json )
                
//                let categoriesJson = json["categories"] as! [[String: Any]]
//                for category in categoriesJson {
//                    let appCategory = AppCategory()
//                    appCategory.setValuesForKeys(category)
//                    appCategories.append(appCategory)
//                }
//           
//                print(appCategories)
                DispatchQueue.main.async(execute: {
                    completionHandler(featuredApps)
                })
                
            
            }catch let err{
                print(err)
            }
            
        }.resume()
    
    }
    static func sampleAppCategories() -> [AppCategory]{
        let bestNewAppsCategory = AppCategory()
        bestNewAppsCategory.name = "Best New Apps"
        
        var bestNewApps = [App]()
        let frozenApp = App()
        frozenApp.name = "Disney Build it: Frozen"
        frozenApp.category = "Entertainment"
        frozenApp.imageName = "frozen"
        frozenApp.price = NSNumber(value: 3.99)
        
        
        bestNewApps.append(frozenApp)
        
        bestNewAppsCategory.apps = bestNewApps
        
        let topNewGamesCategory = AppCategory()
        topNewGamesCategory.name = "Top New Games"
        
        var topNewApps = [App]()
        let telepaintApp = App()
        telepaintApp.name = "Telepaint"
        telepaintApp.category = "Games"
        telepaintApp.imageName = "telepaint"
        telepaintApp.price = NSNumber(value: 5.99)
        
        
        topNewApps.append(telepaintApp)
        topNewGamesCategory.apps = topNewApps
        
        return [bestNewAppsCategory, topNewGamesCategory]
    
    }
}

class App : NSObject {
    var id : NSNumber?
    var name : String?
    var category : String?
    var imageName : String?
    var price : NSNumber?
    
    var screenshots : [String]?
    var desc : String?
    var appInformation : AnyObject?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "description"{
            self.desc = value as? String
        }else{
            super.setValue(value, forKey: key)
        }
        
    }
}
