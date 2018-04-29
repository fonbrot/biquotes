//
//  SettingsViewController.swift
//  biquotes
//
//  Created by 1 on 14/04/2018.
//  Copyright © 2018 1. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    @IBOutlet weak var colorPicker: UIPickerView!
    
    private var colorPickerData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        colorPickerData = Theme.titles()
        let index = Theme.getTheme()
        if index < colorPickerData.count {
            colorPicker.selectRow(index, inComponent: 0, animated: true)
        }
    }
}

extension SettingsViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colorPickerData.count
    }
}

extension SettingsViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return colorPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        Theme.setTheme(row)
    }
}
