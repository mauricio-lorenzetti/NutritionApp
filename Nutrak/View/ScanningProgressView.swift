//
//  ScanningProgressView.swift
//  Nutrak
//
//  Created by Mauricio Lorenzetti on 26/03/25.
//

import SwiftUI
import Combine

struct ScanningProgressView: View {
    @ObservedObject var viewModel: NutritionViewModel
    @State private var progress: Double = 0
    @State private var rotation: Double = 0
    var image: UIImage
    var onAnalysisComplete: () -> Void
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 25) {
                // Logo
                Text("nutrak")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.primary)
                
                // Progress indicator
                ZStack {
                    // Dashed circle with 36 dashes
                    Circle()
                        .trim(from: 0, to: 1)
                        .stroke(
                            style: StrokeStyle(
                                lineWidth: 4,
                                lineCap: .round,
                                lineJoin: .round,
                                dash: [2, 6],
                                dashPhase: 0
                            )
                        )
                        .foregroundColor(Color.disabled)
                        .frame(width: 120, height: 120)
                    
                    // Progress indicator with 36 dashes
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            style: StrokeStyle(
                                lineWidth: 4,
                                lineCap: .round,
                                lineJoin: .round,
                                dash: [2, 6],
                                dashPhase: 0
                            )
                        )
                        .foregroundColor(Color.accentColor)
                        .frame(width: 120, height: 120)
                        .rotationEffect(Angle(degrees: -90))
                }
                .rotationEffect(Angle(degrees: rotation))
                .onAppear {
                    withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                        rotation = 360
                    }
                }
                
                // Status text
                Text("Analyzing your food...")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .frame(width: geometry.size.width, height: 4)
                            .opacity(0.3)
                            .foregroundColor(Color.disabled)
                        
                        Rectangle()
                            .frame(width: geometry.size.width * progress, height: 4)
                            .foregroundColor(Color.accentColor)
                    }
                }
                .frame(height: 4)
                .padding(.horizontal, 40)
                
                // Percentage
                Text("\(Int(progress * 100))%")
                    .font(.headline)
                    .foregroundColor(.black)
            }
            .padding()
        }
        .onAppear {
            startAnalysis()
        }
    }
    
    private func startAnalysis() {
        progress = 0
        let progressTimer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
        
        var progressSubscription: AnyCancellable?
        progressSubscription = progressTimer.sink { _ in
            if progress < 0.98 {
                progress += 0.01
            } else if progress >= 0.98 {
                progressSubscription?.cancel()
                if viewModel.loadingState == .success {
                    onAnalysisComplete()
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        onAnalysisComplete()
                    }
                }
            }
        }
        
        viewModel.analyzeFood(image: image)
    }
}
