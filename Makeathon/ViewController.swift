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

class ViewController: UIViewController{

    //Reference to the firebase database
    var ref: DatabaseReference?
    
    //UI element for the text prompt
    @IBOutlet weak var namePrompt: UILabel!

    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var purpleLabel: UILabel!
    //self.ref!.child("users").setValue(["username": userName])
    
    //Hardcoded beacon uuid's
    let beaconIdentifiers = ["930a216139e0e5fe0b99f2bf730a4d3e",
                             "cbf30d6f18e2a50db958c838ff58cc18",
                             "f14091bdeade69ceb286d0ee6bbb8f25"]
    
    let mintColor = UIColor(red: 155/255.0, green: 186/255.0, blue: 160/255.0, alpha: 1.0)
    
    let blueberryColor = UIColor(red:  36/255.0, green:  24/255.0, blue:  93/255.0, alpha: 1.0)
    
    let blue = UIColor.blue
    
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
        
        let purpleZone = EPXProximityZone(range: EPXProximityRange.custom(desiredMeanTriggerDistance: 0.5)!,
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
        
        let greenZone = EPXProximityZone(range: EPXProximityRange.custom(desiredMeanTriggerDistance: 0.5)!,
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
        
        let blueZone = EPXProximityZone(range: EPXProximityRange.custom(desiredMeanTriggerDistance: 0.5)!,
                                         attachmentKey: "desk",
                                         attachmentValue: "ice")
        blueZone.onEnterAction = { attachment in
            print("Enter blue (close range)")
            self.greenLabel.backgroundColor = self.blue
            self.greenLabel.textColor = UIColor.white
        }
        blueZone.onExitAction = { attachment in
            print("Exit blue (close range)")
            self.greenLabel.backgroundColor = UIColor.white
            self.greenLabel.textColor = self.blue
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

    func labelSetup() {
        namePrompt.layer.borderWidth = 2.0
        namePrompt.layer.borderColor = mintColor
        namePrompt.layer.cornerRadius = 8
        namePrompt.layer.masksToBounds = true
        
        purpleLabel.layer.borderWidth = 2.0
        purpleLabel.layer.borderColor = blueberry
        purpleLabel.layer.cornerRadius = 10
        purpleLabel.layer.masksToBounds = true
        purpleLabel.backgroundColor = UIColor.white
        
        blueLabel.layer.borderWidth = 2.0
        blueLabel.layer.borderColor = blue
        blueLabel.layer.cornerRadius = 10
        blueLabel.layer.masksToBounds = true
        blueLabel.backgroundColor = UIColor.white
        
        greenLabel.layer.borderWidth = 2.0
        greenLabel.layer.borderColor = mintColor
        greenLabel.layer.cornerRadius = 10
        greenLabel.layer.masksToBounds = true
        greenLabel.backgroundColor = UIColor.white
        
    }

}

