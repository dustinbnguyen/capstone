//
//  ViewController.swift
//  CSCE 482
//
//  Created by Caroline Guan on 4/6/20.
//  Copyright © 2020 482. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation
import MapKit
import Foundation


extension UIDevice{
    static func vibrate(){
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
}

class CircularTransition:NSObject {
    
    var circle = UIView()
        
        var startingPoint = CGPoint.zero {
            didSet {
                circle.center = startingPoint
            }
        }
        
        var circleColor = UIColor.white
        
        var duration = 0.3
        
        enum CircularTransitionMode:Int {
            case present, dismiss, pop
        }
        
        var transitionMode:CircularTransitionMode = .present
        
    }

    extension CircularTransition:UIViewControllerAnimatedTransitioning {
        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return duration
        }
        
        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            let containerView = transitionContext.containerView
            
            if transitionMode == .present {
                if let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to) {
                    let viewCenter = presentedView.center
                    let viewSize = presentedView.frame.size
                    
                    circle = UIView()
                    
                    circle.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: startingPoint)
                    
                    circle.layer.cornerRadius = circle.frame.size.height / 2
                    circle.center = startingPoint
                    circle.backgroundColor = circleColor
                    circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    containerView.addSubview(circle)
                    
                    
                    presentedView.center = startingPoint
                    presentedView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    presentedView.alpha = 0
                    containerView.addSubview(presentedView)
                    
                    UIView.animate(withDuration: duration, animations: {
                        self.circle.transform = CGAffineTransform.identity
                        presentedView.transform = CGAffineTransform.identity
                        presentedView.alpha = 1
                        presentedView.center = viewCenter
                        
                        }, completion: { (success:Bool) in
                            transitionContext.completeTransition(success)
                    })
                }
                
            }else{
                let transitionModeKey = (transitionMode == .pop) ? UITransitionContextViewKey.to : UITransitionContextViewKey.from
                
                if let returningView = transitionContext.view(forKey: transitionModeKey) {
                    let viewCenter = returningView.center
                    let viewSize = returningView.frame.size
                    
                    
                    circle.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: startingPoint)
                    
                    circle.layer.cornerRadius = circle.frame.size.height / 2
                    circle.center = startingPoint
                    
                    UIView.animate(withDuration: duration, animations: {
                        self.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                        returningView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                        returningView.center = self.startingPoint
                        returningView.alpha = 0
                        
                        if self.transitionMode == .pop {
                            containerView.insertSubview(returningView, belowSubview: returningView)
                            containerView.insertSubview(self.circle, belowSubview: returningView)
                        }
                        
                        
                        }, completion: { (success:Bool) in
                            returningView.center = viewCenter
                            returningView.removeFromSuperview()
                            
                            self.circle.removeFromSuperview()
                            
                            transitionContext.completeTransition(success)
                            
                    })
                    
                }
                
                
            }
            
        }
        
        
        
        func frameForCircle (withViewCenter viewCenter:CGPoint, size viewSize:CGSize, startPoint:CGPoint) -> CGRect {
            let xLength = fmax(startPoint.x, viewSize.width - startPoint.x)
            let yLength = fmax(startPoint.y, viewSize.height - startPoint.y)
            
            let offestVector = sqrt(xLength * xLength + yLength * yLength) * 2
            let size = CGSize(width: offestVector, height: offestVector)
            
            return CGRect(origin: CGPoint.zero, size: size)
        
        }

}


extension UIColor{
    static let myBlue = UIColor(red: 89, green: 145, blue: 221, alpha: 1 )
}

class ViewController: UIViewController, UIViewControllerTransitioningDelegate{
    
    
    @IBOutlet weak var buildingNames: UILabel!
    
//    var locationManager: CLLocationManager?
    @IBOutlet weak var textLabel: UILabel!
    
    var transition = CircularTransition()
    
    
    
//  let transition = Circular
    @IBOutlet weak var startButton: UIButton!
    
    
//    //global vars
//    var currentHeading: CLHeading? = nil;
//    var isNavigating = false
//
//    //define Collections
//     struct Collection : Decodable {
//        let type : String
//        let features : [Feature]
//    }
//
//    struct Feature : Decodable {
//        let type : String
//        let properties : Properties
//        let geometry: Geometry
//
//    }
//
//    struct Properties : Decodable {
//        let name : String?
//    }
//
//    struct  Geometry: Decodable {
//        let type: String
//        let coordinates: [Double]
//    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        locationManager = CLLocationManager()
//        locationManager?.delegate = self
//        //request authorization for postitioning
//        locationManager?.requestAlwaysAuthorization()
        
        //Speak when app starts
//        let utterance = AVSpeechUtterance(string:"Please be cautious while using this application and mind your surroundings before walking. Touch the middle of the screen to hear what building is in front of you.")
//        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
//        utterance.rate = 0.6
//
//        let synthesizer = AVSpeechSynthesizer()
//        synthesizer.speak(utterance)
        
        
        loadInterface()
        
    }
    
    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        //if user grants authorization then start updating heading
