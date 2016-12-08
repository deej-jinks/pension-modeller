//
//  GenderSelectionViewController.swift
//  DCModeller
//
//  Created by Daniel Jinks on 21/05/2016.
//  Copyright © 2016 Daniel Jinks. All rights reserved.
//

import UIKit
import CoreData

class GenderSelectionViewController: UIViewController {
    
    @IBOutlet weak var genderSelector: UISegmentedControl! {
        didSet {
            if let male = currentUser!.isMale {
                if Bool(male) {
                    genderSelector.selectedSegmentIndex = 0
                } else {
                    genderSelector.selectedSegmentIndex = 1
                }
            } else {
                genderSelector.selectedSegmentIndex = 1
                currentUser!.isMale = false
            }
        }
    }
    
    let cornerRadius: CGFloat = 7.5
    @IBOutlet var contentBoxes: [UIView]! {
        didSet {
            for box in contentBoxes {
                box.layer.cornerRadius = cornerRadius
                box.layer.shadowColor = UIColor.black.cgColor
                box.layer.shadowOpacity = 0.4
                box.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func genderSelectionChanged(_ sender: UISegmentedControl) {
        currentUser!.isMale = NSNumber(value: (sender.selectedSegmentIndex == 0))
    }
}
