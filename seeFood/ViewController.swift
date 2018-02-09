//
//  ViewController.swift
//  seeFood
//
//  Created by Rahul Avale on 2/4/18.
//  Copyright © 2018 Rahul Avale. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageClicked: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let clickedimageCheck = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            imageClicked.image = clickedimageCheck
            
            guard let ciNewImage = CIImage(image: clickedimageCheck) else {
                
                fatalError("Could not convert the UIImage to CIImage")
            }
            detect(image: ciNewImage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
        
    }
    
    func detect(image : CIImage){
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML Model Failed!")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            guard let results = request.results as? [VNClassificationObservation] else {
                
                fatalError("Model Failed to process image!")
            }
            
            if let firstResult  = results.first {
//                if firstResult.identifier.contains("hotdog") {
//                    self.navigationItem.title = "Hotdog!"
//                } else {
//                    self.navigationItem.title = "Not Hotdog!"
//                }
            let name = firstResult.identifier
            self.navigationItem.title = name
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }

    @IBAction func cameraButton(_ sender: Any){
        
        present(imagePicker, animated: true, completion: nil)
    }
    
}

