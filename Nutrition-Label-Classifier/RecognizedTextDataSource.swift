//
//  RecognizedTextDataSource.swift
//  Nutrition-Label-Classifier
//
//  Created by Suthar, Bhavin Udavji on 06/04/20.
//  Copyright © 2020 Suthar, Bhavin Udavji. All rights reserved.
//

import UIKit
import Vision

protocol RecognizedTextDataSource: AnyObject {
    func addRecognizedText(recognizedText: [VNRecognizedTextObservation])
}
