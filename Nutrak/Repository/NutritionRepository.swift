//
//  NutritionRepository.swift
//  Nutrak
//
//  Created by Mauricio Lorenzetti on 30/03/25.
//

import Foundation
import SwiftUI
import Combine

protocol NutritionRepositoryProtocol {
    func analyzeFood(image: UIImage) -> AnyPublisher<NutritionResult, Error>
}

class NutritionRepository: NutritionRepositoryProtocol {
    enum RepositoryError: Error, LocalizedError {
        case invalidData
        case networkError
        case jsonDecodeError
        case fileNotFound
        
        var errorDescription: String? {
            switch self {
            case .invalidData: return "Invalid data received"
            case .networkError: return "Network error occurred"
            case .jsonDecodeError: return "Failed to decode JSON data"
            case .fileNotFound: return "JSON file not found"
            }
        }
    }
    
    func analyzeFood(image: UIImage) -> AnyPublisher<NutritionResult, Error> {
        return Future<NutritionResult, Error> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
                guard let fileURL = Bundle.main.url(forResource: "mock_data", withExtension: "json") else {
                    promise(.failure(NSError(domain: "NutritionRepository",
                                             code: 1,
                                             userInfo: [NSLocalizedDescriptionKey: "JSON file not found, using fallback data"])))
                    return
                }
                
                do {
                    let data = try Data(contentsOf: fileURL)
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(NutritionResponse.self, from: data)
                    
                    if response.success, let nutritionData = response.data {
                        promise(.success(nutritionData))
                    } else if let errorMsg = response.error {
                        promise(.failure(NSError(domain: "NutritionRepository",
                                                 code: 1,
                                                 userInfo: [NSLocalizedDescriptionKey: errorMsg])))
                    } else {
                        promise(.failure(RepositoryError.invalidData))
                    }
                } catch {
                    print("Error loading JSON: \(error)")
                    promise(.failure(RepositoryError.jsonDecodeError))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
