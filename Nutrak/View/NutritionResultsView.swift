//
//  NutritionResultsView.swift
//  Nutrak
//
//  Created by Mauricio Lorenzetti on 27/03/25.
//

import SwiftUI

enum NutrientsIconMapper: String {
    case proteins = "Proteins"
    case carbs = "Carbs"
    case fats = "Fats"
    case iron = "Iron"
    case calcium = "Calcium"
    case calories = "Calories"
    
    var iconName: String {
        switch self {
        case .proteins: return "fish"
        case .carbs: return "safari"
        case .fats: return "drop"
        case .iron: return "drop.triangle"
        case .calcium: return "20.circle"
        case .calories: return "flame.fill"
        }
    }
    
    var unit: String {
        switch self {
        case .proteins, .carbs, .fats: return "g"
        case .iron, .calcium: return "%"
        case .calories: return "kcal"
        }
    }
    
    var color: Color {
        switch self {
        case .proteins: return Color.proteins
        case .carbs: return Color.carbs
        case .fats: return Color.fats
        case .iron: return Color.primary
        case .calcium: return Color.secondary
        case .calories: return Color.primary
        }
    }
}

import SwiftUI

struct NutritionResultsView: View {
    @ObservedObject var viewModel: NutritionViewModel
    
    var foodImage: UIImage
    var onSaveToLog: () -> Void
    var onUpgradeToPremium: () -> Void
    var onDismiss: () -> Void
    
    init(viewModel: NutritionViewModel = NutritionViewModel(),
         foodImage: UIImage,
         onSaveToLog: @escaping () -> Void,
         onUpgradeToPremium: @escaping () -> Void,
         onDismiss: @escaping () -> Void) {
        self.viewModel = viewModel
        self.foodImage = foodImage
        self.onSaveToLog = onSaveToLog
        self.onUpgradeToPremium = onUpgradeToPremium
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        ZStack {
            if viewModel.loadingState == .loading {
                VStack {
                    Text("Loading results...")
                        .font(.title)
                        .foregroundColor(.gray)
                        .background(Color.white)
                }
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        // Header image and navigation
                        HeaderView(foodImage: foodImage, onBackPressed: onDismiss)
                        
                        // Food category and name
                        FoodTitleView(foodName: viewModel.foodName)
                        
                        // Nutritional Overview
                        NutritionalOverviewView(calories: viewModel.calories)
                        
                        // Macronutrients
                        MacronutrientsView(
                            macronutrients: viewModel.macronutrients,
                            totalMacros: viewModel.totalMacros
                        )
                        
                        // Micronutrients
                        MicronutrientsView(
                            micronutrients: viewModel.micronutrients,
                            totalMicros: viewModel.totalMicros
                        )
                        
                        // Macronutrients Chart
                        MacronutrientChart(
                            calories: viewModel.calories,
                            proteins: viewModel.proteinsValue,
                            carbs: viewModel.carbsValue,
                            fats: viewModel.fatsValue
                        )
                        
                        // Weekly Meal Nutrition
                        WeeklyNutritionView(data: viewModel.weeklyData)
                        
                        // Action Buttons
                        ActionButtonsView(
                            onSaveToLog: onSaveToLog,
                            onUpgradeToPremium: onUpgradeToPremium
                        )
                    }
                }
                .ignoresSafeArea(edges: .top)
                .background(Color.white)
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.5), value: viewModel.loadingState == .success)
            }
        }
        .onAppear {
            if viewModel.loadingState == .idle {
                viewModel.analyzeFood(image: foodImage)
            }
        }
        .alert(isPresented: .constant(viewModel.loadingState == .failure("error"))) {
            Alert(
                title: Text("Error"),
                message: Text("Failed to analyze the food image. Please try again."),
                dismissButton: .default(Text("OK")) {
                    onDismiss()
                }
            )
        }
    }
}

// MARK: - Header View
struct HeaderView: View {
    var foodImage: UIImage
    var onBackPressed: () -> Void
    
