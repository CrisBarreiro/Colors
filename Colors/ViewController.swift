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
    
    private var deltaAngle: CGFloat?
    private var startTransform: CGAffineTransform?
    //Knob upper dot position
    private var setPointAngle = Double.pi / 2
    private var maxAngle = 7 * Double.pi / 6
    private var minAngle = 0 - (Double.pi / 6)
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgKnob.isHidden = true
        imgKnob.isUserInteractionEnabled = true
        imgKnobBase.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        btnSwitch.setImage(#imageLiteral(resourceName: "img_switch_off"), for: .normal)
        btnSwitch.setImage(#imageLiteral(resourceName: "img_switch_on"), for: .selected)
    }

    @IBAction func btnSwitchPressed(_ sender: UIButton) {
        btnSwitch.isSelected = !btnSwitch.isSelected
        if (btnSwitch.isSelected) {
            resetKnob()
            imgKnobBase.isHidden = false
            imgKnob.isHidden = false
        } else {
            view.backgroundColor = UIColor(hue: 0.5, saturation: 0, brightness: 0.2, alpha: 1.0)
            imgKnobBase.isHidden = true
            imgKnob.isHidden = true
        }
    }
    
    func resetKnob() {
        view.backgroundColor = UIColor(hue: 0.5, saturation: 0.5, brightness: 0.75, alpha: 1.0)
        imgKnob.transform = CGAffineTransform.identity
        setPointAngle = Double.pi / 2
    }

    private func touchIsInKnobWithDistance (distance:CGFloat) -> Bool {
        //Calculate radius
        if distance > (imgKnob.bounds.height / 2) {
            return false
        }
        return true
    }
    
    //Pythagoras Theorem
    private func calculateDistanceFromCenter(_ point: CGPoint) -> CGFloat {
        let center = CGPoint(x: imgKnob.bounds.size.width / 2.0, y: imgKnob.bounds.size.height / 2.0)
        let dx = point.x - center.x
        let dy = point.y - center.y
        return sqrt((dx * dx) + (dy * dy))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: imgKnob)
            let dist = calculateDistanceFromCenter(position)
            if touchIsInKnobWithDistance(distance: dist) {
                startTransform = imgKnob.transform
                let center = CGPoint(x: imgKnob.bounds.size.width / 2.0, y: imgKnob.bounds.size.height / 2.0)
                let deltaX = position.x - center.x
                let deltaY = position.y - center.y
                deltaAngle = atan2(deltaY, deltaX)
            }
            
        }
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first,
            let deltaAngle = deltaAngle,
            let startTransform = startTransform,
            touch.view == imgKnob{
            let position = touch.location(in: imgKnob)
            let dist = calculateDistanceFromCenter(position)
            if touchIsInKnobWithDistance(distance: dist) {
                //Calculate angle
                let center = CGPoint(x: imgKnob.bounds.size.width / 2.0, y: imgKnob.bounds.size.height / 2.0)
                let deltaX = position.x - center.x
                let deltaY = position.y - center.y
                let angle = atan2(deltaY, deltaX)
                
                //Calculate distance with previous one
                let angleDiff = deltaAngle - angle
                //Rotate image
                let newTransform = startTransform.rotated(by: -angleDiff)
                let lastSetPointAngle = setPointAngle
                
                //Check limits
                setPointAngle = setPointAngle + Double(angleDiff)
                if setPointAngle >= minAngle && setPointAngle <= maxAngle {
                    //Change background color and move knob
                    view.backgroundColor = UIColor(hue: colorValueFromAngle(angle: setPointAngle), saturation: 0.75, brightness: 0.75, alpha: 1.0)
                    imgKnob.transform = newTransform
                    self.startTransform = newTransform
                } else {
                    setPointAngle = lastSetPointAngle
                }
                
            }
        }
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.view == imgKnob {
                deltaAngle = nil
                startTransform = nil
            }
        }
        super.touchesEnded(touches, with: event)
    }
    
    private func colorValueFromAngle(angle: Double) -> CGFloat {
        let hueValue = (angle - minAngle) * (360 / (maxAngle - minAngle))
        return CGFloat(hueValue / 360)
    }
}

