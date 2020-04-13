//
//  ViewController.swift
//  CSCE 482
//
//  Created by Caroline Guan on 4/6/20.
//  Copyright © 2020 482. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var test: UILabel!

    @IBOutlet weak var startButton: UIButton!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        //request authorization for postitioning
        locationManager?.requestAlwaysAuthorization()
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //if user grants authorization then start updating heading
        if status == .authorizedAlways {
            locationManager?.startUpdatingHeading()
                        
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        //update readings after starting updating heading
        //heading relevent to the magnetic pole
        textLabel.text = "Magnetic Heading：\(newHeading.magneticHeading)"
    }
    
    @IBAction func buttonTouched(_ sender: UIButton) {
        test.text = "touch"
    }
}

