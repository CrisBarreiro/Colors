//
//  ViewController.swift
//  Colors
//
//  Created by cristina on 19/8/17.
//  Copyright © 2017 crisbarreiro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var btnSwitch: UIButton!
    @IBOutlet weak var imgKnobBase: UIImageView!
    @IBOutlet weak var imgKnob: UIImageView!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgKnob.isHidden = true
        imgKnobBase.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        btnSwitch.setImage(#imageLiteral(resourceName: "img_switch_off"), for: .normal)
        btnSwitch.setImage(#imageLiteral(resourceName: "img_switch_on"), for: .selected)
    }

    @IBAction func btnSwitchPressed(_ sender: UIButton) {
        btnSwitch.isSelected = !btnSwitch.isSelected
        if (btnSwitch.isSelected) {
            view.backgroundColor = UIColor(hue: 0.5, saturation: 0.5, brightness: 0.75, alpha: 1.0)
            imgKnobBase.isHidden = false
            imgKnob.isHidden = false
        } else {
            view.backgroundColor = UIColor(hue: 0.5, saturation: 0, brightness: 0.2, alpha: 1.0)
            imgKnobBase.isHidden = true
            imgKnob.isHidden = true
        }
    }

    
}

