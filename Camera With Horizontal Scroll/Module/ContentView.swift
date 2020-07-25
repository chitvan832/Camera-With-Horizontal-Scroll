//
//  ContentView.swift
//  Camera With Horizontal Scroll
//
//  Created by Chitvan Saxena on 25/07/20.
//  Copyright © 2020 Chitvan Saxena. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var didTapOnCapture: Bool = false
    @State private var clickedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @ObservedObject var model = ContentViewModel()
    
    private let spacing: CGFloat = 20
    private let widthOfHiddenCards: CGFloat = 50
    private let cardHeight: CGFloat = 175
    
    var body: some View {
        GeometryReader { proxy in
            return VStack {
                if self.clickedImage == nil {
                    CameraView(didTapCapture: self.$didTapOnCapture,
                               image: self.$clickedImage,
                               height: proxy.size.height)
                } else {
                    Image(uiImage: self.clickedImage!)
                        .frame(width: UIScreen.main.bounds.width,
                               height: proxy.size.height / 2,
                               alignment: .center)
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                }
                self.bottomView
                self.updateHeightInModel(height: proxy.size.height)
            }
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
        }
        .navigationBarTitle("Photos")
        .navigationBarItems(trailing: navigationBarTrailingButton)
    }
    
    private func updateHeightInModel(height: CGFloat) -> some View {
        self.model.cameraViewHeight = height/2
        return EmptyView()
    }
    
    private var bottomView: some View {
        VStack {
            horizontalSelectionView
            bottomButtonsView
        }
    }
    
    private var horizontalSelectionView: some View {
        Canvas {
            Carousel(numberOfItems: model.imageCollection.count,
                     spacing: spacing,
                     widthOfHiddenCards: widthOfHiddenCards) {
                        ForEach(model.imageCollection, id: \.self.side ) { collection in
                            Item( _id: collection.side,
                                  spacing: self.spacing,
                                  widthOfHiddenCards: self.widthOfHiddenCards,
                                  cardHeight: self.cardHeight )
                            {
                                VStack(alignment: .center, spacing: 10.0) {
                                    self.collectionItem(for: collection)
                                    Text(collection.side)
                                }
                            }
                            .transition(.slide)
                            .animation(.spring())
                        }
            }
        }
        .environmentObject(model)
    }
    
    private var bottomButtonsView: some View {
        HStack {
            retryButton
            Spacer()
            if clickedImage == nil {
                cameraButton
            } else {
                submitButton
            }
            Spacer()
            galleryButton
        }
        .frame(maxWidth: .infinity, maxHeight: 75, alignment: .center)
        .padding()
    }
    
    private var retryButton: some View {
        Button(action: {
            self.clickedImage = nil
        }) {
            Text("Retry")
        }
    }
    
    private var cameraButton: some View {
        Button(action: {
            self.didTapOnCapture = true
        }) {
            Circle()
        }
    }
    
    private var submitButton: some View {
        Button(action: {
            self.setImageToCollection()
        }) {
            Text("Submit")
        }
    }
    
    private var galleryButton: some View {
        Button(action: {
            self.showingImagePicker = true
        }) {
            Image(systemName: "photo.fill.on.rectangle.fill")
                .padding()
                .foregroundColor(.white)
        }
        .background(Circle().fill(Color.gray))
    }
    
    private func setImageToCollection() {
        model.imageCollection[model.activeCard].image = clickedImage
        model.checkPictureStatus()
        clickedImage = nil
    }
    
    private func collectionItem(for item: CameraSurveyData) -> some View {
        let isActiveCard = (item.side == model.imageCollection[model.activeCard].side)
        var image: Image
        if let userSelectedImage = item.image {
            image = Image(uiImage: userSelectedImage)
        } else {
            image = item.placeHolderImage
        }
        return image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipped()
            .overlay(
                RoundedRectangle(cornerRadius: 5.0)
                    .stroke( isActiveCard ? Color.green : Color.orange, lineWidth: 10.0)
        )
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        clickedImage = inputImage.scaleImage(toHeight: model.cameraViewHeight)
    }
    
    private var navigationBarTrailingButton: some View {
        Group {
            if model.isAllPicturesSubmitted {
                NavigationLink(destination: Text("Work in Progress")) {
                    Text("Proceed")
                }
            } else {
                EmptyView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
