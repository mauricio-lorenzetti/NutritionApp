//
//  NutritionResult.swift
//  Nutrak
//
//  Created by Mauricio Lorenzetti on 30/03/25.
//

import Foundation
import SwiftUI

struct NutritionResult: Codable {
    let foodName: String
    let calories: Int
    let macronutrients: [Nutrient]
    let micronutrients: [Nutrient]
    let weeklyData: [Double]
    
    let caloriesGoal: Int
    let proteinsGoal: Int
    let carbsGoal: Int
    let fatsGoal: Int
}

struct Nutrient: Codable, Identifiable {
    let id: String
    let name: String
    let value: Int
    
    func toTuple() -> (String, Int) {
        return (name, value)
    }
}
