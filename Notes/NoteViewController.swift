//
//  AddNoteViewController.swift
//  Notes
//
//  Created by Gagan on 2018-04-05.
//  Copyright © 2018 My Org. All rights reserved.
//

import UIKit
import os.log
import CoreLocation

class NoteViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, CLLocationManagerDelegate {
    
    var locationCoordinates : CLLocationCoordinate2D?
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        note?.categoryId = row
        note?.categoryName = categories[row]
    }
    
    var note: Note?
    
    let categories: [String] = ["Work", "School", "Personal", "Home", "Others"]
    
    @IBOutlet weak var noteTitleTextField: UITextField!
    @IBOutlet weak var saveNoteButton: UIBarButtonItem!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        
        locationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.requestWhenInUseAuthorization()
        }

        // Do any additional setup after loading the view.
        if let note = note {
            self.title = "Edit Note"
            noteTextView.text = note.text
            noteTitleTextField.text = note.title
            categoryPickerView.selectRow(note.categoryId!, inComponent: 0, animated: true)
            imageView.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleBottomMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue) | UInt8(UIViewAutoresizing.flexibleRightMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleLeftMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleTopMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleWidth.rawValue)))
            imageView.contentMode = UIViewContentMode.scaleAspectFit
            imageView.image = note.image
        } else {
            note = Note(text: "")
            note?.imageValid = false
            
        }
        
        imagePicker.delegate = self
        //noteTextView.becomeFirstResponder()
        
        noteTextView.layer.borderWidth = 1.0
        noteTextView.layer.borderColor = UIColor.lightGray.cgColor
        noteTextView.layer.cornerRadius = 4.0
        
        imageView.layer.cornerRadius = 4.0
        imageView.layer.masksToBounds = true
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            break
        default:
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationCoordinates = location.coordinate
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed updating location")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let c = segue.identifier {
            if c == "showMap" {
                guard let mapViewController = segue.destination as? MapViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                if let lat = note?.locationCoordinatesLat, let long = note?.locationCoordinatesLng {
                    mapViewController.locationCoordinates = CLLocationCoordinate2DMake(lat, long)
                } else {
                    mapViewController.locationCoordinates = locationCoordinates
                }
                return
            }
        }
        
        guard let button = sender as? UIBarButtonItem, button === saveNoteButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let noteText = noteTextView.text
        note?.text = noteText ?? ""
        note?.title = noteTitleTextField.text
        note?.categoryId =  categoryPickerView.selectedRow(inComponent: 0)
        note?.categoryName = categories[(note?.categoryId)!]
        note?.image = imageView.image
        note?.locationCoordinatesLat = locationCoordinates?.latitude
        note?.locationCoordinatesLng = locationCoordinates?.longitude
    }
    
    @IBAction func cancelNoteButton(_ sender: UIBarButtonItem) {
        let isPresentingInAddNoteMode = presentingViewController is UINavigationController
        
        if isPresentingInAddNoteMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The NoteViewController is not inside a navigation controller.")
        }
    }
    
    let imagePicker = UIImagePickerController()

    
    @IBAction func onTextViewTap(_ sender: UITapGestureRecognizer) {
        if noteTextView.isFirstResponder {
            noteTextView.resignFirstResponder()
        } else {
            noteTextView.becomeFirstResponder()
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let img = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.layoutIfNeeded()
        imageView.layer.cornerRadius = 4.0
        imageView.layer.masksToBounds = true
        imageView.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleBottomMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue) | UInt8(UIViewAutoresizing.flexibleRightMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleLeftMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleTopMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleWidth.rawValue)))
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.image = img
        note?.image = img
        note?.imageValid = true
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onTapAddImage(_ sender: UITapGestureRecognizer) {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Album", style: .default, handler: { (alert) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
}
