//
//  InterfaceController.swift
//  com.cashlee.parrotwatch Extension
//
//  Created by CashLee on 16/6/7.
//  Copyright © 2016年 Parrot. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion


class InterfaceController: WKInterfaceController {
    
    var motionMgr:CMMotionManager?

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        
        let motionManager:CMMotionManager = CMMotionManager.init()
        self.motionMgr = motionManager
        
        let action1 = WKAlertAction(title: "OK", style: .Cancel) {}
        if((self.motionMgr?.accelerometerAvailable) != nil){
            self.presentAlertControllerWithTitle("Ready", message: "Accelerometer is ready", preferredStyle: .Alert , actions: [action1])
        }else{
            self.presentAlertControllerWithTitle("Error", message: "No Accelerometer", preferredStyle: .Alert , actions: [action1])
        }
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        //handle methods of acceleration
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
