//
//  ChatViewController.swift
//  team16
//
//  Created by Zephyr Reames-Zepeda on 11/1/21.
//
// UserDefaults = store uid for cometChat
// UserDefaults = store firebase stuff for efficiency
// profile picture is stored on Firebase 

import UIKit
import CometChatPro
import CoreLocation

class ChatConnectController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var status: UILabel!
   
    var found = false
    let defaults = UserDefaults.standard
    let zoneCoords : [[Double]] = [[30.290182089540327,30.285216375887074, -97.72718092833297, -97.7337791625122],   //channel 1 orange
                  [30.285216375887074, 30.283196666738217, -97.72851130400277, -97.7337791625122],      //channel 2 orange
                  [30.283196666738217, 30.279268305967584, -97.72851130400277, -97.73360077473963],     //channel 3 Green
                  [30.283196666738217,30.279268305967584, -97.73360077473963, -97.73926936608133],      //channel 4 red
                  [30.287220439300377, 30.283196666738217, -97.73701713938787,-97.7337791625122],       //channel 5 blue
                  [30.287220439300377,30.283196666738217, -97.74156927166374, -97.73701713938787],      //channel 6 purple
                  [30.28981778243186, 30.287220439300377, -97.74140273655678, -97.73701713938787],      //channel 7 yellow
                  [30.291970612246143, 30.28981778243186, -97.74140273655678, -97.73701713938787],      //channel 8 indigo
                  [30.278577706154252, 30.275923837641706 , -97.73047001223706, -97.73598573351477]]
    
    let locManager = CLLocationManager()
    var currentLocation : CLLocation?
    var currentChannel : String?
   
    @IBOutlet weak var connectButton: UIButton!
    @IBAction func connectButtonPressed(_ sender: Any) {
        if found {
            self.openChat()
        }
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locManager.location
        } else {
            locManager.requestWhenInUseAuthorization()
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = background[defaults.integer(forKey: "theme")]
        placeUserInChat()
        print("COMEETTT \(userComet)")
        let uid : String = userComet! as String
        print(uid)
        let authKey = "50264e3ed1337364db7f5211bb956e9387b2d7d0"
        
        if found {
        CometChat.login(UID: uid, apiKey: authKey, onSuccess: { (user) in
        
            print("Logged IN" + user.stringValue())
            self.locManager.requestWhenInUseAuthorization();
            let guid = self.currentChannel!
            let password = ""// mandatory in case of password protected group type
            CometChat.joinGroup(GUID: guid, groupType: .public, password: nil, onSuccess: { (group) in

        print("Group joined successfully. " + group.stringValue())

        }) { (error) in
          print("Group joining failed with error:" + error!.errorDescription);
        }
        
        }) { (error) in
            print("Login Failed with erorr : " + error.errorDescription)
        }
        
        }
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locManager.startUpdatingLocation()
        // Do any additional setup after loading the view.
        locationAuthStatus()
    
        }
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {print("failed"); return}
    
    }
    
        
func openChat() {
   DispatchQueue.main.async {
          //let chat
       let messageList = customerChat()
       let group = Group(guid: self.currentChannel!, name: "Live Event Chat", groupType: .public, password: nil)
       messageList.set(conversationWith: group, type: .group)
       self.navigationController?.pushViewController(messageList,animated: true)
   }
    
    
}
    func placeUserInChat() {

        var channelNumber = 0
        found = false
        connectButton.setTitle("Not Found", for: .normal)
    
       // 30.290182089540327,30.285216375887074, -97.72718092833297, -97.7337791625122]
        var userLat : Double  = 30.290182089540327
        var userLong : Double = -97.72718092833297
        
        for zone in zoneCoords {
  
                    channelNumber = channelNumber + 1
                    if userLat <= zone[0] && userLat >= zone[1] && userLong >= zone[3] && userLong <= zone[2] {
                        connectButton.setTitle("Connect to channel #\(channelNumber)", for: .normal)
                        currentChannel = "Channel\(channelNumber)"
                        found = true;
                    }
        }
        
        if !found {
            connectButton.setTitle("No channel available", for: .normal)
            status.text = "Try walking to a Channel Zone"
        }
    }
}
