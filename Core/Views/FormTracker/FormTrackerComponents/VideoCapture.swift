import Foundation
import AVFoundation

class VideoCapture: NSObject {
    let captureSession = AVCaptureSession() // Capture session for managing video input and output
    let videoOutput = AVCaptureVideoDataOutput() // Video data output for capturing video frames
    let predictor = Predictor() // Instance of Predictor for performing pose estimation

    override init() {
        super.init()
        
        // Initialize AVCaptureDeviceInput with default video capture device
        guard let captureDevice = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: captureDevice) else {
            // Handle failure to initialize AVCaptureDeviceInput
            print("Failed to initialize AVCaptureDeviceInput")
            return
        }

        // Add input to capture session if possible
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        } else {
            print("Failed to add input to capture session")
        }

        // Add video output to capture session if possible
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        } else {
            print("Failed to add output to capture session")
        }

        // Set videoOutput delegate to self and configure settings
        videoOutput.alwaysDiscardsLateVideoFrames = true
    }
    
    // Start the video capture session on a background queue
    func startCaptureSession() {
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning() // Start running the capture session
        }
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoDispatchQueue"))
        // Set the sample buffer delegate to receive video frames and specify dispatch queue
    }
}

extension VideoCapture: AVCaptureVideoDataOutputSampleBufferDelegate {
    // Method called when a new video frame is captured
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        predictor.estimation(sampleBuffer: sampleBuffer)
        // Pass the captured sample buffer to the predictor for pose estimation
    }
}

