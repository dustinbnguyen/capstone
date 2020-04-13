//
//  ViewController.swift
//  Compass
//
//  Created by 邱天鈜 on 2/19/20.
//  Copyright © 2020 Tony_Qiu. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    
    var locationManager: CLLocationManager?
    
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        //request authorization for postitioning
        locationManager?.requestAlwaysAuthorization()
        
        let utterance = AVSpeechUtterance(string:"Touch on the screen anywhere to hear what building is in front of you.")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = 0.6

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //if user grants authorization then start updating heading
        if status == .authorizedAlways {
            label5.text = "Start Navigating"
            locationManager?.startUpdatingHeading()
                        
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        //update readings after starting updating heading
        //heading relevent to the magnetic pole
        label1.text = "Magnetic Heading：\(newHeading.magneticHeading)"
        //heading relevent to the true north
        label2.text = "True Heading：\(newHeading.trueHeading)"
        //accuracy between two headings
        label3.text = "Heading Accuracy：\(newHeading.headingAccuracy)"
        label4.text = "Timestamp：\(newHeading.timestamp)"
    }
    
    
    @IBAction func speakButtonPressed(_ sender: UIButton) {
        let utterance = AVSpeechUtterance(string:"You are in front of Zachry Building")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = 0.6

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
}
