//
//  customerChat.swift
//  team16
//
//  Created by Zephyr Reames-Zepeda on 12/2/21.
//

import UIKit
import CometChatPro
import CoreLocation
class customerChat: CometChatMessageList {
    
    var currChannel : String?
    let zoneCoords : [[Double]] = [[30.290182089540327,30.285216375887074, -97.72718092833297, -97.7337791625122],   //channel 1 orange
                  [30.285216375887074, 30.283196666738217, -97.72851130400277, -97.7337791625122],      //channel 2 orange
                  [30.283196666738217, 30.279268305967584, -97.72851130400277, -97.73360077473963],     //channel 3 Green
                  [30.283196666738217,30.279268305967584, -97.73360077473963, -97.73926936608133],      //channel 4 red
                  [30.287220439300377, 30.283196666738217, -97.73701713938787,-97.7337791625122],       //channel 5 blue
                  [30.287220439300377,30.283196666738217, -97.74156927166374, -97.73701713938787],      //channel 6 purple
                  [30.28981778243186, 30.287220439300377, -97.74140273655678, -97.73701713938787],      //channel 7 yellow
                  [30.291970612246143, 30.28981778243186, -97.74140273655678, -97.73701713938787],      //channel 8 indigo
                  [30.278577706154252, 30.275923837641706 , -97.73047001223706, -97.73598573351477]]


    let defaults = UserDefaults.standard
    override func viewDidLoad(){
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = background[defaults.integer(forKey: "theme")]
        //checkZones()
    }
    
    override func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.curentLocation = location
        
       // checkZones()
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            //leave group
        let guid : String = "\(currentGroup!.guid as String)"


        print(guid)
        CometChat.leaveGroup(GUID: guid, onSuccess: { (response) in

            print("Left group successfully.")

        }) { (error) in

          print("Group leaving failed with error:" + error!.errorDescription);
        }
            
    }

 
    func checkZones() {
        var found = false
        var userLat : Double  = (self.curentLocation?.coordinate.latitude)!
        var userLong : Double = (self.curentLocation?.coordinate.longitude)!

        var channelNumber = 0
        for zone in zoneCoords {
            print("running Through")
                    channelNumber = channelNumber + 1
                    if userLat <= zone[0] && userLat >= zone[1] && userLong >= zone[3] && userLong <= zone[2] {
                        currChannel = "Channel\(channelNumber)"
                        found = true;
                    
                    }
        
            if (!found){
                DispatchQueue.main.async{
                    self.navigationController?.popViewController(animated: true)
                }
            }
        
        
        
    }

    }
//    func startCheckingLocation(){
//        DispatchQueue.global(qos: .userInitiated).async {
//  for zone in zoneCoords {


}
//            DispatchQueue.main.async {
//              print("This is run on the main queue, after the previous code in outer block")
//            }
//        }
//    }

