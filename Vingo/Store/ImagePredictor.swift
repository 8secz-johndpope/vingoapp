import UIKit
import BinarySwift

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

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
    
    private var vectors: [[Double]] = {
        if let filePath = Bundle.main.path(forResource: "vectors", ofType: "bin"), let nsData = try? NSData(contentsOfFile: filePath) {
            let data = BinaryData(data: nsData as Data, bigEndian: false)
            let reader = BinaryDataReader(data)
        
            var arr: [Double] = []
            while let v: Float32 = try? reader.read() {
                arr.append(Double(v))
            }
            
            print(arr.count)
            
            return arr.chunked(into: 1280)
        } else {
            fatalError("Label file was not found.")
        }
    }()
    
    private var labels: [Int] = {
        if let filePath = Bundle.main.path(forResource: "indx2id", ofType: "bin"), let nsData = try? NSData(contentsOfFile: filePath) {
            let data = BinaryData(data: nsData as Data, bigEndian: false)
            let reader = BinaryDataReader(data)
        
            var arr: [Int32] = []
            while let v: Int32 = try? reader.read() {
                arr.append(v)
            }
            
            return arr.map { Int($0) }
        } else {
            fatalError("Label file was not found.")
        }
    }()
    
    private var knn: KNearestNeighborsClassifier
    init() {
        self.knn = KNearestNeighborsClassifier(data: self.vectors, labels: self.labels)
    }

    func predict(_ buffer: [Float]) throws -> Int? {
        if isRunning {
            return nil
        }
        
        isRunning = true
        var startTime = CACurrentMediaTime()

        var tensorBuffer = buffer;
        guard let outputs = module.predict(image: UnsafeMutableRawPointer(&tensorBuffer)) else {
            return nil
        }
        let results = outputs.map { $0.doubleValue }
        
//        var inferenceTime = (CACurrentMediaTime() - startTime) * 1000
//        print(("PREDICT", inferenceTime))

        let ids = self.knn.predict([results])
        isRunning = false
        
//        inferenceTime = (CACurrentMediaTime() - startTime) * 1000
//        print(("KNN", inferenceTime))

        return ids[0]
    }
}
