//
//  ViewController.swift
//  Makeathon
//
//  Created by Bryan Cooper on 1/20/18.
//  Copyright © 2018 Bryan Cooper. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import EstimoteProximitySDK

//The ViewController class is a single page instance that handles user events
//when entering/leaving the area and then update the client's view and database accordingly.
class ViewController: UIViewController {

    //Reference to the firebase database
    var ref: DatabaseReference?
    
    //UI element for the text prompt
    @IBOutlet weak var namePrompt: UILabel!

    //UI element representing the green beacon named 'mint'
    @IBOutlet weak var greenLabel: UILabel!
    
    //UI element representing the blue beacon named 'ice'
    @IBOutlet weak var blueLabel: UILabel!
    
    //UI element representing the purple beacon named 'blueberry'
    @IBOutlet weak var purpleLabel: UILabel!
    
    //self.ref!.child("users").setValue(["username": userName])
    
    //Hardcoded beacon uuid's
    let beaconIdentifiers = ["930a216139e0e5fe0b99f2bf730a4d3e",
                             "cbf30d6f18e2a50db958c838ff58cc18",
                             "f14091bdeade69ceb286d0ee6bbb8f25"]
    
    let mintColor = UIColor(red: 155/255.0, green: 186/255.0, blue: 160/255.0, alpha: 1.0)
    
    let blueberryColor = UIColor(red:  36/255.0, green:  24/255.0, blue:  93/255.0, alpha: 1.0)
    
    let iceColor = UIColor(red: 153/255.0, green: 1, blue: 1, alpha: 1.0)
    
    var proximityObserver: EPXProximityObserver!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseApp.configure()
        ref = Database.database().reference()

        labelSetup()

        let credentials = EPXCloudCredentials(appID: "makeathon-ccm", appToken: "4e3f2e89fba814ec55602771970a81a2")
        self.proximityObserver = EPXProximityObserver(credentials: credentials, errorBlock: { error in
            print("Ooops! \(error)")
        })
        
        let purpleZone = EPXProximityZone(range: EPXProximityRange.custom(desiredMeanTriggerDistance: 1.0)!,
                                             attachmentKey: "desk",
                                             attachmentValue: "blueberry")
        
        purpleZone.onEnterAction = { attachment in
            print("Enter purple (close range)")
            self.purpleLabel.backgroundColor = self.blueberryColor
            self.purpleLabel.textColor = UIColor.white
        }
        purpleZone.onExitAction = { attachment in
            print("Exit purple (close range)")
            self.purpleLabel.backgroundColor = UIColor.white
            self.purpleLabel.textColor = self.blueberryColor
        }
        
        let greenZone = EPXProximityZone(range: EPXProximityRange.custom(desiredMeanTriggerDistance: 1.0)!,
                                        attachmentKey: "desk",
                                        attachmentValue: "mint")
        greenZone.onEnterAction = { attachment in
            print("Enter green (close range)")
            self.greenLabel.backgroundColor = self.mintColor
            self.greenLabel.textColor = UIColor.white
        }
        greenZone.onExitAction = { attachment in
            print("Exit green (close range)")
            self.greenLabel.backgroundColor = UIColor.white
            self.greenLabel.textColor = self.mintColor
        }
        
        let blueZone = EPXProximityZone(range: EPXProximityRange.custom(desiredMeanTriggerDistance: 1.0)!,
                                         attachmentKey: "desk",
                                         attachmentValue: "ice")
        blueZone.onEnterAction = { attachment in
            print("Enter blue (close range)")
            self.blueLabel.backgroundColor = self.iceColor
            self.blueLabel.textColor = UIColor.white
        }
        blueZone.onExitAction = { attachment in
            print("Exit blue (close range)")
            self.blueLabel.backgroundColor = UIColor.white
            self.blueLabel.textColor = self.iceColor
        }
        
        //Used to log proximity beacons in close range
        /*let closeVenueZone = EPXProximityZone(range: EPXProximityRange.custom(desiredMeanTriggerDistance: 0.5)!,
                                              attachmentKey: "venue",
                                              attachmentValue: "office")
        closeVenueZone.onChangeAction = { attachmentsInside in
            print("Currently, there are \(attachmentsInside.count) attachments in close range:")
            print("\(attachmentsInside.map({ $0.payload.description }).joined(separator: "\n"))")
            print("")
        }*/
        
        //Used to log proximity beacons in mid range
        /*let midVenueZone = EPXProximityZone(range: EPXProximityRange.custom(desiredMeanTriggerDistance: 1.5)!,
                                            attachmentKey: "venue",
                                            attachmentValue: "office")
        midVenueZone.onEnterAction = { attachment in
            print("Enter venue (mid range)")
            self.venueLabel.backgroundColor = self.venueColor
            self.venueLabel.textColor = UIColor.white
        }
        midVenueZone.onExitAction = { attachment in
            print("Exit venue (mid range)")
            self.venueLabel.backgroundColor = UIColor.white
            self.venueLabel.textColor = self.venueColor
        }
        midVenueZone.onChangeAction = { attachmentsInside in
            print("Currently, there are \(attachmentsInside.count) attachments in mid range:")
            print("\(attachmentsInside.map({ $0.payload.description }).joined(separator: "\n"))")
            print("")
        }*/
        
        self.proximityObserver.startObserving([greenZone, purpleZone, blueZone])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Conduct the inital setup for the UI elements representing the beacons
    func labelSetup() {
        self.namePrompt.layer.borderWidth = 2.0
        self.namePrompt.layer.cornerRadius = 8
        self.namePrompt.layer.masksToBounds = true
        
        self.purpleLabel.layer.borderWidth = 2.0
        self.purpleLabel.layer.cornerRadius = 10
        self.purpleLabel.layer.masksToBounds = true
        self.purpleLabel.textColor = self.blueberryColor
        self.purpleLabel.backgroundColor = UIColor.white
        
        self.blueLabel.layer.borderWidth = 2.0
        self.blueLabel.layer.cornerRadius = 10
        self.blueLabel.layer.masksToBounds = true
        self.blueLabel.textColor = self.iceColor
        self.blueLabel.backgroundColor = UIColor.white
        
        self.greenLabel.layer.borderWidth = 2.0
        self.greenLabel.layer.cornerRadius = 10
        self.greenLabel.layer.masksToBounds = true
        self.greenLabel.textColor = self.mintColor
        self.greenLabel.backgroundColor = UIColor.white
        
    }

}

