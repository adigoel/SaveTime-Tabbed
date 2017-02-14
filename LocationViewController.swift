
import UIKit
import CoreLocation
import MapKit
import Foundation

var timeArray = [Int]()
var currentSystemTime = Int()
var locationTimer:Timer!

var current: CFAbsoluteTime!

class LocationViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var timeLabel: UILabel!
    
    
    
    fileprivate var locations = [MKPointAnnotation]()
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        return manager
    }()
    
    @IBAction func enabledChanged(_ sender: UISwitch) {
        if sender.isOn {
            locationManager.startUpdatingLocation()
            
        } else {
            locationManager.stopUpdatingLocation()
        }
    }
    
    func updateTimer() -> Int {
        
        current = CFAbsoluteTimeGetCurrent()
        currentSystemTime = Int(current)%60
        timeLabel.text = "\(currentSystemTime))"
        print(currentSystemTime)
        timeArray.append(currentSystemTime)
        
        let saveSuccessful: Bool = KeychainWrapper.standard.set("Some String", forKey: "myKey", withAccessibility: .whenUnlocked)
        
        print(saveSuccessful)
        
        let retrievedString: String? = KeychainWrapper.standard.string(forKey: "myKey")
        
        
        return currentSystemTime
        
    }
    @IBAction func accuracyChanged(_ sender: UISegmentedControl) {
        let accuracyValues = [
            kCLLocationAccuracyBestForNavigation,
            kCLLocationAccuracyBest,
            kCLLocationAccuracyNearestTenMeters,
            kCLLocationAccuracyHundredMeters,
            kCLLocationAccuracyKilometer,
            kCLLocationAccuracyThreeKilometers]
        
        locationManager.desiredAccuracy = accuracyValues[sender.selectedSegmentIndex];
    }
    
}

// MARK: - CLLocationManagerDelegate
extension LocationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else {
            return
        }
        
        // Add another annotation to the map.
        let annotation = MKPointAnnotation()
        annotation.coordinate = mostRecentLocation.coordinate
        
        // Also add to our map so we can remove old values later
        self.locations.append(annotation)
        
        // Remove values if the array is too big
        while locations.count > 100 {
            let annotationToRemove = self.locations.first!
            self.locations.remove(at: 0)
            
            // Also remove from the map
            mapView.removeAnnotation(annotationToRemove)
        }
        
        locationTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LocationViewController.updateTimer), userInfo: nil, repeats: true)
        
        if UIApplication.shared.applicationState == .active {
            mapView.showAnnotations(self.locations, animated: false)
                    } else if UIApplication.shared.applicationState == .background {
            //print("App is backgrounded. New location is %@", mostRecentLocation)
           
        }
    }
    
}

