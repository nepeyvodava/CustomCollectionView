import AVFoundation
import UIKit

class PreviewCameraV: UIView {
    
    convenience init(_ gravity: AVLayerVideoGravity) {
        self.init()
        videoPreviewLayer.videoGravity = gravity
    }

    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }

}
