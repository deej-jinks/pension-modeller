//
//  ContributionRateSelectionViewController.swift
//  DCModeller
//
//  Created by Daniel Jinks on 21/05/2016.
//  Copyright © 2016 Daniel Jinks. All rights reserved.
//

import UIKit
import CoreData

class ContRateSelectionViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    
    @IBOutlet weak var picker: UIPickerView! {
        didSet {
            picker.dataSource = self
            picker.delegate = self
        }
    }

    @IBOutlet weak var infoBox: UIView! {
        didSet {
            infoBox.alpha = 0.0
        }
    }
    @IBOutlet weak var infoText: UILabel!
    
    let cornerRadius:CGFloat = 7.5
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
    
    var pickerData = GlobalConstants.ContributionRateIncrements
    
    func rowForValue(value: Double) -> Int {
        var r = 0
        for i in 0..<pickerData.count {
            if value == pickerData[i] {
                r = i
            }
        }
        return r
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print ("pickerData : \(pickerData)")
        if let rate = currentDCPension!.totalContributionRate {
            picker.selectRow(rowForValue(Double(rate)),inComponent: 0, animated: false)
        } else {
        picker.selectRow(rowForValue(0.0), inComponent: 0, animated: false)
        }

    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let l = UILabel()

        let percentFormatter = createPercentageNumberFormatter()
        l.text = percentFormatter.stringFromNumber(pickerData[row])

        l.textAlignment = NSTextAlignment.Center
        l.backgroundColor = GlobalConstants.ColorPalette.SecondaryColorDark
        l.font = UIFont(name: "Arial", size: 14.0)
        l.textColor = UIColor.blackColor()
        l.layer.cornerRadius = 5.0
        l.clipsToBounds = true
        return l
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentDCPension?.totalContributionRate = Double(pickerData[row])
        if let salary = currentUser!.salary {
            let monthlyConts = Double(salary) * Double(currentDCPension!.totalContributionRate!) / 12
            let formatter = createNumberFormatter(maxValue: 1000.0, prefix: "£")
            infoText.text = "Based on the salary figure you have entered,\nthat is around " + formatter.stringFromNumber(monthlyConts)! + " per month (gross)"
            UIView.animateWithDuration(0.5) {
                self.infoBox.alpha = 1.0
            }
        }
    }

}
