//
//  HomeView.swift
//  Nutrak
//
//  Created by Mauricio Lorenzetti on 26/03/25.
//

import SwiftUI

struct HomeView: View {
    @State private var ingredient: Ingredient?
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("This app is a demo, please, start the food scanning flow by tapping the center orange button or tap the Streaks button on the tab bar to see the Streaks screen mock implementation.")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .background(Color.white)
                    .padding(48)
                    .padding(.bottom, 180)
                Spacer()
                Text("id: \(ingredient?.id)\n")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .background(Color.white)
                Text("name: \(ingredient?.name ?? "")\n")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .background(Color.white)
                Text("energy: \(ingredient?.energy ?? 0)\n" )
                    .font(.headline)
                    .foregroundColor(.gray)
                    .background(Color.white)
                Text("protein: \(ingredient?.protein ?? "")\n" )
                    .font(.headline)
                    .foregroundColor(.gray)
                    .background(Color.white)
                Button {
                    fetchIngredients()
                } label: {
                    Text("Fetch ingredients")
                }
                Spacer(minLength: 100)
            }
            .navigationTitle("Home")
        }
    }
    
    private func fetchIngredients(id: String = "22634") {
        let repository: IngredientsRepositoryProtocol = MockIngredientsRepository()
        repository.fetchIngredient(id: id) { result in
            switch result {
            case .success(let ingredient):
                self.ingredient = ingredient
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

//#Preview {
//    HomeView()
//}
