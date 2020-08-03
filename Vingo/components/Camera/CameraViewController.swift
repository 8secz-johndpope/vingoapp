import AVFoundation
import UIKit
import SwiftUI

final class CameraViewController: UIViewController {
    public var onFrame: (_ buffer: [Float]) -> Void = {_ in}
    private var cameraController = CameraController()
    private let delayMs: Double = 500
    private var prevTimestampMs: Double = 0.0
    var previewView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        previewView = UIView(frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        previewView.contentMode = UIView.ContentMode.scaleAspectFit
        view.addSubview(previewView)
        
        cameraController.displayPreview(on: previewView)
        cameraController.videoCaptureCompletionBlock = { [weak self] buffer, error in
            guard let strongSelf = self else { return }
            if error != nil {
                return
            }
            guard let pixelBuffer = buffer else { return }
            let currentTimestamp = CACurrentMediaTime()
            
            // Do predict 2fps
            if (currentTimestamp - strongSelf.prevTimestampMs) * 1000 <= strongSelf.delayMs { return }
            strongSelf.prevTimestampMs = currentTimestamp
                        
            strongSelf.onFrame(pixelBuffer)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        cameraController.startSession()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cameraController.stopSession()
    }
}


struct CameraView: UIViewControllerRepresentable {
    public typealias UIViewControllerType = CameraViewController
    public var onFrame: (_ buffer: [Float]) -> Void

    public func makeUIViewController(context: UIViewControllerRepresentableContext<CameraView>) -> CameraViewController {
        let controller = CameraViewController()
        controller.onFrame = self.onFrame
        return controller
    }
    
    public func updateUIViewController(_ uiViewController: CameraViewController, context: UIViewControllerRepresentableContext<CameraView>) {
    }
}
