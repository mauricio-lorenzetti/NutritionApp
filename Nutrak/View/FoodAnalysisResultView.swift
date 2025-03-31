//
//  FoodAnalysisResultView.swift
//  Nutrak
//
//  Created by Mauricio Lorenzetti on 27/03/25.
//

import SwiftUI

struct FoodAnalysisResultView: View {
    let image: UIImage
    
    var body: some View {
        VStack {
            Text("Food Analysis Results")
                .font(.title)
                .padding()
            
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .cornerRadius(12)
                .padding()
            
            Spacer()
            
            Button("Done") {
                
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
    }
}
