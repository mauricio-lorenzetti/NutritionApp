//
//  NutritionResponse.swift
//  Nutrak
//
//  Created by Mauricio Lorenzetti on 30/03/25.
//


struct NutritionResponse: Codable {
    let success: Bool
    let data: NutritionResult?
    let error: String?
}
