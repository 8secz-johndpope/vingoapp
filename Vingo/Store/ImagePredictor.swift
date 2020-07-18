import UIKit

class ImagePredictor {
    private var isRunning: Bool = false
    
    private lazy var module: TorchModule = {
        if let filePath = Bundle.main.path(forResource: "model", ofType: "pt"),
            let module = TorchModule(fileAtPath: filePath) {
            return module
        } else {
            fatalError("Can't find the model file!")
        }
    }()

    private var labels: [String] = {
        if let filePath = Bundle.main.path(forResource: "words", ofType: "txt"),
            let labels = try? String(contentsOfFile: filePath) {
            return labels.components(separatedBy: .newlines)
        } else {
            fatalError("Label file was not found.")
        }
    }()

    func predict(_ buffer: [Float32], resultCount: Int) throws -> ([Float], Double)? {
        if isRunning {
            return nil
        }
        
        isRunning = true
        let startTime = CACurrentMediaTime()
        var tensorBuffer = buffer;
        guard let outputs = module.predict(image: UnsafeMutableRawPointer(&tensorBuffer)) else {
            return nil
        }
        
        isRunning = false
        
        let results = outputs.map { $0.floatValue }
        let inferenceTime = (CACurrentMediaTime() - startTime) * 1000
        return (results, inferenceTime)
    }
}
