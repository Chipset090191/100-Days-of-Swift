//
//  ViewController.swift
//  Project22
//
//  Created by Михаил Тихомиров on 12.02.2024.
//

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    //MARK: Code in this proj was refactored because of Challenges 2 and 3.
    
    @IBOutlet var beaconName: UILabel!
    @IBOutlet var distanceReading: UILabel!
    var locationManager: CLLocationManager?
    var wasDetected: Bool = false
    var allBeacons = [Beacon]()
    var imageView:UIImageView!
    var deviceCircleView:CircleView!
    var searchCircleView:CircleView!
    
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //+++++++++++Added the circle here and positioned it to the center
        
//        imageView = UIImageView(image: UIImage(systemName: "circle"))
//        imageView.translatesAutoresizingMaskIntoConstraints = true
//        imageView.transform = CGAffineTransform(scaleX: 4, y: 4)
//        imageView.tintColor = UIColor.black
//        
//        let screenSize = UIScreen.main.bounds.size
//        let centerX = screenSize.width / 2
//        let centerY = screenSize.height / 2
//        imageView.center = CGPoint(x: centerX, y: centerY)
//        view.addSubview(imageView)
        
        
        deviceCircleView = CircleView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        deviceCircleView.fillColor = .black
        deviceCircleView.center = view.center
        
        view.addSubview(deviceCircleView)
        
        
        
        searchCircleView = CircleView(frame: CGRect(x: 0, y: 0, width: 350, height: 350))
        searchCircleView.fillColor = .clear
        searchCircleView.center = view.center
        view.addSubview(searchCircleView)
        
        //+++++++++++++++++++++++++++++++++++
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization() // requesting from the user to read location
        
        view.backgroundColor = .gray
        
        let beacon1 = Beacon(uuid: UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!, major: 123, minor: 456, identifier: "Apple Beacon")
        let beacon2 = Beacon(uuid: UUID(uuidString: "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6")!, major: 123, minor: 456, identifier: "Radius Beacon")
        let beacon3 = Beacon(uuid: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, major: 123, minor: 456, identifier: "Estimote")
        
        allBeacons += [beacon1, beacon2, beacon3]
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            // isMonitoringAvailable - can this thing detect whether a beacon exist or not
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                // isRangingAvailable() - can we detect how far away a beacon is compared to us
                if CLLocationManager.isRangingAvailable() {
                    for everyBeacon in allBeacons {
                        startScanning(uuid: everyBeacon.uuid, major: everyBeacon.major, minor: everyBeacon.minor, identifier: everyBeacon.identifier)
                    }
                }
            }
        }
    }
    
    func startScanning(uuid: UUID, major: UInt16, minor: UInt16, identifier: String) {
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: major, minor: minor, identifier: identifier)
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
    }
    
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "FAR"
                self.searchCircleView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.deviceCircleView.fillColor = .black
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
                self.searchCircleView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.deviceCircleView.fillColor = .black
            case .immediate:
                self.view.backgroundColor = .red
                self.distanceReading.text = "RIGHT HERE"
                self.searchCircleView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                self.deviceCircleView.fillColor = .green
            default: // that`s unknown for future
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
                self.searchCircleView.transform = CGAffineTransform(scaleX: 3, y: 3)
                self.deviceCircleView.fillColor = .black
            }
        }
            
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            //MARK: Challenge 1.1
            detectionAlert()
            for everyBeacon in allBeacons {
                if beacon.uuid == everyBeacon.uuid {
                    beaconName.text = everyBeacon.identifier
                }
            }
            update(distance: beacon.proximity)
        }
    }
    
    //MARK: Challenge 1.2
    func detectionAlert() {
        if wasDetected { return } else {
            wasDetected = true
            let ac = UIAlertController(title: "Detection information", message: "Your beacon has been detected!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
        }
    }
}
