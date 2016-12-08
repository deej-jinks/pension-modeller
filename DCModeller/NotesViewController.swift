//
//  NotesViewController.swift
//  F1rstPension
//
//  Created by Daniel Jinks on 01/06/2016.
//  Copyright © 2016 Daniel Jinks. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {

    let cornerRadius: CGFloat = 5.0
    
    @IBOutlet var viewsToRound: [UIView]! {
        didSet {
            for view in viewsToRound {
                view.layer.cornerRadius = cornerRadius
                view.layer.shadowColor = UIColor.black.cgColor
                view.layer.shadowOpacity = 0.4
                view.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
