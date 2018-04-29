//
//  Configuration.swift
//  biquotes
//
//  Created by 1 on 15/04/2018.
//  Copyright © 2018 1. All rights reserved.
//

import Foundation
import UIKit

struct Theme {
    var color: UIColor
    var title: String
    
    static var themes = [
        Theme(color: UIColor(red: 1, green: 1, blue: 1, alpha: 1), title: "Белый"),
        Theme(color: UIColor(red: 1, green: 246 / 255, blue: 177 / 255, alpha: 1), title: "Желтый"),
        Theme(color: UIColor(red: 1, green: 218 / 255, blue: 168 / 255, alpha: 1), title: "Оранжевый"),
        Theme(color: UIColor(red: 1, green: 203 / 255, blue: 192 / 255, alpha: 1), title: "Красный"),
        Theme(color: UIColor(red: 190 / 255, green: 1, blue: 209 / 255, alpha: 1), title: "Зеленый"),
        Theme(color: UIColor(red: 176 / 255, green: 223 / 255, blue: 1, alpha: 1), title: "Синий")
    ]
    
    static func titles() -> [String] {
        var titles = [String]()
        for theme in themes {
            titles.append(theme.title)
        }
        return titles
    }
    
    static func setTheme(_ index: Int) {
        UserDefaults.standard.set(index, forKey: "biquotes.currentTheme")
    }
    
    static func getTheme() -> Int {
        return UserDefaults.standard.object(forKey: "biquotes.currentTheme")  as? Int ?? 0
    }
    
    static func getCurrentColor() -> UIColor {
        let index = getTheme()
        if index < 6 {
            return themes[index].color
        }
        return themes[0].color
    }
}


