//
//  LabelDetailsViewController.swift
//  Nutrition-Label-Classifier
//
//  Created by Suthar, Bhavin Udavji on 06/04/20.
//  Copyright © 2020 Suthar, Bhavin Udavji. All rights reserved.
//

import UIKit
import Vision

class LabelDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var textView: UITextView!
    
    var transcript = ""
    
    var data = [String:Any]()
    var calories = [String]()
    var carbs = [String]()
    var fat = [String]()
    var proteins = [String]()
    var microNutrients = [String]()
    var servings = [String]()
    var cholestrol = [String]()
    var sodium = [String]()
    var fat_gram = 0
    var protein_gram = 0
    var carb_gram = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
textView?.text = transcript
        // Do any additional setup after loading the view.
    }
    

}
extension LabelDetailsViewController:RecognizedTextDataSource{
    func addRecognizedText(recognizedText: [VNRecognizedTextObservation]) {
        // Create a full transcript to run analysis on.
        let maximumCandidates = 1
        var end = false
        for i  in 0..<recognizedText.count {
            if end == true {
                break
            }
            let observation = recognizedText[i]
            guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
            
            transcript += candidate.string
              var ip = nerInput.init(text: candidate.string.lowercased())
              var op = try! ner.init().prediction(input: ip)

                  for (lab,tok) in zip(op.tokens, op.labels) {
                    print(candidate.string)
                     print("\(tok) -> \(lab)")
                    if tok == "END" {
                        end = true
                        break
                    }
                    if tok == "CAL"{
                        calories.append(lab)
                    } else if tok == "SERV" {
                        servings.append(lab)
                    } else if tok == "CHOL" {
                        cholestrol.append(lab)
                    } else if tok == "CARB" {
                        carbs.append(lab)
                    } else if tok == "MIC" {
                        microNutrients.append(lab)
                    } else if tok == "SOD" {
                        sodium.append(lab)
                    } else if tok == "FAT" {
                        fat.append(lab)
                    } else if tok == "FAT_G" {
                        fat_gram =  String(lab.split(separator: "g")[0]).toint()
                    } else if tok == "CARB_G" {
                        carb_gram = String(lab.split(separator: "g")[0]).toint()
                    } else if tok == "PROT_G" {
                        protein_gram = String(lab.split(separator: "g")[0]).toint()
                    }
                     
                  }
            transcript += " "
        }
        print("CALORIES")
        var text  = String.init(format: "Calories %@ \n\n FAT %@ \n\n CARBS %@ \n\n SODIUM %@ \n\n CHOLESTROL %@ \n\n MICRO %@", calories.joined(separator: " "),
                                fat.joined(separator: " "),
                                carbs.joined(separator: " "),
                                sodium.joined(separator: " "),
                                cholestrol.joined(separator: " "),
                                microNutrients.joined(separator: " "))
        
        
        var protein_cal = 4 * protein_gram
        var fat_cal = 9 * fat_gram
        var carb_cal = 4 * carb_gram
        
      
        text = String.init(format: "%@ \n protein cal::  %d \n fat cal:: %d \n carb cal:: %d",text,protein_cal,fat_cal,carb_cal)
        
        transcript = text
    }
    
    
}
extension String {
    func toint() -> Int {
        return Int(self) ?? 0
    }
}
