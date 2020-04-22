//
//  Utterance.swift
//  Compass
//
//  Created by 邱天鈜 on 4/19/20.
//  Copyright © 2020 Tony_Qiu. All rights reserved.
//

import UIKit
import AVFoundation

class Utterance: UIViewController {
    
    @IBOutlet weak var ConcentButton: UIButton!
    
    @IBOutlet weak var Stack: UIStackView!
    
    @IBOutlet weak var CautionImg: UIImageView!
    @IBOutlet weak var CautionLabel: UILabel!
    
    @IBOutlet weak var Utterance: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConcentButton.layer.cornerRadius = 19
        ConcentButton.layer.shadowRadius = 3
        ConcentButton.layer.shadowOpacity = 0.3
        ConcentButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        ConcentButton.layer.shadowColor = UIColor.black.cgColor
        // Do any additional setup after loading the view.
        
        Stack.setCustomSpacing(30.0,after: CautionImg)
        
        Stack.setCustomSpacing(10.0,after: CautionLabel)
        
        //Speak when app starts
                let utterance = AVSpeechUtterance(string:"Please be cautious while using this application and mind your surroundings before walking. ")
                utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                utterance.rate = 0.6
        
                let synthesizer = AVSpeechSynthesizer()
                synthesizer.speak(utterance)
       
        
        
    }
    
    @IBAction func Agreed(_ sender: Any) {
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
