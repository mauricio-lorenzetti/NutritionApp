//
//  HomeView.swift
//  Nutrak
//
//  Created by Mauricio Lorenzetti on 26/03/25.
//

import SwiftUI

struct HomeView: View {
    
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
            }
            .navigationTitle("Home")
        }
    }
}

#Preview {
    HomeView()
}
