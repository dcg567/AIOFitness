import Foundation
import Vision

// Typealias for the squat classifier model.
typealias SquatClassifier = TheOne

// Protocol defining the delegate methods for Predictor events.
protocol PredictorDelegate: AnyObject {
    // Notifies the delegate when new recognised points are found.
    func predictor(_ predictor: Predictor, didFindNewRecognizedPoints points: [CGPoint])
    // Notifies the delegate when an action is labeled with confidence.
    func predictor(_ predictor: Predictor, didLabelAction action: String, with confidence: Double)
}

// Class responsible for performing pose estimation and action labeling.
class Predictor {
    weak var delegate: PredictorDelegate? // Delegate to handle predictor events.
    let predictionWindowSize = 30 // Size of the window for storing body pose observations.
    var posesWindow: [VNHumanBodyPoseObservation] = [] // Window to store recent pose observations.
    let observationsNeeded = 180 // Number of observations needed for action labeling (adjust based on performance).

    // Initialize the Predictor instance.
    init() {
        posesWindow.reserveCapacity(predictionWindowSize) // Preallocate memory for pose window.
    }

    // Perform pose estimation using the provided sample buffer.
    func estimation(sampleBuffer: CMSampleBuffer) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            // Capture a weak reference to self to prevent retain cycles.
            guard let self = self else { return }

            // Create a request handler for body pose detection.
            let requestHandler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .up)
            let request = VNDetectHumanBodyPoseRequest(completionHandler: self.bodyPoseHandler)

            do {
                // Perform the body pose detection request.
                try requestHandler.perform([request])
            } catch {
                print("Unable to perform the request, error: \(error)")
            }
        }
    }

    // Handle the body pose detection request.
    func bodyPoseHandler(request: VNRequest, error: Error?) {
        // Retrieve body pose observations from the request results.
        guard let observations = request.results as? [VNHumanBodyPoseObservation] else { return }

        // Process each body pose observation.
        observations.forEach { processObservation($0) }

        // Store the latest observation and label the action type.
        if let result = observations.first {
            storeObservation(result)
            labelActionType()
        }
    }

    // Label the action type based on the observed poses.
    func labelActionType() {
        // Initialize the squat classifier model with the provided MLModelConfiguration.
        guard let squatClassifier = try? SquatClassifier(configuration: MLModelConfiguration()),
              let poseMultiArray = prepareInputWithObservations(posesWindow),
              let predictions = try? squatClassifier.prediction(poses: poseMultiArray) else {
            // If necessary components are unavailable, return early.
            return
        }

        // Retrieve the predicted action label and confidence.
        let label = predictions.label
        let confidence = predictions.labelProbabilities[label] ?? 0

        // Notify the delegate about the labeled action and confidence on the main thread.
        DispatchQueue.main.async {
            self.delegate?.predictor(self, didLabelAction: label, with: confidence)
        }
    }

    // Prepare input data with body pose observations for the squat classifier model.
    func prepareInputWithObservations(_ observations: [VNHumanBodyPoseObservation]) -> MLMultiArray? {
        let numAvailableFrames = observations.count
        var multiArrayBuffer = [MLMultiArray]()

        // Iterate over available frames and create multi-arrays from pose observations.
        for frameIndex in 0 ..< min(numAvailableFrames, observationsNeeded) {
            let pose = observations[frameIndex]
            do {
                // Extract keypoints multi-array from each pose observation.
                let oneFrameMultiArray = try pose.keypointsMultiArray()
                multiArrayBuffer.append(oneFrameMultiArray)
            } catch {
                continue
            }
        }

        // If observations are less than needed, pad with dummy data.
        if numAvailableFrames < observationsNeeded {
            for _ in 0 ..< (observationsNeeded - numAvailableFrames) {
                do {
                    // Create dummy MLMultiArray to pad the input.
                    let oneFrameMultiArray = try MLMultiArray(shape: [1, 3, 18], dataType: .double)
                    try resetMultiArray(oneFrameMultiArray) // Reset the multi-array with default values.
                    multiArrayBuffer.append(oneFrameMultiArray)
                } catch {
                    continue
                }
            }
        }

        // Concatenate multi-arrays in the buffer along the specified axis to create input data.
        return MLMultiArray(concatenating: [MLMultiArray](multiArrayBuffer), axis: 0, dataType: .float)
    }

    // Reset MLMultiArray values to a specified default value.
    func resetMultiArray(_ predictionWindow: MLMultiArray, with value: Double = 0.0) throws {
        let pointer = try UnsafeMutableBufferPointer<Double>(predictionWindow)
        pointer.initialize(repeating: value)
    }

    // Store the observed body pose observation in the poses window.
    func storeObservation(_ observation: VNHumanBodyPoseObservation) {
        // Maintain a fixed-size window of recent pose observations.
        if posesWindow.count >= predictionWindowSize {
            posesWindow.removeFirst() // Remove the oldest observation if the window is full.
        }
        posesWindow.append(observation) // Add the latest observation to the window.
    }

    // Process the observed body pose observation and extract recognized points.
    func processObservation(_ observation: VNHumanBodyPoseObservation) {
        do {
            // Extract recognized body keypoints from the observation.
            let recognisedPoints = try observation.recognizedPoints(forGroupKey: .all)
            
            // Convert recognized points to display-friendly coordinates.
            let displayedPoints = recognisedPoints.map { CGPoint(x: $0.value.x, y: 1 - $0.value.y) }
            
            // Notify the delegate about the newly extracted recognized points.
            delegate?.predictor(self, didFindNewRecognizedPoints: displayedPoints)
        } catch {
            // Handle any errors encountered during the extraction process.
            print("Error finding recognisedPoints: \(error)")
        }
    }
}

//uses the Vision framework and machine learning models (SquatClassifier) to perform body pose estimation and action labeling.
//The class employs a delegate (PredictorDelegate) to notify external objects about events like finding new recognized points during pose estimation and labeling detected actions with confidence scores. The Predictor class handles processing of body pose observations, maintains a window of recent observations (posesWindow), and prepares input data for the squat classifier model.
