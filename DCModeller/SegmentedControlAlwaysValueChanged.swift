//
//  SegmentedControlThatAlwaysFiresOnTouch.swift
//  F1rstPension
//
//  Created by Daniel Jinks on 10/06/2016.
//  Copyright © 2016 Daniel Jinks. All rights reserved.
//

import UIKit

class SegmentedControlAlwaysValueChanged: UISegmentedControl {

    // captures existing selected segment on touchesBegan
    var oldValue : Int!
    
    override func touchesBegan( _ touches: Set<UITouch>, with event: UIEvent? )
    {
        self.oldValue = self.selectedSegmentIndex
        super.touchesBegan( touches , with: event )
    }
    
    // This was the key to make it work as expected
    override func touchesEnded( _ touches: Set<UITouch>, with event: UIEvent? )
    {
        super.touchesEnded( touches , with: event )
        
        if self.oldValue == self.selectedSegmentIndex
        {
            sendActions( for: .valueChanged )
        }
    }

}
