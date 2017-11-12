//
//  ViewController.swift
//  ARTest
//
//  Created by Tim Wong on 11/12/17.
//  Copyright © 2017 tw23. All rights reserved.
//

import UIKit
import ARCL
import CoreLocation

class ViewController: UIViewController, UITextFieldDelegate {
    
    var sceneLocationView = SceneLocationView()
    let textField: UITextField = {
        let textField = UITextField();
        textField.placeholder = "Add Pin"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        sceneLocationView.run()
        
        view.addSubview(sceneLocationView)
        sceneLocationView.addSubview(textField);
        
        let textFieldTopConstraint = NSLayoutConstraint(item: textField, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 30.0);
        let textFieldLeadingConstraint = NSLayoutConstraint(item: textField, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 30.0);
        let textFieldTrailingConstraint = NSLayoutConstraint(item: self.view, attribute: .trailing, relatedBy: .equal, toItem: self.textField, attribute: .trailing, multiplier: 1.0, constant: 30.0);
        
        NSLayoutConstraint.activate([textFieldTopConstraint, textFieldLeadingConstraint, textFieldTrailingConstraint]);
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneLocationView.frame = view.bounds
    }
    
    //MARK: text field
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            if text.count > 0 {
                self.addPin(address: text)
            }
        }
        
        textField.text = "";
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        
        return true;
    }
    
    func addPin(address: String) {
        let geoCoder = CLGeocoder();
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            if error == nil && placemarks != nil && placemarks!.count > 0 {
                if let location = placemarks?.first?.location, let image = UIImage(named: "pin") {
                    let annotationNode = LocationAnnotationNode(location: CLLocation(coordinate: location.coordinate, altitude: 50.0), image: image);
                    annotationNode.scaleRelativeToDistance = true;
                    self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode);
                }
            }
            else {
                print("failed to reverse geocode address with error: \(error!)")
            }
        }
    }
}

