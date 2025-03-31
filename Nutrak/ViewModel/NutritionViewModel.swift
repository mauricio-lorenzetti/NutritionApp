//
//  NutritionViewModel.swift
//  Nutrak
//
//  Created by Mauricio Lorenzetti on 30/03/25.
//

import Foundation
import SwiftUI
import Combine

// MARK: - Loading State Enum
enum LoadingState: Equatable {
    case idle
    case loading
    case success
    case failure(String)
    
    static func == (lhs: LoadingState, rhs: LoadingState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading), (.success, .success):
            return true
        case (.failure(let lhsMessage), .failure(let rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}

// MARK: - ViewModel
class NutritionViewModel: ObservableObject {
    private let repository: NutritionRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    @Published var loadingState: LoadingState = .idle
    @Published var nutritionResult: NutritionResult?
    @Published var scanProgress: Double = 0.0
    
    var foodName: String {
        nutritionResult?.foodName ?? "Unknown Food"
    }
    
    var calories: Int {
        nutritionResult?.calories ?? 0
    }
    
    var macronutrients: [(String, Int)] {
        nutritionResult?.macronutrients.map { $0.toTuple() } ?? []
    }
    
    var micronutrients: [(String, Int)] {
        nutritionResult?.micronutrients.map { $0.toTuple() } ?? []
    }
    
    var totalMacros: Int {
        macronutrients.reduce(0) { $0 + $1.1 }
    }
    
    var totalMicros: Int {
        micronutrients.reduce(0) { $0 + $1.1 }
    }
    
    var weeklyData: [CGFloat] {
        nutritionResult?.weeklyData.map { CGFloat($0) } ?? []
    }
    
    var proteinsValue: Int {
        nutritionResult?.macronutrients.first(where: { $0.name == "Proteins" })?.value ?? 0
    }
    
    var carbsValue: Int {
        nutritionResult?.macronutrients.first(where: { $0.name == "Carbs" })?.value ?? 0
    }
    
    var fatsValue: Int {
        nutritionResult?.macronutrients.first(where: { $0.name == "Fats" })?.value ?? 0
    }
    
    var caloriesGoal: Int {
        nutritionResult?.caloriesGoal ?? 2000
    }
    
    var proteinsGoal: Int {
        nutritionResult?.proteinsGoal ?? 50
    }
    
    var carbsGoal: Int {
        nutritionResult?.carbsGoal ?? 250
    }
    
    var fatsGoal: Int {
        nutritionResult?.fatsGoal ?? 70
    }
    
    init(repository: NutritionRepositoryProtocol = NutritionRepository()) {
        self.repository = repository
    }
    
    func analyzeFood(image: UIImage) {
        loadingState = .loading
        
        repository.analyzeFood(image: image)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.loadingState = .failure(error.localizedDescription)
                    }
                },
                receiveValue: { [weak self] result in
                    self?.nutritionResult = result
                    self?.loadingState = .success
                }
            )
            .store(in: &cancellables)
    }
}