    var body: some View {
        ZStack(alignment: .top) {
            Image(uiImage: foodImage)
                .resizable()
                .scaledToFill()
                .frame(height: 240)
                .clipped()
            
            LinearGradient(
                gradient: Gradient(colors: [Color.white.opacity(1),
                                            Color.white.opacity(0)]),
                startPoint: .bottom,
                endPoint: .center
            )
            .frame(height: 240)
            
            VStack {
                HStack {
                    Button(action: onBackPressed) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("Nutrition Results")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Empty space for balance
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.clear)
                }
                .padding(.horizontal)
                .padding(.top, 64)
            }
        }
    }
}

// MARK: - Food Title View
struct FoodTitleView: View {
    var foodName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("FOOD")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.gray)
            
            Text(foodName)
                .font(.title)
                .fontWeight(.bold)
        }
        .padding(.horizontal)
        .padding(.vertical, 16)
    }
}

// MARK: - Macronutrients View
struct NutrientsView: View {
    var nutrients: [(String, Int)]
    var total: Int
    var unit: String
    var title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                if unit.count > 0 {
                    Text("Total: \(total)\(unit)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 12) {
                ForEach(nutrients, id: \.0) { nutrient in
                    NutrientCard(
                        icon: NutrientsIconMapper(rawValue: nutrient.0)?.iconName ?? "questionmark",
                        name: nutrient.0,
                        value: nutrient.1,
                        unit: NutrientsIconMapper(rawValue: nutrient.0)?.unit ?? "?",
                        color: NutrientsIconMapper(rawValue: nutrient.0)?.color ?? Color.primary
                    )
                }
            }
        }
        .padding()
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
}

// MARK: - Macronutrients View
struct MacronutrientsView: View {
    var macronutrients: [(String, Int)]
    var totalMacros: Int
    
    var body: some View {
        NutrientsView(nutrients: macronutrients,
                      total: totalMacros,
                      unit: "g",
                      title: "Macronutrients")
    }
}

// MARK: - Micronutrients View
struct MicronutrientsView: View {
    var micronutrients: [(String, Int)]
    var totalMicros: Int
    
    var body: some View {
        NutrientsView(nutrients: micronutrients,
                      total: totalMicros,
                      unit: "%",
                      title: "Micronutrients")
    }
}

// MARK: - Nutritional Overview View
struct NutritionalOverviewView: View {
    var calories: Int
    
    var body: some View {
        NutrientsView(nutrients: [("Calories", 320)],
                      total: 0,
                      unit: "",
                      title: "Nutritional Overview")
    }
}


// MARK: - Weekly Nutrition View
struct WeeklyNutritionView: View {
    var data: [CGFloat]
    var labels: [String] = ["M", "T", "W", "T", "F", "S", "S"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Weekly Meal Nutrition")
                .font(.headline)
                .fontWeight(.semibold)
            
            WeeklyNutritionChart(data: data, labels: labels)
                .frame(height: 150)
        }
        .padding()
        .background(Color.background)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
}

// MARK: - Action Buttons View
struct ActionButtonsView: View {
    var onSaveToLog: () -> Void
    var onUpgradeToPremium: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Button(action: onSaveToLog) {
                Text("Save to Daily Log")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.primary)
                    .cornerRadius(12)
            }
            
            HStack {
                Text("Want more insights?")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Button(action: onUpgradeToPremium) {
                    Text("Upgrade to Premium")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(Color.primary)
                }
            }
            .padding(.top, 8)
        }
        .padding(.horizontal)
        .padding(.bottom, 100)
    }
}

// MARK: - Micronutrient Card Component
struct NutrientCard: View {
    let icon: String
    let name: String
    let value: Int
    let unit: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(color)
                .frame(width: 48, height: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Text("\(value)\(unit)")
                    .font(.headline)
                    .fontWeight(.medium)
            }
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.cardBackground)
        .cornerRadius(12)
    }
}

// MARK: - Macronutrient Chart Component
struct MacronutrientChart: View {
    // Current values
    let calories: Int
    let proteins: Int
    let carbs: Int
    let fats: Int
    
    // Daily goals (mock data)
    let caloriesGoal = 2000
    let proteinsGoal = 50
    let carbsGoal = 250
    let fatsGoal = 70
    
