//
//  LandingViewController.swift
//  team16
//
//  Created by Zephyr Reames-Zepeda on 12/2/21.
//

import UIKit

class LandingViewController: UIViewController {

    @IBOutlet weak var SignIn: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0.9294, green: 0.5882, blue: 0.1451, alpha: 1)
        backgroundImage.image = UIImage(named: "utextlogo")
    }

}
