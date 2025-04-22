//
//  IngredientsRepository.swift
//  Nutrak
//
//  Created by Mauricio Lorenzetti on 09/04/25.
//

import Foundation

protocol IngredientsRepositoryProtocol {
    func fetchIngredient(id: String, completion: @escaping (Result<Ingredient, Error>) -> Void)
}

class MockIngredientsRepository: IngredientsRepositoryProtocol {
    func fetchIngredient(id: String, completion: @escaping (Result<Ingredient, Error>) -> Void) {
        completion(.success(Ingredient(id: 1000, name: "Mock Hot Dog New York", energy: -1, protein: "-1.000")))
    }
}


class IngredientsRepository: IngredientsRepositoryProtocol {
    func fetchIngredient(id: String, completion: @escaping (Result<Ingredient, Error>) -> Void) {
        guard let url = URL(string: "https://wger.de/api/v2/ingredientinfo/\(id)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(Ingredient.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

struct Ingredient: Codable {
    let id: Int
    let name: String?
    let energy: Int?
    let protein: String?
}

struct IngredientResponse: Codable {
    let results: [Ingredient]
}
