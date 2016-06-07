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
import WatchConnectivity


class InterfaceController: WKInterfaceController , WCSessionDelegate {
    
    var motionMgr:CMMotionManager?
    var motionQueue:NSOperationQueue?
    var defaultSession:WCSession?
    
    @IBOutlet var statusLabel: WKInterfaceButton!
    @IBOutlet var xLabel: WKInterfaceLabel!
    @IBOutlet var yLabel: WKInterfaceLabel!
    @IBOutlet var zLabel: WKInterfaceLabel!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
        let motionManager:CMMotionManager = CMMotionManager.init()
        self.motionMgr = motionManager
        self.motionQueue = NSOperationQueue.mainQueue()
        self.defaultSession = WCSession.defaultSession()
        self.defaultSession?.activateSession()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        /*
        let action1 = WKAlertAction(title: "OK", style: .Cancel) {}
        if((self.motionMgr?.accelerometerAvailable) != nil){
            self.presentAlertControllerWithTitle("Ready", message: "Accelerometer is ready", preferredStyle: .Alert , actions: [action1])
            self.statusLabel?.setTitle("Ready")
        }else{
            self.presentAlertControllerWithTitle("Error", message: "No Accelerometer", preferredStyle: .Alert , actions: [action1])
            self.statusLabel?.setTitle("Error")
        }
         */
        
        self.statusLabel?.setTitle("Start")
        
        self.xLabel?.setText("x : 0")
        self.yLabel?.setText("y : 0")
        self.zLabel?.setText("z : 0")
        
        self.motionMgr?.accelerometerUpdateInterval = 0.1
        
        self.motionMgr?.startAccelerometerUpdatesToQueue(self.motionQueue!, withHandler: { (accel, error) in
            if((error == nil)){
                let data:CMAcceleration = (accel?.acceleration)!
                print("ok \n x is : %@ \n and y is %@ \n z is %@" , data.x , data.y , data.z)
                let x:String = String("x : \(data.x)" )
                let y:String = String("y : \(data.y)" )
                let z:String = String("z : \(data.z)" )
                self.xLabel?.setText(x)
                self.yLabel?.setText(y)
                self.zLabel?.setText(z)
            }else{
                print(error?.localizedDescription)
            }
        })
        
        print("run here...")
        
        //handle methods of acceleration
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
