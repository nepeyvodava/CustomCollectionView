import AVFoundation
import UIKit

class PreviewCollectionViewCell: CustomCollectionViewCell {
    
    static let reuseID = String(describing: PreviewCollectionViewCell.self)
    
    let captureSession = AVCaptureSession()
    let previewV: PreviewCameraV = {
        let v = PreviewCameraV(.resizeAspectFill)
        return v
    }()
    
    func configure() {
        containerView = previewV
        initialSetup()
        setupViews()
    }
    
    deinit {
        captureSession.stopRunning()
    }
    
}


private extension PreviewCollectionViewCell {
    
    func initialSetup() {
        self.captureSession.beginConfiguration()
        
        guard let videoDevice = captureVideoDevice() else { return }
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
            self.captureSession.canAddInput(videoDeviceInput)
            else { return }
        self.captureSession.addInput(videoDeviceInput)
        
        self.captureSession.commitConfiguration()
        
        self.previewV.videoPreviewLayer.session = self.captureSession
        self.captureSession.startRunning()
    }
    
    func captureVideoDevice() -> AVCaptureDevice? {
        if let device = AVCaptureDevice.default(.builtInDualCamera,
                                                for: .video, position: .back) {
            return device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                       for: .video, position: .back) {
            return device
        } else {
            print("Error: device not found!")
            return nil
        }
    }
    
}
