import Foundation
import UIKit
import AVFoundation
import AudioToolbox

class ViewController: UIViewController {
    let videoCapture = VideoCapture() // VideoCapture instance to manage video capture
    var previewLayer: AVCaptureVideoPreviewLayer? // Preview layer for displaying captured video
    
    var pointLayer = CAShapeLayer() // Layer for displaying recognized points
    
    var squatDetected = false // Flag to track if a good squat is detected
    var noneDetected = false // Flag to track if no specific action is detected
    var badSquatDetected = false // Flag to track if a bad squat is detected
    var isAlertPresenting = false // Flag to track if an alert is currently being presented
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVideoPreview() // Set up video preview layer
        
        // Set the delegate of Predictor to self to receive callbacks
        videoCapture.predictor.delegate = self
    }
    
    // Starts the video capture session and sets up the preview layer
    private func setupVideoPreview() {
        videoCapture.startCaptureSession() // Start video capture session
        previewLayer = AVCaptureVideoPreviewLayer(session: videoCapture.captureSession) // Create preview layer
        
        guard let previewLayer = previewLayer else { return }
        
        view.layer.addSublayer(previewLayer) // Add preview layer to the view's layer
        previewLayer.frame = view.frame // Set preview layer's frame to match view's frame
        
        view.layer.addSublayer(pointLayer) // Add point layer to the view's layer for recognized points
        pointLayer.frame = view.frame // Set point layer's frame to match view's frame
        pointLayer.strokeColor = UIColor.blue.cgColor // Set stroke color for recognized points
    }
}

extension ViewController: PredictorDelegate {
    // Callback function for action labeling from the Predictor
    func predictor(_ predictor: Predictor, didLabelAction action: String, with confidence: Double) {
        print("Action: \(action), Confidence: \(confidence)")
        
        // Handle prediction results from the Predictor
        if action == "GoodForm" && confidence > 0.80 && !squatDetected {
            squatDetected = true
            // Reset squatDetected flag after 2.2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                self.squatDetected = false
            }
            // Show alert for good squat form and play an alert sound
            DispatchQueue.main.async {
                self.showGoodFormAlert(with: confidence)
                AudioServicesPlayAlertSound(SystemSoundID(1322))
            }
        }
    }
    
    // Show an alert for good squat form with given confidence level
    func showGoodFormAlert(with confidence: Double) {
        let alertController = UIAlertController(title: "Good Form", message: "Your squat form is good with \(Int(confidence * 100))% confidence!", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            // Reset isAlertPresenting flag when the alert is dismissed
            self.isAlertPresenting = false
        })
        // Set isAlertPresenting flag and present the alert
        isAlertPresenting = true
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Show an alert for no specific action detected
    func nothing() {
        let alertController = UIAlertController(title: "None", message: "No specific action detected.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            // Reset isAlertPresenting flag when the alert is dismissed
            self.isAlertPresenting = false
        })
        // Set isAlertPresenting flag and present the alert
        isAlertPresenting = true
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Show an alert for bad squat form detected
    func badSquat() {
        let alertController = UIAlertController(title: "Bad Form", message: "Your squat form needs improvement.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            // Reset isAlertPresenting flag when the alert is dismissed
            self.isAlertPresenting = false
        })
        // Set isAlertPresenting flag and present the alert
        isAlertPresenting = true
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Process and display newly recognized points on the UI
    func predictor(_ predictor: Predictor, didFindNewRecognizedPoints points: [CGPoint]) {
        guard let previewLayer = previewLayer else { return }
        
        // Convert recognized points to coordinates relative to the preview layer
        let convertedPoints = points.map {
            previewLayer.layerPointConverted(fromCaptureDevicePoint: $0)
        }
        
        // Create a path for displaying recognized points
        let combinedPath = CGMutablePath()
        for point in convertedPoints {
            let dotPath = UIBezierPath(ovalIn: CGRect(x: point.x, y: point.y, width: 5, height: 5))
            combinedPath.addPath(dotPath.cgPath)
        }
        
        // Update the point layer with the combined path of recognized points
        pointLayer.path = combinedPath
        
        // Notify the main thread to update the point layer's path
        DispatchQueue.main.async {
            self.pointLayer.didChangeValue(for: \.path)
        }
    }
}