//        if status == .authorizedAlways || status == .authorizedWhenInUse {
//
//            locationManager?.startUpdatingHeading()
//            locationManager?.startUpdatingLocation()
//
//        }
//    }

    
//    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
//        //update readings after starting updating heading
//        //heading relevent to the magnetic pole
//        currentHeading = newHeading
////        textLabel.text = "Magnetic Heading：\(newHeading.magneticHeading)"
//    }
    
    
    
    @IBAction func buttonPressed(_ sender: Any) {
        UIDevice.vibrate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let sceondVC = segue.destination as! StopScreenViewController
        sceondVC.transitioningDelegate = self
        sceondVC.modalPresentationStyle = .custom
    }
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = startButton.center
        transition.circleColor = startButton.backgroundColor!
        
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = startButton.center
        transition.circleColor = startButton.backgroundColor!
        
        return transition
    }
    
    
    func loadInterface(){
        
        startButton.layer.cornerRadius = startButton.frame.size.width / 2




    }
    
    
//    func loadStartInterface(){
//        startButton.layer.cornerRadius = 0.5 * startButton.bounds.size.width
//        startButton.clipsToBounds = true
//
//        textLabel.text = "Tap to Get the Building Name"
//        textLabel.font = UIFont(name: "systemFont", size: 20)
//
//        textLabel.translatesAutoresizingMaskIntoConstraints = false
//        textLabel.textColor = UIColor.myBlue
//        startButton.setTitle("START", for: .normal)
//        startButton.backgroundColor = UIColor.myBlue
//        startButton.setTitleColor(.white, for: .normal)
//        self.view.backgroundColor = UIColor.white
//        let marginGuide = view.layoutMarginsGuide
//        NSLayoutConstraint.activate([
//            textLabel.centerXAnchor.constraint(equalTo:view.centerXAnchor),
//            textLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 200),
//            startButton.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 62),
//            startButton.widthAnchor.constraint(equalToConstant: 240)
//
//        ])
//        buildingNames.isHidden = true
//
//
//
//
//
//    }
//    func loadStopInterface(){
//
//        startButton.setTitle("STOP", for: .normal)
//        startButton.setTitleColor(.myBlue, for: .normal)
//        startButton.backgroundColor = UIColor.white
//        self.view.backgroundColor = UIColor.myBlue
//
//        startButton.layer.cornerRadius = 0.5 * startButton.bounds.size.width
//        startButton.clipsToBounds = true
//
//        buildingNames.isHidden = false
//        buildingNames.font = UIFont(name: "helvetica", size: 35)
//        buildingNames.numberOfLines = 0
//        buildingNames.textColor = UIColor.white
//        buildingNames.adjustsFontSizeToFitWidth = true
//        buildingNames.minimumScaleFactor = 0.7
//
//
//        textLabel.text = "You are facing"
//        textLabel.font = UIFont(name: "helvetica", size: 20)
//        textLabel.numberOfLines = 0
//        textLabel.textColor = UIColor.white
//        textLabel.adjustsFontSizeToFitWidth = true
//        textLabel.minimumScaleFactor = 0.7
//
//        let marginGuide = view.layoutMarginsGuide
//        NSLayoutConstraint.activate([
//            buildingNames.centerXAnchor.constraint(equalTo:view.centerXAnchor),
//            textLabel.leadingAnchor.constraint(equalTo: buildingNames.leadingAnchor, constant: 0),
//            textLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 200),
//            buildingNames.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 30),
//            startButton.topAnchor.constraint(equalTo: buildingNames.bottomAnchor, constant: 150),
//            startButton.widthAnchor.constraint(equalToConstant: 160)
//        ])
//
//
//
//    }
//
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    @IBAction func ButtonTouched(_ sender: Any) {
//        isNavigating = !isNavigating
//        if isNavigating{
//           //navigating
//            loadStopInterface()
//
//
//
//        } else{
//
//            loadStartInterface()
//        }
//        let collection = ExtractData()
//
//        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true){ timer in
//
//            let buildingName = self.GetBuildingName(collection: collection)
//                        //heading relevent to the magnetic pole
//            self.buildingNames.text = buildingName
////            self.label5.text = buildingName
//            if !self.isNavigating{
//                timer.invalidate()
//            }
//        }
//
//
//
//
//    }
//
//    @IBAction func buttonTouched(_ sender: UIButton) {
//        //function about reading the building's name can be added here
//
//        textBuildingName.text = findBuilding()
//
//        let utterance = AVSpeechUtterance(string:textBuildingName.text!)
//        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
//        utterance.rate = 0.6
//
//        let synthesizer = AVSpeechSynthesizer()
//        synthesizer.speak(utterance)
//    }
//
//    func findBuilding() -> String {
//        //ENTER BUILDING FINDING FUNCTION HERE
//        return "No building detected"
//    }
}


