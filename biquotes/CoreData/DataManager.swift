//
//  DataManager.swift
//  biquotes
//
//  Created by 1 on 14/04/2018.
//  Copyright © 2018 1. All rights reserved.
//

import Foundation
class DataManager {
    class func preloadData() {
        if let url = Bundle.main.url(forResource: "data.json", withExtension: nil) {
            if let data = try? Data(contentsOf: url) {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let array = json as? [[String:Any]] {
                    for object in array {
                        
                            let name = object["name"] as? String
                            let surname = object["surname"] as? String
                            if let quotes = object["quotes"] as? [String] {
                                let author = Author(context: CoreDataStack.context)
                                author.name = name
                                author.surname = surname
                                for body in quotes {
                                    let quote = Quote(context: CoreDataStack.context)
                                    quote.author = author
                                    quote.body = body
                                }
                            }
                        CoreDataStack.saveContext()
                    }
                }
            }
        }
    }
}
