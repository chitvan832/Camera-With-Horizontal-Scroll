//
//  ContentViewModel.swift
//  Camera With Horizontal Scroll
//
//  Created by Chitvan Saxena on 25/07/20.
//  Copyright © 2020 Chitvan Saxena. All rights reserved.
//

import UIKit
import SwiftUI

class ContentViewModel: ObservableObject {
    
    @Published var activeCard: Int = 0
    @Published var screenDrag: Float = 0.0
    @Published var isAllPicturesSubmitted: Bool = false
    
    var cameraViewHeight: CGFloat = 0.0
    
    var imageCollection: [CameraSurveyData] = [
        CameraSurveyData(side: "Front",
                         placeHolderImage: Image(systemName: "1.square"),
                         image: nil),
        CameraSurveyData(side: "Right side",
                         placeHolderImage: Image(systemName: "2.square"),
                         image: nil),
        CameraSurveyData(side: "Left side",
                         placeHolderImage: Image(systemName: "3.square"),
                         image: nil),
        CameraSurveyData(side: "Rear",
                         placeHolderImage: Image(systemName: "4.square"),
                         image: nil),
        CameraSurveyData(side: "Custom",
                         placeHolderImage: Image(systemName: "5.square"),
                         image: nil)
    ]
    
    func checkPictureStatus() {
        isAllPicturesSubmitted = imageCollection.filter({ $0.image == nil }).isEmpty
    }
}

struct CameraSurveyData {
    
    let side: String
    let placeHolderImage: Image
    var image: UIImage?
}