    // Colors
    let proteinsColor = Color.proteins
    let carbsColor = Color.carbs
    let fatsColor = Color.fats
    let caloriesColor = Color.calories
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .center, spacing: 0) {
                // Donut chart for macronutrients
                ZStack {
                    // Carbs progress (outermost)
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 12)
                        .frame(width: 180, height: 180)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(min(carbs, carbsGoal)) / CGFloat(carbsGoal))
                        .stroke(
                            carbsColor,
                            style: StrokeStyle(
                                lineWidth: 12,
                                lineCap: .round,
                                lineJoin: .round
                            )
                        )
                        .frame(width: 180, height: 180)
                        .rotationEffect(.degrees(-90))
                    
                    // Protein progress (middle)
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 12)
                        .frame(width: 144, height: 144)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(min(proteins, proteinsGoal)) / CGFloat(proteinsGoal))
                        .stroke(
                            proteinsColor,
                            style: StrokeStyle(
                                lineWidth: 12,
                                lineCap: .round,
                                lineJoin: .round
                            )
                        )
                        .frame(width: 144, height: 144)
                        .rotationEffect(.degrees(-90))
                    
                    // Fat progress (innermost)
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 12)
                        .frame(width: 108, height: 108)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(min(fats, fatsGoal)) / CGFloat(fatsGoal))
                        .stroke(
                            fatsColor,
                            style: StrokeStyle(
                                lineWidth: 12,
                                lineCap: .round,
                                lineJoin: .round
                            )
                        )
                        .frame(width: 108, height: 108)
                        .rotationEffect(.degrees(-90))
                    
                    // Center content
                    VStack(spacing: 2) {
                        Text("Remaining")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text("\(caloriesGoal - calories)")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("kcal")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(width: 80)
                    .multilineTextAlignment(.center)
                }
                .frame(width: 180, height: 180)
                .padding(.trailing, 16)
                
                // Legend with consumed/goal values
                VStack(alignment: .leading, spacing: 16) {
                    //Calories
                    Text("Calories consumed")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Text("\(calories) kcal")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    // Carbs
                    MacronutrientLegendItem(
                        name: "Carbs",
                        consumed: carbs,
                        goal: carbsGoal,
                        unit: "g",
                        color: carbsColor
                    )
                    
                    // Proteins
                    MacronutrientLegendItem(
                        name: "Proteins",
                        consumed: proteins,
                        goal: proteinsGoal,
                        unit: "g",
                        color: proteinsColor
                    )
                    
                    // Fats
                    MacronutrientLegendItem(
                        name: "Fats",
                        consumed: fats,
                        goal: fatsGoal,
                        unit: "g",
                        color: fatsColor
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)
            
            // Calories progress bar
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Daily Calories")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Text("\(calories)/\(caloriesGoal) kcal")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 12)
                    
                    // Progress
                    RoundedRectangle(cornerRadius: 6)
                        .fill(caloriesColor)
                        .frame(width: calculateProgressBarWidth(consumed: calories, goal: caloriesGoal), height: 12)
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
    
    private func calculateProgressBarWidth(consumed: Int, goal: Int) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width - 64 // Accounting for padding
        let progress = CGFloat(min(consumed, goal)) / CGFloat(goal)
        return progress * screenWidth
    }
}

// MARK: - Macronutrient Legend Item
struct MacronutrientLegendItem: View {
    let name: String
    let consumed: Int
    let goal: Int
    let unit: String
    let color: Color
    
    var body: some View {
        HStack {
            // Color indicator and name on left
            HStack(spacing: 8) {
                Circle()
                    .fill(color)
                    .frame(width: 10, height: 10)
                
                Text(name)
                    .font(.subheadline)
            }
            
            Spacer()
            
            // Consumed/Goal values on right
            Text("\(consumed)/\(goal)\(unit)")
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
}

// MARK: - Weekly Nutrition Chart Component
struct WeeklyNutritionChart: View {
    let data: [CGFloat]
    let labels: [String]
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ForEach(0..<data.count, id: \.self) { index in
                VStack(spacing: 4) {
                    // Bar with gradient
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.accent, Color.primary]),
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )
                        .frame(width: 20, height: 100 * data[index])
                        .cornerRadius(10)
                    
                    // Day label
                    Text(labels[index])
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 20)
    }
}

// MARK: - Preview
#Preview {
    let viewModel = NutritionViewModel()
    return NutritionResultsView(
        viewModel: viewModel,
        foodImage: UIImage(named: "pizza_placeholder") ?? UIImage(),
        onSaveToLog: {},
        onUpgradeToPremium: {},
        onDismiss: {}
    )
}
