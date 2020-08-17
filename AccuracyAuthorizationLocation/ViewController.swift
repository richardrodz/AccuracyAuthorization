//
//  ViewController.swift
//  AccuracyAuthorizationLocation
//
//  Created by Nguyen Phat on 6/25/20.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet private weak var locationStatusLabel: UILabel!
    @IBOutlet private weak var accuracyAuthorizationLabel: UILabel!
    @IBOutlet private weak var coordinatesLabel: UILabel!
    
    @IBOutlet private weak var requestLocationButton: UIButton!
    lazy var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coordinatesLabel.isHidden = true
        requestLocationButton.setTitle("Request Location", for: .normal)
        requestLocationButton.setTitleColor(.gray, for: .disabled)
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    
    @IBAction func onRequestLocation(_ sender: UIButton) {
        requestLocationButton.isEnabled = false
        locationManager.requestLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if CLLocationManager().accuracyAuthorization == .reducedAccuracy {
            print("reduce accuracy")
        } else {
            print("full accuracy")
        }
    }
    
    @IBAction func presentNextView(_ sender: UIButton) {
        if let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "TestSecondViewController") as? TestSecondViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus()
        switch status {
        case .authorizedAlways:
            locationStatusLabel.text = ".authorizedAlways"
            break
        case .authorizedWhenInUse:
            locationStatusLabel.text = ".authorizedWhenInUse"
            break
        case .denied:
            locationStatusLabel.text = ".denied"
            break
        case .notDetermined:
            locationStatusLabel.text = ".notDetermined"
            break
        case .restricted:
            locationStatusLabel.text = ".restricted"
            break
        default:
            break
        }
        
        let accuracyAuthorization = manager.accuracyAuthorization
        switch accuracyAuthorization {
        case .fullAccuracy:
            accuracyAuthorizationLabel.text = ".fullAccuracy"
            locationManager.requestLocation()
            break
        case .reducedAccuracy:
            accuracyAuthorizationLabel.text = ".reducedAccuracy"
            manager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "ForDelivery") { (error) in
                self.locationManager.requestLocation()
            }
            break
        default:
            break
        }
    }
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let coorText = "(\(location.coordinate.latitude), \(location.coordinate.longitude))"
        coordinatesLabel.text = coorText
        coordinatesLabel.isHidden = false
        requestLocationButton.isEnabled = true
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error)
    }
}
