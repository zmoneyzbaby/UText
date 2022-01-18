//
//  MapViewController.swift
//  team16
//
//  Created by Zephyr Reames-Zepeda on 11/1/21.
////
//channel 1 - upper northeast
 

import UIKit
import MapKit
import CoreLocation
import CometChatPro

// hello

class MapViewController: UIViewController, MKMapViewDelegate {
    var activeUsersInChat: [String: Int] = [:]
    let locManager = CLLocationManager()
    var currentLocation : CLLocation?
    let channels = ["channel1", "channel2", "channel3", "channel4", "channel5", "channel6", "channel7", "channel8", "channel9"]
    var usersInChat : [String : Any] = [:]
    let defaults = UserDefaults.standard // BEN ADDED THIS
    
    @IBOutlet weak var zoom: UISlider!
    
    @IBOutlet weak var mapView: MKMapView!
   // let locManager = CLLocationManager()
    var zoneLevel = 0;
    var printLevel = 0;
    let zoneCoords : [[Double]] = [[30.290182089540327,30.285216375887074, -97.72718092833297, -97.7337791625122],   //channel 1 orange
                  [30.285216375887074, 30.283196666738217, -97.72851130400277, -97.7337791625122],      //channel 2 orange
                  [30.283196666738217, 30.279268305967584, -97.72851130400277, -97.73360077473963],     //channel 3 Green
                  [30.283196666738217,30.279268305967584, -97.73360077473963, -97.73926936608133],      //channel 4 red
                  [30.287220439300377, 30.283196666738217, -97.73701713938787,-97.7337791625122],       //channel 5 blue
                  [30.287220439300377,30.283196666738217, -97.74156927166374, -97.73701713938787],      //channel 6 purple
                  [30.28981778243186, 30.287220439300377, -97.74140273655678, -97.73701713938787],      //channel 7 yellow
                  [30.291970612246143, 30.28981778243186, -97.74140273655678, -97.73701713938787],      //channel 8 indigo
                  [30.278577706154252, 30.275923837641706 , -97.73047001223706, -97.73598573351477]]    //channel 9 pink
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        if (defaults.integer(forKey: "zoneDisplay") == 1){
        zoneLevel = 0
        
        locationAuthStatus()
    
    
            CometChat.getOnlineGroupMemberCount(self.channels, onSuccess: {
                countData in
                self.usersInChat = countData
                print(self.usersInChat)
              
                    DispatchQueue.main.async {
                        for zone in self.zoneCoords {
                            self.zoneLevel += 1

                        self.mapView.addOverlay(MKPolygon(coordinates: [CLLocationCoordinate2DMake(zone[0], zone[3])
                                                ,CLLocationCoordinate2DMake(zone[0], zone[2]),
                                                CLLocationCoordinate2DMake(zone[1], zone[2]),
                                                CLLocationCoordinate2DMake(zone[1], zone[3])], count: 4))


                        let marker = MKPointAnnotation()
                        marker.coordinate =  CLLocationCoordinate2DMake((zone[0]+zone[1])/2, (zone[3] + zone[2])/2 )

                        print(self.zoneLevel)
                        marker.title = "CHANNEL \(self.zoneLevel)"
                       // marker.subtitle = "Users in Chat : \(usersInCha
                        let channelName = "channel\(self.zoneLevel)"
                        marker.subtitle = "Users in Chat \(self.usersInChat[channelName] ?? 0)"


                            self.mapView.addAnnotation(marker as MKAnnotation)
                        }

                    }

            }, onError: {
              error in
              print(error?.errorDescription)
             })
      }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30.287291, longitude: -97.737134), latitudinalMeters: 1100, longitudinalMeters: 1100)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        
       
        //mapView.addOverlay(MKCircle(center: CLLocationCoordinate2D(latitude: 30.29048818981761, longitude: -97.7243685547436), radius: 100))
    }
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locManager.location
        } else {
            locManager.requestWhenInUseAuthorization()
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        //we want the user location to be a blue dot not an annotation view
        if (annotation.isKind(of: MKUserLocation.self)){
        return nil;
        }
        
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
        
        printLevel += 1

        if (defaults.integer(forKey: "zoneColors") == 1){ // BEN ADDED THIS
            switch(annotation.title) {
            case "CHANNEL 1" : annotationView.markerTintColor = UIColor.systemOrange
            case "CHANNEL 2" : annotationView.markerTintColor = UIColor.systemGreen
            case "CHANNEL 3" : annotationView.markerTintColor = UIColor.systemRed
            case "CHANNEL 4" : annotationView.markerTintColor = UIColor.systemBlue
            case "CHANNEL 5" : annotationView.markerTintColor = UIColor.systemPurple
            case "CHANNEL 6" : annotationView.markerTintColor = UIColor.systemPink
            case "CHANNEL 7" : annotationView.markerTintColor = UIColor.systemTeal
            case "CHANNEL 8" : annotationView.markerTintColor = UIColor.systemIndigo
            case "CHANNEL 9" : annotationView.markerTintColor = UIColor.systemYellow
            default : print("error")
            }
                
            } else {
                switch(annotation.title) {
                case "CHANNEL 1" : annotationView.markerTintColor = UIColor.white
                case "CHANNEL 2" : annotationView.markerTintColor = UIColor.white
                case "CHANNEL 3" : annotationView.markerTintColor = UIColor.white
                case "CHANNEL 4" : annotationView.markerTintColor = UIColor.white
                case "CHANNEL 5" : annotationView.markerTintColor = UIColor.white
                case "CHANNEL 6" : annotationView.markerTintColor = UIColor.white
                case "CHANNEL 7" : annotationView.markerTintColor = UIColor.white
                case "CHANNEL 8" : annotationView.markerTintColor = UIColor.white
                case "CHANNEL 9" : annotationView.markerTintColor = UIColor.white
                default : print("error")
                }
                
                
                
            }
        
        annotationView.glyphImage = UIImage(named: "chat")
        
        return annotationView
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        

        if let overlay = overlay as? MKPolygon {
                let polygonView = MKPolygonRenderer(overlay: overlay)
                polygonView.strokeColor = UIColor.gray
                polygonView.lineWidth = 0.6
            
            switch(zoneLevel) {
                case 1: polygonView.fillColor = UIColor.systemOrange
                case 2: polygonView.fillColor = UIColor.systemGreen
                case 3: polygonView.fillColor = UIColor.systemRed
                case 4: polygonView.fillColor = UIColor.systemBlue
                case 5: polygonView.fillColor = UIColor.systemPurple
                case 6: polygonView.fillColor = UIColor.systemPink
                case 7: polygonView.fillColor = UIColor.systemTeal
                case 8: polygonView.fillColor = UIColor.systemIndigo
                case 9: polygonView.fillColor = UIColor.systemYellow
                default: print("error")
            }
                polygonView.alpha = 0.35
                return polygonView
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    @IBAction func sliderMoved(_ sender: Any) {
        let miles = Double(self.zoom.value)
        var currentRegion = self.mapView.region
        currentRegion.span = MKCoordinateSpan(latitudeDelta: miles / 69.0, longitudeDelta: miles / 69.0)
        self.mapView.region = currentRegion
         
       }
}

