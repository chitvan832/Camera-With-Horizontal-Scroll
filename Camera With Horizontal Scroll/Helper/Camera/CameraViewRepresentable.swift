
import AVFoundation
import SwiftUI
import UIKit

struct CustomCameraRepresentable: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = CustomCameraViewController
    
    @Binding var image: UIImage?
    @Binding var didTapCapture: Bool
    let height: CGFloat
    
    func makeUIViewController(context: Context) -> CustomCameraViewController {
        let controller = CustomCameraViewController(height: height)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: CustomCameraViewController, context: Context) {
        if didTapCapture {
            uiViewController.didTapCapture()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

extension CustomCameraRepresentable {
    
    class Coordinator: NSObject, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate {
        
        private let parent: CustomCameraRepresentable
        
        init(_ parent: CustomCameraRepresentable) {
            self.parent = parent
        }
        
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            
            parent.didTapCapture = false
            
            if let imageData = photo.fileDataRepresentation(),
                let capturedImage = UIImage(data: imageData),
                let cgImage = capturedImage.cgImage {
                let flippedImage = UIImage(cgImage: cgImage,
                                           scale: capturedImage.scale,
                                           orientation: .leftMirrored)
                let cropImage = flippedImage.scaleImage(toHeight: parent.height/2)
                parent.image = cropImage
            }
        }
    }
}
