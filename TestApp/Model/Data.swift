import UIKit

struct Data {
    let image: UIImage?
    let title: String
    var imageV: UIImageView { return UIImageView(image: image) }
}
