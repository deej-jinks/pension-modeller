//
//  DateSelectionViewController.swift
//  DCModeller
//
//  Created by Daniel Jinks on 20/05/2016.
//  Copyright © 2016 Daniel Jinks. All rights reserved.
//

import UIKit
import CoreData

class DateSelectionViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let monthsAsStrings = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    
    var year: Int {
        if let dob = currentUser!.dateOfBirth {
            return NSCalendar.currentCalendar().component(.Year, fromDate: dob)
        } else {
            return 1970
        }
    }
    var month: Int {
        if let dob = currentUser!.dateOfBirth {
            return NSCalendar.currentCalendar().component(.Month, fromDate: dob)
        } else {
            return 1
        }
    }
    var day: Int {
        if let dob = currentUser!.dateOfBirth {
            return NSCalendar.currentCalendar().component(.Day, fromDate: dob)
        } else {
            return 1
        }
    }
    
    @IBOutlet weak var picker: UIPickerView! {
        didSet {
            picker.dataSource = self
            picker.delegate = self
        }
    }
    
    
    let cornerRadius: CGFloat = 7.5
    @IBOutlet var contentBoxes: [UIView]! {
        didSet {
            for box in contentBoxes {
                box.layer.cornerRadius = cornerRadius
                box.layer.shadowColor = UIColor.blackColor().CGColor
                box.layer.shadowOpacity = 0.4
                box.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
            }
        }
    }
    
    var pickerData = [[Int]]()
    let pickerRowSizes = [10000,10000,10000]
    var pickerRowMiddles: [Int] {
        return [Int((10000 / pickerData[0].count) / 2 ) * pickerData[0].count,
        Int((10000 / pickerData[1].count) / 2 ) * pickerData[1].count,
        Int((10000 / pickerData[2].count) / 2 ) * pickerData[2].count]
    }

    func valueForRow(row: Int, component: Int) -> Int {
        return ((row - pickerRowMiddles[component]) % pickerData[component].count) + pickerData[component].first!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dayArray = [Int](1...31)
        let monthArray = [Int](1...12)
        let yearArray = [Int](1942...2000)
        
        pickerData = [
            dayArray,
            monthArray,
            yearArray
            ]
        
        picker.selectRow(pickerRowMiddles[0] + day - dayArray.first!, inComponent: 0, animated: false)
        picker.selectRow(pickerRowMiddles[1] + month - monthArray.first!, inComponent: 1, animated: false)
        picker.selectRow(pickerRowMiddles[2] + year - yearArray.first!, inComponent: 2, animated: false)
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        print("picker data components : \(pickerData.count)")
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print("picker data rows in component : \(pickerData[component].count)")
        return 10000 // pickerData[component].count
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let l = UILabel()
    
        if component == 1 {
            l.text = monthsAsStrings[row % pickerData[component].count]
        } else {
            l.text = String(pickerData[component][row % pickerData[component].count])
        }
        l.textAlignment = NSTextAlignment.Center
        l.backgroundColor = GlobalConstants.ColorPalette.SecondaryColorDark
        l.font = UIFont(name: "Arial", size: 14.0)
        l.textColor = UIColor.whiteColor()
        l.layer.cornerRadius = 5.0
        l.clipsToBounds = true
        return l
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let newRow = pickerRowMiddles[component] + (row % pickerData[component].count)
        pickerView.selectRow(newRow, inComponent: component, animated: false)
        var dateNotSet = true
        repeat {
        if let possibleDate = setNewDate(year: valueForRow(picker.selectedRowInComponent(2), component: 2), month: valueForRow(picker.selectedRowInComponent(1), component: 1), day: valueForRow(picker.selectedRowInComponent(0), component: 0)) {
            currentUser!.dateOfBirth = possibleDate
            dateNotSet = false
        } else {
            picker.selectRow(picker.selectedRowInComponent(0) - 1, inComponent: 0, animated: true)
        }
        } while dateNotSet
    }
    
}
