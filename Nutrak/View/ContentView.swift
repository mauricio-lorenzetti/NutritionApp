//
//  ContentView.swift
//  Nutrak
//
//  Created by Mauricio Lorenzetti on 26/03/25.
//

import AVFoundation
import SwiftUI

struct ContentView: View {
    @StateObject private var nutritionViewModel = NutritionViewModel()
    
    @State private var selectedTab: TabItem = .home
    @State private var showCamera = false
    @State private var showPermissionAlert = false
    @State private var scannedImage: UIImage? = nil
    @State private var isAnalyzing = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ZStack {
                    switch selectedTab {
                    case .home:
                        HomeView()
                            .transition(.opacity)
                    case .logs:
                        PlaceholderView(tabItem: selectedTab)
                            .transition(.opacity)
                    case .scan:
                        if let image = scannedImage {
                            NutritionResultsView(
                                viewModel: nutritionViewModel,
                                foodImage: image,
                                onSaveToLog: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        selectedTab = .streaks
                                    }
                                },
                                onUpgradeToPremium: {
                                    print("Upgrading to premium")
                                },
                                onDismiss: {
                                    scannedImage = nil
                                    nutritionViewModel.loadingState = .idle
                                    selectedTab = .home
                                }
                            )
                            .transition(.opacity.combined(with: .scale(scale: 0.95)))
                            .animation(.easeInOut(duration: 0.5), value: scannedImage != nil)
                        } else {
                            Color.clear
                        }
                    case .streaks:
                        StreaksView(selectedTab: $selectedTab)
                            .transition(.opacity)
                    case .profile:
                        PlaceholderView(tabItem: selectedTab)
                            .transition(.opacity)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Divider()
                
                CustomTabBar(
                    selectedTab: $selectedTab,
                    onScanButtonTapped: {
                        checkCameraPermissions()
                    }
                )
                .background(Color.white)
            }
            .edgesIgnoringSafeArea(.bottom)
            
            if showPermissionAlert {
                PermissionAlertView(
                    onAllow: {
                        showPermissionAlert = false
                        showCamera = true
                    },
                    onDeny: {
                        showPermissionAlert = false
                        if selectedTab == .scan && scannedImage == nil {
                            selectedTab = .home
                        }
                    }
                )
                .transition(.opacity)
                .zIndex(2)
            }
        }
        .onChange(of: selectedTab) { newTab in
            if newTab == .scan {
                checkCameraPermissions()
            }
        }
        .fullScreenCover(isPresented: $showCamera, onDismiss: {
            if selectedTab == .scan && scannedImage == nil {
                withAnimation(.easeInOut(duration: 0.3)) {
                    selectedTab = .home
                }
            } else if scannedImage != nil {
                withAnimation(.easeInOut(duration: 0.5)) {
                    selectedTab = .scan
                }
            }
        }) {
            CameraView(onImageCaptured: { image in
                if image.size.width > 0 {
                    scannedImage = image
                    isAnalyzing = true
                }
            })
        }
        .overlay {
            if isAnalyzing, let image = scannedImage {
                ScanningProgressView(
                    viewModel: nutritionViewModel,
                    image: image,
                    onAnalysisComplete: {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isAnalyzing = false
                            selectedTab = .scan
                        }
                    }
                )
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.5), value: isAnalyzing)
                .zIndex(3)
            }
        }
    }
    
    private func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            showCamera = true
        case .notDetermined:
            showPermissionAlert = true
        case .denied, .restricted:
            showPermissionAlert = true
        @unknown default:
            break
        }
    }
}

#Preview {
    ContentView()
}
