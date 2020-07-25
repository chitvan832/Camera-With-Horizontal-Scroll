
import UIKit

//TODO: Move to Extension
extension UIImage {
    func scaleImage(toHeight newHeight: CGFloat) -> UIImage {
        let newSize = CGSize(width: UIScreen.main.bounds.width,
                             height: newHeight)
        let renderer = UIGraphicsImageRenderer(size: newSize)

        let image = renderer.image { (context) in
            self.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        }
        return image
    }
}
