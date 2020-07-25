
import SwiftUI

struct CameraView: View {
    
    @Binding var didTapCapture: Bool
    @Binding var image: UIImage?
    let height: CGFloat
    
    var body: some View {
        CustomCameraRepresentable(image: self.$image,
                                  didTapCapture: $didTapCapture,
                                  height: height)
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView(didTapCapture: .constant(false), image: .constant(UIImage()), height: 123)
    }
}
