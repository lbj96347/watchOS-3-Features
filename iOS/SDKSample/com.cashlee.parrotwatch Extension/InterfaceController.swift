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
    var motionQueue:OperationQueue?

    var altimeterMgr:CMAltimeter?
    var altimeterQueue:OperationQueue?

    var defaultSession:WCSession?

    var crowDelegate: CrowDelegate?

    @IBOutlet var statusLabel: WKInterfaceButton!
    @IBOutlet var xLabel: WKInterfaceLabel!
    @IBOutlet var yLabel: WKInterfaceLabel!
    @IBOutlet var zLabel: WKInterfaceLabel!

    override func awake(withContext context: AnyObject?) {
        super.awake(withContext: context)
        // Configure interface objects here.

        let motionManager:CMMotionManager = CMMotionManager.init()
        self.motionMgr = motionManager
        self.motionQueue = OperationQueue.main()
        self.motionMgr?.accelerometerUpdateInterval = 0.35 //Hit the prioaty send too much message

        /*
         let altimeterManager:CMAltimeter = CMAltimeter.init()
         self.altimeterMgr = altimeterManager
         self.altimeterQueue = NSOperationQueue.mainQueue()
         */

        if(WCSession.isSupported()){
            self.defaultSession = WCSession.default()
            self.defaultSession?.delegate = self;
            self.defaultSession?.activate()
        }

        initCrowDelegate()
    }

    func initCrowDelegate() {
        if #available(watchOSApplicationExtension 3.0, *) {
            crowDelegate = CrowDelegate()
            crownSequencer.delegate = crowDelegate
            crownSequencer.focus()
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()

        if( self.motionMgr?.isAccelerometerAvailable == true ){
            //self.presentAlertControllerWithTitle("Ready", message: "Accelerometer is ready", preferredStyle: .Alert , actions: [action1])
            self.statusLabel?.setTitle("Start")
        }else{
            //self.presentAlertControllerWithTitle("Error", message: "No Accelerometer", preferredStyle: .Alert , actions: [action1])
            self.statusLabel?.setTitle("Error")
        }

        if(WCSession.isSupported()){
            self.defaultSession?.sendMessage(["msg":"hello"], replyHandler: { (replyMsg) in
                //
                }, errorHandler: { (error) in
                    //
            })
        }

        //handle methods of acceleration

    }

    @IBAction func switchMotion(sender:AnyObject){

        if( self.motionMgr?.isAccelerometerActive == false ){


            self.xLabel?.setText("x : 0")
            self.yLabel?.setText("y : 0")
            self.zLabel?.setText("z : 0")

            /*
             self.altimeterMgr?.startRelativeAltitudeUpdatesToQueue(self.altimeterQueue!, withHandler: { (altitudeData, error) in
             let altitude:CMAltitudeData = altitudeData!
             let sendData:NSDictionary = ["altitude" : ["relativeAltitude": altitude.relativeAltitude , "pressure" : altitude.pressure ]]
             if(WCSession.isSupported()){
             self.defaultSession?.sendMessage( sendData as! [String : AnyObject] , replyHandler: { (replyMsg) in
             //
             }, errorHandler: { (error) in
             //
             })
             }
             })
             */

            self.motionMgr?.startAccelerometerUpdates(to: self.motionQueue!, withHandler: { (accel, error) in
                if((error == nil)){

                    self.statusLabel?.setTitle("Stop")

                    let data:CMAcceleration = (accel?.acceleration)!
                    print("ok \n x is : %@ \n and y is %@ \n z is %@" , data.x , data.y , data.z)
                    let x:String = String("x : \(data.x)" )
                    let y:String = String("y : \(data.y)" )
                    let z:String = String("z : \(data.z)" )
                    self.xLabel?.setText(x)
                    self.yLabel?.setText(y)
                    self.zLabel?.setText(z)

                    //let sendData:NSDictionary =  ["acceletation" : [ "x" : data.x , "y" : data.y , "z" : data.z ]]

                    let sendData:NSDictionary =  [ "x" : data.x , "y" : data.y , "z" : data.z ]

                    if(WCSession.isSupported()){

                        self.defaultSession?.sendMessage( sendData as! [String : AnyObject] , replyHandler: { (replyMsg) in
                            //
                            }, errorHandler: { (error) in
                                //
                        })
                    }


                }else{
                    print(error?.localizedDescription)

                    self.statusLabel?.setTitle("Restart")
                }
            })


        }else{

            self.motionMgr?.stopAccelerometerUpdates()

            self.altimeterMgr?.stopRelativeAltitudeUpdates()

            self.statusLabel?.setTitle("Start")

        }

    }

    @IBAction func testSendMsg(){
        print("Send test msg")
        if(WCSession.isSupported()){
            self.defaultSession?.sendMessage(["msg":"Test"], replyHandler: { (replyMsg) in
                //
                }, errorHandler: { (error) in
                    //
            })
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: NSError?) {
        //
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
}
