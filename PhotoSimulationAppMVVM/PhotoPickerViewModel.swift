//
//  PhotoPickerViewModel.swift
//  PhotoSimulationAppMVVM
//
//  Created by user260588 on 10/23/24.
//
import SwiftUI
import Vision

class PhotoPickerViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var extractedData: ExtractedData?

    func extractText(from image: UIImage) {
        guard let cgImage = image.cgImage else {
            extractedData = nil
            return
        }

        let request = VNRecognizeTextRequest { (request, error) in
            if let results = request.results as? [VNRecognizedTextObservation] {
                let text = results.compactMap { observation in
                    observation.topCandidates(1).first?.string
                }.joined(separator: "\n")
                
                DispatchQueue.main.async {
                    self.extractedData = self.parseText(text)
                }
            } else {
                DispatchQueue.main.async {
                    self.extractedData = nil
                }
            }
        }

        request.recognitionLevel = .accurate
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                DispatchQueue.main.async {
                    self.extractedData = nil
                }
            }
        }
    }

    func parseText(_ text: String) -> ExtractedData {
        var name: String?
        var amount: String?
        var date: String?
        var day: String?

        // Regular expressions for name, amount, and date
        let namePattern = "Name: (.+)"
        let dayPattern = "DATE(.+)"
        let amountPattern = "\\$?\\d+(?:,\\d{3})*(?:\\.\\d{2})?"
        let datePattern = "\\b\\d{1,2}/\\d{1,2}/\\d{2,4}\\b"

        // Extracting the name (modify as needed based on your text structure)
        if let nameMatch = text.range(of: namePattern, options: .regularExpression) {
            name = String(text[nameMatch])
                .replacingOccurrences(of: "Name: ", with: "")
                .trimmingCharacters(in: .whitespaces)
        }
        
        if let dateMat = text.range(of: dayPattern, options: .regularExpression) {
            day = String(text[dateMat])
                .replacingOccurrences(of: "DATE", with: "")
                .trimmingCharacters(in: .whitespaces)
        }

        // Extracting the amount
        if let amountMatch = text.range(of: amountPattern, options: .regularExpression) {
            amount = String(text[amountMatch])
                .trimmingCharacters(in: .whitespaces)
        }

        // Extracting the date
        if let dateMatch = text.range(of: datePattern, options: .regularExpression) {
            date = String(text[dateMatch])
                .trimmingCharacters(in: .whitespaces)
        }

        return ExtractedData(name: name, amount: amount, date: day)
    }
    
//    func extractTextResult(from image: UIImage) {
//        guard let cgImage = image.cgImage else { return }
//
//        let request = VNRecognizeTextRequest { request, error in
//            if let results = request.results as? [VNRecognizedTextObservation] {
//                for observation in results {
//                    guard let topCandidate = observation.topCandidates(1).first else { continue }
//                    print("Extracted text: \(topCandidate.string)")
//                }
//            }
//        }
//
//        request.recognitionLevel = .accurate
//
//        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
//        do {
//            try handler.perform([request])
//        } catch {
//            print("Error performing text recognition: \(error)")
//        }
//    }
}

