//
//  ViewController.swift
//  Nutrition-Label-Classifier
//
//  Created by Suthar, Bhavin Udavji on 06/04/20.
//  Copyright © 2020 Suthar, Bhavin Udavji. All rights reserved.
//

import UIKit
import VisionKit
import Vision



class ViewController: UIViewController {
    
    var resultsViewController: (UIViewController & RecognizedTextDataSource)?
    var textRecognitionRequest = VNRecognizeTextRequest()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
         textRecognitionRequest = VNRecognizeTextRequest(completionHandler: { (request, error) in
                   guard let resultsViewController = self.resultsViewController else {
                       print("resultsViewController is not set")
                       return
                   }
                   if let results = request.results, !results.isEmpty {
                       if let requestResults = request.results as? [VNRecognizedTextObservation] {
                           DispatchQueue.main.async {
                               resultsViewController.addRecognizedText(recognizedText: requestResults)
                           }
                       }
                   }
               })
               // This doesn't require OCR on a live camera feed, select accurate for more accurate results.
               textRecognitionRequest.recognitionLevel = .accurate
               textRecognitionRequest.usesLanguageCorrection = true
    }
    
    @IBAction func scan_tap(_ sender: UIButton) {
        scan()
       }
    func scan() {
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = self
        present(documentCameraViewController, animated: true)
    }
    func processImage(image: UIImage) {
         guard let cgImage = image.cgImage else {
             print("Failed to get cgimage from input image")
             return
         }
         
         let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
         do {
             try handler.perform([textRecognitionRequest])
         } catch {
             print(error)
         }
     }


}

extension ViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        
            resultsViewController = storyboard?.instantiateViewController(withIdentifier: "label-details") as? (UIViewController & RecognizedTextDataSource)
        
        controller.dismiss(animated: true) {
            DispatchQueue.global(qos: .userInitiated).async {
                for pageNumber in 0 ..< scan.pageCount {
                    let image = scan.imageOfPage(at: pageNumber)
                    self.processImage(image: image)
                }
                DispatchQueue.main.async {
                    if let resultsVC = self.resultsViewController {
                        self.navigationController?.pushViewController(resultsVC, animated: true)
                    }
                }
            }
        }
    }
}

