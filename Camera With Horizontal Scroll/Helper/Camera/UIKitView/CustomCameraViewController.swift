
import AVFoundation
import UIKit

class CustomCameraViewController: UIViewController {
    
    private var captureSession = AVCaptureSession()
    private var frontCamera: AVCaptureDevice?
    private var currentCamera: AVCaptureDevice?
    private var photoOutput: AVCapturePhotoOutput?
    
    var height: CGFloat?
    
    weak var delegate: AVCapturePhotoCaptureDelegate?
    
    init(height: CGFloat) {
        super.init(nibName: nil, bundle: nil)
        self.height = height
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
    }
    
    private func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    private func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera],
                                                                      mediaType: AVMediaType.video,
                                                                      position: AVCaptureDevice.Position.front)
        self.currentCamera = deviceDiscoverySession.devices.first(where: { $0.position == .front })
    }
    
    
    private func setupInputOutput() {
        guard let _currentCamera = currentCamera else {
            return
        }
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: _currentCamera)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        } catch {
            //TODO: Handler error
            print(error)
        }
        
    }
    
    private func setupPreviewLayer() {
        let cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer.videoGravity = AVLayerVideoGravity.resize
        cameraPreviewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer.frame = CGRect(x: 0,
                                          y: 0,
                                          width: view.frame.width,
                                          height: (height ?? 0) / 2)
        view.layer.insertSublayer(cameraPreviewLayer, at: 0)
    }
    
    private func startRunningCaptureSession(){
        #if targetEnvironment(simulator)
        #else
        captureSession.startRunning()
        #endif
    }
    
    func didTapCapture() {
        let settings = AVCapturePhotoSettings()
        if let _delegate = delegate {
            photoOutput?.capturePhoto(with: settings, delegate: _delegate)
        }
    }
}
