//
//  StopScreenViewController.swift
//  Compass
//
//  Created by 邱天鈜 on 4/21/20.
//  Copyright © 2020 Tony_Qiu. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation
import MapKit
import Foundation




class StopScreenViewController: UIViewController, CLLocationManagerDelegate{
    
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var PromptText: UILabel!
    
    @IBOutlet weak var buildingNames: UILabel!
    
    //global vars
    
    
   
    var currentHeading: CLHeading? = nil;
    var isNavigating = true
    var foundBuilding: Bool = false
    
    //define Collections
     struct Collection : Decodable {
        let type : String
        let features : [Feature]
    }

    struct Feature : Decodable {
        let type : String
        let properties : Properties
        let geometry: Geometry
       
    }

    struct Properties : Decodable {
        let name : String?
    }

    struct  Geometry: Decodable {
        let type: String
        let coordinates: [Double]
    }
    
     var locationManager: CLLocationManager?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stopButton.layer.cornerRadius = stopButton.frame.size.width / 2
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        //request authorization for postitioning
        locationManager?.requestAlwaysAuthorization()
        
        startFinding()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //if user grants authorization then start updating heading
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            
            locationManager?.startUpdatingHeading()
            locationManager?.startUpdatingLocation()
                        
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
            //update readings after starting updating heading
            //heading relevent to the magnetic pole
            currentHeading = newHeading
    //        textLabel.text = "Magnetic Heading：\(newHeading.magneticHeading)"
        }
    
    
    func degreesToRadians(degrees: Double) -> Double {
        return degrees * .pi / 180.0
    }
    
    
    func radiansToDegrees(radians: Double) -> Double {
        if (radians * 180.0 / .pi >= 0) {
            return radians * 180.0 / .pi;
        } else {
            return 360 + (radians * 180.0 / .pi)
        }
    }
    
    
    func getBearingBetweenTwoPoints(point1 : CLLocation, point2 : CLLocation) -> Double {

        let lat1 = degreesToRadians(degrees: point1.coordinate.latitude)
        let lon1 = degreesToRadians(degrees: point1.coordinate.longitude)

        let lat2 = degreesToRadians(degrees: point2.coordinate.latitude)
        let lon2 = degreesToRadians(degrees: point2.coordinate.longitude)

        let dLon = lon2 - lon1

        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)

        return radiansToDegrees(radians: radiansBearing)
    }
    
    
    func ExtractData()->Collection{ //extract data from geojson file
        var collection: Collection?
        let urlBar = Bundle.main.url(forResource: "buildings", withExtension: "geojson")!
        do{
        let jsonData = try Data(contentsOf: urlBar)
        collection = try JSONDecoder().decode(Collection.self, from: jsonData)
        }catch { print("Error while parsing: \(error)") }
        return collection!
    }
    
    
    
    func GetAngleDiff(bearingAngle:Double, currHeading:Double)->Double{//Get absolute angle difference between bearings
        let x = (bearingAngle - currHeading + 360.0).truncatingRemainder(dividingBy: 360.0);
        let y = (currHeading -  bearingAngle + 360.0).truncatingRemainder(dividingBy: 360.0);
        let angleDiff = min(x, y)
        return angleDiff
    }
    
    
    func GetBuildingName(collection: Collection)->String{
                
                let locationManager = CLLocationManager()
                    locationManager.requestWhenInUseAuthorization()
                    var curLoc: CLLocation!
        //            var curHeading: CLHeading!
                    if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                    CLLocationManager.authorizationStatus() == .authorizedAlways) {
        //                locationManager.startUpdatingHeading()
                        locationManager.startUpdatingLocation()

                        
            //           print(currentLoc.coordinate.latitude)
            //           print(currentLoc.coordinate.longitude)
                }
                curLoc = locationManager.location
        //        curHeading = locationManager.heading
        
        var TempLoc: CLLocation;
