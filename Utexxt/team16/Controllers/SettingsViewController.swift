//
//  SettingsViewController.swift
//  team16
//
//  Created by Zephyr Reames-Zepeda on 11/1/21.
//

import UIKit

class SettingsViewController: UIViewController {

    
    @IBOutlet weak var ThemeSegControl: UISegmentedControl!
    @IBOutlet weak var ZoneSwitch: UISwitch!
    @IBOutlet weak var ZoneColorSwitch: UISwitch!
    @IBOutlet weak var ApplyButton: UIButton!
    
    
    let defaults = UserDefaults.standard
    
    var themeIdx: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = background[defaults.integer(forKey: "theme")]
    }
    

    @IBAction func ThemeSelect(_ sender: Any) {
        switch ThemeSegControl.selectedSegmentIndex {
        
        case 0: //CLASSIC
            themeIdx = 0
            //defaults.set(0, forKey: "theme")
            view.backgroundColor = background[themeIdx]
        case 1: //GREEN
            themeIdx = 1
            //defaults.set(1, forKey: "theme")
            view.backgroundColor = background[themeIdx]
        case 2: //LIGHT
            themeIdx = 2
            //defaults.set(2, forKey: "theme")
            view.backgroundColor = background[themeIdx]
        case 3: //COOL
            themeIdx = 3
            //defaults.set(3, forKey: "theme")
            view.backgroundColor = background[themeIdx]
        default:
            print("")
            //defaults.set(0, forKey: "theme")
            view.backgroundColor = background[themeIdx]
        }
        
    }
    
    
    @IBAction func ShowZones(_ sender: Any) {
        
        if ( ZoneSwitch.isOn){
            defaults.set(1, forKey: "zoneDisplay")
            print("zones on")
        }
        
        else {
            defaults.set(0, forKey: "zoneDisplay")
            print("zones off")
        }
        
    }
    
    
    @IBAction func ShowZoneColors(_ sender: Any) {
        if ( ZoneColorSwitch.isOn){
            defaults.set(1, forKey: "zoneColors")
            print("zone colors on")
        }
        
        else {
            defaults.set(0, forKey: "zoneColors")
            print("zone colors off")
        }
        
    }
    
    @IBAction func ApplySettings(_ sender: Any) {
        defaults.set(themeIdx, forKey: "theme")
        view.backgroundColor = background[defaults.integer(forKey: "theme")]
        print(defaults.integer(forKey: "theme"))

    }
}