//        var targetLoc: CLLocation;
        var targetLocName: String = "";
        var distance: CLLocationDistance;
        var minDist:CLLocationDistance = 200;
        
        
            for feature in collection.features {
          
//                let x = feature.geometry.coordinates[0]
//                let y = feature.geometry.coordinates[1]
//                let x1 = curLoc.coordinate.latitude
//                let x2 = curLoc.coordinate.longitude
//
                TempLoc = CLLocation(latitude: feature.geometry.coordinates[1], longitude: feature.geometry.coordinates[0]) // Get rough point coordinates from GeoJson
                        
                distance = TempLoc.distance(from: curLoc) //Distance in Meters
//                    -----debug-------
//                let b1 = self.getBearingBetweenTwoPoints1(point1: curLoc!, point2: TempLoc)
//                let b3 = currentHeading!.trueHeading
//                let b2 = self.GetAngleDiff(bearingAngle: b1, currHeading: self.currentHeading!.trueHeading)
                
                
                if(distance <= 200 && distance >= 0){
                           //only calculate bearing when the building is within 250 meter radius
                    let bearing = self.getBearingBetweenTwoPoints(point1: curLoc!, point2: TempLoc)
                    let angleDiff = self.GetAngleDiff(bearingAngle: bearing, currHeading: self.currentHeading!.trueHeading)
                    
                    if(distance >= 150 && distance <= 200 && angleDiff <= 5){
                        //when user is facing building and within 25 meter distance
                        if (distance <= minDist){ // if the building is closer then the closest building then replace the cloest building
                            minDist = distance;
//                            targetLoc = TempLoc;
                            targetLocName = feature.properties.name!;
                            foundBuilding = true;
                        }
                    }else if(distance >= 100 && distance <= 150 && angleDiff <= 10){
                        if (distance <= minDist){ // if the building is closer then the closest building then replace the cloest building
                            minDist = distance;
//                            targetLoc = TempLoc;
                            targetLocName = feature.properties.name!;
                            foundBuilding = true;
                            
                        }
                        
                    }else if(distance >= 75 && distance <= 100 && angleDiff <= 25){
                        if (distance <= minDist){ // if the building is closer then the closest building then replace the cloest building
                            minDist = distance;
//                            targetLoc = TempLoc;
                            targetLocName = feature.properties.name!;
                            foundBuilding = true;
                        }
                        
                    }else if(distance >= 50 && distance <= 75 && angleDiff <= 35){
                        if (distance <= minDist){ // if the building is closer then the closest building then replace the cloest building
                            minDist = distance;
//                            targetLoc = TempLoc;
                            targetLocName = feature.properties.name!;
                            foundBuilding = true;
                        }
                        
                    }else if(distance >= 25 && distance <= 50 && angleDiff <= 45){
                        if (distance <= minDist){ // if the building is closer then the closest building then replace the cloest building
                            minDist = distance;
//                            targetLoc = TempLoc;
                            targetLocName = feature.properties.name!;
                            foundBuilding = true;
                        }
                        
                    }else if(distance >= 0 && distance <= 25 && angleDiff <= 55){
                        if (distance <= minDist){ // if the building is closer then the closest building then replace the cloest building
                            minDist = distance;
//                            targetLoc = TempLoc;
                            targetLocName = feature.properties.name!;
                            foundBuilding = true;
                        }

                    }
                }
            }
        return targetLocName
    }
    
    
    
    
    @IBAction func dismissStopVC(_ sender: Any) {
        
        
        
        UIDevice.vibrate()
        
        stopFinding()
        self.dismiss(animated: true, completion: nil)
    }
    

    var BuildingNameFoundLast: String = "No building found";
    
    func stopFinding(){
        

        let utterance = AVSpeechUtterance(string: BuildingNameFoundLast)
                utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                utterance.rate = 0.6
        
                let synthesizer = AVSpeechSynthesizer()
                synthesizer.speak(utterance)
        
        isNavigating = false
    }
    
    func startFinding(){
        let collection = ExtractData()
        
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true){ timer in
    
                let buildingNameStr = self.GetBuildingName(collection: collection)
                            //heading relevent to the magnetic pole
                
                if self.foundBuilding{
                    self.buildingNames.isHidden = false
                    self.buildingNames.text = buildingNameStr
                    self.BuildingNameFoundLast = buildingNameStr
                    
                }else{
                    self.buildingNames.isHidden = true
                    self.PromptText.text = "No building found"
                    self.BuildingNameFoundLast = "No building found"
                    
                    
                }
                
    //            self.label5.text = buildingName
                if !self.isNavigating{
                    timer.invalidate()
                }
            }
        
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
